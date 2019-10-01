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
  name = "alacritty-${version}";
  version = "unstable-2019-09-26g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "jwilm";
    repo = "alacritty";
    rev = "9a0555bbba30c264f617ec9260ca00e0eab70870";
    sha256 = "060x35grpw4vxg6lhnrp6gkdr95c47avy5iwmcaijrpsqazn0nd2";
  };

  cargoSha256 = "1wcx8zwhhryhaq3i0yshqz5b73dyjprmz816n8nd0lk8rmf6az0z";

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
  postPatch = ''
    substituteInPlace alacritty_terminal/src/config/mouse.rs \
      --replace xdg-open ${xdg_utils}/bin/xdg-open
  '';

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
