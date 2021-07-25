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
namespace Camilla.Core {
    /**
     * Objects class is a collection of static APIs for manipulating objects
     */
    public class String : GLib.Object {
        /**
         * Check whether sring is null or empty.
         * @param str string for checking.
         * @return true: string is null or empty, false: otherwise
         */
        public static bool isNullOrEmpty (string str) {
            return (Objects.isNull (str)) || (str == "");
        }

        /**
         * Split the string by the specified number of characters and returns it as an
         * array of strings.
         * @param str Character string to be splited
         * @return Array of split string.
         */
        public static string[] splitByNum (string str, uint num) {
            if (Objects.isNull (str) || num == 0) {
                return new string[1];
            }

            string[] strs = {};
            string tmp = "";
            for (int i = 0; i < str.length; i++) {
                tmp += str.get_char (i).to_string ();
                if (i != 0 && i % num == 0) {
                    strs += tmp;
                    tmp = "";
                }
            }
            strs += tmp;
            return strs;
        }

        /**
         * The character string is divided using the line feed code as the delimiter.
         * The divided character string is returned in list format.
         * @param str string to be divided
         * @result string converted to List<string>
         */
        public static List<string> toLines (string str) {
            List<string> lineList = new List<string>();
            string line = "";

            if (Objects.isNull (str)) {
                return lineList;
            }

            for (int i = 0; i < str.length; i++) {
                if (str.valid_char (i)) {
                    var nowChar = str.get_char (i);
                    line += nowChar.to_string ();

                    if (nowChar == '\n') {
                        lineList.append (line);
                        line = "";
                    }
                }
            }

            return lineList;
        }
    }
}