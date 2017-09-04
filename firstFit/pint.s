.code32

.section .data
buffer:
	.rept 30
	.byte 0
	.endr
	.byte '\n'

size:
	.long 1
begin:
	.long 0

.section .text 
.globl pint
.type pint, @function

pint:
	pushl %ebp
	movl %esp, %ebp
	pushl %ebx
	pushl %esi
	pushl %edi

	movl 8(%ebp), %eax
	movl $buffer, %esi
	addl $30, %esi
	movl $1, %edi

loop_begin:
	cmpl $0, %eax
	je loop_end

	cltd
	movl $10, %ecx
	idivl %ecx

	pushl %eax
	pushl %edx

	decl %esi
	add $48, %edx
	movb %dl, (%esi)
	incl %edi

	popl %edx
	popl %eax
	
	jmp loop_begin

loop_end:
	movl $4, %eax
	movl $1, %ebx
	movl %esi, %ecx
	movl %edi, %edx
	int $0x80
	popl %edi
	popl %esi
	popl %ebx
	movl %ebp, %esp
	popl %ebp
	ret
