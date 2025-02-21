%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>

#define MAX_LABELS 100  

typedef struct {
    char *lexeme;
    int line;
} labelEntry;

labelEntry labelTable[MAX_LABELS];
int labelCount = 0;
int lineCount = 0;

int installLabel(const char *token);
void processRegister(const char *token);
void processLabel(const char *token, int isDefinition);
void processNumber(const char *token);
void saveSymbolTable(const char *filename);

%}

delim   [\n]
ws      {delim}+
letter  [A-Za-z]
digit   [0-9]
label   {letter}({letter}|{digit})*
number  {digit}+
register   R{digit}+
ignore [ ,:]
linecomment  ";".*

%%

"LDI"    { printf("00000"); }
"LOAD"   { printf("000010000000000000"); }
"STORE"  { printf("000100000000000000"); }
"JUMP"   { printf("000110000000000000000"); }
"JZ"     { printf("001000000000000000000"); }
"JP"     { printf("001010000000000000000"); }
"JNP"    { printf("001100000000000000000"); }
"JC"     { printf("001110000000000000000"); }
"RET"    { printf("010000000000000000000"); }
"CALL"   { printf("010010000000000000000"); }
"ADD"    { printf("01010000000000000000000"); }
"SUB"    { printf("01011000000000000000000"); }
"MUL"    { printf("01100000000000000000000"); }
"DIV"    { printf("01101000000000000000000"); }
"AND"    { printf("01110000000000000000000"); }
"OR"     { printf("01111000000000000000000"); }
"XOR"    { printf("10000000000000000000000"); }
"MOV"    { printf("10001000000000000000000000"); } 
"CMP"    { printf("10010000000000000000000000"); } 
"PUSH"   { printf("10011000000000000000000000000"); }
"POP"    { printf("10100000000000000000000000000"); } 
"READ"   { printf("10101000000000000000000000000"); }
"WRITE"  { printf("10110000000000000000000000000"); }
"CLR"    { printf("10111000000000000000000000000"); }
"DEC"    { printf("11000000000000000000000000000"); }
"INC"    { printf("11001000000000000000000000000"); }
"NOT"    { printf("11010000000000000000000000000"); }
"SHL"    { printf("11011000000000000000000000000"); }
"SHR"    { printf("11100000000000000000000000000"); }
"NEG"    { printf("11101000000000000000000000000000"); }
"HLT"    { printf("11110000000000000000000000000000");     saveSymbolTable("Labeltable.txt");}
"NOP"    { printf("11111000000000000000000000000000"); } 
{delim}  { lineCount++; printf("\n"); }
{ignore}
{linecomment}
{register}  { processRegister(yytext); }
{label}":"  { 
    yytext[yyleng-1] = '\0';
    processLabel(yytext, 1);
}
{label}     { processLabel(yytext, 0); }
{number}    { processNumber(yytext); }

%%

void processRegister(const char *token) {
    int reg = atoi(token + 1);
    char bin[4];  // 3 bits + terminador nulo

    for (int i = 2; i >= 0; i--) {
        bin[i] = (reg % 2) ? '1' : '0';
        reg /= 2;
    }
    bin[3] = '\0';
    printf("%s", bin);
}

void processLabel(const char *token, int isDefinition) {
    int idx = -1;
    for (int i = 0; i < labelCount; i++) {
        if (strcmp(token, labelTable[i].lexeme) == 0) {
            idx = i;
            break;
        }
    }
    if (idx == -1) {
        idx = installLabel(token);
    }
    if (isDefinition) {
        labelTable[idx].line = lineCount;
    } else {
        printf("(%d)", idx);
    }
}

int installLabel(const char *token) {
    if (labelCount < MAX_LABELS) {
        labelTable[labelCount].lexeme = strdup(token);
        labelTable[labelCount].line = lineCount;
        return labelCount++;
    } else {
        fprintf(stderr, "Tabla de Etiquetas llena.\n");
        exit(1);
    }
}

void processNumber(const char *token) {
    int num = atoi(token);
    char bin[25];  // 24 bits + terminador nulo

    bin[24] = '\0';
    for (int i = 23; i >= 0; i--) {
        bin[23 - i] = (num & (1 << i)) ? '1' : '0';
    }
    printf("%s", bin);
}

void saveSymbolTable(const char *filename) {
    FILE *fp = fopen(filename, "w");
    if (!fp) {
        perror("Error al abrir el archivo para guardar la tabla de símbolos");
        exit(EXIT_FAILURE);
    }
    for (int i = 0; i < labelCount; i++) {
        fprintf(fp, "%d %s %d\n", i, labelTable[i].lexeme, labelTable[i].line);
    }
    fclose(fp);
}
