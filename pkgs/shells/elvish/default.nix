{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "elvish";
  version = "unstable-2019-07-20g${builtins.substring 0 9 src.rev}";

  goPackagePath = "github.com/elves/elvish";
  excludedPackages = [ "website" ];
  buildFlagsArray = ''
    -ldflags=
      -X ${goPackagePath}/buildinfo.Version=${version}
  '';

  src = fetchFromGitHub {
    owner = "elves";
    repo = "elvish";
    rev = "b724f0aa20239829b1a37cfbef44694c4c755dcc";
    sha256 = "1x15flkcrrqrsgry210frlizb5h0jimyddkg7cbfjw35219n79g8";
  };

  meta = with stdenv.lib; {
    description = "A friendly and expressive command shell";
    longDescription = ''
      Elvish is a friendly interactive shell and an expressive programming
      language. It runs on Linux, BSDs, macOS and Windows. Despite its pre-1.0
      status, it is already suitable for most daily interactive use.
    '';
    homepage = https://elv.sh/;
    license = licenses.bsd2;
    maintainers = with maintainers; [ vrthra AndersonTorres ];
    platforms = with platforms; linux ++ darwin;
  };

  passthru = {
    shellPath = "/bin/elvish";
  };
}
