/*
 * TestRunner.vala
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
public static int main (string[] args) {
    Test.init (ref args);

    TestSuite.get_root ().add_suite (new Log4ValaTest.Config ().get_suite ());
    TestSuite.get_root ().add_suite (new Log4ValaTest.Level ().get_suite ());
    TestSuite.get_root ().add_suite (new Log4ValaTest.Logger ().get_suite ());
    TestSuite.get_root ().add_suite (new Log4ValaTest.LoggerConfig ().get_suite ());
    TestSuite.get_root ().add_suite (new Log4ValaTest.Layout.SimpleLayout ().get_suite ());
    TestSuite.get_root ().add_suite (new Log4ValaTest.Layout.PatternLayout ().get_suite ());

    return Test.run ();
}