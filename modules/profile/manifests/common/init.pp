#
class profile::common::init (
  $timezone     = $profile::common::params::default_timezone,
  $motd_content = $profile::common::params::default_motd_content,
  ) inherits profile::common::params {

  ##############################################################################
  # Include dependencies
  include stdlib

  ##############################################################################
  # Install Base packages
  case $operatingsystem {
    'RedHat', 'Fedora', 'CentOS': {
      $install_additionals_packages = hiera_array(profile::common::packages::redhat_family, [])
    }
    'Debian', 'Ubuntu': {
      $install_additionals_packages = hiera_array(profile::common::packages::debian_family, [])
    }
  }

  # Merging data
  $software_array = $default_packages + $install_additionals_packages
  $install_packages = unique($software_array)
  # Install
  package { $install_packages:
    ensure => 'installed',
  }

  ##############################################################################
  # Include modt profile
  $show_content = hiera(profile::common::motd::content, $motd_content)
  class { 'motd':
    content => $show_content,
  }

  ##############################################################################
  # Timezone
  $install_timezone = hiera(profile::common::timezone, $timezone)
  class { 'timezone':
      timezone => $install_timezone,
  }
}
