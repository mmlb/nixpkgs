{callPackage, stdenv, fetchFromGitHub, ...}:

stdenv.mkDerivation rec {
  name = "gitstatus-${version}";
  version = "20190325";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "gitstatus";
    rev = "e1a61e76ccc74bd9d0f637724af7a9c0641ae85b";
    sha256 = "0gx308wa2v18wy5d4dgwlb3zzg5ri21fjy0bq5k9jk89xf0z2cwb";
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
