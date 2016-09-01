#
class profile::motd::init (
  $content = "You are connected to: ${::fqdn}. \n This system is managed by Puppet version ${::puppetversion}.",
  ){

    $show_message = hiera(profile::motd::content, $content)
    class { 'motd':
      content => $show_message,
    }
  }
