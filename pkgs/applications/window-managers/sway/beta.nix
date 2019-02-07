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
  version = "20190207" + (builtins.substring 0 8 "${src.rev}");

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "sway";
    rev = "ec5da0ca5bad6a433f727499d68ac1352397f5aa";
    sha256 = "0828zvahgxsq5l01yjaa7sfzc10ya6ylb4bkag8mvydk1d96y3g4";
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
