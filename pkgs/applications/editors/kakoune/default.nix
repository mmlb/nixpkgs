{ lib, stdenv, fetchFromGitHub, ncurses, asciidoc, docbook_xsl, libxslt, pkg-config }:

with lib;

stdenv.mkDerivation rec {
  pname = "kakoune-unwrapped";
  version = "unstable-2021-01-22g${builtins.substring 0 9 src.rev}";
  src = fetchFromGitHub {
    owner = "mawww";
    repo = "kakoune";
    rev = "74fc52b3de6927632b5a8484f68f68bd34f383d5";
    sha256 = "1cxa30fp36phbi8cyzshpsj7abfz9r2qwl3hs7gvj83i9gawgiq0";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ncurses asciidoc docbook_xsl libxslt ];
  makeFlags = [ "debug=no" ];
  enableParallelBuilding = true;

  postPatch = ''
    export PREFIX=$out
    cd src
    sed -ie 's#--no-xmllint#--no-xmllint --xsltproc-opts="--nonet"#g' Makefile
  '';

  preConfigure = ''
    export version="v${version}"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/kak -ui json -e "kill 0"
  '';

  postInstall = ''
    # make share/kak/autoload a directory, so we can use symlinkJoin with plugins
    cd "$out/share/kak"
    autoload_target=$(readlink autoload)
    rm autoload
    mkdir autoload
    ln -s --relative "$autoload_target" autoload
  '';

  meta = {
    homepage = "http://kakoune.org/";
    description = "A vim inspired text editor";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ vrthra ];
    platforms = platforms.unix;
  };
}
