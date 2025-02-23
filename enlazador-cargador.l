%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int dir = 0;   /* Global variable */

void processInstruction(const char *yytext);
void print11BitBinary(int number, char *dest);
%}

binary    [01]+
parennum  \([0-9]+\)
instr     {binary}{parennum}

%%

{instr}    { processInstruction(yytext); }
.|\n      { ECHO; }

%%

/* Converts number to an 11-bit binary string stored in dest */
void print11BitBinary(int number, char *dest) {
    dest[11] = '\0';
    for (int i = 10; i >= 0; i--) {
        dest[i] = (number & 1) ? '1' : '0';
        number >>= 1;
    }
}

/* Processes an instruction with a binary literal followed by a number in parentheses.
   It extracts the binary part and the integer, sums the integer with dir, converts the sum
   to an 11-bit binary string, and prints the original binary literal concatenated with that result. */
void processInstruction(const char *yytext) {
    char binaryPart[256];
    int num;
    /* Parse a string of 0s and 1s and then a number in parentheses */
    if (sscanf(yytext, "%[01](%d)", binaryPart, &num) != 2) {
        fprintf(stderr, "Error: invalid format '%s'\n", yytext);
        exit(1);
    }
    int sum = dir + num;
    char newBinary[12];
    print11BitBinary(sum, newBinary);
    /* Print the binary literal concatenated with the 11-bit binary sum */
    printf("%s%s", binaryPart, newBinary);
}

int main(int argc, char **argv) {
    yylex();
    return 0;
}
