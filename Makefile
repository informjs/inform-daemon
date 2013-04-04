CC=coffee
OUT=lib/inform-daemon
IN=src/

all: lib/inform-daemon
	${CC} -o ${OUT} -c ${IN}

lib/inform-daemon:
	mkdir -p "${OUT}"

