suse_package_manager=/usr/bin/zypper

check_suse_updates() {
  /usr/bin/docker run --rm $image_name $pkg_manager_list_p | grep "No updates found"
}

set_suse_package_manager() {
  pkg_manager_bin=/usr/bin/zypper
  pkg_manager_list_p="$pkg_manager_bin --non-interactive lp"
  pkg_manager_patch="$pkg_manager_bin --non-interactive patch"
  check_updates=check_suse_updates
}
