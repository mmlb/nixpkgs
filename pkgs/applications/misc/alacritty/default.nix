{ stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  makeWrapper,
  ncurses,
  expat,
  pkgconfig,
  freetype,
  fontconfig,
  libX11,
  gzip,
  libXcursor,
  libXxf86vm,
  libXi,
  libXrandr,
  libGL,
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
  ];
in buildRustPackage rec {
  name = "alacritty-${version}";
  version = "20190207g" + (builtins.substring 0 8 "${src.rev}");

  src = fetchFromGitHub {
    owner = "jwilm";
    repo = "alacritty";
    rev = "153f9257b8a78432e9a7830f1eb3c539716f6724";
    sha256 = "12h0cl243w3c74cihx6b9vzpf6k3spncczsmg0y5py85lxn5kill";
  };

  cargoSha256 = "0bwsibbnikaz2j51fblm6iisjbg7p02k1amclk3naplm3dnlshgx";

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkgconfig
    ncurses
    gzip
  ];

  buildInputs = rpathLibs
    ++ lib.optionals stdenv.isDarwin [
      AppKit CoreFoundation CoreGraphics CoreServices CoreText Foundation OpenGL
      # Needed for CFURLResourceIsReachable symbols.
      cf-private
    ];

  outputs = [ "out" "terminfo" ];

  postPatch = ''
    substituteInPlace copypasta/src/x11.rs \
      --replace Command::new\(\"xclip\"\) Command::new\(\"${xclip}/bin/xclip\"\)
  '';

  postBuild = lib.optionalString stdenv.isDarwin "make app";

  installPhase = ''
    runHook preInstall

    install -D target/release/alacritty $out/bin/alacritty

  '' + (if stdenv.isDarwin then ''
    mkdir $out/Applications
    cp -r target/release/osx/Alacritty.app $out/Applications/Alacritty.app
  '' else ''
    install -D alacritty.desktop $out/share/applications/alacritty.desktop
    patchelf --set-rpath "${stdenv.lib.makeLibraryPath rpathLibs}" $out/bin/alacritty
  '') + ''

    install -D alacritty-completions.zsh "$out/share/zsh/site-functions/_alacritty"
    install -D alacritty-completions.bash "$out/etc/bash_completion.d/alacritty-completions.bash"
    install -D alacritty-completions.fish "$out/share/fish/vendor_completions.d/alacritty.fish"

    install -dm 755 "$out/share/man/man1"
    gzip -c alacritty.man > "$out/share/man/man1/alacritty.1.gz"

    install -dm 755 "$terminfo/share/terminfo/a/"
    tic -x -o "$terminfo/share/terminfo" alacritty.info
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
