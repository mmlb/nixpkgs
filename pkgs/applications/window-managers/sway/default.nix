{ stdenv, fetchFromGitHub, fetchpatch
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
  version = "20190324g" + (builtins.substring 0 8 "${src.rev}");

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "sway";
    rev = "d9de5b87583ccf8b633980ebbdec67227bbe7db4";
    sha256 = "1cgi37wpk033nfvcv7n3fircyrbpcy3pv0hy2dir3yyd0hdzighn";
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
    "-Dxwayland=enabled" "-Dgdk-pixbuf=enabled" "-Dtray=enabled" "-DSWAY_VERSION=${version}"
  ] ++ stdenv.lib.optional buildDocs "-Dman-pages=enabled";

  meta = with stdenv.lib; {
    description = "i3-compatible tiling Wayland compositor";
    homepage    = https://swaywm.org;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos synthetica ];
  };
}
