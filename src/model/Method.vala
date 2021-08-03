/*
 * Method.vala
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

namespace Camilla.Model {
    /** Class is Model class for method definition. */
    public class Method : GLib.Object {
        /** Method name.*/
        private string _name;
        public string name {
            get {
                return _name;
            }
        }
        /** Method implementation. */
        private List<string> _implementation;
        public List<string> implementation {
            get {
                return _implementation;
            }
        }

        /** Constructor */
        public Method (string name, List<string> implementation) {
            this._name = name;
            this._implementation = implementation.copy_deep (strdup);
        }

        /**
         * Deep copy method for Method class.
         * This method is used for delegate method in copy_deep().
         * @param src copy target
         * @result copied Method class
         */
        public static Method copyMethod (Method src) {
            if (Objects.isNull (src)) {
                return new Method ("", new List<string>());
            }
            return new Method (src.name, src.implementation.copy_deep (strdup));
        }
    }
}