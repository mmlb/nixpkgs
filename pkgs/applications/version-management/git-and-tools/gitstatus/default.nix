{callPackage, stdenv, fetchFromGitHub, ...}:

stdenv.mkDerivation rec {
  name = "gitstatus-${version}";
  version = "unstable-2019-06-09g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "gitstatus";
    rev = "7d32e772d3ee681b7a82e92c955a31694e8d3c8f";
    sha256 = "1anw78j2d1b6z4hxr0897f9wri5y8kcfiz4ybqwwilcgw9zgjip5";
  };

  buildInputs = [ (callPackage ./romkatv_libgit2.nix {}) ];
  patchPhase = ''
    sed -i "s|local daemon.*|local daemon=$out/bin/gitstatusd|" gitstatus.plugin.zsh
  '';
  installPhase = ''
    install -Dm755 gitstatusd $out/bin/gitstatusd
    install -Dm444 gitstatus.plugin.zsh $out
  '';

  meta = with stdenv.lib; {
    description = "10x faster implementation of `git status` command";
    homepage = https://github.com/romkatv/gitstatus;
    license = [ licenses.gpl3 ];

    maintainers = [ maintainers.mmlb ];
  };
}
