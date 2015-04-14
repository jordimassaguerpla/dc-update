fedora_package_manager=/usr/bin/yum

check_fedora_updates() {
  updates=$(/usr/bin/docker run --rm $image_name $pkg_manager_list_p | wc -l)
  [ $updates -eq 0 ]
}

set_fedora_package_manager() {
  pkg_manager_bin=/usr/bin/yum
  pkg_manager_list_p="$pkg_manager_bin check-update"
  pkg_manager_patch="$pkg_manager_bin -y update"
  check_updates=check_fedora_updates
}
