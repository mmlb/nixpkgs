{ stdenv, fetchFromGitHub
, meson, ninja
, pkgconfig, scdoc
, wayland, libxkbcommon, pcre, json_c, dbus
, pango, cairo, libevdev, libinput, libcap, pam, gdk_pixbuf
, wlroots, wayland-protocols
, buildDocs ? true
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "sway";
  version = "20190124" + (builtins.substring 0 8 "${src.rev}");

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "sway";
    rev = "5f45a4bbc195400dd28e086c2e0e2f479b86e4eb";
    sha256 = "03fb41bm87ylxjampsivwahn68w9071bmakh83q7ca4hpp7j10y3";
  };

  nativeBuildInputs = [
    pkgconfig meson ninja
  ] ++ stdenv.lib.optional buildDocs scdoc;

  buildInputs = [
    wayland libxkbcommon pcre json_c dbus
    pango cairo libevdev libinput libcap pam gdk_pixbuf
    wlroots wayland-protocols
  ];

  enableParallelBuilding = true;

  mesonFlags = "-Dman-pages=enabled -Dsway-version=${version}-${src.rev} -Dxwayland=enabled";

  meta = with stdenv.lib; {
    description = "i3-compatible window manager for Wayland";
    homepage    = https://swaywm.org;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos synthetica ]; # Trying to keep it up-to-date.
  };
}
