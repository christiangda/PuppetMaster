#
class profile::common::params {

  $timezone = 'Etc/UTC'

  case $::operatingsystem {
    'RedHat', 'Fedora', 'CentOS': {
      $package_backends = [
        'pdns-backend-geo',
        'pdns-backend-lua',
        'pdns-backend-ldap',
        'pdns-backend-lmdb',
        'pdns-backend-pipe',
        'pdns-backend-geoip',
        'pdns-backend-mydns',
        'pdns-backend-mysql',
        'pdns-backend-remote',
        'pdns-backend-sqlite',
        'pdns-backend-opendbx',
        'pdns-backend-tinydns',
        'pdns-backend-postgresql',
      ]
    }
    'Debian', 'Ubuntu': {
      $package_backends = [
        'pdns-backend-geo',
        'pdns-backend-ldap',
        'pdns-backend-lua',
        'pdns-backend-mysql',
        'pdns-backend-pgsql',
        'pdns-backend-pipe',
        'pdns-backend-sqlite3',
      ]
    }
    default: {
      fail("\"${module_name}\" not support for \"${::operatingsystem}\"")
    }
  }
}
