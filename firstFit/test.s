.code32

.section .text

.equ MIN_SIZE, 1
.equ MAX_SIZE, 500

.globl _start
_start:
	movl %esp, %ebp

	call allocate_init
	movl $MIN_SIZE, %eax

loop_begin:
	cmpl $MAX_SIZE, %eax
	jg loop_end
	
	pushl %eax
	call allocate
	popl %eax
	incl %eax

	jmp loop_begin

loop_end:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
