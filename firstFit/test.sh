as test.s -o test.o --32
as allocate.s -o allocate.o --32
as pint.s -o pint.o --32
ld test.o allocate.o pint.o -o test -m elf_i386
./test
