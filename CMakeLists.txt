cmake_minimum_required(VERSION 3.12 FATAL_ERROR)

project(digital-assistant)

include(FindPkgConfig)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
include(clone-GSL)
include(clone-imgui)
include(formatting)

message(STATUS "current module path ${CMAKE_MODULE_PATH}")

find_package(Freetype REQUIRED)
find_package(OpenGL 3 REQUIRED)
find_package(SDL2 REQUIRED)

get_property(_subprojects GLOBAL PROPERTY AS_SUBPROJECT)
message(STATUS "subprojects ${_subprojects}")

set(SOURCE_FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/src/digitalassistant.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/src/no-warn-imgui.hpp)

add_executable(digitalassistant ${SOURCE_FILES})
add_clangformat(digitalassistant FILES ${SOURCE_FILES})

add_library(imgui OBJECT
    ${CMAKE_CURRENT_BINARY_DIR}/imgui-src/examples/imgui_impl_opengl3.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/imgui-src/examples/imgui_impl_sdl.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/imgui-src/examples/libs/gl3w/GL/gl3w.c
    ${CMAKE_CURRENT_BINARY_DIR}/imgui-src/imgui.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/imgui-src/imgui_demo.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/imgui-src/imgui_draw.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/imgui-src/imgui_widgets.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/imgui-src/misc/cpp/imgui_stdlib.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/imgui-src/misc/freetype/imgui_freetype.cpp)

target_include_directories(imgui
PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/imgui-src/examples/libs/gl3w>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/imgui-src/examples>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/imgui-src>
    ${FREETYPE_INCLUDE_DIRS}
    ${SDL2_INCLUDE_DIRS})

target_link_libraries(imgui
PUBLIC
    ${SDL2_LIBRARIES}
    ${FREETYPE_LIBRARIES}
    ${CMAKE_DL_LIBS}
    OpenGL::GL)

target_compile_options(digitalassistant
PRIVATE
    -std=gnu++1z #[[since cxx_std_17 doesn't exist yet]]
    -Wall
    -Werror
    -Wextra
    -pedantic
    -Wconversion
    -Winit-self
    -Woverloaded-virtual
    -Wunreachable-code
    -Wold-style-cast
    -Wsign-promo
    -Wshadow)

target_include_directories(digitalassistant
PRIVATE
    ${SDL2_INCLUDE_DIRS})

target_link_libraries(digitalassistant
PRIVATE
    GSL
    imgui
    ${SDL2_LIBRARIES})
