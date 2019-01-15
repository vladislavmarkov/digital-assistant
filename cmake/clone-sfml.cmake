include(subproject)

get_property(_as_subproject GLOBAL PROPERTY AS_SUBPROJECT)
if(NOT sfml IN_LIST _as_subproject)
    # downloading and configuring sfml
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/download-sfml.txt.in ${CMAKE_CURRENT_BINARY_DIR}/sfml-download/CMakeLists.txt)

    execute_process(
    COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" .
    RESULT_VARIABLE result
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/sfml-download)
    if(result)
        message(FATAL_ERROR "CMake step for sfml failed: ${result}")
    endif()

    # building sfml
    execute_process(
    COMMAND ${CMAKE_COMMAND} --build .
    RESULT_VARIABLE result
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/sfml-download)
    if(result)
        message(FATAL_ERROR "Build step for sfml failed: ${result}")
    endif()

    add_subdirectory(
        ${CMAKE_CURRENT_BINARY_DIR}/sfml-src
        ${CMAKE_CURRENT_BINARY_DIR}/sfml-build
        EXCLUDE_FROM_ALL)

    append_as_subproject(sfml)
endif()
