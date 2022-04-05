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
    extern void creation_failed         (const char * const file);
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
     * \brief   A flag to control whether the tab width was already set.
     *
     * This flag indicates whether the tab width was already configurated.  It
     * will be inverted as soon as the tab width was set.
     */

    bool tab_width_unset = true;



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
     * \brief   The input file to read from.
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
 * \brief   Quit the application because of not creatable files.
 *
 * This lexer needs to be able to create auxillary files.  In case it could not
 * create them, it is not useful to continue its execution.
 *
 * This function will write a brief error message to `stderr` and quit the
 * application with code 73.
 */

inline void creation_failed (const char * const file)
{
    fprintf (stderr, "Intended file could not be created:  '%s'.\n", file);
    exit (EX_CANTCREAT);
    return;
}



/**
 * \brief   Evaluate the command line arguments and set the environment.
 * \param   argc    The count of passed command line arguments.
 * \param   args    The passed command line arguments.
 *
 * This function will evaluate the passed command line arguments and set the
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

void eval (const int argc, char * const * const args)
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
                    if (isdigit (args[i][0x1]) && tab_width_unset)
                    {
                        tab_width       = args[i][0x1] - '0';
                        tab_width_unset = false;
                    }
                    else if (isdigit (args[i][0x1]))
                        unresolvable_argument (args[i]);
                    else
                        unknown_option (args[i]);
                    break;
            };
        }
        else if (input_unset)
        {
            input_name  = args[i];
            input_unset = false;
        }
        else
            unresolvable_argument (args[i]);

    return;
}



/**
 * \brief   Tidy up and write back.
 *
 * This function will close all open streams and write back all content.
 */

void finish (void)
{
    if (auxillary != NULL)
        fclose (auxillary);

    if (input_file != NULL)
        fclose (input_file);

    if (! input_unset)
    {
        input_file = fopen (AUXILLARY, "rb");

        if (input_file == NULL)
            unknown_file (AUXILLARY);

        fseek (input_file, 0x0, SEEK_END);
        const size_t size = ftell (input_file);
        rewind (input_file);

        auxillary = fopen (input_name, "wb");

        if (auxillary == NULL)
        {
            fclose (input_file);
            creation_failed (input_name);
        };

        char * const content = (char *) calloc (size + 0x1, sizeof (char));

        if (content == NULL)
        {
            fclose (auxillary);
            fclose (input_file);
            memory_insufficient ();
        }

        const size_t bytes = fread (content, sizeof (char), size, input_file);
        fclose (input_file);

        content[bytes] = 0x0;
        fwrite (content, sizeof (char), bytes, auxillary);
        fclose (auxillary);

        free (content);
        remove (AUXILLARY);
    };

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
 * The intended tab width can be any integer from zero to nine, including zero
 * and nine.  The desired width needs be to entered as a decimal integer with
 * `-` as a prefix.  For instance, in order to remove all tab characters, `-0`,
 * for tab width zero, needs to be passed.  If no argument is passed to this
 * lexer, 4 will be assumed, by default.  Only one tab width setting is
 * permitted.
 *
 * This lexer offers both an interactive mode as well as a batch one.
 *
 * The former is invoked automatically if no file name is passed.  Anything
 * which does not carry `-` as a prefix is assumed to be a file name.  In the
 * interactive mode, the lexer reads from `stdin` and writes to `stdout`.  This
 * is useful in order to pipe data around in a terminal session.
 *
 * The batch mode is invoked automatically by passing a file name to the lexer.
 * Anything which does not carry `-` as a prefix is assumed to be a file name.
 * The lexer will read from the given file, write the intermediate output to an
 * auxillary file named `untab.l.aux` and rewrite the original file at the end.
 * The auxillary file is tidied up automatically.
 *
 * In case of errors, the lexer will automatically abort the execution and will
 * close all open streams and free all allocated memory regions, respectively.
 * Corresponding error messages will be written to `stdout` and the return value
 * of the lexer will be set according to `sysexits.h`.
 *
 * Possible errors are:
 * * mandatory memory allocations fail
 * * required files cannot be accessed and / or created
 * * unknown command line options
 *
 * The meaning of the return values are as follows:
 *
 * | Code   | Meaning                               |
 * |:------:|:--------------------------------------|
 * | 0      | no problem occured                    |
 * | 64     | unknown option / too many arguments   |
 * | 69     | required file not accessable          |
 * | 73     | required file not creatable           |
 * | 74     | too few memory                        |
 */

int main (const int argc, char * const * const args)
{
    eval (argc, args);
    prepare ();
    process ();
    finish ();
    return EX_OK;
}



/**
 * \brief   Quit the application because of too few memory.
 *
 * Sometimes, there is not enough memory left in order to allocate an
 * intermediate buffer.  In these situations, it is not useful to continue the
 * execution of the lexer.
 *
 * This function will write a brief error message to `stderr` and quit the
 * application with code 74.
 */

inline void memory_insufficient (void)
{
    fprintf (stderr, "Not enough memory available!\n");
    exit (EX_IOERR);
    return;
}



/**
 * \brief   Set up the streams for lexing.
 *
 * This function will open the files for in- and output.
 *
 * In case there is no input file set, both `yyin` and `yyout` will remain
 * unchanged.
 */

void prepare (void)
{
    if (input_name != NULL)
    {
        input_file = fopen (input_name, "rb");

        if (input_file == NULL)
            unknown_file (input_name);

        auxillary = fopen (AUXILLARY, "wb");

        if (auxillary == NULL)
        {
            fclose (input_file);
            creation_failed (AUXILLARY);
        };

        yyin    = input_file;
        yyout   = auxillary;
    };

    return;
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
 * This function will write the configurated count of spaces to the configurated
 * output stream.
 */

void spaces (void)
{
    for (int i = 0x0; i < tab_width; i++)
        fprintf (yyout, " ");

    return;
}



/**
 * \brief   Quit the application because of an unknown file.
 *
 * Sometimes, the requested are not available for some reasons.  In these
 * situations, it is not useful to continue the execution of the lexer.
 *
 * This function will write a brief error message to `stderr` and quit the
 * application with code 69.
 */

inline void unknown_file (const char * const file)
{
    fprintf (stderr, "Unknown file:  '%s'.\n", file);
    exit (EX_UNAVAILABLE);
    return;
}



/**
 * \brief   Quit the application because of an unknown option.
 * \param   option  The option which cannot be resolved.
 *
 * In case some options cannot be resolved, the lexer cannot deduce which action
 * was intended.  Hence, it will consider them unresolvable and quit.
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
 *
 * This function will write a brief error message to `stderr` and quit the
 * application with code 64.
 */

inline void unresolvable_argument (const char * const argument)
{
    fprintf (stderr, "Unresolvable argument:  '%s'.\n", argument);
    exit (EX_USAGE);
    return;
}

/******************************************************************************/
