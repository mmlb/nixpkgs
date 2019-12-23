{ stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,

  cmake,
  gzip,
  installShellFiles,
  makeWrapper,
  ncurses,
  pkgconfig,
  python3,

  expat,
  fontconfig,
  freetype,
  libGL,
  libX11,
  libXcursor,
  libXi,
  libXrandr,
  libXxf86vm,
  libxcb,
  libxkbcommon,
  wayland,
  xdg_utils,

  # Darwin Frameworks
  AppKit,
  CoreGraphics,
  CoreServices,
  CoreText,
  Foundation,
  OpenGL }:

with rustPlatform;

let
  rpathLibs = [
    expat
    fontconfig
    freetype
    libGL
    libX11
    libXcursor
    libXi
    libXrandr
    libXxf86vm
    libxcb
  ] ++ lib.optionals stdenv.isLinux [
    libxkbcommon
    wayland
  ];
in buildRustPackage rec {
  pname = "alacritty";
  version = "unstable-2019-11-25g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "jwilm";
    repo = pname;
    rev = "b115b9038566d6ce0ed56f4a50c428c98e04b51a";
    sha256 = "0adaqdbma6gskb2g14yscrgr9gch5wf2g2clchplv72c2qr1k427";
  };

  cargoSha256 = "1r267g8f986nxh8ms5yhp50qy1yl8gly2jr78p738qqc6frlxlhv";

  nativeBuildInputs = [
    cmake
    gzip
    installShellFiles
    makeWrapper
    ncurses
    pkgconfig
    python3
  ];

  buildInputs = rpathLibs
    ++ lib.optionals stdenv.isDarwin [ AppKit CoreGraphics CoreServices CoreText Foundation OpenGL ];

  outputs = [ "out" "terminfo" ];

  postBuild = lib.optionalString stdenv.isDarwin "make app";

  installPhase = ''
    runHook preInstall

    install -D target/release/alacritty $out/bin/alacritty

  '' + (if stdenv.isDarwin then ''
    mkdir $out/Applications
    cp -r target/release/osx/Alacritty.app $out/Applications/Alacritty.app
  '' else ''
    install -D extra/linux/alacritty.desktop -t $out/share/applications/
    install -D extra/logo/alacritty-term.svg $out/share/icons/hicolor/scalable/apps/Alacritty.svg
    patchelf --set-rpath "${stdenv.lib.makeLibraryPath rpathLibs}" $out/bin/alacritty
  '') + ''

    installShellCompletion --zsh extra/completions/_alacritty
    installShellCompletion --bash extra/completions/alacritty.bash
    installShellCompletion --fish extra/completions/alacritty.fish

    install -dm 755 "$out/share/man/man1"
    gzip -c extra/alacritty.man > "$out/share/man/man1/alacritty.1.gz"

    install -dm 755 "$terminfo/share/terminfo/a/"
    tic -xe alacritty,alacritty-direct -o "$terminfo/share/terminfo" extra/alacritty.info
    mkdir -p $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages

    runHook postInstall
  '';

  dontPatchELF = true;

  meta = with stdenv.lib; {
    description = "GPU-accelerated terminal emulator";
    homepage = "https://github.com/jwilm/alacritty";
    license = licenses.asl20;
    maintainers = with maintainers; [ filalex77 mic92 ];
    platforms = platforms.unix;
  };
}
