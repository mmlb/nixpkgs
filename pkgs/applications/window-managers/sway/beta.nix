{ stdenv, fetchFromGitHub
, meson, ninja
, pkgconfig, scdoc
, wayland, libxkbcommon, pcre, json_c, dbus, libevdev
, pango, cairo, libinput, libcap, pam, gdk_pixbuf
, wlroots, wayland-protocols
, buildDocs ? true
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "sway";
  version = "20190207g" + (builtins.substring 0 8 "${src.rev}");

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "sway";
    rev = "f00fbe6861bad18fc0615be8fe5ba0102c609067";
    sha256 = "1ldd3vhgc61nh0nziqlhcns159qgayw61g7ycinv76bscnlpb81n";
  };

  nativeBuildInputs = [
    pkgconfig meson ninja
  ] ++ stdenv.lib.optional buildDocs scdoc;

  buildInputs = [
    wayland libxkbcommon pcre json_c dbus libevdev
    pango cairo libinput libcap pam gdk_pixbuf
    wlroots wayland-protocols
  ];

  enableParallelBuilding = true;

  mesonFlags = [
    "-Dsway-version=${version}" "-Dxwayland=enabled" "-Dgdk-pixbuf=enabled"
    "-Dman-pages=enabled" "-Dtray=enabled"
  ];

  meta = with stdenv.lib; {
    description = "i3-compatible window manager for Wayland";
    homepage    = https://swaywm.org;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos synthetica ]; # Trying to keep it up-to-date.
  };
}
