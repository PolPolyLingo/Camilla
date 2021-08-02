/*
 * Layout.PatternLayout.test.vala
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
public class Log4ValaTest.Layout.PatternLayout : AbstractTestCase {
    public PatternLayout () {
        base ("Layout.PatternLayout");
        add_test ("format_core", format_core);
        add_test ("format_date_default", format_date_default);
        add_test ("format_date_custom", format_date_custom);
        add_test ("format_error_default", format_error_default);
        add_test ("format_error_custom", format_error_custom);
    }

    public void format_core () {
        var layout = new Log4Vala.Layout.PatternLayout ();
        assert (layout != null);
        assert (layout.header == null);
        assert (layout.footer == null);
        layout.pattern = "%p %c %m";
        var event = new Log4Vala.LogEvent.with_message (
            "some.test",
            Log4Vala.Level.TRACE,
            "a test message"
        );
        assert (layout.format (event) == "TRACE some.test a test message");
    }

    public void format_date_default () {
        var layout = new Log4Vala.Layout.PatternLayout ();
        layout.pattern = "%d";
        var event = new Log4Vala.LogEvent.with_message (
            "some.test",
            Log4Vala.Level.TRACE,
            "a test message"
        );
        event.timestamp = new DateTime.utc (2014, 1, 1, 0, 0, 1);
        assert (layout.format (event) == "2014-01-01T00:00:01Z");
    }

    public void format_date_custom () {
        var layout = new Log4Vala.Layout.PatternLayout ();
        layout.pattern = "%d{%Y-%m}";
        var event = new Log4Vala.LogEvent.with_message (
            "some.test",
            Log4Vala.Level.TRACE,
            "a test message"
        );
        event.timestamp = new DateTime.utc (2014, 1, 1, 0, 0, 1);
        assert (layout.format (event) == "2014-01");
    }

    public void format_error_default () {
        var layout = new Log4Vala.Layout.PatternLayout ();
        layout.pattern = "%E";
        try {
            throw_error ();
        } catch (Error e) {
            var event = new Log4Vala.LogEvent.with_message (
                "some.test",
                Log4Vala.Level.TRACE,
                "a test message"
            );
            event.error = e;
            assert (layout.format (event).has_prefix ("2, "));
            assert (layout.format (event).has_suffix (", An error!"));
        }
    }

    public void format_error_custom () {
        var layout = new Log4Vala.Layout.PatternLayout ();
        layout.pattern = "%E{%Ec %Ed %Em}";
        try {
            throw_error ();
        } catch (Error e) {
            var event = new Log4Vala.LogEvent.with_message (
                "some.test",
                Log4Vala.Level.TRACE,
                "a test message"
            );
            event.error = e;
            assert (layout.format (event).has_prefix ("2 "));
            assert (layout.format (event).has_suffix (" An error!"));
        }
    }

    public void throw_error () throws FileError {
        throw new FileError.ACCES ("An error!");
    }
}
