{ stdenv
, fetchFromGitHub
, perl
, libtool
}:

stdenv.mkDerivation rec {
  pname = "libvterm-neovim";
  version = "unstable-2019-08-28g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "libvterm";
    rev = "4a5fa43e0dbc0db4fe67d40d788d60852864df9e";
    sha256 = "0hkzqng3zs8hz327wdlhzshcg0qr31fhsbi9mvifkyly6c3y78cx";
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
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
