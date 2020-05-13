{ stdenv, fetchFromGitHub, makeWrapper
, meson, ninja
, pkg-config, scdoc
, wayland, libxkbcommon, pcre, json_c, dbus, libevdev
, pango, cairo, libinput, libcap, pam, gdk-pixbuf
, wlroots, wayland-protocols
}:

stdenv.mkDerivation rec {
  pname = "sway";
  version = "unstable-2020-02-19g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = pname;
    rev = "f2a60d2d05366b824cda3762ecc33758b6d9ae53";
    sha256 = "1afpn7rvmvq4qqb694l4zh54wcgc31xqi1yh5vbc835hiwyvg68g";
  };

  patches = [
    ./sway-config-no-nix-store-references.patch
    ./load-configuration-from-etc.patch
  ];

  nativeBuildInputs = [
    pkg-config meson ninja scdoc
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

  postPatch = ''
    sed -i "/^project(/,/^)/ s/\\bversion: '\([0-9]\.[0-9]\)'/version: '\1-${version}'/" meson.build
  '';

  meta = with stdenv.lib; {
    description = "i3-compatible tiling Wayland compositor";
    homepage    = "https://swaywm.org";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos synthetica ma27 ];
  };
}
