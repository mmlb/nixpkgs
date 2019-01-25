{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "elvish-unstable-${version}";
  version = "20190121";

  goPackagePath = "github.com/elves/elvish";
  excludedPackages = [ "website" ];
  buildFlagsArray = ''
    -ldflags=
      -X ${goPackagePath}/buildinfo.Version=${version}
  '';

  src = fetchFromGitHub {
    repo = "elvish";
    owner = "elves";
    rev = "1875b1a7ad3e0cbce029a00fd411b17fb79946d3";
    sha256 = "0agk0fmz327jw15z3z0h85i89dq3mwkmg0rk9bg0yxdawfcxldxh";
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
