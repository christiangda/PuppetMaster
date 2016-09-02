#
class profile::common::params {

  # Default timezone
  $default_timezone = 'Etc/UTC'

  # Default motd message
  $default_motd_content = "You are connected to: ${fqdn}"

  # Values based in OS type
  case $operatingsystem {
    'CentOS': {
      $default_packages = [
        'epel-release',
        'openssl',
        'htop',
        'mlocate',
        'sysstat',
      ]
    }
    'RedHat', 'Fedora': {
      $default_packages = [
        'openssl',
        'htop',
        'mlocate',
        'sysstat',
      ]
    }
    'Debian', 'Ubuntu': {
      $default_packages = [
        'openssl',
        'htop',
        'mlocate',
        'sysstat',
      ]
    }
    default: {
      fail("\"${module_name}\" not support for \"${::operatingsystem}\"")
    }
  }

  #

}
