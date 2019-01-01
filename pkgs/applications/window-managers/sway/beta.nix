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
  version = "20181230";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "sway";
    rev = "69e0982439c096083d29667e8d2e2e25ef77cd61";
    sha256 = "1520159ic07cnya9phl8h35h7pd2q99phr5k8jdlkvqx4rnz0kj5";
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

  mesonFlags = "-Dsway-version=${version}";

  meta = with stdenv.lib; {
    description = "i3-compatible window manager for Wayland";
    homepage    = https://swaywm.org;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos synthetica ]; # Trying to keep it up-to-date.
  };
}
