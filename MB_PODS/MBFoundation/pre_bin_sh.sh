sed -i "" "s/^ *pod_resource_bundle_dir=.*/      pod_resource_bundle_dir\=\"\$\{PODS_ROOT\}\/MBFoundation\/binary_frameworks\/MBFoundation.framework\/Resources\/\$\{bundle_file\}\"/" MBFoundation.podspec