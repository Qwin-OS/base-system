
bootblock.o:     формат файла elf32-i386


Дизассемблирование раздела .text:

00007c00 <start>:
# with %cs=0 %ip=7c00.

.code16                       # Assemble for 16-bit mode
.globl start
start:
  cli                         # BIOS enabled interrupts; disable
    7c00:	fa                   	cli    

  # Zero data segment registers DS, ES, and SS.
  xorw    %ax,%ax             # Set %ax to zero
    7c01:	31 c0                	xor    %eax,%eax
  movw    %ax,%ds             # -> Data Segment
    7c03:	8e d8                	mov    %eax,%ds
  movw    %ax,%es             # -> Extra Segment
    7c05:	8e c0                	mov    %eax,%es
  movw    %ax,%ss             # -> Stack Segment
    7c07:	8e d0                	mov    %eax,%ss

  # Clear screen 

movw $03,%ax;
    7c09:	b8 03 00 cd 10       	mov    $0x10cd0003,%eax

00007c0e <seta20.1>:
int $0x10

  # Physical address line A20 is tied to zero so that the first PCs 
  # with 2 MB would run software that assumed 1 MB.  Undo that.
seta20.1:
  inb     $0x64,%al               # Wait for not busy
    7c0e:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    7c10:	a8 02                	test   $0x2,%al
  jnz     seta20.1
    7c12:	75 fa                	jne    7c0e <seta20.1>

  movb    $0xd1,%al               # 0xd1 -> port 0x64
    7c14:	b0 d1                	mov    $0xd1,%al
  outb    %al,$0x64
    7c16:	e6 64                	out    %al,$0x64

00007c18 <seta20.2>:

seta20.2:
  inb     $0x64,%al               # Wait for not busy
    7c18:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    7c1a:	a8 02                	test   $0x2,%al
  jnz     seta20.2
    7c1c:	75 fa                	jne    7c18 <seta20.2>

  movb    $0xdf,%al               # 0xdf -> port 0x60
    7c1e:	b0 df                	mov    $0xdf,%al
  outb    %al,$0x60
    7c20:	e6 60                	out    %al,$0x60

  # Switch from real to protected mode.  Use a bootstrap GDT that makes
  # virtual addresses map directly to physical addresses so that the
  # effective memory map doesn't change during the transition.
  lgdt    gdtdesc
    7c22:	0f 01 16             	lgdtl  (%esi)
    7c25:	7c 7c                	jl     7ca3 <readsect+0xf>
  movl    %cr0, %eax
    7c27:	0f 20 c0             	mov    %cr0,%eax
  orl     $CR0_PE, %eax
    7c2a:	66 83 c8 01          	or     $0x1,%ax
  movl    %eax, %cr0
    7c2e:	0f 22 c0             	mov    %eax,%cr0

//PAGEBREAK!
  # Complete transition to 32-bit protected mode by using long jmp
  # to reload %cs and %eip.  The segment descriptors are set up with no
  # translation, so that the mapping is still the identity mapping.
  ljmp    $(SEG_KCODE<<3), $start32
    7c31:	ea 36 7c 08 00 66 b8 	ljmp   $0xb866,$0x87c36

00007c36 <start32>:

