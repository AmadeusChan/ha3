# allocate_init

.section .text

.globl allocate_init
.type allocate_init, @function

allocate_init:
	pushl %ebp
	movl %esp, %ebp

	movl $SYS_BRK, %eax
	movl $0, %ebx
	int $LINUX_SYSCALL
	movl %eax, current_break
	movl %eax, heap_begin

	movl %ebp, %esp
	popl %ebp
	ret
