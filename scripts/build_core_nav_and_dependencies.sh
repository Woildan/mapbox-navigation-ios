#!/bin/sh

package_dir="pkg"

rm -Rf ${package_dir}

carthage update --platform iOS

xcodebuild -scheme MapboxCoreNavigationUniversal -configuration release

declare -a nav_core_dependencies=("MapboxDirections" "MapboxMobileEvents" "Polyline" "Turf")

frameworks_dir="${package_dir}/Frameworks"

echo "Copying \"MapboxCoreNavigation\" dependencies to \"${frameworks_dir}\"\n"

for i in "${nav_core_dependencies[@]}"
do
	cp -r "Carthage/Build/iOS/$i.framework" ${frameworks_dir}
done

echo "Creating \"MapboxCoreNavigation\" framework archive\n"

tar -zcf "${package_dir}/MapboxCoreNavigation.framework.tar.gz" -C ${package_dir} "Frameworks"

echo "SUCCESS: Archive created.\n"
