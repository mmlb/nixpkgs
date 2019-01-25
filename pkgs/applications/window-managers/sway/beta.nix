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
  version = "20190124";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "sway";
    rev = "75406bb93b96091d30e52922d0f319530fe65471";
    sha256 = "0n2j15naa4r11yji3fc7pfk51l0alpi2xpxdfj32jdkgnmvnc1kr";
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
