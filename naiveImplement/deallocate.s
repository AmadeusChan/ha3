.code32

.section .text
.globl deallocate
.type deallocate, @function

.equ ST_MEMORY_SEG, 4

deallocate:
	movl ST_MEMEORY_SEG(%esp), %eax
	subl $HEADER_SIZE, %eax
	movl $AVAILABLE, HDR_AVAIL_OFFSET(%eax)
	ret
