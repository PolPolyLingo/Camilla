% CAMILLA(1)
% Naohiro CHIKAMATSU <n.chika156@gmail.com>
% August 2020

# NAME

camilla –  static analysis tool for vala language

# SYNOPSIS

**camilla** [OPTIONS] DIRECTORY_PATH

# DESCRIPTION
**camilla** statically analyzes * .vala files under specified directory or under the current directory.

# OPTIONS
**-c**, **--count**
:   Counts the number of lines of Vala language source code (code lines, comment lines, blank lines).

**-d**, **--debug**
:   Show debug log at STDOUT.

**-h**, **--help**
:   Show help message.

**-v**, **--version**
:   Show camilla command version.

# EXIT VALUES
**0**
:   Success

**1**
:   There is an error in the argument of the camilla command.

# BUGS
See GitHub Issues: https://github.com/nao1215/Camilla/issues

# LICENSE
The camilla command project is licensed under the terms of the Apache License 2.0.