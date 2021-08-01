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
     * SourceCodeParser extracts class names, variable names, method names, and
     * method definitions.
     */
    public class SourceCodeParser : GLib.Object {
        /**
         * After parsing the source code (one file) without comments,
         * the data of the namespace in the source code is returned.
         * @param sc source code without comment
         * @return date in namespace.
         */
        public static Namespace parse (SourceCode sc) {
            return new Namespace (new List<Class>(), new List<Struct>());
        }
    }
}