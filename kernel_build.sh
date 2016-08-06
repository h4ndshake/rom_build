#!/bin/bash

# Original script: Megatron007 @ XDA
# This is a script used to build custom kernels.
###### defines ######

local_dir=$PWD
defconfig=msm8960dt_mmi_defconfig
jobs=4
AnyKernel_folder=~/Development/AnyKernel
KERNEL=Kernel_ColorCalibration

###### defines ######

echo export KBUILD_BUILD_USER=rafael
export KBUILD_BUILD_USER=rafael

echo  export KBUILD_BUILD_HOST=Inspiron
export KBUILD_BUILD_HOST=Inspiron

echo '#############'
echo 'Cleaning'
echo '#############'
make clean                                                           # clean the sources
rm -rf out
rm $AnyKernel_folder/$KERNEL.zip                                     # clean the output folder
rm $AnyKernel_folder/modules/* 
rm $AnyKernel_folder/zImage
echo ''
echo '#############'
echo 'Setting Up'
echo '#############'
export ARCH=arm
export CROSS_COMPILE=~/Development/arm-eabi-4.9/bin/arm-eabi-
make $defconfig
echo ''
echo '#############'
echo 'Compiling'
echo '#############'
time make -j$jobs
echo ''
echo '#############'
echo 'Post-compile'
echo '#############'
echo ''
mkdir -p out/modules                                                 # make "out" folder
cp arch/arm/boot/zImage out/zImage                                   # copy zImage to "out" folder
# Find and copy modules
find -name '*.ko' | xargs -I {} cp {} ./out/modules/
cp -r out/* $AnyKernel_folder/                                       # copy zImage and modules to AnyKernel folder
echo 'Done'
echo ''
if [ -a arch/arm/boot/zImage ]; then
echo '#############'
echo 'Making zip'
echo '#############'
echo ''
cd $AnyKernel_folder/
zip -r $KERNEL.zip ./ -x *.zip *.gitignore *EMPTY_DIRECTORY
if [[ $1 = -d ]]; then
cp $KERNEL $AnyKernel_folder/$KERNEL
echo "Copying $KERNEL to My Folder"
fi
cd $local_dir                                                        # cd back to the old dir
echo ''
echo '#############'
echo 'Success!'
echo '#############'
else
echo ''
echo '#############'
echo 'Fail!'
echo '#############'
fi
