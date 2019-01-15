find_program(CLANG_FORMAT NAMES clang-format)
if (NOT CLANG_FORMAT)
    message(STATUS "\"clang-format\" is missing")
endif(NOT CLANG_FORMAT)

function(add_clangformat)
    if (NOT CLANG_FORMAT)
        message(STATUS "skip formatting due to clang-format is missing")
    else()
        set(optional)          # we don't need any optionals
        set(single_value)      # ...and single-valued parameters
        set(multi_value FILES) # use FILES tag for multi-valued parameters

        # skip the 0th arg by starting to parse from the 1st one
        cmake_parse_arguments(PARSE_ARGV 1 FORMAT "${optional}" "${single_value}" "${multi_value}")

        set(_sources)

        foreach(_source ${FORMAT_FILES})
            get_filename_component(_source_file ${_source} NAME)
            get_source_file_property(_source_file_loc "${_source}" LOCATION)

            set(_format_file ${_source_file}.format)

            add_custom_command(OUTPUT ${_format_file}
            DEPENDS ${_source}
            COMMENT "clang-format ${_source}"
            COMMAND ${CLANG_FORMAT} -style=file -i ${_source_file_loc}
            COMMAND ${CMAKE_COMMAND} -E touch ${_format_file})

            list(APPEND _sources ${_format_file})
        endforeach(_source)

        if (_sources)
            add_custom_target(${ARGV0}_format
            SOURCES ${_sources}
            COMMENT "clang-format for target ${ARGV0}")
        endif()
    endif(NOT CLANG_FORMAT)
endfunction(add_clangformat)
