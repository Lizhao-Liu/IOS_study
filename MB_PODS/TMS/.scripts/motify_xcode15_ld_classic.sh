#!/bin/bash

xcodebuild_version=$(xcodebuild -version)
echo $xcodebuild_version

workspace_dir=$(find $(pwd) -maxdepth 1 -name "*.xcodeproj")
pbxproj_path="${workspace_dir}/project.pbxproj"
echo $pbxproj_path

if [[ $xcodebuild_version =~ "Xcode 15" ]]; then
    echo "Xcode 15, add -ld_classic"
    sed -i "" "s/OTHER_LDFLAGS.*/OTHER_LDFLAGS = \"-ld_classic\";/" $pbxproj_path

else
    sed -i "" "s/-ld_classic//" $pbxproj_path

    echo "Xcode other version, remove -ld_classic"
fi
