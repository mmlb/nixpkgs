{callPackage, stdenv, fetchFromGitHub, ...}:

stdenv.mkDerivation rec {
  pname = "gitstatus";
  version = "unstable-2020-03-15g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = pname;
    rev = "69a666e4e46446dfbdb447b49a36f8d1f4589dc5";
    sha256 = "1vknhn24bgq0ai32b045jyv2zcq8xik6wkl17nn9cwbs1crb2zky";
  };

  buildInputs = [ (callPackage ./romkatv_libgit2.nix {}) ];
  patchPhase = ''
    sed -i "1i GITSTATUS_DAEMON=$out/bin/gitstatusd" gitstatus.plugin.zsh
  '';
  installPhase = ''
    install -Dm755 usrbin/gitstatusd $out/bin/gitstatusd
    install -Dm444 gitstatus.plugin.zsh $out
  '';

  meta = with stdenv.lib; {
    description = "10x faster implementation of `git status` command";
    homepage = https://github.com/romkatv/gitstatus;
    license = [ licenses.gpl3 ];

    maintainers = with maintainers; [ mmlb hexa ];
  };
}
