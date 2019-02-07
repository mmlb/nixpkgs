{callPackage, stdenv, fetchFromGitHub, ...}:

stdenv.mkDerivation rec {
  name = "gitstatus-${version}";
  version = "unstable-2019-06-06g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "gitstatus";
    rev = "708e9a6a77af608cd10aa3069046109a9e4dc40f";
    sha256 = "08wfxad7ssmnyzkjc7smlxl5k295gdfm1s0j9jxnr66s8x05m9m5";
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
