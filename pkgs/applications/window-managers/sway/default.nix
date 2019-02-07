{ stdenv, fetchFromGitHub, fetchpatch
, meson, ninja
, pkgconfig, scdoc
, wayland, libxkbcommon, pcre, json_c, dbus, libevdev
, pango, cairo, libinput, libcap, pam, gdk_pixbuf
, wlroots, wayland-protocols
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "sway";
  version = "unstable-2019-05-27g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "sway";
    rev = "18476b0ec1fa58aa558f4c6b821e7243a64e4924";
    sha256 = "1fxylhxlzpq25h5yqbbilxbz293cydb40cvsbzsdd6gvfgiyf8g2";
  };

  # no need for pr3862 patches
  nativeBuildInputs = [ pkgconfig meson ninja scdoc ];

  buildInputs = [
    wayland libxkbcommon pcre json_c dbus libevdev
    pango cairo libinput libcap pam gdk_pixbuf
    wlroots wayland-protocols
  ];

  enableParallelBuilding = true;

  mesonFlags = [
    "-Ddefault-wallpaper=false" "-Dxwayland=enabled" "-Dgdk-pixbuf=enabled"
    "-Dtray=enabled" "-Dman-pages=enabled"
    "-DSWAY_VERSION=${version}"
  ];

  meta = with stdenv.lib; {
    description = "i3-compatible tiling Wayland compositor";
    homepage    = https://swaywm.org;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos synthetica ];
  };
}
