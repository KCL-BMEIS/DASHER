
Param(
  [parameter(mandatory=$true)][string]$file,
  [string]$test

)

Get-Content "$file" | ForEach-Object -Begin {$settings=@{}} -Process {$store = [regex]::split($_,'='); if(($store[0].CompareTo("") -ne 0) -and ($store[0].StartsWith("[") -ne $True) -and ($store[0].StartsWith("#") -ne $True)) {$settings.Add($store[0], $store[1])}}


# Reading parameters file
$xnat_name = "uploader"
$psql_user="xnat"

$xnat_host = $settings.Get_Item("xnat_host")
$psql_pwd = $settings.Get_Item("psql_pwd")
$ssl = $settings.Get_Item("ssl")
$ssl_key = $settings.Get_Item("ssl_key_file")
$ssl_crt = $settings.Get_Item("ssl_crt_file")
$ssl_trust = $settings.Get_Item("ssl_trust_file")
$ssl_pem = $settings.Get_Item("ssl_dhparem_file")
$hospital_code = $settings.Get_Item("hospital_code")
$xnat_user = $settings.Get_Item("xnat_user")
$xnat_pwd = $settings.Get_Item("xnat_pwd")
$xnat_admin_user = $settings.Get_Item("xnat_admin_user")
$xnat_admin_email = $settings.Get_Item("xnat_admin_email")
$xnat_admin_pwd = $settings.Get_Item("xnat_admin_pwd")
$anon_project = $settings.Get_Item("anon_project")

$storage_path = $settings.Get_Item("storage_path") -replace  '/', '\\'
$import_folder = $settings.Get_Item("import_data_folder")  -replace  '/', '\\'
$linux_import_folder = $import_folder -replace  '\\', '/'
$linux_storage_path = $storage_path -replace  '\\', '/'





$anon_port = "8082"
if ("$ssl" -like "*true*") {
    $anon_port = "444"
    if ( $ssl_crt.length -le 3 ) {
         Write-Host  "Error: Check xnat.cfg - ssl cert file missing $"
        Exit
    }
    if ( $ssl_trust.length -le 3 ) {
         Write-Host  "Error: Check xnat.cfg - ssl trust file missing "
        Exit
    }
        if ( $ssl_pem.length -le 3 ) {
         Write-Host  "Error: Check xnat.cfg - ssl dhparem file missing "
        Exit
    }
    if ( "$ssl_crt" -like "*\*" ) {

         Write-Host  "Error: Check xnat.cfg - filename only for ssl certificates"
        Exit
    }
    if ( "$ssl_trust" -like "*\*" ) {

         Write-Host  "Error: Check xnat.cfg - filename only for ssl certificates"
        Exit
    }if ( "$ssl_pem" -like "*\*" ) {

         Write-Host  "Error: Check xnat.cfg - filename only for ssl certificates"
        Exit
    }
}


if (Test-Path $storage_path)
{
    Write-Host "Storage path already exists, use restart.bat or restart_and_clean.bat!"
    Exit
}


if ( $xnat_host.length -le 5 ) {

     Write-Host  "Error: Check xnat.cfg - url (xnat_host) too short: $xnat_host"
    Exit
}

if ( $anon_project.length -le 3 ) {

     Write-Host  "Error: Check xnat.cfg - anon_project too short: $anon_project"
    Exit
}


if ( $xnat_admin_user -eq "admin" ) {

     Write-Host  "Error: Check xnat.cfg - xnat_admin_user cnanot be named admin"
    Exit
}

if ( "$storage_path" -like "/" ) {

     Write-Host  "Error: Check xnat.cfg - use \ for paths in Windows: $storage_path"
    Exit
}
if ( "$import_data_folder" -like "/" ) {

     Write-Host  "Error: Check xnat.cfg - use \ for paths in Windows: $import_data_folder"
    Exit
}


