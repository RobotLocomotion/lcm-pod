
set(LCM_GEN_SOURCES
    main.c
    lcmgen.c
    getopt.c
    tokenize.c
    emit_c.c
    emit_cpp.c
    emit_java.c
    emit_csharp.c
    emit_python.c
    emit_lua.c )

add_executable(lcm-gen  ${LCM_GEN_SOURCES})

if (WIN32)
  set_source_files_properties(${LCM_GEN_SOURCES} PROPERTIES COMPILE_FLAGS /TP)
endif()

pods_use_pkg_config_packages(lcm-gen glib-2.0)

pods_install_executables(lcm-gen)
