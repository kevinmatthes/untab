<!------------------------------------------------------------------------------
--
-- Copyright (C) 2022 Kevin Matthes
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License along
-- with this program; if not, write to the Free Software Foundation, Inc.,
-- 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
--
----
--
--  FILE
--      README.md
--
--  BRIEF
--      Important information regarding this project.
--
--  AUTHOR
--      Kevin Matthes
--
--  COPYRIGHT
--      (C) 2022 Kevin Matthes.
--      This file is licensed GPL 2 as of June 1991.
--
--  DATE
--      2022
--
--  NOTE
--      See `LICENSE' for full license.
--
------------------------------------------------------------------------------->

# untab

## Summary

A simple lexer which removes tab characters from a given file.

## License

This project's license is **GPL 2** (as of June 1991).  The whole license text
can be found in `LICENSE` in the main directory of this repository.  The brief
version is as follows:

> Copyright (C) 2022 Kevin Matthes
>
> This program is free software; you can redistribute it and/or modify
> it under the terms of the GNU General Public License as published by
> the Free Software Foundation; either version 2 of the License, or
> (at your option) any later version.
>
> This program is distributed in the hope that it will be useful,
> but WITHOUT ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> GNU General Public License for more details.
>
> You should have received a copy of the GNU General Public License along
> with this program; if not, write to the Free Software Foundation, Inc.,
> 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

When compiling a printable version of this documentation using Pandoc, the full
license will be attached automatically to the resulting document.  This can be
invoked by calling `repository-manual.m`.

## Software Requirements

| Requirement       | Type          | Role                                  |
|:------------------|:-------------:|:--------------------------------------|
| `docs-snippets`   | repository    | documentation constants               |
| Flex              | application   | Lex compiler                          |
| GCC               | application   | C compiler                            |
| GNU Octave        | application   | execution of the provided scripts     |
| Pandoc            | application   | compilation of repository manual      |
| `texlive-full`    | package       | compilation of repository manual      |

The compilation of such an **optional** repository manual can be invoked by just
calling one of the following lines in a terminal.

```
octave repository-manual.m
octave-cli repository-manual.m
```

Both will redirect to the same application, GNU Octave, which will then create
the manual for this repository and attach the entire license to it.  The
resulting file, `repository.pdf`, will be saved in the main directory of this
repository.

## Description

This repository provides a simple lexer in order to replace tab characters from
input source files with space characters.  It can be compiled by invoking the
GNU Octave script `flex-gcc.m` in a terminal:

```
octave flex-gcc.m
octave-cli flex-gcc.m
```

This lexer will replace any tab characters in the input stream with space
characters.  In order to define the count of spaces to replace a single tab
with, the command line arguments will be used to determine the intended value.

The intended tab width can be any integer from zero to nine, including zero and
nine.  The desired width needs be to entered as a decimal integer with `-` as a
prefix.  For instance, in order to remove all tab characters, `-0`, for tab
width zero, needs to be passed.  If no argument is passed to this lexer, 4 will
be assumed, by default.

This lexer offers both an interactive mode as well as a batch one.

The former is invoked automatically if no file name is passed.  Anything which
does not carry `-` as a prefix is assumed to be a file name.  In the interactive
mode, the lexer reads from `stdin` and writes to `stdout`.  This is useful in
order to pipe data around in a terminal session.

The batch mode is invoked automatically by passing a file name to the lexer.
Anything which does not carry `-` as a prefix is assumed to be a file name.  The
lexer will read from the given file, write the intermediate output to an
auxillary file named `untab.l.aux` and rewrite the result to the original file
at the end.  The auxillary file is tidied up automatically.

In case of errors, the lexer will automatically abort the execution and will
close all open streams and free all allocated memory regions, respectively.
Corresponding error messages will be written to `stdout` and the return value of
the lexer will be set according to `sysexits.h`.

Possible errors are:
* mandatory memory allocations fail
* required files cannot be accessed
* unknown command line options

The meaning of the return values are as follows:

| Code   | Meaning                               |
|:------:|:--------------------------------------|
| 0      | no problem occured                    |
| 64     | unknown option / too many arguments   |
| 69     | required file not accessable          |
| 74     | too few memory                        |

The script `install-app.m` will install the application in `~/.local/bin/`, at
option.

```
octave install-app.m
octave-cli install-app.m
```

<!----------------------------------------------------------------------------->
