.RECIPEPREFIX := >
SHELL := cmd.exe
.SHELLFLAGS := /c

CC=g++
CFLAGS=-std=c++17

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

INCLUDECADMIUM=-I $(CADMIUM_DIR)/include
INCLUDEJSON=-I ./vendor

ifneq ("$(wildcard ../DESTimes/include)","")
INCLUDEDESTIMES=-I ../DESTimes/include
else ifneq ("$(wildcard ../../DESTimes/include)","")
INCLUDEDESTIMES=-I ../../DESTimes/include
else
INCLUDEDESTIMES=
endif

INCLUDELOCAL=-I ./atomics -I ./top_model

all: simulator

simulator: | bin simulation_results
simulator: bin/heat_diffusion

bin/heat_diffusion: | bin
bin/heat_diffusion: build/main.o
>$(CC) $(CFLAGS) $(INCLUDECADMIUM) $(INCLUDEJSON) $(INCLUDEDESTIMES) $(INCLUDELOCAL) -o $@ $^

build/main.o: | build
build/main.o: top_model/main.cpp \
	top_model/heat_diffusion_top.hpp top_model/heat_surface_coupled.hpp \
	atomics/heat_diffusion_state.hpp atomics/heat_diffusion_cell.hpp atomics/trigger_generator.hpp
>$(CC) $(CFLAGS) $(INCLUDECADMIUM) $(INCLUDEJSON) $(INCLUDEDESTIMES) $(INCLUDELOCAL) -c $< -o $@

bin build simulation_results:
>if not exist $@ mkdir $@

clean:
>if exist bin rmdir /s /q bin
>if exist build rmdir /s /q build
>if exist simulation_results rmdir /s /q simulation_results
