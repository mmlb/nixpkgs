{callPackage, stdenv, fetchFromGitHub, libgit2_0_27, ...}:

let romkatvLibgit2 = callPackage ./libgit2_patched.nix {};

in

stdenv.mkDerivation rec {
  name = "gitstatus-${version}";
  version = "20190411"+ (builtins.substring 0 9 "g${src.rev}");

  src = fetchFromGitHub {
    owner  = "romkatv";
    repo   = "gitstatus";
    rev    = "7b177d3df477a2df85ae747b90f3dd234c92f090";
    sha256 = "05afkc2llqjfvsvrrbbk0i9nmwflrf37pb9p917fg9iz5k3i03l4";
  };

  buildInputs = [ romkatvLibgit2 ];
  installPhase = ''
    install -Dm755 gitstatusd $out/bin/gitstatusd
    install -Dm444 gitstatus.plugin.zsh $out
    sed -i "s|local daemon.*|local daemon=$out/bin/gitstatusd|" $out/gitstatus.plugin.zsh
  '';

  meta = with stdenv.lib; {
    description = "eradicate removes commented-out code from Python files.";
    homepage = https://github.com/myint/eradicate;
    license = [ licenses.gpl3 ];

    maintainers = [ maintainers.mmlb ];
  };
}
