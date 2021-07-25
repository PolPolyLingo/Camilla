/*
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
namespace Camilla.Core {
    /**
     * Print class is a collection of static APIs for standard output.
     */
    public class Stdout : GLib.Object {
        private const string red = "\x1b[31m";
        private const string green = "\x1b[32m";
        private const string yellow = "\x1b[33m";
        private const string purple = "\x1b[34m";
        private const string cyan = "\x1b[36m";
        private const string magenta = "\x1b[35m";
        private const string end = "\x1b[00m";

        public enum Color {
            RED,
            GREEN,
            YELLOW,
            PURPLE,
            CYAN,
            MAGENTA,
            DEFALUT
        }

        /**
         * Print message with line number.
         * This method was created for the -n option (an option that assigns line numbers)
         * that is common in UNIX commands.
         */
        public static void printWithLineNumber (string str) {
            if (Objects.isNull (str)) {
                return;
            }

            string[] lines = str.split ("\n"); // Only Unix Line Feed.
            string format = "%0" + (lines.length / 10).to_string () +
                            "d: %s\n";
            uint lineNr = 1;
            foreach (string line in lines) {
                /** Last line is only line feed. */
                if (lineNr != lines.length) {
                    stdout.printf (format, lineNr, line);
                    lineNr++;
                }
            }
        }

        /**
         * Print message in red letters.
         * @param str string to display.
         */
        public static void printRed (string format, ...) {
            va_list va_list = va_list ();
            string res = format.vprintf (va_list);
            stdout.printf (red);
            print (res);
            stdout.printf (end);
        }

        /**
         * Print message in green letters.
         * @param str string to display.
         */
        public static void printGreen (string format, ...) {
            va_list va_list = va_list ();
            string res = format.vprintf (va_list);
            stdout.printf (green);
            print (res);
            stdout.printf (end);
        }

        /**
         * Print message in yellow letters.
         * @param str string to display.
         */
        public static void printYellow (string format, ...) {
            va_list va_list = va_list ();
            string res = format.vprintf (va_list);
            stdout.printf (yellow);
            print (res);
            stdout.printf (end);
        }

        /**
         * Print message in purple letters.
         * @param str string to display.
         */
        public static void printPurple (string format, ...) {
            va_list va_list = va_list ();
            string res = format.vprintf (va_list);
            stdout.printf (purple);
            print (res);
            stdout.printf (end);
        }

        /**
         * Print message in cyan letters.
         * @param str string to display.
         */
        public static void printCyan (string format, ...) {
            va_list va_list = va_list ();
            string res = format.vprintf (va_list);
            stdout.printf (cyan);
            print (res);
            stdout.printf (end);
        }

        /**
         * Print message in magenta letters.
         * @param str string to display.
         */
        public static void printMagenta (string format, ...) {
            va_list va_list = va_list ();
            string res = format.vprintf (va_list);
            stdout.printf (magenta);
            print (res);
            stdout.printf (end);
        }

        /**
         * Print message in default color letters.
         * @param str string to display.
         */
        public static void printDefault (string format, ...) {
            va_list va_list = va_list ();
            string res = format.vprintf (va_list);
            print (res);
        }
    }
}