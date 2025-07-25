# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 4.0

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /opt/homebrew/bin/cmake

# The command to remove a file.
RM = /opt/homebrew/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/luis/Desktop/dataHandler

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/luis/Desktop/dataHandler/build

# Utility rule file for appdataHandler_qmltyperegistration.

# Include any custom commands dependencies for this target.
include CMakeFiles/appdataHandler_qmltyperegistration.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/appdataHandler_qmltyperegistration.dir/progress.make

CMakeFiles/appdataHandler_qmltyperegistration: appdatahandler_qmltyperegistrations.cpp
CMakeFiles/appdataHandler_qmltyperegistration: dataHandler/appdataHandler.qmltypes

appdatahandler_qmltyperegistrations.cpp: qmltypes/appdataHandler_foreign_types.txt
appdatahandler_qmltyperegistrations.cpp: meta_types/qt6appdatahandler_debug_metatypes.json
appdatahandler_qmltyperegistrations.cpp: /opt/homebrew/share/qt/libexec/qmltyperegistrar
appdatahandler_qmltyperegistrations.cpp: /opt/homebrew/share/qt/metatypes/qt6core_release_metatypes.json
appdatahandler_qmltyperegistrations.cpp: /opt/homebrew/share/qt/metatypes/qt6qml_release_metatypes.json
appdatahandler_qmltyperegistrations.cpp: /opt/homebrew/share/qt/metatypes/qt6network_release_metatypes.json
appdatahandler_qmltyperegistrations.cpp: /opt/homebrew/share/qt/metatypes/qt6quick_release_metatypes.json
appdatahandler_qmltyperegistrations.cpp: /opt/homebrew/share/qt/metatypes/qt6gui_release_metatypes.json
appdatahandler_qmltyperegistrations.cpp: /opt/homebrew/share/qt/metatypes/qt6qmlmeta_release_metatypes.json
appdatahandler_qmltyperegistrations.cpp: /opt/homebrew/share/qt/metatypes/qt6qmlmodels_release_metatypes.json
appdatahandler_qmltyperegistrations.cpp: /opt/homebrew/share/qt/metatypes/qt6qmlworkerscript_release_metatypes.json
appdatahandler_qmltyperegistrations.cpp: /opt/homebrew/share/qt/metatypes/qt6opengl_release_metatypes.json
appdatahandler_qmltyperegistrations.cpp: /opt/homebrew/share/qt/metatypes/qt6sql_release_metatypes.json
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --blue --bold --progress-dir=/Users/luis/Desktop/dataHandler/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Automatic QML type registration for target appdataHandler"
	/opt/homebrew/share/qt/libexec/qmltyperegistrar --generate-qmltypes=/Users/luis/Desktop/dataHandler/build/dataHandler/appdataHandler.qmltypes --import-name=dataHandler --major-version=1 --minor-version=0 @/Users/luis/Desktop/dataHandler/build/qmltypes/appdataHandler_foreign_types.txt -o /Users/luis/Desktop/dataHandler/build/appdatahandler_qmltyperegistrations.cpp /Users/luis/Desktop/dataHandler/build/meta_types/qt6appdatahandler_debug_metatypes.json
	/opt/homebrew/bin/cmake -E make_directory /Users/luis/Desktop/dataHandler/build/.qt/qmltypes
	/opt/homebrew/bin/cmake -E touch /Users/luis/Desktop/dataHandler/build/.qt/qmltypes/appdataHandler.qmltypes

dataHandler/appdataHandler.qmltypes: appdatahandler_qmltyperegistrations.cpp
	@$(CMAKE_COMMAND) -E touch_nocreate dataHandler/appdataHandler.qmltypes

meta_types/qt6appdatahandler_debug_metatypes.json: meta_types/qt6appdatahandler_debug_metatypes.json.gen
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --blue --bold --progress-dir=/Users/luis/Desktop/dataHandler/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Generating meta_types/qt6appdatahandler_debug_metatypes.json"
	/opt/homebrew/bin/cmake -E true

