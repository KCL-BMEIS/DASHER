
project=$1
session=$2
deleteall=$3
if [ "$deleteall" = "Y" ]; then
	find /data/xnat/archive/ -name "*.dcm" -type f  -delete
	find /data/xnat/archive/ -name "*.nii" -type f  -delete
	find /data/xnat/archive/ -name "*.bf"  -type f  -delete
else
	find /data/xnat/archive/$project/arc001/$session -name "*.dcm" -type f  -delete
	find /data/xnat/archive/$project/arc001/$session -name "*.nii" -type f  -delete
	find /data/xnat/archive/$project/arc001/$session -name "*.bf" -type f  -delete
fi
