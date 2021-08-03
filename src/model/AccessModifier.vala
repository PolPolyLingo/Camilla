/*
 * AccessModifier.vala
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
namespace Camilla.Model {
    /** Enum representation of Access modifiers in vala language. */
    public enum AccessModifiers {
        PUBLIC, /** No restrictions to access. */
        PRIVATE, /** Access is limited to within the class/struct definition. */
        PROTECTED, /** Access is limited to within the class definition and any class that inherits from the class */
        INTERNAL, /** Access is limited eclusively to classes defined within the same package */
    }

    /** AccessModifier is Model class for access modifiers. */
    public class AccessModifier {
        /** Access modifiers. */
        private AccessModifiers _access;
        public AccessModifiers access {
            get {
                return _access;
            }
        }

        /** Constructor */
        public AccessModifier (AccessModifiers am) {
            this._access = am;
        }

        /**
         * Convert the representation of access modifier
         * from string type to enum type.
         * @param am string of access modifier.
         * @return Access modifier converted from string type to enum type.
         */
        public AccessModifiers toAccessModifier (string am) {
            AccessModifiers modifier = AccessModifiers.PRIVATE;
            switch (am) {
                case "public":
                    modifier = AccessModifiers.PUBLIC;
                    break;
                case "private":
                    modifier = AccessModifiers.PRIVATE;
                    break;
                case "protected":
                    modifier = AccessModifiers.PROTECTED;
                    break;
                case "":
                    modifier = AccessModifiers.INTERNAL;
                    break;
                default:
                    modifier = AccessModifiers.PRIVATE;
                    break;
            }
            return modifier;
        }
    }
}