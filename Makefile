CC=coffee
OUT=lib/informd
IN=src/

all: lib/inform-daemon
	${CC} -o ${OUT} -c ${IN}

lib/inform-daemon:
	mkdir -p "${OUT}"

