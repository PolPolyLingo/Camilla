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
    /** Class is Model class for namespace. */
    public class Namespace : GLib.Object {
        /** Class list in namespace. */
        private List<Class> _classList;
        public List<Class> classList {
            get {
                return _classList;
            }
        }

        /** Struct list in namespace */
        private List<Struct> _structList;
        public List<Struct> structList {
            get {
                return _structList;
            }
        }

        /** Constructor */
        public Namespace (List<Class> classList, List<Struct> structList) {
            this._classList = classList.copy_deep (Class.copyClass);
            this._structList = structList.copy_deep (Struct.copyStruct);
        }
    }
}