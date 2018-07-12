#!/bin/sh

CONFIGURATION="Release"
if [[ $# -eq 1 && $1 = "Debug" ]]; then
    CONFIGURATION=$1
fi

echo "====== Building using '${CONFIGURATION}' configuration..."

package_dir="pkg"
frameworks_dir_name="Frameworks-${CONFIGURATION}"
frameworks_dir_path="${package_dir}/${frameworks_dir_name}"

rm -Rf ${frameworks_dir_path}

carthage update --platform iOS

xcodebuild -scheme MapboxCoreNavigationUniversal -configuration ${CONFIGURATION}

declare -a nav_core_dependencies=("MapboxDirections" "MapboxMobileEvents" "Polyline" "Turf")

echo "Copying \"MapboxCoreNavigation\" dependencies to \"${frameworks_dir_path}\"\n"

for i in "${nav_core_dependencies[@]}"
do
	cp -r "Carthage/Build/iOS/$i.framework" ${frameworks_dir_path}
	cp -r "Carthage/Build/iOS/$i.framework.dSYM" ${frameworks_dir_path}
done

echo "Creating \"MapboxCoreNavigation\" framework archive\n"

tar -zcf "${package_dir}/MapboxCoreNavigation.framework.tar.gz" -C ${package_dir} ${frameworks_dir_name}

echo "====== SUCCESS: Archive created.\n"
