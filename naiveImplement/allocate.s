# allocate.s

.section .text
.globl allocate
.type allocate, @function

.equ ST_MEM_SIZE, 8

allocate:
	pushl %ebp
	movl %esp, %ebp
	movl ST_MEM_SIZE(%ebp), %ecx

	movl heap_begin, %eax
	movl current_break, %ebx

loop_begin:
	cmpl %ebx, %eax
	je move_break

	movl HDR_SIZE_OFFSET(%eax), %edx
	cmpl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
	je next_location
	
	cmpl %edx, %ecx
	jle allocate_here

next_location:
	addl $HEADER_SIZE, %eax
	addl %edx, %eax
	jmp loop_begin

allocate_here:
	movl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
	addl $HEADER_SIZE, %eax

	movl %ebp, %esp
	popl %ebp
	ret

move_break:
	addl $HEADER_SIZE, %ebx
	addl %ecx, %ebx

	pushl %eax
	movl $SYS_BRK, %eax
	int $LINUX_SYSCALL
	popl %eax

	movl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
	movl %ecx, HDR_SIZE_OFFSET(%eax)
	addl $HEADER_SIZE, %eax
	movl %ebx, current_break

	movl %ebp, %esp
	popl %ebp
	ret



