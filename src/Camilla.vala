/*
 * Camilla.vala
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
using Camilla.Model;
using Camilla.Parser;
using Log4Vala;

namespace Camilla {
    public class Camilla : GLib.Object {
        /** Argument information. */
        private ArgParser argParser;
        /** File list to be checked.  */
        private List<string> targetFileList;
        /** File list that failed to parse. */
        private List<string> parseFailedFileList;
        /** logger  */
        private Log4Vala.Logger logger;

        /**
         * Application exit status.
         */
        enum EXIT_STATUS {
            SUCCESS,
            FAILURE
        }

        /** Constructor. */
        public Camilla () {
            this.argParser = new ArgParser.Builder ().
                              applicationName ("camilla").
                              applicationArgument ("FILE_NAME or DIRECTORY_NAME or NOTHING").
                              description (N_ ("camilla is static analysis tool for vala language.")).
                              version ("0.1.0").
                              author ("Naohiro CHIKAMATSU <n.chika156@gmail.com>").
                              contact ("https://github.com/nao1215/Camilla").
                              build ();
        }

        /**
         * Start camilla that is static analysis tool for vala language.
         * @param commandline arguments.
         */
        public int run (string[] args) {
            if (!initialize (args)) {
                return EXIT_STATUS.FAILURE;
            }
            logParseTargetFiles ();
            parse ();
            return EXIT_STATUS.SUCCESS;
        }

        /**
         * TBD: Change this function name
         */
        private void parse () {
            if (argParser.hasOption ("c")) {
                CountLineOfCode cloc = new CountLineOfCode ();
                parseFailedFileList = cloc.cloc (targetFileList);
                return;
            }

            logger.debug ("Start parsing.");
            foreach (string file in targetFileList) {
                DeleteComment dc = new DeleteComment ();
                if (!dc.deleteComment (file)) {
                    continue;
                }
                SourceCode sc = new SourceCode (file, dc.getCodeWithoutComment ());
                SourceCodeParser scp = new SourceCodeParser ();
                Namespace namespace = scp.parse (sc);
            }
            logParseFailedFiles ();
        }

        /**
         * Initialize the application
         * @param commandline arguments.
         * @return true: initialize is success, false: need to close the application.
         */
        private bool initialize (string[] args) {
            setOptions ();
            argParser.parse (args);

            if (argParser.hasOption ("d")) {
                debugPrintOn ();
            }
            /**
             * If we don't get the logger at this timing that is the config
             * setting is confirmed, the log level will not be set as expected.
             */
            logger = Log4Vala.Logger.get_logger ("Camilla.class");
            logger.info (Banner.startMsg);
            logger.info (argParser.parseResult ());

            if (argParser.hasOption ("v")) {
                argParser.showVersion ();
                return false;
            }

            if (argParser.hasOption ("h")) {
                argParser.usage ();
                return false;
            }

            if (!decideTargetFileList () || targetFileList.length () == 0) {
                argParser.usage ();
                return false;
            }
            return true;
        }

        /**
         * Set application options.
         */
        private void setOptions () {
            argParser.addOption ("c", "count", N_ ("Count line of codes."));
            argParser.addOption ("d", "debug", N_ ("Show debug log at STDOUT."));
            argParser.addOption ("h", "help", N_ ("Show help message."));
            argParser.addOption ("v", "version", N_ ("Show camilla command version."));
        }

        /**
         * Set file list to be checked.
         * Each element of the list is sorted in ascending order by string.
         * And then, leave only files with the extension ".vala" in the list.
         * @result true: There is .vala file(s), false: There is not .vala file.
         */
        private bool decideTargetFileList () {
            /* target directory is current directory. */
            if (argParser.copyArgWithoutCmdNameAndOptions ().length () == 0) {
                targetFileList = Core.File.walk (".");
                targetFileList.sort (strcmp);
                targetFileList = excludeNotParsedFiles ();
                return true;
            }

            foreach (var path in argParser.copyArgWithoutCmdNameAndOptions ()) {
                if (Core.File.isFile (path)) {
                    targetFileList.append (path);
                    targetFileList = excludeNotParsedFiles ();
                    return true;
                }
                if (Core.File.isDir (path)) {
                    targetFileList = Core.File.walk (path);
                    targetFileList.sort (strcmp);
                    targetFileList = excludeNotParsedFiles ();
                    return true;
                }
                break;
            }
            return false;
        }

        /**
         * Exclude the elements of the list that contains the ".vala" string and not file.
         */
        private List<string> excludeNotParsedFiles () {
            List<string> list = new List<string> ();
            foreach (string element in targetFileList) {
                if (element.contains (".vala") && Core.File.isFile (element)) {
                    list.append (element);
                }
            }
            return list.copy_deep (strdup);
        }

        /**
         * Logs with a log level of INFO or higher are output to the user.
         * Delete the default settings and overwrite the debug log settings.
         * Therefore, the setting for writing to the log file and the
         * log level are different from initial setteing.
         * And then, show only messages. Not show log level or time information or other information.
         */
        private void debugPrintOn () {
            var config = Log4Vala.Config.get_config ();
            config.set_defaults ();

            config.root_level = Level.INFO;
            config.root_appender.layout = new Log4Vala.Layout.PatternLayout ();
            var layout = (Log4Vala.Layout.PatternLayout)config.root_appender.layout;
            layout.pattern = "%m"; /* Only show message. */
        }

        /**
         * Log the file list to be parsed.
         * Use this method after decideTargetFileList().
         */
        private void logParseTargetFiles () {
            logger.info ("[Parse taget files]");
            foreach (string element in targetFileList) {
                logger.info (" " + element);
            }
        }

        /**
         * Log files that failed parse.
         */
        private void logParseFailedFiles () {
            logger.info ("[Parse failed files]");
            if (parseFailedFileList.length () == 0) {
                logger.info (" Nothing.");
                return;
            }
            foreach (var file in parseFailedFileList) {
                logger.info (" " + file);
            }
        }
    }
}
