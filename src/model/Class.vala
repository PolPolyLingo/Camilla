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

using Gee;

namespace Camilla.Model {
    public class Class : GLib.Object {
        /** Source code file path that this class was implemented.*/
        private string filePath = null;
        /** Function Map: key=function name, value=Function(has name and implementation) */
        HashMap<string, Function> FunctionMap;

        public Class (string filePath) {
            this.filePath = filePath;
            this.FunctionMap = new HashMap<string, Function>();
        }
    }
}