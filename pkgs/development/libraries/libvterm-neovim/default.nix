{ stdenv
, fetchFromGitHub
, perl
, libtool
}:

stdenv.mkDerivation rec {
  pname = "libvterm-neovim";
  version = "unstable-2019-09-17g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "libvterm";
    rev = "fcbccd3c79bfa811800fea24db3a77384941cb70";
    sha256 = "1da17cmwwmfyz4jvj8lf3vqwjdv1583srp7gvf8rhypwvr6sb806";
  };

  buildInputs = [ perl ];
  nativeBuildInputs = [ libtool ];

  makeFlags = [ "PREFIX=$(out)" ]
    ++ stdenv.lib.optional stdenv.isDarwin "LIBTOOL=${libtool}/bin/libtool";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "VT220/xterm/ECMA-48 terminal emulator library";
    homepage = http://www.leonerd.org.uk/code/libvterm/;
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs ];
    platforms = platforms.unix;
  };
}
