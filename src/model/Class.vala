/*
 * Class.vala
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

using Gee;
using Camilla.Core;

namespace Camilla.Model {
    /** Class is Model class for class definition. */
    public class Class : GLib.Object {
        /** Source code file path that this class was implemented.*/
        private string _filePath;
        public string filePath {
            get {
                return _filePath;
            }
        }
        /** Method Map: key=method name, value=method(has name and implementation) */
        private HashMap<string, Method> _methodMap;
        public HashMap<string, Method> methodMap {
            get {
                return _methodMap;
            }
        }

        /** Constructor */
        public Class (string filePath, HashMap<string, Method> methodMap) {
            this._filePath = filePath;
            this._methodMap = methodMap;
        }

        /**
         * Deep copy method for Variable class.
         * This method is used for delegate method in copy_deep().
         * @param src copy target
         * @result copied Variable class
         */
        public static Class copyClass (Class src) {
            if (Objects.isNull (src)) {
                var map = new HashMap<string, Method>();
                return new Class ("", map);
            }
            return new Class (src.filePath, src.methodMap);
        }
    }
}