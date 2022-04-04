/*
 * Copyright (C) 2022 Kevin Matthes
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

/**
 * \author      Kevin Matthes
 * \brief       A simple lexer which removes tab characters from a given file.
 * \copyright   (C) 2022 Kevin Matthes.
 *              This file is licensed GPL 2 as of June 1991.
 * \date        2022
 * \file        untab.l
 * \note        See `LICENSE' for full license.
 *              See `README.md' for project details.
 */

/******************************************************************************/

%{
    /**
     * \brief   The count of spaces to replace a tab character with.
     *
     * This global variable will be used in order control how many spaces will
     * replace a single tab character.
     *
     * It is initialised with 0x0 in order to give it a sane initial value.
     */

    unsigned int    tablength   = 0x0;

    extern int main (const int argc, const char * const * const args);
%}

%% /***************************************************************************/

"\t"    {
            for (unsigned int i = 0x0; i < tablength; i++)
                fprintf (yyout, " ");
        };

.       {
            ECHO;
        };

%% /***************************************************************************/

/**
 * \brief   The main function of this lexer.
 * \param   argc    The count of passed command line arguments.
 * \param   args    The passed command line arguments.
 * \return  0x0
 *
 * This lexer will replace any tab characters in the input stream with space
 * characters.  In order to define the count of spaces to replace a single tab
 * with, the command line arguments will be used to determine the intended
 * value.
 *
 * If no argument is passed to this lexer, 0x4 will be assumed, by default.
 *
 * In case just one argument is passed, it will be converted into an integer
 * number which is assumed to be the intended count of spaces.
 *
 * Should two or more arguments be passed to this lexer, 0x4 is assumed since it
 * could not be deduced which argument is intended to be the one for the tab
 * width.
 *
 * This lexer always returns with 0x0.
 */

int main (const int argc, const char * const * const args)
{
    switch (argc)
    {
        default:
            tablength   = 0x4;
            break;

        case 0x2:
            tablength   = (unsigned int) atoi (args[0x1]);
            break;
    };

    yylex ();
    yylex_destroy ();

    return 0x0;
}

/******************************************************************************/
