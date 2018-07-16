#!/bin/bash -eu
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.

build_package ()
{
  PACKAGE=$1

  cd $PACKAGE

  # Install build dependencies
  mk-build-deps -i -r -t "apt-get --no-install-recommends -y " -s sudo
  sudo apt-get remove -y $PACKAGE-build-deps

  # Build the package
  dpkg-buildpackage

  # Get binary package name
  VERSION=$(dpkg-parsechangelog | sed -n 's/^Version: *//p')
  ARCH=$(dpkg-architecture -q DEB_BUILD_ARCH)
  DEB=${PACKAGE}_${VERSION}_$ARCH.deb

  # Install the binary package
  cd ..
  sudo dpkg -i $DEB
}

build_package binutils-m68k-atari-mint
build_package mintbin-m68k-atari-mint
build_package gcc-m68k-atari-mint
build_package mintlib-m68k-atari-mint
build_package pml-m68k-atari-mint
build_package gemlib-m68k-atari-mint
build_package cross-mint-essential
build_package cflib-m68k-atari-mint
build_package gemma-m68k-atari-mint
build_package ldg-m68k-atari-mint
build_package sdl-m68k-atari-mint
build_package ncurses-m68k-atari-mint
build_package zlib-m68k-atari-mint
build_package readline-m68k-atari-mint
build_package openssl-m68k-atari-mint
