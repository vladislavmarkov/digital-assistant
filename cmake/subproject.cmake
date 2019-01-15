function(append_as_subproject)
    get_property(_as_subproject GLOBAL PROPERTY AS_SUBPROJECT)
    if(NOT ARGV0 IN_LIST _as_subproject)
        set_property(GLOBAL APPEND PROPERTY AS_SUBPROJECT ${ARGV0})
    endif()
endfunction(append_as_subproject)

macro(add_subproj_library)
    if (NOT ${ARGV1} STREQUAL "ALIAS")
        append_as_subproject(${ARGV0})
    endif()
    add_library(${ARGN})
endmacro(add_subproj_library)

function(find_dependencies)
    get_property(AS_SUBPROJECT GLOBAL PROPERTY AS_SUBPROJECT)
    list(LENGTH ARGN _arg_count)
    math(EXPR _reminder "${_arg_count} % 3")
    if (NOT ${_reminder} EQUAL 0)
        message(FATAL "wrong number of arguments")
    endif()

    foreach(_item RANGE 0 _reminder 3)
        set(_index ${_item})
        set(TARGET_NAME ${ARGV${_index}})
        if(NOT TARGET_NAME IN_LIST AS_SUBPROJECT)
            math(EXPR _index "${_index} + 1")
            set(REPO_URL ${ARGV${_index}})
            math(EXPR _index "${_index} + 1")
            set(REPO_TAG ${ARGV${_index}})

            # downloading and configuring
            configure_file(
                ${CMAKE_CURRENT_SOURCE_DIR}/cmake/download.txt.in
                ${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}-download/CMakeLists.txt)

            execute_process(
            COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" .
            RESULT_VARIABLE result
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}-download)
            if(result)
                message(FATAL_ERROR "CMake step for ${TARGET_NAME} failed: ${result}")
            endif()

            # building
            execute_process(COMMAND ${CMAKE_COMMAND} --build .
            RESULT_VARIABLE result
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}-download)
            if(result)
                message(FATAL_ERROR "Build step for ${TARGET_NAME} failed: ${result}")
            endif()

            add_subdirectory(
                ${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}-src
                ${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}-build)
        endif()
    endforeach(_item)
endfunction(find_dependencies)