if ( "$xnat_host" -notlike "http*" ) {

     Write-Host  "Error: Check xnat.cfg - url malformed, not http/https: $xnat_host"
    Exit
}

if ( $storage_path.length -le 2 ) {

     Write-Host  "Error: Check xnat.cfg - storage_path too short"
    Exit
}
if ( $import_folder.length -le 2 ) {

    Write-Host "Error: Check xnat.cfg - import_data_folder too short"
    Exit
}

if ( $xnat_user.length -le 2 ) {

    echo "Error: Check xnat.cfg - xnat_user too short"
    Exit
}
if ( $xnat_pwd.length -le 2 ) {

    Write-Host "Error: Check xnat.cfg - xnat_pwd too short"
    Exit
}

if ( $xnat_admin_user.length -le 2 ) {

    Write-Host "Error: Check xnat.cfg - xnat_admin_user too short"
    Exit
}
if ( $xnat_admin_pwd.length -le 2 ) {

    Write-Host "Error: Check xnat.cfg - xnat_admin_pwd too short: $xnat_admin_pwd"
    Exit
}
if ( $psql_pwd.length -le 2 ) {

    Write-Host "Error: Check xnat.cfg - psql_pwd too short: $psql_pwd"
    Exit
}
if ( $hospital_code.length -le 2 ) {

    Write-Host "Error: Check xnat.cfg - hospital_code too short"
    Exit
}
$stacks = (docker stack ls) | Out-String
Write-Host "### Existing Stacks: $stacks    ###"
if ($stacks -like "*secure-dicom*" )
{   
	Write-Host "### uploader already running.... stopping current service and rebuilding###"
	docker stack rm secure-dicom-uploader
	Start-Sleep 60
	
}

cd..

docker swarm leave

#Remove-Item –path $storage_path –recurse 

Write-Host "### Installing XNAT UPLOADER        ###"
Write-Host "### Using config file xnat.cfg      ###"
Write-Host "# Host:  $xnat_host            ###"
Write-Host "# Local Project: $hospital_code      ###"
Write-Host "# storage path:  $storage_path    ,linux: $linux_storage_path       ###"
Write-Host "# import folder, linux:  $import_folder , linux: $linux_import_folder          ###"
Write-Host "# admin email:  $xnat_admin_email            ###"
Write-Host "# ssl_key:  $ssl_key            ###"
Write-Host "# ssl_bundle: $ssl_bundle       ###"

#Unzip volume

New-Item -ItemType directory -Path $storage_path\certificates\
New-Item -ItemType directory -Path $storage_path\archive1\
New-Item -ItemType directory -Path $storage_path\archive2\
New-Item -ItemType directory -Path $storage_path\postgres-data1\
New-Item -ItemType directory -Path $storage_path\postgres-data2\
New-Item -ItemType directory -Path $storage_path\scripts1\
New-Item -ItemType directory -Path $storage_path\scripts2\
New-Item -ItemType directory -Path $storage_path\tomcat_logs1\
New-Item -ItemType directory -Path $storage_path\tomcat_logs2\
New-Item -ItemType directory -Path $storage_path\nginx_logs\
New-Item -ItemType directory -Path $import_folder




# copy templates and cfg file
Write-Host "######################"
Write-Host "Copying templates and conf files"

Copy-Item "xnat.cfg" -Destination ".\xnat\xnat.cfg"
Copy-Item ".\xnat\templates\prefs-init.ini-template" -Destination ".\xnat\conf1\prefs-init.ini"
Copy-Item ".\xnat\templates\prefs-init.ini-template" -Destination ".\xnat\conf2\prefs-init.ini"
Copy-Item ".\xnat\templates\site-config-template" -Destination ".\xnat\conf2\siteConfig.txt"
Copy-Item ".\xnat\templates\site-config-template" -Destination ".\xnat\conf1\siteConfig.txt"
Copy-Item ".\xnat\templates\gradle.properties-template" -Destination ".\xnat\conf1\gradle.properties"
Copy-Item ".\xnat\templates\gradle.properties-template" -Destination ".\xnat\conf2\gradle.properties"
Copy-Item ".\xnat\templates\xnat-conf.properties-template" -Destination ".\xnat\conf1\xnat-conf.properties"
Copy-Item ".\xnat\templates\xnat-conf.properties-template" -Destination ".\xnat\conf2\xnat-conf.properties"
Copy-Item ".\xnat\templates\cronjobs-template" -Destination ".\xnat\cronjobs.txt"


