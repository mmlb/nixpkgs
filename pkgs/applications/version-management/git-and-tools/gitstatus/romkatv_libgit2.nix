{fetchFromGitHub, libgit2, ...}:

libgit2.overrideAttrs (oldAttrs: rec {
  cmakeFlags = oldAttrs.cmakeFlags ++ [
    "-DUSE_BUNDLED_ZLIB=ON"
    "-DUSE_ICONV=OFF"
    "-DBUILD_CLAR=OFF"
    "-DUSE_SSH=OFF"
    "-DUSE_HTTPS=OFF"
    "-DBUILD_SHARED_LIBS=OFF"
    "-DUSE_EXT_HTTP_PARSER=OFF"
  ];
  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "libgit2";
    rev = "3751d18a728562c075359f2041ef9b4408e73942";
    sha256 = "17jx2q6lg8d15ix081anhq001r6ypxlh7i372386xnhvl4dx6jbd";
  };
})
