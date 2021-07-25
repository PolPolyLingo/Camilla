/*
 * Copyright 2021 Naohiro CHIKAMATSU
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
using Posix;
namespace Camilla.Core {
    public class File : GLib.Object {
        /**
         * Returns a list of files under the specified path.
         * @param path Check target path
         */
        public static List<string> walk (string path) {
            List<string> fileList = new List<string>();
            if (Objects.isNull (path)) {
                GLib.stdout.printf ("Target path is null.\n");
                return fileList;
            }

            try {
                GLib.Dir dir = GLib.Dir.open (path, 0);
                for ( ; ; ) {
                    weak string ? item = dir.read_name ();
                    if (Objects.isNull (item)) {
                        break;
                    }
                    string filePath = Path.build_filename (path, item);
                    if (isFile (filePath) && !isSymbolicFile (filePath)) {
                        fileList.append (filePath);
                    }
                    if (isDir (filePath)) {
                        foreach (string str in walk (filePath)) {
                            fileList.append (str);
                        }
                    }
                }
            } catch (GLib.FileError e) {
                GLib.critical ("Cannot open directory %s\n", path);
                return fileList;
            }

            return fileList;
        }

        /**
         * Deletes the file specified by the argument.
         * @param path file path to be deleted
         */
        public static void delete (string path) {
            if (Objects.isNull (path)) {
                return;
            }

            GLib.File file = GLib.File.new_for_path (path);
            try {
                file.delete ();
                GLib.stdout.printf ("Delete %s\n", path);
            } catch (Error e) {
                GLib.critical ("Cannot delete %s\n", path);
            }
        }

        /**
         * Returns whether the file exists in the specified path.
         * @param path file path to be checked.
         * @return true: path is file, false: path is not file
         */
        public static bool isFile (string path) {
            if (Objects.isNull (path)) {
                return false;
            }
            return FileUtils.test (path, FileTest.IS_REGULAR);
        }

        /**
         * Returns whether the directory exists in the specified path.
         * @param path file path to be checked.
         * @return true: path is directory, false: path is not directory
         */
        public static bool isDir (string path) {
            if (Objects.isNull (path)) {
                return false;
            }
            return FileUtils.test (path, FileTest.IS_DIR);
        }

        /**
         * Returns whether the file can read in the specified path.
         * @param path file path to be checked.
         * @return true: can read, false: can not read.
         */
        public static bool canRead (string path) {
            if (Objects.isNull (path)) {
                return false;
            }
            return (Posix.access (path, R_OK) == 0) ? true : false;
        }

        /**
         * Returns whether the file can write in the specified path.
         * @param path file path to be checked.
         * @return true: can write, false: can not write.
         */
        public static bool canWrite (string path) {
            if (Objects.isNull (path)) {
                return false;
            }
            return (Posix.access (path, W_OK) == 0) ? true : false;
        }

        /**
         * Returns whether the file can execute in the specified path.
         * @param path file path to be checked.
         * @return true: can execute, false: can not execute.
         */
        public static bool canExec (string path) {
            if (Objects.isNull (path)) {
                return false;
            }
            return FileUtils.test (path, FileTest.IS_EXECUTABLE);
        }

        /**
         * Returns whether the symbolic file exists in the specified path.
         * @param path file path to be checked.
         * @return true: path is symbolic file, false: path is not symbolic file
         */
        public static bool isSymbolicFile (string path) {
            if (Objects.isNull (path)) {
                return false;
            }
            return FileUtils.test (path, FileTest.IS_SYMLINK);
        }

        /**
         * Returns whether the hidden file exists in the specified path.
         * @param path file path to be checked.
         * @return true: path is hidden file, false: path is not hidden file
         */
        public static bool isHiddenFile (string path) {
            if (String.isNullOrEmpty (path)) {
                return false;
            }
            return basename (path).get_char (0).to_string () == ".";
        }

        /**
         * Extract the base name (file name) from the file path.
         * @param path file path to be checked.
         * @return string of basename. If path is null or not file path, return "";
         */
        public static string basename (string path) {
            if (String.isNullOrEmpty (path)) {
                return "";
            }
            var file = GLib.File.new_for_path (path);
            return file.get_basename ();
        }

        /**
         * Extract the base name (file name) without extension from the file path.
         * @param path file path to be checked.
         * @return string of basename. If path is null or not file path, return "";
         */
        public static string basename_without_ext (string path) {
            string basename = basename (path);
            string ext = extension (path);

            if (basename == "") {
                return "";
            }
            if (ext == "") {
                return basename;
            }
            return basename.slice (0, basename.last_index_of (ext));
        }

        /**
         * Extract the extension(e.g. ".txt") from the file path.
         * @param path file path to be checked.
         * @return string of extension with dot. If path is null or not file path, return
         *         "";
         */
        public static string extension (string path) {
            string file = basename (path);
            if (String.isNullOrEmpty (file) || !file.contains (".")) {
                return "";
            }
            if (isHiddenFile (file)) {
                /* No extension */
                if (file == file.substring (file.last_index_of ("."))) {
                    return "";
                }
            }
            int start = file.last_index_of (".");
            return file.slice (start, file.length);
        }
    }
}