meta_types/qt6appdatahandler_debug_metatypes.json.gen: /opt/homebrew/share/qt/libexec/moc
meta_types/qt6appdatahandler_debug_metatypes.json.gen: meta_types/appdataHandler_json_file_list.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --blue --bold --progress-dir=/Users/luis/Desktop/dataHandler/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Running moc --collect-json for target appdataHandler"
	/opt/homebrew/share/qt/libexec/moc -o /Users/luis/Desktop/dataHandler/build/meta_types/qt6appdatahandler_debug_metatypes.json.gen --collect-json @/Users/luis/Desktop/dataHandler/build/meta_types/appdataHandler_json_file_list.txt
	/opt/homebrew/bin/cmake -E copy_if_different /Users/luis/Desktop/dataHandler/build/meta_types/qt6appdatahandler_debug_metatypes.json.gen /Users/luis/Desktop/dataHandler/build/meta_types/qt6appdatahandler_debug_metatypes.json

meta_types/appdataHandler_json_file_list.txt: /opt/homebrew/share/qt/libexec/cmake_automoc_parser
meta_types/appdataHandler_json_file_list.txt: appdataHandler_autogen/timestamp
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --blue --bold --progress-dir=/Users/luis/Desktop/dataHandler/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Running AUTOMOC file extraction for target appdataHandler"
	/opt/homebrew/share/qt/libexec/cmake_automoc_parser --cmake-autogen-cache-file /Users/luis/Desktop/dataHandler/build/CMakeFiles/appdataHandler_autogen.dir/ParseCache.txt --cmake-autogen-info-file /Users/luis/Desktop/dataHandler/build/CMakeFiles/appdataHandler_autogen.dir/AutogenInfo.json --output-file-path /Users/luis/Desktop/dataHandler/build/meta_types/appdataHandler_json_file_list.txt --timestamp-file-path /Users/luis/Desktop/dataHandler/build/meta_types/appdataHandler_json_file_list.txt.timestamp --cmake-autogen-include-dir-path /Users/luis/Desktop/dataHandler/build/appdataHandler_autogen/include

appdataHandler_autogen/timestamp: /opt/homebrew/share/qt/libexec/moc
appdataHandler_autogen/timestamp: CMakeFiles/appdataHandler_qmltyperegistration.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --blue --bold --progress-dir=/Users/luis/Desktop/dataHandler/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Automatic MOC and UIC for target appdataHandler"
	/opt/homebrew/bin/cmake -E cmake_autogen /Users/luis/Desktop/dataHandler/build/CMakeFiles/appdataHandler_autogen.dir/AutogenInfo.json Debug
	/opt/homebrew/bin/cmake -E touch /Users/luis/Desktop/dataHandler/build/appdataHandler_autogen/timestamp

CMakeFiles/appdataHandler_qmltyperegistration.dir/codegen:
.PHONY : CMakeFiles/appdataHandler_qmltyperegistration.dir/codegen

appdataHandler_qmltyperegistration: CMakeFiles/appdataHandler_qmltyperegistration
appdataHandler_qmltyperegistration: appdataHandler_autogen/timestamp
appdataHandler_qmltyperegistration: appdatahandler_qmltyperegistrations.cpp
appdataHandler_qmltyperegistration: dataHandler/appdataHandler.qmltypes
appdataHandler_qmltyperegistration: meta_types/appdataHandler_json_file_list.txt
appdataHandler_qmltyperegistration: meta_types/qt6appdatahandler_debug_metatypes.json
appdataHandler_qmltyperegistration: meta_types/qt6appdatahandler_debug_metatypes.json.gen
appdataHandler_qmltyperegistration: CMakeFiles/appdataHandler_qmltyperegistration.dir/build.make
.PHONY : appdataHandler_qmltyperegistration

# Rule to build all files generated by this target.
CMakeFiles/appdataHandler_qmltyperegistration.dir/build: appdataHandler_qmltyperegistration
.PHONY : CMakeFiles/appdataHandler_qmltyperegistration.dir/build

CMakeFiles/appdataHandler_qmltyperegistration.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/appdataHandler_qmltyperegistration.dir/cmake_clean.cmake
.PHONY : CMakeFiles/appdataHandler_qmltyperegistration.dir/clean

CMakeFiles/appdataHandler_qmltyperegistration.dir/depend:
	cd /Users/luis/Desktop/dataHandler/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/luis/Desktop/dataHandler /Users/luis/Desktop/dataHandler /Users/luis/Desktop/dataHandler/build /Users/luis/Desktop/dataHandler/build /Users/luis/Desktop/dataHandler/build/CMakeFiles/appdataHandler_qmltyperegistration.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : CMakeFiles/appdataHandler_qmltyperegistration.dir/depend

