#!/bin/bash
# USAGE: . build.sh codename
if [ ! $1 ];
then
echo -e "";
echo -e "USAGE: ./build.sh <device-codename>";
echo -e ""
else
DEVICE="$1"
. build/envsetup.sh
lunch aosp_$DEVICE-userdebug && mka bacon | tee aosp_$DEVICE-$(date +%Y%m%d).log
fi
