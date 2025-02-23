%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define MAX_LABELS 100  

typedef struct {
    char *lexeme;
} labelEntry;

labelEntry labelTable[MAX_LABELS];
int labelCount = 0;
int lineCount = 0;
int dir = 0;

void processLabel(const char *yytext);
%}

delim   [\n]
ws      {delim}+
digit   [0-9]
label   \({digit}+\)

%%

{label}    { processLabel(yytext); }
.          { ECHO; }   /* Imprime el resto de la línea tal cual */

%%


void print11BitBinary(int number) {
    char bin[12];
    bin[11] = '\0';
    for (int i = 10; i >= 0; i--) {
        bin[i] = (number & 1) ? '1' : '0';
        number >>= 1;
    }
    printf("%s", bin);
}

void loadLabelTable() {
    FILE *fp = fopen("Labeltable.txt", "r");  
    if (fp == NULL) {
        fprintf(stderr, "Error: cannot open LABELTABLE.TXT\n");
        exit(1);
    }
    char line[256];
    labelCount = 0;
    while (fgets(line, sizeof(line), fp) && labelCount < MAX_LABELS) {
        int index;
        char tempLabel[100], thirdColumn[100];
        if (sscanf(line, "%d %s %s", &index, tempLabel, thirdColumn) == 3) {
            if (index < MAX_LABELS) {
                labelTable[index].lexeme = strdup(thirdColumn);
                if (index >= labelCount)
                    labelCount = index + 1;
            }
        }
    }
    fclose(fp);
}

void processLabel(const char *yytext) {
    static int loaded = 0;
    if (!loaded) {
        loadLabelTable();
        loaded = 1;
    }
    // yytext es como "(123)"; extraemos el dígito entre los paréntesis.
    int labelIndex = atoi(yytext + 1); 
    if (labelIndex < labelCount && labelTable[labelIndex].lexeme != NULL) {
        // Imprime el contenido de la tabla tal cual, conservando los paréntesis originales.
        printf("(");
        printf("%s", labelTable[labelIndex].lexeme);
        printf(")");
    } else {
        fprintf(stderr, "Error: label index %d out of range or not defined\n", labelIndex);
        exit(1);
    }
}