Write-Host "######################"
Write-Host "Editing conf files"



# no longer uysed$sif = Get-Content "..\xnat\SeriesImportFilter.txt"

$anon_url = '{0}:{1}/anon/' -f $xnat_host,$anon_port

get-childitem .\xnat\conf1 -recurse -exclude setup*  | 
 select -expand fullname |
  foreach {
  $curFile = $_
  Write-Host "... Editing $curFile " 
  $lines=@(Get-Content $curFile)
  $newlines = @()
  foreach ($line in $lines) {
    # reformat the current line 
    $line = $line -replace '@ADMIN_EMAIL@', $xnat_admin_email 
    $line = $line -replace '@XNAT_ADMIN_USER@', $xnat_admin_user 
    $line = $line -replace '@SITE@', $xnat_name 
    $line = $line -replace '@SITEURL@', $xnat_host 
    $line = $line -replace '@SITEURLNA@', $xnat_host
    $line = $line -replace '@SITEURLPA@', $anon_url
    $line = $line -replace '@PROJECT@', $hospital_code 
    $line = $line -replace '@PIPELINE_URL@', 'http://localhost:8080/'
    $line = $line -replace '@PG_USR@', $psql_user 
    $line = $line -replace '@PG_PWD@', $psql_pwd 
    $line = $line -replace '@DB_NUM@', '1' 
    $newlines += $line
  }
  $newlines | out-file -FilePath $curFile -Encoding ASCII
}


$site_anon = 'anon' -f $xnat_name
get-childitem .\xnat\conf2 -recurse -exclude setup* | 
 select -expand fullname |
foreach {
  $curFile = $_
  Write-Host "... Editing $curFile " 
  $lines=@(Get-Content $curFile)
  $newlines = @()
  foreach ($line in $lines) {
    # reformat the current line 
    $line = $line -replace '@ADMIN_EMAIL@', $xnat_admin_email
    $line = $line -replace '@XNAT_ADMIN_USER@', $xnat_admin_user
    $line = $line -replace '@SITE@', $site_anon 
    $line = $line -replace '@SITEURL@', $anon_url
    $line = $line -replace '@SITEURLNA@', $xnat_host 
    $line = $line -replace '@SITEURLPA@', $anon_url
    $line = $line -replace '@PROJECT@', $hospital_code
    $line = $line -replace '@PIPELINE_URL@', 'http://localhost:8080/anon'
    $line = $line -replace '@PG_USR@', $psql_user  
    $line = $line -replace '@PG_PWD@', $psql_pwd 
    $line = $line -replace '@DB_NUM@', '2' 
    $newlines += $line
  }
  $newlines | out-file -FilePath $curFile -Encoding ASCII
}


Write-Host "######################"
Write-Host "Configuring nginx"
# NGINX ssl config
$NGINX_CONF='.\nginx\xnat.conf'
if ("$ssl" -like "*true*")
{   Write-Host "Nginx configured for https, secure site"
    copy .\nginx\xnat_ssl.conf .\nginx\xnat.conf
}else
{    Write-Host "# Nginx configured for http, no ssl configuration"
    copy .\nginx\xnat_nonssl.conf .\nginx\xnat.conf
}

$nginx_host1 = $xnat_host -replace 'https://', ''
$nginx_host = $nginx_host1 -replace 'http://', ''
Write-Host "Host: $nginx_host"

