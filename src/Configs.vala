/*
 * Config.vala
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

namespace Camilla {
    /**
     * Configs class to configure Camilla application.
     * Named Config "s" to avoid having the same name as Log4vala's Config class.
     */
    public class Configs : GLib.Object {
        public const string APPLICATION_NAME = "camilla";
        /** Default settings for logs */
        const string DEFAULT_LOG_CONF_PATH = "/usr/share/camilla/camilla-log4vala.conf";
        /**This path that used by developers in environments where Camilla is not yet installed. */
        const string DEVELOPER_LOG_CONF_PATH = "data/camilla-log4vala.conf";

        /**
         * Search for log configuration files with the following priorities.
         * - ${HOME}/.config/camilla/camilla-log4vala.conf
         * - /usr/share/camilla/camilla-log4vala.conf
         * - data/camilla-log4vala.conf (This path is relative path from the project root)
         * Returns the path of the earliest found log configuration file.
         * @return log conf file path or null.
         */
        public static string ? logConfFilePath () {
            var userSettingFilePath = GLib.Environment.get_home_dir () + "/.config/camilla/camilla-log4vala.conf";

            if (Core.File.isFile (userSettingFilePath)) {
                return userSettingFilePath.dup ();
            }
            if (Core.File.isFile (DEFAULT_LOG_CONF_PATH)) {
                return DEFAULT_LOG_CONF_PATH.dup ();
            }
            if (Core.File.isFile (DEVELOPER_LOG_CONF_PATH)) {
                return DEVELOPER_LOG_CONF_PATH.dup ();
            }
            return null;
        }
    }
}