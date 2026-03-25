#!/bin/bash
set -e

if [ -z "$CADMIUM" ] && [ -d "../cadmium_v2/include" ]; then
    export CADMIUM="$(cd ../cadmium_v2/include && pwd)"
fi

if [ -z "$CADMIUM" ]; then
    echo "CADMIUM is not set. Point it to the cadmium_v2 include directory."
    exit 1
fi

if ! command -v cmake >/dev/null 2>&1; then
    echo "cmake was not found in PATH."
    exit 1
fi

if ! command -v make >/dev/null 2>&1; then
    echo "make was not found in PATH."
    exit 1
fi

if ! command -v g++ >/dev/null 2>&1; then
    echo "g++ was not found in PATH."
    exit 1
fi

GENERATOR="${CMAKE_GENERATOR:-}"
case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*)
        export CC="${CC:-gcc}"
        export CXX="${CXX:-g++}"
        if [ -z "$GENERATOR" ]; then
            GENERATOR="MinGW Makefiles"
        fi
        ;;
    *)
        if [ -z "$GENERATOR" ]; then
            GENERATOR="Unix Makefiles"
        fi
        ;;
esac

if [ -d "build" ]; then rm -Rf build; fi
mkdir -p build
cd build || exit
rm -rf *
cmake -G "$GENERATOR" ..
make
cd ..
echo "Compilation done. Executable in the bin folder"