.code32  # Tell assembler to generate 32-bit code now.
start32:
  # Set up the protected-mode data segment registers
  movw    $(SEG_KDATA<<3), %ax    # Our data segment selector
    7c36:	66 b8 10 00          	mov    $0x10,%ax
  movw    %ax, %ds                # -> DS: Data Segment
    7c3a:	8e d8                	mov    %eax,%ds
  movw    %ax, %es                # -> ES: Extra Segment
    7c3c:	8e c0                	mov    %eax,%es
  movw    %ax, %ss                # -> SS: Stack Segment
    7c3e:	8e d0                	mov    %eax,%ss
  movw    $0, %ax                 # Zero segments not ready for use
    7c40:	66 b8 00 00          	mov    $0x0,%ax
  movw    %ax, %fs                # -> FS
    7c44:	8e e0                	mov    %eax,%fs
  movw    %ax, %gs                # -> GS
    7c46:	8e e8                	mov    %eax,%gs

  # Set up the stack pointer and call into C.
  movl    $start, %esp
    7c48:	bc 00 7c 00 00       	mov    $0x7c00,%esp
  call    bootmain
    7c4d:	e8 e1 00 00 00       	call   7d33 <bootmain>

  # If bootmain returns (it shouldn't), trigger a Bochs
  # breakpoint if running under Bochs, then loop.
  movw    $0x8a00, %ax            # 0x8a00 -> port 0x8a00
    7c52:	66 b8 00 8a          	mov    $0x8a00,%ax
  movw    %ax, %dx
    7c56:	66 89 c2             	mov    %ax,%dx
  outw    %ax, %dx
    7c59:	66 ef                	out    %ax,(%dx)
  movw    $0x8ae0, %ax            # 0x8ae0 -> port 0x8a00
    7c5b:	66 b8 e0 8a          	mov    $0x8ae0,%ax
  outw    %ax, %dx
    7c5f:	66 ef                	out    %ax,(%dx)

00007c61 <spin>:
spin:
  jmp     spin
    7c61:	eb fe                	jmp    7c61 <spin>
    7c63:	90                   	nop

00007c64 <gdt>:
	...
    7c6c:	ff                   	(bad)  
    7c6d:	ff 00                	incl   (%eax)
    7c6f:	00 00                	add    %al,(%eax)
    7c71:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7c78:	00 92 cf 00 17 00    	add    %dl,0x1700cf(%edx)

00007c7c <gdtdesc>:
    7c7c:	17                   	pop    %ss
    7c7d:	00 64 7c 00          	add    %ah,0x0(%esp,%edi,2)
	...

00007c82 <waitdisk>:
  entry();
}

void
waitdisk(void)
{
    7c82:	55                   	push   %ebp
    7c83:	89 e5                	mov    %esp,%ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
    7c85:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7c8a:	ec                   	in     (%dx),%al
  // Wait for disk ready.
  while((inb(0x1F7) & 0xC0) != 0x40)
    7c8b:	83 e0 c0             	and    $0xffffffc0,%eax
    7c8e:	3c 40                	cmp    $0x40,%al
    7c90:	75 f8                	jne    7c8a <waitdisk+0x8>
    ;
}
    7c92:	5d                   	pop    %ebp
    7c93:	c3                   	ret    

00007c94 <readsect>:

// Read a single sector at offset into dst.
void
readsect(void *dst, uint offset)
{
    7c94:	55                   	push   %ebp
    7c95:	89 e5                	mov    %esp,%ebp
    7c97:	57                   	push   %edi
    7c98:	53                   	push   %ebx
    7c99:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  // Issue command.
  waitdisk();
    7c9c:	e8 e1 ff ff ff       	call   7c82 <waitdisk>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
    7ca1:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7ca6:	b8 01 00 00 00       	mov    $0x1,%eax
    7cab:	ee                   	out    %al,(%dx)
    7cac:	b2 f3                	mov    $0xf3,%dl
    7cae:	89 d8                	mov    %ebx,%eax
    7cb0:	ee                   	out    %al,(%dx)
    7cb1:	0f b6 c7             	movzbl %bh,%eax
    7cb4:	b2 f4                	mov    $0xf4,%dl
    7cb6:	ee                   	out    %al,(%dx)
  outb(0x1F2, 1);   // count = 1
  outb(0x1F3, offset);
  outb(0x1F4, offset >> 8);
  outb(0x1F5, offset >> 16);
    7cb7:	89 d8                	mov    %ebx,%eax
    7cb9:	c1 e8 10             	shr    $0x10,%eax
    7cbc:	b2 f5                	mov    $0xf5,%dl
    7cbe:	ee                   	out    %al,(%dx)
  outb(0x1F6, (offset >> 24) | 0xE0);
    7cbf:	c1 eb 18             	shr    $0x18,%ebx
    7cc2:	89 d8                	mov    %ebx,%eax
    7cc4:	83 c8 e0             	or     $0xffffffe0,%eax
    7cc7:	b2 f6                	mov    $0xf6,%dl
    7cc9:	ee                   	out    %al,(%dx)
    7cca:	b2 f7                	mov    $0xf7,%dl
    7ccc:	b8 20 00 00 00       	mov    $0x20,%eax
    7cd1:	ee                   	out    %al,(%dx)
  outb(0x1F7, 0x20);  // cmd 0x20 - read sectors

  // Read data.
  waitdisk();
    7cd2:	e8 ab ff ff ff       	call   7c82 <waitdisk>
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
    7cd7:	8b 7d 08             	mov    0x8(%ebp),%edi
    7cda:	b9 80 00 00 00       	mov    $0x80,%ecx
    7cdf:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7ce4:	fc                   	cld    
    7ce5:	f3 6d                	rep insl (%dx),%es:(%edi)
  insl(0x1F0, dst, SECTSIZE/4);
}
    7ce7:	5b                   	pop    %ebx
    7ce8:	5f                   	pop    %edi
    7ce9:	5d                   	pop    %ebp
    7cea:	c3                   	ret    

