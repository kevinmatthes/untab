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
--      CHANGELOG.md
--
--  BRIEF
--      The development history of this project.
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
--      See `README.md' for project details.
--
------------------------------------------------------------------------------->

# Changelog

## [Unreleased]

### Added

* create `define.dox`
* function `creation_failed`
* function `license`
* function `version`
* option for license information
* option for verion information

### Changed

* adjust docstrings
* adjust option parsing
* adjust README description
* call `creation_failed` instead of `unknown_file` when file creations fail
* outsource all macro docstrings to `define.dox`

### Fixed

* accept only the first tab width setting
* typo in changelog item
* update submodule `routines`

## [1.3] -- 2022-04-05

### Changed

* adjust docstrings
* adjust README description

### Fixed

* unused functions `input` and `yyunput`

## [1.2] -- 2022-04-04

### Added

* basic option parsing
* forward declaration of `main` in main lexfile
* function `eval`
* function `finish`
* function `memory_insufficient`
* function `prepare`
* function `process`
* function `spaces`
* function `unknown_file`
* function `unknown_option`
* function `unresolvable_argument`
* include `ctypes.h`
* include `sysexits.h`
* optimisation of given files -- given as command line arguments

### Changed

* data type of `tablength` from `unsigned int` to `int`
* outsource argument evaluation to function `eval`
* outsource lexer call and destruction to function `process`
* outsource space character insertion to function `spaces`

### Fixed

* too much `const`

### Removed

* passing integers to the application for setting the tab width

## [1.1] -- 2022-04-02

### Deprecated

* passing integers to the application for setting the tab width

### Fixed

* missing changelog item
* obsolete banners in build routine
* typo in changelog item
* typos in docstrings

## [1.0] -- 2022-04-02

### Added

* build instruction:  installation
* create `install-app.m`

### Fixed

* fix memory leaks of lexer

## [0.4] -- 2022-04-02

### Added

* docstrings for Doxygen
* minimal project description in README
* software requirement: Flex

### Changed

* data type of `tablength` from `int` to `unsigned int`

### Fixed

* changelog as Appendix B in repository manual
* missing changelog item

### Removed

* software requirement: Doxygen
* software requirement: `make`

## [0.3] -- 2022-04-01

### Added

* build instruction:  entire compilation routine
* create `flex-gcc.m`

### Deprecated

* software requirement: Doxygen
* software requirement: `make`

## [0.2] -- 2022-04-01

### Added

* create `untab.l`

### Fixed

* ignore `lex.*.c`
* ignore `untab` (compilation target)

## [0.1] -- 2022-04-01

### Added

* add GPL 2.0 license
* build instruction:  repository manual
* create `.gitignore`
* create list of authors
* create project meta data for repository manual
* create repository README
* create this changelog
* create this repository
* submodule `docs-snippets`
* submodule `routines`

<!----------------------------------------------------------------------------->
