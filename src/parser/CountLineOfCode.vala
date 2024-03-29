/*
 * CountLineOfCode.vala
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
using Camilla.Core;
using Camilla.Model;

namespace Camilla.Parser {
    /**
     * CountLineOfCode is class that count line of code (only for vala).
     * This class external specification is similar to the cloc command.
     * However, implementation is different. I have never seen the source code of the cloc command.
     */
    public class CountLineOfCode : GLib.Object {
        /** logger  */
        private Log4Vala.Logger logger;
        /** File list that failed to parse. */
        private List<string> parseFailedFileList;

        /** Constructor */
        public CountLineOfCode () {
            logger = Log4Vala.Logger.get_logger ("CountLineOfCode.class");
            parseFailedFileList = new List<string> ();
        }

        /**
         * Similar to the cloc command, it counts the number of lines in the source code
         * and displays the result. However, this method only measures the number of lines
         * in the vala source code.
         * @param list List with elements of vala file only.
         * @result String list containing filenames that failed to parse
         */
        public List<string> cloc (List<string> list) {
            if (list.length () == 0) {
                logger.warn ("File list is empty. Unable to calculate the number of lines of code.");
                return parseFailedFileList.copy_deep (strdup);
            }
            List<LineOfCode> locList = new List<LineOfCode> ();
            foreach (string file in list) {
                locList.append (count (file));
            }
            showClocResult (locList);
            return parseFailedFileList.copy_deep (strdup);
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
                blankCnt += loc.blank;
                commentCnt += loc.comment;
                codeCnt += loc.code;
            }
            return new LineOfCode ("Sum", blankCnt, commentCnt, codeCnt);
        }

        private void showClocResult (List<LineOfCode> locList) {
            var sum = calcSumLineOfCode (locList);
            stdout.printf ("---------------------------------------------------------------------------------------\n");
            stdout.printf ("File                                                blank        comment           code\n");
            stdout.printf ("---------------------------------------------------------------------------------------\n");
            foreach (var loc in locList) {
                stdout.printf ("%-52s%5u        %7u         %6u\n",
                               loc.filePath, loc.blank, loc.comment, loc.code);
            }
            stdout.printf ("---------------------------------------------------------------------------------------\n");
            stdout.printf ("%-52s%5u        %7u         %6u\n",
                           sum.filePath, sum.blank, sum.comment, sum.code);
            stdout.printf ("---------------------------------------------------------------------------------------\n");
        }

        /**
         * Returns the number of comment lines, blank lines, and code lines in the source code.
         * @filePath file path to be checked.
         * @return Result that count Line Of Code.
         */
        private LineOfCode count (string filePath) {
            if (Objects.isNull (filePath)) {
                logger.warn ("The file path to be counted is null. The counting target file list is abnormal.");
                return new LineOfCode ("!!! Parse error !!!", 0, 0, 0);
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
                logger.warn ("Comment deletion failed.");
                parseFailedFileList.append (filePath);
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