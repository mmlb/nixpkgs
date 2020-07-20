{ callPackage, stdenv, fetchFromGitHub, ...}:

stdenv.mkDerivation rec {
  pname = "gitstatus";
  version = "unstable-2020-07-07g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = pname;
    rev = "8ccd4d34ed798f26e1d50ee09acd1db31bfda50e";
    sha256 = "1byh7h85f81ajw4k994q7dnqxbycshkq0zzyarxzsl4b2jp7nmc3";
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
    homepage = "https://github.com/romkatv/gitstatus";
    license = [ licenses.gpl3 ];
    maintainers = with maintainers; [ mmlb hexa ];
  };
}
