{ stdenv, fetchFromGitHub, makeWrapper
, meson, ninja
, pkgconfig, scdoc
, wayland, libxkbcommon, pcre, json_c, dbus, libevdev
, pango, cairo, libinput, libcap, pam, gdk-pixbuf
, wlroots, wayland-protocols
}:

stdenv.mkDerivation rec {
  pname = "sway";
  version = "unstable-2020-05-02g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = pname;
    rev = "52bd6aecf24af2aefc202d73aeef205cd62fa8b8";
    sha256 = "1vly3qz6mzpvwfxh5la73qz2cy800c1y9ly9dlqcz06pzw69cram";
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
    "-Ddefault-wallpaper=false"
    "-Dgdk-pixbuf=enabled"
    "-Dlogind-provider=systemd"
    "-Dman-pages=enabled"
    "-Dtray=enabled"
    "-Dxwayland=enabled"
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
