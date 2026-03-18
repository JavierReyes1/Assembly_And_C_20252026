build:
	@echo "Part 2 -o compiles and links and generates an executable target"
	gcc -o sampleapp main.c -I.
	@echo "Part 3 -c produce object files"
	gcc -c main.c -I.
	@echo "Part 3 section 2 -s produce .out files"
	gcc -s main.c -I.
	@echo "Part 4  -S produce assembly files"
	gcc -S main.c -I.
	@echo "Part 5  -Wall produce warning messages that are generated during compilation will be printed"
	gcc -Wall -o sampleapp main.c -I.
	@echo "Part 6  g++ -o putting in a make file Need a build target label and tab for recipe"
	@echo "Build Started"
	g++ -o sampleapp main.c -I.
	@echo "Build Completed"
	./sampleapp

clean:
	@echo "Cleaning up"
	rm *.o
