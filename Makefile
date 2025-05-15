determinant_calculator: determinant_calculator.o
	ld -o determinant_calculator determinant_calculator.o
determinant_calculator.o:
	as -g -o determinant_calculator.o determinant_calculator.s
clean:
	rm -f determinant_calculator
	rm -f determinant_calculator.o
