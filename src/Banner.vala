/*
 * Banner.vala
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
namespace Camilla {
    /**
     * Banner class that manages the banner message constants displayed
     * to the user.
     */
    public class Banner : GLib.Object {
        public const string startMsg =
            "== Start ===========================================\n" +
            "  Camilla is static analysis tool for Vala.         \n" +
            "  URL: https://github.com/nao1215/Camilla           \n" +
            "====================================================";
    }
}