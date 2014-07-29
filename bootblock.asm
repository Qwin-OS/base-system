
bootblock.o:     формат файла elf32-i386


Дизассемблирование раздела .text:

00007c00 <start>:
 

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
    7c4d:	e8 de 00 00 00       	call   7d30 <bootmain>

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
  outb(0x1F2, 1);   // count = 1
  outb(0x1F3, offset);
  outb(0x1F4, offset >> 8);
    7cb1:	89 d8                	mov    %ebx,%eax
    7cb3:	c1 e8 08             	shr    $0x8,%eax
    7cb6:	b2 f4                	mov    $0xf4,%dl
    7cb8:	ee                   	out    %al,(%dx)
  outb(0x1F5, offset >> 16);
    7cb9:	89 d8                	mov    %ebx,%eax
    7cbb:	c1 e8 10             	shr    $0x10,%eax
    7cbe:	b2 f5                	mov    $0xf5,%dl
    7cc0:	ee                   	out    %al,(%dx)
  outb(0x1F6, (offset >> 24) | 0xE0);
    7cc1:	89 d8                	mov    %ebx,%eax
    7cc3:	c1 e8 18             	shr    $0x18,%eax
    7cc6:	83 c8 e0             	or     $0xffffffe0,%eax
    7cc9:	b2 f6                	mov    $0xf6,%dl
    7ccb:	ee                   	out    %al,(%dx)
    7ccc:	b2 f7                	mov    $0xf7,%dl
    7cce:	b8 20 00 00 00       	mov    $0x20,%eax
    7cd3:	ee                   	out    %al,(%dx)
  outb(0x1F7, 0x20);  // cmd 0x20 - read sectors

  // Read data.
  waitdisk();
    7cd4:	e8 a9 ff ff ff       	call   7c82 <waitdisk>
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
    7cd9:	8b 7d 08             	mov    0x8(%ebp),%edi
    7cdc:	b9 80 00 00 00       	mov    $0x80,%ecx
    7ce1:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7ce6:	fc                   	cld    
    7ce7:	f3 6d                	rep insl (%dx),%es:(%edi)
  insl(0x1F0, dst, SECTSIZE/4);
}
    7ce9:	5b                   	pop    %ebx
    7cea:	5f                   	pop    %edi
    7ceb:	5d                   	pop    %ebp
    7cec:	c3                   	ret    

00007ced <readseg>:

// Read 'count' bytes at 'offset' from kernel into physical address 'pa'.
// Might copy more than asked.
void
readseg(uchar* pa, uint count, uint offset)
{
    7ced:	55                   	push   %ebp
    7cee:	89 e5                	mov    %esp,%ebp
    7cf0:	57                   	push   %edi
    7cf1:	56                   	push   %esi
    7cf2:	53                   	push   %ebx
    7cf3:	8b 5d 08             	mov    0x8(%ebp),%ebx
    7cf6:	8b 75 10             	mov    0x10(%ebp),%esi
  uchar* epa;

  epa = pa + count;
    7cf9:	89 df                	mov    %ebx,%edi
    7cfb:	03 7d 0c             	add    0xc(%ebp),%edi

  // Round down to sector boundary.
  pa -= offset % SECTSIZE;
    7cfe:	89 f0                	mov    %esi,%eax
    7d00:	25 ff 01 00 00       	and    $0x1ff,%eax
    7d05:	29 c3                	sub    %eax,%ebx

  // Translate from bytes to sectors; kernel starts at sector 1.
  offset = (offset / SECTSIZE) + 1;
    7d07:	c1 ee 09             	shr    $0x9,%esi
    7d0a:	83 c6 01             	add    $0x1,%esi

  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; pa < epa; pa += SECTSIZE, offset++)
    7d0d:	39 df                	cmp    %ebx,%edi
    7d0f:	76 17                	jbe    7d28 <readseg+0x3b>
    readsect(pa, offset);
    7d11:	56                   	push   %esi
    7d12:	53                   	push   %ebx
    7d13:	e8 7c ff ff ff       	call   7c94 <readsect>
  offset = (offset / SECTSIZE) + 1;

  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; pa < epa; pa += SECTSIZE, offset++)
    7d18:	81 c3 00 02 00 00    	add    $0x200,%ebx
    7d1e:	83 c6 01             	add    $0x1,%esi
    7d21:	83 c4 08             	add    $0x8,%esp
    7d24:	39 df                	cmp    %ebx,%edi
    7d26:	77 e9                	ja     7d11 <readseg+0x24>
    readsect(pa, offset);
}
    7d28:	8d 65 f4             	lea    -0xc(%ebp),%esp
    7d2b:	5b                   	pop    %ebx
    7d2c:	5e                   	pop    %esi
    7d2d:	5f                   	pop    %edi
    7d2e:	5d                   	pop    %ebp
    7d2f:	c3                   	ret    