$lines=@(Get-Content $NGINX_CONF)
$newlines = @()
foreach ($line in $lines) {
  # reformat the current line 
  $line = $line -replace '@SERVER_NAME@', $nginx_host
  $line = $line -replace '@CRT@', $ssl_crt 
  $line = $line -replace '@KEY@', $ssl_key
  $line = $line -replace '@PEM@', $ssl_pem
  $line = $line -replace '@TRUST@', $ssl_trust
  $newlines += $line
}
$newlines | out-file -FilePath $NGINX_CONF -Encoding ASCII

Write-Host "######################"
Write-Host "Configuring Docker Compose"
# docker compse, set volume path

$DOCKER_FILE='docker-compose.yml'
copy docker-compose-template.yml docker-compose.yml

$lines=@(Get-Content $DOCKER_FILE)
$newlines = @()
foreach ($line in $lines) {
  # reformat the current line 
  $line = $line -replace './volume', $linux_storage_path 
  $line = $line -replace '@IMPORT_DATA_FOLDER@', $linux_import_folder 
  $line = $line -replace "#WINX", '' 
  $line = $line -replace '@PG_PWD@', $psql_pwd  
  $line = $line -replace '@PG_USER@', $psql_user 
  $newlines += $line
}
$newlines | out-file -FilePath $DOCKER_FILE -Encoding ASCII

$CRON_FILE='.\xnat\cronjobs.txt'
(Get-Content  $CRON_FILE) -replace '#WIN#' , '' | Set-Content  $CRON_FILE



Write-Host "######################"
Write-Host "Copying plugins, certificates and webapps"




xcopy /y .\certs\* $storage_path\certificates\


xcopy /y .\scripts\* $storage_path\scripts1\ /s /e

xcopy /y .\scripts\clean_logs.sh $storage_path\scripts2\ /s /e
xcopy /y .\scripts\pipelines\* $storage_path\scripts2\pipelines\ /s /e

New-Item -ItemType directory -Path $storage_path\scripts1\logs\
New-Item -ItemType directory -Path $storage_path\scripts2\logs\
New-Item -ItemType directory -Path $storage_path\scripts1\access_logs\
New-Item -ItemType directory -Path $storage_path\scripts2\access_logs\

## COPY PLUGINS AND WEBAPPS
Copy-Item -Path ".\plugins1" -Destination "$storage_path\scripts1\" -Recurse
Copy-Item -Path ".\plugins2" -Destination "$storage_path\scripts2\" -Recurse



### create XNAT pipe user
cd xnat
$random1 = -join ((65..90) + (97..122) | Get-Random -Count 15 | % {[char]$_})
Add-Content xnat.cfg  "xnat_pipe_user=xnat_pipe"
Add-Content xnat.cfg  "xnat_pipe_pwd=$random1"
cd..




