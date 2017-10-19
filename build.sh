#!/bin/sh
sudo apt update
sudo apt-get build-dep qemu
sudo apt-get install python-pip git protobuf-compiler protobuf-c-compiler \
  libprotobuf-c0-dev libprotoc-dev libelf-dev \
  libcapstone-dev python-pycparser libc++-dev cmake git \
  subversion

svn checkout http://llvm.org/svn/llvm-project/llvm/tags/RELEASE_33/final/ llvm
cd llvm/tools
svn checkout http://llvm.org/svn/llvm-project/cfe/tags/RELEASE_33/final/ clang
cd -
cd llvm/tools/clang/tools
svn checkout http://llvm.org/svn/llvm-project/clang-tools-extra/tags/RELEASE_33/final/ extra
cd -

cd llvm
./configure --enable-optimized --disable-assertions --enable-targets=x86 && REQUIRES_RTTI=1 make -j $(nproc)
sudo make install
cd -

wget https://www.prevanders.net/libdwarf-20160613.tar.gz
tar xf libdwarf-20160613.tar.gz
cd dwarf-20160613
./configure --enable-shared
make
sudo mkdir -p /usr/local/include/libdwarf
sudo cp libdwarf/libdwarf.h /usr/local/include/libdwarf
sudo cp libdwarf/dwarf.h /usr/local/include/libdwarf
sudo cp libdwarf/libdwarf.so /usr/local/lib/ 

git clone https://github.com/panda-re/panda
cd panda

mkdir -p build-panda && cd build-panda
../panda/build.sh

# qemu-img create -f qcow2 testing-image.img 10G
