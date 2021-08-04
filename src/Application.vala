/*
 * Application.vala
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
using Log4Vala;

namespace Camilla {
    public class Application : GLib.Application  {
        /** entry point. */
        public static int main (string[] args) {
            Log4Vala.init (Configs.logConfFilePath ());
            initTranslationConfig ();
            Environment.set_application_name (Configs.APPLICATION_NAME);
            Environment.set_prgname (Configs.APPLICATION_NAME);

            Camilla camilla = new Camilla ();
            return camilla.run (args);
        }

        /**
         * Make settings for internationalization.
         * The character string enclosed in N_ () is the translation target.
         */
        private static void initTranslationConfig () {
            Intl.setlocale (LocaleCategory.ALL, "");
            Intl.bindtextdomain (GETTEXT_PACKAGE, LOCALEDIR);
            Intl.bind_textdomain_codeset (GETTEXT_PACKAGE, "UTF-8");
            Intl.textdomain (GETTEXT_PACKAGE);
        }
    }
}