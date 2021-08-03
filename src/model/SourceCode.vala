/*
 * SourceCode.vala
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
    /** SourceCode is Model class for source code without comment. */
    public class SourceCode : GLib.Object {
        /** Source code file path */
        private string _filePath;
        public string filePath {
            get {
                return _filePath;
            }
        }
        /** Source code without comment. */
        private List<string> _code;
        public List<string> code {
            get {
                return _code;
            }
        }

        /** Constructor */
        public SourceCode (string filePath, List<string> code) {
            this._filePath = filePath;
            this._code = code.copy_deep (strdup);
        }
    }
}