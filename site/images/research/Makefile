SRC := $(shell find . -name '*.tex')
SVG := $(SRC:%.tex=%.svg)

all: $(SVG)

%.svg: %.tex
	pdflatex -shell-escape $<

clean:
	rm -rf build
	latexmk -C
