{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "elvish";
  version = "unstable-2020-04-13g${builtins.substring 0 9 src.rev}";

  buildFlagsArray = ''
    -ldflags=-X github.com/elves/elvish/buildinfo.Version=${version}
  '';

  src = fetchFromGitHub {
    owner = "elves";
    repo = pname;
    rev = "3a976ef1c2e4f8c16e8c45e2b2bbafcafe985595";
    sha256 = "0nyglvc8bqxhb8h4pp2ckdaqpma6lpggm5mk9wm9dd5bjk0lkxk3";
  };
  modSha256 = "1jl43p9jf5kwv9rg3srmwp9ss4q9qdqj5f02q4zsmalkyan4zbz1";

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
