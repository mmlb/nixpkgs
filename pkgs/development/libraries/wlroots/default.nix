{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, fetchpatch
, wayland, libGL, wayland-protocols, libinput, libxkbcommon, pixman
, xcbutilwm, libX11, libcap, xcbutilimage, xcbutilerrors, mesa
, libpng, ffmpeg_4, freerdp
}:

stdenv.mkDerivation rec {
  pname = "wlroots";
  version = "unstable-2019-12-11g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = pname;
    rev = "efd294ef09e95870b72d7b1903d39221a2aecc11";
    sha256 = "0yjhd82n22cnppb2qfaaml9l8hqq5aby0rc3zzq11s0hyr475z1s";
  };

  # $out for the library and $examples for the example programs (in examples):
  outputs = [ "out" "examples" ];

  nativeBuildInputs = [ meson ninja pkgconfig ];

  buildInputs = [
    wayland libGL wayland-protocols libinput libxkbcommon pixman
    xcbutilwm libX11 libcap xcbutilimage xcbutilerrors mesa
    libpng ffmpeg_4 freerdp
  ];

  mesonFlags = [
    "-Dlibcap=enabled" "-Dlogind=enabled" "-Dxwayland=enabled" "-Dx11-backend=enabled"
    "-Dxcb-icccm=enabled" "-Dxcb-errors=enabled"
  ];

  postPatch = ''
    # It happens from time to time that the version wasn't updated:
    sed -i "/^project(/,/^)/ s/\\bversion: '\([0-9]\.[0-9]\.[0-9]\)'/version: '\1-${version}'/" meson.build
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
    inherit (src.meta) homepage;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
