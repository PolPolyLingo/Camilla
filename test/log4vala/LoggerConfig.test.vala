/*
 * LoggerConfig.test.vala
 *
 * The Log4Vala Project
 *
 * Copyright 2013-2016 Sensical, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
public class Log4ValaTest.LoggerConfig : AbstractTestCase {
    public LoggerConfig () {
        base ("LoggerConfig");
        add_test ("from_config_level_only", from_config_level_only);
        add_test ("from_config_appender_only", from_config_appender_only);
        add_test ("from_config_level_append", from_config_level_append);
    }

    public void from_config_level_only () {
        var config = new Log4Vala.LoggerConfig.from_config ("DEBUG");
        assert (config != null);
        assert (config.level == Log4Vala.Level.DEBUG);
        assert (config.appenders == null);
    }

    public void from_config_appender_only () {
        var config = new Log4Vala.LoggerConfig.from_config ("Appender1");
        assert (config != null);
        assert (config.level == null);
        assert (config.appenders[0] == "Appender1");
    }

    public void from_config_level_append () {
        var config = new Log4Vala.LoggerConfig.from_config ("DEBUG, Appender1, Appender2");
        assert (config != null);
        assert (config.level == Log4Vala.Level.DEBUG);
        assert (config.appenders[0] == "Appender1");
        assert (config.appenders[1] == "Appender2");
    }
}
