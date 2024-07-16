config=debug

all: gnudo

gnudo: Sources/Gnudo.swift
	swift build -c $(config)

clean:
	rm gnudo
