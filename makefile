END=debug

all: gnudo

gnudo: Sources/Gnudo.swift
	swift build -c $(END)

clean:
	rm gnudo
