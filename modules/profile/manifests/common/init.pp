#
class profile::common::init (
  $timezone             = $profile::common::params::default_timezone,
  $motd_content         = $profile::common::params::default_motd_content,
  $additionals_packages = $profile::common::params::default_packages,
  ) inherits profile::common::params {

  ##############################################################################
  # Install Base packages
  $install_additionals_packages = hiera_array(profile::common::additionals_packages, [])
  # mergin both arrays
  $install_packages = [$additionals_packages, $install_additionals_packages]
  package { $install_packages: ensure => present }

  ##############################################################################
  # Include modt profile
  $show_content = hiera(profile::common::motd::content, $motd_content)
  class {'profile::motd::init':
    content => $show_content,
  }

  ##############################################################################
  #
}
