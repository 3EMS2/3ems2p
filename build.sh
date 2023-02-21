#!/bin/sh

BUILDROOT=$(pwd)
PREFIX=${PREFIX:-$BUILDROOT/tmp}

SLHDRDIR=${SLHDRDIR:-$PREFIX}

SLHDRINC=${SLHDRDIR:-$1}/include
SLHDRLIB=${SLHDRDIR:-$1}/lib

FFDIR=$BUILDROOT/ffmpeg
OVDIR=$BUILDROOT/ovvc
MPDIR=$BUILDROOT/mpv
SLDIR=$BUILDROOT/slhdr

LIBDIR=${LIBDIR:-$PREFIX/lib}
INCDIR=${INCDIR:-$PREFIX/include}

mkdir -p $LIBDIR
mkdir -p $INCDIR

# Instal SLHDR library to destination
# This could be avoided but it makes everything
# easier.
cp -r $SLHDRLIB $PREFIX
cp -r $SLHDRINC $PREFIX

export LD_LIBRARY_PATH=$LIBDIR:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=$LIBDIR/pkgconfig:$PKG_CONFIG_PATH

cd $SLDIR
./configure --srcdir=$SLHDRDIR --incdir=$SLHDRINC --prefix=$PREFIX
make -j $(nproc)
make install

cd $OVDIR
autoreconf -if .
mkdir -p build && cd build
../configure --prefix=$PREFIX --with-slhdr
make -j $(nproc)
make install

cd ..

cd $FFDIR
mkdir -p build && cd build
../configure --prefix=$PREFIX --enable-libopenvvc --enable-libxml2 --enable-openssl
make -j $(nproc)
make install

cd $MPDIR
meson setup build --prefix=$PREFIX --libdir=$LIBDIR
meson configure build --prefix=$PREFIX --libdir=$LIBDIR
meson compile -C build
meson install -C build

cat > $BUILDROOT/env.mak  << EOF

3ems2_exit_venv(){
  source \$tmpfile
  rm \$tmpfile
  unset \$tmpfile
  unset 3ems2_bck_create
  unset 3ems2_exit_venv
  unset setup_3ems2_env
}

#Create backup file to restore env when exited
3ems2_bck_create() {
  tmpfile=\$(mktemp -t env_XXX)
  trap 3ems2_exit_venv INT QUIT EXIT

  cat > \$tmpfile  << EOF2
LD_LIBRARY_PATH=\$LD_LIBRARY_PATH
PKG_CONFIG_PATH=\$PKG_CONFIG_PATH
PATH=\$PATH
PS1='\$PS1'
EOF2
}

setup_3ems2_env(){

  3ems2_bck_create

  local BUILDROOT=$BUILDROOT
  local PREFIX=${PREFIX}

  local SLHDRDIR=${SLHDRDIR}

  local SLHDRINC=${SLHDRINC}
  local SLHDRLIB=${SLHDRLIB}

  local FFDIR=$FFDIR
  local OVDIR=$OVDIR
  local MPDIR=$MPDIR
  local SLDIR=$SLDIR

  local LIBDIR=${LIBDIR}
  local INCDIR=${INCDIR}

  export LD_LIBRARY_PATH=$LIBDIR:\$LD_LIBRARY_PATH
  export PKG_CONFIG_PATH=$LIBDIR/pkgconfig:\$PKG_CONFIG_PATH
  export PATH=$PREFIX/bin:\$PATH

  PS1='(3ems2) '\$PS1
}

setup_3ems2_env

EOF
