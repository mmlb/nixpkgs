{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "elvish";
  version = "unstable-2020-01-12g${builtins.substring 0 9 src.rev}";

  buildFlagsArray = ''
    -ldflags=-X github.com/elves/elvish/buildinfo.Version=${version}
  '';

  src = fetchFromGitHub {
    owner = "elves";
    repo = pname;
    rev = "042301f47f7ad1beaf1eaddb67f913584b57711c";
    sha256 = "0lz9lf1swrn67kymcp2wh67lh3c0ifqm9035gpkd3zynlq3wzqfm";
  };

  modSha256 = "13x4wbfj8049ygm3zbgzyr2bm4sq4x6xddrxx6shr8fydlcf1g8v";

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
