#
class profile::common::init (
  $timezone             = $profile::common::params::default_timezone,
  $motd_message         = $profile::common::params::default_motd_message,
  $additionals_packages = $profile::common::params::default_packages,
  ) inherits profile::common::params {

  ##############################################################################
  # Install Base packages
  $install_additionals_packages = hiera_array(profile::common::additionals_packages, [])
  $install_packages = merge($additionals_packages, $install_additionals_packages)

  package { $install_packages:
    ensure => installed,
  }

  ##############################################################################
  # Include modt profile
  $show_message = hiera(profile::common:motd:message, $motd_message)

  class ::profile::motd {
    $message = $show_message,
  }

  ##############################################################################
  #
}
