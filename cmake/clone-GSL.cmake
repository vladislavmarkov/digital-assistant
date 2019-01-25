include(subproject)

get_property(_as_subproject GLOBAL PROPERTY AS_SUBPROJECT)
if(NOT GSL IN_LIST _as_subproject)
    # downloading and configuring GSL
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/download-gsl.txt.in ${CMAKE_CURRENT_BINARY_DIR}/GSL-download/CMakeLists.txt)

    execute_process(
    COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" .
    RESULT_VARIABLE result
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/GSL-download)
    if(result)
        message(FATAL_ERROR "CMake step for GSL failed: ${result}")
    endif()

    # building GSL
    execute_process(COMMAND ${CMAKE_COMMAND} --build .
    RESULT_VARIABLE result
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/GSL-download)
    if(result)
        message(FATAL_ERROR "Build step for GSL failed: ${result}")
    endif()

    append_as_subproject(GSL)
    add_subdirectory(${CMAKE_CURRENT_BINARY_DIR}/GSL-src EXCLUDE_FROM_ALL)
endif()
