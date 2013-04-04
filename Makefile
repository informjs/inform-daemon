CC=coffee
OUT=lib/informd
IN=src/

all: lib/informd
	${CC} -o ${OUT} -c ${IN}

lib/informd:
	mkdir -p "${OUT}"

