{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "elvish-unstable-${version}";
  version = "20181118";

  goPackagePath = "github.com/elves/elvish";
  excludedPackages = [ "website" ];
  buildFlagsArray = ''
    -ldflags=
      -X ${goPackagePath}/buildinfo.Version=${version}
  '';

  src = fetchFromGitHub {
    repo = "elvish";
    owner = "elves";
    rev = "b544378b37ac36392fb704b08dd3ed1c3f0b05be";
    sha256 = "16kh63lcb813614m4xdp4cnkcwchv4c4dpmw48rgrmq6mr3baisg";
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
