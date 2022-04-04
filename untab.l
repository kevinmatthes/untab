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
    /*
     * Includes.
     */

    #include <ctype.h>
    #include <stdbool.h>
    #include <sysexits.h>



    /*
     * Function declarations.
     */

    // Processing functions.
    extern void eval    (const int argc, char * const * const args);
    extern void finish  (void);
    extern int  main    (const int argc, char * const * const args);
    extern void prepare (void);
    extern void process (void);
    extern void spaces  (void);

    // Error handling functions.
    extern void memory_insufficient     (void);
    extern void unknown_file            (const char * const file);
    extern void unknown_option          (const char * const option);
    extern void unresolvable_argument   (const char * const argument);



    /**
     * \brief   The path to the auxillary file.
     *
     * This is the path to the auxillary file which will be removed at the end.
     */

    #define AUXILLARY   "untab.l.aux"



    /**
     * \brief   A flag to control whether the input file was already set.
     *
     * This flag indicates whether the input file was already configurated.  It
     * will be inverted as soon as the file was set.
     */

    bool input_unset = true;



    /**
     * \brief   The input file to read from.
     *
     * This is the file to optimise.  It will be opened when all arguments are
     * processed.
     */

    char * input_name = NULL;



    /**
     * \brief   An auxillary file.
     *
     * This file will store the output of the lexer, if required.
     */

    FILE * auxillary = NULL;



    /**
     * \brief   The input file.
     *
     * The input file to optimise.
     */

    FILE * input_file = NULL;



    /**
     * \brief   The count of spaces to replace a tab character with.
     *
     * This global variable will be used in order control how many spaces will
     * replace a single tab character.
     *
     * By default, a tab width of four spaces is assumed.
     */

    int tab_width = 0x4;
%}

%% /***************************************************************************/

"\t"    spaces ();
.       ECHO;

%% /***************************************************************************/

/**
 * \brief   Evaluate the command line arguments and set the environment.
 * \param   argc    The count of passed command line arguments.
 * \param   args    The passed command line arguments.
 *
 * This function will evaluate the passed command line arguments set the
 * environment of this lexer accordingly.
 *
 * The arguments might contain options which are used in order instruct the
 * resulting application.  For instance, the intended tab width can be passed as
 * an option.
 *
 * If no file is named, the standard streams `yyin` and `yyout` will remain
 * unchanged such that the lexer will read from `stdin` and will write to
 * `stdout`.  Else, the given file will become the input stream and the result
 * will be stored in an auxillary file during the processing.  At the end, the
 * content will be written back to the original input file and the intermediate
 * file will be removed.
 */

void eval (const int argc, const char * const * const args)
{
    for (int i = 0x1; i < argc; i++)
        if (args[i][0x0] == '-')
        {
            switch (strlen (args[i]))
            {
                default:
                    unknown_option (args[i]);
                    break;

                case 0x2:
                    if (isdigit (args[i][0x1]))
                        tab_width = args[i][0x1] - '0';
                    else
                        unknown_option (args[i]);
                    break;
            };
        }
        else if (input_unset)
        {
            input       = args[i];
            input_unset = false;
        }
        else
            unresolvable_argument (args[i]);

    return;
}



/**
 * \brief   The main function of this lexer.
 * \param   argc    The count of passed command line arguments.
 * \param   args    The passed command line arguments.
 * \return  The application status.
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
 * The meaning of the return values is as follows:
 *
 * | Code   | Meaning               |
 * |:------:|:----------------------|
 * | 0      | No problem occured.   |
 * | 64     | Unknown option.       |
 */

int main (const int argc, const char * const * const args)
{
    eval (argc, args);
    process ();
    return EX_OK;
}



/**
 * \brief   Lex the given stream.
 *
 * This function fill run the defined lexer over the input stream, write the
 * result to the configurated output stream and free the lexer at the end.
 */

inline void process (void)
{
    yylex ();
    yylex_destroy ();
    return;
}



/**
 * \brief   Write the spaces to `yyout`.
 *
 * This function will write the configurated count of spaces to the default
 * output stream.
 */

void spaces (void)
{
    for (int i = 0x0; i < tab_width; i++)
        fprintf (yyout, " ");

    return;
}



/**
 * \brief   Quit the application because of an unknown option.
 * \param   option  The option which cannot be resolved.
 *
 * This function will write a brief error message to `stderr` and quit the
 * application with code 64.
 */

inline void unknown_option (const char * const option)
{
    fprintf (stderr, "Unknown option:  '%s'.\n", option);
    exit (EX_USAGE);
    return;
}



/**
 * \brief   Quit the application because of an unresolvable argument.
 * \param   argument    The argument which cannot be resolved.
 *
 * In case some extra arguments are passed to the lexer, it cannot deduce what
 * it should do with them.  Hence, it will consider them unresolvable and quit.
 */

inline void unresolvable_argument (const char * const argument)
{
    fprintf (stderr, "Unresolvable argument:  '%s'.\n", argument);
    exit (EX_USAGE);
    return;
}

/******************************************************************************/
