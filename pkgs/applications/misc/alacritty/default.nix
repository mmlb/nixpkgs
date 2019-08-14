{ stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,

  cmake,
  gzip,
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
  name = "alacritty-${version}";
  version = "unstable-2019-08-08g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "jwilm";
    repo = "alacritty";
    rev = "5cf77bf250712bf2630322f92c1025baa364922e";
    sha256 = "0iig3xf45q3z32gnxs2n0b6xqg23qr4gz7cqf9sxzmbbx9vwgfda";
  };

  cargoSha256 = "0anmjf9v65x6gd8xp23rxwfrnd0955q2ygnzyq3d44hk141cg89j";

  nativeBuildInputs = [
    cmake
    gzip
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

    install -D extra/completions/_alacritty -t "$out/share/zsh/site-functions/"
    install -D extra/completions/alacritty.bash -t "$out/etc/bash_completion.d/"
    install -D extra/completions/alacritty.fish -t "$out/share/fish/vendor_completions.d/"

    install -dm 755 "$out/share/man/man1"
    gzip -c extra/alacritty.man > "$out/share/man/man1/alacritty.1.gz"

    install -dm 755 "$terminfo/share/terminfo/a/"
    tic -o "$terminfo/share/terminfo" extra/alacritty.info
    mkdir -p $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages

    runHook postInstall
  '';

  dontPatchELF = true;

  meta = with stdenv.lib; {
    description = "GPU-accelerated terminal emulator";
    homepage = https://github.com/jwilm/alacritty;
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ mic92 ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-linux" ];
  };
}
