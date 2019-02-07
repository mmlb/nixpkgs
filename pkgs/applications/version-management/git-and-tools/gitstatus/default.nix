{callPackage, stdenv, fetchFromGitHub, ...}:

stdenv.mkDerivation rec {
  name = "gitstatus-${version}";
  version = "20190411"+ (builtins.substring 0 9 "g${src.rev}");

  src = fetchFromGitHub {
    owner  = "romkatv";
    repo   = "gitstatus";
    rev    = "7b177d3df477a2df85ae747b90f3dd234c92f090";
    sha256 = "05afkc2llqjfvsvrrbbk0i9nmwflrf37pb9p917fg9iz5k3i03l4";
  };

  buildInputs = [ (callPackage ./romkatv_libgit2.nix {}) ];
  installPhase = ''
    install -Dm755 gitstatusd $out/bin/gitstatusd
    install -Dm444 gitstatus.plugin.zsh $out
    sed -i "s|local daemon.*|local daemon=$out/bin/gitstatusd|" $out/gitstatus.plugin.zsh
  '';

  meta = with stdenv.lib; {
    description = "10x faster implementation of `git status` command";
    homepage = https://github.com/romkatv/gitstatus;
    license = [ licenses.gpl3 ];

    maintainers = [ maintainers.mmlb ];
  };
}
