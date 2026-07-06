#! /usr/bin/bash
set -e

mkdir -p build
cd build

# DD4hep installs its CMake config to $PREFIX/cmake (not the standard
# lib/cmake/DD4hep CMake would auto-discover) -- see the
# eic-stack-roadmap memory. Hint it explicitly; DD4hepConfig.cmake's
# own script logic then walks DD4hep_DIR back up to the install root
# (see cmake/DD4hepConfig.cmake.in upstream), which is what npsim's own
# CMakeLists.txt (include(${DD4hep_DIR}/cmake/DD4hep.cmake)) expects.
cmake .. \
  -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
  -DCMAKE_BUILD_TYPE=Release \
  -DUSE_GEOCAD=ON \
  -DDD4hep_DIR="${PREFIX}/cmake" \
  -DCMAKE_PREFIX_PATH="${PREFIX}/cmake;${PREFIX}"

NPROC=$(nproc 2>/dev/null || sysctl -n hw.ncpu)
make -j"$NPROC"
make install
