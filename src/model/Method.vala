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
     * Class is Model class for method definition.
     */
    public class Method : GLib.Object {
        /** Method name.*/
        private string name;
        /** Method implementation. */
        private string implementation = null;

        /** Constructor */
        public Method (string name, string implementation) {
            this.name = name;
            this.implementation = implementation;
        }

        /**
         * Returns method name.
         */
        public string getName () {
            return name;
        }

        /**
         * Returns method implementation.
         */
        public string getImplementation () {
            return implementation;
        }
    }
}