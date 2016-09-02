#
class profile::common::init (
  $timezone     = $profile::common::params::default_timezone,
  $motd_content = $profile::common::params::default_motd_content,
  ) inherits profile::common::params {

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
  $install_packages = unique($default_packages + $install_additionals_packages)
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
  class { 'timezone':
      timezone => $timezone,
  }
}
