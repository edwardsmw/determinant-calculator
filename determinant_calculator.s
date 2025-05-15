/*
Determinant calculator
05/12/2023
Programmed by Maxwell Edwards
*/

.macro push register
	str	\register, [sp, #-16]!
.endm

.macro pop register
	ldr	\register, [sp], #16
.endm

.macro popRegisters
	
	ldr	X1, [sp], #16
	ldr	X2, [sp], #16
	ldr	X3, [sp], #16
	ldr	X4, [sp], #16
	ldr	X5, [sp], #16
	ldr	X6, [sp], #16
	ldr	X7, [sp], #16
	ldr	X8, [sp], #16
	ldr	X9, [sp], #16
	ldr	X10, [sp], #16
	ldr	X11, [sp], #16
	ldr	X12, [sp], #16
	ldr	X13, [sp], #16
	ldr	X14, [sp], #16
	ldr	X15, [sp], #16
	ldr	X16, [sp], #16
	ldr	X17, [sp], #16
	ldr	X18, [sp], #16
.endm

.macro pushRegisters
	
	str	X18, [sp, #-16]!
	str	X17, [sp, #-16]!
	str	X16, [sp, #-16]!
	str	X15, [sp, #-16]!
	str	X14, [sp, #-16]!
	str	X13, [sp, #-16]!
	str	X12, [sp, #-16]!
	str	X11, [sp, #-16]!
	str	X10, [sp, #-16]!
	str	X9, [sp, #-16]!
	str	X8, [sp, #-16]!
	str	X7, [sp, #-16]!
	str	X6, [sp, #-16]!
	str	X5, [sp, #-16]!
	str	X4, [sp, #-16]!
	str	X3, [sp, #-16]!
	str	X2, [sp, #-16]!
	str	X1, [sp, #-16]!
.endm

.macro endl
	push	X0
	push	X1
	push	X2
	push	X8
	
	mov	X0, #1
	ldr	X1, =endl
	ldr	X2, =endlSize
	mov	X8, #64
	svc	0

	pop	X8
	pop	X2
	pop	X1
	pop	X0
.endm

.macro space
	push	X0
	push	X1
	push	X2
	push	X8
	
	mov	X0, #1
	ldr	X1, =space
	ldr	X2, =spaceSize
	mov	X8, #64
	svc	0

	pop	X8
	pop	X2
	pop	X1
	pop	X0
.endm

.macro getLength
push	X1
push	X3

mov	X2, #0		// find length of input stored in X1, result goes in X2
1:
ldrb	W3, [X1]
cmp	X3, #0xA
beq	2f
add	X2, X2, #1
add	X1, X1, #1
b 	1b
2:

pop	X3
pop	X1
.endm

.data
num:
	.fill 8, 1, 0
	numSize = . - num
num2:
	.fill 8, 1, 0
	num2Size = . - num2
endl:
	.ascii "\n"
	endlSize = . - endl
space:	.asciz " "
	spaceSize = . - space
command:
	.fill 1, 1, 0
	commandSize = . - command

.balign 8
matrix:
.skip 800

prompt1:
	.ascii "Enter the size of your matrix (square matrices only, maximum size 5): "
	prompt1Size = . - prompt1
prompt2:
	.ascii "Enter an integer: "
	prompt2Size = . - prompt2
prompt_error1:
	.ascii "Error: invalid size.\n"
	prompt_error1Size = . - prompt_error1
prompt_error2:
	.ascii "Error: invalid input.\n"
	prompt_error2Size = . - prompt_error2
prompt_error3:
	.ascii "Error: position out of bounds.\n"
	prompt_error3Size = . - prompt_error3
prompt_help:
	.ascii "Valid commands:\n	p: print the matrix\n	e: edit specified position in the matrix\n	q: quit the program\n	h: display this help page\n	c: calculate determinant\n"
	prompt_helpSize = . - prompt_help
prompt_getrow:
	.ascii "Specify a row: "
	prompt_getrowSize = . - prompt_getrow
prompt_getcol:
	.ascii "Specify a column: "
	prompt_getcolSize = . - prompt_getcol
prompt_replace:
	.ascii "Enter a new value: "
	prompt_replaceSize = . - prompt_replace

.equ max_size, 5

.text

.global _start
_start:

promptmtr:

mov	X0, #1
ldr	X1, =prompt1
ldr	X2, =prompt1Size
mov	X8, #64
svc	0

mov	X0, #1
ldr	X1, =num
ldr	X2, =numSize
mov	X8, #63
svc	0

ldr	X1, =num
getLength
bl	str2int

cmp	X0, #0
ble	4f

cmp	X0, max_size
ble	2f

4:
mov	X0, #1
ldr	X1, =prompt_error1
ldr	X2, =prompt_error1Size
mov	X8, #64
svc	0

b	promptmtr

2:

mov	X19, X0		// X19: matrix size

mov	X5, #0
3:				// matrix population

ldr	X3, =matrix
mul	X4, X19, X19
sub	X4, X4, #1

mov	X0, #1
ldr	X1, =prompt2
ldr	X2, =prompt2Size
mov	X8, #64
svc	0

mov	X0, #1
ldr	X1, =num
ldr	X2, =numSize
mov	X8, #63
svc	0

ldr	X1, =num
getLength
pushRegisters
bl	str2int
popRegisters

lsl	X6, X5, #3
str	X0, [X3, X6]

add	X5, X5, #1
cmp	X5, X4
ble	3b

help:
mov	X0, #1
ldr	X1, =prompt_help
ldr	X2, =prompt_helpSize
mov	X8, #64
svc	0

menu:


mov	X0, #1
ldr	X1, =command
ldr	X2, =commandSize
mov	X8, #63
svc	0


ldrb	W4, [X1]

cmp	X4, #112
beq	print

cmp	X4, #113
beq	quit

cmp	X4, #104
beq	help

cmp	X4, #99
beq	calculate

cmp	X4, #101
beq	edit

b	menu

edit:


mov	X0, #1
ldr	X1, =prompt_getrow
ldr	X2, =prompt_getrowSize
mov	X8, #64
svc	0

mov	X0, #1
ldr	X1, =num
ldr	X2, =numSize
mov	X8, #63
svc	0			// unsolved bug at this line
svc	0

ldr	X1, =num
getLength
pushRegisters
bl	str2int
popRegisters

mov	X10, X0			// X10: specified row number

mov	X0, #1
ldr	X1, =prompt_getcol
ldr	X2, =prompt_getcolSize
mov	X8, #64
svc	0

mov	X0, #1
ldr	X1, =num
ldr	X2, =numSize
mov	X8, #63
svc	0

ldr	X1, =num
getLength
pushRegisters
bl	str2int
popRegisters

mov	X11, X0			// X11: specified column number

cmp	X10, X19
bgt	error_oob
cmp	X10, #0
blt	error_oob

cmp	X11, X19
bgt	error_oob
cmp	X11, #0
blt	error_oob

ldr	X1, =matrix
mov	X8, #0

sub	X10, X10, #1		// translate to array index
sub	X11, X11, #1
mul	X8, X10, X19
add	X8, X8, X11

lsl	X8, X8, #3
add	X1, X1, X8

push	X1			// get replacement value
mov	X0, #1
ldr	X1, =prompt_replace
ldr	X2, =prompt_replaceSize
mov	X8, #64
svc	0

mov	X0, #1
ldr	X1, =num
ldr	X2, =numSize
mov	X8, #63
svc	0

ldr	X1, =num
getLength
pushRegisters
bl	str2int
popRegisters
pop	X1

str	X0, [X1]
b	menu

error_oob:

mov	X0, #1
ldr	X1, =prompt_error3
ldr	X2, =prompt_error3Size
mov	X8, #64
svc	0

b	menu


calculate:
ldr	X1, =matrix
mov	X2, X19
bl	getDeterminant
mov	X3, X0
ldr	X2, =num2Size
ldr	X1, =num2
bl	int2str

mov	X0, #1
ldr	X1, =num2
ldr	X2, =num2Size
mov	X8, #64
svc	0
endl
b	menu

print:
ldr	X1, =matrix
mov	X2, X19
bl	printMatrix
b	menu

quit:
mov	X0, #0
mov	X8, #93
svc	0

// param: address of matrix in X1, size of matrix in X2 (nxn matrix, X2 contains n)
// ret: determinant of matrix
getDeterminant:
push	X19

mov	X0, #0		//start X0 at 0, result will accumulate here

cmp	X2, #1
beq	basecase


mov	X3, #0
mul	X4, X2, X2	// X4: total size of matrix

mov	X5, sp		
sub	X5, X5, #16


mov	X6, #2		// dividing length by 2, then adding length mod 1
udiv	X7, X4, X6


push	X4
udiv	X8, X4, X6
msub	X4, X8, X6, X4

add	X7, X7, X4	// X7 contains our stack offset (multiple of 16)
lsl	X7, X7, #4
pop	X4

sub	sp, sp, X7

mov	X9, #0
push	X3
mov	X3, #0
1:			// matrix going into stack memory
lsl	X8, X3, #3
cmp	X8, #0
beq	2f
			// offset becomes negative for stack, unless zero
mvn	X9, X8
add	X9, X9, #1

2:
ldr	X10, [X1, X8]
str	X10, [X5, X9]
add	X3, X3, #1
cmp	X3, X4
blt	1b
pop	X3


6:
udiv	X13, X3, X2	// X13: row to expand from, current position / n

push	X3
udiv	X8, X3, X2
msub	X3, X8, X2, X3
mov	X14, X3
			// X14: col to expand from, current position % n


push	X1
mov	X3, #0
mov	X11, #0		// X11: current row
mov	X12, #0		// X12: current col

1:	
mov	X9, #0
lsl	X8, X3, #3
cmp	X8, #0
beq	2f

mvn	X9, X8
add	X9, X9, #1

2:

udiv	X11, X3, X2

push	X3
push	X8
udiv	X8, X3, X2
msub	X3, X8, X2, X3
mov	X12, X3
pop	X8
pop	X3

mov	X15, #0		// comparing rows and cols to populate submatrix
mov	X16, #0

cmp	X11, X13
beq	3f
mov	X15, #1
3:

cmp	X12, X14
beq	4f
mov	X16, #1
4:

and	X17, X16, X15
cmp	X17, #0
beq	5f

ldr	X10, [X5, X9]
str	X10, [X1]
add	X1, X1, #8	

5:

add	X3, X3, #1
cmp	X3, X4
blt	1b

pop	X1
pop	X3			// X1 is original matrix pointer, X3 top row counter

push	X0
pushRegisters
push	lr

sub	X2, X2, #1		// submatrix size one less than parent matrix

bl	getDeterminant		// recursion

mov	X19, X0			// store determinant of submatrix in X19, pop registers
pop	lr
popRegisters
pop	X0			// X0 contains cumulative result

				// getting stack offset	
mov	X9, #0
lsl	X8, X3, #3
cmp	X8, #0
beq	2f

mvn	X9, X8
add	X9, X9, #1

2:

ldr	X10, [X5, X9]		// getting minor value at current position
mul	X10, X10, X19

push	X0
pushRegisters			// multiply cofactor by appropriate power of -1

mov	X1, #-1
mov	X2, X3

push	lr
bl	expn
pop	lr

popRegisters
mul	X10, X10, X0
pop	X0

add	X0, X0, X10		// accumulate
add	X3, X3, #1
cmp	X3, X2
blt	6b

add	sp, sp, X7

b	1f
basecase:
ldr	X0, [X1]
b 3f
1:


mov	X9, #0		// matrix coming off of stack; going back to location stored in X1
mov	X3, #0
1:			
lsl	X8, X3, #3
cmp	X8, #0
beq	2f
			
mvn	X9, X8
add	X9, X9, #1

2:
ldr	X10, [X5, X9]
str	X10, [X1, X8]
add	X3, X3, #1
cmp	X3, X4
blt	1b

3:


pop	X19
ret


// param: address of matrix in X1, size of matrix in X2 (nxn matrix, X2 contains n)
// ret: void
// postcondition: matrix is printed to the screen
printMatrix:

mov	X3, #0		// start counter in X3

mov	X6, X2		// save the size n
mul	X2, X2, X2	// getting index at end of array
sub	X2, X2, #1

1:
lsl	X4, X3, #3	// get current offset
ldr	X5, [X1, X4]	// get value stored at current index

pushRegisters		// prints number at current index
push	lr
ldr	X1, =num2
ldr	X2, =num2Size
mov	X3, X5
bl	int2str
mov	X0, #1
ldr	X1, =num2
ldr	X2, =num2Size
mov	X8, #64
svc	0
space
pop lr
popRegisters



add	X3, X3, #1

push	X3			// putting each row on its own line
udiv	X9, X3, X6
msub	X3, X9, X6, X3
mov	X9, X3
pop	X3			// X3: current index, X9: current index % n

cmp	X9, #0
bne 2f
endl
2:

cmp	X3, X2
ble	1b


ret

// param: address of placeholder str in X1, length of placeholder in X2, int to convert in X3
// ret: void
// postcondition: int converted to str
int2str:


push	X1
push	X2
push	X3
push	lr

bl	zeroString	// zero out the string

pop	lr
pop	X3
pop	X2
pop	X1

mov	X4, #0		// X4: counter for powers of 10
mov	X5, X1		
sub	X2, X2, #1	// X2: len-1
add	X5, X5, X2	// X5: address of end of placeholder str



mov	X9, #0		// X9: 0 indicates positive sign, 1 negative
cmp	X3, #0
bgt	3f
beq	zero		// special case for zero
mvn	X3, X3
add	X3, X3, #1
mov	X9, #1
3:

1:				// getting largest power that goes into input num
push	X1
push	X2
push	lr

mov	X1, #10
mov	X2, X4

bl	expn

pop	lr
pop	X2
pop	X1

add	X4, X4, #1
cmp	X0, X3
ble	1b
mov	X6, #10
udiv	X0, X0, X6
sub	X4, X4, #2		// X4 contains exponent, X0 contains 10^exp

sub	X5, X5, X4		// adjust str ptr

cmp	X9, #1			// negative sign handling
bne	4f
sub	X5, X5, #1
mov	X10, #45
strb	W10, [X5]
add	X5, X5, #1
4:

2:
mov	X6, X3			// placing int input elsewhere, dividing by largest power of ten and storing ascii
udiv	X6, X6, X0
add	X6, X6, #48
strb	W6, [X5]
sub	X6, X6, #48

mul	X6, X6, X0		// increment ptr, decrement exponent, subtract current place value from int
sub	X3, X3, X6
mov	X6, #10
udiv	X0, X0, X6
add	X5, X5, #1

sub	X8, X5, X1		// compare current position with length of str
cmp	X8, X2
ble	2b
b	5f

zero:
mov	X6, #48
strb	W6, [X5]

5:

ret


//param: address of string in X1, size of str in X2
//ret: int in X0
str2int:

// X1: ptr to str[0]
// X2: len-1
// X3: ptr to str[len-1]
mov	X0, #0
mov	X3, X1
sub	X2, X2, #1
add	X3, X3, X2

// X4: counter
mov	X4, #0

1:

push	X0
push	X1
push	X2
push	lr

mov	X1, #10
mov	X2, X4
bl	expn
mov	X5, X0		// X5: 10 to power

pop	lr
pop	X2
pop	X1
pop	X0

ldrb	W6, [X3]
cmp	X6, #45 	// handle negatives
bne	3f

mvn	X0, X0
add	X0, X0, #1
b	4f

3:
sub	X6, X6, #48
madd	X0, X6, X5, X0

4:
cmp	X4, X2
beq	2f
add	X4, X4, #1
sub	X3, X3, #1
b	1b
2:

ret

//param: base in X1, exp in X2
//ret: base^exp in X0
expn:

cmp	X2, #0
bne	3f
mov	X0, #1
b	2f
3:

mov	X0, X1

1:
cmp	X2, #1
beq	2f
mul	X0, X0, X1
sub	X2, X2, #1
b	1b
2:

ret


// param: address of string in X1, length in X2
// postcondition: str is erased
// ret: void
zeroString:

1:
mov	X3, #0
strb	W3, [X1]
add	X1, X1, #1
sub	X2, X2, #1
cmp	X2, #0
bne	1b

ret
