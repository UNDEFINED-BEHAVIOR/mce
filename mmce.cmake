cmake_minimum_required(VERSION 3.1)

# Common find_openmp for cmake 3.1+, automatically tries to create 3.9+ like targets.
# https://cliutils.gitlab.io/modern-cmake/chapters/packages/OpenMP.html
function(FindOpenMP_Compat)
    find_package(OpenMP REQUIRED)
    if (OpenMP_FOUND)
        if(${CMAKE_VERSION} VERSION_LESS "3.9.0") 
            find_package(Threads REQUIRED)
            if(OpenMP_CXX_FOUND)
                add_library(OpenMP::OpenMP_CXX IMPORTED INTERFACE)
                set_property(
                    TARGET OpenMP::OpenMP_CXX
                    PROPERTY INTERFACE_COMPILE_OPTIONS ${OpenMP_CXX_FLAGS}
                )
                # Only works if the same flag is passed to the linker; use CMake 3.9+ otherwise (Intel, AppleClang)
                set_property(
                    TARGET OpenMP::OpenMP_CXX
                    PROPERTY INTERFACE_LINK_LIBRARIES ${OpenMP_CXX_FLAGS} Threads::Threads
                )
            endif()
            if(OpenMP_C_FOUND)
                add_library(OpenMP::OpenMP_C IMPORTED INTERFACE)
                set_property(
                    TARGET OpenMP::OpenMP_C
                    PROPERTY INTERFACE_COMPILE_OPTIONS ${OpenMP_C_FLAGS}
                )
                set_property(
                    TARGET OpenMP::OpenMP_C
                    PROPERTY INTERFACE_LINK_LIBRARIES ${OpenMP_C_FLAGS} Threads::Threads
                )
            endif()
            # todo consider support fortran?
        endif()
        message(STATUS "OpenMP Found")
    else()
        message(FATAL "Failed to locate OpenMP")
    endif()
endfunction()