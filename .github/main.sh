#!/bin/bash -eu
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.

echorun () {
  echo "::group::Run $@"
  "$@"
  echo "::endgroup::"
}

# Display packages versions
echorun git --version
echorun gpg --version
echorun dpkg --version

# Set DEBEMAIL variable for signing packages
echorun . .github/guess_debemail.sh

# Deploy updated packages to Ubuntu Launchpad PPA
echorun . .github/init_ppa.sh ppa:vriviere/ppa

echorun .github/deploy_changed_packages.sh -m68k-atari-mint

# The lines below are sorted according to dependencies
#echorun .github/deploy_ppa_all_dists.sh binutils-m68k-atari-mint
#echorun .github/deploy_ppa_all_dists.sh mintbin-m68k-atari-mint

#echorun .github/deploy_ppa_all_dists.sh gcc-m68k-atari-mint

#echorun .github/deploy_ppa_all_dists.sh mintlib-m68k-atari-mint

#echorun .github/deploy_ppa_all_dists.sh pml-m68k-atari-mint

#echorun .github/deploy_ppa_all_dists.sh gemlib-m68k-atari-mint
#echorun .github/deploy_ppa_all_dists.sh ncurses-m68k-atari-mint
#echorun .github/deploy_ppa_all_dists.sh zlib-m68k-atari-mint

#echorun .github/deploy_ppa_all_dists.sh cross-mint-essential
#echorun .github/deploy_ppa_all_dists.sh cflib-m68k-atari-mint
#echorun .github/deploy_ppa_all_dists.sh gemma-m68k-atari-mint
#echorun .github/deploy_ppa_all_dists.sh ldg-m68k-atari-mint
#echorun .github/deploy_ppa_all_dists.sh readline-m68k-atari-mint

#echorun .github/deploy_ppa_all_dists.sh sdl-m68k-atari-mint
#echorun .github/deploy_ppa_all_dists.sh openssl-m68k-atari-mint

echo "Packages will be available at $PPA_URL"
