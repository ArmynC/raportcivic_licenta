cmake_minimum_required(VERSION 3.22)

project(LibsodiumWrapper VERSION 10.0.20 LANGUAGES C CXX)

if(WIN32)
    # pre-built static
    set(LIBSODIUM_ROOT "${CMAKE_CURRENT_SOURCE_DIR}")
    set(LIBSODIUM_INCLUDE_DIR "${LIBSODIUM_ROOT}/include")
    set(LIBSODIUM_LIBRARY "${LIBSODIUM_ROOT}/lib/libsodium.a")

    # define library target interface
    add_library(libsodium INTERFACE)

    # sets the directories for lib and include
    target_include_directories(libsodium INTERFACE ${LIBSODIUM_INCLUDE_DIR})
    target_link_libraries(libsodium INTERFACE ${LIBSODIUM_LIBRARY})

    message(STATUS "Libsodium include directory: ${LIBSODIUM_INCLUDE_DIR}")
    message(STATUS "Libsodium library: ${LIBSODIUM_LIBRARY}")

else()
    # search in linux system the package
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(LIBSODIUM libsodium IMPORTED_TARGET)

    if(LIBSODIUM_FOUND)
        add_library(libsodium INTERFACE)
        
        target_include_directories(libsodium INTERFACE PkgConfig::LIBSODIUM)
        target_link_libraries(libsodium INTERFACE PkgConfig::LIBSODIUM)

        message(STATUS "Found system libsodium library")
    else()
        # fallback to pre-built static
        set(LIBSODIUM_ROOT "${CMAKE_CURRENT_SOURCE_DIR}")
        set(LIBSODIUM_INCLUDE_DIR "${LIBSODIUM_ROOT}/include")
        set(LIBSODIUM_LIBRARY "${LIBSODIUM_ROOT}/lib/libsodium.a")
        
        add_library(libsodium INTERFACE)
        
        target_include_directories(libsodium INTERFACE ${LIBSODIUM_INCLUDE_DIR})
        target_link_libraries(libsodium INTERFACE ${LIBSODIUM_LIBRARY})

        message(STATUS "Using pre-built libsodium library")
    endif()
endif()
