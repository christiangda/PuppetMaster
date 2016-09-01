#
class profile::common::params {

  # Default timezone
  $default_timezone = 'Etc/UTC'

  # Default motd message
  $default_motd_message = "You are connected to: $facter['fqdn']"

  # Values based in OS type
  case $::operatingsystem {
    'RedHat', 'Fedora', 'CentOS': {
      $default_packages = [
        'epel-release',
        'openssl',
        'vim-enhanced',
        'htop',
        'elinks',
        'mlocate',
        'nmap',
        'telnet',
        'sysstat',
      ]
    }
    'Debian', 'Ubuntu': {
      $default_packages = [
        'openssl',
        'vim',
        'htop',
        'elinks',
        'mlocate',
        'nmap',
        'telnet',
        'sysstat',
      ]
    }
    default: {
      fail("\"${module_name}\" not support for \"${::operatingsystem}\"")
    }
  }
}
