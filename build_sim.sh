#!/bin/bash
set -e

SOURCE_DIR="$(pwd)"
BUILD_DIR="build"

case "$(uname -r)" in
    *[Mm]icrosoft*|*[Ww][Ss][Ll]*)
        if [[ "$SOURCE_DIR" == /mnt/* ]]; then
            BUILD_DIR="${HOME}/.cache/$(basename "$SOURCE_DIR")-build"
            echo "Using WSL-local build directory: $BUILD_DIR"
        fi
        ;;
esac

if [ -d "$BUILD_DIR" ]; then rm -Rf "$BUILD_DIR"; fi
mkdir -p "$BUILD_DIR"

cmake -S "$SOURCE_DIR" -B "$BUILD_DIR"
cmake --build "$BUILD_DIR"

echo "Compilation done. Executable in the bin folder"