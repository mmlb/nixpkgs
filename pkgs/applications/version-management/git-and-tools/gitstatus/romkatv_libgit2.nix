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
    rev = "4649ef460abf58ceaa0ca76ddd152f93c00cb397";
    sha256 = "18k5bqs7dqrld763awk3cm05jbplpzm8lm4ngqhivjs6mwvbyqdc";
  };
})
