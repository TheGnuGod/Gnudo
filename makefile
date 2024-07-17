config=debug
sourcefiles=Sources/Gnudo.swift Sources/ListStructs.swift Package.swift

all: gnudo

gnudo: $(sourcefiles)
	swift build -c $(config)

clean:
	rm -rf .build/debug 
	rm -rf .build/release
