#!/bin/sh
# msys build script for appveyor

die() { echo "$@"; exit 1; }

# Run in top-level directory
cd `dirname "$0"`/..

# Show arch
echo "MINGW_INSTALLS: $MINGW_INSTALLS"
echo ""

# Update pacman db and packages
pacman --noconfirm -Syu
pacman --noconfirm -Su
echo ""

# Install dependencies
if [ "$MINGW_INSTALLS" = "mingw32" ]; then
    pacman -S --noconfirm \
    mingw-w64-i686-gflags \
    mingw-w64-i686-cmake  \
    unzip
fi

if [ "$MINGW_INSTALLS" = "mingw64" ]; then
    pacman -S --noconfirm \
    mingw-w64-x86_64-gflags \
    mingw-w64-x86_64-cmake \
    unzip
fi
echo ""


for f in mingw-w64-*; do
  cd $f
  makepkg-mingw || exit 1
  
  # Copy built package
  mkdir ../build
  cp *.pkg.tar.xz ../build/
  cd ..
done
