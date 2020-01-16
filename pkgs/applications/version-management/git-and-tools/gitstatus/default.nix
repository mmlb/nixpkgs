{callPackage, stdenv, fetchFromGitHub, ...}:

stdenv.mkDerivation rec {
  pname = "gitstatus";
  version = "unstable-2020-01-12g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = pname;
    rev = "b86b0e680571397437e70d1f50c3d0fd9a9a8f05";
    sha256 = "11ias1icw1amkbj1z0m6nvxzg9a0y52525szl3lf706r06dj7mss";
  };

  buildInputs = [ (callPackage ./romkatv_libgit2.nix {}) ];
  patchPhase = ''
    sed -i "1i GITSTATUS_DAEMON=$out/bin/gitstatusd" gitstatus.plugin.zsh
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
