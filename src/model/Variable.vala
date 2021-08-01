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

namespace Camilla.Model {
    /**
     * Variable is Model class for variable.
     * This class containes variable name, access modifier, variable type.
     */
    public class Variable : GLib.Object {
        /** Variable name. */
        private string _name;
        public string name {
            get {
                return _name;
            }
        }
        /** Variable type. */
        private string _dataType;
        public string dataType {
            get {
                return _dataType;
            }
        }

        /** Constructor */
        public Variable (string name, string dataType) {
            this._name = name;
            this._dataType = dataType;
        }

        /**
         * Deep copy method for Variable class.
         * This method is used for delegate method in copy_deep().
         * @param src copy target
         * @result copied Variable class
         */
        public static Variable copyVariable (Variable src) {
            if (Objects.isNull (src)) {
                return new Variable ("", "");
            }
            return new Variable (src.name, src.dataType);
        }
    }
}