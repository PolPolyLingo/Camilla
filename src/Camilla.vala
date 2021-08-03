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
            logger = Log4Vala.Logger.get_logger ("Camilla.class");
        }

        /**
         * Start camilla that is static analysis tool for vala language.
         * @param commandline arguments.
         */
        public int run (string[] args) {
            logger.info ("Start");
            if (!initialize (args)) {
                return EXIT_STATUS.FAILURE;
            }
            parse ();

            return EXIT_STATUS.SUCCESS;
        }

        /**
         * TBD: Change this function name
         */
        private void parse () {
            if (argParser.hasOption ("c")) {
                CountLineOfCode cloc = new CountLineOfCode ();
                cloc.cloc (targetFileList);
                return;
            }

            foreach (string file in targetFileList) {
                DeleteComment dc = new DeleteComment ();
                if (!dc.deleteComment (file)) {
                    stdout.printf ("Can't parse %s.", file);
                    continue;
                }
                SourceCode sc = new SourceCode (file, dc.getCodeWithoutComment ());
                SourceCodeParser scp = new SourceCodeParser ();
                Namespace namespace = scp.parse (sc);
            }
        }

        /**
         * Initialize the application
         * @param commandline arguments.
         * @return true: initialize is success, false: need to close the application.
         */
        private bool initialize (string[] args) {
            setOptions ();
            argParser.parse (args);

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
    }
}
