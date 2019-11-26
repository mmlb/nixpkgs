{callPackage, stdenv, fetchFromGitHub, ...}:

stdenv.mkDerivation rec {
  pname = "gitstatus";
  version = "unstable-2019-11-22g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "gitstatus";
    rev = "ecef84922ab71fd2b285eeb89f7f9fdc09786749";
    sha256 = "1vswhgpjyd719c735bnpp9lvpkprzfxlifafkxcyhx9gfq4v2rrf";
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
