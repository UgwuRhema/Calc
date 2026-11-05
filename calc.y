%{
package main

import (
	"bufio"
	"fmt"
	"math"
	"os"
)

%}

%union {
	value float64
}

%token <value> NUM

%left '+' '-'
%left '*' '/' '%'
%left UMINUS
%right '^'

%type <value> exp

%%

input:
	  /* empty */
	| input line
	;

line:
	  '\n'
	| exp '\n' { fmt.Printf("= %.10g\n", $1) }
	| exp ';'  { fmt.Printf("= %.10g\n", $1) }
	;

exp:
	  NUM                  { $$ = $1 }
	| exp '+' exp          { $$ = $1 + $3 }
	| exp '-' exp          { $$ = $1 - $3 }
	| exp '*' exp          { $$ = $1 * $3 }
	| exp '/' exp          { $$ = $1 / $3 }
	| exp '%' exp          { $$ = math.Mod($1, $3) }
	| exp '^' exp          { $$ = math.Pow($1, $3) }
	| '-' exp %prec UMINUS { $$ = -$2 }
	| '(' exp ')'          { $$ = $2 }
	;

%%

func main() {
	fmt.Println("calc: enter an expression (Ctrl-D to quit)")
	os.Exit(yyParse(newLexer(bufio.NewReader(os.Stdin))))
}
