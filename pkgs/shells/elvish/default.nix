{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "elvish";
  version = "unstable-2020-08-18g${builtins.substring 0 9 src.rev}";

  excludedPackages = [ "website" ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/elves/elvish/pkg/buildinfo.Version==${version} -X github.com/elves/elvish/pkg/buildinfo.Reproducible=true" ];

  src = fetchFromGitHub {
    owner = "elves";
    repo = pname;
    rev = "ce19bca5995c121c012903247a84024bfa967a8b";
    sha256 = "12xvq8xy7z4a654ga0mh0s9xd5v3wgy4k1zji65sask3p750vbj3";
  };

  vendorSha256 = "0bkv68b38xqzjif340rz2pgh8v2s0syls09in35xjds60bv9fk98";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "A friendly and expressive command shell";
    longDescription = ''
      Elvish is a friendly interactive shell and an expressive programming
      language. It runs on Linux, BSDs, macOS and Windows. Despite its pre-1.0
      status, it is already suitable for most daily interactive use.
    '';
    homepage = "https://elv.sh/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ vrthra AndersonTorres ];
    platforms = with platforms; linux ++ darwin;
  };

  passthru = {
    shellPath = "/bin/elvish";
  };
}
