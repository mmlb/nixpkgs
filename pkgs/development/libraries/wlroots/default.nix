{ stdenv, fetchFromGitHub, meson, ninja, pkg-config, wayland
, libGL, wayland-protocols, libinput, libxkbcommon, pixman
, xcbutilwm, libX11, libcap, xcbutilimage, xcbutilerrors, mesa
, libpng, ffmpeg_4
}:

stdenv.mkDerivation rec {
  pname = "wlroots";
  version = "unstable-2020-03-10g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = pname;
    rev = "0c7c562482575cacaecadcd7913ef25aeb21711f";
    sha256 = "0j2lh9vc92zhn44rjbia5aw3y1rpgfng1x1h17lcvj5m4i6vj0pc";
  };

  # $out for the library and $examples for the example programs (in examples):
  outputs = [ "out" "examples" ];

  nativeBuildInputs = [ meson ninja pkg-config wayland ];

  buildInputs = [
    libGL wayland-protocols libinput libxkbcommon pixman
    xcbutilwm libX11 libcap xcbutilimage xcbutilerrors mesa
    libpng ffmpeg_4
  ];

  postPatch = ''
    # Add the revision to the version
    sed -i "/^project(/,/^)/ s/\\bversion: '\([0-9]\+\.[0-9]\+\.[0-9]\+\)'/version: '\1-${version}'/" meson.build
  '';

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
