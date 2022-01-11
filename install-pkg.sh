#!/usr/bin/env bash
set -e
BUILD_DIR=/home/runner
CACHE_DIR=/tmp
LP_DIR=`cd $(dirname $0); cd ..; pwd`

function error() {
  echo "[!] $*" >&2
  exit 1
}

function log() {
  echo "[-] $*"
}

function indent() {
  c='s/^/       /'
  case $(uname) in
    Darwin) sed -l "$c";;
    *)      sed -u "$c";;
  esac
}

APT_CACHE_DIR="$CACHE_DIR/apt/cache"
APT_STATE_DIR="$CACHE_DIR/apt/state"
APT_SOURCELIST_DIR="$CACHE_DIR/apt/sources"   # place custom sources.list here
APT_SOURCES="$APT_SOURCELIST_DIR/sources.list"
APT_OPTIONS="-o debug::nolocking=true -o dir::cache=$APT_CACHE_DIR -o dir::state=$APT_STATE_DIR"
APT_OPTIONS="$APT_OPTIONS -o dir::etc::sourcelist=$APT_SOURCES"

rm -rf $APT_CACHE_DIR
mkdir -p "$APT_CACHE_DIR/archives/partial"
mkdir -p "$APT_STATE_DIR/lists/partial"
mkdir -p "$APT_SOURCELIST_DIR"   # make dir for sources
cat "/etc/apt/sources.list" > "$APT_SOURCES"    # no cp here

# log "Updating apt caches"
# apt-get $APT_OPTIONS update | indent

for PACKAGE in $@; do
  if [[ $PACKAGE == *deb ]]; then
    PACKAGE_NAME=$(basename $PACKAGE .deb)
    PACKAGE_FILE=$APT_CACHE_DIR/archives/$PACKAGE_NAME.deb

    log "Fetching $PACKAGE"
    curl -s -L -z $PACKAGE_FILE -o $PACKAGE_FILE $PACKAGE 2>&1 | indent
  else
    log "Fetching .debs for $PACKAGE"
    apt-get $APT_OPTIONS -y --force-yes -d install --reinstall $PACKAGE | indent
  fi
done

mkdir -p $BUILD_DIR/.apt

for DEB in $(ls -1 $APT_CACHE_DIR/archives/*.deb); do
  log "Installing $(basename $DEB)"
  dpkg -x $DEB $BUILD_DIR/.apt/
done

log "Rewrite package-config files"
find $BUILD_DIR/.apt -type f -ipath '*/pkgconfig/*.pc' | xargs --no-run-if-empty -n 1 sed -i -e 's!^prefix=\(.*\)$!prefix='"$BUILD_DIR"'/.apt\1!g'