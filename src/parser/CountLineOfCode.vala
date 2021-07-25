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
using Camilla.Core;
using Camilla.Model;

namespace Camilla.Parser {
    public class CountLineOfCode : GLib.Object {

        /**
         * Returns the number of comment lines, blank lines, and code lines in the source code.
         * @filePath file path to be checked.
         * @return Result that count Line Of Code.
         */
        public static LineOfCode count (string filePath) {
            if (Objects.isNull (filePath)) {
                return new LineOfCode ("(null)", 0, 0, 0);
            }

            List<string> codeWithoutComment = getCodeWithoutComment (filePath);
            uint blankCnt = countBlankLine (codeWithoutComment);
            uint commentCnt = Core.File.lines (filePath).length () - codeWithoutComment.length ();
            uint codeCnt = codeWithoutComment.length () - blankCnt;

            return new LineOfCode (filePath, blankCnt, commentCnt, codeCnt);
        }

        /**
         * Return code string of list without comment.
         * @param filePath file path to be checked.
         */
        private static List<string> getCodeWithoutComment (string filePath) {
            DeleteComment dc = new DeleteComment ();
            if (!dc.deleteComment (filePath)) {
                return new List<string>();
            }
            string code = dc.getCodeWithoutComment ();
            return String.toLines (code);
        }

        /**
         * Return number of blank line.
         * @param codeWithoutComment source code string without comment
         * @return number of blank line
         */
        private static uint countBlankLine (List<string> codeWithoutComment) {
            uint count = 0;
            bool notBlank = false;

            foreach (string line in codeWithoutComment) {
                for (int i = 0; i < line.length; i++) {
                    if (line.valid_char (i)) {
                        var nowChar = line.get_char (i);

                        if (nowChar == '\n' || nowChar == ' ' || nowChar == '\t') {
                            continue;
                        } else {
                            i = line.length; /* This line is not blank. */
                            notBlank = true;
                        }
                    }
                }
                if (!notBlank) {
                    count++;
                }
                notBlank = false;
            }
            return count;
        }
    }
}