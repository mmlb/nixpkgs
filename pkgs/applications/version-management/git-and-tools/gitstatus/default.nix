{callPackage, stdenv, fetchFromGitHub, ...}:

stdenv.mkDerivation {
  name = "gitstatus-${version}";
  version = "unstable-2019-08-20g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "gitstatus";
    rev = "324982333189809163f3532ebe83b8b24f907d27";
    sha256 = "0hk8dsgvkz6zxrvgkgk5m69zj4ybfy4acpc1ff5248vbxmnrnqhv";
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
