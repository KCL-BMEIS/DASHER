Param(
  [parameter(mandatory=$true)][string]$file
)



Get-Content "$file" | ForEach-Object -Begin {$settings=@{}} -Process {$store = [regex]::split($_,'='); if(($store[0].CompareTo("") -ne 0) -and ($store[0].StartsWith("[") -ne $True) -and ($store[0].StartsWith("#") -ne $True)) {$settings.Add($store[0], $store[1])}}
$volume_path = $settings.Get_Item("storage_path")
$import_data_folder = $settings.Get_Item("import_data_folder")
$HC = $settings.Get_Item("hospital_code")
$anon_project = $settings.Get_Item("anon_project")
$xnat_admin_user = $settings.Get_Item("xnat_admin_user")
$xnat_admin_pwd = $settings.Get_Item("xnat_admin_pwd")

Write-Host "###### RUNNING TESTS #######################"
Write-Host "###### PLEASE BE PATIENT, THIS WILL TAKE TIME#######"
Write-Host "###### Storage Path: $volume_path #############"



if ( $volume_path -like '.*' )
{	$volume_path="$volume_path"
	Write-Host "volume is relative path, changing: $volume_path " 
      
}

Write-Host "#########################################"
#Write-Host "###  Copying test data in import directory  ###"

$directory="tests\test_data"
$import_folder=$import_data_folder.replace("/","\")
#done in setup script now, to save time.
Write-Host " Test data: $directory Destination fodler: $import_folder"
Copy-Item  "$directory" -Destination "$import_folder" -Recurse 
Write-Host "###  Waiting for setup to complete... tests will start in 35 minutes.  ###"




$a = 2100

Do
{
 
 Start-Sleep 1
 $a--
 Write-Progress -Activity "Time left $a" 
 } While ($a -ge 0)

$all_tests_pass=$true

$image_pass=$true
$images = (docker image ls) | Out-String
Write-Host "##### Checking images for errors:   ######"
if (!$images -contains "nginx" )
{    Write-Host "nginx image not found"
	$image_pass=$false
}
if (!$images -contains "postgres" )
{    Write-Host "postgres image not found"
	 $image_pass=$false
}
if (!$images -contains "xnat1" )
{    Write-Host "xnat1 image not found"
     $image_pass=$false
}
if (!$images -contains "xnat2" )
{    Write-Host "xnat2 image not found"
     $image_pass=$false
}
if ($image_pass)
{
	Write-Host "PASS: All docker images created"
} else
{
    Write-Host "FAIL: Docker images not created"
    $all_tests_pass=$false
}




$container_pass=$true
$containers = (docker container ls) | Out-String
Write-Host "#####  Checking containers exist: #######"
if (!$containers -contains "nginx" )
{    Write-Host "nginx container not found"
	$container_pass=$false
} 
if (!$containers -contains "xnat-db1" )
{   Write-Host "postgres1 container not found"
	$container_pass=$false
}
if (!$containers -contains "xnat-db2" )
{   Write-Host "postgres2 container not found"
	$container_pass=$false
}
if (!$containers -contains "xnat-web1" )
{    Write-Host "xnat1 container not found"
	$container_pass=$false
}
if (!$containers -contains "xnat-web2" )
{    Write-Host "xnat2 container not found"
	$container_pass=$false
}
if ($container_pass)
{
	Write-Host "PASS: All docker containers running"
} else {
  Write-Host "FAIL: Not all containers are running"
  $all_tests_pass=$false
}


Write-Host "##### Checking file system:   #######"
$fs_pass=$true
$volume_path = $volume_path.replace("/","\")

$root_path = "$volume_path\tomcat_logs1\application.log"
if(![System.IO.File]::Exists($root_path)){
   Write-Host "FAIL: Tomcat Logs folder 1, $root_path, does not exist: Tomcat running?:"
   $fs_pass=$false
}
$root_path = "$volume_path\tomcat_logs2\application.log"
if(![System.IO.File]::Exists($root_path)){
   Write-Host "FAIL: Tomcat Logs folder 2, $root_path, does not exist: Tomcat running?:"
   $fs_pass=$false
}
if ($fs_pass)
{
	Write-Host "PASS: All files created"
} else {
  Write-Host "FAIL: Not all files created"
  $all_tests_pass=$false
}




Write-Host "#####  Checking to see if project QUARANTINE created ###"
$test_project_archive_path = "$volume_path\archive1\QUARANTINE\arc001\"
if(Test-Path $test_project_archive_path){
    Write-Host "PASS: QUARANTINE project exists"   
} else {
    Write-Host "FAIL: Test project archive folder, $test_project_archive_path, does not exist."
    $all_tests_pass=$false   
}


Write-Host "#####  Checking to see if test session ZZZspine was imported ###"
$root_path = "$volume_path\archive1\$HC\arc001\zzsabrSPINE\"
if(Test-Path $root_path){
    Write-Host "PASS: Test Data is in archive"
} else
{
    Write-Host "FAIL:Test data is not in archive directory"
    $all_tests_pass=$false
}


Write-Host "#####  Checking to see if test session ZZZspine was annonymsied and annoymised session test_session exists ###"

$root_path = "$volume_path\archive2\$anon_project\arc001\TestSession\"
if(Test-Path $root_path){
    Write-Host "PASS: Annoymised Session is in archive"
} else
{
    Write-Host "FAIL: Annoymised Session is not in archive directory $root_path "
    $all_tests_pass=$false
}




Write-Host "##########DELETNG TEST DATA###############################"
Start-Process  .\Windows\update_xnat_projects.bat delete_test_data


Write-Host "#########################################"
Write-Host "Tests Complete"

if ($all_tests_pass)
{
  Write-Host "PASS: All Tests PASS"
} else {
  Write-Host "FAIL: Tests fail"
  $all_tests_pass=$false
  exit 1
}

exit $LASTEXITCODE


