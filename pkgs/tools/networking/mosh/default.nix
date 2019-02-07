{ lib, stdenv, fetchFromGitHub, zlib, protobuf, ncurses, pkgconfig
, makeWrapper, perlPackages, openssl, autoreconfHook, openssh, bash-completion
, libutempter ? null, withUtempter ? stdenv.isLinux }:

stdenv.mkDerivation rec {
  name = "mosh-${version}";
  version = "unstable-2019-07-10g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "mobile-shell";
    repo = "mosh";
    rev = "b1da7005358b4a550e31faa646cf1cf116700412";
    sha256 = "113md2x97vlijd78wkjh1498xmsp7awn5nk34gwg7z9b7d5pm5qf";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ protobuf ncurses zlib makeWrapper openssl bash-completion ]
    ++ (with perlPackages; [ perl IOTty ])
    ++ lib.optional withUtempter libutempter;

  patches = [
    ./ssh_path.patch
    ./utempter_path.patch
  ];
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
