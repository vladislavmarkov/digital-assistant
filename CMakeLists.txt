cmake_minimum_required(VERSION 3.12 FATAL_ERROR)

project(digital-assistant)

include(FindPkgConfig)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
include(clone-imgui)
include(clone-sfml)
include(formatting)

message(STATUS "current module path ${CMAKE_MODULE_PATH}")

find_package(Freetype REQUIRED)

set(UNFORMATTED_FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/src/digitalassistant.cpp)

set(SOURCE_FILES ${UNFORMATTED_FILES})
list(FILTER SOURCE_FILES EXCLUDE REGEX ".*\\.hpp")

add_executable(digitalassistant ${SOURCE_FILES})
add_clangformat(digitalassistant FILES ${UNFORMATTED_FILES})

add_library(imgui OBJECT
    ${CMAKE_CURRENT_BINARY_DIR}/imgui-src/imgui.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/imgui-src/imgui_draw.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/imgui-src/imgui_widgets.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/imgui-src/misc/cpp/imgui_stdlib.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/imgui-src/misc/freetype/imgui_freetype.cpp)

add_executable(binary_to_compressed_c
    ${CMAKE_CURRENT_BINARY_DIR}/imgui-src/misc/fonts/binary_to_compressed_c.cpp)

target_include_directories(imgui
PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/imgui-src>
    ${FREETYPE_INCLUDE_DIRS})

target_link_libraries(imgui
PUBLIC
    ${FREETYPE_LIBRARIES})

target_compile_options(digitalassistant
PRIVATE
    -std=gnu++1z #[[since cxx_std_17 doesn't exist yet]]
    -Wall
    -Werror
    -Wextra)

# unfortunately imgui and sfml doesn't compile with these
#[[
    -pedantic
    -Wconversion
    -Winit-self
    -Woverloaded-virtual
    -Wunreachable-code
    -Wold-style-cast
    -Wsign-promo
    -Wshadow
]]

if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(debug_postfix -d)
    else()
        set(debug_postfix)
    endif(CMAKE_BUILD_TYPE STREQUAL "Debug")

    set(dlls_to_copy
        ${CMAKE_CURRENT_BINARY_DIR}/sfml-build/lib/sfml-graphics${debug_postfix}-2.dll
        ${CMAKE_CURRENT_BINARY_DIR}/sfml-build/lib/sfml-system${debug_postfix}-2.dll
        ${CMAKE_CURRENT_BINARY_DIR}/sfml-build/lib/sfml-window${debug_postfix}-2.dll)

    add_custom_target(copydlls ALL
    COMMENT "copy sfml dlls closer to executable"
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${dlls_to_copy} ${CMAKE_CURRENT_BINARY_DIR})

    add_dependencies(copydlls sfml-system sfml-window sfml-graphics)
endif(CMAKE_SYSTEM_NAME STREQUAL "Windows")

target_include_directories(digitalassistant
PRIVATE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src>)

target_link_libraries(digitalassistant
PRIVATE
    imgui
    sfml-graphics
    sfml-system
    sfml-window)
