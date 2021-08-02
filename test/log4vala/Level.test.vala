/*
 * Level.test.vala
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
public class Log4ValaTest.Level : AbstractTestCase {
    public Level () {
        base ("Level");
        add_test ("check_trace", check_trace);
        add_test ("check_debug", check_debug);
        add_test ("check_info", check_info);
        add_test ("check_warn", check_warn);
        add_test ("check_error", check_error);
        add_test ("check_fatal", check_fatal);
        add_test ("friendly_warn", friendly_warn);
        add_test ("by_name_warn", by_name_warn);
    }

    public void check_trace () {
        assert (Log4Vala.Level.TRACE > -1);
    }

    public void check_debug () {
        assert (Log4Vala.Level.DEBUG > -1);
    }

    public void check_info () {
        assert (Log4Vala.Level.INFO > -1);
    }

    public void check_warn () {
        assert (Log4Vala.Level.WARN > -1);
    }

    public void check_error () {
        assert (Log4Vala.Level.ERROR > -1);
    }

    public void check_fatal () {
        assert (Log4Vala.Level.FATAL > -1);
    }

    public void friendly_warn () {
        assert (Log4Vala.Level.WARN.friendly () == "WARN");
    }

    public void by_name_warn () {
        assert (Log4Vala.Level.get_by_name ("warn") != null);
        assert (Log4Vala.Level.get_by_name ("warn") == Log4Vala.Level.WARN);
    }
}