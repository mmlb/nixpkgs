{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "elvish";
  version = "20190311g" + (builtins.substring 0 8 "${src.rev}");

  goPackagePath = "github.com/elves/elvish";
  excludedPackages = [ "website" ];
  buildFlagsArray = ''
    -ldflags=
      -X ${goPackagePath}/buildinfo.Version=${version}
  '';

  src = fetchFromGitHub {
    owner = "elves";
    repo = "elvish";
    rev = "06fae6494a81fc73ce88019409ca8f1cb0c6b05d";
    sha256 = "0i56vjwi3va0bs0fb1n94498d9h79wv94bndc35mldrirmh50vxd";
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
