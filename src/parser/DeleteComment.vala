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

namespace Camilla.Parser {
    /**
     * DeleteComment is class that delete comment from vala source code.
     * Source code without comments is returned as a List<string>.
     */
    public class DeleteComment : GLib.Object {
        /** Result ehether the deletion was successful. */
        private bool result = false;
        /** Source code without comment. When not execute delete(), this variable is "".*/
        private string codeWithoutComment = "";
        /** Source code file path.*/
        private string filePath;
        /** Now parsing character */
        private unichar nowChar = '\0';
        /** Previous character */
        private unichar prevChar = '\0';
        /** Two times previous character */
        private unichar prevprevChar = '\0';
        /** source code parse status */
        private STATE state = STATE.CODE;
        /** Constant definition for avoiding unnatural formats */
        private const unichar DOUBLE_QUOTE = '"';

        /** Parsing code state */
        enum STATE {
            CODE, /** Source code without string literal */
            C_STYLE_COMMENT, /** C style commet ("/" "*" + "*" "/") */
            CPP_STYLE_COMMENT, /** C++ style commet("//") */
            STRING_LITERAL /** String enclosed in double quotes */
        }

        /**
         * Delete comment from source code and save code without comment.
         * @param filePath file path to the code to delete the comment
         */
        public bool deleteComment (string filePath) {
            bool headerIsCStyleComment = false;
            this.filePath = filePath;
            if (!Core.File.canRead (filePath)) {
                return result;
            }

            string fileContens = fileToStr (filePath);
            for (int i = 0; i < fileContens.length; i++) {
                if (fileContens.valid_char (i)) {
                    nowChar = fileContens.get_char (i);
                    if (skipEndOfCStyleComment ()) {
                        continue;
                    }

                    if (skipCPlusPlusComment ()) {
                        continue;
                    }

                    if (skipEndOfStringLiteral ()) {
                        continue;
                    }

                    if (transitionStartCStyleCommentIfNeeded ()) {
                        if (codeWithoutComment.length == 0) {
                            headerIsCStyleComment = true;
                        }
                        continue;
                    }

                    if (transitionStartCPlusPlusStyleCommentIfNeeded ()) {
                        continue;
                    }

                    if (prevChar != '\0') {
                        codeWithoutComment += prevChar.to_string ();
                    }
                    transitionStartStringLiteralIfNeeded ();
                    prevprevChar = prevChar;
                    prevChar = nowChar;
                }
            }

            if (prevChar != '\0' && (state == STATE.CODE || state == STATE.STRING_LITERAL)) {
                codeWithoutComment += prevChar.to_string ();
            }

            /*
             * If the source code was started with a C-style comment,
             * an unnecessary line break remains in the string for the first character.
             * So, delete first line feed.
             */
            if (headerIsCStyleComment) {
                codeWithoutComment = codeWithoutComment.substring (1, codeWithoutComment.length - 1);
            }
            result = true;
            return result;
        }

        /**
         * Skip end of C style comment.
         * @result true: can parse next character, false: can not parse next character.
         */
        private bool skipEndOfCStyleComment () {
            if (state == STATE.C_STYLE_COMMENT) {
                if (prevprevChar != '\\' && prevChar == '*' && nowChar == '/') {
                    state = STATE.CODE;

                    int offset = codeWithoutComment.last_index_of_char ('\n');
                    if (offset >= 0) {
                        codeWithoutComment = codeWithoutComment.substring (0, offset);
                    }
                    resetPreAndPrePreChar ();
                } else if (nowChar == '\n') {
                    resetPreAndPrePreChar ();
                } else {
                    prevprevChar = prevChar;
                    prevChar = nowChar;
                }
                return true;
            }
            return false;
        }

        /**
         * Skip C++ style comment(e.g. //).
         * @result true: can parse next character, false: can not parse next character.
         */
        private bool skipCPlusPlusComment () {
            if (state == STATE.CPP_STYLE_COMMENT) {
                if (nowChar == '\n') {
                    state = STATE.CODE;

                    long offset = codeWithoutComment.length - 1;
                    if (offset >= 0 && codeWithoutComment.substring (offset) != "\n") {
                        codeWithoutComment += nowChar.to_string ();
                    }
                    resetPreAndPrePreChar ();
                }
                return true;
            }
            return false;
        }

        /**
         * Skip to the end of the string literal(e.g. "this string is string literal").
         * @result true: can parse next character, false: can not parse next character.
         */
        private bool skipEndOfStringLiteral () {
            if (prevChar != '\\' && nowChar == DOUBLE_QUOTE && state == STATE.STRING_LITERAL) {
                state = STATE.CODE;
                codeWithoutComment += prevChar.to_string ();
                prevprevChar = prevChar;
                prevChar = nowChar;
                return true;
            }
            return false;
        }

        /**
         * If C-style comment has started, the state transitions.
         * @result true: can parse next character, false: can not parse next character.
         */
        private bool transitionStartCStyleCommentIfNeeded () {
            if (prevprevChar != '\\' && prevChar == '/' && nowChar == '*' && state == STATE.CODE) {
                state = STATE.C_STYLE_COMMENT;
                resetPreAndPrePreChar ();
                return true;
            }
            return false;
        }

        /**
         * If C++ comment has started, the state transitions.
         * @result true: can parse next character, false: can not parse next character.
         */
        private bool transitionStartCPlusPlusStyleCommentIfNeeded () {
            if (prevprevChar != '\\' && prevChar == '/' && nowChar == '/' && state == STATE.CODE) {
                state = STATE.CPP_STYLE_COMMENT;
                resetPreAndPrePreChar ();
                return true;
            }
            return false;
        }

        /**
         * If string enclosed in double quotes has started, the state transitions.
         * @result true: can parse next character, false: can not parse next character.
         */
        private void transitionStartStringLiteralIfNeeded () {
            if (nowChar == DOUBLE_QUOTE) {
                state = STATE.STRING_LITERAL;
            }
        }

        /**
         * Convert the contents of the file to string type.
         * @param filePath convert target file path.
         * @note This method does not check whether file exists and read.
         */
        private string fileToStr (string filePath) {
            char buf[2048];
            string str = "";

            FileStream stream = FileStream.open (filePath, "r");

            while (stream.gets (buf) != null) {
                str = str + ((string) buf);
            }
            return str;
        }

        /** Set '\0' for prevChar and preprevChar. */
        private void resetPreAndPrePreChar () {
            prevprevChar = '\0';
            prevChar = '\0';
        }

        /**
         * Return source code without comment.
         * @return List<string> that source code without comment or null.
         *
         */
        public List<string> getCodeWithoutComment () {
            return result ? String.toLines (codeWithoutComment) : null;
        }
    }
}
