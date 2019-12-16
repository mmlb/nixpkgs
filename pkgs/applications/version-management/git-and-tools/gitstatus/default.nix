{callPackage, stdenv, fetchFromGitHub, ...}:

stdenv.mkDerivation rec {
  pname = "gitstatus";
  version = "unstable-2019-12-06g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = pname;
    rev = "7d9f0d0db3ffbe0a6993a5ff7d47e741cef3473b";
    sha256 = "1yighlj8vj268j70nynxb6z557gr9yii500rmm86rjb8gcx75rpw";
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
