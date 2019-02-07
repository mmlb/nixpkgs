{ stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  expat,
  fontconfig,
  freetype,
  gzip,
  libGL,
  libX11,
  libXcursor,
  libXi,
  libXrandr,
  libXxf86vm,
  libxkbcommon,
  libxcb,
  makeWrapper,
  ncurses,
  pkgconfig,
  python3,
  wayland,
  xclip,
  # Darwin Frameworks
  cf-private,
  AppKit,
  CoreFoundation,
  CoreGraphics,
  CoreServices,
  CoreText,
  Foundation,
  OpenGL }:

with rustPlatform;

let
  rpathLibs = [
    expat
    freetype
    fontconfig
    libX11
    libXcursor
    libXxf86vm
    libXrandr
    libGL
    libXi
  ] ++ lib.optionals stdenv.isLinux [
    libxkbcommon
    libxcb
    wayland
  ];
in buildRustPackage rec {
  name = "alacritty-${version}";
  version = "20190501g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "jwilm";
    repo = "alacritty";
    rev = "ba6e208a95e37116b031aca02246d3cff04c0216";
    sha256 = "08rxzywgmp9j30lyix6nivdhgjh8863qpjdairpzchyl3wi9ssh9";
  };

  cargoSha256 = "04mfdm0b7jj0mkchrzzq9bm99m5y9h4ajj848kkf679k5wfiqc12";

  nativeBuildInputs = [
    cmake
    gzip
    makeWrapper
    ncurses
    pkgconfig
    python3
  ];

  buildInputs = rpathLibs
    ++ lib.optionals stdenv.isDarwin [
      AppKit CoreFoundation CoreGraphics CoreServices CoreText Foundation OpenGL
      # Needed for CFURLResourceIsReachable symbols.
      cf-private
    ];

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
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
