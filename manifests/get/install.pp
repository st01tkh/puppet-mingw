define mingw::get::install(){
  $pkgname = $title

  $tmp_dir = 'c:\temp'
  $tmp_base = 'chocolatey-mingw-get.123'
  $tmp_path = file_join_win(["${tmp_dir}", "${tmp_base}"])
  
  $sysroot = env("SYSTEMROOT")
  $sys32 = file_join_win(["${sysroot}", "System32"])

  $tools_dir = 'C:\tools'

  $mingw_dir = file_join_win(["${tools_dir}", "MinGW"])
  $mingw_bin = file_join_win(["${mingw_dir}", "bin"])

  $msys_dir = file_join_win(["${mingw_dir}", "msys", "1.0"])
  $msys_bin = file_join_win(["${msys_dir}", "bin"])

  $choco_dir = env("ChocolateyInstall")
  $choco_bin = file_join_win(["${choco_dir}", "bin"])

  exec { "mingw-get_install_${$pkgname}": 
    path => [$sysroot, $sys32, $mingw_bin, $msys_bin],
    command => "mingw-get install ${pkgname}",
  }
}
