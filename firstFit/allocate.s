.code32

.section .data

heap_begin:
	.long 0
current_break:
	.long 0
heap_size:
	.long 0

break_begin:
	.ascii "move_break begin\n"
	len_break_begin=.-break_begin
break_end:
	.ascii "move_break end\n"
	len_break_end=.-break_end

.equ HEADER_SIZE, 12
.equ HDR_AVAIL_OFFSET, 0
.equ HDR_LAST_OFFSET, 4
.equ HDR_SIZE_OFFSET, 8

.equ AVAILABLE, 1
.equ UNAVAILABLE, 0

.equ LINUX_SYSCALL, 0x80
.equ SYS_BRK, 45

.equ PAGE_SIZE, 4096

.section .text

.globl allocate_init
.type allocate_init, @function

allocate_init:
	pushl %ebp
	movl %esp, %ebp
	pushl %ebx

	movl $SYS_BRK, %eax
	movl $0, %ebx
	int $LINUX_SYSCALL

	# set the initial heap size as 4kB
	movl %eax, %ebx
	addl $PAGE_SIZE, %ebx
	movl %eax, heap_begin
	movl %ebx, current_break
	movl $PAGE_SIZE, heap_size
	movl $SYS_BRK, %eax
	int $LINUX_SYSCALL

	# initialize the first block
	movl heap_begin, %eax
	movl $AVAILABLE, HDR_AVAIL_OFFSET(%eax)
	movl $0, HDR_LAST_OFFSET(%eax)
	movl $PAGE_SIZE, HDR_SIZE_OFFSET(%eax)
	subl $HEADER_SIZE, HDR_SIZE_OFFSET(%eax)

	popl %ebx
	movl %ebp, %esp
	popl %ebp
	ret

.globl allocate
.type allocate, @function
.equ ST_MEM_SIZE, 8
.equ MIN_BLOCK, 32

allocate:
	pushl %ebp
	movl %esp, %ebp
	pushl %ebx
	pushl %edi


	movl ST_MEM_SIZE(%ebp), %ecx # %ecx holds the size
	pushl %ecx
	call pint
	popl %ecx
	movl heap_begin, %eax # %eax hodls the heap_begin
	movl current_break, %ebx # %ebx holds the current_break
	movl $0, %edi

loop_begin: # to search for available block
	cmpl %ebx, %eax
	jge move_break

	cmpl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
	je next_location

	cmpl HDR_SIZE_OFFSET(%eax), %ecx
	jle allocate_here

next_location:
	movl %eax, %edi
	addl HDR_SIZE_OFFSET(%eax), %eax
	addl $HEADER_SIZE, %eax
	jmp loop_begin

allocate_here: # to allocate memory at (%eax)
	pushl %edx
	pushl %ecx
	pushl %eax

	call pint

	popl %eax
	popl %ecx
	popl %edx

	movl $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
	movl HDR_SIZE_OFFSET(%eax), %edx
	subl %ecx, %edx
	cmpl $MIN_BLOCK, %edx
	jl allocate_finished

	movl %ecx, HDR_SIZE_OFFSET(%eax) # to split the block
	
	pushl %esi # save the callee-save register
	movl %eax, %esi
	addl %ecx, %esi
	addl $HEADER_SIZE, %esi

	movl $AVAILABLE, HDR_AVAIL_OFFSET(%esi) # to initialize the new block
	subl $HEADER_SIZE, %edx
	movl %edx, HDR_SIZE_OFFSET(%esi)
	movl %eax, HDR_LAST_OFFSET(%esi)

	popl %esi

allocate_finished:
	popl %edi
	popl %ebx
	movl %ebp, %esp
	popl %ebp
	ret

move_break:
	pushl %eax
	pushl %ebx
	pushl %ecx
	pushl %edx

	movl $4, %eax
	movl $1, %ebx
	movl $break_begin, %ecx
	movl $len_break_begin, %edx
	int $0x80
	
	pushl heap_size
	call pint
	popl heap_size

	popl %edx
	popl %ecx
	popl %ebx
	popl %eax

	movl $SYS_BRK, %eax
	addl heap_size, %ebx
	int $LINUX_SYSCALL

	pushl %edx
	pushl %ecx
	pushl %eax
	movl $SYS_BRK, %eax
	movl $0, %ebx
	int $0x80
	pushl %eax
	call pint
	popl %eax
	popl %eax
	popl %ecx
	popl %edx

	# to set up the new block
	movl current_break, %eax
	movl $AVAILABLE, HDR_AVAIL_OFFSET(%eax)
	movl %edi, HDR_LAST_OFFSET(%eax)
	pushl %ebx
	movl heap_size, %ebx
	movl %ebx, HDR_SIZE_OFFSET(%eax)
	popl %ebx

	sall $1, heap_size
	movl heap_begin, %ebx
	addl heap_size, %ebx
	movl %ebx, current_break

	pushl %eax
	pushl %edx
	pushl %ecx
	pushl heap_begin
	call pint
	popl heap_begin
	pushl current_break
	call pint
	popl current_break
	popl %ecx
	popl %edx
	popl %eax

	pushl %eax
	pushl %ebx
	pushl %ecx
	pushl %edx

	movl $4, %eax
	movl $1, %ebx
	movl $break_end, %ecx
	movl $len_break_end, %edx
	int $0x80

	popl %edx
	popl %ecx
	popl %ebx
	popl %eax

	movl current_break, %ebx

	jmp loop_begin

