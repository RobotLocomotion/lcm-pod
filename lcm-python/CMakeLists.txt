# setup.py needs this path to be in native format or it will drop the path separator
# after the drive letter.
file(TO_NATIVE_PATH "${CMAKE_INSTALL_PREFIX}" INSTALL_PREFIX)
add_custom_target(install_python ALL
	COMMAND ${PYTHON_EXECUTABLE} setup.py build --build-base=${CMAKE_CURRENT_BINARY_DIR}
	build_ext --include-dirs="${CMAKE_BINARY_DIR}/include" --library-dirs="${CMAKE_BINARY_DIR}/lib"
	install --prefix=${INSTALL_PREFIX}
	WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
