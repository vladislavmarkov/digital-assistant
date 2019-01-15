include(subproject)

get_property(_as_subproject GLOBAL PROPERTY AS_SUBPROJECT)
if(NOT imgui IN_LIST _as_subproject)
    # downloading and configuring imgui
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/download-imgui.txt.in ${CMAKE_CURRENT_BINARY_DIR}/imgui-download/CMakeLists.txt)

    execute_process(
    COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" .
    RESULT_VARIABLE result
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/imgui-download)
    if(result)
        message(FATAL_ERROR "CMake step for imgui failed: ${result}")
    endif()

    # building imgui
    execute_process(COMMAND ${CMAKE_COMMAND} --build .
    RESULT_VARIABLE result
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/imgui-download)
    if(result)
        message(FATAL_ERROR "Build step for imgui failed: ${result}")
    endif()

    append_as_subproject(imgui)
endif()
