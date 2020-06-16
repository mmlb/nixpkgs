{ stdenv, fetchFromGitHub, meson, ninja, pkg-config, wayland
, libGL, wayland-protocols, libinput, libxkbcommon, pixman
, xcbutilwm, libX11, libcap, xcbutilimage, xcbutilerrors, mesa
, libpng, ffmpeg
}:

stdenv.mkDerivation rec {
  pname = "wlroots";
  version = "unstable-2020-06-13g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = pname;
    rev = "cae533cad2b068dd13993a64fdc46c243c4984a2";
    sha256 = "14wx9llvqk5nk2xbhjml1bg2sfwd02id43w51nhg9ajrcz6nk9j5";
  };

  # $out for the library and $examples for the example programs (in examples):
  outputs = [ "out" "examples" ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ meson ninja pkg-config wayland ];

  buildInputs = [
    libGL wayland-protocols libinput libxkbcommon pixman
    xcbutilwm libX11 libcap xcbutilimage xcbutilerrors mesa
    libpng ffmpeg
  ];

  postPatch = ''
    # Add the revision to the version
    sed -i "/^project(/,/^)/ s/\\bversion: '\([0-9]\+\.[0-9]\+\.[0-9]\+\)'/version: '\1-${version}'/" meson.build
  '';

  mesonFlags = [ "-Dlogind-provider=systemd" ];

  postInstall = ''
    # Copy the library to $examples
    mkdir -p $examples/lib
    cp -P libwlroots* $examples/lib/
  '';

  postFixup = ''
    # Install ALL example programs to $examples:
    # screencopy dmabuf-capture input-inhibitor layer-shell idle-inhibit idle
    # screenshot output-layout multi-pointer rotation tablet touch pointer
    # simple
    mkdir -p $examples/bin
    cd ./examples
    for binary in $(find . -executable -type f -printf '%P\n' | grep -vE '\.so'); do
      cp "$binary" "$examples/bin/wlroots-$binary"
    done
  '';

  meta = with stdenv.lib; {
    description = "A modular Wayland compositor library";
    longDescription = ''
      Pluggable, composable, unopinionated modules for building a Wayland
      compositor; or about 50,000 lines of code you were going to write anyway.
    '';
    inherit (src.meta) homepage;
    changelog = "https://github.com/swaywm/wlroots/releases/tag/${version}";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