00007d30 <bootmain>:

void readseg(uchar*, uint, uint);

void
bootmain(void)
{
    7d30:	55                   	push   %ebp
    7d31:	89 e5                	mov    %esp,%ebp
    7d33:	57                   	push   %edi
    7d34:	56                   	push   %esi
    7d35:	53                   	push   %ebx
    7d36:	83 ec 0c             	sub    $0xc,%esp
  uchar* pa;

  elf = (struct elfhdr*)0x10000;  // scratch space

  // Read 1st page off disk
  readseg((uchar*)elf, 4096, 0);
    7d39:	6a 00                	push   $0x0
    7d3b:	68 00 10 00 00       	push   $0x1000
    7d40:	68 00 00 01 00       	push   $0x10000
    7d45:	e8 a3 ff ff ff       	call   7ced <readseg>

  // Is this an ELF executable?
  if(elf->magic != ELF_MAGIC)
    7d4a:	83 c4 0c             	add    $0xc,%esp
    7d4d:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
    7d54:	45 4c 46 
    7d57:	75 50                	jne    7da9 <bootmain+0x79>
    return;  // let bootasm.S handle error

  // Load each program segment (ignores ph flags).
  ph = (struct proghdr*)((uchar*)elf + elf->phoff);
    7d59:	a1 1c 00 01 00       	mov    0x1001c,%eax
    7d5e:	8d 98 00 00 01 00    	lea    0x10000(%eax),%ebx
  eph = ph + elf->phnum;
    7d64:	0f b7 35 2c 00 01 00 	movzwl 0x1002c,%esi
    7d6b:	c1 e6 05             	shl    $0x5,%esi
    7d6e:	01 de                	add    %ebx,%esi
  for(; ph < eph; ph++){
    7d70:	39 f3                	cmp    %esi,%ebx
    7d72:	73 2f                	jae    7da3 <bootmain+0x73>
    pa = (uchar*)ph->paddr;
    7d74:	8b 7b 0c             	mov    0xc(%ebx),%edi
    readseg(pa, ph->filesz, ph->off);
    7d77:	ff 73 04             	pushl  0x4(%ebx)
    7d7a:	ff 73 10             	pushl  0x10(%ebx)
    7d7d:	57                   	push   %edi
    7d7e:	e8 6a ff ff ff       	call   7ced <readseg>
    if(ph->memsz > ph->filesz)
    7d83:	8b 4b 14             	mov    0x14(%ebx),%ecx
    7d86:	8b 43 10             	mov    0x10(%ebx),%eax
    7d89:	83 c4 0c             	add    $0xc,%esp
    7d8c:	39 c1                	cmp    %eax,%ecx
    7d8e:	76 0c                	jbe    7d9c <bootmain+0x6c>
      stosb(pa + ph->filesz, 0, ph->memsz - ph->filesz);
    7d90:	01 c7                	add    %eax,%edi
    7d92:	29 c1                	sub    %eax,%ecx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    7d94:	b8 00 00 00 00       	mov    $0x0,%eax
    7d99:	fc                   	cld    
    7d9a:	f3 aa                	rep stos %al,%es:(%edi)
    return;  // let bootasm.S handle error

  // Load each program segment (ignores ph flags).
  ph = (struct proghdr*)((uchar*)elf + elf->phoff);
  eph = ph + elf->phnum;
  for(; ph < eph; ph++){
    7d9c:	83 c3 20             	add    $0x20,%ebx
    7d9f:	39 de                	cmp    %ebx,%esi
    7da1:	77 d1                	ja     7d74 <bootmain+0x44>
  }

  // Call the entry point from the ELF header.
  // Does not return!
  entry = (void(*)(void))(elf->entry);
  entry();
    7da3:	ff 15 18 00 01 00    	call   *0x10018
}
    7da9:	8d 65 f4             	lea    -0xc(%ebp),%esp
    7dac:	5b                   	pop    %ebx
    7dad:	5e                   	pop    %esi
    7dae:	5f                   	pop    %edi
    7daf:	5d                   	pop    %ebp
    7db0:	c3                   	ret    
