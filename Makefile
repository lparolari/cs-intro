MAINFILE = lesson-1
SRC = $(shell pwd)
BUILD_DIR = _build


# ***********************************************************
# ****** MAIN

.PHONY: all
all:  # all do nothing by default

pdf: pdflatex  # default
pdflatex: buildlatex bib buildlatex
pdfdocker: builddocker

prettify: backup src2tmp tabs2spaces rmTrailingSpaces tmp2src


# ***********************************************************
# ****** BUILD RECIPES

# build using docker
builddocker:
	docker pull dxjoke/tectonic-docker
	docker run --mount src=$(SRC),target=/usr/src/tex,type=bind dxjoke/tectonic-docker /bin/sh -c "tectonic --keep-intermediates --reruns 0 $MAINFILE.tex; biber $MAINFILE; tectonic $MAINFILE.tex"

# build using pdflatex
buildlatex:
	pdflatex $(MAINFILE)
bib:
	biber $(MAINFILE)

# read
read:
	evince $(MAINFILE).pdf &

# edit
edit:
	emacs ${MAINFILE}.tex

# backup
backup:
	cp -f ${MAINFILE}.tex ${MAINFILE}.tex.bak
restore:
	cp -f ${MAINFILE}.tex.bak ${MAINFILE}.tex

src2tmp:
	cp -f ${MAINFILE}.tex ${MAINFILE}.tex.tmp
tmp2src:
	cp -f ${MAINFILE}.tex.tmp ${MAINFILE}.tex

# convert a tab to 4 spaces 
tabs2spaces:
	expand -t 4 ${MAINFILE}.tex > ${MAINFILE}.tex.tmp

# remove trailing spaces
rmTrailingSpaces:
#	sed -i 's/[[:space:]]*$//' ${MAINFILE}.tex.tmp
# do nothing for now
# FIXME: the $ si interpreted in bash end cause the sed command to fail!


# ***********************************************************
# ****** CLEAN RECIPES
.PHONY: clean
clean:
	-rm -f *.aux
	-rm -f *.log
	-rm -f *.toc
	-rm -f *.bbl
	-rm -f *.blg
	-rm -f *.out
	-rm -f make/bib

.PHONY: cleanall
cleanall: clean
	-rm -f *.pdf
	-rm -f *.ps
	-rm -f *.dvi
	-rm -rf ./make
	-rm -f *.mtc*
	-rm -f *.maf
	-rm -f *.listing
	-rm -f *.loa
	-rm -f *.lof
	-rm -f *.lot
	-rm -f *.bcf
	-rm -f *.fls
	-rm -f *.pyg
	-rm -f *.run.xml
	-rm -rf $(BUILD_DIR)
	-rm -f *.nav
	-rm -f *.snm
