add_executable(${projectName} main.cpp)

set(CADMIUM_DIR $ENV{CADMIUM})
if(CADMIUM_DIR AND EXISTS "${CADMIUM_DIR}/include/cadmium")
    set(CADMIUM_DIR "${CADMIUM_DIR}/include")
elseif(CADMIUM_DIR AND EXISTS "${CADMIUM_DIR}/cadmium")
    # CADMIUM already points to the include directory.
elseif(EXISTS "${CMAKE_SOURCE_DIR}/../cadmium_v2/include/cadmium")
    set(CADMIUM_DIR "${CMAKE_SOURCE_DIR}/../cadmium_v2/include")
elseif(EXISTS "${CMAKE_SOURCE_DIR}/../cadmium/include/cadmium")
    set(CADMIUM_DIR "${CMAKE_SOURCE_DIR}/../cadmium/include")
else()
    set(CADMIUM_DIR "")
endif()

if(NOT CADMIUM_DIR)
    message(FATAL_ERROR "Could not find Cadmium headers. Set CADMIUM to the Cadmium repo root or include directory, or clone cadmium_v2 beside this repository.")
endif()

if(NOT EXISTS "${CADMIUM_DIR}/cadmium/simulation/root_coordinator.hpp")
    message(FATAL_ERROR "CADMIUM_DIR='${CADMIUM_DIR}' does not contain Cadmium headers.")
endif()

message(STATUS "Using Cadmium headers from: ${CADMIUM_DIR}")

if(NOT IS_ABSOLUTE "${CADMIUM_DIR}")
    get_filename_component(CADMIUM_DIR "${CADMIUM_DIR}" ABSOLUTE BASE_DIR "${CMAKE_SOURCE_DIR}")
endif()

target_include_directories(${projectName} PUBLIC
    "."
    "../include"
    "${CADMIUM_DIR}"
)

if(EXISTS "${CMAKE_SOURCE_DIR}/../DESTimes/include")
    target_include_directories(${projectName} PUBLIC "${CMAKE_SOURCE_DIR}/../DESTimes/include")
elseif(EXISTS "${CMAKE_SOURCE_DIR}/../../DESTimes/include")
    target_include_directories(${projectName} PUBLIC "${CMAKE_SOURCE_DIR}/../../DESTimes/include")
endif()

target_compile_features(${projectName} PUBLIC cxx_std_17)

