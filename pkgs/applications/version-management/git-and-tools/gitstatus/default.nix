{callPackage, stdenv, fetchFromGitHub, ...}:

stdenv.mkDerivation rec {
  pname = "gitstatus";
  version = "unstable-2019-09-09g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "gitstatus";
    rev = "2bfb1de6e0e839174d6b92f4b4174835f3238d97";
    sha256 = "0nimlr1kk79zz3kxn9kawwqglm6zl2xvq0yi7gy3giwz32sbw9b3";
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
