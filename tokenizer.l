%{
package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

type lexer struct {
	src     *bufio.Reader
	buf     []byte
	empty   bool
	current byte
}

func newLexer(src *bufio.Reader) *lexer {
	l := &lexer{src: src}
	if b, err := src.ReadByte(); err == nil {
		l.current = b
	}
	return l
}

func (l *lexer) getc() byte {
	if l.current != 0 {
		l.buf = append(l.buf, l.current)
	}
	l.current = 0
	if b, err := l.src.ReadByte(); err == nil {
		l.current = b
	}
	return l.current
}

func (l *lexer) Error(msg string) {
	fmt.Fprintln(os.Stderr, "parse error:", msg)
}

func (l *lexer) Lex(lval *yySymType) int {
	var err error
	c := l.current
	if l.empty {
		c, l.empty = l.getc(), false
	}
%}

%yyc c
%yyn c = l.getc()

D  [0-9]+
E  [eE][-+]?{D}
F  {D}"."{D}?{E}?|{D}{E}?|"."{D}{E}?

%%
	l.buf = l.buf[:0]

[ \t\r]+

{F}
	if lval.value, err = strconv.ParseFloat(string(l.buf), 64); err != nil {
		fmt.Fprintln(os.Stderr, "bad number:", err)
		os.Exit(1)
	}
	return NUM

%%
	l.empty = true
	return int(c)
}
