{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "elvish";
  version = "unstable-2020-11-07g${builtins.substring 0 9 src.rev}";

  excludedPackages = [ "website" ];

  buildFlagsArray = [
    "-ldflags=-s -w -X github.com/elves/elvish/pkg/buildinfo.Version==${version} -X github.com/elves/elvish/pkg/buildinfo.Reproducible=true"
  ];

  src = fetchFromGitHub {
    owner = "elves";
    repo = pname;
    rev = "6f3b8a787b8b8eb98e1436316f0d4cc1d00e4604";
    sha256 = "1bnwdk003l6z1q3bb4s8q840zqv9ba19gh50am9y4whww5904yc5";
  };

  vendorSha256 = "124m9680pl7wrh7ld7v39dfl86r6vih1pjk3bmbihy0fjgxnnq0b";

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

  passthru = { shellPath = "/bin/elvish"; };
}
