{ stdenv, fetchFromGitHub, makeWrapper
, meson, ninja
, pkgconfig, scdoc
, wayland, libxkbcommon, pcre, json_c, dbus, libevdev
, pango, cairo, libinput, libcap, pam, gdk-pixbuf
, wlroots, wayland-protocols
}:

stdenv.mkDerivation rec {
  pname = "sway";
  version = "unstable-2019-08-27g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "sway";
    rev = "be138dab4419d3e76a7742428d9ec85bce06116b";
    sha256 = "0vch2zm5afc76ia78p3vg71zr2fyda67l9hd2h0x1jq3mnvfbxnd";
  };

  patches = [
    ./sway-config-no-nix-store-references.patch
    ./load-configuration-from-etc.patch
  ];

  nativeBuildInputs = [
    pkgconfig meson ninja scdoc
  ];

  buildInputs = [
    wayland libxkbcommon pcre json_c dbus libevdev
    pango cairo libinput libcap pam gdk-pixbuf
    wlroots wayland-protocols
  ];

  enableParallelBuilding = true;

  mesonFlags = [
    "-Ddefault-wallpaper=false" "-Dxwayland=enabled" "-Dgdk-pixbuf=enabled"
    "-Dtray=enabled" "-Dman-pages=enabled"
  ];

  meta = with stdenv.lib; {
    description = "i3-compatible tiling Wayland compositor";
    homepage    = "https://swaywm.org";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos synthetica ma27 ];
  };
}
