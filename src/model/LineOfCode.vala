/*
 * LineOfCode.vala
 *
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
namespace Camilla.Model {
    /** LineOfCode is class that holds information about the number of lines of source code. */
    public class LineOfCode : GLib.Object {
        /** Source code file path.*/
        private string _filePath;
        public string filePath {
            get {
                return _filePath;
            }
        }
        /** number of blank line */
        private uint _blank;
        public uint blank {
            get {
                return _blank;
            }
        }
        /** number of comment line */
        private uint _comment;
        public uint comment {
            get {
                return _comment;
            }
        }
        /** number of code line */
        private uint _code;
        public uint code {
            get {
                return _code;
            }
        }

        /** Constructor */
        public LineOfCode (string filePath, uint blank, uint comment, uint code) {
            this._filePath = filePath;
            this._blank = blank;
            this._comment = comment;
            this._code = code;
        }
    }
}