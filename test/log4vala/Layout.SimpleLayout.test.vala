/*
 * Layout.SimpleLayout.test.vala
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
public class Log4ValaTest.Layout.SimpleLayout : AbstractTestCase {
    public SimpleLayout () {
        base ("Layout.SimpleLayout");
        add_test ("format", format);
        add_test ("format.with.null", format_with_null);
    }

    public void format () {
        var layout = new Log4Vala.Layout.SimpleLayout ();
        assert (layout != null);
        assert (layout.header == null);
        assert (layout.footer == null);
        var event = new Log4Vala.LogEvent.with_message (
            "some.test",
            Log4Vala.Level.TRACE,
            "a test message"
        );
        assert (layout.format (event) == "TRACE - a test message");
    }

    public void format_with_null () {
        var layout = new Log4Vala.Layout.SimpleLayout ();
        assert (layout != null);
        assert (layout.header == null);
        assert (layout.footer == null);
        var event = new Log4Vala.LogEvent.with_message (
            "some.test",
            Log4Vala.Level.TRACE,
            null
        );
        assert (layout.format (event) == "TRACE - (null)");
    }
}
