{ stdenv, fetchFromGitHub, makeWrapper
, meson, ninja
, pkgconfig, scdoc
, wayland, libxkbcommon, pcre, json_c, dbus, libevdev
, pango, cairo, libinput, libcap, pam, gdk-pixbuf
, wlroots, wayland-protocols, swaybg
}:

stdenv.mkDerivation rec {
  pname = "sway";
  version = "unstable-2019-11-26g${builtins.substring 0 9 src.rev}";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "sway";
    rev = "90e3d25009a201363e5cbe001f344f97f7f7c579";
    sha256 = "1xlmrsdrjhaq5acc76fhl2zbbnbsp3mslaw35h69bahyjv4fwp4b";
  };

  nativeBuildInputs = [ pkgconfig meson ninja scdoc makeWrapper ];

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

  postInstall = ''
    wrapProgram $out/bin/sway --prefix PATH : "${swaybg}/bin"
  '';

  postPatch = ''
    sed -i "/^project(/,/^)/ s/\\bversion: '\([0-9]\.[0-9]\)'/version: '\1-${version}'/" meson.build
  '';

  meta = with stdenv.lib; {
    description = "i3-compatible tiling Wayland compositor";
    homepage    = https://swaywm.org;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos synthetica ];
  };
}
