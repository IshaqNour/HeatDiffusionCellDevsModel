add_executable(${projectName} main.cpp)

set(CADMIUM_DIR $ENV{CADMIUM})
if(NOT CADMIUM_DIR)
    message(FATAL_ERROR "Set CADMIUM to the Cadmium include directory before building.")
endif()

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