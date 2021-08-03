/*
 * Struct.vala
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
    /** Struct is Model class for struct. */
    public class Struct : GLib.Object {
        /** Struct member variable. */
        private List<Variable> _memberList;
        public List<Variable> memberList {
            get {
                return _memberList;
            }
        }

        /** Constructor */
        public Struct (List<Variable> memberList) {
            this._memberList = memberList.copy_deep (Variable.copyVariable);
        }

        /**
         * Deep copy method for Struct class.
         * This method is used for delegate method in copy_deep().
         * @param src copy target
         * @result copied Struct class
         */
        public static Struct copyStruct (Struct src) {
            if (Objects.isNull (src)) {
                return new Struct (new List<Variable>());
            }
            return new Struct (src.memberList.copy_deep (Variable.copyVariable));
        }
    }
}