{callPackage, stdenv, fetchFromGitHub, ...}:

stdenv.mkDerivation rec {
  name = "gitstatus-${version}";
  version = "unstable-2019-06-21g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "gitstatus";
    rev = "5766fe6633dda01413f9458e0392ef3c6a409e86";
    sha256 = "1fvi0smxznmjvlx3zv3cl1q971aqvxd63w0y9cnpw7s6r063jmmq";
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
