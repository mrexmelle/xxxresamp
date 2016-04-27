
PROJECT=xxxresamp

all:
	clang src/*.m -F /Library/Frameworks -framework Foundation -framework AppKit -o $(PROJECT)

clean:
	rm -f $(PROJECT)

install: all
	cp $(PROJECT) /usr/local/bin