all: calc

calc: calc.go tokenizer.go
	go build -o calc .

calc.go: calc.y
	goyacc -o calc.go calc.y

tokenizer.go: tokenizer.l
	golex -o tokenizer.go tokenizer.l

clean:
	rm -f calc calc.go tokenizer.go y.output

.PHONY: all clean
