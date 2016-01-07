# == Class: mingw
#
# Puppet module to setup MinGW via chocolatey
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { 'mingw':
#  }
#
# === Authors
#
# st01tkh <st01tkh@gmail.com>
#
# === Copyright
#
# Copyright 2016 st01tkh
#
class mingw {
  if ($operatingsystem == 'windows') {
      include chocolatey
      #Package { provider => chocolatey, }
      #package {'git':
      #  ensure => latest,
      #}

      $tmp_dir = 'c:\temp'
      $tmp_base = 'chocolatey-mingw-get.123'
      $tmp_path = file_join_win(["${tmp_dir}", "${tmp_base}"])
    
      $sysroot = env("SYSTEMROOT")
      $sys32 = file_join_win(["${sysroot}", "System32"])
      $choco_dir = env("ChocolateyInstall")
      $choco_bin = file_join_win(["${choco_dir}", "bin"])

      $nuspec_base = 'mingw-get.nuspec'
      $nupkg_base = 'mingw-get.1.0.3.nupkg'
      $nupkg_path = file_join_win(["${tmp_path}", $nupkg_base])
      $nupkg_uri = file_join_uri(["${tmp_path}", $nupkg_base])

      file { "${tmp_dir}":
        ensure => directory
      }
      vcsrepo { "${$tmp_path}":
        require => [File["${tmp_dir}"]],
        ensure   => present,
        provider => git,
        source => 'https://github.com/hsk/chocolatey-mingw-get',
      }
      exec {'choco_install_mingw-get_by_nuspec': 
        require => Vcsrepo["${$tmp_path}"],
        path => [$sysroot, $sys32, $choco_bin],
        cwd => "${tmp_path}",
        command => "choco install -y -f ${nuspec_base}",
      }

      #exec {'choco_pack_mingw-get': 
      #  require => Vcsrepo["${$tmp_path}"],
      #  path => [$sysroot, $sys32, $choco_bin],
      #  cwd => "${tmp_path}",
      #  command => 'choco pack',
      #  creates => $nupkg_path,
      #}
      ##class {'chocolatey':
      ##  require => Exec['choco_pack_mingw-get'],
      ##  chocolatey_download_url => $nupkg_uri,
      ##}
      #exec{'choco_install_mingw-get':
      #  require => Exec['choco_pack_mingw-get'],
      #  path => [$sysroot, $sys32, $choco_bin],
      #  cwd => "${tmp_path}",
      #  command => "choco install -y -f ${nupkg_base}",
      #}
      #notify { "choco install -y -f ${nupkg_base}": }
  } else {
      notify {"$operatingsystem is not supported": }
  }
}