### PROXY
$use_proxy = $settings.Get_Item("use_proxy")
$proxy_url = $settings.Get_Item("proxy_url")
$xnat_user = $settings.Get_Item("xnat_user")
$proxy_port = $settings.Get_Item("proxy_port")
if ("$use_proxy" -like "*true*"){
   $JAVA_PROXY = " -Dhttp.proxyHost=$proxy_url  -Dhttp.proxyPort=$proxy_port -Dhttps.proxyHost=$proxy_url  -Dhttps.proxyPort=$proxy_port   -Dhttp.nonProxyHosts=`"localhost|127.0.0.1|xnat-web1|xnat-web2`" "
    Remove-Item -path ./xnat_proxy
    cp -R ./xnat ./xnat_proxy
   $GRADLEW_PROXY = $JAVA_PROXY -replace "http://", "" -replace "https://", ""

    get-childitem ./xnat_proxy -exclude  *.tar,*.tar.gz,*.zip,*.war,*.tgz,*.cfg,*.xml | 
     select -expand fullname |
    foreach {
      $curFile = $_
      Write-Host "reading $curFile"
      $lines=@(Get-Content $curFile)
      $newlines = @()
      foreach ($line in $lines) {        
        $line = $line -replace "#ENV ", "ENV "
        $line = $line -replace "@PROXYURL@", "$proxy_url"
    $line = $line -replace "@PROXYPORT@", "$proxy_port"
        $line = $line -replace "@JAVA_PROXY@", "$JAVA_PROXY"
        $line = $line -replace "gradlew", "gradlew $GRADLEW_PROXY"
        $newlines += $line
      }
      $newlines | out-file -FilePath $curFile -Encoding ASCII
    }

  cd xnat_proxy
     $JAVA_PROXY = " -Dhttp.proxyHost=$proxy_url  -Dhttp.proxyPort=$proxy_port -Dhttps.proxyHost=$proxy_url  -Dhttps.proxyPort=$proxy_port   -Dhttp.nonProxyHosts=\`"localhost|127.0.0.1|xnat-web1|xnat-web2\`" "
    Add-Content bash_profile "# Using proxy - changing bash_profile"
    Add-Content bash_profile "export HTTPS_PROXY=`"${proxy_url}:$proxy_port`""
    Add-Content bash_profile "export https_proxy=`"${proxy_url}:$proxy_port`""
    Add-Content bash_profile "export ftp_proxy=`"${proxy_url}:$proxy_port`""
    Add-Content bash_profile "export FTP_PROXY=`"${proxy_url}:$proxy_port`""
    Add-Content bash_profile "export no_proxy=`"localhost, 127.0.0.1, xnat-web1, xnat-web2`""
    Add-Content bash_profile "export NO_PROXY=`"localhost, 127.0.0.1, xnat-web1, xnat-web2`""  
    Add-Content setenv.sh "export JAVA_OPTS=`"`$`{JAVA_OPTS}  $JAVA_PROXY `"" 
    Add-Content setenv.sh "export CATALINA_OPTS=`"`$`{CATALINA_OPTS`}  $JAVA_PROXY  `""
   
   
} else {
   cd xnat
}



### Create XNAT Pipe


# build images
Write-Host "######################"
Write-Host "Building docker images"


docker build -f Dockerfile1 -t xnat1 .
if ($LASTEXITCODE -ne 0 ){ 
  Write-Host  "Error: Docker build for xnat1 Failed" 
    Exit
}
docker build -f Dockerfile2 -t xnat2 .
if ($LASTEXITCODE -ne 0 ){ 
  Write-Host  "Error: Docker build for xnat2 Failed" 
    Exit
}
cd..
cd nginx
docker build -t nginx-xnat1 .
if ($LASTEXITCODE -ne 0 ){ 
  Write-Host  "Error: Docker build for nginx Failed" 
    Exit
}
cd..
cd postgres
docker build -f Dockerfile -t postgres-xnat .
if ($LASTEXITCODE -ne 0 ){ 
  Write-Host  "Error: Docker build for postgres Failed" 
    Exit
}
cd..
docker swarm init




Write-Host "Deploying stack"
docker stack deploy -c docker-compose.yml secure-dicom-uploader
if ($LASTEXITCODE -ne 0 ){ 
  Write-Host  "Error: Docker failed to create stack" 
    Exit
}


#run tests - 
if ("$test" -notlike "*test*") {

    Powershell.exe -executionpolicy remotesigned -File .\tests\run_win_tests.ps1 xnat.cfg
	$CFG_FILE='xnat.cfg'
	(Get-Content  $CFG_FILE) -replace '_pwd.+$',  , '_pwd=' | Set-Content  $CFG_FILE
	$CFG_FILE='.\xnat\xnat.cfg'
	(Get-Content  $CFG_FILE) -replace '_pwd.+$',  , '_pwd=' | Set-Content  $CFG_FILE
	Remove-Item -path .\xnat\conf1\* -include *.properties
	Remove-Item -path .\xnat\conf2\* -include *.properties

}
cd Windows
exit $LASTEXITCODE