00007ceb <readseg>:

// Read 'count' bytes at 'offset' from kernel into physical address 'pa'.
// Might copy more than asked.
void
readseg(uchar* pa, uint count, uint offset)
{
    7ceb:	55                   	push   %ebp
    7cec:	89 e5                	mov    %esp,%ebp
    7cee:	57                   	push   %edi
    7cef:	56                   	push   %esi
    7cf0:	53                   	push   %ebx
    7cf1:	83 ec 08             	sub    $0x8,%esp
    7cf4:	8b 5d 08             	mov    0x8(%ebp),%ebx
    7cf7:	8b 75 10             	mov    0x10(%ebp),%esi
  uchar* epa;

  epa = pa + count;
    7cfa:	89 df                	mov    %ebx,%edi
    7cfc:	03 7d 0c             	add    0xc(%ebp),%edi

  // Round down to sector boundary.
  pa -= offset % SECTSIZE;
    7cff:	89 f0                	mov    %esi,%eax
    7d01:	25 ff 01 00 00       	and    $0x1ff,%eax
    7d06:	29 c3                	sub    %eax,%ebx

  // Translate from bytes to sectors; kernel starts at sector 1.
  offset = (offset / SECTSIZE) + 1;
    7d08:	c1 ee 09             	shr    $0x9,%esi
    7d0b:	83 c6 01             	add    $0x1,%esi

  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; pa < epa; pa += SECTSIZE, offset++)
    7d0e:	39 df                	cmp    %ebx,%edi
    7d10:	76 19                	jbe    7d2b <readseg+0x40>
    readsect(pa, offset);
    7d12:	89 74 24 04          	mov    %esi,0x4(%esp)
    7d16:	89 1c 24             	mov    %ebx,(%esp)
    7d19:	e8 76 ff ff ff       	call   7c94 <readsect>
  offset = (offset / SECTSIZE) + 1;

  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; pa < epa; pa += SECTSIZE, offset++)
    7d1e:	81 c3 00 02 00 00    	add    $0x200,%ebx
    7d24:	83 c6 01             	add    $0x1,%esi
    7d27:	39 df                	cmp    %ebx,%edi
    7d29:	77 e7                	ja     7d12 <readseg+0x27>
    readsect(pa, offset);
}
    7d2b:	83 c4 08             	add    $0x8,%esp
    7d2e:	5b                   	pop    %ebx
    7d2f:	5e                   	pop    %esi
    7d30:	5f                   	pop    %edi
    7d31:	5d                   	pop    %ebp
    7d32:	c3                   	ret    

00007d33 <bootmain>:

void readseg(uchar*, uint, uint);

