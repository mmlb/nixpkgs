{ lib, stdenv, fetchFromGitHub, zlib, protobuf, ncurses, pkgconfig, IOTty
, makeWrapper, perl, openssl, autoreconfHook, openssh, bash-completion
, libutempter ? null, withUtempter ? stdenv.isLinux }:

stdenv.mkDerivation rec {
  name = "mosh-20180412";

  src = fetchFromGitHub {
    owner = "mobile-shell";
    repo = "mosh";
    rev = "944fd6c796338235c4f3d8daf4959ff658f12760";
    sha256 = "0fwrdqizwnn0kmf8bvlz334va526mlbm1kas9fif0jmvl1q11ayv";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ protobuf ncurses zlib makeWrapper openssl bash-completion ]
    ++ (with perlPackages; [ perl IOTty ])
    ++ lib.optional withUtempter libutempter;

  patches = [ ./ssh_path.patch ./utempter_path.patch ];
  postPatch = ''
    substituteInPlace scripts/mosh.pl \
        --subst-var-by ssh "${openssh}/bin/ssh"
  '';

  configureFlags = [ "--enable-completion" ] ++ lib.optional withUtempter "--with-utempter";

  postInstall = ''
      wrapProgram $out/bin/mosh --prefix PERL5LIB : $PERL5LIB
  '';

  CXXFLAGS = stdenv.lib.optionalString stdenv.cc.isClang "-std=c++11";

  meta = {
    homepage = https://mosh.org/;
    description = "Mobile shell (ssh replacement)";
    longDescription = ''
      Remote terminal application that allows roaming, supports intermittent
      connectivity, and provides intelligent local echo and line editing of
      user keystrokes.

      Mosh is a replacement for SSH. It's more robust and responsive,
      especially over Wi-Fi, cellular, and long-distance links.
    '';
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = stdenv.lib.platforms.unix;
  };
}
