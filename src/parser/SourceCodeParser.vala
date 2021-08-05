/*
 * SourceCodeParser.vala
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
using Gee;

namespace Camilla.Parser {
    /**
     * SourceCodeParser extracts class names, variable names, method names, and
     * method definitions.
     */
    public class SourceCodeParser : GLib.Object {
        /** logger  */
        private Log4Vala.Logger logger;

        /** Constructor */
        public SourceCodeParser () {
            logger = Log4Vala.Logger.get_logger ("SourceCodeParser.class");
        }

        /**
         * After parsing the source code (one file) without comments,
         * the data of the namespace in the source code is returned.
         * @param sc source code without comment
         * @return date in namespace.
         */
        public Namespace parse (SourceCode sc) {
            NamespaceExtractor ne = new NamespaceExtractor ();
            HashMap<string, string> namespaceMap = ne.parse (sc);

            foreach (string key in namespaceMap.keys) {
                // var code = namespaceMap.get (key);
                logger.info ("[file]=" + sc.filePath + " [namespace]=" + key);
            }
            return new Namespace (new GLib.List<Class>(), new GLib.List<Struct>());
        }
    }

    private class NamespaceExtractor : GLib.Object {
        /** Namespace Map: key=namespace name, value=source code in namespace */
        private HashMap<string, string> namespaceMap;
        /** Parse state */
        private STATE state = NOT_FOUND_NAMESPACE;
        /** Curly braces to determine the start and end of a namespace */
        uint curlyBraces = 0;
        /** logger  */
        private Log4Vala.Logger logger;

        /** Constructor */
        public NamespaceExtractor () {
            namespaceMap = new HashMap<string, string> ();
            logger = Log4Vala.Logger.get_logger ("NamespaceExtractor.class");
        }

        /** Parsing namespace state.*/
        enum STATE {
            NOT_FOUND_NAMESPACE, /** Not found namespace during parsing(Or finished parsing one namespace) */
            STRING_LITERAL, /** String enclosed in double quotes */
            FOUND_NAMESPACE, /** Found namespace during parsing */
            STRING_LITERAL_IN_NAMESPACE /** String enclosed in double quotes in namespace */
        }

        /**
         * Pass the source code and extract the namespace name and the strings
         * contained in that namespace.
         * @param sc source code without comment.
         * @result Namespace Map (key=namespace name, value=source code in namespace)
         * @note TBD: Does not support nested namespaces. It's like below,
         * ----NG case----
         * namespace NameSpaceName1 {
         *     namespace NameSpaceName2 {
         *     }
         * }
         * ---------------
         * ----OK case----
         * namespace NameSpaceName1.NameSpaceName2 {
         * }
         * ---------------
         */
        public HashMap<string, string> parse (SourceCode sc) {
            string code = String.toString (sc.code);
            string strInNamespace = "";
            string namespaceName = "";
            string nowStr = "";

            for (int i = 0; i < code.length; i++) {

                nowStr = code.substring (i, 1);
                if (transitionFoundNamespaceIfNeeded (strInNamespace, nowStr)) {
                    namespaceName = decideNamespaceName (strInNamespace);
                }
                transitionStateForStringLiteralIfNeeded (strInNamespace, nowStr);
                countCurlyBracesIfNeeded (nowStr);
                strInNamespace += nowStr;

                if (state == STATE.FOUND_NAMESPACE && curlyBraces == 0) {
                    namespaceMap.set (namespaceName, strInNamespace);
                    namespaceName = "";
                    strInNamespace = "";
                    state = STATE.NOT_FOUND_NAMESPACE;
                }
            }

            if (hasGlobalNamespace (strInNamespace)) {
                namespaceMap.set ("global", strInNamespace);
            }

            if (curlyBraces != 0) {
                logger.warn ("The number of curly braces does not match. Number od curry brace="
                             + curlyBraces.to_string ());
                logger.warn ("File that may have failed to parse:" + sc.filePath);
            }
            return namespaceMap;
        }

        /**
         * If the namespace is found in a string, change the state.
         * @strInNamespace String in parse.
         * @return true: state is changed, false: state is not change
         */
        private bool transitionFoundNamespaceIfNeeded (string strInNamespace, string nowStr) {
            if (state == STATE.NOT_FOUND_NAMESPACE && strInNamespace.contains ("namespace") && nowStr == "{") {
                state = STATE.FOUND_NAMESPACE;
                return true;
            }
            return false;
        }

        /**
         * If the string litreal is found, change the state.
         * @param nowStr String being parsed
         */
        private void transitionStateForStringLiteralIfNeeded (string strInNamespace, string nowStr) {
            string lastChar = "";
            if (strInNamespace.length != 0) {
                lastChar = strInNamespace.substring (strInNamespace.length - 1);
            }

            if (lastChar == "'" && state != STATE.STRING_LITERAL && state != STATE.STRING_LITERAL_IN_NAMESPACE) {
                return;
            }

            if (state == STATE.NOT_FOUND_NAMESPACE && lastChar != "\\" && nowStr == "\"") {
                state = STATE.STRING_LITERAL;
            } else if (state == STATE.FOUND_NAMESPACE && lastChar != "\\" && nowStr == "\"") {
                state = STATE.STRING_LITERAL_IN_NAMESPACE;
            } else if (state == STATE.STRING_LITERAL && lastChar != "\\" && nowStr == "\"") {
                state = STATE.NOT_FOUND_NAMESPACE;
            } else if (state == STATE.STRING_LITERAL_IN_NAMESPACE && lastChar != "\\" && nowStr == "\"") {
                state = STATE.FOUND_NAMESPACE;
            }
        }

        /**
         * Count the number of parentheses to determine the start and end
         * of a namespace.
         * @param nowStr String being parsed
         */
        private void countCurlyBracesIfNeeded (string nowStr) {
            if (state == STATE.FOUND_NAMESPACE && nowStr == "{") {
                curlyBraces++;
            } else if (state == STATE.FOUND_NAMESPACE && nowStr == "}") {
                curlyBraces--;
            }
        }

        /**
         * Extract XXXXX from a string of the form "namespace XXXXX".
         * "XXXXX" is the name of the namespace.
         * @param strInNamespace string include "namespace XXXXX"
         * @result string of namespace name.
         */
        private string decideNamespaceName (string strInNamespace) {
            var tmp = strInNamespace.dup ();
            /** Delete strings that appear before "namespace". */
            tmp = tmp.replace ("\n", "");
            tmp = tmp.substring (tmp.index_of ("namespace"), tmp.length - tmp.index_of ("namespace"));
            tmp = tmp.replace ("namespace", "");
            tmp = String.trim (tmp);
            return tmp.dup ();
        }

        /**
         * Returns whether the namespace is not explicitly specified.
         * In this case, it belongs to the global namespace.
         * @param strInNamespace String in parse.
         * @result true: global namespace, false: not global namespace
         */
        private bool hasGlobalNamespace (string strInNamespace) {
            var tmp = strInNamespace.dup ();
            tmp = tmp.replace ("\n", "");
            tmp = String.trim (tmp);
            return (tmp.length != 0) ? true : false;
        }
    }
}