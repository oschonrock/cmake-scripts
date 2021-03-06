# cmake-scripts

Common CMake tools and wrappers to use in other repositories.

## `scripts.cmake`

A wrapper file including all other CMake modules:
- `conan.cmake`
- `install.cmake`
- `warnings.cmake`

## `conan.cmake`

- `conan_init(generator)` - initializes CMake with data from Conan Package Manger (if present)

## `install.cmake`

- `CMAKE_SCRIPTS_ROOT` - a path to scripts directory
- `install_targets(targets...)` - marks provided targets for installation in typical destination directories
- `configure_and_install(configure_in_file_path, namespace, version_compare_rules)` - creates CMake package
     version and config files based on a provided template, and installs them together with
     `${CMAKE_PROJECT_NAME}Targets` ``EXPORT` target.

## `warnings.cmake`

- `set_warnings(treat_warnings_as_errors)` - very restrictive compilation warning flags settings for
     Continuous Integration and local builds. It should not be used in the library project `CMakeLists.txt`
     file to not force other users using this library to compile their projects with our flags or even worse
     to modify their preset flags by our scripts.
