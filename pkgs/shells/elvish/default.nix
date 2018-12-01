{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "elvish-unstable-${version}";
  version = "20181125";

  goPackagePath = "github.com/elves/elvish";
  excludedPackages = [ "website" ];
  buildFlagsArray = ''
    -ldflags=
      -X ${goPackagePath}/buildinfo.Version=${version}
  '';

  src = fetchFromGitHub {
    repo = "elvish";
    owner = "elves";
    rev = "3dae357e5e024b900a4e34ee20a27bf0ca899dbe";
    sha256 = "0crin50kk5f6nnj3sdb4yzglizg5x3pjf1qds5fj906mwz5sgx7p";
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
