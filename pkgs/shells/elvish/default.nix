{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "elvish";
  version = "unstable-2019-11-16g${builtins.substring 0 9 src.rev}";

  buildFlagsArray = ''
    -ldflags=-X github.com/elves/elvish/buildinfo.Version=${version}
  '';

  src = fetchFromGitHub {
    owner = "elves";
    repo = "elvish";
    rev = "d1ec850cd0ace951b0f63eb9a86219b8dea9be6d";
    sha256 = "0hzjw06qxg2g5lwfxkjbn7a7pv7mkmhrkhq5i8dz5fp6gmmdqzsp";
  };
  modSha256 = "13x4wbfj8049ygm3zbgzyr2bm4sq4x6xddrxx6shr8fydlcf1g8v";

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
