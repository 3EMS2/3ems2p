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

export LD_LIBRARY_PATH=$LIBDIR
export PKG_CONFIG_PATH=$LIBDIR/pkgconfig/

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

