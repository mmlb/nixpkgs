{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "elvish-unstable-${version}";
  version = "20181217";

  goPackagePath = "github.com/elves/elvish";
  excludedPackages = [ "website" ];
  buildFlagsArray = ''
    -ldflags=
      -X ${goPackagePath}/buildinfo.Version=${version}
  '';

  src = fetchFromGitHub {
    repo = "elvish";
    owner = "elves";
    rev = "d939a109039d125b5e89e509adffa77174297053";
    sha256 = "0y0sr0l4yah8m5mnxrwzc586hq45mhpspxkrjd5933j0d618kfr4";
  };

  meta = with stdenv.lib; {
    description = "A friendly and expressive Unix shell";
    homepage = https://elv.sh/;
    license = licenses.bsd2;
    maintainers = with maintainers; [ vrthra ];
    platforms = with platforms; linux ++ darwin;
  };

  passthru = {
    shellPath = "/bin/elvish";
  };
}
