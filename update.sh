#! /bin/sh
set -e

NODE_VERSION=0.10.32

Tlinux64() {(
  rm -Rf ./linux64 || true
  mkdir ./linux64
  cd linux64

  echo "$NODE_VERSION" > NODE_VERSION

  # Download the node binary
  TARF="node-v${NODE_VERSION}-linux-x64.tar.gz"
  DIRN="`echo "$TARF" | sed 's@\.\(tar\.\|t\)\(gz\|xz\|bz2\|bz\)$@@'`"
  wget "http://nodejs.org/dist/v${NODE_VERSION}/$TARF"
  tar -xf "$TARF"
  mv "$DIRN"/* .
  rm "$TARF"
  rmdir "$DIRN"
  
  PREFIX="$PWD"
  export PATH="$PREFIX/bin:$PREFIX/lib/node_modules/.bin:$PATH"

  # Install node-gyp stuff
  cd "$PREFIX/lib"
  npm install node-gyp

  # Install headers using node-gyp
  cd "$PREFIX"
  HOME="$PREFIX" node-gyp install "$NODE_VERSION"
  mv ".node-gyp/$NODE_VERSION/deps"/* ./include/
  rm -R .node-gyp
)}

Tlinux64
