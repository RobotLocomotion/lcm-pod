
set (CMAKE_JAVA_TARGET_OUTPUT_NAME lcm)  # todo: remove this when cmake min version >= 2.8.12
# from UseJava.cmake
# In CMake < 2.8.12, add_jar used variables which were set prior to calling
# add_jar for customizing the behavior of add_jar. In order to be backwards
# compatible, check if any of those variables are set, and use them to
# initialize values of the named arguments. (Giving the corresponding named
# argument will override the value set here.)

set(jchart2d_src_dir ${CMAKE_CURRENT_SOURCE_DIR}/jchart2d-code/src)
set(jide_jar ${CMAKE_CURRENT_SOURCE_DIR}/jchart2d-code/ext/jide-oss-2.9.7.jar)
set(xmlgraphics_jar ${CMAKE_CURRENT_SOURCE_DIR}/jchart2d-code/ext/xmlgraphics-commons-1.3.1.jar)

FILE(GLOB_RECURSE lcm_java_files lcm/*.java)
FILE(GLOB_RECURSE jchart2d_files ${jchart2d_src_dir}/*.java)

set(JAR_EXTRACT_DIR "${CMAKE_CURRENT_BINARY_DIR}/jarbuild")
set(CMAKE_JAVA_INCLUDE_PATH ${JAR_EXTRACT_DIR})
FILE(MAKE_DIRECTORY ${JAR_EXTRACT_DIR})

# Extract all the JAR files to a temporary "build" directory
add_custom_target(lcm-extract-jars
  COMMAND ${Java_JAR_EXECUTABLE} "-xf" ${xmlgraphics_jar}
  COMMAND ${Java_JAR_EXECUTABLE} "-xf" ${jide_jar}
  WORKING_DIRECTORY ${JAR_EXTRACT_DIR}
  )

add_jar(lcm-java
  SOURCES ${lcm_java_files} ${jchart2d_files}
  OUTPUT_NAME lcm)

add_dependencies(lcm-java lcm-extract-jars)

get_target_property(LCM_JAR_FILE lcm-java JAR_FILE)

# Add the class files from the external JARS into our lcm jar output by add_jar
add_custom_command(TARGET lcm-java
  POST_BUILD
  COMMAND ${Java_JAR_EXECUTABLE} uf ${LCM_JAR_FILE} *
  WORKING_DIRECTORY ${JAR_EXTRACT_DIR}
  )


pods_install_jars(lcm-java)

pods_install_pkg_config_file(lcm-java
    CLASSPATH lcm
    VERSION ${LCM_VERSION})

if (APPLE)
  set(MAC_JAVA_FIX "-Djava.net.preferIPv4Stack=true")
endif()

file(WRITE ${CMAKE_BINARY_DIR}/lcm-logplayer-gui
	"#!/bin/sh\n"
	"exec java -server ${MAC_JAVA_FIX} -Xincgc -Xmx64m -Xms32m -ea -cp \"${CMAKE_INSTALL_PREFIX}/share/java/*\" lcm.logging.LogPlayer \$*\n")
file(INSTALL ${CMAKE_BINARY_DIR}/lcm-logplayer-gui
	     DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
	     FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

file(WRITE ${CMAKE_BINARY_DIR}/lcm-spy
	"#!/bin/sh\n"
	"exec java -server ${MAC_JAVA_FIX} -Xincgc -Xmx128m -Xms64m -ea -cp \"${CMAKE_INSTALL_PREFIX}/share/java/*\" lcm.spy.Spy \$*\n")
file(INSTALL ${CMAKE_BINARY_DIR}/lcm-spy
	     DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
	     FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
