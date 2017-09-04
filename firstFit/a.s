
allocate.o:     file format elf32-i386


Disassembly of section .text:

00000000 <allocate_init>:
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	b8 2d 00 00 00       	mov    $0x2d,%eax
   9:	bb 00 00 00 00       	mov    $0x0,%ebx
   e:	cd 80                	int    $0x80
  10:	89 c3                	mov    %eax,%ebx
  12:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  18:	a3 00 00 00 00       	mov    %eax,0x0
  1d:	89 1d 04 00 00 00    	mov    %ebx,0x4
  23:	c7 05 08 00 00 00 00 	movl   $0x1000,0x8
  2a:	10 00 00 
  2d:	b8 2d 00 00 00       	mov    $0x2d,%eax
  32:	cd 80                	int    $0x80
  34:	a1 00 00 00 00       	mov    0x0,%eax
  39:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  46:	c7 40 08 00 10 00 00 	movl   $0x1000,0x8(%eax)
  4d:	83 68 08 0c          	subl   $0xc,0x8(%eax)
  51:	5b                   	pop    %ebx
  52:	89 ec                	mov    %ebp,%esp
  54:	5d                   	pop    %ebp
  55:	c3                   	ret    

00000056 <allocate>:
  56:	68 00 00 00 00       	push   $0x0
  5b:	89 e5                	mov    %esp,%ebp
  5d:	53                   	push   %ebx
  5e:	57                   	push   %edi
  5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  62:	a1 00 00 00 00       	mov    0x0,%eax
  67:	8b 1d 04 00 00 00    	mov    0x4,%ebx
  6d:	bf 00 00 00 00       	mov    $0x0,%edi

00000072 <loop_begin>:
  72:	39 d8                	cmp    %ebx,%eax
  74:	7d 45                	jge    bb <move_break>
  76:	83 38 00             	cmpl   $0x0,(%eax)
  79:	74 05                	je     80 <next_location>
  7b:	3b 48 08             	cmp    0x8(%eax),%ecx
  7e:	7e 0a                	jle    8a <allocate_here>

00000080 <next_location>:
  80:	89 c7                	mov    %eax,%edi
  82:	03 40 08             	add    0x8(%eax),%eax
  85:	83 c0 0c             	add    $0xc,%eax
  88:	eb e8                	jmp    72 <loop_begin>

0000008a <allocate_here>:
  8a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  90:	8b 50 08             	mov    0x8(%eax),%edx
  93:	29 ca                	sub    %ecx,%edx
  95:	83 fa 20             	cmp    $0x20,%edx
  98:	7c 1b                	jl     b5 <allocate_finished>
  9a:	89 48 08             	mov    %ecx,0x8(%eax)
  9d:	56                   	push   %esi
  9e:	89 c6                	mov    %eax,%esi
  a0:	01 ce                	add    %ecx,%esi
  a2:	83 c6 0c             	add    $0xc,%esi
  a5:	c7 06 01 00 00 00    	movl   $0x1,(%esi)
  ab:	83 ea 0c             	sub    $0xc,%edx
  ae:	89 56 08             	mov    %edx,0x8(%esi)
  b1:	89 46 04             	mov    %eax,0x4(%esi)
  b4:	5e                   	pop    %esi

000000b5 <allocate_finished>:
  b5:	5f                   	pop    %edi
  b6:	5b                   	pop    %ebx
  b7:	89 ec                	mov    %ebp,%esp
  b9:	5d                   	pop    %ebp
  ba:	c3                   	ret    

000000bb <move_break>:
  bb:	b8 2d 00 00 00       	mov    $0x2d,%eax
  c0:	03 1d 08 00 00 00    	add    0x8,%ebx
  c6:	cd 80                	int    $0x80
  c8:	a1 04 00 00 00       	mov    0x4,%eax
  cd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  d3:	89 78 04             	mov    %edi,0x4(%eax)
  d6:	53                   	push   %ebx
  d7:	8b 1d 08 00 00 00    	mov    0x8,%ebx
  dd:	89 58 08             	mov    %ebx,0x8(%eax)
  e0:	5b                   	pop    %ebx
  e1:	d1 25 08 00 00 00    	shll   0x8
  e7:	89 1d 04 00 00 00    	mov    %ebx,0x4
  ed:	eb 83                	jmp    72 <loop_begin>

Disassembly of section .data:

00000000 <heap_begin>:
   0:	00 00                	add    %al,(%eax)
	...

00000004 <current_break>:
   4:	00 00                	add    %al,(%eax)
	...

00000008 <heap_size>:
   8:	00 00                	add    %al,(%eax)
	...
