CC=coffee
OUT=lib/informd
IN=src/

all: lib
	${CC} -o ${OUT} -c ${IN}

lib:
	mkdir -p "${OUT}"
