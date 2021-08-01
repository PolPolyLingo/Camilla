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
    /**
     * CountLineOfCode is class that count line of code (only for vala).
     * This class external specification is similar to the cloc command.
     * However, implementation is different. I have never seen the source code of the cloc command.
     */
    public class CountLineOfCode : GLib.Object {
        /**
         * Similar to the cloc command, it counts the number of lines in the source code
         * and displays the result. However, this method only measures the number of lines
         * in the vala source code.
         * @param list List with elements of vala file only.
         * @result true: If the number of lines is measured successfully,
         *         false: list is empty or null.
         */
        public void cloc (List<string> list) {
            if (list.length () == 0) {
                return;
            }
            List<LineOfCode> locList = new List<LineOfCode> ();
            foreach (string file in list) {
                locList.append (count (file));
            }
            showClocResult (locList);
        }

        /**
         * Returns the total value of each blank line, code line, and comment line.
         * @locList　A list of LineOfCode classes that set the number of comment lines,
         *           the number of blank lines, and the number of code lines.
         * @return LineOfCode that already setted total value of each blank line, code line, and comment line.
         */
        private LineOfCode calcSumLineOfCode (List<LineOfCode> locList) {
            uint blankCnt = 0;
            uint commentCnt = 0;
            uint codeCnt = 0;

            foreach (var loc in locList) {
                blankCnt += loc.getBlank ();
                commentCnt += loc.getComment ();
                codeCnt += loc.getCode ();
            }
            return new LineOfCode ("Sum", blankCnt, commentCnt, codeCnt);
        }

        private void showClocResult (List<LineOfCode> locList) {
            var sum = calcSumLineOfCode (locList);
            stdout.printf ("-------------------------------------------------------------------------------\n");
            stdout.printf ("File                                        blank        comment           code\n");
            stdout.printf ("-------------------------------------------------------------------------------\n");
            foreach (var loc in locList) {
                stdout.printf ("%-44s%5u        %7u         %6u\n",
                               loc.getFilePath (), loc.getBlank (), loc.getComment (), loc.getCode ());
            }
            stdout.printf ("-------------------------------------------------------------------------------\n");
            stdout.printf ("%-44s%5u        %7u         %6u\n",
                           sum.getFilePath (), sum.getBlank (), sum.getComment (), sum.getCode ());
            stdout.printf ("-------------------------------------------------------------------------------\n");
        }

        /**
         * Returns the number of comment lines, blank lines, and code lines in the source code.
         * @filePath file path to be checked.
         * @return Result that count Line Of Code.
         */
        private LineOfCode count (string filePath) {
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
        private List<string> getCodeWithoutComment (string filePath) {
            DeleteComment dc = new DeleteComment ();
            if (!dc.deleteComment (filePath)) {
                return new List<string>();
            }
            return dc.getCodeWithoutComment ();
        }

        /**
         * Return number of blank line.
         * @param codeWithoutComment source code string without comment
         * @return number of blank line
         */
        private uint countBlankLine (List<string> codeWithoutComment) {
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