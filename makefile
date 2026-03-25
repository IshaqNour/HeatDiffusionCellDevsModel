.RECIPEPREFIX := >
SHELL := /bin/sh
.SHELLFLAGS := -c
.SILENT:

EXEEXT :=
SIMULATOR := bin/heat_diffusion
RUNTIME_DLL_TARGETS :=
BUILD_ENV_PREFIX :=
COPY_FILE := cp -f
REMOVE_DIRS := rm -rf
MAKE_DIR := mkdir -p

ifeq ($(OS),Windows_NT)
EXEEXT := .exe
SIMULATOR := bin/heat_diffusion$(EXEEXT)
SHELL := cmd.exe
.SHELLFLAGS := /c
COPY_FILE := copy /y
REMOVE_DIRS := rmdir /s /q
MAKE_DIR := mkdir

ifneq ("$(wildcard C:/msys64/ucrt64/bin/g++.exe)","")
CC := C:/msys64/ucrt64/bin/g++.exe
TOOLCHAIN_BIN := C:/msys64/ucrt64/bin
else ifneq ("$(wildcard C:/msys64/mingw64/bin/g++.exe)","")
CC := C:/msys64/mingw64/bin/g++.exe
TOOLCHAIN_BIN := C:/msys64/mingw64/bin
else ifneq ("$(wildcard C:/msys64/clang64/bin/g++.exe)","")
CC := C:/msys64/clang64/bin/g++.exe
TOOLCHAIN_BIN := C:/msys64/clang64/bin
endif

ifneq ("$(TOOLCHAIN_BIN)","")
RUNTIME_DLL_TARGETS := bin/libgcc_s_seh-1.dll bin/libstdc++-6.dll bin/libwinpthread-1.dll
TOOLCHAIN_BIN_WIN := $(subst /,\,$(TOOLCHAIN_BIN))
BUILD_ENV_PREFIX := set "PATH=$(TOOLCHAIN_BIN);%PATH%" &&
endif
endif

CC ?= g++
CFLAGS := -std=c++17

CADMIUM_DIR ?= ./vendor/cadmium_v2
ifeq ("$(wildcard $(CADMIUM_DIR)/include)","")
ifeq ("$(wildcard ../cadmium_v2/include)","")
ifeq ("$(wildcard ../cadmium/include)","")
$(error Could not find Cadmium headers. Put cadmium_v2 in ./vendor/cadmium_v2, clone it beside this folder, or run 'make CADMIUM_DIR=/path/to/cadmium_v2')
else
CADMIUM_DIR := ../cadmium
endif
else
CADMIUM_DIR := ../cadmium_v2
endif
endif

INCLUDECADMIUM := -I $(CADMIUM_DIR)/include
INCLUDEJSON := -I ./vendor

ifneq ("$(wildcard ../DESTimes/include)","")
INCLUDEDESTIMES := -I ../DESTimes/include
else ifneq ("$(wildcard ../../DESTimes/include)","")
INCLUDEDESTIMES := -I ../../DESTimes/include
else
INCLUDEDESTIMES :=
endif

INCLUDELOCAL := -I ./atomics -I ./top_model

all: simulator

simulator: | bin simulation_results
simulator: $(SIMULATOR) $(RUNTIME_DLL_TARGETS)

$(SIMULATOR): | bin
$(SIMULATOR): build/main.o
>$(BUILD_ENV_PREFIX) $(CC) $(CFLAGS) $(INCLUDECADMIUM) $(INCLUDEJSON) $(INCLUDEDESTIMES) $(INCLUDELOCAL) -o $@ $^

build/main.o: | build
build/main.o: top_model/main.cpp \
	top_model/heat_diffusion_top.hpp top_model/heat_surface_coupled.hpp \
	atomics/heat_diffusion_state.hpp atomics/heat_diffusion_cell.hpp atomics/trigger_generator.hpp
>$(BUILD_ENV_PREFIX) $(CC) $(CFLAGS) $(INCLUDECADMIUM) $(INCLUDEJSON) $(INCLUDEDESTIMES) $(INCLUDELOCAL) -c $< -o $@

bin/libgcc_s_seh-1.dll: $(TOOLCHAIN_BIN)/libgcc_s_seh-1.dll | bin
>$(BUILD_ENV_PREFIX) $(COPY_FILE) "$(TOOLCHAIN_BIN_WIN)\libgcc_s_seh-1.dll" "$@" >nul

bin/libstdc++-6.dll: $(TOOLCHAIN_BIN)/libstdc++-6.dll | bin
>$(BUILD_ENV_PREFIX) $(COPY_FILE) "$(TOOLCHAIN_BIN_WIN)\libstdc++-6.dll" "$@" >nul

bin/libwinpthread-1.dll: $(TOOLCHAIN_BIN)/libwinpthread-1.dll | bin
>$(BUILD_ENV_PREFIX) $(COPY_FILE) "$(TOOLCHAIN_BIN_WIN)\libwinpthread-1.dll" "$@" >nul

bin build simulation_results:
ifeq ($(OS),Windows_NT)
>if not exist $@ $(MAKE_DIR) $@
else
>$(MAKE_DIR) "$@"
endif

clean:
ifeq ($(OS),Windows_NT)
>if exist bin $(REMOVE_DIRS) bin
>if exist build $(REMOVE_DIRS) build
>if exist simulation_results $(REMOVE_DIRS) simulation_results
else
>$(REMOVE_DIRS) bin build simulation_results
endif
