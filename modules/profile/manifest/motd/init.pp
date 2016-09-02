#
class profile::motd::init (
  $content = "You are connected to: %{::fqdn}",
  ){

    $show_content = hiera(profile::motd::content, $content)
    class { 'motd':
      content => $show_content,
    }
  }