void
bootmain(void)
{
    7d33:	55                   	push   %ebp
    7d34:	89 e5                	mov    %esp,%ebp
    7d36:	57                   	push   %edi
    7d37:	56                   	push   %esi
    7d38:	53                   	push   %ebx
    7d39:	83 ec 1c             	sub    $0x1c,%esp
  uchar* pa;

  elf = (struct elfhdr*)0x10000;  // scratch space

  // Read 1st page off disk
  readseg((uchar*)elf, 4096, 0);
    7d3c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    7d43:	00 
    7d44:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    7d4b:	00 
    7d4c:	c7 04 24 00 00 01 00 	movl   $0x10000,(%esp)
    7d53:	e8 93 ff ff ff       	call   7ceb <readseg>

  // Is this an ELF executable?
  if(elf->magic != ELF_MAGIC)
    7d58:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
    7d5f:	45 4c 46 
    7d62:	75 57                	jne    7dbb <bootmain+0x88>
    return;  // let bootasm.S handle error

  // Load each program segment (ignores ph flags).
  ph = (struct proghdr*)((uchar*)elf + elf->phoff);
    7d64:	a1 1c 00 01 00       	mov    0x1001c,%eax
    7d69:	8d 98 00 00 01 00    	lea    0x10000(%eax),%ebx
  eph = ph + elf->phnum;
    7d6f:	0f b7 35 2c 00 01 00 	movzwl 0x1002c,%esi
    7d76:	c1 e6 05             	shl    $0x5,%esi
    7d79:	01 de                	add    %ebx,%esi
  for(; ph < eph; ph++){
    7d7b:	39 f3                	cmp    %esi,%ebx
    7d7d:	73 36                	jae    7db5 <bootmain+0x82>
    pa = (uchar*)ph->paddr;
    7d7f:	8b 7b 0c             	mov    0xc(%ebx),%edi
    readseg(pa, ph->filesz, ph->off);
    7d82:	8b 43 04             	mov    0x4(%ebx),%eax
    7d85:	89 44 24 08          	mov    %eax,0x8(%esp)
    7d89:	8b 43 10             	mov    0x10(%ebx),%eax
    7d8c:	89 44 24 04          	mov    %eax,0x4(%esp)
    7d90:	89 3c 24             	mov    %edi,(%esp)
    7d93:	e8 53 ff ff ff       	call   7ceb <readseg>
    if(ph->memsz > ph->filesz)
    7d98:	8b 4b 14             	mov    0x14(%ebx),%ecx
    7d9b:	8b 43 10             	mov    0x10(%ebx),%eax
    7d9e:	39 c1                	cmp    %eax,%ecx
    7da0:	76 0c                	jbe    7dae <bootmain+0x7b>
      stosb(pa + ph->filesz, 0, ph->memsz - ph->filesz);
    7da2:	01 c7                	add    %eax,%edi
    7da4:	29 c1                	sub    %eax,%ecx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    7da6:	b8 00 00 00 00       	mov    $0x0,%eax
    7dab:	fc                   	cld    
    7dac:	f3 aa                	rep stos %al,%es:(%edi)
    return;  // let bootasm.S handle error

  // Load each program segment (ignores ph flags).
  ph = (struct proghdr*)((uchar*)elf + elf->phoff);
  eph = ph + elf->phnum;
  for(; ph < eph; ph++){
    7dae:	83 c3 20             	add    $0x20,%ebx
    7db1:	39 de                	cmp    %ebx,%esi
    7db3:	77 ca                	ja     7d7f <bootmain+0x4c>
  }

  // Call the entry point from the ELF header.
  // Does not return!
  entry = (void(*)(void))(elf->entry);
  entry();
    7db5:	ff 15 18 00 01 00    	call   *0x10018
}
    7dbb:	83 c4 1c             	add    $0x1c,%esp
    7dbe:	5b                   	pop    %ebx
    7dbf:	5e                   	pop    %esi
    7dc0:	5f                   	pop    %edi
    7dc1:	5d                   	pop    %ebp
    7dc2:	c3                   	ret    
