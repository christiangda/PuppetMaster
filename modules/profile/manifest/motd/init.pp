#
class profile::motd::init (
  $message = "You are connected to: $facts['fqdn'] \n",
  ){

    $show_message = hiera(profile::motd::message, $message)
    class { 'motd':
      content => $show_message,
    }
  }
