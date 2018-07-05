{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "elvish";
  version = "20180702";

  goPackagePath = "github.com/elves/elvish";
  excludedPackages = [ "website" ];
  buildFlagsArray = ''
    -ldflags=
      -X ${goPackagePath}/buildinfo.Version=${version}
  '';

  src = fetchFromGitHub {
    repo = "elvish";
    owner = "elves";
    rev = "8a49c8fa275d4ae6437777cbefaff9d5d9e4acaf";
    sha256 = "1nxijphdbqbv032s9mw7miypy92xdyzkql1bcqh0s1d0ghi66hvm";
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
