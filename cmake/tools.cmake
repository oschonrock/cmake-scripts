# The MIT License (MIT)
#
# Copyright (c) 2017 Mateusz Pusz
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

if(COMMAND configure_and_install)
    # header included already
    return()
endif()


# Provide typical configuration for specific packages
macro(find_package _name)
    _find_package(${ARGV})
    if("${_name}" STREQUAL "GTest")
        # fix an issue of GTest not buildng in Visual Studio 2017 with C++17
        if(CMAKE_CXX_STANDARD STREQUAL "17" AND MSVC)
            add_definitions(-DGTEST_LANG_CXX11=1 -DGTEST_HAS_TR1_TUPLE=0)
        endif()
    endif()
endmacro()


# Helper to use conan generated configuration if provided
macro(conan_init)
    if(EXISTS ${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
        include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
        conan_basic_setup(TARGETS)
    elseif(EXISTS ${CMAKE_BINARY_DIR}/conanbuildinfo_multi.cmake)
        include(${CMAKE_BINARY_DIR}/conanbuildinfo_multi.cmake)
        conan_basic_setup(TARGETS)
    endif()
endmacro()


# Generate configuration files and install the package
function(configure_and_install _configure_in_file_path _version_compare_rules)
    # prepare installation files
    include(CMakePackageConfigHelpers)
    set(ConfigPackageSource ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME})
    set(ConfigPackageDestination lib/cmake/${CMAKE_PROJECT_NAME})
    write_basic_package_version_file(
            ${ConfigPackageSource}/${CMAKE_PROJECT_NAME}-config-version.cmake
            COMPATIBILITY ${_version_compare_rules})
    configure_package_config_file(${_configure_in_file_path}
            ${ConfigPackageSource}/${CMAKE_PROJECT_NAME}-config.cmake
            INSTALL_DESTINATION ${ConfigPackageDestination})

    # install library
    install(EXPORT ${CMAKE_PROJECT_NAME}Targets
            DESTINATION ${ConfigPackageDestination}
            FILE ${CMAKE_PROJECT_NAME}-targets.cmake
            NAMESPACE mp::
            COMPONENT Devel)
    install(FILES
            "${ConfigPackageSource}/${CMAKE_PROJECT_NAME}-config.cmake"
            "${ConfigPackageSource}/${CMAKE_PROJECT_NAME}-config-version.cmake"
            DESTINATION ${ConfigPackageDestination}
            COMPONENT Devel)
endfunction()


# Fix an issue of not specifying C++17 in Visual Studio 2017
if(CMAKE_CXX_STANDARD STREQUAL "17" AND MSVC)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /std:c++latest")
endif()