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
namespace Camilla.Model {
    /**
     * LineOfCode is class that holds information about the number of lines of source code.
     */
    public class LineOfCode : GLib.Object {
        /** Source code file path.*/
        private string filePath = null;
        /** number of blank line */
        uint blank = 0;
        /** number of comment line */
        uint comment = 0;
        /** number of code line */
        uint code = 0;

        /** Constructor */
        public LineOfCode (string filePath, uint blank, uint comment, uint code) {
            this.filePath = filePath;
            this.blank = blank;
            this.comment = comment;
            this.code = code;
        }

        /**
         * Returns  Source code file path .
         */
        public string getFilePath () {
            return filePath;
        }

        /**
         * Returns number of blank line.
         */
        public uint getBlank () {
            return blank;
        }

        /**
         * Returns number of comment line.
         */
        public uint getComment () {
            return comment;
        }

        /**
         * Returns number of code line.
         */
        public uint getCode () {
            return code;
        }
    }
}