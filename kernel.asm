
kernel:     формат файла elf32-i386


Дизассемблирование раздела .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 50 c6 10 80       	mov    $0x8010c650,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 b1 33 10 80       	mov    $0x801033b1,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 dc 7f 10 	movl   $0x80107fdc,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100049:	e8 d7 49 00 00       	call   80104a25 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 90 db 10 80 84 	movl   $0x8010db84,0x8010db90
80100055:	db 10 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 94 db 10 80 84 	movl   $0x8010db84,0x8010db94
8010005f:	db 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 94 c6 10 80 	movl   $0x8010c694,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 94 db 10 80    	mov    0x8010db94,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c 84 db 10 80 	movl   $0x8010db84,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 94 db 10 80       	mov    0x8010db94,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 94 db 10 80       	mov    %eax,0x8010db94

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
801000ac:	72 bd                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000ae:	c9                   	leave  
801000af:	c3                   	ret    

801000b0 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate fresh block.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b0:	55                   	push   %ebp
801000b1:	89 e5                	mov    %esp,%ebp
801000b3:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b6:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801000bd:	e8 84 49 00 00       	call   80104a46 <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c2:	a1 94 db 10 80       	mov    0x8010db94,%eax
801000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000ca:	eb 63                	jmp    8010012f <bget+0x7f>
    if(b->dev == dev && b->sector == sector){
801000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000cf:	8b 40 04             	mov    0x4(%eax),%eax
801000d2:	3b 45 08             	cmp    0x8(%ebp),%eax
801000d5:	75 4f                	jne    80100126 <bget+0x76>
801000d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000da:	8b 40 08             	mov    0x8(%eax),%eax
801000dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e0:	75 44                	jne    80100126 <bget+0x76>
      if(!(b->flags & B_BUSY)){
801000e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e5:	8b 00                	mov    (%eax),%eax
801000e7:	83 e0 01             	and    $0x1,%eax
801000ea:	85 c0                	test   %eax,%eax
801000ec:	75 23                	jne    80100111 <bget+0x61>
        b->flags |= B_BUSY;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 00                	mov    (%eax),%eax
801000f3:	83 c8 01             	or     $0x1,%eax
801000f6:	89 c2                	mov    %eax,%edx
801000f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fb:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
801000fd:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100104:	e8 9f 49 00 00       	call   80104aa8 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 60 c6 10 	movl   $0x8010c660,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 58 46 00 00       	call   8010477c <sleep>
      goto loop;
80100124:	eb 9c                	jmp    801000c2 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 10             	mov    0x10(%eax),%eax
8010012c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010012f:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
80100136:	75 94                	jne    801000cc <bget+0x1c>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100138:	a1 90 db 10 80       	mov    0x8010db90,%eax
8010013d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100140:	eb 4d                	jmp    8010018f <bget+0xdf>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
80100142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100145:	8b 00                	mov    (%eax),%eax
80100147:	83 e0 01             	and    $0x1,%eax
8010014a:	85 c0                	test   %eax,%eax
8010014c:	75 38                	jne    80100186 <bget+0xd6>
8010014e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100151:	8b 00                	mov    (%eax),%eax
80100153:	83 e0 04             	and    $0x4,%eax
80100156:	85 c0                	test   %eax,%eax
80100158:	75 2c                	jne    80100186 <bget+0xd6>
      b->dev = dev;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 08             	mov    0x8(%ebp),%edx
80100160:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	8b 55 0c             	mov    0xc(%ebp),%edx
80100169:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100175:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010017c:	e8 27 49 00 00       	call   80104aa8 <release>
      return b;
80100181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100184:	eb 1e                	jmp    801001a4 <bget+0xf4>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100189:	8b 40 0c             	mov    0xc(%eax),%eax
8010018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010018f:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
80100196:	75 aa                	jne    80100142 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100198:	c7 04 24 e3 7f 10 80 	movl   $0x80107fe3,(%esp)
8010019f:	e8 96 03 00 00       	call   8010053a <panic>
}
801001a4:	c9                   	leave  
801001a5:	c3                   	ret    

801001a6 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001a6:	55                   	push   %ebp
801001a7:	89 e5                	mov    %esp,%ebp
801001a9:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, sector);
801001ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801001af:	89 44 24 04          	mov    %eax,0x4(%esp)
801001b3:	8b 45 08             	mov    0x8(%ebp),%eax
801001b6:	89 04 24             	mov    %eax,(%esp)
801001b9:	e8 f2 fe ff ff       	call   801000b0 <bget>
801001be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001c4:	8b 00                	mov    (%eax),%eax
801001c6:	83 e0 02             	and    $0x2,%eax
801001c9:	85 c0                	test   %eax,%eax
801001cb:	75 0b                	jne    801001d8 <bread+0x32>
    iderw(b);
801001cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d0:	89 04 24             	mov    %eax,(%esp)
801001d3:	e8 b5 25 00 00       	call   8010278d <iderw>
  return b;
801001d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001db:	c9                   	leave  
801001dc:	c3                   	ret    

801001dd <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001dd:	55                   	push   %ebp
801001de:	89 e5                	mov    %esp,%ebp
801001e0:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
801001e3:	8b 45 08             	mov    0x8(%ebp),%eax
801001e6:	8b 00                	mov    (%eax),%eax
801001e8:	83 e0 01             	and    $0x1,%eax
801001eb:	85 c0                	test   %eax,%eax
801001ed:	75 0c                	jne    801001fb <bwrite+0x1e>
    panic("bwrite");
801001ef:	c7 04 24 f4 7f 10 80 	movl   $0x80107ff4,(%esp)
801001f6:	e8 3f 03 00 00       	call   8010053a <panic>
  b->flags |= B_DIRTY;
801001fb:	8b 45 08             	mov    0x8(%ebp),%eax
801001fe:	8b 00                	mov    (%eax),%eax
80100200:	83 c8 04             	or     $0x4,%eax
80100203:	89 c2                	mov    %eax,%edx
80100205:	8b 45 08             	mov    0x8(%ebp),%eax
80100208:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010020a:	8b 45 08             	mov    0x8(%ebp),%eax
8010020d:	89 04 24             	mov    %eax,(%esp)
80100210:	e8 78 25 00 00       	call   8010278d <iderw>
}
80100215:	c9                   	leave  
80100216:	c3                   	ret    

80100217 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100217:	55                   	push   %ebp
80100218:	89 e5                	mov    %esp,%ebp
8010021a:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
8010021d:	8b 45 08             	mov    0x8(%ebp),%eax
80100220:	8b 00                	mov    (%eax),%eax
80100222:	83 e0 01             	and    $0x1,%eax
80100225:	85 c0                	test   %eax,%eax
80100227:	75 0c                	jne    80100235 <brelse+0x1e>
    panic("brelse");
80100229:	c7 04 24 fb 7f 10 80 	movl   $0x80107ffb,(%esp)
80100230:	e8 05 03 00 00       	call   8010053a <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010023c:	e8 05 48 00 00       	call   80104a46 <acquire>

  b->next->prev = b->prev;
80100241:	8b 45 08             	mov    0x8(%ebp),%eax
80100244:	8b 40 10             	mov    0x10(%eax),%eax
80100247:	8b 55 08             	mov    0x8(%ebp),%edx
8010024a:	8b 52 0c             	mov    0xc(%edx),%edx
8010024d:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	8b 40 0c             	mov    0xc(%eax),%eax
80100256:	8b 55 08             	mov    0x8(%ebp),%edx
80100259:	8b 52 10             	mov    0x10(%edx),%edx
8010025c:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010025f:	8b 15 94 db 10 80    	mov    0x8010db94,%edx
80100265:	8b 45 08             	mov    0x8(%ebp),%eax
80100268:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	c7 40 0c 84 db 10 80 	movl   $0x8010db84,0xc(%eax)
  bcache.head.next->prev = b;
80100275:	a1 94 db 10 80       	mov    0x8010db94,%eax
8010027a:	8b 55 08             	mov    0x8(%ebp),%edx
8010027d:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100280:	8b 45 08             	mov    0x8(%ebp),%eax
80100283:	a3 94 db 10 80       	mov    %eax,0x8010db94

  b->flags &= ~B_BUSY;
80100288:	8b 45 08             	mov    0x8(%ebp),%eax
8010028b:	8b 00                	mov    (%eax),%eax
8010028d:	83 e0 fe             	and    $0xfffffffe,%eax
80100290:	89 c2                	mov    %eax,%edx
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80100297:	8b 45 08             	mov    0x8(%ebp),%eax
8010029a:	89 04 24             	mov    %eax,(%esp)
8010029d:	e8 b3 45 00 00       	call   80104855 <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801002a9:	e8 fa 47 00 00       	call   80104aa8 <release>
}
801002ae:	c9                   	leave  
801002af:	c3                   	ret    

801002b0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002b0:	55                   	push   %ebp
801002b1:	89 e5                	mov    %esp,%ebp
801002b3:	83 ec 14             	sub    $0x14,%esp
801002b6:	8b 45 08             	mov    0x8(%ebp),%eax
801002b9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002bd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002c1:	89 c2                	mov    %eax,%edx
801002c3:	ec                   	in     (%dx),%al
801002c4:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002c7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002cb:	c9                   	leave  
801002cc:	c3                   	ret    

801002cd <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002cd:	55                   	push   %ebp
801002ce:	89 e5                	mov    %esp,%ebp
801002d0:	83 ec 08             	sub    $0x8,%esp
801002d3:	8b 55 08             	mov    0x8(%ebp),%edx
801002d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801002d9:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002dd:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002e0:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801002e4:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801002e8:	ee                   	out    %al,(%dx)
}
801002e9:	c9                   	leave  
801002ea:	c3                   	ret    

801002eb <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801002eb:	55                   	push   %ebp
801002ec:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801002ee:	fa                   	cli    
}
801002ef:	5d                   	pop    %ebp
801002f0:	c3                   	ret    

801002f1 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	56                   	push   %esi
801002f5:	53                   	push   %ebx
801002f6:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
801002f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801002fd:	74 1c                	je     8010031b <printint+0x2a>
801002ff:	8b 45 08             	mov    0x8(%ebp),%eax
80100302:	c1 e8 1f             	shr    $0x1f,%eax
80100305:	0f b6 c0             	movzbl %al,%eax
80100308:	89 45 10             	mov    %eax,0x10(%ebp)
8010030b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010030f:	74 0a                	je     8010031b <printint+0x2a>
    x = -xx;
80100311:	8b 45 08             	mov    0x8(%ebp),%eax
80100314:	f7 d8                	neg    %eax
80100316:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100319:	eb 06                	jmp    80100321 <printint+0x30>
  else
    x = xx;
8010031b:	8b 45 08             	mov    0x8(%ebp),%eax
8010031e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100321:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100328:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010032b:	8d 41 01             	lea    0x1(%ecx),%eax
8010032e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100331:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100334:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100337:	ba 00 00 00 00       	mov    $0x0,%edx
8010033c:	f7 f3                	div    %ebx
8010033e:	89 d0                	mov    %edx,%eax
80100340:	0f b6 80 04 90 10 80 	movzbl -0x7fef6ffc(%eax),%eax
80100347:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
8010034b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010034e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100351:	ba 00 00 00 00       	mov    $0x0,%edx
80100356:	f7 f6                	div    %esi
80100358:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010035b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010035f:	75 c7                	jne    80100328 <printint+0x37>

  if(sign)
80100361:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100365:	74 10                	je     80100377 <printint+0x86>
    buf[i++] = '-';
80100367:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010036a:	8d 50 01             	lea    0x1(%eax),%edx
8010036d:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100370:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
80100375:	eb 18                	jmp    8010038f <printint+0x9e>
80100377:	eb 16                	jmp    8010038f <printint+0x9e>
    consputc(buf[i]);
80100379:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010037c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010037f:	01 d0                	add    %edx,%eax
80100381:	0f b6 00             	movzbl (%eax),%eax
80100384:	0f be c0             	movsbl %al,%eax
80100387:	89 04 24             	mov    %eax,(%esp)
8010038a:	e8 c1 03 00 00       	call   80100750 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
8010038f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100393:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100397:	79 e0                	jns    80100379 <printint+0x88>
    consputc(buf[i]);
}
80100399:	83 c4 30             	add    $0x30,%esp
8010039c:	5b                   	pop    %ebx
8010039d:	5e                   	pop    %esi
8010039e:	5d                   	pop    %ebp
8010039f:	c3                   	ret    

801003a0 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003a0:	55                   	push   %ebp
801003a1:	89 e5                	mov    %esp,%ebp
801003a3:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003a6:	a1 f4 b5 10 80       	mov    0x8010b5f4,%eax
801003ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003b2:	74 0c                	je     801003c0 <cprintf+0x20>
    acquire(&cons.lock);
801003b4:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
801003bb:	e8 86 46 00 00       	call   80104a46 <acquire>

  if (fmt == 0)
801003c0:	8b 45 08             	mov    0x8(%ebp),%eax
801003c3:	85 c0                	test   %eax,%eax
801003c5:	75 0c                	jne    801003d3 <cprintf+0x33>
    panic("null fmt");
801003c7:	c7 04 24 02 80 10 80 	movl   $0x80108002,(%esp)
801003ce:	e8 67 01 00 00       	call   8010053a <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003d3:	8d 45 0c             	lea    0xc(%ebp),%eax
801003d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801003e0:	e9 21 01 00 00       	jmp    80100506 <cprintf+0x166>
    if(c != '%'){
801003e5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801003e9:	74 10                	je     801003fb <cprintf+0x5b>
      consputc(c);
801003eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801003ee:	89 04 24             	mov    %eax,(%esp)
801003f1:	e8 5a 03 00 00       	call   80100750 <consputc>
      continue;
801003f6:	e9 07 01 00 00       	jmp    80100502 <cprintf+0x162>
    }
    c = fmt[++i] & 0xff;
801003fb:	8b 55 08             	mov    0x8(%ebp),%edx
801003fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100405:	01 d0                	add    %edx,%eax
80100407:	0f b6 00             	movzbl (%eax),%eax
8010040a:	0f be c0             	movsbl %al,%eax
8010040d:	25 ff 00 00 00       	and    $0xff,%eax
80100412:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100415:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100419:	75 05                	jne    80100420 <cprintf+0x80>
      break;
8010041b:	e9 06 01 00 00       	jmp    80100526 <cprintf+0x186>
    switch(c){
80100420:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100423:	83 f8 70             	cmp    $0x70,%eax
80100426:	74 4f                	je     80100477 <cprintf+0xd7>
80100428:	83 f8 70             	cmp    $0x70,%eax
8010042b:	7f 13                	jg     80100440 <cprintf+0xa0>
8010042d:	83 f8 25             	cmp    $0x25,%eax
80100430:	0f 84 a6 00 00 00    	je     801004dc <cprintf+0x13c>
80100436:	83 f8 64             	cmp    $0x64,%eax
80100439:	74 14                	je     8010044f <cprintf+0xaf>
8010043b:	e9 aa 00 00 00       	jmp    801004ea <cprintf+0x14a>
80100440:	83 f8 73             	cmp    $0x73,%eax
80100443:	74 57                	je     8010049c <cprintf+0xfc>
80100445:	83 f8 78             	cmp    $0x78,%eax
80100448:	74 2d                	je     80100477 <cprintf+0xd7>
8010044a:	e9 9b 00 00 00       	jmp    801004ea <cprintf+0x14a>
    case 'd':
      printint(*argp++, 10, 1);
8010044f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100452:	8d 50 04             	lea    0x4(%eax),%edx
80100455:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100458:	8b 00                	mov    (%eax),%eax
8010045a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80100461:	00 
80100462:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100469:	00 
8010046a:	89 04 24             	mov    %eax,(%esp)
8010046d:	e8 7f fe ff ff       	call   801002f1 <printint>
      break;
80100472:	e9 8b 00 00 00       	jmp    80100502 <cprintf+0x162>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100477:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047a:	8d 50 04             	lea    0x4(%eax),%edx
8010047d:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100480:	8b 00                	mov    (%eax),%eax
80100482:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100489:	00 
8010048a:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80100491:	00 
80100492:	89 04 24             	mov    %eax,(%esp)
80100495:	e8 57 fe ff ff       	call   801002f1 <printint>
      break;
8010049a:	eb 66                	jmp    80100502 <cprintf+0x162>
    case 's':
      if((s = (char*)*argp++) == 0)
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004ae:	75 09                	jne    801004b9 <cprintf+0x119>
        s = "(null)";
801004b0:	c7 45 ec 0b 80 10 80 	movl   $0x8010800b,-0x14(%ebp)
      for(; *s; s++)
801004b7:	eb 17                	jmp    801004d0 <cprintf+0x130>
801004b9:	eb 15                	jmp    801004d0 <cprintf+0x130>
        consputc(*s);
801004bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004be:	0f b6 00             	movzbl (%eax),%eax
801004c1:	0f be c0             	movsbl %al,%eax
801004c4:	89 04 24             	mov    %eax,(%esp)
801004c7:	e8 84 02 00 00       	call   80100750 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004cc:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d3:	0f b6 00             	movzbl (%eax),%eax
801004d6:	84 c0                	test   %al,%al
801004d8:	75 e1                	jne    801004bb <cprintf+0x11b>
        consputc(*s);
      break;
801004da:	eb 26                	jmp    80100502 <cprintf+0x162>
    case '%':
      consputc('%');
801004dc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004e3:	e8 68 02 00 00       	call   80100750 <consputc>
      break;
801004e8:	eb 18                	jmp    80100502 <cprintf+0x162>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801004ea:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004f1:	e8 5a 02 00 00       	call   80100750 <consputc>
      consputc(c);
801004f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801004f9:	89 04 24             	mov    %eax,(%esp)
801004fc:	e8 4f 02 00 00       	call   80100750 <consputc>
      break;
80100501:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100502:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100506:	8b 55 08             	mov    0x8(%ebp),%edx
80100509:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010050c:	01 d0                	add    %edx,%eax
8010050e:	0f b6 00             	movzbl (%eax),%eax
80100511:	0f be c0             	movsbl %al,%eax
80100514:	25 ff 00 00 00       	and    $0xff,%eax
80100519:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010051c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100520:	0f 85 bf fe ff ff    	jne    801003e5 <cprintf+0x45>
      consputc(c);
      break;
    }
  }

  if(locking)
80100526:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010052a:	74 0c                	je     80100538 <cprintf+0x198>
    release(&cons.lock);
8010052c:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100533:	e8 70 45 00 00       	call   80104aa8 <release>
}
80100538:	c9                   	leave  
80100539:	c3                   	ret    

8010053a <panic>:

void
panic(char *s)
{
8010053a:	55                   	push   %ebp
8010053b:	89 e5                	mov    %esp,%ebp
8010053d:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];
  
  cli();
80100540:	e8 a6 fd ff ff       	call   801002eb <cli>
  cons.locking = 0;
80100545:	c7 05 f4 b5 10 80 00 	movl   $0x0,0x8010b5f4
8010054c:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010054f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100555:	0f b6 00             	movzbl (%eax),%eax
80100558:	0f b6 c0             	movzbl %al,%eax
8010055b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010055f:	c7 04 24 12 80 10 80 	movl   $0x80108012,(%esp)
80100566:	e8 35 fe ff ff       	call   801003a0 <cprintf>
  cprintf(s);
8010056b:	8b 45 08             	mov    0x8(%ebp),%eax
8010056e:	89 04 24             	mov    %eax,(%esp)
80100571:	e8 2a fe ff ff       	call   801003a0 <cprintf>
  cprintf("\n");
80100576:	c7 04 24 21 80 10 80 	movl   $0x80108021,(%esp)
8010057d:	e8 1e fe ff ff       	call   801003a0 <cprintf>
  getcallerpcs(&s, pcs);
80100582:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100585:	89 44 24 04          	mov    %eax,0x4(%esp)
80100589:	8d 45 08             	lea    0x8(%ebp),%eax
8010058c:	89 04 24             	mov    %eax,(%esp)
8010058f:	e8 63 45 00 00       	call   80104af7 <getcallerpcs>
  for(i=0; i<10; i++)
80100594:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010059b:	eb 1b                	jmp    801005b8 <panic+0x7e>
    cprintf(" %p", pcs[i]);
8010059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005a0:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a8:	c7 04 24 23 80 10 80 	movl   $0x80108023,(%esp)
801005af:	e8 ec fd ff ff       	call   801003a0 <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005b4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005b8:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005bc:	7e df                	jle    8010059d <panic+0x63>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005be:	c7 05 a0 b5 10 80 01 	movl   $0x1,0x8010b5a0
801005c5:	00 00 00 
  for(;;)
    ;
801005c8:	eb fe                	jmp    801005c8 <panic+0x8e>

801005ca <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005ca:	55                   	push   %ebp
801005cb:	89 e5                	mov    %esp,%ebp
801005cd:	83 ec 28             	sub    $0x28,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005d0:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005d7:	00 
801005d8:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005df:	e8 e9 fc ff ff       	call   801002cd <outb>
  pos = inb(CRTPORT+1) << 8;
801005e4:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005eb:	e8 c0 fc ff ff       	call   801002b0 <inb>
801005f0:	0f b6 c0             	movzbl %al,%eax
801005f3:	c1 e0 08             	shl    $0x8,%eax
801005f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
801005f9:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100600:	00 
80100601:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100608:	e8 c0 fc ff ff       	call   801002cd <outb>
  pos |= inb(CRTPORT+1);
8010060d:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100614:	e8 97 fc ff ff       	call   801002b0 <inb>
80100619:	0f b6 c0             	movzbl %al,%eax
8010061c:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010061f:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100623:	75 30                	jne    80100655 <cgaputc+0x8b>
    pos += 80 - pos%80;
80100625:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100628:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010062d:	89 c8                	mov    %ecx,%eax
8010062f:	f7 ea                	imul   %edx
80100631:	c1 fa 05             	sar    $0x5,%edx
80100634:	89 c8                	mov    %ecx,%eax
80100636:	c1 f8 1f             	sar    $0x1f,%eax
80100639:	29 c2                	sub    %eax,%edx
8010063b:	89 d0                	mov    %edx,%eax
8010063d:	c1 e0 02             	shl    $0x2,%eax
80100640:	01 d0                	add    %edx,%eax
80100642:	c1 e0 04             	shl    $0x4,%eax
80100645:	29 c1                	sub    %eax,%ecx
80100647:	89 ca                	mov    %ecx,%edx
80100649:	b8 50 00 00 00       	mov    $0x50,%eax
8010064e:	29 d0                	sub    %edx,%eax
80100650:	01 45 f4             	add    %eax,-0xc(%ebp)
80100653:	eb 35                	jmp    8010068a <cgaputc+0xc0>
  else if(c == BACKSPACE){
80100655:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010065c:	75 0c                	jne    8010066a <cgaputc+0xa0>
    if(pos > 0) --pos;
8010065e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100662:	7e 26                	jle    8010068a <cgaputc+0xc0>
80100664:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100668:	eb 20                	jmp    8010068a <cgaputc+0xc0>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010066a:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
80100670:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100673:	8d 50 01             	lea    0x1(%eax),%edx
80100676:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100679:	01 c0                	add    %eax,%eax
8010067b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
8010067e:	8b 45 08             	mov    0x8(%ebp),%eax
80100681:	0f b6 c0             	movzbl %al,%eax
80100684:	80 cc 07             	or     $0x7,%ah
80100687:	66 89 02             	mov    %ax,(%edx)
  
  if((pos/80) >= 24){  // Scroll up.
8010068a:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
80100691:	7e 53                	jle    801006e6 <cgaputc+0x11c>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100693:	a1 00 90 10 80       	mov    0x80109000,%eax
80100698:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
8010069e:	a1 00 90 10 80       	mov    0x80109000,%eax
801006a3:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006aa:	00 
801006ab:	89 54 24 04          	mov    %edx,0x4(%esp)
801006af:	89 04 24             	mov    %eax,(%esp)
801006b2:	e8 b2 46 00 00       	call   80104d69 <memmove>
    pos -= 80;
801006b7:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006bb:	b8 80 07 00 00       	mov    $0x780,%eax
801006c0:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006c3:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006c6:	a1 00 90 10 80       	mov    0x80109000,%eax
801006cb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006ce:	01 c9                	add    %ecx,%ecx
801006d0:	01 c8                	add    %ecx,%eax
801006d2:	89 54 24 08          	mov    %edx,0x8(%esp)
801006d6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006dd:	00 
801006de:	89 04 24             	mov    %eax,(%esp)
801006e1:	e8 b4 45 00 00       	call   80104c9a <memset>
  }
  
  outb(CRTPORT, 14);
801006e6:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801006ed:	00 
801006ee:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801006f5:	e8 d3 fb ff ff       	call   801002cd <outb>
  outb(CRTPORT+1, pos>>8);
801006fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006fd:	c1 f8 08             	sar    $0x8,%eax
80100700:	0f b6 c0             	movzbl %al,%eax
80100703:	89 44 24 04          	mov    %eax,0x4(%esp)
80100707:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010070e:	e8 ba fb ff ff       	call   801002cd <outb>
  outb(CRTPORT, 15);
80100713:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
8010071a:	00 
8010071b:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100722:	e8 a6 fb ff ff       	call   801002cd <outb>
  outb(CRTPORT+1, pos);
80100727:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010072a:	0f b6 c0             	movzbl %al,%eax
8010072d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100731:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100738:	e8 90 fb ff ff       	call   801002cd <outb>
  crt[pos] = ' ' | 0x0700;
8010073d:	a1 00 90 10 80       	mov    0x80109000,%eax
80100742:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100745:	01 d2                	add    %edx,%edx
80100747:	01 d0                	add    %edx,%eax
80100749:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010074e:	c9                   	leave  
8010074f:	c3                   	ret    

80100750 <consputc>:

void
consputc(int c)
{
80100750:	55                   	push   %ebp
80100751:	89 e5                	mov    %esp,%ebp
80100753:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
80100756:	a1 a0 b5 10 80       	mov    0x8010b5a0,%eax
8010075b:	85 c0                	test   %eax,%eax
8010075d:	74 07                	je     80100766 <consputc+0x16>
    cli();
8010075f:	e8 87 fb ff ff       	call   801002eb <cli>
    for(;;)
      ;
80100764:	eb fe                	jmp    80100764 <consputc+0x14>
  }

  if(c == BACKSPACE){
80100766:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010076d:	75 26                	jne    80100795 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010076f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100776:	e8 a4 5e 00 00       	call   8010661f <uartputc>
8010077b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100782:	e8 98 5e 00 00       	call   8010661f <uartputc>
80100787:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010078e:	e8 8c 5e 00 00       	call   8010661f <uartputc>
80100793:	eb 0b                	jmp    801007a0 <consputc+0x50>
  } else
    uartputc(c);
80100795:	8b 45 08             	mov    0x8(%ebp),%eax
80100798:	89 04 24             	mov    %eax,(%esp)
8010079b:	e8 7f 5e 00 00       	call   8010661f <uartputc>
  cgaputc(c);
801007a0:	8b 45 08             	mov    0x8(%ebp),%eax
801007a3:	89 04 24             	mov    %eax,(%esp)
801007a6:	e8 1f fe ff ff       	call   801005ca <cgaputc>
}
801007ab:	c9                   	leave  
801007ac:	c3                   	ret    

801007ad <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007ad:	55                   	push   %ebp
801007ae:	89 e5                	mov    %esp,%ebp
801007b0:	83 ec 28             	sub    $0x28,%esp
  int c;

  acquire(&input.lock);
801007b3:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
801007ba:	e8 87 42 00 00       	call   80104a46 <acquire>
  while((c = getc()) >= 0){
801007bf:	e9 37 01 00 00       	jmp    801008fb <consoleintr+0x14e>
    switch(c){
801007c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007c7:	83 f8 10             	cmp    $0x10,%eax
801007ca:	74 1e                	je     801007ea <consoleintr+0x3d>
801007cc:	83 f8 10             	cmp    $0x10,%eax
801007cf:	7f 0a                	jg     801007db <consoleintr+0x2e>
801007d1:	83 f8 08             	cmp    $0x8,%eax
801007d4:	74 64                	je     8010083a <consoleintr+0x8d>
801007d6:	e9 91 00 00 00       	jmp    8010086c <consoleintr+0xbf>
801007db:	83 f8 15             	cmp    $0x15,%eax
801007de:	74 2f                	je     8010080f <consoleintr+0x62>
801007e0:	83 f8 7f             	cmp    $0x7f,%eax
801007e3:	74 55                	je     8010083a <consoleintr+0x8d>
801007e5:	e9 82 00 00 00       	jmp    8010086c <consoleintr+0xbf>
    case C('P'):  // Process listing.
      procdump();
801007ea:	e8 09 41 00 00       	call   801048f8 <procdump>
      break;
801007ef:	e9 07 01 00 00       	jmp    801008fb <consoleintr+0x14e>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801007f4:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801007f9:	83 e8 01             	sub    $0x1,%eax
801007fc:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(BACKSPACE);
80100801:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100808:	e8 43 ff ff ff       	call   80100750 <consputc>
8010080d:	eb 01                	jmp    80100810 <consoleintr+0x63>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010080f:	90                   	nop
80100810:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
80100816:	a1 58 de 10 80       	mov    0x8010de58,%eax
8010081b:	39 c2                	cmp    %eax,%edx
8010081d:	74 16                	je     80100835 <consoleintr+0x88>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010081f:	a1 5c de 10 80       	mov    0x8010de5c,%eax
80100824:	83 e8 01             	sub    $0x1,%eax
80100827:	83 e0 7f             	and    $0x7f,%eax
8010082a:	0f b6 80 d4 dd 10 80 	movzbl -0x7fef222c(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100831:	3c 0a                	cmp    $0xa,%al
80100833:	75 bf                	jne    801007f4 <consoleintr+0x47>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100835:	e9 c1 00 00 00       	jmp    801008fb <consoleintr+0x14e>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
8010083a:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
80100840:	a1 58 de 10 80       	mov    0x8010de58,%eax
80100845:	39 c2                	cmp    %eax,%edx
80100847:	74 1e                	je     80100867 <consoleintr+0xba>
        input.e--;
80100849:	a1 5c de 10 80       	mov    0x8010de5c,%eax
8010084e:	83 e8 01             	sub    $0x1,%eax
80100851:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(BACKSPACE);
80100856:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010085d:	e8 ee fe ff ff       	call   80100750 <consputc>
      }
      break;
80100862:	e9 94 00 00 00       	jmp    801008fb <consoleintr+0x14e>
80100867:	e9 8f 00 00 00       	jmp    801008fb <consoleintr+0x14e>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010086c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100870:	0f 84 84 00 00 00    	je     801008fa <consoleintr+0x14d>
80100876:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
8010087c:	a1 54 de 10 80       	mov    0x8010de54,%eax
80100881:	29 c2                	sub    %eax,%edx
80100883:	89 d0                	mov    %edx,%eax
80100885:	83 f8 7f             	cmp    $0x7f,%eax
80100888:	77 70                	ja     801008fa <consoleintr+0x14d>
        c = (c == '\r') ? '\n' : c;
8010088a:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
8010088e:	74 05                	je     80100895 <consoleintr+0xe8>
80100890:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100893:	eb 05                	jmp    8010089a <consoleintr+0xed>
80100895:	b8 0a 00 00 00       	mov    $0xa,%eax
8010089a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
8010089d:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008a2:	8d 50 01             	lea    0x1(%eax),%edx
801008a5:	89 15 5c de 10 80    	mov    %edx,0x8010de5c
801008ab:	83 e0 7f             	and    $0x7f,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008b3:	88 82 d4 dd 10 80    	mov    %al,-0x7fef222c(%edx)
        consputc(c);
801008b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008bc:	89 04 24             	mov    %eax,(%esp)
801008bf:	e8 8c fe ff ff       	call   80100750 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c4:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008c8:	74 18                	je     801008e2 <consoleintr+0x135>
801008ca:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008ce:	74 12                	je     801008e2 <consoleintr+0x135>
801008d0:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008d5:	8b 15 54 de 10 80    	mov    0x8010de54,%edx
801008db:	83 ea 80             	sub    $0xffffff80,%edx
801008de:	39 d0                	cmp    %edx,%eax
801008e0:	75 18                	jne    801008fa <consoleintr+0x14d>
          input.w = input.e;
801008e2:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008e7:	a3 58 de 10 80       	mov    %eax,0x8010de58
          wakeup(&input.r);
801008ec:	c7 04 24 54 de 10 80 	movl   $0x8010de54,(%esp)
801008f3:	e8 5d 3f 00 00       	call   80104855 <wakeup>
        }
      }
      break;
801008f8:	eb 00                	jmp    801008fa <consoleintr+0x14d>
801008fa:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
801008fb:	8b 45 08             	mov    0x8(%ebp),%eax
801008fe:	ff d0                	call   *%eax
80100900:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100903:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100907:	0f 89 b7 fe ff ff    	jns    801007c4 <consoleintr+0x17>
        }
      }
      break;
    }
  }
  release(&input.lock);
8010090d:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100914:	e8 8f 41 00 00       	call   80104aa8 <release>
}
80100919:	c9                   	leave  
8010091a:	c3                   	ret    

8010091b <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010091b:	55                   	push   %ebp
8010091c:	89 e5                	mov    %esp,%ebp
8010091e:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100921:	8b 45 08             	mov    0x8(%ebp),%eax
80100924:	89 04 24             	mov    %eax,(%esp)
80100927:	e8 69 10 00 00       	call   80101995 <iunlock>
  target = n;
8010092c:	8b 45 10             	mov    0x10(%ebp),%eax
8010092f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100932:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100939:	e8 08 41 00 00       	call   80104a46 <acquire>
  while(n > 0){
8010093e:	e9 aa 00 00 00       	jmp    801009ed <consoleread+0xd2>
    while(input.r == input.w){
80100943:	eb 42                	jmp    80100987 <consoleread+0x6c>
      if(proc->killed){
80100945:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010094b:	8b 40 24             	mov    0x24(%eax),%eax
8010094e:	85 c0                	test   %eax,%eax
80100950:	74 21                	je     80100973 <consoleread+0x58>
        release(&input.lock);
80100952:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100959:	e8 4a 41 00 00       	call   80104aa8 <release>
        ilock(ip);
8010095e:	8b 45 08             	mov    0x8(%ebp),%eax
80100961:	89 04 24             	mov    %eax,(%esp)
80100964:	e8 de 0e 00 00       	call   80101847 <ilock>
        return -1;
80100969:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010096e:	e9 a5 00 00 00       	jmp    80100a18 <consoleread+0xfd>
      }
      sleep(&input.r, &input.lock);
80100973:	c7 44 24 04 a0 dd 10 	movl   $0x8010dda0,0x4(%esp)
8010097a:	80 
8010097b:	c7 04 24 54 de 10 80 	movl   $0x8010de54,(%esp)
80100982:	e8 f5 3d 00 00       	call   8010477c <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
80100987:	8b 15 54 de 10 80    	mov    0x8010de54,%edx
8010098d:	a1 58 de 10 80       	mov    0x8010de58,%eax
80100992:	39 c2                	cmp    %eax,%edx
80100994:	74 af                	je     80100945 <consoleread+0x2a>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100996:	a1 54 de 10 80       	mov    0x8010de54,%eax
8010099b:	8d 50 01             	lea    0x1(%eax),%edx
8010099e:	89 15 54 de 10 80    	mov    %edx,0x8010de54
801009a4:	83 e0 7f             	and    $0x7f,%eax
801009a7:	0f b6 80 d4 dd 10 80 	movzbl -0x7fef222c(%eax),%eax
801009ae:	0f be c0             	movsbl %al,%eax
801009b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
801009b4:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801009b8:	75 19                	jne    801009d3 <consoleread+0xb8>
      if(n < target){
801009ba:	8b 45 10             	mov    0x10(%ebp),%eax
801009bd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801009c0:	73 0f                	jae    801009d1 <consoleread+0xb6>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801009c2:	a1 54 de 10 80       	mov    0x8010de54,%eax
801009c7:	83 e8 01             	sub    $0x1,%eax
801009ca:	a3 54 de 10 80       	mov    %eax,0x8010de54
      }
      break;
801009cf:	eb 26                	jmp    801009f7 <consoleread+0xdc>
801009d1:	eb 24                	jmp    801009f7 <consoleread+0xdc>
    }
    *dst++ = c;
801009d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801009d6:	8d 50 01             	lea    0x1(%eax),%edx
801009d9:	89 55 0c             	mov    %edx,0xc(%ebp)
801009dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
801009df:	88 10                	mov    %dl,(%eax)
    --n;
801009e1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
801009e5:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801009e9:	75 02                	jne    801009ed <consoleread+0xd2>
      break;
801009eb:	eb 0a                	jmp    801009f7 <consoleread+0xdc>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
801009ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801009f1:	0f 8f 4c ff ff ff    	jg     80100943 <consoleread+0x28>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
801009f7:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
801009fe:	e8 a5 40 00 00       	call   80104aa8 <release>
  ilock(ip);
80100a03:	8b 45 08             	mov    0x8(%ebp),%eax
80100a06:	89 04 24             	mov    %eax,(%esp)
80100a09:	e8 39 0e 00 00       	call   80101847 <ilock>

  return target - n;
80100a0e:	8b 45 10             	mov    0x10(%ebp),%eax
80100a11:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a14:	29 c2                	sub    %eax,%edx
80100a16:	89 d0                	mov    %edx,%eax
}
80100a18:	c9                   	leave  
80100a19:	c3                   	ret    

80100a1a <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a1a:	55                   	push   %ebp
80100a1b:	89 e5                	mov    %esp,%ebp
80100a1d:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a20:	8b 45 08             	mov    0x8(%ebp),%eax
80100a23:	89 04 24             	mov    %eax,(%esp)
80100a26:	e8 6a 0f 00 00       	call   80101995 <iunlock>
  acquire(&cons.lock);
80100a2b:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a32:	e8 0f 40 00 00       	call   80104a46 <acquire>
  for(i = 0; i < n; i++)
80100a37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a3e:	eb 1d                	jmp    80100a5d <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100a40:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a43:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a46:	01 d0                	add    %edx,%eax
80100a48:	0f b6 00             	movzbl (%eax),%eax
80100a4b:	0f be c0             	movsbl %al,%eax
80100a4e:	0f b6 c0             	movzbl %al,%eax
80100a51:	89 04 24             	mov    %eax,(%esp)
80100a54:	e8 f7 fc ff ff       	call   80100750 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100a59:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a60:	3b 45 10             	cmp    0x10(%ebp),%eax
80100a63:	7c db                	jl     80100a40 <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100a65:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a6c:	e8 37 40 00 00       	call   80104aa8 <release>
  ilock(ip);
80100a71:	8b 45 08             	mov    0x8(%ebp),%eax
80100a74:	89 04 24             	mov    %eax,(%esp)
80100a77:	e8 cb 0d 00 00       	call   80101847 <ilock>

  return n;
80100a7c:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100a7f:	c9                   	leave  
80100a80:	c3                   	ret    

80100a81 <consoleinit>:

void
consoleinit(void)
{
80100a81:	55                   	push   %ebp
80100a82:	89 e5                	mov    %esp,%ebp
80100a84:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100a87:	c7 44 24 04 27 80 10 	movl   $0x80108027,0x4(%esp)
80100a8e:	80 
80100a8f:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a96:	e8 8a 3f 00 00       	call   80104a25 <initlock>
  initlock(&input.lock, "input");
80100a9b:	c7 44 24 04 2f 80 10 	movl   $0x8010802f,0x4(%esp)
80100aa2:	80 
80100aa3:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100aaa:	e8 76 3f 00 00       	call   80104a25 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100aaf:	c7 05 0c e8 10 80 1a 	movl   $0x80100a1a,0x8010e80c
80100ab6:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100ab9:	c7 05 08 e8 10 80 1b 	movl   $0x8010091b,0x8010e808
80100ac0:	09 10 80 
  cons.locking = 1;
80100ac3:	c7 05 f4 b5 10 80 01 	movl   $0x1,0x8010b5f4
80100aca:	00 00 00 

  picenable(IRQ_KBD);
80100acd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ad4:	e8 59 2f 00 00       	call   80103a32 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100ad9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100ae0:	00 
80100ae1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ae8:	e8 5c 1e 00 00       	call   80102949 <ioapicenable>
}
80100aed:	c9                   	leave  
80100aee:	c3                   	ret    

80100aef <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100aef:	55                   	push   %ebp
80100af0:	89 e5                	mov    %esp,%ebp
80100af2:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  if((ip = namei(path)) == 0)
80100af8:	8b 45 08             	mov    0x8(%ebp),%eax
80100afb:	89 04 24             	mov    %eax,(%esp)
80100afe:	e8 ef 18 00 00       	call   801023f2 <namei>
80100b03:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b06:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b0a:	75 0a                	jne    80100b16 <exec+0x27>
    return -1;
80100b0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b11:	e9 de 03 00 00       	jmp    80100ef4 <exec+0x405>
  ilock(ip);
80100b16:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b19:	89 04 24             	mov    %eax,(%esp)
80100b1c:	e8 26 0d 00 00       	call   80101847 <ilock>
  pgdir = 0;
80100b21:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b28:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b2f:	00 
80100b30:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b37:	00 
80100b38:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100b3e:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b42:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b45:	89 04 24             	mov    %eax,(%esp)
80100b48:	e8 07 12 00 00       	call   80101d54 <readi>
80100b4d:	83 f8 33             	cmp    $0x33,%eax
80100b50:	77 05                	ja     80100b57 <exec+0x68>
    goto bad;
80100b52:	e9 76 03 00 00       	jmp    80100ecd <exec+0x3de>
  if(elf.magic != ELF_MAGIC)
80100b57:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b5d:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b62:	74 05                	je     80100b69 <exec+0x7a>
    goto bad;
80100b64:	e9 64 03 00 00       	jmp    80100ecd <exec+0x3de>

  if((pgdir = setupkvm()) == 0)
80100b69:	e8 02 6c 00 00       	call   80107770 <setupkvm>
80100b6e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100b71:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100b75:	75 05                	jne    80100b7c <exec+0x8d>
    goto bad;
80100b77:	e9 51 03 00 00       	jmp    80100ecd <exec+0x3de>

  // Load program into memory.
  sz = 0;
80100b7c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b83:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100b8a:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100b90:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100b93:	e9 cb 00 00 00       	jmp    80100c63 <exec+0x174>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b98:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100b9b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100ba2:	00 
80100ba3:	89 44 24 08          	mov    %eax,0x8(%esp)
80100ba7:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100bad:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bb1:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100bb4:	89 04 24             	mov    %eax,(%esp)
80100bb7:	e8 98 11 00 00       	call   80101d54 <readi>
80100bbc:	83 f8 20             	cmp    $0x20,%eax
80100bbf:	74 05                	je     80100bc6 <exec+0xd7>
      goto bad;
80100bc1:	e9 07 03 00 00       	jmp    80100ecd <exec+0x3de>
    if(ph.type != ELF_PROG_LOAD)
80100bc6:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100bcc:	83 f8 01             	cmp    $0x1,%eax
80100bcf:	74 05                	je     80100bd6 <exec+0xe7>
      continue;
80100bd1:	e9 80 00 00 00       	jmp    80100c56 <exec+0x167>
    if(ph.memsz < ph.filesz)
80100bd6:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100bdc:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100be2:	39 c2                	cmp    %eax,%edx
80100be4:	73 05                	jae    80100beb <exec+0xfc>
      goto bad;
80100be6:	e9 e2 02 00 00       	jmp    80100ecd <exec+0x3de>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100beb:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100bf1:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100bf7:	01 d0                	add    %edx,%eax
80100bf9:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bfd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c00:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c04:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c07:	89 04 24             	mov    %eax,(%esp)
80100c0a:	e8 2f 6f 00 00       	call   80107b3e <allocuvm>
80100c0f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c12:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c16:	75 05                	jne    80100c1d <exec+0x12e>
      goto bad;
80100c18:	e9 b0 02 00 00       	jmp    80100ecd <exec+0x3de>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c1d:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100c23:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c29:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c2f:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100c33:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100c37:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100c3a:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c3e:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c42:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c45:	89 04 24             	mov    %eax,(%esp)
80100c48:	e8 06 6e 00 00       	call   80107a53 <loaduvm>
80100c4d:	85 c0                	test   %eax,%eax
80100c4f:	79 05                	jns    80100c56 <exec+0x167>
      goto bad;
80100c51:	e9 77 02 00 00       	jmp    80100ecd <exec+0x3de>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c56:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100c5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c5d:	83 c0 20             	add    $0x20,%eax
80100c60:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c63:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100c6a:	0f b7 c0             	movzwl %ax,%eax
80100c6d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100c70:	0f 8f 22 ff ff ff    	jg     80100b98 <exec+0xa9>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100c76:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c79:	89 04 24             	mov    %eax,(%esp)
80100c7c:	e8 4a 0e 00 00       	call   80101acb <iunlockput>
  ip = 0;
80100c81:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100c88:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c8b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100c90:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100c95:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c98:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c9b:	05 00 20 00 00       	add    $0x2000,%eax
80100ca0:	89 44 24 08          	mov    %eax,0x8(%esp)
80100ca4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ca7:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cae:	89 04 24             	mov    %eax,(%esp)
80100cb1:	e8 88 6e 00 00       	call   80107b3e <allocuvm>
80100cb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cb9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100cbd:	75 05                	jne    80100cc4 <exec+0x1d5>
    goto bad;
80100cbf:	e9 09 02 00 00       	jmp    80100ecd <exec+0x3de>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cc4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cc7:	2d 00 20 00 00       	sub    $0x2000,%eax
80100ccc:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cd0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cd3:	89 04 24             	mov    %eax,(%esp)
80100cd6:	e8 93 70 00 00       	call   80107d6e <clearpteu>
  sp = sz;
80100cdb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cde:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100ce1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100ce8:	e9 9a 00 00 00       	jmp    80100d87 <exec+0x298>
    if(argc >= MAXARG)
80100ced:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100cf1:	76 05                	jbe    80100cf8 <exec+0x209>
      goto bad;
80100cf3:	e9 d5 01 00 00       	jmp    80100ecd <exec+0x3de>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cf8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100cfb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d02:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d05:	01 d0                	add    %edx,%eax
80100d07:	8b 00                	mov    (%eax),%eax
80100d09:	89 04 24             	mov    %eax,(%esp)
80100d0c:	e8 f3 41 00 00       	call   80104f04 <strlen>
80100d11:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100d14:	29 c2                	sub    %eax,%edx
80100d16:	89 d0                	mov    %edx,%eax
80100d18:	83 e8 01             	sub    $0x1,%eax
80100d1b:	83 e0 fc             	and    $0xfffffffc,%eax
80100d1e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d2e:	01 d0                	add    %edx,%eax
80100d30:	8b 00                	mov    (%eax),%eax
80100d32:	89 04 24             	mov    %eax,(%esp)
80100d35:	e8 ca 41 00 00       	call   80104f04 <strlen>
80100d3a:	83 c0 01             	add    $0x1,%eax
80100d3d:	89 c2                	mov    %eax,%edx
80100d3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d42:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100d49:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d4c:	01 c8                	add    %ecx,%eax
80100d4e:	8b 00                	mov    (%eax),%eax
80100d50:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100d54:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d58:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d5b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d5f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d62:	89 04 24             	mov    %eax,(%esp)
80100d65:	e8 c9 71 00 00       	call   80107f33 <copyout>
80100d6a:	85 c0                	test   %eax,%eax
80100d6c:	79 05                	jns    80100d73 <exec+0x284>
      goto bad;
80100d6e:	e9 5a 01 00 00       	jmp    80100ecd <exec+0x3de>
    ustack[3+argc] = sp;
80100d73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d76:	8d 50 03             	lea    0x3(%eax),%edx
80100d79:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d7c:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d83:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100d87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d8a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d91:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d94:	01 d0                	add    %edx,%eax
80100d96:	8b 00                	mov    (%eax),%eax
80100d98:	85 c0                	test   %eax,%eax
80100d9a:	0f 85 4d ff ff ff    	jne    80100ced <exec+0x1fe>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100da0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100da3:	83 c0 03             	add    $0x3,%eax
80100da6:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100dad:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100db1:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100db8:	ff ff ff 
  ustack[1] = argc;
80100dbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dbe:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dc7:	83 c0 01             	add    $0x1,%eax
80100dca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dd1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dd4:	29 d0                	sub    %edx,%eax
80100dd6:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100ddc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ddf:	83 c0 04             	add    $0x4,%eax
80100de2:	c1 e0 02             	shl    $0x2,%eax
80100de5:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100de8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100deb:	83 c0 04             	add    $0x4,%eax
80100dee:	c1 e0 02             	shl    $0x2,%eax
80100df1:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100df5:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100dfb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100dff:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e02:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e06:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e09:	89 04 24             	mov    %eax,(%esp)
80100e0c:	e8 22 71 00 00       	call   80107f33 <copyout>
80100e11:	85 c0                	test   %eax,%eax
80100e13:	79 05                	jns    80100e1a <exec+0x32b>
    goto bad;
80100e15:	e9 b3 00 00 00       	jmp    80100ecd <exec+0x3de>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e1a:	8b 45 08             	mov    0x8(%ebp),%eax
80100e1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e23:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e26:	eb 17                	jmp    80100e3f <exec+0x350>
    if(*s == '/')
80100e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e2b:	0f b6 00             	movzbl (%eax),%eax
80100e2e:	3c 2f                	cmp    $0x2f,%al
80100e30:	75 09                	jne    80100e3b <exec+0x34c>
      last = s+1;
80100e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e35:	83 c0 01             	add    $0x1,%eax
80100e38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e3b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e42:	0f b6 00             	movzbl (%eax),%eax
80100e45:	84 c0                	test   %al,%al
80100e47:	75 df                	jne    80100e28 <exec+0x339>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e49:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e4f:	8d 50 6c             	lea    0x6c(%eax),%edx
80100e52:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100e59:	00 
80100e5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100e5d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e61:	89 14 24             	mov    %edx,(%esp)
80100e64:	e8 51 40 00 00       	call   80104eba <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e69:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e6f:	8b 40 04             	mov    0x4(%eax),%eax
80100e72:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100e75:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e7b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100e7e:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100e81:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e87:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100e8a:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100e8c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e92:	8b 40 18             	mov    0x18(%eax),%eax
80100e95:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100e9b:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100e9e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea4:	8b 40 18             	mov    0x18(%eax),%eax
80100ea7:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100eaa:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100ead:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eb3:	89 04 24             	mov    %eax,(%esp)
80100eb6:	e8 a6 69 00 00       	call   80107861 <switchuvm>
  freevm(oldpgdir);
80100ebb:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ebe:	89 04 24             	mov    %eax,(%esp)
80100ec1:	e8 0e 6e 00 00       	call   80107cd4 <freevm>
  return 0;
80100ec6:	b8 00 00 00 00       	mov    $0x0,%eax
80100ecb:	eb 27                	jmp    80100ef4 <exec+0x405>

 bad:
  if(pgdir)
80100ecd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100ed1:	74 0b                	je     80100ede <exec+0x3ef>
    freevm(pgdir);
80100ed3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ed6:	89 04 24             	mov    %eax,(%esp)
80100ed9:	e8 f6 6d 00 00       	call   80107cd4 <freevm>
  if(ip)
80100ede:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100ee2:	74 0b                	je     80100eef <exec+0x400>
    iunlockput(ip);
80100ee4:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100ee7:	89 04 24             	mov    %eax,(%esp)
80100eea:	e8 dc 0b 00 00       	call   80101acb <iunlockput>
  return -1;
80100eef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100ef4:	c9                   	leave  
80100ef5:	c3                   	ret    

80100ef6 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100ef6:	55                   	push   %ebp
80100ef7:	89 e5                	mov    %esp,%ebp
80100ef9:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100efc:	c7 44 24 04 35 80 10 	movl   $0x80108035,0x4(%esp)
80100f03:	80 
80100f04:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f0b:	e8 15 3b 00 00       	call   80104a25 <initlock>
}
80100f10:	c9                   	leave  
80100f11:	c3                   	ret    

80100f12 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f12:	55                   	push   %ebp
80100f13:	89 e5                	mov    %esp,%ebp
80100f15:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f18:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f1f:	e8 22 3b 00 00       	call   80104a46 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f24:	c7 45 f4 94 de 10 80 	movl   $0x8010de94,-0xc(%ebp)
80100f2b:	eb 29                	jmp    80100f56 <filealloc+0x44>
    if(f->ref == 0){
80100f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f30:	8b 40 04             	mov    0x4(%eax),%eax
80100f33:	85 c0                	test   %eax,%eax
80100f35:	75 1b                	jne    80100f52 <filealloc+0x40>
      f->ref = 1;
80100f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f3a:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f41:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f48:	e8 5b 3b 00 00       	call   80104aa8 <release>
      return f;
80100f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f50:	eb 1e                	jmp    80100f70 <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f52:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f56:	81 7d f4 f4 e7 10 80 	cmpl   $0x8010e7f4,-0xc(%ebp)
80100f5d:	72 ce                	jb     80100f2d <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f5f:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f66:	e8 3d 3b 00 00       	call   80104aa8 <release>
  return 0;
80100f6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100f70:	c9                   	leave  
80100f71:	c3                   	ret    

80100f72 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f72:	55                   	push   %ebp
80100f73:	89 e5                	mov    %esp,%ebp
80100f75:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100f78:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f7f:	e8 c2 3a 00 00       	call   80104a46 <acquire>
  if(f->ref < 1)
80100f84:	8b 45 08             	mov    0x8(%ebp),%eax
80100f87:	8b 40 04             	mov    0x4(%eax),%eax
80100f8a:	85 c0                	test   %eax,%eax
80100f8c:	7f 0c                	jg     80100f9a <filedup+0x28>
    panic("filedup");
80100f8e:	c7 04 24 3c 80 10 80 	movl   $0x8010803c,(%esp)
80100f95:	e8 a0 f5 ff ff       	call   8010053a <panic>
  f->ref++;
80100f9a:	8b 45 08             	mov    0x8(%ebp),%eax
80100f9d:	8b 40 04             	mov    0x4(%eax),%eax
80100fa0:	8d 50 01             	lea    0x1(%eax),%edx
80100fa3:	8b 45 08             	mov    0x8(%ebp),%eax
80100fa6:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fa9:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100fb0:	e8 f3 3a 00 00       	call   80104aa8 <release>
  return f;
80100fb5:	8b 45 08             	mov    0x8(%ebp),%eax
}
80100fb8:	c9                   	leave  
80100fb9:	c3                   	ret    

80100fba <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100fba:	55                   	push   %ebp
80100fbb:	89 e5                	mov    %esp,%ebp
80100fbd:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
80100fc0:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100fc7:	e8 7a 3a 00 00       	call   80104a46 <acquire>
  if(f->ref < 1)
80100fcc:	8b 45 08             	mov    0x8(%ebp),%eax
80100fcf:	8b 40 04             	mov    0x4(%eax),%eax
80100fd2:	85 c0                	test   %eax,%eax
80100fd4:	7f 0c                	jg     80100fe2 <fileclose+0x28>
    panic("fileclose");
80100fd6:	c7 04 24 44 80 10 80 	movl   $0x80108044,(%esp)
80100fdd:	e8 58 f5 ff ff       	call   8010053a <panic>
  if(--f->ref > 0){
80100fe2:	8b 45 08             	mov    0x8(%ebp),%eax
80100fe5:	8b 40 04             	mov    0x4(%eax),%eax
80100fe8:	8d 50 ff             	lea    -0x1(%eax),%edx
80100feb:	8b 45 08             	mov    0x8(%ebp),%eax
80100fee:	89 50 04             	mov    %edx,0x4(%eax)
80100ff1:	8b 45 08             	mov    0x8(%ebp),%eax
80100ff4:	8b 40 04             	mov    0x4(%eax),%eax
80100ff7:	85 c0                	test   %eax,%eax
80100ff9:	7e 11                	jle    8010100c <fileclose+0x52>
    release(&ftable.lock);
80100ffb:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80101002:	e8 a1 3a 00 00       	call   80104aa8 <release>
80101007:	e9 82 00 00 00       	jmp    8010108e <fileclose+0xd4>
    return;
  }
  ff = *f;
8010100c:	8b 45 08             	mov    0x8(%ebp),%eax
8010100f:	8b 10                	mov    (%eax),%edx
80101011:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101014:	8b 50 04             	mov    0x4(%eax),%edx
80101017:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010101a:	8b 50 08             	mov    0x8(%eax),%edx
8010101d:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101020:	8b 50 0c             	mov    0xc(%eax),%edx
80101023:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101026:	8b 50 10             	mov    0x10(%eax),%edx
80101029:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010102c:	8b 40 14             	mov    0x14(%eax),%eax
8010102f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101032:	8b 45 08             	mov    0x8(%ebp),%eax
80101035:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
8010103c:	8b 45 08             	mov    0x8(%ebp),%eax
8010103f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101045:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
8010104c:	e8 57 3a 00 00       	call   80104aa8 <release>
  
  if(ff.type == FD_PIPE)
80101051:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101054:	83 f8 01             	cmp    $0x1,%eax
80101057:	75 18                	jne    80101071 <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
80101059:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
8010105d:	0f be d0             	movsbl %al,%edx
80101060:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101063:	89 54 24 04          	mov    %edx,0x4(%esp)
80101067:	89 04 24             	mov    %eax,(%esp)
8010106a:	e8 73 2c 00 00       	call   80103ce2 <pipeclose>
8010106f:	eb 1d                	jmp    8010108e <fileclose+0xd4>
  else if(ff.type == FD_INODE){
80101071:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101074:	83 f8 02             	cmp    $0x2,%eax
80101077:	75 15                	jne    8010108e <fileclose+0xd4>
    begin_trans();
80101079:	e8 53 21 00 00       	call   801031d1 <begin_trans>
    iput(ff.ip);
8010107e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101081:	89 04 24             	mov    %eax,(%esp)
80101084:	e8 71 09 00 00       	call   801019fa <iput>
    commit_trans();
80101089:	e8 8c 21 00 00       	call   8010321a <commit_trans>
  }
}
8010108e:	c9                   	leave  
8010108f:	c3                   	ret    

80101090 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101090:	55                   	push   %ebp
80101091:	89 e5                	mov    %esp,%ebp
80101093:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
80101096:	8b 45 08             	mov    0x8(%ebp),%eax
80101099:	8b 00                	mov    (%eax),%eax
8010109b:	83 f8 02             	cmp    $0x2,%eax
8010109e:	75 38                	jne    801010d8 <filestat+0x48>
    ilock(f->ip);
801010a0:	8b 45 08             	mov    0x8(%ebp),%eax
801010a3:	8b 40 10             	mov    0x10(%eax),%eax
801010a6:	89 04 24             	mov    %eax,(%esp)
801010a9:	e8 99 07 00 00       	call   80101847 <ilock>
    stati(f->ip, st);
801010ae:	8b 45 08             	mov    0x8(%ebp),%eax
801010b1:	8b 40 10             	mov    0x10(%eax),%eax
801010b4:	8b 55 0c             	mov    0xc(%ebp),%edx
801010b7:	89 54 24 04          	mov    %edx,0x4(%esp)
801010bb:	89 04 24             	mov    %eax,(%esp)
801010be:	e8 4c 0c 00 00       	call   80101d0f <stati>
    iunlock(f->ip);
801010c3:	8b 45 08             	mov    0x8(%ebp),%eax
801010c6:	8b 40 10             	mov    0x10(%eax),%eax
801010c9:	89 04 24             	mov    %eax,(%esp)
801010cc:	e8 c4 08 00 00       	call   80101995 <iunlock>
    return 0;
801010d1:	b8 00 00 00 00       	mov    $0x0,%eax
801010d6:	eb 05                	jmp    801010dd <filestat+0x4d>
  }
  return -1;
801010d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010dd:	c9                   	leave  
801010de:	c3                   	ret    

801010df <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801010df:	55                   	push   %ebp
801010e0:	89 e5                	mov    %esp,%ebp
801010e2:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
801010e5:	8b 45 08             	mov    0x8(%ebp),%eax
801010e8:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801010ec:	84 c0                	test   %al,%al
801010ee:	75 0a                	jne    801010fa <fileread+0x1b>
    return -1;
801010f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801010f5:	e9 9f 00 00 00       	jmp    80101199 <fileread+0xba>
  if(f->type == FD_PIPE)
801010fa:	8b 45 08             	mov    0x8(%ebp),%eax
801010fd:	8b 00                	mov    (%eax),%eax
801010ff:	83 f8 01             	cmp    $0x1,%eax
80101102:	75 1e                	jne    80101122 <fileread+0x43>
    return piperead(f->pipe, addr, n);
80101104:	8b 45 08             	mov    0x8(%ebp),%eax
80101107:	8b 40 0c             	mov    0xc(%eax),%eax
8010110a:	8b 55 10             	mov    0x10(%ebp),%edx
8010110d:	89 54 24 08          	mov    %edx,0x8(%esp)
80101111:	8b 55 0c             	mov    0xc(%ebp),%edx
80101114:	89 54 24 04          	mov    %edx,0x4(%esp)
80101118:	89 04 24             	mov    %eax,(%esp)
8010111b:	e8 43 2d 00 00       	call   80103e63 <piperead>
80101120:	eb 77                	jmp    80101199 <fileread+0xba>
  if(f->type == FD_INODE){
80101122:	8b 45 08             	mov    0x8(%ebp),%eax
80101125:	8b 00                	mov    (%eax),%eax
80101127:	83 f8 02             	cmp    $0x2,%eax
8010112a:	75 61                	jne    8010118d <fileread+0xae>
    ilock(f->ip);
8010112c:	8b 45 08             	mov    0x8(%ebp),%eax
8010112f:	8b 40 10             	mov    0x10(%eax),%eax
80101132:	89 04 24             	mov    %eax,(%esp)
80101135:	e8 0d 07 00 00       	call   80101847 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010113a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010113d:	8b 45 08             	mov    0x8(%ebp),%eax
80101140:	8b 50 14             	mov    0x14(%eax),%edx
80101143:	8b 45 08             	mov    0x8(%ebp),%eax
80101146:	8b 40 10             	mov    0x10(%eax),%eax
80101149:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010114d:	89 54 24 08          	mov    %edx,0x8(%esp)
80101151:	8b 55 0c             	mov    0xc(%ebp),%edx
80101154:	89 54 24 04          	mov    %edx,0x4(%esp)
80101158:	89 04 24             	mov    %eax,(%esp)
8010115b:	e8 f4 0b 00 00       	call   80101d54 <readi>
80101160:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101163:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101167:	7e 11                	jle    8010117a <fileread+0x9b>
      f->off += r;
80101169:	8b 45 08             	mov    0x8(%ebp),%eax
8010116c:	8b 50 14             	mov    0x14(%eax),%edx
8010116f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101172:	01 c2                	add    %eax,%edx
80101174:	8b 45 08             	mov    0x8(%ebp),%eax
80101177:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
8010117a:	8b 45 08             	mov    0x8(%ebp),%eax
8010117d:	8b 40 10             	mov    0x10(%eax),%eax
80101180:	89 04 24             	mov    %eax,(%esp)
80101183:	e8 0d 08 00 00       	call   80101995 <iunlock>
    return r;
80101188:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010118b:	eb 0c                	jmp    80101199 <fileread+0xba>
  }
  panic("fileread");
8010118d:	c7 04 24 4e 80 10 80 	movl   $0x8010804e,(%esp)
80101194:	e8 a1 f3 ff ff       	call   8010053a <panic>
}
80101199:	c9                   	leave  
8010119a:	c3                   	ret    

8010119b <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
8010119b:	55                   	push   %ebp
8010119c:	89 e5                	mov    %esp,%ebp
8010119e:	53                   	push   %ebx
8010119f:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801011a2:	8b 45 08             	mov    0x8(%ebp),%eax
801011a5:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801011a9:	84 c0                	test   %al,%al
801011ab:	75 0a                	jne    801011b7 <filewrite+0x1c>
    return -1;
801011ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011b2:	e9 20 01 00 00       	jmp    801012d7 <filewrite+0x13c>
  if(f->type == FD_PIPE)
801011b7:	8b 45 08             	mov    0x8(%ebp),%eax
801011ba:	8b 00                	mov    (%eax),%eax
801011bc:	83 f8 01             	cmp    $0x1,%eax
801011bf:	75 21                	jne    801011e2 <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
801011c1:	8b 45 08             	mov    0x8(%ebp),%eax
801011c4:	8b 40 0c             	mov    0xc(%eax),%eax
801011c7:	8b 55 10             	mov    0x10(%ebp),%edx
801011ca:	89 54 24 08          	mov    %edx,0x8(%esp)
801011ce:	8b 55 0c             	mov    0xc(%ebp),%edx
801011d1:	89 54 24 04          	mov    %edx,0x4(%esp)
801011d5:	89 04 24             	mov    %eax,(%esp)
801011d8:	e8 97 2b 00 00       	call   80103d74 <pipewrite>
801011dd:	e9 f5 00 00 00       	jmp    801012d7 <filewrite+0x13c>
  if(f->type == FD_INODE){
801011e2:	8b 45 08             	mov    0x8(%ebp),%eax
801011e5:	8b 00                	mov    (%eax),%eax
801011e7:	83 f8 02             	cmp    $0x2,%eax
801011ea:	0f 85 db 00 00 00    	jne    801012cb <filewrite+0x130>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
801011f0:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
801011f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801011fe:	e9 a8 00 00 00       	jmp    801012ab <filewrite+0x110>
      int n1 = n - i;
80101203:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101206:	8b 55 10             	mov    0x10(%ebp),%edx
80101209:	29 c2                	sub    %eax,%edx
8010120b:	89 d0                	mov    %edx,%eax
8010120d:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101210:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101213:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101216:	7e 06                	jle    8010121e <filewrite+0x83>
        n1 = max;
80101218:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010121b:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_trans();
8010121e:	e8 ae 1f 00 00       	call   801031d1 <begin_trans>
      ilock(f->ip);
80101223:	8b 45 08             	mov    0x8(%ebp),%eax
80101226:	8b 40 10             	mov    0x10(%eax),%eax
80101229:	89 04 24             	mov    %eax,(%esp)
8010122c:	e8 16 06 00 00       	call   80101847 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101231:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101234:	8b 45 08             	mov    0x8(%ebp),%eax
80101237:	8b 50 14             	mov    0x14(%eax),%edx
8010123a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010123d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101240:	01 c3                	add    %eax,%ebx
80101242:	8b 45 08             	mov    0x8(%ebp),%eax
80101245:	8b 40 10             	mov    0x10(%eax),%eax
80101248:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010124c:	89 54 24 08          	mov    %edx,0x8(%esp)
80101250:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101254:	89 04 24             	mov    %eax,(%esp)
80101257:	e8 5c 0c 00 00       	call   80101eb8 <writei>
8010125c:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010125f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101263:	7e 11                	jle    80101276 <filewrite+0xdb>
        f->off += r;
80101265:	8b 45 08             	mov    0x8(%ebp),%eax
80101268:	8b 50 14             	mov    0x14(%eax),%edx
8010126b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010126e:	01 c2                	add    %eax,%edx
80101270:	8b 45 08             	mov    0x8(%ebp),%eax
80101273:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101276:	8b 45 08             	mov    0x8(%ebp),%eax
80101279:	8b 40 10             	mov    0x10(%eax),%eax
8010127c:	89 04 24             	mov    %eax,(%esp)
8010127f:	e8 11 07 00 00       	call   80101995 <iunlock>
      commit_trans();
80101284:	e8 91 1f 00 00       	call   8010321a <commit_trans>

      if(r < 0)
80101289:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010128d:	79 02                	jns    80101291 <filewrite+0xf6>
        break;
8010128f:	eb 26                	jmp    801012b7 <filewrite+0x11c>
      if(r != n1)
80101291:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101294:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80101297:	74 0c                	je     801012a5 <filewrite+0x10a>
        panic("short filewrite");
80101299:	c7 04 24 57 80 10 80 	movl   $0x80108057,(%esp)
801012a0:	e8 95 f2 ff ff       	call   8010053a <panic>
      i += r;
801012a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012a8:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012ae:	3b 45 10             	cmp    0x10(%ebp),%eax
801012b1:	0f 8c 4c ff ff ff    	jl     80101203 <filewrite+0x68>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801012b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012ba:	3b 45 10             	cmp    0x10(%ebp),%eax
801012bd:	75 05                	jne    801012c4 <filewrite+0x129>
801012bf:	8b 45 10             	mov    0x10(%ebp),%eax
801012c2:	eb 05                	jmp    801012c9 <filewrite+0x12e>
801012c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012c9:	eb 0c                	jmp    801012d7 <filewrite+0x13c>
  }
  panic("filewrite");
801012cb:	c7 04 24 67 80 10 80 	movl   $0x80108067,(%esp)
801012d2:	e8 63 f2 ff ff       	call   8010053a <panic>
}
801012d7:	83 c4 24             	add    $0x24,%esp
801012da:	5b                   	pop    %ebx
801012db:	5d                   	pop    %ebp
801012dc:	c3                   	ret    

801012dd <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801012dd:	55                   	push   %ebp
801012de:	89 e5                	mov    %esp,%ebp
801012e0:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
801012e3:	8b 45 08             	mov    0x8(%ebp),%eax
801012e6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801012ed:	00 
801012ee:	89 04 24             	mov    %eax,(%esp)
801012f1:	e8 b0 ee ff ff       	call   801001a6 <bread>
801012f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801012f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012fc:	83 c0 18             	add    $0x18,%eax
801012ff:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80101306:	00 
80101307:	89 44 24 04          	mov    %eax,0x4(%esp)
8010130b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010130e:	89 04 24             	mov    %eax,(%esp)
80101311:	e8 53 3a 00 00       	call   80104d69 <memmove>
  brelse(bp);
80101316:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101319:	89 04 24             	mov    %eax,(%esp)
8010131c:	e8 f6 ee ff ff       	call   80100217 <brelse>
}
80101321:	c9                   	leave  
80101322:	c3                   	ret    

80101323 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101323:	55                   	push   %ebp
80101324:	89 e5                	mov    %esp,%ebp
80101326:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101329:	8b 55 0c             	mov    0xc(%ebp),%edx
8010132c:	8b 45 08             	mov    0x8(%ebp),%eax
8010132f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101333:	89 04 24             	mov    %eax,(%esp)
80101336:	e8 6b ee ff ff       	call   801001a6 <bread>
8010133b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
8010133e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101341:	83 c0 18             	add    $0x18,%eax
80101344:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010134b:	00 
8010134c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101353:	00 
80101354:	89 04 24             	mov    %eax,(%esp)
80101357:	e8 3e 39 00 00       	call   80104c9a <memset>
  log_write(bp);
8010135c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010135f:	89 04 24             	mov    %eax,(%esp)
80101362:	e8 0b 1f 00 00       	call   80103272 <log_write>
  brelse(bp);
80101367:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010136a:	89 04 24             	mov    %eax,(%esp)
8010136d:	e8 a5 ee ff ff       	call   80100217 <brelse>
}
80101372:	c9                   	leave  
80101373:	c3                   	ret    

80101374 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101374:	55                   	push   %ebp
80101375:	89 e5                	mov    %esp,%ebp
80101377:	83 ec 38             	sub    $0x38,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
8010137a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
80101381:	8b 45 08             	mov    0x8(%ebp),%eax
80101384:	8d 55 d8             	lea    -0x28(%ebp),%edx
80101387:	89 54 24 04          	mov    %edx,0x4(%esp)
8010138b:	89 04 24             	mov    %eax,(%esp)
8010138e:	e8 4a ff ff ff       	call   801012dd <readsb>
  for(b = 0; b < sb.size; b += BPB){
80101393:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010139a:	e9 07 01 00 00       	jmp    801014a6 <balloc+0x132>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
8010139f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a2:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801013a8:	85 c0                	test   %eax,%eax
801013aa:	0f 48 c2             	cmovs  %edx,%eax
801013ad:	c1 f8 0c             	sar    $0xc,%eax
801013b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
801013b3:	c1 ea 03             	shr    $0x3,%edx
801013b6:	01 d0                	add    %edx,%eax
801013b8:	83 c0 03             	add    $0x3,%eax
801013bb:	89 44 24 04          	mov    %eax,0x4(%esp)
801013bf:	8b 45 08             	mov    0x8(%ebp),%eax
801013c2:	89 04 24             	mov    %eax,(%esp)
801013c5:	e8 dc ed ff ff       	call   801001a6 <bread>
801013ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801013d4:	e9 9d 00 00 00       	jmp    80101476 <balloc+0x102>
      m = 1 << (bi % 8);
801013d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801013dc:	99                   	cltd   
801013dd:	c1 ea 1d             	shr    $0x1d,%edx
801013e0:	01 d0                	add    %edx,%eax
801013e2:	83 e0 07             	and    $0x7,%eax
801013e5:	29 d0                	sub    %edx,%eax
801013e7:	ba 01 00 00 00       	mov    $0x1,%edx
801013ec:	89 c1                	mov    %eax,%ecx
801013ee:	d3 e2                	shl    %cl,%edx
801013f0:	89 d0                	mov    %edx,%eax
801013f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801013f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801013f8:	8d 50 07             	lea    0x7(%eax),%edx
801013fb:	85 c0                	test   %eax,%eax
801013fd:	0f 48 c2             	cmovs  %edx,%eax
80101400:	c1 f8 03             	sar    $0x3,%eax
80101403:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101406:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
8010140b:	0f b6 c0             	movzbl %al,%eax
8010140e:	23 45 e8             	and    -0x18(%ebp),%eax
80101411:	85 c0                	test   %eax,%eax
80101413:	75 5d                	jne    80101472 <balloc+0xfe>
        bp->data[bi/8] |= m;  // Mark block in use.
80101415:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101418:	8d 50 07             	lea    0x7(%eax),%edx
8010141b:	85 c0                	test   %eax,%eax
8010141d:	0f 48 c2             	cmovs  %edx,%eax
80101420:	c1 f8 03             	sar    $0x3,%eax
80101423:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101426:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010142b:	89 d1                	mov    %edx,%ecx
8010142d:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101430:	09 ca                	or     %ecx,%edx
80101432:	89 d1                	mov    %edx,%ecx
80101434:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101437:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
8010143b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010143e:	89 04 24             	mov    %eax,(%esp)
80101441:	e8 2c 1e 00 00       	call   80103272 <log_write>
        brelse(bp);
80101446:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101449:	89 04 24             	mov    %eax,(%esp)
8010144c:	e8 c6 ed ff ff       	call   80100217 <brelse>
        bzero(dev, b + bi);
80101451:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101454:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101457:	01 c2                	add    %eax,%edx
80101459:	8b 45 08             	mov    0x8(%ebp),%eax
8010145c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101460:	89 04 24             	mov    %eax,(%esp)
80101463:	e8 bb fe ff ff       	call   80101323 <bzero>
        return b + bi;
80101468:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010146b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010146e:	01 d0                	add    %edx,%eax
80101470:	eb 4e                	jmp    801014c0 <balloc+0x14c>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101472:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101476:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
8010147d:	7f 15                	jg     80101494 <balloc+0x120>
8010147f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101482:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101485:	01 d0                	add    %edx,%eax
80101487:	89 c2                	mov    %eax,%edx
80101489:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010148c:	39 c2                	cmp    %eax,%edx
8010148e:	0f 82 45 ff ff ff    	jb     801013d9 <balloc+0x65>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101494:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101497:	89 04 24             	mov    %eax,(%esp)
8010149a:	e8 78 ed ff ff       	call   80100217 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
8010149f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801014a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014ac:	39 c2                	cmp    %eax,%edx
801014ae:	0f 82 eb fe ff ff    	jb     8010139f <balloc+0x2b>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801014b4:	c7 04 24 71 80 10 80 	movl   $0x80108071,(%esp)
801014bb:	e8 7a f0 ff ff       	call   8010053a <panic>
}
801014c0:	c9                   	leave  
801014c1:	c3                   	ret    

801014c2 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014c2:	55                   	push   %ebp
801014c3:	89 e5                	mov    %esp,%ebp
801014c5:	83 ec 38             	sub    $0x38,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
801014c8:	8d 45 dc             	lea    -0x24(%ebp),%eax
801014cb:	89 44 24 04          	mov    %eax,0x4(%esp)
801014cf:	8b 45 08             	mov    0x8(%ebp),%eax
801014d2:	89 04 24             	mov    %eax,(%esp)
801014d5:	e8 03 fe ff ff       	call   801012dd <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
801014da:	8b 45 0c             	mov    0xc(%ebp),%eax
801014dd:	c1 e8 0c             	shr    $0xc,%eax
801014e0:	89 c2                	mov    %eax,%edx
801014e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801014e5:	c1 e8 03             	shr    $0x3,%eax
801014e8:	01 d0                	add    %edx,%eax
801014ea:	8d 50 03             	lea    0x3(%eax),%edx
801014ed:	8b 45 08             	mov    0x8(%ebp),%eax
801014f0:	89 54 24 04          	mov    %edx,0x4(%esp)
801014f4:	89 04 24             	mov    %eax,(%esp)
801014f7:	e8 aa ec ff ff       	call   801001a6 <bread>
801014fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801014ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80101502:	25 ff 0f 00 00       	and    $0xfff,%eax
80101507:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010150a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010150d:	99                   	cltd   
8010150e:	c1 ea 1d             	shr    $0x1d,%edx
80101511:	01 d0                	add    %edx,%eax
80101513:	83 e0 07             	and    $0x7,%eax
80101516:	29 d0                	sub    %edx,%eax
80101518:	ba 01 00 00 00       	mov    $0x1,%edx
8010151d:	89 c1                	mov    %eax,%ecx
8010151f:	d3 e2                	shl    %cl,%edx
80101521:	89 d0                	mov    %edx,%eax
80101523:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101526:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101529:	8d 50 07             	lea    0x7(%eax),%edx
8010152c:	85 c0                	test   %eax,%eax
8010152e:	0f 48 c2             	cmovs  %edx,%eax
80101531:	c1 f8 03             	sar    $0x3,%eax
80101534:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101537:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
8010153c:	0f b6 c0             	movzbl %al,%eax
8010153f:	23 45 ec             	and    -0x14(%ebp),%eax
80101542:	85 c0                	test   %eax,%eax
80101544:	75 0c                	jne    80101552 <bfree+0x90>
    panic("freeing free block");
80101546:	c7 04 24 87 80 10 80 	movl   $0x80108087,(%esp)
8010154d:	e8 e8 ef ff ff       	call   8010053a <panic>
  bp->data[bi/8] &= ~m;
80101552:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101555:	8d 50 07             	lea    0x7(%eax),%edx
80101558:	85 c0                	test   %eax,%eax
8010155a:	0f 48 c2             	cmovs  %edx,%eax
8010155d:	c1 f8 03             	sar    $0x3,%eax
80101560:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101563:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101568:	8b 4d ec             	mov    -0x14(%ebp),%ecx
8010156b:	f7 d1                	not    %ecx
8010156d:	21 ca                	and    %ecx,%edx
8010156f:	89 d1                	mov    %edx,%ecx
80101571:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101574:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
80101578:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010157b:	89 04 24             	mov    %eax,(%esp)
8010157e:	e8 ef 1c 00 00       	call   80103272 <log_write>
  brelse(bp);
80101583:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101586:	89 04 24             	mov    %eax,(%esp)
80101589:	e8 89 ec ff ff       	call   80100217 <brelse>
}
8010158e:	c9                   	leave  
8010158f:	c3                   	ret    

80101590 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
80101590:	55                   	push   %ebp
80101591:	89 e5                	mov    %esp,%ebp
80101593:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
80101596:	c7 44 24 04 9a 80 10 	movl   $0x8010809a,0x4(%esp)
8010159d:	80 
8010159e:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801015a5:	e8 7b 34 00 00       	call   80104a25 <initlock>
}
801015aa:	c9                   	leave  
801015ab:	c3                   	ret    

801015ac <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801015ac:	55                   	push   %ebp
801015ad:	89 e5                	mov    %esp,%ebp
801015af:	83 ec 38             	sub    $0x38,%esp
801015b2:	8b 45 0c             	mov    0xc(%ebp),%eax
801015b5:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
801015b9:	8b 45 08             	mov    0x8(%ebp),%eax
801015bc:	8d 55 dc             	lea    -0x24(%ebp),%edx
801015bf:	89 54 24 04          	mov    %edx,0x4(%esp)
801015c3:	89 04 24             	mov    %eax,(%esp)
801015c6:	e8 12 fd ff ff       	call   801012dd <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
801015cb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801015d2:	e9 98 00 00 00       	jmp    8010166f <ialloc+0xc3>
    bp = bread(dev, IBLOCK(inum));
801015d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015da:	c1 e8 03             	shr    $0x3,%eax
801015dd:	83 c0 02             	add    $0x2,%eax
801015e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801015e4:	8b 45 08             	mov    0x8(%ebp),%eax
801015e7:	89 04 24             	mov    %eax,(%esp)
801015ea:	e8 b7 eb ff ff       	call   801001a6 <bread>
801015ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801015f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015f5:	8d 50 18             	lea    0x18(%eax),%edx
801015f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015fb:	83 e0 07             	and    $0x7,%eax
801015fe:	c1 e0 06             	shl    $0x6,%eax
80101601:	01 d0                	add    %edx,%eax
80101603:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101606:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101609:	0f b7 00             	movzwl (%eax),%eax
8010160c:	66 85 c0             	test   %ax,%ax
8010160f:	75 4f                	jne    80101660 <ialloc+0xb4>
      memset(dip, 0, sizeof(*dip));
80101611:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
80101618:	00 
80101619:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101620:	00 
80101621:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101624:	89 04 24             	mov    %eax,(%esp)
80101627:	e8 6e 36 00 00       	call   80104c9a <memset>
      dip->type = type;
8010162c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010162f:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
80101633:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101636:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101639:	89 04 24             	mov    %eax,(%esp)
8010163c:	e8 31 1c 00 00       	call   80103272 <log_write>
      brelse(bp);
80101641:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101644:	89 04 24             	mov    %eax,(%esp)
80101647:	e8 cb eb ff ff       	call   80100217 <brelse>
      return iget(dev, inum);
8010164c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010164f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101653:	8b 45 08             	mov    0x8(%ebp),%eax
80101656:	89 04 24             	mov    %eax,(%esp)
80101659:	e8 e5 00 00 00       	call   80101743 <iget>
8010165e:	eb 29                	jmp    80101689 <ialloc+0xdd>
    }
    brelse(bp);
80101660:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101663:	89 04 24             	mov    %eax,(%esp)
80101666:	e8 ac eb ff ff       	call   80100217 <brelse>
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
8010166b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010166f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101672:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101675:	39 c2                	cmp    %eax,%edx
80101677:	0f 82 5a ff ff ff    	jb     801015d7 <ialloc+0x2b>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
8010167d:	c7 04 24 a1 80 10 80 	movl   $0x801080a1,(%esp)
80101684:	e8 b1 ee ff ff       	call   8010053a <panic>
}
80101689:	c9                   	leave  
8010168a:	c3                   	ret    

8010168b <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
8010168b:	55                   	push   %ebp
8010168c:	89 e5                	mov    %esp,%ebp
8010168e:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
80101691:	8b 45 08             	mov    0x8(%ebp),%eax
80101694:	8b 40 04             	mov    0x4(%eax),%eax
80101697:	c1 e8 03             	shr    $0x3,%eax
8010169a:	8d 50 02             	lea    0x2(%eax),%edx
8010169d:	8b 45 08             	mov    0x8(%ebp),%eax
801016a0:	8b 00                	mov    (%eax),%eax
801016a2:	89 54 24 04          	mov    %edx,0x4(%esp)
801016a6:	89 04 24             	mov    %eax,(%esp)
801016a9:	e8 f8 ea ff ff       	call   801001a6 <bread>
801016ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016b4:	8d 50 18             	lea    0x18(%eax),%edx
801016b7:	8b 45 08             	mov    0x8(%ebp),%eax
801016ba:	8b 40 04             	mov    0x4(%eax),%eax
801016bd:	83 e0 07             	and    $0x7,%eax
801016c0:	c1 e0 06             	shl    $0x6,%eax
801016c3:	01 d0                	add    %edx,%eax
801016c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801016c8:	8b 45 08             	mov    0x8(%ebp),%eax
801016cb:	0f b7 50 10          	movzwl 0x10(%eax),%edx
801016cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016d2:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016d5:	8b 45 08             	mov    0x8(%ebp),%eax
801016d8:	0f b7 50 12          	movzwl 0x12(%eax),%edx
801016dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016df:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801016e3:	8b 45 08             	mov    0x8(%ebp),%eax
801016e6:	0f b7 50 14          	movzwl 0x14(%eax),%edx
801016ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016ed:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801016f1:	8b 45 08             	mov    0x8(%ebp),%eax
801016f4:	0f b7 50 16          	movzwl 0x16(%eax),%edx
801016f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016fb:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801016ff:	8b 45 08             	mov    0x8(%ebp),%eax
80101702:	8b 50 18             	mov    0x18(%eax),%edx
80101705:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101708:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010170b:	8b 45 08             	mov    0x8(%ebp),%eax
8010170e:	8d 50 1c             	lea    0x1c(%eax),%edx
80101711:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101714:	83 c0 0c             	add    $0xc,%eax
80101717:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010171e:	00 
8010171f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101723:	89 04 24             	mov    %eax,(%esp)
80101726:	e8 3e 36 00 00       	call   80104d69 <memmove>
  log_write(bp);
8010172b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010172e:	89 04 24             	mov    %eax,(%esp)
80101731:	e8 3c 1b 00 00       	call   80103272 <log_write>
  brelse(bp);
80101736:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101739:	89 04 24             	mov    %eax,(%esp)
8010173c:	e8 d6 ea ff ff       	call   80100217 <brelse>
}
80101741:	c9                   	leave  
80101742:	c3                   	ret    

80101743 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101743:	55                   	push   %ebp
80101744:	89 e5                	mov    %esp,%ebp
80101746:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101749:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101750:	e8 f1 32 00 00       	call   80104a46 <acquire>

  // Is the inode already cached?
  empty = 0;
80101755:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010175c:	c7 45 f4 94 e8 10 80 	movl   $0x8010e894,-0xc(%ebp)
80101763:	eb 59                	jmp    801017be <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101765:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101768:	8b 40 08             	mov    0x8(%eax),%eax
8010176b:	85 c0                	test   %eax,%eax
8010176d:	7e 35                	jle    801017a4 <iget+0x61>
8010176f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101772:	8b 00                	mov    (%eax),%eax
80101774:	3b 45 08             	cmp    0x8(%ebp),%eax
80101777:	75 2b                	jne    801017a4 <iget+0x61>
80101779:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010177c:	8b 40 04             	mov    0x4(%eax),%eax
8010177f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101782:	75 20                	jne    801017a4 <iget+0x61>
      ip->ref++;
80101784:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101787:	8b 40 08             	mov    0x8(%eax),%eax
8010178a:	8d 50 01             	lea    0x1(%eax),%edx
8010178d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101790:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101793:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
8010179a:	e8 09 33 00 00       	call   80104aa8 <release>
      return ip;
8010179f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017a2:	eb 6f                	jmp    80101813 <iget+0xd0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801017a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017a8:	75 10                	jne    801017ba <iget+0x77>
801017aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ad:	8b 40 08             	mov    0x8(%eax),%eax
801017b0:	85 c0                	test   %eax,%eax
801017b2:	75 06                	jne    801017ba <iget+0x77>
      empty = ip;
801017b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017b7:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017ba:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
801017be:	81 7d f4 34 f8 10 80 	cmpl   $0x8010f834,-0xc(%ebp)
801017c5:	72 9e                	jb     80101765 <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801017c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017cb:	75 0c                	jne    801017d9 <iget+0x96>
    panic("iget: no inodes");
801017cd:	c7 04 24 b3 80 10 80 	movl   $0x801080b3,(%esp)
801017d4:	e8 61 ed ff ff       	call   8010053a <panic>

  ip = empty;
801017d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
801017df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017e2:	8b 55 08             	mov    0x8(%ebp),%edx
801017e5:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801017e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ea:	8b 55 0c             	mov    0xc(%ebp),%edx
801017ed:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801017f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
801017fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017fd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101804:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
8010180b:	e8 98 32 00 00       	call   80104aa8 <release>

  return ip;
80101810:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101813:	c9                   	leave  
80101814:	c3                   	ret    

80101815 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101815:	55                   	push   %ebp
80101816:	89 e5                	mov    %esp,%ebp
80101818:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
8010181b:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101822:	e8 1f 32 00 00       	call   80104a46 <acquire>
  ip->ref++;
80101827:	8b 45 08             	mov    0x8(%ebp),%eax
8010182a:	8b 40 08             	mov    0x8(%eax),%eax
8010182d:	8d 50 01             	lea    0x1(%eax),%edx
80101830:	8b 45 08             	mov    0x8(%ebp),%eax
80101833:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101836:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
8010183d:	e8 66 32 00 00       	call   80104aa8 <release>
  return ip;
80101842:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101845:	c9                   	leave  
80101846:	c3                   	ret    

80101847 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101847:	55                   	push   %ebp
80101848:	89 e5                	mov    %esp,%ebp
8010184a:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
8010184d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101851:	74 0a                	je     8010185d <ilock+0x16>
80101853:	8b 45 08             	mov    0x8(%ebp),%eax
80101856:	8b 40 08             	mov    0x8(%eax),%eax
80101859:	85 c0                	test   %eax,%eax
8010185b:	7f 0c                	jg     80101869 <ilock+0x22>
    panic("ilock");
8010185d:	c7 04 24 c3 80 10 80 	movl   $0x801080c3,(%esp)
80101864:	e8 d1 ec ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
80101869:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101870:	e8 d1 31 00 00       	call   80104a46 <acquire>
  while(ip->flags & I_BUSY)
80101875:	eb 13                	jmp    8010188a <ilock+0x43>
    sleep(ip, &icache.lock);
80101877:	c7 44 24 04 60 e8 10 	movl   $0x8010e860,0x4(%esp)
8010187e:	80 
8010187f:	8b 45 08             	mov    0x8(%ebp),%eax
80101882:	89 04 24             	mov    %eax,(%esp)
80101885:	e8 f2 2e 00 00       	call   8010477c <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
8010188a:	8b 45 08             	mov    0x8(%ebp),%eax
8010188d:	8b 40 0c             	mov    0xc(%eax),%eax
80101890:	83 e0 01             	and    $0x1,%eax
80101893:	85 c0                	test   %eax,%eax
80101895:	75 e0                	jne    80101877 <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101897:	8b 45 08             	mov    0x8(%ebp),%eax
8010189a:	8b 40 0c             	mov    0xc(%eax),%eax
8010189d:	83 c8 01             	or     $0x1,%eax
801018a0:	89 c2                	mov    %eax,%edx
801018a2:	8b 45 08             	mov    0x8(%ebp),%eax
801018a5:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
801018a8:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801018af:	e8 f4 31 00 00       	call   80104aa8 <release>

  if(!(ip->flags & I_VALID)){
801018b4:	8b 45 08             	mov    0x8(%ebp),%eax
801018b7:	8b 40 0c             	mov    0xc(%eax),%eax
801018ba:	83 e0 02             	and    $0x2,%eax
801018bd:	85 c0                	test   %eax,%eax
801018bf:	0f 85 ce 00 00 00    	jne    80101993 <ilock+0x14c>
    bp = bread(ip->dev, IBLOCK(ip->inum));
801018c5:	8b 45 08             	mov    0x8(%ebp),%eax
801018c8:	8b 40 04             	mov    0x4(%eax),%eax
801018cb:	c1 e8 03             	shr    $0x3,%eax
801018ce:	8d 50 02             	lea    0x2(%eax),%edx
801018d1:	8b 45 08             	mov    0x8(%ebp),%eax
801018d4:	8b 00                	mov    (%eax),%eax
801018d6:	89 54 24 04          	mov    %edx,0x4(%esp)
801018da:	89 04 24             	mov    %eax,(%esp)
801018dd:	e8 c4 e8 ff ff       	call   801001a6 <bread>
801018e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801018e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018e8:	8d 50 18             	lea    0x18(%eax),%edx
801018eb:	8b 45 08             	mov    0x8(%ebp),%eax
801018ee:	8b 40 04             	mov    0x4(%eax),%eax
801018f1:	83 e0 07             	and    $0x7,%eax
801018f4:	c1 e0 06             	shl    $0x6,%eax
801018f7:	01 d0                	add    %edx,%eax
801018f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
801018fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018ff:	0f b7 10             	movzwl (%eax),%edx
80101902:	8b 45 08             	mov    0x8(%ebp),%eax
80101905:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101909:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010190c:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101910:	8b 45 08             	mov    0x8(%ebp),%eax
80101913:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101917:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010191a:	0f b7 50 04          	movzwl 0x4(%eax),%edx
8010191e:	8b 45 08             	mov    0x8(%ebp),%eax
80101921:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101925:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101928:	0f b7 50 06          	movzwl 0x6(%eax),%edx
8010192c:	8b 45 08             	mov    0x8(%ebp),%eax
8010192f:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101933:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101936:	8b 50 08             	mov    0x8(%eax),%edx
80101939:	8b 45 08             	mov    0x8(%ebp),%eax
8010193c:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010193f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101942:	8d 50 0c             	lea    0xc(%eax),%edx
80101945:	8b 45 08             	mov    0x8(%ebp),%eax
80101948:	83 c0 1c             	add    $0x1c,%eax
8010194b:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101952:	00 
80101953:	89 54 24 04          	mov    %edx,0x4(%esp)
80101957:	89 04 24             	mov    %eax,(%esp)
8010195a:	e8 0a 34 00 00       	call   80104d69 <memmove>
    brelse(bp);
8010195f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101962:	89 04 24             	mov    %eax,(%esp)
80101965:	e8 ad e8 ff ff       	call   80100217 <brelse>
    ip->flags |= I_VALID;
8010196a:	8b 45 08             	mov    0x8(%ebp),%eax
8010196d:	8b 40 0c             	mov    0xc(%eax),%eax
80101970:	83 c8 02             	or     $0x2,%eax
80101973:	89 c2                	mov    %eax,%edx
80101975:	8b 45 08             	mov    0x8(%ebp),%eax
80101978:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
8010197b:	8b 45 08             	mov    0x8(%ebp),%eax
8010197e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101982:	66 85 c0             	test   %ax,%ax
80101985:	75 0c                	jne    80101993 <ilock+0x14c>
      panic("ilock: no type");
80101987:	c7 04 24 c9 80 10 80 	movl   $0x801080c9,(%esp)
8010198e:	e8 a7 eb ff ff       	call   8010053a <panic>
  }
}
80101993:	c9                   	leave  
80101994:	c3                   	ret    

80101995 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101995:	55                   	push   %ebp
80101996:	89 e5                	mov    %esp,%ebp
80101998:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
8010199b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010199f:	74 17                	je     801019b8 <iunlock+0x23>
801019a1:	8b 45 08             	mov    0x8(%ebp),%eax
801019a4:	8b 40 0c             	mov    0xc(%eax),%eax
801019a7:	83 e0 01             	and    $0x1,%eax
801019aa:	85 c0                	test   %eax,%eax
801019ac:	74 0a                	je     801019b8 <iunlock+0x23>
801019ae:	8b 45 08             	mov    0x8(%ebp),%eax
801019b1:	8b 40 08             	mov    0x8(%eax),%eax
801019b4:	85 c0                	test   %eax,%eax
801019b6:	7f 0c                	jg     801019c4 <iunlock+0x2f>
    panic("iunlock");
801019b8:	c7 04 24 d8 80 10 80 	movl   $0x801080d8,(%esp)
801019bf:	e8 76 eb ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
801019c4:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801019cb:	e8 76 30 00 00       	call   80104a46 <acquire>
  ip->flags &= ~I_BUSY;
801019d0:	8b 45 08             	mov    0x8(%ebp),%eax
801019d3:	8b 40 0c             	mov    0xc(%eax),%eax
801019d6:	83 e0 fe             	and    $0xfffffffe,%eax
801019d9:	89 c2                	mov    %eax,%edx
801019db:	8b 45 08             	mov    0x8(%ebp),%eax
801019de:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
801019e1:	8b 45 08             	mov    0x8(%ebp),%eax
801019e4:	89 04 24             	mov    %eax,(%esp)
801019e7:	e8 69 2e 00 00       	call   80104855 <wakeup>
  release(&icache.lock);
801019ec:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801019f3:	e8 b0 30 00 00       	call   80104aa8 <release>
}
801019f8:	c9                   	leave  
801019f9:	c3                   	ret    

801019fa <iput>:
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
void
iput(struct inode *ip)
{
801019fa:	55                   	push   %ebp
801019fb:	89 e5                	mov    %esp,%ebp
801019fd:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101a00:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a07:	e8 3a 30 00 00       	call   80104a46 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101a0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a0f:	8b 40 08             	mov    0x8(%eax),%eax
80101a12:	83 f8 01             	cmp    $0x1,%eax
80101a15:	0f 85 93 00 00 00    	jne    80101aae <iput+0xb4>
80101a1b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a1e:	8b 40 0c             	mov    0xc(%eax),%eax
80101a21:	83 e0 02             	and    $0x2,%eax
80101a24:	85 c0                	test   %eax,%eax
80101a26:	0f 84 82 00 00 00    	je     80101aae <iput+0xb4>
80101a2c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a2f:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101a33:	66 85 c0             	test   %ax,%ax
80101a36:	75 76                	jne    80101aae <iput+0xb4>
    // inode has no links: truncate and free inode.
    if(ip->flags & I_BUSY)
80101a38:	8b 45 08             	mov    0x8(%ebp),%eax
80101a3b:	8b 40 0c             	mov    0xc(%eax),%eax
80101a3e:	83 e0 01             	and    $0x1,%eax
80101a41:	85 c0                	test   %eax,%eax
80101a43:	74 0c                	je     80101a51 <iput+0x57>
      panic("iput busy");
80101a45:	c7 04 24 e0 80 10 80 	movl   $0x801080e0,(%esp)
80101a4c:	e8 e9 ea ff ff       	call   8010053a <panic>
    ip->flags |= I_BUSY;
80101a51:	8b 45 08             	mov    0x8(%ebp),%eax
80101a54:	8b 40 0c             	mov    0xc(%eax),%eax
80101a57:	83 c8 01             	or     $0x1,%eax
80101a5a:	89 c2                	mov    %eax,%edx
80101a5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5f:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101a62:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a69:	e8 3a 30 00 00       	call   80104aa8 <release>
    itrunc(ip);
80101a6e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a71:	89 04 24             	mov    %eax,(%esp)
80101a74:	e8 7d 01 00 00       	call   80101bf6 <itrunc>
    ip->type = 0;
80101a79:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7c:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101a82:	8b 45 08             	mov    0x8(%ebp),%eax
80101a85:	89 04 24             	mov    %eax,(%esp)
80101a88:	e8 fe fb ff ff       	call   8010168b <iupdate>
    acquire(&icache.lock);
80101a8d:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a94:	e8 ad 2f 00 00       	call   80104a46 <acquire>
    ip->flags = 0;
80101a99:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101aa3:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa6:	89 04 24             	mov    %eax,(%esp)
80101aa9:	e8 a7 2d 00 00       	call   80104855 <wakeup>
  }
  ip->ref--;
80101aae:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab1:	8b 40 08             	mov    0x8(%eax),%eax
80101ab4:	8d 50 ff             	lea    -0x1(%eax),%edx
80101ab7:	8b 45 08             	mov    0x8(%ebp),%eax
80101aba:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101abd:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101ac4:	e8 df 2f 00 00       	call   80104aa8 <release>
}
80101ac9:	c9                   	leave  
80101aca:	c3                   	ret    

80101acb <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101acb:	55                   	push   %ebp
80101acc:	89 e5                	mov    %esp,%ebp
80101ace:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101ad1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad4:	89 04 24             	mov    %eax,(%esp)
80101ad7:	e8 b9 fe ff ff       	call   80101995 <iunlock>
  iput(ip);
80101adc:	8b 45 08             	mov    0x8(%ebp),%eax
80101adf:	89 04 24             	mov    %eax,(%esp)
80101ae2:	e8 13 ff ff ff       	call   801019fa <iput>
}
80101ae7:	c9                   	leave  
80101ae8:	c3                   	ret    

80101ae9 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101ae9:	55                   	push   %ebp
80101aea:	89 e5                	mov    %esp,%ebp
80101aec:	53                   	push   %ebx
80101aed:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101af0:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101af4:	77 3e                	ja     80101b34 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101af6:	8b 45 08             	mov    0x8(%ebp),%eax
80101af9:	8b 55 0c             	mov    0xc(%ebp),%edx
80101afc:	83 c2 04             	add    $0x4,%edx
80101aff:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b03:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b0a:	75 20                	jne    80101b2c <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0f:	8b 00                	mov    (%eax),%eax
80101b11:	89 04 24             	mov    %eax,(%esp)
80101b14:	e8 5b f8 ff ff       	call   80101374 <balloc>
80101b19:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b22:	8d 4a 04             	lea    0x4(%edx),%ecx
80101b25:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b28:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b2f:	e9 bc 00 00 00       	jmp    80101bf0 <bmap+0x107>
  }
  bn -= NDIRECT;
80101b34:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101b38:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101b3c:	0f 87 a2 00 00 00    	ja     80101be4 <bmap+0xfb>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101b42:	8b 45 08             	mov    0x8(%ebp),%eax
80101b45:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b48:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b4f:	75 19                	jne    80101b6a <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101b51:	8b 45 08             	mov    0x8(%ebp),%eax
80101b54:	8b 00                	mov    (%eax),%eax
80101b56:	89 04 24             	mov    %eax,(%esp)
80101b59:	e8 16 f8 ff ff       	call   80101374 <balloc>
80101b5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b61:	8b 45 08             	mov    0x8(%ebp),%eax
80101b64:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b67:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101b6a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6d:	8b 00                	mov    (%eax),%eax
80101b6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b72:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b76:	89 04 24             	mov    %eax,(%esp)
80101b79:	e8 28 e6 ff ff       	call   801001a6 <bread>
80101b7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101b81:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b84:	83 c0 18             	add    $0x18,%eax
80101b87:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101b8a:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b8d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101b94:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101b97:	01 d0                	add    %edx,%eax
80101b99:	8b 00                	mov    (%eax),%eax
80101b9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101ba2:	75 30                	jne    80101bd4 <bmap+0xeb>
      a[bn] = addr = balloc(ip->dev);
80101ba4:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ba7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101bae:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101bb1:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101bb4:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb7:	8b 00                	mov    (%eax),%eax
80101bb9:	89 04 24             	mov    %eax,(%esp)
80101bbc:	e8 b3 f7 ff ff       	call   80101374 <balloc>
80101bc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bc7:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bcc:	89 04 24             	mov    %eax,(%esp)
80101bcf:	e8 9e 16 00 00       	call   80103272 <log_write>
    }
    brelse(bp);
80101bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bd7:	89 04 24             	mov    %eax,(%esp)
80101bda:	e8 38 e6 ff ff       	call   80100217 <brelse>
    return addr;
80101bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101be2:	eb 0c                	jmp    80101bf0 <bmap+0x107>
  }

  panic("bmap: out of range");
80101be4:	c7 04 24 ea 80 10 80 	movl   $0x801080ea,(%esp)
80101beb:	e8 4a e9 ff ff       	call   8010053a <panic>
}
80101bf0:	83 c4 24             	add    $0x24,%esp
80101bf3:	5b                   	pop    %ebx
80101bf4:	5d                   	pop    %ebp
80101bf5:	c3                   	ret    

80101bf6 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101bf6:	55                   	push   %ebp
80101bf7:	89 e5                	mov    %esp,%ebp
80101bf9:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101bfc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101c03:	eb 44                	jmp    80101c49 <itrunc+0x53>
    if(ip->addrs[i]){
80101c05:	8b 45 08             	mov    0x8(%ebp),%eax
80101c08:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c0b:	83 c2 04             	add    $0x4,%edx
80101c0e:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c12:	85 c0                	test   %eax,%eax
80101c14:	74 2f                	je     80101c45 <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101c16:	8b 45 08             	mov    0x8(%ebp),%eax
80101c19:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c1c:	83 c2 04             	add    $0x4,%edx
80101c1f:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101c23:	8b 45 08             	mov    0x8(%ebp),%eax
80101c26:	8b 00                	mov    (%eax),%eax
80101c28:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c2c:	89 04 24             	mov    %eax,(%esp)
80101c2f:	e8 8e f8 ff ff       	call   801014c2 <bfree>
      ip->addrs[i] = 0;
80101c34:	8b 45 08             	mov    0x8(%ebp),%eax
80101c37:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c3a:	83 c2 04             	add    $0x4,%edx
80101c3d:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101c44:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c45:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101c49:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101c4d:	7e b6                	jle    80101c05 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101c4f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c52:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c55:	85 c0                	test   %eax,%eax
80101c57:	0f 84 9b 00 00 00    	je     80101cf8 <itrunc+0x102>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101c5d:	8b 45 08             	mov    0x8(%ebp),%eax
80101c60:	8b 50 4c             	mov    0x4c(%eax),%edx
80101c63:	8b 45 08             	mov    0x8(%ebp),%eax
80101c66:	8b 00                	mov    (%eax),%eax
80101c68:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c6c:	89 04 24             	mov    %eax,(%esp)
80101c6f:	e8 32 e5 ff ff       	call   801001a6 <bread>
80101c74:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101c77:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c7a:	83 c0 18             	add    $0x18,%eax
80101c7d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101c80:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101c87:	eb 3b                	jmp    80101cc4 <itrunc+0xce>
      if(a[j])
80101c89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c8c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c93:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101c96:	01 d0                	add    %edx,%eax
80101c98:	8b 00                	mov    (%eax),%eax
80101c9a:	85 c0                	test   %eax,%eax
80101c9c:	74 22                	je     80101cc0 <itrunc+0xca>
        bfree(ip->dev, a[j]);
80101c9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ca1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ca8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101cab:	01 d0                	add    %edx,%eax
80101cad:	8b 10                	mov    (%eax),%edx
80101caf:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb2:	8b 00                	mov    (%eax),%eax
80101cb4:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cb8:	89 04 24             	mov    %eax,(%esp)
80101cbb:	e8 02 f8 ff ff       	call   801014c2 <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101cc0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101cc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cc7:	83 f8 7f             	cmp    $0x7f,%eax
80101cca:	76 bd                	jbe    80101c89 <itrunc+0x93>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101ccc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ccf:	89 04 24             	mov    %eax,(%esp)
80101cd2:	e8 40 e5 ff ff       	call   80100217 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80101cda:	8b 50 4c             	mov    0x4c(%eax),%edx
80101cdd:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce0:	8b 00                	mov    (%eax),%eax
80101ce2:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ce6:	89 04 24             	mov    %eax,(%esp)
80101ce9:	e8 d4 f7 ff ff       	call   801014c2 <bfree>
    ip->addrs[NDIRECT] = 0;
80101cee:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf1:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101cf8:	8b 45 08             	mov    0x8(%ebp),%eax
80101cfb:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101d02:	8b 45 08             	mov    0x8(%ebp),%eax
80101d05:	89 04 24             	mov    %eax,(%esp)
80101d08:	e8 7e f9 ff ff       	call   8010168b <iupdate>
}
80101d0d:	c9                   	leave  
80101d0e:	c3                   	ret    

80101d0f <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101d0f:	55                   	push   %ebp
80101d10:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101d12:	8b 45 08             	mov    0x8(%ebp),%eax
80101d15:	8b 00                	mov    (%eax),%eax
80101d17:	89 c2                	mov    %eax,%edx
80101d19:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d1c:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101d1f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d22:	8b 50 04             	mov    0x4(%eax),%edx
80101d25:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d28:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101d2b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2e:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101d32:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d35:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101d38:	8b 45 08             	mov    0x8(%ebp),%eax
80101d3b:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101d3f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d42:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101d46:	8b 45 08             	mov    0x8(%ebp),%eax
80101d49:	8b 50 18             	mov    0x18(%eax),%edx
80101d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d4f:	89 50 10             	mov    %edx,0x10(%eax)
}
80101d52:	5d                   	pop    %ebp
80101d53:	c3                   	ret    

80101d54 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101d54:	55                   	push   %ebp
80101d55:	89 e5                	mov    %esp,%ebp
80101d57:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d5a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d5d:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101d61:	66 83 f8 03          	cmp    $0x3,%ax
80101d65:	75 60                	jne    80101dc7 <readi+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101d67:	8b 45 08             	mov    0x8(%ebp),%eax
80101d6a:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d6e:	66 85 c0             	test   %ax,%ax
80101d71:	78 20                	js     80101d93 <readi+0x3f>
80101d73:	8b 45 08             	mov    0x8(%ebp),%eax
80101d76:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d7a:	66 83 f8 09          	cmp    $0x9,%ax
80101d7e:	7f 13                	jg     80101d93 <readi+0x3f>
80101d80:	8b 45 08             	mov    0x8(%ebp),%eax
80101d83:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d87:	98                   	cwtl   
80101d88:	8b 04 c5 00 e8 10 80 	mov    -0x7fef1800(,%eax,8),%eax
80101d8f:	85 c0                	test   %eax,%eax
80101d91:	75 0a                	jne    80101d9d <readi+0x49>
      return -1;
80101d93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d98:	e9 19 01 00 00       	jmp    80101eb6 <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
80101d9d:	8b 45 08             	mov    0x8(%ebp),%eax
80101da0:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101da4:	98                   	cwtl   
80101da5:	8b 04 c5 00 e8 10 80 	mov    -0x7fef1800(,%eax,8),%eax
80101dac:	8b 55 14             	mov    0x14(%ebp),%edx
80101daf:	89 54 24 08          	mov    %edx,0x8(%esp)
80101db3:	8b 55 0c             	mov    0xc(%ebp),%edx
80101db6:	89 54 24 04          	mov    %edx,0x4(%esp)
80101dba:	8b 55 08             	mov    0x8(%ebp),%edx
80101dbd:	89 14 24             	mov    %edx,(%esp)
80101dc0:	ff d0                	call   *%eax
80101dc2:	e9 ef 00 00 00       	jmp    80101eb6 <readi+0x162>
  }

  if(off > ip->size || off + n < off)
80101dc7:	8b 45 08             	mov    0x8(%ebp),%eax
80101dca:	8b 40 18             	mov    0x18(%eax),%eax
80101dcd:	3b 45 10             	cmp    0x10(%ebp),%eax
80101dd0:	72 0d                	jb     80101ddf <readi+0x8b>
80101dd2:	8b 45 14             	mov    0x14(%ebp),%eax
80101dd5:	8b 55 10             	mov    0x10(%ebp),%edx
80101dd8:	01 d0                	add    %edx,%eax
80101dda:	3b 45 10             	cmp    0x10(%ebp),%eax
80101ddd:	73 0a                	jae    80101de9 <readi+0x95>
    return -1;
80101ddf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101de4:	e9 cd 00 00 00       	jmp    80101eb6 <readi+0x162>
  if(off + n > ip->size)
80101de9:	8b 45 14             	mov    0x14(%ebp),%eax
80101dec:	8b 55 10             	mov    0x10(%ebp),%edx
80101def:	01 c2                	add    %eax,%edx
80101df1:	8b 45 08             	mov    0x8(%ebp),%eax
80101df4:	8b 40 18             	mov    0x18(%eax),%eax
80101df7:	39 c2                	cmp    %eax,%edx
80101df9:	76 0c                	jbe    80101e07 <readi+0xb3>
    n = ip->size - off;
80101dfb:	8b 45 08             	mov    0x8(%ebp),%eax
80101dfe:	8b 40 18             	mov    0x18(%eax),%eax
80101e01:	2b 45 10             	sub    0x10(%ebp),%eax
80101e04:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e07:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e0e:	e9 94 00 00 00       	jmp    80101ea7 <readi+0x153>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e13:	8b 45 10             	mov    0x10(%ebp),%eax
80101e16:	c1 e8 09             	shr    $0x9,%eax
80101e19:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e1d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e20:	89 04 24             	mov    %eax,(%esp)
80101e23:	e8 c1 fc ff ff       	call   80101ae9 <bmap>
80101e28:	8b 55 08             	mov    0x8(%ebp),%edx
80101e2b:	8b 12                	mov    (%edx),%edx
80101e2d:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e31:	89 14 24             	mov    %edx,(%esp)
80101e34:	e8 6d e3 ff ff       	call   801001a6 <bread>
80101e39:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101e3c:	8b 45 10             	mov    0x10(%ebp),%eax
80101e3f:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e44:	89 c2                	mov    %eax,%edx
80101e46:	b8 00 02 00 00       	mov    $0x200,%eax
80101e4b:	29 d0                	sub    %edx,%eax
80101e4d:	89 c2                	mov    %eax,%edx
80101e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e52:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101e55:	29 c1                	sub    %eax,%ecx
80101e57:	89 c8                	mov    %ecx,%eax
80101e59:	39 c2                	cmp    %eax,%edx
80101e5b:	0f 46 c2             	cmovbe %edx,%eax
80101e5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101e61:	8b 45 10             	mov    0x10(%ebp),%eax
80101e64:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e69:	8d 50 10             	lea    0x10(%eax),%edx
80101e6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e6f:	01 d0                	add    %edx,%eax
80101e71:	8d 50 08             	lea    0x8(%eax),%edx
80101e74:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e77:	89 44 24 08          	mov    %eax,0x8(%esp)
80101e7b:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e82:	89 04 24             	mov    %eax,(%esp)
80101e85:	e8 df 2e 00 00       	call   80104d69 <memmove>
    brelse(bp);
80101e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e8d:	89 04 24             	mov    %eax,(%esp)
80101e90:	e8 82 e3 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e95:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e98:	01 45 f4             	add    %eax,-0xc(%ebp)
80101e9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e9e:	01 45 10             	add    %eax,0x10(%ebp)
80101ea1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ea4:	01 45 0c             	add    %eax,0xc(%ebp)
80101ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101eaa:	3b 45 14             	cmp    0x14(%ebp),%eax
80101ead:	0f 82 60 ff ff ff    	jb     80101e13 <readi+0xbf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101eb3:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101eb6:	c9                   	leave  
80101eb7:	c3                   	ret    

80101eb8 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101eb8:	55                   	push   %ebp
80101eb9:	89 e5                	mov    %esp,%ebp
80101ebb:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ebe:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec1:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101ec5:	66 83 f8 03          	cmp    $0x3,%ax
80101ec9:	75 60                	jne    80101f2b <writei+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ecb:	8b 45 08             	mov    0x8(%ebp),%eax
80101ece:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ed2:	66 85 c0             	test   %ax,%ax
80101ed5:	78 20                	js     80101ef7 <writei+0x3f>
80101ed7:	8b 45 08             	mov    0x8(%ebp),%eax
80101eda:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ede:	66 83 f8 09          	cmp    $0x9,%ax
80101ee2:	7f 13                	jg     80101ef7 <writei+0x3f>
80101ee4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee7:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101eeb:	98                   	cwtl   
80101eec:	8b 04 c5 04 e8 10 80 	mov    -0x7fef17fc(,%eax,8),%eax
80101ef3:	85 c0                	test   %eax,%eax
80101ef5:	75 0a                	jne    80101f01 <writei+0x49>
      return -1;
80101ef7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101efc:	e9 44 01 00 00       	jmp    80102045 <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
80101f01:	8b 45 08             	mov    0x8(%ebp),%eax
80101f04:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f08:	98                   	cwtl   
80101f09:	8b 04 c5 04 e8 10 80 	mov    -0x7fef17fc(,%eax,8),%eax
80101f10:	8b 55 14             	mov    0x14(%ebp),%edx
80101f13:	89 54 24 08          	mov    %edx,0x8(%esp)
80101f17:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f1a:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f1e:	8b 55 08             	mov    0x8(%ebp),%edx
80101f21:	89 14 24             	mov    %edx,(%esp)
80101f24:	ff d0                	call   *%eax
80101f26:	e9 1a 01 00 00       	jmp    80102045 <writei+0x18d>
  }

  if(off > ip->size || off + n < off)
80101f2b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2e:	8b 40 18             	mov    0x18(%eax),%eax
80101f31:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f34:	72 0d                	jb     80101f43 <writei+0x8b>
80101f36:	8b 45 14             	mov    0x14(%ebp),%eax
80101f39:	8b 55 10             	mov    0x10(%ebp),%edx
80101f3c:	01 d0                	add    %edx,%eax
80101f3e:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f41:	73 0a                	jae    80101f4d <writei+0x95>
    return -1;
80101f43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f48:	e9 f8 00 00 00       	jmp    80102045 <writei+0x18d>
  if(off + n > MAXFILE*BSIZE)
80101f4d:	8b 45 14             	mov    0x14(%ebp),%eax
80101f50:	8b 55 10             	mov    0x10(%ebp),%edx
80101f53:	01 d0                	add    %edx,%eax
80101f55:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101f5a:	76 0a                	jbe    80101f66 <writei+0xae>
    return -1;
80101f5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f61:	e9 df 00 00 00       	jmp    80102045 <writei+0x18d>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f6d:	e9 9f 00 00 00       	jmp    80102011 <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f72:	8b 45 10             	mov    0x10(%ebp),%eax
80101f75:	c1 e8 09             	shr    $0x9,%eax
80101f78:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f7c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f7f:	89 04 24             	mov    %eax,(%esp)
80101f82:	e8 62 fb ff ff       	call   80101ae9 <bmap>
80101f87:	8b 55 08             	mov    0x8(%ebp),%edx
80101f8a:	8b 12                	mov    (%edx),%edx
80101f8c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f90:	89 14 24             	mov    %edx,(%esp)
80101f93:	e8 0e e2 ff ff       	call   801001a6 <bread>
80101f98:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101f9b:	8b 45 10             	mov    0x10(%ebp),%eax
80101f9e:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fa3:	89 c2                	mov    %eax,%edx
80101fa5:	b8 00 02 00 00       	mov    $0x200,%eax
80101faa:	29 d0                	sub    %edx,%eax
80101fac:	89 c2                	mov    %eax,%edx
80101fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fb1:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101fb4:	29 c1                	sub    %eax,%ecx
80101fb6:	89 c8                	mov    %ecx,%eax
80101fb8:	39 c2                	cmp    %eax,%edx
80101fba:	0f 46 c2             	cmovbe %edx,%eax
80101fbd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80101fc0:	8b 45 10             	mov    0x10(%ebp),%eax
80101fc3:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fc8:	8d 50 10             	lea    0x10(%eax),%edx
80101fcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fce:	01 d0                	add    %edx,%eax
80101fd0:	8d 50 08             	lea    0x8(%eax),%edx
80101fd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fd6:	89 44 24 08          	mov    %eax,0x8(%esp)
80101fda:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fdd:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fe1:	89 14 24             	mov    %edx,(%esp)
80101fe4:	e8 80 2d 00 00       	call   80104d69 <memmove>
    log_write(bp);
80101fe9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fec:	89 04 24             	mov    %eax,(%esp)
80101fef:	e8 7e 12 00 00       	call   80103272 <log_write>
    brelse(bp);
80101ff4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ff7:	89 04 24             	mov    %eax,(%esp)
80101ffa:	e8 18 e2 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101fff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102002:	01 45 f4             	add    %eax,-0xc(%ebp)
80102005:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102008:	01 45 10             	add    %eax,0x10(%ebp)
8010200b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010200e:	01 45 0c             	add    %eax,0xc(%ebp)
80102011:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102014:	3b 45 14             	cmp    0x14(%ebp),%eax
80102017:	0f 82 55 ff ff ff    	jb     80101f72 <writei+0xba>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
8010201d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102021:	74 1f                	je     80102042 <writei+0x18a>
80102023:	8b 45 08             	mov    0x8(%ebp),%eax
80102026:	8b 40 18             	mov    0x18(%eax),%eax
80102029:	3b 45 10             	cmp    0x10(%ebp),%eax
8010202c:	73 14                	jae    80102042 <writei+0x18a>
    ip->size = off;
8010202e:	8b 45 08             	mov    0x8(%ebp),%eax
80102031:	8b 55 10             	mov    0x10(%ebp),%edx
80102034:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
80102037:	8b 45 08             	mov    0x8(%ebp),%eax
8010203a:	89 04 24             	mov    %eax,(%esp)
8010203d:	e8 49 f6 ff ff       	call   8010168b <iupdate>
  }
  return n;
80102042:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102045:	c9                   	leave  
80102046:	c3                   	ret    

80102047 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102047:	55                   	push   %ebp
80102048:	89 e5                	mov    %esp,%ebp
8010204a:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
8010204d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102054:	00 
80102055:	8b 45 0c             	mov    0xc(%ebp),%eax
80102058:	89 44 24 04          	mov    %eax,0x4(%esp)
8010205c:	8b 45 08             	mov    0x8(%ebp),%eax
8010205f:	89 04 24             	mov    %eax,(%esp)
80102062:	e8 a5 2d 00 00       	call   80104e0c <strncmp>
}
80102067:	c9                   	leave  
80102068:	c3                   	ret    

80102069 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102069:	55                   	push   %ebp
8010206a:	89 e5                	mov    %esp,%ebp
8010206c:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010206f:	8b 45 08             	mov    0x8(%ebp),%eax
80102072:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102076:	66 83 f8 01          	cmp    $0x1,%ax
8010207a:	74 0c                	je     80102088 <dirlookup+0x1f>
    panic("dirlookup not DIR");
8010207c:	c7 04 24 fd 80 10 80 	movl   $0x801080fd,(%esp)
80102083:	e8 b2 e4 ff ff       	call   8010053a <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102088:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010208f:	e9 88 00 00 00       	jmp    8010211c <dirlookup+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102094:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010209b:	00 
8010209c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010209f:	89 44 24 08          	mov    %eax,0x8(%esp)
801020a3:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020a6:	89 44 24 04          	mov    %eax,0x4(%esp)
801020aa:	8b 45 08             	mov    0x8(%ebp),%eax
801020ad:	89 04 24             	mov    %eax,(%esp)
801020b0:	e8 9f fc ff ff       	call   80101d54 <readi>
801020b5:	83 f8 10             	cmp    $0x10,%eax
801020b8:	74 0c                	je     801020c6 <dirlookup+0x5d>
      panic("dirlink read");
801020ba:	c7 04 24 0f 81 10 80 	movl   $0x8010810f,(%esp)
801020c1:	e8 74 e4 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
801020c6:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801020ca:	66 85 c0             	test   %ax,%ax
801020cd:	75 02                	jne    801020d1 <dirlookup+0x68>
      continue;
801020cf:	eb 47                	jmp    80102118 <dirlookup+0xaf>
    if(namecmp(name, de.name) == 0){
801020d1:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020d4:	83 c0 02             	add    $0x2,%eax
801020d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801020db:	8b 45 0c             	mov    0xc(%ebp),%eax
801020de:	89 04 24             	mov    %eax,(%esp)
801020e1:	e8 61 ff ff ff       	call   80102047 <namecmp>
801020e6:	85 c0                	test   %eax,%eax
801020e8:	75 2e                	jne    80102118 <dirlookup+0xaf>
      // entry matches path element
      if(poff)
801020ea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801020ee:	74 08                	je     801020f8 <dirlookup+0x8f>
        *poff = off;
801020f0:	8b 45 10             	mov    0x10(%ebp),%eax
801020f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801020f6:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
801020f8:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801020fc:	0f b7 c0             	movzwl %ax,%eax
801020ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102102:	8b 45 08             	mov    0x8(%ebp),%eax
80102105:	8b 00                	mov    (%eax),%eax
80102107:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010210a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010210e:	89 04 24             	mov    %eax,(%esp)
80102111:	e8 2d f6 ff ff       	call   80101743 <iget>
80102116:	eb 18                	jmp    80102130 <dirlookup+0xc7>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102118:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010211c:	8b 45 08             	mov    0x8(%ebp),%eax
8010211f:	8b 40 18             	mov    0x18(%eax),%eax
80102122:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102125:	0f 87 69 ff ff ff    	ja     80102094 <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
8010212b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102130:	c9                   	leave  
80102131:	c3                   	ret    

80102132 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102132:	55                   	push   %ebp
80102133:	89 e5                	mov    %esp,%ebp
80102135:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102138:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010213f:	00 
80102140:	8b 45 0c             	mov    0xc(%ebp),%eax
80102143:	89 44 24 04          	mov    %eax,0x4(%esp)
80102147:	8b 45 08             	mov    0x8(%ebp),%eax
8010214a:	89 04 24             	mov    %eax,(%esp)
8010214d:	e8 17 ff ff ff       	call   80102069 <dirlookup>
80102152:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102155:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102159:	74 15                	je     80102170 <dirlink+0x3e>
    iput(ip);
8010215b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010215e:	89 04 24             	mov    %eax,(%esp)
80102161:	e8 94 f8 ff ff       	call   801019fa <iput>
    return -1;
80102166:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010216b:	e9 b7 00 00 00       	jmp    80102227 <dirlink+0xf5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102170:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102177:	eb 46                	jmp    801021bf <dirlink+0x8d>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102179:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010217c:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102183:	00 
80102184:	89 44 24 08          	mov    %eax,0x8(%esp)
80102188:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010218b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010218f:	8b 45 08             	mov    0x8(%ebp),%eax
80102192:	89 04 24             	mov    %eax,(%esp)
80102195:	e8 ba fb ff ff       	call   80101d54 <readi>
8010219a:	83 f8 10             	cmp    $0x10,%eax
8010219d:	74 0c                	je     801021ab <dirlink+0x79>
      panic("dirlink read");
8010219f:	c7 04 24 0f 81 10 80 	movl   $0x8010810f,(%esp)
801021a6:	e8 8f e3 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
801021ab:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021af:	66 85 c0             	test   %ax,%ax
801021b2:	75 02                	jne    801021b6 <dirlink+0x84>
      break;
801021b4:	eb 16                	jmp    801021cc <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021b9:	83 c0 10             	add    $0x10,%eax
801021bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801021bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801021c2:	8b 45 08             	mov    0x8(%ebp),%eax
801021c5:	8b 40 18             	mov    0x18(%eax),%eax
801021c8:	39 c2                	cmp    %eax,%edx
801021ca:	72 ad                	jb     80102179 <dirlink+0x47>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
801021cc:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801021d3:	00 
801021d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801021d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801021db:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021de:	83 c0 02             	add    $0x2,%eax
801021e1:	89 04 24             	mov    %eax,(%esp)
801021e4:	e8 79 2c 00 00       	call   80104e62 <strncpy>
  de.inum = inum;
801021e9:	8b 45 10             	mov    0x10(%ebp),%eax
801021ec:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021f3:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801021fa:	00 
801021fb:	89 44 24 08          	mov    %eax,0x8(%esp)
801021ff:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102202:	89 44 24 04          	mov    %eax,0x4(%esp)
80102206:	8b 45 08             	mov    0x8(%ebp),%eax
80102209:	89 04 24             	mov    %eax,(%esp)
8010220c:	e8 a7 fc ff ff       	call   80101eb8 <writei>
80102211:	83 f8 10             	cmp    $0x10,%eax
80102214:	74 0c                	je     80102222 <dirlink+0xf0>
    panic("dirlink");
80102216:	c7 04 24 1c 81 10 80 	movl   $0x8010811c,(%esp)
8010221d:	e8 18 e3 ff ff       	call   8010053a <panic>
  
  return 0;
80102222:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102227:	c9                   	leave  
80102228:	c3                   	ret    

80102229 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102229:	55                   	push   %ebp
8010222a:	89 e5                	mov    %esp,%ebp
8010222c:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
8010222f:	eb 04                	jmp    80102235 <skipelem+0xc>
    path++;
80102231:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102235:	8b 45 08             	mov    0x8(%ebp),%eax
80102238:	0f b6 00             	movzbl (%eax),%eax
8010223b:	3c 2f                	cmp    $0x2f,%al
8010223d:	74 f2                	je     80102231 <skipelem+0x8>
    path++;
  if(*path == 0)
8010223f:	8b 45 08             	mov    0x8(%ebp),%eax
80102242:	0f b6 00             	movzbl (%eax),%eax
80102245:	84 c0                	test   %al,%al
80102247:	75 0a                	jne    80102253 <skipelem+0x2a>
    return 0;
80102249:	b8 00 00 00 00       	mov    $0x0,%eax
8010224e:	e9 86 00 00 00       	jmp    801022d9 <skipelem+0xb0>
  s = path;
80102253:	8b 45 08             	mov    0x8(%ebp),%eax
80102256:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102259:	eb 04                	jmp    8010225f <skipelem+0x36>
    path++;
8010225b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
8010225f:	8b 45 08             	mov    0x8(%ebp),%eax
80102262:	0f b6 00             	movzbl (%eax),%eax
80102265:	3c 2f                	cmp    $0x2f,%al
80102267:	74 0a                	je     80102273 <skipelem+0x4a>
80102269:	8b 45 08             	mov    0x8(%ebp),%eax
8010226c:	0f b6 00             	movzbl (%eax),%eax
8010226f:	84 c0                	test   %al,%al
80102271:	75 e8                	jne    8010225b <skipelem+0x32>
    path++;
  len = path - s;
80102273:	8b 55 08             	mov    0x8(%ebp),%edx
80102276:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102279:	29 c2                	sub    %eax,%edx
8010227b:	89 d0                	mov    %edx,%eax
8010227d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102280:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102284:	7e 1c                	jle    801022a2 <skipelem+0x79>
    memmove(name, s, DIRSIZ);
80102286:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
8010228d:	00 
8010228e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102291:	89 44 24 04          	mov    %eax,0x4(%esp)
80102295:	8b 45 0c             	mov    0xc(%ebp),%eax
80102298:	89 04 24             	mov    %eax,(%esp)
8010229b:	e8 c9 2a 00 00       	call   80104d69 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022a0:	eb 2a                	jmp    801022cc <skipelem+0xa3>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
801022a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022a5:	89 44 24 08          	mov    %eax,0x8(%esp)
801022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022ac:	89 44 24 04          	mov    %eax,0x4(%esp)
801022b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801022b3:	89 04 24             	mov    %eax,(%esp)
801022b6:	e8 ae 2a 00 00       	call   80104d69 <memmove>
    name[len] = 0;
801022bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
801022be:	8b 45 0c             	mov    0xc(%ebp),%eax
801022c1:	01 d0                	add    %edx,%eax
801022c3:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801022c6:	eb 04                	jmp    801022cc <skipelem+0xa3>
    path++;
801022c8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022cc:	8b 45 08             	mov    0x8(%ebp),%eax
801022cf:	0f b6 00             	movzbl (%eax),%eax
801022d2:	3c 2f                	cmp    $0x2f,%al
801022d4:	74 f2                	je     801022c8 <skipelem+0x9f>
    path++;
  return path;
801022d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
801022d9:	c9                   	leave  
801022da:	c3                   	ret    

801022db <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801022db:	55                   	push   %ebp
801022dc:	89 e5                	mov    %esp,%ebp
801022de:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
801022e1:	8b 45 08             	mov    0x8(%ebp),%eax
801022e4:	0f b6 00             	movzbl (%eax),%eax
801022e7:	3c 2f                	cmp    $0x2f,%al
801022e9:	75 1c                	jne    80102307 <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
801022eb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801022f2:	00 
801022f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801022fa:	e8 44 f4 ff ff       	call   80101743 <iget>
801022ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102302:	e9 af 00 00 00       	jmp    801023b6 <namex+0xdb>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80102307:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010230d:	8b 40 68             	mov    0x68(%eax),%eax
80102310:	89 04 24             	mov    %eax,(%esp)
80102313:	e8 fd f4 ff ff       	call   80101815 <idup>
80102318:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
8010231b:	e9 96 00 00 00       	jmp    801023b6 <namex+0xdb>
    ilock(ip);
80102320:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102323:	89 04 24             	mov    %eax,(%esp)
80102326:	e8 1c f5 ff ff       	call   80101847 <ilock>
    if(ip->type != T_DIR){
8010232b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010232e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102332:	66 83 f8 01          	cmp    $0x1,%ax
80102336:	74 15                	je     8010234d <namex+0x72>
      iunlockput(ip);
80102338:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010233b:	89 04 24             	mov    %eax,(%esp)
8010233e:	e8 88 f7 ff ff       	call   80101acb <iunlockput>
      return 0;
80102343:	b8 00 00 00 00       	mov    $0x0,%eax
80102348:	e9 a3 00 00 00       	jmp    801023f0 <namex+0x115>
    }
    if(nameiparent && *path == '\0'){
8010234d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102351:	74 1d                	je     80102370 <namex+0x95>
80102353:	8b 45 08             	mov    0x8(%ebp),%eax
80102356:	0f b6 00             	movzbl (%eax),%eax
80102359:	84 c0                	test   %al,%al
8010235b:	75 13                	jne    80102370 <namex+0x95>
      // Stop one level early.
      iunlock(ip);
8010235d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102360:	89 04 24             	mov    %eax,(%esp)
80102363:	e8 2d f6 ff ff       	call   80101995 <iunlock>
      return ip;
80102368:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010236b:	e9 80 00 00 00       	jmp    801023f0 <namex+0x115>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102370:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102377:	00 
80102378:	8b 45 10             	mov    0x10(%ebp),%eax
8010237b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010237f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102382:	89 04 24             	mov    %eax,(%esp)
80102385:	e8 df fc ff ff       	call   80102069 <dirlookup>
8010238a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010238d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102391:	75 12                	jne    801023a5 <namex+0xca>
      iunlockput(ip);
80102393:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102396:	89 04 24             	mov    %eax,(%esp)
80102399:	e8 2d f7 ff ff       	call   80101acb <iunlockput>
      return 0;
8010239e:	b8 00 00 00 00       	mov    $0x0,%eax
801023a3:	eb 4b                	jmp    801023f0 <namex+0x115>
    }
    iunlockput(ip);
801023a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023a8:	89 04 24             	mov    %eax,(%esp)
801023ab:	e8 1b f7 ff ff       	call   80101acb <iunlockput>
    ip = next;
801023b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801023b6:	8b 45 10             	mov    0x10(%ebp),%eax
801023b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801023bd:	8b 45 08             	mov    0x8(%ebp),%eax
801023c0:	89 04 24             	mov    %eax,(%esp)
801023c3:	e8 61 fe ff ff       	call   80102229 <skipelem>
801023c8:	89 45 08             	mov    %eax,0x8(%ebp)
801023cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801023cf:	0f 85 4b ff ff ff    	jne    80102320 <namex+0x45>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801023d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023d9:	74 12                	je     801023ed <namex+0x112>
    iput(ip);
801023db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023de:	89 04 24             	mov    %eax,(%esp)
801023e1:	e8 14 f6 ff ff       	call   801019fa <iput>
    return 0;
801023e6:	b8 00 00 00 00       	mov    $0x0,%eax
801023eb:	eb 03                	jmp    801023f0 <namex+0x115>
  }
  return ip;
801023ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801023f0:	c9                   	leave  
801023f1:	c3                   	ret    

801023f2 <namei>:

struct inode*
namei(char *path)
{
801023f2:	55                   	push   %ebp
801023f3:	89 e5                	mov    %esp,%ebp
801023f5:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801023f8:	8d 45 ea             	lea    -0x16(%ebp),%eax
801023fb:	89 44 24 08          	mov    %eax,0x8(%esp)
801023ff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102406:	00 
80102407:	8b 45 08             	mov    0x8(%ebp),%eax
8010240a:	89 04 24             	mov    %eax,(%esp)
8010240d:	e8 c9 fe ff ff       	call   801022db <namex>
}
80102412:	c9                   	leave  
80102413:	c3                   	ret    

80102414 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102414:	55                   	push   %ebp
80102415:	89 e5                	mov    %esp,%ebp
80102417:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
8010241a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010241d:	89 44 24 08          	mov    %eax,0x8(%esp)
80102421:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102428:	00 
80102429:	8b 45 08             	mov    0x8(%ebp),%eax
8010242c:	89 04 24             	mov    %eax,(%esp)
8010242f:	e8 a7 fe ff ff       	call   801022db <namex>
}
80102434:	c9                   	leave  
80102435:	c3                   	ret    

80102436 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102436:	55                   	push   %ebp
80102437:	89 e5                	mov    %esp,%ebp
80102439:	83 ec 14             	sub    $0x14,%esp
8010243c:	8b 45 08             	mov    0x8(%ebp),%eax
8010243f:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102443:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102447:	89 c2                	mov    %eax,%edx
80102449:	ec                   	in     (%dx),%al
8010244a:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010244d:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102451:	c9                   	leave  
80102452:	c3                   	ret    

80102453 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102453:	55                   	push   %ebp
80102454:	89 e5                	mov    %esp,%ebp
80102456:	57                   	push   %edi
80102457:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102458:	8b 55 08             	mov    0x8(%ebp),%edx
8010245b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010245e:	8b 45 10             	mov    0x10(%ebp),%eax
80102461:	89 cb                	mov    %ecx,%ebx
80102463:	89 df                	mov    %ebx,%edi
80102465:	89 c1                	mov    %eax,%ecx
80102467:	fc                   	cld    
80102468:	f3 6d                	rep insl (%dx),%es:(%edi)
8010246a:	89 c8                	mov    %ecx,%eax
8010246c:	89 fb                	mov    %edi,%ebx
8010246e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102471:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102474:	5b                   	pop    %ebx
80102475:	5f                   	pop    %edi
80102476:	5d                   	pop    %ebp
80102477:	c3                   	ret    

80102478 <outb>:

static inline void
outb(ushort port, uchar data)
{
80102478:	55                   	push   %ebp
80102479:	89 e5                	mov    %esp,%ebp
8010247b:	83 ec 08             	sub    $0x8,%esp
8010247e:	8b 55 08             	mov    0x8(%ebp),%edx
80102481:	8b 45 0c             	mov    0xc(%ebp),%eax
80102484:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102488:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010248b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010248f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102493:	ee                   	out    %al,(%dx)
}
80102494:	c9                   	leave  
80102495:	c3                   	ret    

80102496 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102496:	55                   	push   %ebp
80102497:	89 e5                	mov    %esp,%ebp
80102499:	56                   	push   %esi
8010249a:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
8010249b:	8b 55 08             	mov    0x8(%ebp),%edx
8010249e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024a1:	8b 45 10             	mov    0x10(%ebp),%eax
801024a4:	89 cb                	mov    %ecx,%ebx
801024a6:	89 de                	mov    %ebx,%esi
801024a8:	89 c1                	mov    %eax,%ecx
801024aa:	fc                   	cld    
801024ab:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801024ad:	89 c8                	mov    %ecx,%eax
801024af:	89 f3                	mov    %esi,%ebx
801024b1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024b4:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
801024b7:	5b                   	pop    %ebx
801024b8:	5e                   	pop    %esi
801024b9:	5d                   	pop    %ebp
801024ba:	c3                   	ret    

801024bb <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801024bb:	55                   	push   %ebp
801024bc:	89 e5                	mov    %esp,%ebp
801024be:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
801024c1:	90                   	nop
801024c2:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801024c9:	e8 68 ff ff ff       	call   80102436 <inb>
801024ce:	0f b6 c0             	movzbl %al,%eax
801024d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
801024d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801024d7:	25 c0 00 00 00       	and    $0xc0,%eax
801024dc:	83 f8 40             	cmp    $0x40,%eax
801024df:	75 e1                	jne    801024c2 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801024e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801024e5:	74 11                	je     801024f8 <idewait+0x3d>
801024e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801024ea:	83 e0 21             	and    $0x21,%eax
801024ed:	85 c0                	test   %eax,%eax
801024ef:	74 07                	je     801024f8 <idewait+0x3d>
    return -1;
801024f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801024f6:	eb 05                	jmp    801024fd <idewait+0x42>
  return 0;
801024f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801024fd:	c9                   	leave  
801024fe:	c3                   	ret    

801024ff <ideinit>:

void
ideinit(void)
{
801024ff:	55                   	push   %ebp
80102500:	89 e5                	mov    %esp,%ebp
80102502:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
80102505:	c7 44 24 04 24 81 10 	movl   $0x80108124,0x4(%esp)
8010250c:	80 
8010250d:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102514:	e8 0c 25 00 00       	call   80104a25 <initlock>
  picenable(IRQ_IDE);
80102519:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102520:	e8 0d 15 00 00       	call   80103a32 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102525:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010252a:	83 e8 01             	sub    $0x1,%eax
8010252d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102531:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102538:	e8 0c 04 00 00       	call   80102949 <ioapicenable>
  idewait(0);
8010253d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102544:	e8 72 ff ff ff       	call   801024bb <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102549:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
80102550:	00 
80102551:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102558:	e8 1b ff ff ff       	call   80102478 <outb>
  for(i=0; i<1000; i++){
8010255d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102564:	eb 20                	jmp    80102586 <ideinit+0x87>
    if(inb(0x1f7) != 0){
80102566:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010256d:	e8 c4 fe ff ff       	call   80102436 <inb>
80102572:	84 c0                	test   %al,%al
80102574:	74 0c                	je     80102582 <ideinit+0x83>
      havedisk1 = 1;
80102576:	c7 05 38 b6 10 80 01 	movl   $0x1,0x8010b638
8010257d:	00 00 00 
      break;
80102580:	eb 0d                	jmp    8010258f <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102582:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102586:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
8010258d:	7e d7                	jle    80102566 <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
8010258f:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
80102596:	00 
80102597:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
8010259e:	e8 d5 fe ff ff       	call   80102478 <outb>
}
801025a3:	c9                   	leave  
801025a4:	c3                   	ret    

801025a5 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801025a5:	55                   	push   %ebp
801025a6:	89 e5                	mov    %esp,%ebp
801025a8:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801025ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025af:	75 0c                	jne    801025bd <idestart+0x18>
    panic("idestart");
801025b1:	c7 04 24 28 81 10 80 	movl   $0x80108128,(%esp)
801025b8:	e8 7d df ff ff       	call   8010053a <panic>

  idewait(0);
801025bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801025c4:	e8 f2 fe ff ff       	call   801024bb <idewait>
  outb(0x3f6, 0);  // generate interrupt
801025c9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801025d0:	00 
801025d1:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
801025d8:	e8 9b fe ff ff       	call   80102478 <outb>
  outb(0x1f2, 1);  // number of sectors
801025dd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801025e4:	00 
801025e5:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
801025ec:	e8 87 fe ff ff       	call   80102478 <outb>
  outb(0x1f3, b->sector & 0xff);
801025f1:	8b 45 08             	mov    0x8(%ebp),%eax
801025f4:	8b 40 08             	mov    0x8(%eax),%eax
801025f7:	0f b6 c0             	movzbl %al,%eax
801025fa:	89 44 24 04          	mov    %eax,0x4(%esp)
801025fe:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
80102605:	e8 6e fe ff ff       	call   80102478 <outb>
  outb(0x1f4, (b->sector >> 8) & 0xff);
8010260a:	8b 45 08             	mov    0x8(%ebp),%eax
8010260d:	8b 40 08             	mov    0x8(%eax),%eax
80102610:	c1 e8 08             	shr    $0x8,%eax
80102613:	0f b6 c0             	movzbl %al,%eax
80102616:	89 44 24 04          	mov    %eax,0x4(%esp)
8010261a:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
80102621:	e8 52 fe ff ff       	call   80102478 <outb>
  outb(0x1f5, (b->sector >> 16) & 0xff);
80102626:	8b 45 08             	mov    0x8(%ebp),%eax
80102629:	8b 40 08             	mov    0x8(%eax),%eax
8010262c:	c1 e8 10             	shr    $0x10,%eax
8010262f:	0f b6 c0             	movzbl %al,%eax
80102632:	89 44 24 04          	mov    %eax,0x4(%esp)
80102636:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
8010263d:	e8 36 fe ff ff       	call   80102478 <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
80102642:	8b 45 08             	mov    0x8(%ebp),%eax
80102645:	8b 40 04             	mov    0x4(%eax),%eax
80102648:	83 e0 01             	and    $0x1,%eax
8010264b:	c1 e0 04             	shl    $0x4,%eax
8010264e:	89 c2                	mov    %eax,%edx
80102650:	8b 45 08             	mov    0x8(%ebp),%eax
80102653:	8b 40 08             	mov    0x8(%eax),%eax
80102656:	c1 e8 18             	shr    $0x18,%eax
80102659:	83 e0 0f             	and    $0xf,%eax
8010265c:	09 d0                	or     %edx,%eax
8010265e:	83 c8 e0             	or     $0xffffffe0,%eax
80102661:	0f b6 c0             	movzbl %al,%eax
80102664:	89 44 24 04          	mov    %eax,0x4(%esp)
80102668:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
8010266f:	e8 04 fe ff ff       	call   80102478 <outb>
  if(b->flags & B_DIRTY){
80102674:	8b 45 08             	mov    0x8(%ebp),%eax
80102677:	8b 00                	mov    (%eax),%eax
80102679:	83 e0 04             	and    $0x4,%eax
8010267c:	85 c0                	test   %eax,%eax
8010267e:	74 34                	je     801026b4 <idestart+0x10f>
    outb(0x1f7, IDE_CMD_WRITE);
80102680:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
80102687:	00 
80102688:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010268f:	e8 e4 fd ff ff       	call   80102478 <outb>
    outsl(0x1f0, b->data, 512/4);
80102694:	8b 45 08             	mov    0x8(%ebp),%eax
80102697:	83 c0 18             	add    $0x18,%eax
8010269a:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801026a1:	00 
801026a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801026a6:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801026ad:	e8 e4 fd ff ff       	call   80102496 <outsl>
801026b2:	eb 14                	jmp    801026c8 <idestart+0x123>
  } else {
    outb(0x1f7, IDE_CMD_READ);
801026b4:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
801026bb:	00 
801026bc:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026c3:	e8 b0 fd ff ff       	call   80102478 <outb>
  }
}
801026c8:	c9                   	leave  
801026c9:	c3                   	ret    

801026ca <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801026ca:	55                   	push   %ebp
801026cb:	89 e5                	mov    %esp,%ebp
801026cd:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801026d0:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801026d7:	e8 6a 23 00 00       	call   80104a46 <acquire>
  if((b = idequeue) == 0){
801026dc:	a1 34 b6 10 80       	mov    0x8010b634,%eax
801026e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801026e8:	75 11                	jne    801026fb <ideintr+0x31>
    release(&idelock);
801026ea:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801026f1:	e8 b2 23 00 00       	call   80104aa8 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
801026f6:	e9 90 00 00 00       	jmp    8010278b <ideintr+0xc1>
  }
  idequeue = b->qnext;
801026fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026fe:	8b 40 14             	mov    0x14(%eax),%eax
80102701:	a3 34 b6 10 80       	mov    %eax,0x8010b634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102706:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102709:	8b 00                	mov    (%eax),%eax
8010270b:	83 e0 04             	and    $0x4,%eax
8010270e:	85 c0                	test   %eax,%eax
80102710:	75 2e                	jne    80102740 <ideintr+0x76>
80102712:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102719:	e8 9d fd ff ff       	call   801024bb <idewait>
8010271e:	85 c0                	test   %eax,%eax
80102720:	78 1e                	js     80102740 <ideintr+0x76>
    insl(0x1f0, b->data, 512/4);
80102722:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102725:	83 c0 18             	add    $0x18,%eax
80102728:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
8010272f:	00 
80102730:	89 44 24 04          	mov    %eax,0x4(%esp)
80102734:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
8010273b:	e8 13 fd ff ff       	call   80102453 <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102740:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102743:	8b 00                	mov    (%eax),%eax
80102745:	83 c8 02             	or     $0x2,%eax
80102748:	89 c2                	mov    %eax,%edx
8010274a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010274d:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
8010274f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102752:	8b 00                	mov    (%eax),%eax
80102754:	83 e0 fb             	and    $0xfffffffb,%eax
80102757:	89 c2                	mov    %eax,%edx
80102759:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010275c:	89 10                	mov    %edx,(%eax)
  wakeup(b);
8010275e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102761:	89 04 24             	mov    %eax,(%esp)
80102764:	e8 ec 20 00 00       	call   80104855 <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102769:	a1 34 b6 10 80       	mov    0x8010b634,%eax
8010276e:	85 c0                	test   %eax,%eax
80102770:	74 0d                	je     8010277f <ideintr+0xb5>
    idestart(idequeue);
80102772:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102777:	89 04 24             	mov    %eax,(%esp)
8010277a:	e8 26 fe ff ff       	call   801025a5 <idestart>

  release(&idelock);
8010277f:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102786:	e8 1d 23 00 00       	call   80104aa8 <release>
}
8010278b:	c9                   	leave  
8010278c:	c3                   	ret    

8010278d <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010278d:	55                   	push   %ebp
8010278e:	89 e5                	mov    %esp,%ebp
80102790:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102793:	8b 45 08             	mov    0x8(%ebp),%eax
80102796:	8b 00                	mov    (%eax),%eax
80102798:	83 e0 01             	and    $0x1,%eax
8010279b:	85 c0                	test   %eax,%eax
8010279d:	75 0c                	jne    801027ab <iderw+0x1e>
    panic("iderw: buf not busy");
8010279f:	c7 04 24 31 81 10 80 	movl   $0x80108131,(%esp)
801027a6:	e8 8f dd ff ff       	call   8010053a <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801027ab:	8b 45 08             	mov    0x8(%ebp),%eax
801027ae:	8b 00                	mov    (%eax),%eax
801027b0:	83 e0 06             	and    $0x6,%eax
801027b3:	83 f8 02             	cmp    $0x2,%eax
801027b6:	75 0c                	jne    801027c4 <iderw+0x37>
    panic("iderw: nothing to do");
801027b8:	c7 04 24 45 81 10 80 	movl   $0x80108145,(%esp)
801027bf:	e8 76 dd ff ff       	call   8010053a <panic>
  if(b->dev != 0 && !havedisk1)
801027c4:	8b 45 08             	mov    0x8(%ebp),%eax
801027c7:	8b 40 04             	mov    0x4(%eax),%eax
801027ca:	85 c0                	test   %eax,%eax
801027cc:	74 15                	je     801027e3 <iderw+0x56>
801027ce:	a1 38 b6 10 80       	mov    0x8010b638,%eax
801027d3:	85 c0                	test   %eax,%eax
801027d5:	75 0c                	jne    801027e3 <iderw+0x56>
    panic("iderw: ide disk 1 not present");
801027d7:	c7 04 24 5a 81 10 80 	movl   $0x8010815a,(%esp)
801027de:	e8 57 dd ff ff       	call   8010053a <panic>

  acquire(&idelock);  //DOC:acquire-lock
801027e3:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801027ea:	e8 57 22 00 00       	call   80104a46 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
801027ef:	8b 45 08             	mov    0x8(%ebp),%eax
801027f2:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801027f9:	c7 45 f4 34 b6 10 80 	movl   $0x8010b634,-0xc(%ebp)
80102800:	eb 0b                	jmp    8010280d <iderw+0x80>
80102802:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102805:	8b 00                	mov    (%eax),%eax
80102807:	83 c0 14             	add    $0x14,%eax
8010280a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010280d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102810:	8b 00                	mov    (%eax),%eax
80102812:	85 c0                	test   %eax,%eax
80102814:	75 ec                	jne    80102802 <iderw+0x75>
    ;
  *pp = b;
80102816:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102819:	8b 55 08             	mov    0x8(%ebp),%edx
8010281c:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
8010281e:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102823:	3b 45 08             	cmp    0x8(%ebp),%eax
80102826:	75 0d                	jne    80102835 <iderw+0xa8>
    idestart(b);
80102828:	8b 45 08             	mov    0x8(%ebp),%eax
8010282b:	89 04 24             	mov    %eax,(%esp)
8010282e:	e8 72 fd ff ff       	call   801025a5 <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102833:	eb 15                	jmp    8010284a <iderw+0xbd>
80102835:	eb 13                	jmp    8010284a <iderw+0xbd>
    sleep(b, &idelock);
80102837:	c7 44 24 04 00 b6 10 	movl   $0x8010b600,0x4(%esp)
8010283e:	80 
8010283f:	8b 45 08             	mov    0x8(%ebp),%eax
80102842:	89 04 24             	mov    %eax,(%esp)
80102845:	e8 32 1f 00 00       	call   8010477c <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010284a:	8b 45 08             	mov    0x8(%ebp),%eax
8010284d:	8b 00                	mov    (%eax),%eax
8010284f:	83 e0 06             	and    $0x6,%eax
80102852:	83 f8 02             	cmp    $0x2,%eax
80102855:	75 e0                	jne    80102837 <iderw+0xaa>
    sleep(b, &idelock);
  }

  release(&idelock);
80102857:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
8010285e:	e8 45 22 00 00       	call   80104aa8 <release>
}
80102863:	c9                   	leave  
80102864:	c3                   	ret    

80102865 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102865:	55                   	push   %ebp
80102866:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102868:	a1 34 f8 10 80       	mov    0x8010f834,%eax
8010286d:	8b 55 08             	mov    0x8(%ebp),%edx
80102870:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102872:	a1 34 f8 10 80       	mov    0x8010f834,%eax
80102877:	8b 40 10             	mov    0x10(%eax),%eax
}
8010287a:	5d                   	pop    %ebp
8010287b:	c3                   	ret    

8010287c <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
8010287c:	55                   	push   %ebp
8010287d:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010287f:	a1 34 f8 10 80       	mov    0x8010f834,%eax
80102884:	8b 55 08             	mov    0x8(%ebp),%edx
80102887:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102889:	a1 34 f8 10 80       	mov    0x8010f834,%eax
8010288e:	8b 55 0c             	mov    0xc(%ebp),%edx
80102891:	89 50 10             	mov    %edx,0x10(%eax)
}
80102894:	5d                   	pop    %ebp
80102895:	c3                   	ret    

80102896 <ioapicinit>:

void
ioapicinit(void)
{
80102896:	55                   	push   %ebp
80102897:	89 e5                	mov    %esp,%ebp
80102899:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
8010289c:	a1 04 f9 10 80       	mov    0x8010f904,%eax
801028a1:	85 c0                	test   %eax,%eax
801028a3:	75 05                	jne    801028aa <ioapicinit+0x14>
    return;
801028a5:	e9 9d 00 00 00       	jmp    80102947 <ioapicinit+0xb1>

  ioapic = (volatile struct ioapic*)IOAPIC;
801028aa:	c7 05 34 f8 10 80 00 	movl   $0xfec00000,0x8010f834
801028b1:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801028b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801028bb:	e8 a5 ff ff ff       	call   80102865 <ioapicread>
801028c0:	c1 e8 10             	shr    $0x10,%eax
801028c3:	25 ff 00 00 00       	and    $0xff,%eax
801028c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
801028cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801028d2:	e8 8e ff ff ff       	call   80102865 <ioapicread>
801028d7:	c1 e8 18             	shr    $0x18,%eax
801028da:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
801028dd:	0f b6 05 00 f9 10 80 	movzbl 0x8010f900,%eax
801028e4:	0f b6 c0             	movzbl %al,%eax
801028e7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801028ea:	74 0c                	je     801028f8 <ioapicinit+0x62>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801028ec:	c7 04 24 78 81 10 80 	movl   $0x80108178,(%esp)
801028f3:	e8 a8 da ff ff       	call   801003a0 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801028f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801028ff:	eb 3e                	jmp    8010293f <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102901:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102904:	83 c0 20             	add    $0x20,%eax
80102907:	0d 00 00 01 00       	or     $0x10000,%eax
8010290c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010290f:	83 c2 08             	add    $0x8,%edx
80102912:	01 d2                	add    %edx,%edx
80102914:	89 44 24 04          	mov    %eax,0x4(%esp)
80102918:	89 14 24             	mov    %edx,(%esp)
8010291b:	e8 5c ff ff ff       	call   8010287c <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102920:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102923:	83 c0 08             	add    $0x8,%eax
80102926:	01 c0                	add    %eax,%eax
80102928:	83 c0 01             	add    $0x1,%eax
8010292b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102932:	00 
80102933:	89 04 24             	mov    %eax,(%esp)
80102936:	e8 41 ff ff ff       	call   8010287c <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010293b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010293f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102942:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102945:	7e ba                	jle    80102901 <ioapicinit+0x6b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102947:	c9                   	leave  
80102948:	c3                   	ret    

80102949 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102949:	55                   	push   %ebp
8010294a:	89 e5                	mov    %esp,%ebp
8010294c:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
8010294f:	a1 04 f9 10 80       	mov    0x8010f904,%eax
80102954:	85 c0                	test   %eax,%eax
80102956:	75 02                	jne    8010295a <ioapicenable+0x11>
    return;
80102958:	eb 37                	jmp    80102991 <ioapicenable+0x48>

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010295a:	8b 45 08             	mov    0x8(%ebp),%eax
8010295d:	83 c0 20             	add    $0x20,%eax
80102960:	8b 55 08             	mov    0x8(%ebp),%edx
80102963:	83 c2 08             	add    $0x8,%edx
80102966:	01 d2                	add    %edx,%edx
80102968:	89 44 24 04          	mov    %eax,0x4(%esp)
8010296c:	89 14 24             	mov    %edx,(%esp)
8010296f:	e8 08 ff ff ff       	call   8010287c <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102974:	8b 45 0c             	mov    0xc(%ebp),%eax
80102977:	c1 e0 18             	shl    $0x18,%eax
8010297a:	8b 55 08             	mov    0x8(%ebp),%edx
8010297d:	83 c2 08             	add    $0x8,%edx
80102980:	01 d2                	add    %edx,%edx
80102982:	83 c2 01             	add    $0x1,%edx
80102985:	89 44 24 04          	mov    %eax,0x4(%esp)
80102989:	89 14 24             	mov    %edx,(%esp)
8010298c:	e8 eb fe ff ff       	call   8010287c <ioapicwrite>
}
80102991:	c9                   	leave  
80102992:	c3                   	ret    

80102993 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102993:	55                   	push   %ebp
80102994:	89 e5                	mov    %esp,%ebp
80102996:	8b 45 08             	mov    0x8(%ebp),%eax
80102999:	05 00 00 00 80       	add    $0x80000000,%eax
8010299e:	5d                   	pop    %ebp
8010299f:	c3                   	ret    

801029a0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801029a0:	55                   	push   %ebp
801029a1:	89 e5                	mov    %esp,%ebp
801029a3:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
801029a6:	c7 44 24 04 aa 81 10 	movl   $0x801081aa,0x4(%esp)
801029ad:	80 
801029ae:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
801029b5:	e8 6b 20 00 00       	call   80104a25 <initlock>
  kmem.use_lock = 0;
801029ba:	c7 05 74 f8 10 80 00 	movl   $0x0,0x8010f874
801029c1:	00 00 00 
  freerange(vstart, vend);
801029c4:	8b 45 0c             	mov    0xc(%ebp),%eax
801029c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801029cb:	8b 45 08             	mov    0x8(%ebp),%eax
801029ce:	89 04 24             	mov    %eax,(%esp)
801029d1:	e8 26 00 00 00       	call   801029fc <freerange>
}
801029d6:	c9                   	leave  
801029d7:	c3                   	ret    

801029d8 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
801029d8:	55                   	push   %ebp
801029d9:	89 e5                	mov    %esp,%ebp
801029db:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
801029de:	8b 45 0c             	mov    0xc(%ebp),%eax
801029e1:	89 44 24 04          	mov    %eax,0x4(%esp)
801029e5:	8b 45 08             	mov    0x8(%ebp),%eax
801029e8:	89 04 24             	mov    %eax,(%esp)
801029eb:	e8 0c 00 00 00       	call   801029fc <freerange>
  kmem.use_lock = 1;
801029f0:	c7 05 74 f8 10 80 01 	movl   $0x1,0x8010f874
801029f7:	00 00 00 
}
801029fa:	c9                   	leave  
801029fb:	c3                   	ret    

801029fc <freerange>:

void
freerange(void *vstart, void *vend)
{
801029fc:	55                   	push   %ebp
801029fd:	89 e5                	mov    %esp,%ebp
801029ff:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102a02:	8b 45 08             	mov    0x8(%ebp),%eax
80102a05:	05 ff 0f 00 00       	add    $0xfff,%eax
80102a0a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102a0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a12:	eb 12                	jmp    80102a26 <freerange+0x2a>
    kfree(p);
80102a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a17:	89 04 24             	mov    %eax,(%esp)
80102a1a:	e8 16 00 00 00       	call   80102a35 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a1f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a29:	05 00 10 00 00       	add    $0x1000,%eax
80102a2e:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102a31:	76 e1                	jbe    80102a14 <freerange+0x18>
    kfree(p);
}
80102a33:	c9                   	leave  
80102a34:	c3                   	ret    

80102a35 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102a35:	55                   	push   %ebp
80102a36:	89 e5                	mov    %esp,%ebp
80102a38:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102a3b:	8b 45 08             	mov    0x8(%ebp),%eax
80102a3e:	25 ff 0f 00 00       	and    $0xfff,%eax
80102a43:	85 c0                	test   %eax,%eax
80102a45:	75 1b                	jne    80102a62 <kfree+0x2d>
80102a47:	81 7d 08 fc 26 11 80 	cmpl   $0x801126fc,0x8(%ebp)
80102a4e:	72 12                	jb     80102a62 <kfree+0x2d>
80102a50:	8b 45 08             	mov    0x8(%ebp),%eax
80102a53:	89 04 24             	mov    %eax,(%esp)
80102a56:	e8 38 ff ff ff       	call   80102993 <v2p>
80102a5b:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102a60:	76 0c                	jbe    80102a6e <kfree+0x39>
    panic("kfree");
80102a62:	c7 04 24 af 81 10 80 	movl   $0x801081af,(%esp)
80102a69:	e8 cc da ff ff       	call   8010053a <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a6e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102a75:	00 
80102a76:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102a7d:	00 
80102a7e:	8b 45 08             	mov    0x8(%ebp),%eax
80102a81:	89 04 24             	mov    %eax,(%esp)
80102a84:	e8 11 22 00 00       	call   80104c9a <memset>

  if(kmem.use_lock)
80102a89:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102a8e:	85 c0                	test   %eax,%eax
80102a90:	74 0c                	je     80102a9e <kfree+0x69>
    acquire(&kmem.lock);
80102a92:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102a99:	e8 a8 1f 00 00       	call   80104a46 <acquire>
  r = (struct run*)v;
80102a9e:	8b 45 08             	mov    0x8(%ebp),%eax
80102aa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102aa4:	8b 15 78 f8 10 80    	mov    0x8010f878,%edx
80102aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aad:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ab2:	a3 78 f8 10 80       	mov    %eax,0x8010f878
  if(kmem.use_lock)
80102ab7:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102abc:	85 c0                	test   %eax,%eax
80102abe:	74 0c                	je     80102acc <kfree+0x97>
    release(&kmem.lock);
80102ac0:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102ac7:	e8 dc 1f 00 00       	call   80104aa8 <release>
}
80102acc:	c9                   	leave  
80102acd:	c3                   	ret    

80102ace <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102ace:	55                   	push   %ebp
80102acf:	89 e5                	mov    %esp,%ebp
80102ad1:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102ad4:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102ad9:	85 c0                	test   %eax,%eax
80102adb:	74 0c                	je     80102ae9 <kalloc+0x1b>
    acquire(&kmem.lock);
80102add:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102ae4:	e8 5d 1f 00 00       	call   80104a46 <acquire>
  r = kmem.freelist;
80102ae9:	a1 78 f8 10 80       	mov    0x8010f878,%eax
80102aee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102af1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102af5:	74 0a                	je     80102b01 <kalloc+0x33>
    kmem.freelist = r->next;
80102af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102afa:	8b 00                	mov    (%eax),%eax
80102afc:	a3 78 f8 10 80       	mov    %eax,0x8010f878
  if(kmem.use_lock)
80102b01:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102b06:	85 c0                	test   %eax,%eax
80102b08:	74 0c                	je     80102b16 <kalloc+0x48>
    release(&kmem.lock);
80102b0a:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102b11:	e8 92 1f 00 00       	call   80104aa8 <release>
  return (char*)r;
80102b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102b19:	c9                   	leave  
80102b1a:	c3                   	ret    

80102b1b <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102b1b:	55                   	push   %ebp
80102b1c:	89 e5                	mov    %esp,%ebp
80102b1e:	83 ec 14             	sub    $0x14,%esp
80102b21:	8b 45 08             	mov    0x8(%ebp),%eax
80102b24:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b28:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102b2c:	89 c2                	mov    %eax,%edx
80102b2e:	ec                   	in     (%dx),%al
80102b2f:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102b32:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102b36:	c9                   	leave  
80102b37:	c3                   	ret    

80102b38 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102b38:	55                   	push   %ebp
80102b39:	89 e5                	mov    %esp,%ebp
80102b3b:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102b3e:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102b45:	e8 d1 ff ff ff       	call   80102b1b <inb>
80102b4a:	0f b6 c0             	movzbl %al,%eax
80102b4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b53:	83 e0 01             	and    $0x1,%eax
80102b56:	85 c0                	test   %eax,%eax
80102b58:	75 0a                	jne    80102b64 <kbdgetc+0x2c>
    return -1;
80102b5a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102b5f:	e9 25 01 00 00       	jmp    80102c89 <kbdgetc+0x151>
  data = inb(KBDATAP);
80102b64:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102b6b:	e8 ab ff ff ff       	call   80102b1b <inb>
80102b70:	0f b6 c0             	movzbl %al,%eax
80102b73:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102b76:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102b7d:	75 17                	jne    80102b96 <kbdgetc+0x5e>
    shift |= E0ESC;
80102b7f:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102b84:	83 c8 40             	or     $0x40,%eax
80102b87:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102b8c:	b8 00 00 00 00       	mov    $0x0,%eax
80102b91:	e9 f3 00 00 00       	jmp    80102c89 <kbdgetc+0x151>
  } else if(data & 0x80){
80102b96:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102b99:	25 80 00 00 00       	and    $0x80,%eax
80102b9e:	85 c0                	test   %eax,%eax
80102ba0:	74 45                	je     80102be7 <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102ba2:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102ba7:	83 e0 40             	and    $0x40,%eax
80102baa:	85 c0                	test   %eax,%eax
80102bac:	75 08                	jne    80102bb6 <kbdgetc+0x7e>
80102bae:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bb1:	83 e0 7f             	and    $0x7f,%eax
80102bb4:	eb 03                	jmp    80102bb9 <kbdgetc+0x81>
80102bb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bb9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102bbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bbf:	05 20 90 10 80       	add    $0x80109020,%eax
80102bc4:	0f b6 00             	movzbl (%eax),%eax
80102bc7:	83 c8 40             	or     $0x40,%eax
80102bca:	0f b6 c0             	movzbl %al,%eax
80102bcd:	f7 d0                	not    %eax
80102bcf:	89 c2                	mov    %eax,%edx
80102bd1:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102bd6:	21 d0                	and    %edx,%eax
80102bd8:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102bdd:	b8 00 00 00 00       	mov    $0x0,%eax
80102be2:	e9 a2 00 00 00       	jmp    80102c89 <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102be7:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102bec:	83 e0 40             	and    $0x40,%eax
80102bef:	85 c0                	test   %eax,%eax
80102bf1:	74 14                	je     80102c07 <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102bf3:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102bfa:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102bff:	83 e0 bf             	and    $0xffffffbf,%eax
80102c02:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  }

  shift |= shiftcode[data];
80102c07:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c0a:	05 20 90 10 80       	add    $0x80109020,%eax
80102c0f:	0f b6 00             	movzbl (%eax),%eax
80102c12:	0f b6 d0             	movzbl %al,%edx
80102c15:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c1a:	09 d0                	or     %edx,%eax
80102c1c:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  shift ^= togglecode[data];
80102c21:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c24:	05 20 91 10 80       	add    $0x80109120,%eax
80102c29:	0f b6 00             	movzbl (%eax),%eax
80102c2c:	0f b6 d0             	movzbl %al,%edx
80102c2f:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c34:	31 d0                	xor    %edx,%eax
80102c36:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  c = charcode[shift & (CTL | SHIFT)][data];
80102c3b:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c40:	83 e0 03             	and    $0x3,%eax
80102c43:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102c4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c4d:	01 d0                	add    %edx,%eax
80102c4f:	0f b6 00             	movzbl (%eax),%eax
80102c52:	0f b6 c0             	movzbl %al,%eax
80102c55:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102c58:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c5d:	83 e0 08             	and    $0x8,%eax
80102c60:	85 c0                	test   %eax,%eax
80102c62:	74 22                	je     80102c86 <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102c64:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102c68:	76 0c                	jbe    80102c76 <kbdgetc+0x13e>
80102c6a:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102c6e:	77 06                	ja     80102c76 <kbdgetc+0x13e>
      c += 'A' - 'a';
80102c70:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102c74:	eb 10                	jmp    80102c86 <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102c76:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102c7a:	76 0a                	jbe    80102c86 <kbdgetc+0x14e>
80102c7c:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102c80:	77 04                	ja     80102c86 <kbdgetc+0x14e>
      c += 'a' - 'A';
80102c82:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102c86:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102c89:	c9                   	leave  
80102c8a:	c3                   	ret    

80102c8b <kbdintr>:

void
kbdintr(void)
{
80102c8b:	55                   	push   %ebp
80102c8c:	89 e5                	mov    %esp,%ebp
80102c8e:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102c91:	c7 04 24 38 2b 10 80 	movl   $0x80102b38,(%esp)
80102c98:	e8 10 db ff ff       	call   801007ad <consoleintr>
}
80102c9d:	c9                   	leave  
80102c9e:	c3                   	ret    

80102c9f <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102c9f:	55                   	push   %ebp
80102ca0:	89 e5                	mov    %esp,%ebp
80102ca2:	83 ec 08             	sub    $0x8,%esp
80102ca5:	8b 55 08             	mov    0x8(%ebp),%edx
80102ca8:	8b 45 0c             	mov    0xc(%ebp),%eax
80102cab:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102caf:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cb2:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102cb6:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102cba:	ee                   	out    %al,(%dx)
}
80102cbb:	c9                   	leave  
80102cbc:	c3                   	ret    

80102cbd <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102cbd:	55                   	push   %ebp
80102cbe:	89 e5                	mov    %esp,%ebp
80102cc0:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102cc3:	9c                   	pushf  
80102cc4:	58                   	pop    %eax
80102cc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102cc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102ccb:	c9                   	leave  
80102ccc:	c3                   	ret    

80102ccd <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102ccd:	55                   	push   %ebp
80102cce:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102cd0:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102cd5:	8b 55 08             	mov    0x8(%ebp),%edx
80102cd8:	c1 e2 02             	shl    $0x2,%edx
80102cdb:	01 c2                	add    %eax,%edx
80102cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ce0:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102ce2:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102ce7:	83 c0 20             	add    $0x20,%eax
80102cea:	8b 00                	mov    (%eax),%eax
}
80102cec:	5d                   	pop    %ebp
80102ced:	c3                   	ret    

80102cee <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102cee:	55                   	push   %ebp
80102cef:	89 e5                	mov    %esp,%ebp
80102cf1:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102cf4:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102cf9:	85 c0                	test   %eax,%eax
80102cfb:	75 05                	jne    80102d02 <lapicinit+0x14>
    return;
80102cfd:	e9 43 01 00 00       	jmp    80102e45 <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102d02:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102d09:	00 
80102d0a:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102d11:	e8 b7 ff ff ff       	call   80102ccd <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102d16:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102d1d:	00 
80102d1e:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102d25:	e8 a3 ff ff ff       	call   80102ccd <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102d2a:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102d31:	00 
80102d32:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102d39:	e8 8f ff ff ff       	call   80102ccd <lapicw>
  lapicw(TICR, 10000000); 
80102d3e:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102d45:	00 
80102d46:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102d4d:	e8 7b ff ff ff       	call   80102ccd <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102d52:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102d59:	00 
80102d5a:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102d61:	e8 67 ff ff ff       	call   80102ccd <lapicw>
  lapicw(LINT1, MASKED);
80102d66:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102d6d:	00 
80102d6e:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102d75:	e8 53 ff ff ff       	call   80102ccd <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102d7a:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102d7f:	83 c0 30             	add    $0x30,%eax
80102d82:	8b 00                	mov    (%eax),%eax
80102d84:	c1 e8 10             	shr    $0x10,%eax
80102d87:	0f b6 c0             	movzbl %al,%eax
80102d8a:	83 f8 03             	cmp    $0x3,%eax
80102d8d:	76 14                	jbe    80102da3 <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
80102d8f:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102d96:	00 
80102d97:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102d9e:	e8 2a ff ff ff       	call   80102ccd <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102da3:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102daa:	00 
80102dab:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102db2:	e8 16 ff ff ff       	call   80102ccd <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102db7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102dbe:	00 
80102dbf:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102dc6:	e8 02 ff ff ff       	call   80102ccd <lapicw>
  lapicw(ESR, 0);
80102dcb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102dd2:	00 
80102dd3:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102dda:	e8 ee fe ff ff       	call   80102ccd <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102ddf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102de6:	00 
80102de7:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102dee:	e8 da fe ff ff       	call   80102ccd <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102df3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102dfa:	00 
80102dfb:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102e02:	e8 c6 fe ff ff       	call   80102ccd <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102e07:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102e0e:	00 
80102e0f:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102e16:	e8 b2 fe ff ff       	call   80102ccd <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102e1b:	90                   	nop
80102e1c:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102e21:	05 00 03 00 00       	add    $0x300,%eax
80102e26:	8b 00                	mov    (%eax),%eax
80102e28:	25 00 10 00 00       	and    $0x1000,%eax
80102e2d:	85 c0                	test   %eax,%eax
80102e2f:	75 eb                	jne    80102e1c <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102e31:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e38:	00 
80102e39:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102e40:	e8 88 fe ff ff       	call   80102ccd <lapicw>
}
80102e45:	c9                   	leave  
80102e46:	c3                   	ret    

80102e47 <cpunum>:

int
cpunum(void)
{
80102e47:	55                   	push   %ebp
80102e48:	89 e5                	mov    %esp,%ebp
80102e4a:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102e4d:	e8 6b fe ff ff       	call   80102cbd <readeflags>
80102e52:	25 00 02 00 00       	and    $0x200,%eax
80102e57:	85 c0                	test   %eax,%eax
80102e59:	74 25                	je     80102e80 <cpunum+0x39>
    static int n;
    if(n++ == 0)
80102e5b:	a1 40 b6 10 80       	mov    0x8010b640,%eax
80102e60:	8d 50 01             	lea    0x1(%eax),%edx
80102e63:	89 15 40 b6 10 80    	mov    %edx,0x8010b640
80102e69:	85 c0                	test   %eax,%eax
80102e6b:	75 13                	jne    80102e80 <cpunum+0x39>
      cprintf("cpu called from %x with interrupts enabled\n",
80102e6d:	8b 45 04             	mov    0x4(%ebp),%eax
80102e70:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e74:	c7 04 24 b8 81 10 80 	movl   $0x801081b8,(%esp)
80102e7b:	e8 20 d5 ff ff       	call   801003a0 <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102e80:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102e85:	85 c0                	test   %eax,%eax
80102e87:	74 0f                	je     80102e98 <cpunum+0x51>
    return lapic[ID]>>24;
80102e89:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102e8e:	83 c0 20             	add    $0x20,%eax
80102e91:	8b 00                	mov    (%eax),%eax
80102e93:	c1 e8 18             	shr    $0x18,%eax
80102e96:	eb 05                	jmp    80102e9d <cpunum+0x56>
  return 0;
80102e98:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102e9d:	c9                   	leave  
80102e9e:	c3                   	ret    

80102e9f <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102e9f:	55                   	push   %ebp
80102ea0:	89 e5                	mov    %esp,%ebp
80102ea2:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102ea5:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102eaa:	85 c0                	test   %eax,%eax
80102eac:	74 14                	je     80102ec2 <lapiceoi+0x23>
    lapicw(EOI, 0);
80102eae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102eb5:	00 
80102eb6:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102ebd:	e8 0b fe ff ff       	call   80102ccd <lapicw>
}
80102ec2:	c9                   	leave  
80102ec3:	c3                   	ret    

80102ec4 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102ec4:	55                   	push   %ebp
80102ec5:	89 e5                	mov    %esp,%ebp
}
80102ec7:	5d                   	pop    %ebp
80102ec8:	c3                   	ret    

80102ec9 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102ec9:	55                   	push   %ebp
80102eca:	89 e5                	mov    %esp,%ebp
80102ecc:	83 ec 1c             	sub    $0x1c,%esp
80102ecf:	8b 45 08             	mov    0x8(%ebp),%eax
80102ed2:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
80102ed5:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102edc:	00 
80102edd:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102ee4:	e8 b6 fd ff ff       	call   80102c9f <outb>
  outb(IO_RTC+1, 0x0A);
80102ee9:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102ef0:	00 
80102ef1:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102ef8:	e8 a2 fd ff ff       	call   80102c9f <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102efd:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102f04:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f07:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102f0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f0f:	8d 50 02             	lea    0x2(%eax),%edx
80102f12:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f15:	c1 e8 04             	shr    $0x4,%eax
80102f18:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102f1b:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102f1f:	c1 e0 18             	shl    $0x18,%eax
80102f22:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f26:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f2d:	e8 9b fd ff ff       	call   80102ccd <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102f32:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80102f39:	00 
80102f3a:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f41:	e8 87 fd ff ff       	call   80102ccd <lapicw>
  microdelay(200);
80102f46:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102f4d:	e8 72 ff ff ff       	call   80102ec4 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80102f52:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80102f59:	00 
80102f5a:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f61:	e8 67 fd ff ff       	call   80102ccd <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102f66:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102f6d:	e8 52 ff ff ff       	call   80102ec4 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102f72:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80102f79:	eb 40                	jmp    80102fbb <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
80102f7b:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102f7f:	c1 e0 18             	shl    $0x18,%eax
80102f82:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f86:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f8d:	e8 3b fd ff ff       	call   80102ccd <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80102f92:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f95:	c1 e8 0c             	shr    $0xc,%eax
80102f98:	80 cc 06             	or     $0x6,%ah
80102f9b:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f9f:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fa6:	e8 22 fd ff ff       	call   80102ccd <lapicw>
    microdelay(200);
80102fab:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102fb2:	e8 0d ff ff ff       	call   80102ec4 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102fb7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80102fbb:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80102fbf:	7e ba                	jle    80102f7b <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102fc1:	c9                   	leave  
80102fc2:	c3                   	ret    

80102fc3 <initlog>:

static void recover_from_log(void);

void
initlog(void)
{
80102fc3:	55                   	push   %ebp
80102fc4:	89 e5                	mov    %esp,%ebp
80102fc6:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102fc9:	c7 44 24 04 e4 81 10 	movl   $0x801081e4,0x4(%esp)
80102fd0:	80 
80102fd1:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80102fd8:	e8 48 1a 00 00       	call   80104a25 <initlock>
  readsb(ROOTDEV, &sb);
80102fdd:	8d 45 e8             	lea    -0x18(%ebp),%eax
80102fe0:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fe4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102feb:	e8 ed e2 ff ff       	call   801012dd <readsb>
  log.start = sb.size - sb.nlog;
80102ff0:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ff6:	29 c2                	sub    %eax,%edx
80102ff8:	89 d0                	mov    %edx,%eax
80102ffa:	a3 b4 f8 10 80       	mov    %eax,0x8010f8b4
  log.size = sb.nlog;
80102fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103002:	a3 b8 f8 10 80       	mov    %eax,0x8010f8b8
  log.dev = ROOTDEV;
80103007:	c7 05 c0 f8 10 80 01 	movl   $0x1,0x8010f8c0
8010300e:	00 00 00 
  recover_from_log();
80103011:	e8 9a 01 00 00       	call   801031b0 <recover_from_log>
}
80103016:	c9                   	leave  
80103017:	c3                   	ret    

80103018 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103018:	55                   	push   %ebp
80103019:	89 e5                	mov    %esp,%ebp
8010301b:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010301e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103025:	e9 8c 00 00 00       	jmp    801030b6 <install_trans+0x9e>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
8010302a:	8b 15 b4 f8 10 80    	mov    0x8010f8b4,%edx
80103030:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103033:	01 d0                	add    %edx,%eax
80103035:	83 c0 01             	add    $0x1,%eax
80103038:	89 c2                	mov    %eax,%edx
8010303a:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
8010303f:	89 54 24 04          	mov    %edx,0x4(%esp)
80103043:	89 04 24             	mov    %eax,(%esp)
80103046:	e8 5b d1 ff ff       	call   801001a6 <bread>
8010304b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
8010304e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103051:	83 c0 10             	add    $0x10,%eax
80103054:	8b 04 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%eax
8010305b:	89 c2                	mov    %eax,%edx
8010305d:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
80103062:	89 54 24 04          	mov    %edx,0x4(%esp)
80103066:	89 04 24             	mov    %eax,(%esp)
80103069:	e8 38 d1 ff ff       	call   801001a6 <bread>
8010306e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103071:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103074:	8d 50 18             	lea    0x18(%eax),%edx
80103077:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010307a:	83 c0 18             	add    $0x18,%eax
8010307d:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103084:	00 
80103085:	89 54 24 04          	mov    %edx,0x4(%esp)
80103089:	89 04 24             	mov    %eax,(%esp)
8010308c:	e8 d8 1c 00 00       	call   80104d69 <memmove>
    bwrite(dbuf);  // write dst to disk
80103091:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103094:	89 04 24             	mov    %eax,(%esp)
80103097:	e8 41 d1 ff ff       	call   801001dd <bwrite>
    brelse(lbuf); 
8010309c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010309f:	89 04 24             	mov    %eax,(%esp)
801030a2:	e8 70 d1 ff ff       	call   80100217 <brelse>
    brelse(dbuf);
801030a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801030aa:	89 04 24             	mov    %eax,(%esp)
801030ad:	e8 65 d1 ff ff       	call   80100217 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801030b2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801030b6:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801030bb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801030be:	0f 8f 66 ff ff ff    	jg     8010302a <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
801030c4:	c9                   	leave  
801030c5:	c3                   	ret    

801030c6 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801030c6:	55                   	push   %ebp
801030c7:	89 e5                	mov    %esp,%ebp
801030c9:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
801030cc:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
801030d1:	89 c2                	mov    %eax,%edx
801030d3:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
801030d8:	89 54 24 04          	mov    %edx,0x4(%esp)
801030dc:	89 04 24             	mov    %eax,(%esp)
801030df:	e8 c2 d0 ff ff       	call   801001a6 <bread>
801030e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801030e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801030ea:	83 c0 18             	add    $0x18,%eax
801030ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801030f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801030f3:	8b 00                	mov    (%eax),%eax
801030f5:	a3 c4 f8 10 80       	mov    %eax,0x8010f8c4
  for (i = 0; i < log.lh.n; i++) {
801030fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103101:	eb 1b                	jmp    8010311e <read_head+0x58>
    log.lh.sector[i] = lh->sector[i];
80103103:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103106:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103109:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
8010310d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103110:	83 c2 10             	add    $0x10,%edx
80103113:	89 04 95 88 f8 10 80 	mov    %eax,-0x7fef0778(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
8010311a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010311e:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103123:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103126:	7f db                	jg     80103103 <read_head+0x3d>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
80103128:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010312b:	89 04 24             	mov    %eax,(%esp)
8010312e:	e8 e4 d0 ff ff       	call   80100217 <brelse>
}
80103133:	c9                   	leave  
80103134:	c3                   	ret    

80103135 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103135:	55                   	push   %ebp
80103136:	89 e5                	mov    %esp,%ebp
80103138:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
8010313b:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
80103140:	89 c2                	mov    %eax,%edx
80103142:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
80103147:	89 54 24 04          	mov    %edx,0x4(%esp)
8010314b:	89 04 24             	mov    %eax,(%esp)
8010314e:	e8 53 d0 ff ff       	call   801001a6 <bread>
80103153:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103156:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103159:	83 c0 18             	add    $0x18,%eax
8010315c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
8010315f:	8b 15 c4 f8 10 80    	mov    0x8010f8c4,%edx
80103165:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103168:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010316a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103171:	eb 1b                	jmp    8010318e <write_head+0x59>
    hb->sector[i] = log.lh.sector[i];
80103173:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103176:	83 c0 10             	add    $0x10,%eax
80103179:	8b 0c 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%ecx
80103180:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103183:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103186:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
8010318a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010318e:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103193:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103196:	7f db                	jg     80103173 <write_head+0x3e>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
80103198:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010319b:	89 04 24             	mov    %eax,(%esp)
8010319e:	e8 3a d0 ff ff       	call   801001dd <bwrite>
  brelse(buf);
801031a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031a6:	89 04 24             	mov    %eax,(%esp)
801031a9:	e8 69 d0 ff ff       	call   80100217 <brelse>
}
801031ae:	c9                   	leave  
801031af:	c3                   	ret    

801031b0 <recover_from_log>:

static void
recover_from_log(void)
{
801031b0:	55                   	push   %ebp
801031b1:	89 e5                	mov    %esp,%ebp
801031b3:	83 ec 08             	sub    $0x8,%esp
  read_head();      
801031b6:	e8 0b ff ff ff       	call   801030c6 <read_head>
  install_trans(); // if committed, copy from log to disk
801031bb:	e8 58 fe ff ff       	call   80103018 <install_trans>
  log.lh.n = 0;
801031c0:	c7 05 c4 f8 10 80 00 	movl   $0x0,0x8010f8c4
801031c7:	00 00 00 
  write_head(); // clear the log
801031ca:	e8 66 ff ff ff       	call   80103135 <write_head>
}
801031cf:	c9                   	leave  
801031d0:	c3                   	ret    

801031d1 <begin_trans>:

void
begin_trans(void)
{
801031d1:	55                   	push   %ebp
801031d2:	89 e5                	mov    %esp,%ebp
801031d4:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
801031d7:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801031de:	e8 63 18 00 00       	call   80104a46 <acquire>
  while (log.busy) {
801031e3:	eb 14                	jmp    801031f9 <begin_trans+0x28>
    sleep(&log, &log.lock);
801031e5:	c7 44 24 04 80 f8 10 	movl   $0x8010f880,0x4(%esp)
801031ec:	80 
801031ed:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801031f4:	e8 83 15 00 00       	call   8010477c <sleep>

void
begin_trans(void)
{
  acquire(&log.lock);
  while (log.busy) {
801031f9:	a1 bc f8 10 80       	mov    0x8010f8bc,%eax
801031fe:	85 c0                	test   %eax,%eax
80103200:	75 e3                	jne    801031e5 <begin_trans+0x14>
    sleep(&log, &log.lock);
  }
  log.busy = 1;
80103202:	c7 05 bc f8 10 80 01 	movl   $0x1,0x8010f8bc
80103209:	00 00 00 
  release(&log.lock);
8010320c:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80103213:	e8 90 18 00 00       	call   80104aa8 <release>
}
80103218:	c9                   	leave  
80103219:	c3                   	ret    

8010321a <commit_trans>:

void
commit_trans(void)
{
8010321a:	55                   	push   %ebp
8010321b:	89 e5                	mov    %esp,%ebp
8010321d:	83 ec 18             	sub    $0x18,%esp
  if (log.lh.n > 0) {
80103220:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103225:	85 c0                	test   %eax,%eax
80103227:	7e 19                	jle    80103242 <commit_trans+0x28>
    write_head();    // Write header to disk -- the real commit
80103229:	e8 07 ff ff ff       	call   80103135 <write_head>
    install_trans(); // Now install writes to home locations
8010322e:	e8 e5 fd ff ff       	call   80103018 <install_trans>
    log.lh.n = 0; 
80103233:	c7 05 c4 f8 10 80 00 	movl   $0x0,0x8010f8c4
8010323a:	00 00 00 
    write_head();    // Erase the transaction from the log
8010323d:	e8 f3 fe ff ff       	call   80103135 <write_head>
  }
  
  acquire(&log.lock);
80103242:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80103249:	e8 f8 17 00 00       	call   80104a46 <acquire>
  log.busy = 0;
8010324e:	c7 05 bc f8 10 80 00 	movl   $0x0,0x8010f8bc
80103255:	00 00 00 
  wakeup(&log);
80103258:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
8010325f:	e8 f1 15 00 00       	call   80104855 <wakeup>
  release(&log.lock);
80103264:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
8010326b:	e8 38 18 00 00       	call   80104aa8 <release>
}
80103270:	c9                   	leave  
80103271:	c3                   	ret    

80103272 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103272:	55                   	push   %ebp
80103273:	89 e5                	mov    %esp,%ebp
80103275:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103278:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
8010327d:	83 f8 09             	cmp    $0x9,%eax
80103280:	7f 12                	jg     80103294 <log_write+0x22>
80103282:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103287:	8b 15 b8 f8 10 80    	mov    0x8010f8b8,%edx
8010328d:	83 ea 01             	sub    $0x1,%edx
80103290:	39 d0                	cmp    %edx,%eax
80103292:	7c 0c                	jl     801032a0 <log_write+0x2e>
    panic("too big a transaction");
80103294:	c7 04 24 e8 81 10 80 	movl   $0x801081e8,(%esp)
8010329b:	e8 9a d2 ff ff       	call   8010053a <panic>
  if (!log.busy)
801032a0:	a1 bc f8 10 80       	mov    0x8010f8bc,%eax
801032a5:	85 c0                	test   %eax,%eax
801032a7:	75 0c                	jne    801032b5 <log_write+0x43>
    panic("write outside of trans");
801032a9:	c7 04 24 fe 81 10 80 	movl   $0x801081fe,(%esp)
801032b0:	e8 85 d2 ff ff       	call   8010053a <panic>

  for (i = 0; i < log.lh.n; i++) {
801032b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032bc:	eb 1f                	jmp    801032dd <log_write+0x6b>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
801032be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032c1:	83 c0 10             	add    $0x10,%eax
801032c4:	8b 04 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%eax
801032cb:	89 c2                	mov    %eax,%edx
801032cd:	8b 45 08             	mov    0x8(%ebp),%eax
801032d0:	8b 40 08             	mov    0x8(%eax),%eax
801032d3:	39 c2                	cmp    %eax,%edx
801032d5:	75 02                	jne    801032d9 <log_write+0x67>
      break;
801032d7:	eb 0e                	jmp    801032e7 <log_write+0x75>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (!log.busy)
    panic("write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
801032d9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801032dd:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801032e2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801032e5:	7f d7                	jg     801032be <log_write+0x4c>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
      break;
  }
  log.lh.sector[i] = b->sector;
801032e7:	8b 45 08             	mov    0x8(%ebp),%eax
801032ea:	8b 40 08             	mov    0x8(%eax),%eax
801032ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
801032f0:	83 c2 10             	add    $0x10,%edx
801032f3:	89 04 95 88 f8 10 80 	mov    %eax,-0x7fef0778(,%edx,4)
  struct buf *lbuf = bread(b->dev, log.start+i+1);
801032fa:	8b 15 b4 f8 10 80    	mov    0x8010f8b4,%edx
80103300:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103303:	01 d0                	add    %edx,%eax
80103305:	83 c0 01             	add    $0x1,%eax
80103308:	89 c2                	mov    %eax,%edx
8010330a:	8b 45 08             	mov    0x8(%ebp),%eax
8010330d:	8b 40 04             	mov    0x4(%eax),%eax
80103310:	89 54 24 04          	mov    %edx,0x4(%esp)
80103314:	89 04 24             	mov    %eax,(%esp)
80103317:	e8 8a ce ff ff       	call   801001a6 <bread>
8010331c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(lbuf->data, b->data, BSIZE);
8010331f:	8b 45 08             	mov    0x8(%ebp),%eax
80103322:	8d 50 18             	lea    0x18(%eax),%edx
80103325:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103328:	83 c0 18             	add    $0x18,%eax
8010332b:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103332:	00 
80103333:	89 54 24 04          	mov    %edx,0x4(%esp)
80103337:	89 04 24             	mov    %eax,(%esp)
8010333a:	e8 2a 1a 00 00       	call   80104d69 <memmove>
  bwrite(lbuf);
8010333f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103342:	89 04 24             	mov    %eax,(%esp)
80103345:	e8 93 ce ff ff       	call   801001dd <bwrite>
  brelse(lbuf);
8010334a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010334d:	89 04 24             	mov    %eax,(%esp)
80103350:	e8 c2 ce ff ff       	call   80100217 <brelse>
  if (i == log.lh.n)
80103355:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
8010335a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010335d:	75 0d                	jne    8010336c <log_write+0xfa>
    log.lh.n++;
8010335f:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103364:	83 c0 01             	add    $0x1,%eax
80103367:	a3 c4 f8 10 80       	mov    %eax,0x8010f8c4
  b->flags |= B_DIRTY; // XXX prevent eviction
8010336c:	8b 45 08             	mov    0x8(%ebp),%eax
8010336f:	8b 00                	mov    (%eax),%eax
80103371:	83 c8 04             	or     $0x4,%eax
80103374:	89 c2                	mov    %eax,%edx
80103376:	8b 45 08             	mov    0x8(%ebp),%eax
80103379:	89 10                	mov    %edx,(%eax)
}
8010337b:	c9                   	leave  
8010337c:	c3                   	ret    

8010337d <v2p>:
8010337d:	55                   	push   %ebp
8010337e:	89 e5                	mov    %esp,%ebp
80103380:	8b 45 08             	mov    0x8(%ebp),%eax
80103383:	05 00 00 00 80       	add    $0x80000000,%eax
80103388:	5d                   	pop    %ebp
80103389:	c3                   	ret    

8010338a <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
8010338a:	55                   	push   %ebp
8010338b:	89 e5                	mov    %esp,%ebp
8010338d:	8b 45 08             	mov    0x8(%ebp),%eax
80103390:	05 00 00 00 80       	add    $0x80000000,%eax
80103395:	5d                   	pop    %ebp
80103396:	c3                   	ret    

80103397 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103397:	55                   	push   %ebp
80103398:	89 e5                	mov    %esp,%ebp
8010339a:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010339d:	8b 55 08             	mov    0x8(%ebp),%edx
801033a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801033a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
801033a6:	f0 87 02             	lock xchg %eax,(%edx)
801033a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801033ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801033af:	c9                   	leave  
801033b0:	c3                   	ret    

801033b1 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801033b1:	55                   	push   %ebp
801033b2:	89 e5                	mov    %esp,%ebp
801033b4:	83 e4 f0             	and    $0xfffffff0,%esp
801033b7:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801033ba:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
801033c1:	80 
801033c2:	c7 04 24 fc 26 11 80 	movl   $0x801126fc,(%esp)
801033c9:	e8 d2 f5 ff ff       	call   801029a0 <kinit1>
  kvmalloc();      // kernel page table
801033ce:	e8 5a 44 00 00       	call   8010782d <kvmalloc>
  mpinit();        // collect info about this machine
801033d3:	e8 2a 04 00 00       	call   80103802 <mpinit>
  lapicinit();
801033d8:	e8 11 f9 ff ff       	call   80102cee <lapicinit>
  seginit();       // set up segments
801033dd:	e8 de 3d 00 00       	call   801071c0 <seginit>
  cprintf("\nkernel: initializing all devices\n\n", cpu->id);
801033e2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801033e8:	0f b6 00             	movzbl (%eax),%eax
801033eb:	0f b6 c0             	movzbl %al,%eax
801033ee:	89 44 24 04          	mov    %eax,0x4(%esp)
801033f2:	c7 04 24 18 82 10 80 	movl   $0x80108218,(%esp)
801033f9:	e8 a2 cf ff ff       	call   801003a0 <cprintf>
  picinit();       // interrupt controller
801033fe:	e8 5d 06 00 00       	call   80103a60 <picinit>
  ioapicinit();    // another interrupt controller
80103403:	e8 8e f4 ff ff       	call   80102896 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103408:	e8 74 d6 ff ff       	call   80100a81 <consoleinit>
  uartinit();      // serial port
8010340d:	e8 fd 30 00 00       	call   8010650f <uartinit>
  pinit();         // process table
80103412:	e8 53 0b 00 00       	call   80103f6a <pinit>
  tvinit();        // trap vectors
80103417:	e8 a5 2c 00 00       	call   801060c1 <tvinit>
  binit();         // buffer cache
8010341c:	e8 13 cc ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103421:	e8 d0 da ff ff       	call   80100ef6 <fileinit>
  iinit();         // inode cache
80103426:	e8 65 e1 ff ff       	call   80101590 <iinit>
  ideinit();       // disk
8010342b:	e8 cf f0 ff ff       	call   801024ff <ideinit>
  if(!ismp)
80103430:	a1 04 f9 10 80       	mov    0x8010f904,%eax
80103435:	85 c0                	test   %eax,%eax
80103437:	75 05                	jne    8010343e <main+0x8d>
    timerinit();   // uniprocessor timer
80103439:	e8 ce 2b 00 00       	call   8010600c <timerinit>
  startothers();   // start other processors
8010343e:	e8 63 00 00 00       	call   801034a6 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103443:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
8010344a:	8e 
8010344b:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103452:	e8 81 f5 ff ff       	call   801029d8 <kinit2>
  userinit();      // first user process
80103457:	e8 29 0c 00 00       	call   80104085 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
8010345c:	e8 1a 00 00 00       	call   8010347b <mpmain>

80103461 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103461:	55                   	push   %ebp
80103462:	89 e5                	mov    %esp,%ebp
80103464:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103467:	e8 d8 43 00 00       	call   80107844 <switchkvm>
  seginit();
8010346c:	e8 4f 3d 00 00       	call   801071c0 <seginit>
  lapicinit();
80103471:	e8 78 f8 ff ff       	call   80102cee <lapicinit>
  mpmain();
80103476:	e8 00 00 00 00       	call   8010347b <mpmain>

8010347b <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
8010347b:	55                   	push   %ebp
8010347c:	89 e5                	mov    %esp,%ebp
8010347e:	83 ec 18             	sub    $0x18,%esp
  //cprintf("cpu%d: starting\n", cpu->id);  //Bug with multicore CPUs
  idtinit();       // load idt register
80103481:	e8 af 2d 00 00       	call   80106235 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103486:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010348c:	05 a8 00 00 00       	add    $0xa8,%eax
80103491:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80103498:	00 
80103499:	89 04 24             	mov    %eax,(%esp)
8010349c:	e8 f6 fe ff ff       	call   80103397 <xchg>
  scheduler();     // start running processes
801034a1:	e8 2e 11 00 00       	call   801045d4 <scheduler>

801034a6 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801034a6:	55                   	push   %ebp
801034a7:	89 e5                	mov    %esp,%ebp
801034a9:	53                   	push   %ebx
801034aa:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
801034ad:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
801034b4:	e8 d1 fe ff ff       	call   8010338a <p2v>
801034b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801034bc:	b8 8a 00 00 00       	mov    $0x8a,%eax
801034c1:	89 44 24 08          	mov    %eax,0x8(%esp)
801034c5:	c7 44 24 04 0c b5 10 	movl   $0x8010b50c,0x4(%esp)
801034cc:	80 
801034cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034d0:	89 04 24             	mov    %eax,(%esp)
801034d3:	e8 91 18 00 00       	call   80104d69 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801034d8:	c7 45 f4 20 f9 10 80 	movl   $0x8010f920,-0xc(%ebp)
801034df:	e9 85 00 00 00       	jmp    80103569 <startothers+0xc3>
    if(c == cpus+cpunum())  // We've started already.
801034e4:	e8 5e f9 ff ff       	call   80102e47 <cpunum>
801034e9:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801034ef:	05 20 f9 10 80       	add    $0x8010f920,%eax
801034f4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801034f7:	75 02                	jne    801034fb <startothers+0x55>
      continue;
801034f9:	eb 67                	jmp    80103562 <startothers+0xbc>

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801034fb:	e8 ce f5 ff ff       	call   80102ace <kalloc>
80103500:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103503:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103506:	83 e8 04             	sub    $0x4,%eax
80103509:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010350c:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103512:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103514:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103517:	83 e8 08             	sub    $0x8,%eax
8010351a:	c7 00 61 34 10 80    	movl   $0x80103461,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103520:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103523:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103526:	c7 04 24 00 a0 10 80 	movl   $0x8010a000,(%esp)
8010352d:	e8 4b fe ff ff       	call   8010337d <v2p>
80103532:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103534:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103537:	89 04 24             	mov    %eax,(%esp)
8010353a:	e8 3e fe ff ff       	call   8010337d <v2p>
8010353f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103542:	0f b6 12             	movzbl (%edx),%edx
80103545:	0f b6 d2             	movzbl %dl,%edx
80103548:	89 44 24 04          	mov    %eax,0x4(%esp)
8010354c:	89 14 24             	mov    %edx,(%esp)
8010354f:	e8 75 f9 ff ff       	call   80102ec9 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103554:	90                   	nop
80103555:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103558:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010355e:	85 c0                	test   %eax,%eax
80103560:	74 f3                	je     80103555 <startothers+0xaf>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103562:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103569:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010356e:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103574:	05 20 f9 10 80       	add    $0x8010f920,%eax
80103579:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010357c:	0f 87 62 ff ff ff    	ja     801034e4 <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103582:	83 c4 24             	add    $0x24,%esp
80103585:	5b                   	pop    %ebx
80103586:	5d                   	pop    %ebp
80103587:	c3                   	ret    

80103588 <p2v>:
80103588:	55                   	push   %ebp
80103589:	89 e5                	mov    %esp,%ebp
8010358b:	8b 45 08             	mov    0x8(%ebp),%eax
8010358e:	05 00 00 00 80       	add    $0x80000000,%eax
80103593:	5d                   	pop    %ebp
80103594:	c3                   	ret    

80103595 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103595:	55                   	push   %ebp
80103596:	89 e5                	mov    %esp,%ebp
80103598:	83 ec 14             	sub    $0x14,%esp
8010359b:	8b 45 08             	mov    0x8(%ebp),%eax
8010359e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801035a2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801035a6:	89 c2                	mov    %eax,%edx
801035a8:	ec                   	in     (%dx),%al
801035a9:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801035ac:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801035b0:	c9                   	leave  
801035b1:	c3                   	ret    

801035b2 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801035b2:	55                   	push   %ebp
801035b3:	89 e5                	mov    %esp,%ebp
801035b5:	83 ec 08             	sub    $0x8,%esp
801035b8:	8b 55 08             	mov    0x8(%ebp),%edx
801035bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801035be:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801035c2:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801035c5:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801035c9:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801035cd:	ee                   	out    %al,(%dx)
}
801035ce:	c9                   	leave  
801035cf:	c3                   	ret    

801035d0 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
801035d3:	a1 44 b6 10 80       	mov    0x8010b644,%eax
801035d8:	89 c2                	mov    %eax,%edx
801035da:	b8 20 f9 10 80       	mov    $0x8010f920,%eax
801035df:	29 c2                	sub    %eax,%edx
801035e1:	89 d0                	mov    %edx,%eax
801035e3:	c1 f8 02             	sar    $0x2,%eax
801035e6:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
801035ec:	5d                   	pop    %ebp
801035ed:	c3                   	ret    

801035ee <sum>:

static uchar
sum(uchar *addr, int len)
{
801035ee:	55                   	push   %ebp
801035ef:	89 e5                	mov    %esp,%ebp
801035f1:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
801035f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
801035fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103602:	eb 15                	jmp    80103619 <sum+0x2b>
    sum += addr[i];
80103604:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103607:	8b 45 08             	mov    0x8(%ebp),%eax
8010360a:	01 d0                	add    %edx,%eax
8010360c:	0f b6 00             	movzbl (%eax),%eax
8010360f:	0f b6 c0             	movzbl %al,%eax
80103612:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103615:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103619:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010361c:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010361f:	7c e3                	jl     80103604 <sum+0x16>
    sum += addr[i];
  return sum;
80103621:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103624:	c9                   	leave  
80103625:	c3                   	ret    

80103626 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103626:	55                   	push   %ebp
80103627:	89 e5                	mov    %esp,%ebp
80103629:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
8010362c:	8b 45 08             	mov    0x8(%ebp),%eax
8010362f:	89 04 24             	mov    %eax,(%esp)
80103632:	e8 51 ff ff ff       	call   80103588 <p2v>
80103637:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
8010363a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010363d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103640:	01 d0                	add    %edx,%eax
80103642:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103645:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103648:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010364b:	eb 3f                	jmp    8010368c <mpsearch1+0x66>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010364d:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103654:	00 
80103655:	c7 44 24 04 3c 82 10 	movl   $0x8010823c,0x4(%esp)
8010365c:	80 
8010365d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103660:	89 04 24             	mov    %eax,(%esp)
80103663:	e8 a9 16 00 00       	call   80104d11 <memcmp>
80103668:	85 c0                	test   %eax,%eax
8010366a:	75 1c                	jne    80103688 <mpsearch1+0x62>
8010366c:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103673:	00 
80103674:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103677:	89 04 24             	mov    %eax,(%esp)
8010367a:	e8 6f ff ff ff       	call   801035ee <sum>
8010367f:	84 c0                	test   %al,%al
80103681:	75 05                	jne    80103688 <mpsearch1+0x62>
      return (struct mp*)p;
80103683:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103686:	eb 11                	jmp    80103699 <mpsearch1+0x73>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103688:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010368c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010368f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103692:	72 b9                	jb     8010364d <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103694:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103699:	c9                   	leave  
8010369a:	c3                   	ret    

8010369b <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
8010369b:	55                   	push   %ebp
8010369c:	89 e5                	mov    %esp,%ebp
8010369e:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
801036a1:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801036a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036ab:	83 c0 0f             	add    $0xf,%eax
801036ae:	0f b6 00             	movzbl (%eax),%eax
801036b1:	0f b6 c0             	movzbl %al,%eax
801036b4:	c1 e0 08             	shl    $0x8,%eax
801036b7:	89 c2                	mov    %eax,%edx
801036b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036bc:	83 c0 0e             	add    $0xe,%eax
801036bf:	0f b6 00             	movzbl (%eax),%eax
801036c2:	0f b6 c0             	movzbl %al,%eax
801036c5:	09 d0                	or     %edx,%eax
801036c7:	c1 e0 04             	shl    $0x4,%eax
801036ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
801036cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801036d1:	74 21                	je     801036f4 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
801036d3:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
801036da:	00 
801036db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036de:	89 04 24             	mov    %eax,(%esp)
801036e1:	e8 40 ff ff ff       	call   80103626 <mpsearch1>
801036e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
801036e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801036ed:	74 50                	je     8010373f <mpsearch+0xa4>
      return mp;
801036ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036f2:	eb 5f                	jmp    80103753 <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801036f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036f7:	83 c0 14             	add    $0x14,%eax
801036fa:	0f b6 00             	movzbl (%eax),%eax
801036fd:	0f b6 c0             	movzbl %al,%eax
80103700:	c1 e0 08             	shl    $0x8,%eax
80103703:	89 c2                	mov    %eax,%edx
80103705:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103708:	83 c0 13             	add    $0x13,%eax
8010370b:	0f b6 00             	movzbl (%eax),%eax
8010370e:	0f b6 c0             	movzbl %al,%eax
80103711:	09 d0                	or     %edx,%eax
80103713:	c1 e0 0a             	shl    $0xa,%eax
80103716:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103719:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010371c:	2d 00 04 00 00       	sub    $0x400,%eax
80103721:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103728:	00 
80103729:	89 04 24             	mov    %eax,(%esp)
8010372c:	e8 f5 fe ff ff       	call   80103626 <mpsearch1>
80103731:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103734:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103738:	74 05                	je     8010373f <mpsearch+0xa4>
      return mp;
8010373a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010373d:	eb 14                	jmp    80103753 <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
8010373f:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103746:	00 
80103747:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
8010374e:	e8 d3 fe ff ff       	call   80103626 <mpsearch1>
}
80103753:	c9                   	leave  
80103754:	c3                   	ret    

80103755 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103755:	55                   	push   %ebp
80103756:	89 e5                	mov    %esp,%ebp
80103758:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010375b:	e8 3b ff ff ff       	call   8010369b <mpsearch>
80103760:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103763:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103767:	74 0a                	je     80103773 <mpconfig+0x1e>
80103769:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010376c:	8b 40 04             	mov    0x4(%eax),%eax
8010376f:	85 c0                	test   %eax,%eax
80103771:	75 0a                	jne    8010377d <mpconfig+0x28>
    return 0;
80103773:	b8 00 00 00 00       	mov    $0x0,%eax
80103778:	e9 83 00 00 00       	jmp    80103800 <mpconfig+0xab>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
8010377d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103780:	8b 40 04             	mov    0x4(%eax),%eax
80103783:	89 04 24             	mov    %eax,(%esp)
80103786:	e8 fd fd ff ff       	call   80103588 <p2v>
8010378b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010378e:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103795:	00 
80103796:	c7 44 24 04 41 82 10 	movl   $0x80108241,0x4(%esp)
8010379d:	80 
8010379e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037a1:	89 04 24             	mov    %eax,(%esp)
801037a4:	e8 68 15 00 00       	call   80104d11 <memcmp>
801037a9:	85 c0                	test   %eax,%eax
801037ab:	74 07                	je     801037b4 <mpconfig+0x5f>
    return 0;
801037ad:	b8 00 00 00 00       	mov    $0x0,%eax
801037b2:	eb 4c                	jmp    80103800 <mpconfig+0xab>
  if(conf->version != 1 && conf->version != 4)
801037b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037b7:	0f b6 40 06          	movzbl 0x6(%eax),%eax
801037bb:	3c 01                	cmp    $0x1,%al
801037bd:	74 12                	je     801037d1 <mpconfig+0x7c>
801037bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037c2:	0f b6 40 06          	movzbl 0x6(%eax),%eax
801037c6:	3c 04                	cmp    $0x4,%al
801037c8:	74 07                	je     801037d1 <mpconfig+0x7c>
    return 0;
801037ca:	b8 00 00 00 00       	mov    $0x0,%eax
801037cf:	eb 2f                	jmp    80103800 <mpconfig+0xab>
  if(sum((uchar*)conf, conf->length) != 0)
801037d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037d4:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801037d8:	0f b7 c0             	movzwl %ax,%eax
801037db:	89 44 24 04          	mov    %eax,0x4(%esp)
801037df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037e2:	89 04 24             	mov    %eax,(%esp)
801037e5:	e8 04 fe ff ff       	call   801035ee <sum>
801037ea:	84 c0                	test   %al,%al
801037ec:	74 07                	je     801037f5 <mpconfig+0xa0>
    return 0;
801037ee:	b8 00 00 00 00       	mov    $0x0,%eax
801037f3:	eb 0b                	jmp    80103800 <mpconfig+0xab>
  *pmp = mp;
801037f5:	8b 45 08             	mov    0x8(%ebp),%eax
801037f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801037fb:	89 10                	mov    %edx,(%eax)
  return conf;
801037fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103800:	c9                   	leave  
80103801:	c3                   	ret    

80103802 <mpinit>:

void
mpinit(void)
{
80103802:	55                   	push   %ebp
80103803:	89 e5                	mov    %esp,%ebp
80103805:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103808:	c7 05 44 b6 10 80 20 	movl   $0x8010f920,0x8010b644
8010380f:	f9 10 80 
  if((conf = mpconfig(&mp)) == 0)
80103812:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103815:	89 04 24             	mov    %eax,(%esp)
80103818:	e8 38 ff ff ff       	call   80103755 <mpconfig>
8010381d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103820:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103824:	75 05                	jne    8010382b <mpinit+0x29>
    return;
80103826:	e9 9c 01 00 00       	jmp    801039c7 <mpinit+0x1c5>
  ismp = 1;
8010382b:	c7 05 04 f9 10 80 01 	movl   $0x1,0x8010f904
80103832:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103835:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103838:	8b 40 24             	mov    0x24(%eax),%eax
8010383b:	a3 7c f8 10 80       	mov    %eax,0x8010f87c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103840:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103843:	83 c0 2c             	add    $0x2c,%eax
80103846:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103849:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010384c:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103850:	0f b7 d0             	movzwl %ax,%edx
80103853:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103856:	01 d0                	add    %edx,%eax
80103858:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010385b:	e9 f4 00 00 00       	jmp    80103954 <mpinit+0x152>
    switch(*p){
80103860:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103863:	0f b6 00             	movzbl (%eax),%eax
80103866:	0f b6 c0             	movzbl %al,%eax
80103869:	83 f8 04             	cmp    $0x4,%eax
8010386c:	0f 87 bf 00 00 00    	ja     80103931 <mpinit+0x12f>
80103872:	8b 04 85 84 82 10 80 	mov    -0x7fef7d7c(,%eax,4),%eax
80103879:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
8010387b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010387e:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103881:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103884:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103888:	0f b6 d0             	movzbl %al,%edx
8010388b:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80103890:	39 c2                	cmp    %eax,%edx
80103892:	74 2d                	je     801038c1 <mpinit+0xbf>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103894:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103897:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010389b:	0f b6 d0             	movzbl %al,%edx
8010389e:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801038a3:	89 54 24 08          	mov    %edx,0x8(%esp)
801038a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801038ab:	c7 04 24 46 82 10 80 	movl   $0x80108246,(%esp)
801038b2:	e8 e9 ca ff ff       	call   801003a0 <cprintf>
        ismp = 0;
801038b7:	c7 05 04 f9 10 80 00 	movl   $0x0,0x8010f904
801038be:	00 00 00 
      }
      if(proc->flags & MPBOOT)
801038c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801038c4:	0f b6 40 03          	movzbl 0x3(%eax),%eax
801038c8:	0f b6 c0             	movzbl %al,%eax
801038cb:	83 e0 02             	and    $0x2,%eax
801038ce:	85 c0                	test   %eax,%eax
801038d0:	74 15                	je     801038e7 <mpinit+0xe5>
        bcpu = &cpus[ncpu];
801038d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801038d7:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801038dd:	05 20 f9 10 80       	add    $0x8010f920,%eax
801038e2:	a3 44 b6 10 80       	mov    %eax,0x8010b644
      cpus[ncpu].id = ncpu;
801038e7:	8b 15 00 ff 10 80    	mov    0x8010ff00,%edx
801038ed:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801038f2:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
801038f8:	81 c2 20 f9 10 80    	add    $0x8010f920,%edx
801038fe:	88 02                	mov    %al,(%edx)
      ncpu++;
80103900:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80103905:	83 c0 01             	add    $0x1,%eax
80103908:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
      p += sizeof(struct mpproc);
8010390d:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103911:	eb 41                	jmp    80103954 <mpinit+0x152>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103913:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103916:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103919:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010391c:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103920:	a2 00 f9 10 80       	mov    %al,0x8010f900
      p += sizeof(struct mpioapic);
80103925:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103929:	eb 29                	jmp    80103954 <mpinit+0x152>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010392b:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
8010392f:	eb 23                	jmp    80103954 <mpinit+0x152>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103931:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103934:	0f b6 00             	movzbl (%eax),%eax
80103937:	0f b6 c0             	movzbl %al,%eax
8010393a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010393e:	c7 04 24 64 82 10 80 	movl   $0x80108264,(%esp)
80103945:	e8 56 ca ff ff       	call   801003a0 <cprintf>
      ismp = 0;
8010394a:	c7 05 04 f9 10 80 00 	movl   $0x0,0x8010f904
80103951:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103954:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103957:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010395a:	0f 82 00 ff ff ff    	jb     80103860 <mpinit+0x5e>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103960:	a1 04 f9 10 80       	mov    0x8010f904,%eax
80103965:	85 c0                	test   %eax,%eax
80103967:	75 1d                	jne    80103986 <mpinit+0x184>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103969:	c7 05 00 ff 10 80 01 	movl   $0x1,0x8010ff00
80103970:	00 00 00 
    lapic = 0;
80103973:	c7 05 7c f8 10 80 00 	movl   $0x0,0x8010f87c
8010397a:	00 00 00 
    ioapicid = 0;
8010397d:	c6 05 00 f9 10 80 00 	movb   $0x0,0x8010f900
    return;
80103984:	eb 41                	jmp    801039c7 <mpinit+0x1c5>
  }

  if(mp->imcrp){
80103986:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103989:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
8010398d:	84 c0                	test   %al,%al
8010398f:	74 36                	je     801039c7 <mpinit+0x1c5>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103991:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103998:	00 
80103999:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
801039a0:	e8 0d fc ff ff       	call   801035b2 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801039a5:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
801039ac:	e8 e4 fb ff ff       	call   80103595 <inb>
801039b1:	83 c8 01             	or     $0x1,%eax
801039b4:	0f b6 c0             	movzbl %al,%eax
801039b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801039bb:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
801039c2:	e8 eb fb ff ff       	call   801035b2 <outb>
  }
}
801039c7:	c9                   	leave  
801039c8:	c3                   	ret    

801039c9 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801039c9:	55                   	push   %ebp
801039ca:	89 e5                	mov    %esp,%ebp
801039cc:	83 ec 08             	sub    $0x8,%esp
801039cf:	8b 55 08             	mov    0x8(%ebp),%edx
801039d2:	8b 45 0c             	mov    0xc(%ebp),%eax
801039d5:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801039d9:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801039dc:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801039e0:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801039e4:	ee                   	out    %al,(%dx)
}
801039e5:	c9                   	leave  
801039e6:	c3                   	ret    

801039e7 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
801039e7:	55                   	push   %ebp
801039e8:	89 e5                	mov    %esp,%ebp
801039ea:	83 ec 0c             	sub    $0xc,%esp
801039ed:	8b 45 08             	mov    0x8(%ebp),%eax
801039f0:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
801039f4:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801039f8:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
801039fe:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a02:	0f b6 c0             	movzbl %al,%eax
80103a05:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a09:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103a10:	e8 b4 ff ff ff       	call   801039c9 <outb>
  outb(IO_PIC2+1, mask >> 8);
80103a15:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a19:	66 c1 e8 08          	shr    $0x8,%ax
80103a1d:	0f b6 c0             	movzbl %al,%eax
80103a20:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a24:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103a2b:	e8 99 ff ff ff       	call   801039c9 <outb>
}
80103a30:	c9                   	leave  
80103a31:	c3                   	ret    

80103a32 <picenable>:

void
picenable(int irq)
{
80103a32:	55                   	push   %ebp
80103a33:	89 e5                	mov    %esp,%ebp
80103a35:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103a38:	8b 45 08             	mov    0x8(%ebp),%eax
80103a3b:	ba 01 00 00 00       	mov    $0x1,%edx
80103a40:	89 c1                	mov    %eax,%ecx
80103a42:	d3 e2                	shl    %cl,%edx
80103a44:	89 d0                	mov    %edx,%eax
80103a46:	f7 d0                	not    %eax
80103a48:	89 c2                	mov    %eax,%edx
80103a4a:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103a51:	21 d0                	and    %edx,%eax
80103a53:	0f b7 c0             	movzwl %ax,%eax
80103a56:	89 04 24             	mov    %eax,(%esp)
80103a59:	e8 89 ff ff ff       	call   801039e7 <picsetmask>
}
80103a5e:	c9                   	leave  
80103a5f:	c3                   	ret    

80103a60 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103a66:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103a6d:	00 
80103a6e:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103a75:	e8 4f ff ff ff       	call   801039c9 <outb>
  outb(IO_PIC2+1, 0xFF);
80103a7a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103a81:	00 
80103a82:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103a89:	e8 3b ff ff ff       	call   801039c9 <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103a8e:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103a95:	00 
80103a96:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103a9d:	e8 27 ff ff ff       	call   801039c9 <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103aa2:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103aa9:	00 
80103aaa:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103ab1:	e8 13 ff ff ff       	call   801039c9 <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103ab6:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103abd:	00 
80103abe:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103ac5:	e8 ff fe ff ff       	call   801039c9 <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103aca:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103ad1:	00 
80103ad2:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103ad9:	e8 eb fe ff ff       	call   801039c9 <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103ade:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103ae5:	00 
80103ae6:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103aed:	e8 d7 fe ff ff       	call   801039c9 <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103af2:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103af9:	00 
80103afa:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b01:	e8 c3 fe ff ff       	call   801039c9 <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103b06:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103b0d:	00 
80103b0e:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b15:	e8 af fe ff ff       	call   801039c9 <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103b1a:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103b21:	00 
80103b22:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b29:	e8 9b fe ff ff       	call   801039c9 <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103b2e:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103b35:	00 
80103b36:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103b3d:	e8 87 fe ff ff       	call   801039c9 <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103b42:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103b49:	00 
80103b4a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103b51:	e8 73 fe ff ff       	call   801039c9 <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103b56:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103b5d:	00 
80103b5e:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103b65:	e8 5f fe ff ff       	call   801039c9 <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103b6a:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103b71:	00 
80103b72:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103b79:	e8 4b fe ff ff       	call   801039c9 <outb>

  if(irqmask != 0xFFFF)
80103b7e:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103b85:	66 83 f8 ff          	cmp    $0xffff,%ax
80103b89:	74 12                	je     80103b9d <picinit+0x13d>
    picsetmask(irqmask);
80103b8b:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103b92:	0f b7 c0             	movzwl %ax,%eax
80103b95:	89 04 24             	mov    %eax,(%esp)
80103b98:	e8 4a fe ff ff       	call   801039e7 <picsetmask>
}
80103b9d:	c9                   	leave  
80103b9e:	c3                   	ret    

80103b9f <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103b9f:	55                   	push   %ebp
80103ba0:	89 e5                	mov    %esp,%ebp
80103ba2:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103ba5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103bac:	8b 45 0c             	mov    0xc(%ebp),%eax
80103baf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
80103bb8:	8b 10                	mov    (%eax),%edx
80103bba:	8b 45 08             	mov    0x8(%ebp),%eax
80103bbd:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103bbf:	e8 4e d3 ff ff       	call   80100f12 <filealloc>
80103bc4:	8b 55 08             	mov    0x8(%ebp),%edx
80103bc7:	89 02                	mov    %eax,(%edx)
80103bc9:	8b 45 08             	mov    0x8(%ebp),%eax
80103bcc:	8b 00                	mov    (%eax),%eax
80103bce:	85 c0                	test   %eax,%eax
80103bd0:	0f 84 c8 00 00 00    	je     80103c9e <pipealloc+0xff>
80103bd6:	e8 37 d3 ff ff       	call   80100f12 <filealloc>
80103bdb:	8b 55 0c             	mov    0xc(%ebp),%edx
80103bde:	89 02                	mov    %eax,(%edx)
80103be0:	8b 45 0c             	mov    0xc(%ebp),%eax
80103be3:	8b 00                	mov    (%eax),%eax
80103be5:	85 c0                	test   %eax,%eax
80103be7:	0f 84 b1 00 00 00    	je     80103c9e <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103bed:	e8 dc ee ff ff       	call   80102ace <kalloc>
80103bf2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103bf5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103bf9:	75 05                	jne    80103c00 <pipealloc+0x61>
    goto bad;
80103bfb:	e9 9e 00 00 00       	jmp    80103c9e <pipealloc+0xff>
  p->readopen = 1;
80103c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c03:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103c0a:	00 00 00 
  p->writeopen = 1;
80103c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c10:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103c17:	00 00 00 
  p->nwrite = 0;
80103c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c1d:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103c24:	00 00 00 
  p->nread = 0;
80103c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c2a:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103c31:	00 00 00 
  initlock(&p->lock, "pipe");
80103c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c37:	c7 44 24 04 98 82 10 	movl   $0x80108298,0x4(%esp)
80103c3e:	80 
80103c3f:	89 04 24             	mov    %eax,(%esp)
80103c42:	e8 de 0d 00 00       	call   80104a25 <initlock>
  (*f0)->type = FD_PIPE;
80103c47:	8b 45 08             	mov    0x8(%ebp),%eax
80103c4a:	8b 00                	mov    (%eax),%eax
80103c4c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103c52:	8b 45 08             	mov    0x8(%ebp),%eax
80103c55:	8b 00                	mov    (%eax),%eax
80103c57:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103c5b:	8b 45 08             	mov    0x8(%ebp),%eax
80103c5e:	8b 00                	mov    (%eax),%eax
80103c60:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103c64:	8b 45 08             	mov    0x8(%ebp),%eax
80103c67:	8b 00                	mov    (%eax),%eax
80103c69:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c6c:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103c6f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c72:	8b 00                	mov    (%eax),%eax
80103c74:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c7d:	8b 00                	mov    (%eax),%eax
80103c7f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103c83:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c86:	8b 00                	mov    (%eax),%eax
80103c88:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c8f:	8b 00                	mov    (%eax),%eax
80103c91:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c94:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103c97:	b8 00 00 00 00       	mov    $0x0,%eax
80103c9c:	eb 42                	jmp    80103ce0 <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
80103c9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103ca2:	74 0b                	je     80103caf <pipealloc+0x110>
    kfree((char*)p);
80103ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ca7:	89 04 24             	mov    %eax,(%esp)
80103caa:	e8 86 ed ff ff       	call   80102a35 <kfree>
  if(*f0)
80103caf:	8b 45 08             	mov    0x8(%ebp),%eax
80103cb2:	8b 00                	mov    (%eax),%eax
80103cb4:	85 c0                	test   %eax,%eax
80103cb6:	74 0d                	je     80103cc5 <pipealloc+0x126>
    fileclose(*f0);
80103cb8:	8b 45 08             	mov    0x8(%ebp),%eax
80103cbb:	8b 00                	mov    (%eax),%eax
80103cbd:	89 04 24             	mov    %eax,(%esp)
80103cc0:	e8 f5 d2 ff ff       	call   80100fba <fileclose>
  if(*f1)
80103cc5:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cc8:	8b 00                	mov    (%eax),%eax
80103cca:	85 c0                	test   %eax,%eax
80103ccc:	74 0d                	je     80103cdb <pipealloc+0x13c>
    fileclose(*f1);
80103cce:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cd1:	8b 00                	mov    (%eax),%eax
80103cd3:	89 04 24             	mov    %eax,(%esp)
80103cd6:	e8 df d2 ff ff       	call   80100fba <fileclose>
  return -1;
80103cdb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103ce0:	c9                   	leave  
80103ce1:	c3                   	ret    

80103ce2 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103ce2:	55                   	push   %ebp
80103ce3:	89 e5                	mov    %esp,%ebp
80103ce5:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80103ce8:	8b 45 08             	mov    0x8(%ebp),%eax
80103ceb:	89 04 24             	mov    %eax,(%esp)
80103cee:	e8 53 0d 00 00       	call   80104a46 <acquire>
  if(writable){
80103cf3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103cf7:	74 1f                	je     80103d18 <pipeclose+0x36>
    p->writeopen = 0;
80103cf9:	8b 45 08             	mov    0x8(%ebp),%eax
80103cfc:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103d03:	00 00 00 
    wakeup(&p->nread);
80103d06:	8b 45 08             	mov    0x8(%ebp),%eax
80103d09:	05 34 02 00 00       	add    $0x234,%eax
80103d0e:	89 04 24             	mov    %eax,(%esp)
80103d11:	e8 3f 0b 00 00       	call   80104855 <wakeup>
80103d16:	eb 1d                	jmp    80103d35 <pipeclose+0x53>
  } else {
    p->readopen = 0;
80103d18:	8b 45 08             	mov    0x8(%ebp),%eax
80103d1b:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103d22:	00 00 00 
    wakeup(&p->nwrite);
80103d25:	8b 45 08             	mov    0x8(%ebp),%eax
80103d28:	05 38 02 00 00       	add    $0x238,%eax
80103d2d:	89 04 24             	mov    %eax,(%esp)
80103d30:	e8 20 0b 00 00       	call   80104855 <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103d35:	8b 45 08             	mov    0x8(%ebp),%eax
80103d38:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103d3e:	85 c0                	test   %eax,%eax
80103d40:	75 25                	jne    80103d67 <pipeclose+0x85>
80103d42:	8b 45 08             	mov    0x8(%ebp),%eax
80103d45:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103d4b:	85 c0                	test   %eax,%eax
80103d4d:	75 18                	jne    80103d67 <pipeclose+0x85>
    release(&p->lock);
80103d4f:	8b 45 08             	mov    0x8(%ebp),%eax
80103d52:	89 04 24             	mov    %eax,(%esp)
80103d55:	e8 4e 0d 00 00       	call   80104aa8 <release>
    kfree((char*)p);
80103d5a:	8b 45 08             	mov    0x8(%ebp),%eax
80103d5d:	89 04 24             	mov    %eax,(%esp)
80103d60:	e8 d0 ec ff ff       	call   80102a35 <kfree>
80103d65:	eb 0b                	jmp    80103d72 <pipeclose+0x90>
  } else
    release(&p->lock);
80103d67:	8b 45 08             	mov    0x8(%ebp),%eax
80103d6a:	89 04 24             	mov    %eax,(%esp)
80103d6d:	e8 36 0d 00 00       	call   80104aa8 <release>
}
80103d72:	c9                   	leave  
80103d73:	c3                   	ret    

80103d74 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103d74:	55                   	push   %ebp
80103d75:	89 e5                	mov    %esp,%ebp
80103d77:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
80103d7a:	8b 45 08             	mov    0x8(%ebp),%eax
80103d7d:	89 04 24             	mov    %eax,(%esp)
80103d80:	e8 c1 0c 00 00       	call   80104a46 <acquire>
  for(i = 0; i < n; i++){
80103d85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103d8c:	e9 a6 00 00 00       	jmp    80103e37 <pipewrite+0xc3>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103d91:	eb 57                	jmp    80103dea <pipewrite+0x76>
      if(p->readopen == 0 || proc->killed){
80103d93:	8b 45 08             	mov    0x8(%ebp),%eax
80103d96:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103d9c:	85 c0                	test   %eax,%eax
80103d9e:	74 0d                	je     80103dad <pipewrite+0x39>
80103da0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103da6:	8b 40 24             	mov    0x24(%eax),%eax
80103da9:	85 c0                	test   %eax,%eax
80103dab:	74 15                	je     80103dc2 <pipewrite+0x4e>
        release(&p->lock);
80103dad:	8b 45 08             	mov    0x8(%ebp),%eax
80103db0:	89 04 24             	mov    %eax,(%esp)
80103db3:	e8 f0 0c 00 00       	call   80104aa8 <release>
        return -1;
80103db8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103dbd:	e9 9f 00 00 00       	jmp    80103e61 <pipewrite+0xed>
      }
      wakeup(&p->nread);
80103dc2:	8b 45 08             	mov    0x8(%ebp),%eax
80103dc5:	05 34 02 00 00       	add    $0x234,%eax
80103dca:	89 04 24             	mov    %eax,(%esp)
80103dcd:	e8 83 0a 00 00       	call   80104855 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103dd2:	8b 45 08             	mov    0x8(%ebp),%eax
80103dd5:	8b 55 08             	mov    0x8(%ebp),%edx
80103dd8:	81 c2 38 02 00 00    	add    $0x238,%edx
80103dde:	89 44 24 04          	mov    %eax,0x4(%esp)
80103de2:	89 14 24             	mov    %edx,(%esp)
80103de5:	e8 92 09 00 00       	call   8010477c <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103dea:	8b 45 08             	mov    0x8(%ebp),%eax
80103ded:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103df3:	8b 45 08             	mov    0x8(%ebp),%eax
80103df6:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103dfc:	05 00 02 00 00       	add    $0x200,%eax
80103e01:	39 c2                	cmp    %eax,%edx
80103e03:	74 8e                	je     80103d93 <pipewrite+0x1f>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103e05:	8b 45 08             	mov    0x8(%ebp),%eax
80103e08:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103e0e:	8d 48 01             	lea    0x1(%eax),%ecx
80103e11:	8b 55 08             	mov    0x8(%ebp),%edx
80103e14:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80103e1a:	25 ff 01 00 00       	and    $0x1ff,%eax
80103e1f:	89 c1                	mov    %eax,%ecx
80103e21:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e24:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e27:	01 d0                	add    %edx,%eax
80103e29:	0f b6 10             	movzbl (%eax),%edx
80103e2c:	8b 45 08             	mov    0x8(%ebp),%eax
80103e2f:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103e33:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e3a:	3b 45 10             	cmp    0x10(%ebp),%eax
80103e3d:	0f 8c 4e ff ff ff    	jl     80103d91 <pipewrite+0x1d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103e43:	8b 45 08             	mov    0x8(%ebp),%eax
80103e46:	05 34 02 00 00       	add    $0x234,%eax
80103e4b:	89 04 24             	mov    %eax,(%esp)
80103e4e:	e8 02 0a 00 00       	call   80104855 <wakeup>
  release(&p->lock);
80103e53:	8b 45 08             	mov    0x8(%ebp),%eax
80103e56:	89 04 24             	mov    %eax,(%esp)
80103e59:	e8 4a 0c 00 00       	call   80104aa8 <release>
  return n;
80103e5e:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103e61:	c9                   	leave  
80103e62:	c3                   	ret    

80103e63 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103e63:	55                   	push   %ebp
80103e64:	89 e5                	mov    %esp,%ebp
80103e66:	53                   	push   %ebx
80103e67:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103e6a:	8b 45 08             	mov    0x8(%ebp),%eax
80103e6d:	89 04 24             	mov    %eax,(%esp)
80103e70:	e8 d1 0b 00 00       	call   80104a46 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103e75:	eb 3a                	jmp    80103eb1 <piperead+0x4e>
    if(proc->killed){
80103e77:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e7d:	8b 40 24             	mov    0x24(%eax),%eax
80103e80:	85 c0                	test   %eax,%eax
80103e82:	74 15                	je     80103e99 <piperead+0x36>
      release(&p->lock);
80103e84:	8b 45 08             	mov    0x8(%ebp),%eax
80103e87:	89 04 24             	mov    %eax,(%esp)
80103e8a:	e8 19 0c 00 00       	call   80104aa8 <release>
      return -1;
80103e8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e94:	e9 b5 00 00 00       	jmp    80103f4e <piperead+0xeb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103e99:	8b 45 08             	mov    0x8(%ebp),%eax
80103e9c:	8b 55 08             	mov    0x8(%ebp),%edx
80103e9f:	81 c2 34 02 00 00    	add    $0x234,%edx
80103ea5:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ea9:	89 14 24             	mov    %edx,(%esp)
80103eac:	e8 cb 08 00 00       	call   8010477c <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103eb1:	8b 45 08             	mov    0x8(%ebp),%eax
80103eb4:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103eba:	8b 45 08             	mov    0x8(%ebp),%eax
80103ebd:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103ec3:	39 c2                	cmp    %eax,%edx
80103ec5:	75 0d                	jne    80103ed4 <piperead+0x71>
80103ec7:	8b 45 08             	mov    0x8(%ebp),%eax
80103eca:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103ed0:	85 c0                	test   %eax,%eax
80103ed2:	75 a3                	jne    80103e77 <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103ed4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103edb:	eb 4b                	jmp    80103f28 <piperead+0xc5>
    if(p->nread == p->nwrite)
80103edd:	8b 45 08             	mov    0x8(%ebp),%eax
80103ee0:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103ee6:	8b 45 08             	mov    0x8(%ebp),%eax
80103ee9:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103eef:	39 c2                	cmp    %eax,%edx
80103ef1:	75 02                	jne    80103ef5 <piperead+0x92>
      break;
80103ef3:	eb 3b                	jmp    80103f30 <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103ef5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ef8:	8b 45 0c             	mov    0xc(%ebp),%eax
80103efb:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80103efe:	8b 45 08             	mov    0x8(%ebp),%eax
80103f01:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103f07:	8d 48 01             	lea    0x1(%eax),%ecx
80103f0a:	8b 55 08             	mov    0x8(%ebp),%edx
80103f0d:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80103f13:	25 ff 01 00 00       	and    $0x1ff,%eax
80103f18:	89 c2                	mov    %eax,%edx
80103f1a:	8b 45 08             	mov    0x8(%ebp),%eax
80103f1d:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80103f22:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f24:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f2b:	3b 45 10             	cmp    0x10(%ebp),%eax
80103f2e:	7c ad                	jl     80103edd <piperead+0x7a>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103f30:	8b 45 08             	mov    0x8(%ebp),%eax
80103f33:	05 38 02 00 00       	add    $0x238,%eax
80103f38:	89 04 24             	mov    %eax,(%esp)
80103f3b:	e8 15 09 00 00       	call   80104855 <wakeup>
  release(&p->lock);
80103f40:	8b 45 08             	mov    0x8(%ebp),%eax
80103f43:	89 04 24             	mov    %eax,(%esp)
80103f46:	e8 5d 0b 00 00       	call   80104aa8 <release>
  return i;
80103f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103f4e:	83 c4 24             	add    $0x24,%esp
80103f51:	5b                   	pop    %ebx
80103f52:	5d                   	pop    %ebp
80103f53:	c3                   	ret    

80103f54 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80103f54:	55                   	push   %ebp
80103f55:	89 e5                	mov    %esp,%ebp
80103f57:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f5a:	9c                   	pushf  
80103f5b:	58                   	pop    %eax
80103f5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80103f5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103f62:	c9                   	leave  
80103f63:	c3                   	ret    

80103f64 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80103f64:	55                   	push   %ebp
80103f65:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80103f67:	fb                   	sti    
}
80103f68:	5d                   	pop    %ebp
80103f69:	c3                   	ret    

80103f6a <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103f6a:	55                   	push   %ebp
80103f6b:	89 e5                	mov    %esp,%ebp
80103f6d:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103f70:	c7 44 24 04 9d 82 10 	movl   $0x8010829d,0x4(%esp)
80103f77:	80 
80103f78:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80103f7f:	e8 a1 0a 00 00       	call   80104a25 <initlock>
}
80103f84:	c9                   	leave  
80103f85:	c3                   	ret    

80103f86 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103f86:	55                   	push   %ebp
80103f87:	89 e5                	mov    %esp,%ebp
80103f89:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80103f8c:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80103f93:	e8 ae 0a 00 00       	call   80104a46 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f98:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
80103f9f:	eb 50                	jmp    80103ff1 <allocproc+0x6b>
    if(p->state == UNUSED)
80103fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fa4:	8b 40 0c             	mov    0xc(%eax),%eax
80103fa7:	85 c0                	test   %eax,%eax
80103fa9:	75 42                	jne    80103fed <allocproc+0x67>
      goto found;
80103fab:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103faf:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80103fb6:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80103fbb:	8d 50 01             	lea    0x1(%eax),%edx
80103fbe:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
80103fc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103fc7:	89 42 10             	mov    %eax,0x10(%edx)
  release(&ptable.lock);
80103fca:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80103fd1:	e8 d2 0a 00 00       	call   80104aa8 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103fd6:	e8 f3 ea ff ff       	call   80102ace <kalloc>
80103fdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103fde:	89 42 08             	mov    %eax,0x8(%edx)
80103fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fe4:	8b 40 08             	mov    0x8(%eax),%eax
80103fe7:	85 c0                	test   %eax,%eax
80103fe9:	75 33                	jne    8010401e <allocproc+0x98>
80103feb:	eb 20                	jmp    8010400d <allocproc+0x87>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fed:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80103ff1:	81 7d f4 54 1e 11 80 	cmpl   $0x80111e54,-0xc(%ebp)
80103ff8:	72 a7                	jb     80103fa1 <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
80103ffa:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104001:	e8 a2 0a 00 00       	call   80104aa8 <release>
  return 0;
80104006:	b8 00 00 00 00       	mov    $0x0,%eax
8010400b:	eb 76                	jmp    80104083 <allocproc+0xfd>
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
8010400d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104010:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104017:	b8 00 00 00 00       	mov    $0x0,%eax
8010401c:	eb 65                	jmp    80104083 <allocproc+0xfd>
  }
  sp = p->kstack + KSTACKSIZE;
8010401e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104021:	8b 40 08             	mov    0x8(%eax),%eax
80104024:	05 00 10 00 00       	add    $0x1000,%eax
80104029:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010402c:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104030:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104033:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104036:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104039:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
8010403d:	ba 7c 60 10 80       	mov    $0x8010607c,%edx
80104042:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104045:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104047:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
8010404b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010404e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104051:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104054:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104057:	8b 40 1c             	mov    0x1c(%eax),%eax
8010405a:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104061:	00 
80104062:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104069:	00 
8010406a:	89 04 24             	mov    %eax,(%esp)
8010406d:	e8 28 0c 00 00       	call   80104c9a <memset>
  p->context->eip = (uint)forkret;
80104072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104075:	8b 40 1c             	mov    0x1c(%eax),%eax
80104078:	ba 50 47 10 80       	mov    $0x80104750,%edx
8010407d:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80104080:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104083:	c9                   	leave  
80104084:	c3                   	ret    

80104085 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104085:	55                   	push   %ebp
80104086:	89 e5                	mov    %esp,%ebp
80104088:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
8010408b:	e8 f6 fe ff ff       	call   80103f86 <allocproc>
80104090:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104093:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104096:	a3 48 b6 10 80       	mov    %eax,0x8010b648
  if((p->pgdir = setupkvm()) == 0)
8010409b:	e8 d0 36 00 00       	call   80107770 <setupkvm>
801040a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040a3:	89 42 04             	mov    %eax,0x4(%edx)
801040a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040a9:	8b 40 04             	mov    0x4(%eax),%eax
801040ac:	85 c0                	test   %eax,%eax
801040ae:	75 0c                	jne    801040bc <userinit+0x37>
    panic("userinit: out of memory?");
801040b0:	c7 04 24 a4 82 10 80 	movl   $0x801082a4,(%esp)
801040b7:	e8 7e c4 ff ff       	call   8010053a <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801040bc:	ba 2c 00 00 00       	mov    $0x2c,%edx
801040c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040c4:	8b 40 04             	mov    0x4(%eax),%eax
801040c7:	89 54 24 08          	mov    %edx,0x8(%esp)
801040cb:	c7 44 24 04 e0 b4 10 	movl   $0x8010b4e0,0x4(%esp)
801040d2:	80 
801040d3:	89 04 24             	mov    %eax,(%esp)
801040d6:	e8 ed 38 00 00       	call   801079c8 <inituvm>
  p->sz = PGSIZE;
801040db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040de:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801040e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040e7:	8b 40 18             	mov    0x18(%eax),%eax
801040ea:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801040f1:	00 
801040f2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801040f9:	00 
801040fa:	89 04 24             	mov    %eax,(%esp)
801040fd:	e8 98 0b 00 00       	call   80104c9a <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104102:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104105:	8b 40 18             	mov    0x18(%eax),%eax
80104108:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010410e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104111:	8b 40 18             	mov    0x18(%eax),%eax
80104114:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010411a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010411d:	8b 40 18             	mov    0x18(%eax),%eax
80104120:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104123:	8b 52 18             	mov    0x18(%edx),%edx
80104126:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010412a:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010412e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104131:	8b 40 18             	mov    0x18(%eax),%eax
80104134:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104137:	8b 52 18             	mov    0x18(%edx),%edx
8010413a:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010413e:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104145:	8b 40 18             	mov    0x18(%eax),%eax
80104148:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010414f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104152:	8b 40 18             	mov    0x18(%eax),%eax
80104155:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010415c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010415f:	8b 40 18             	mov    0x18(%eax),%eax
80104162:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104169:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010416c:	83 c0 6c             	add    $0x6c,%eax
8010416f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104176:	00 
80104177:	c7 44 24 04 bd 82 10 	movl   $0x801082bd,0x4(%esp)
8010417e:	80 
8010417f:	89 04 24             	mov    %eax,(%esp)
80104182:	e8 33 0d 00 00       	call   80104eba <safestrcpy>
  p->cwd = namei("/");
80104187:	c7 04 24 c6 82 10 80 	movl   $0x801082c6,(%esp)
8010418e:	e8 5f e2 ff ff       	call   801023f2 <namei>
80104193:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104196:	89 42 68             	mov    %eax,0x68(%edx)

  p->state = RUNNABLE;
80104199:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010419c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
801041a3:	c9                   	leave  
801041a4:	c3                   	ret    

801041a5 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801041a5:	55                   	push   %ebp
801041a6:	89 e5                	mov    %esp,%ebp
801041a8:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  
  sz = proc->sz;
801041ab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801041b1:	8b 00                	mov    (%eax),%eax
801041b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801041b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801041ba:	7e 34                	jle    801041f0 <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801041bc:	8b 55 08             	mov    0x8(%ebp),%edx
801041bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041c2:	01 c2                	add    %eax,%edx
801041c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801041ca:	8b 40 04             	mov    0x4(%eax),%eax
801041cd:	89 54 24 08          	mov    %edx,0x8(%esp)
801041d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041d4:	89 54 24 04          	mov    %edx,0x4(%esp)
801041d8:	89 04 24             	mov    %eax,(%esp)
801041db:	e8 5e 39 00 00       	call   80107b3e <allocuvm>
801041e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801041e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801041e7:	75 41                	jne    8010422a <growproc+0x85>
      return -1;
801041e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041ee:	eb 58                	jmp    80104248 <growproc+0xa3>
  } else if(n < 0){
801041f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801041f4:	79 34                	jns    8010422a <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801041f6:	8b 55 08             	mov    0x8(%ebp),%edx
801041f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041fc:	01 c2                	add    %eax,%edx
801041fe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104204:	8b 40 04             	mov    0x4(%eax),%eax
80104207:	89 54 24 08          	mov    %edx,0x8(%esp)
8010420b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010420e:	89 54 24 04          	mov    %edx,0x4(%esp)
80104212:	89 04 24             	mov    %eax,(%esp)
80104215:	e8 fe 39 00 00       	call   80107c18 <deallocuvm>
8010421a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010421d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104221:	75 07                	jne    8010422a <growproc+0x85>
      return -1;
80104223:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104228:	eb 1e                	jmp    80104248 <growproc+0xa3>
  }
  proc->sz = sz;
8010422a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104230:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104233:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104235:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010423b:	89 04 24             	mov    %eax,(%esp)
8010423e:	e8 1e 36 00 00       	call   80107861 <switchuvm>
  return 0;
80104243:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104248:	c9                   	leave  
80104249:	c3                   	ret    

8010424a <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
8010424a:	55                   	push   %ebp
8010424b:	89 e5                	mov    %esp,%ebp
8010424d:	57                   	push   %edi
8010424e:	56                   	push   %esi
8010424f:	53                   	push   %ebx
80104250:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80104253:	e8 2e fd ff ff       	call   80103f86 <allocproc>
80104258:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010425b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010425f:	75 0a                	jne    8010426b <fork+0x21>
    return -1;
80104261:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104266:	e9 3a 01 00 00       	jmp    801043a5 <fork+0x15b>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
8010426b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104271:	8b 10                	mov    (%eax),%edx
80104273:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104279:	8b 40 04             	mov    0x4(%eax),%eax
8010427c:	89 54 24 04          	mov    %edx,0x4(%esp)
80104280:	89 04 24             	mov    %eax,(%esp)
80104283:	e8 2c 3b 00 00       	call   80107db4 <copyuvm>
80104288:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010428b:	89 42 04             	mov    %eax,0x4(%edx)
8010428e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104291:	8b 40 04             	mov    0x4(%eax),%eax
80104294:	85 c0                	test   %eax,%eax
80104296:	75 2c                	jne    801042c4 <fork+0x7a>
    kfree(np->kstack);
80104298:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010429b:	8b 40 08             	mov    0x8(%eax),%eax
8010429e:	89 04 24             	mov    %eax,(%esp)
801042a1:	e8 8f e7 ff ff       	call   80102a35 <kfree>
    np->kstack = 0;
801042a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801042a9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
801042b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801042b3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
801042ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042bf:	e9 e1 00 00 00       	jmp    801043a5 <fork+0x15b>
  }
  np->sz = proc->sz;
801042c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042ca:	8b 10                	mov    (%eax),%edx
801042cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801042cf:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
801042d1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801042d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801042db:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
801042de:	8b 45 e0             	mov    -0x20(%ebp),%eax
801042e1:	8b 50 18             	mov    0x18(%eax),%edx
801042e4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042ea:	8b 40 18             	mov    0x18(%eax),%eax
801042ed:	89 c3                	mov    %eax,%ebx
801042ef:	b8 13 00 00 00       	mov    $0x13,%eax
801042f4:	89 d7                	mov    %edx,%edi
801042f6:	89 de                	mov    %ebx,%esi
801042f8:	89 c1                	mov    %eax,%ecx
801042fa:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801042fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801042ff:	8b 40 18             	mov    0x18(%eax),%eax
80104302:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104309:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104310:	eb 3d                	jmp    8010434f <fork+0x105>
    if(proc->ofile[i])
80104312:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104318:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010431b:	83 c2 08             	add    $0x8,%edx
8010431e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104322:	85 c0                	test   %eax,%eax
80104324:	74 25                	je     8010434b <fork+0x101>
      np->ofile[i] = filedup(proc->ofile[i]);
80104326:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010432c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010432f:	83 c2 08             	add    $0x8,%edx
80104332:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104336:	89 04 24             	mov    %eax,(%esp)
80104339:	e8 34 cc ff ff       	call   80100f72 <filedup>
8010433e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104341:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104344:	83 c1 08             	add    $0x8,%ecx
80104347:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010434b:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010434f:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104353:	7e bd                	jle    80104312 <fork+0xc8>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104355:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010435b:	8b 40 68             	mov    0x68(%eax),%eax
8010435e:	89 04 24             	mov    %eax,(%esp)
80104361:	e8 af d4 ff ff       	call   80101815 <idup>
80104366:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104369:	89 42 68             	mov    %eax,0x68(%edx)
 
  pid = np->pid;
8010436c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010436f:	8b 40 10             	mov    0x10(%eax),%eax
80104372:	89 45 dc             	mov    %eax,-0x24(%ebp)
  np->state = RUNNABLE;
80104375:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104378:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  safestrcpy(np->name, proc->name, sizeof(proc->name));
8010437f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104385:	8d 50 6c             	lea    0x6c(%eax),%edx
80104388:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010438b:	83 c0 6c             	add    $0x6c,%eax
8010438e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104395:	00 
80104396:	89 54 24 04          	mov    %edx,0x4(%esp)
8010439a:	89 04 24             	mov    %eax,(%esp)
8010439d:	e8 18 0b 00 00       	call   80104eba <safestrcpy>
  return pid;
801043a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
801043a5:	83 c4 2c             	add    $0x2c,%esp
801043a8:	5b                   	pop    %ebx
801043a9:	5e                   	pop    %esi
801043aa:	5f                   	pop    %edi
801043ab:	5d                   	pop    %ebp
801043ac:	c3                   	ret    

801043ad <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
801043ad:	55                   	push   %ebp
801043ae:	89 e5                	mov    %esp,%ebp
801043b0:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
801043b3:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801043ba:	a1 48 b6 10 80       	mov    0x8010b648,%eax
801043bf:	39 c2                	cmp    %eax,%edx
801043c1:	75 0c                	jne    801043cf <exit+0x22>
    panic("init exiting");
801043c3:	c7 04 24 c8 82 10 80 	movl   $0x801082c8,(%esp)
801043ca:	e8 6b c1 ff ff       	call   8010053a <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801043cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801043d6:	eb 44                	jmp    8010441c <exit+0x6f>
    if(proc->ofile[fd]){
801043d8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043de:	8b 55 f0             	mov    -0x10(%ebp),%edx
801043e1:	83 c2 08             	add    $0x8,%edx
801043e4:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801043e8:	85 c0                	test   %eax,%eax
801043ea:	74 2c                	je     80104418 <exit+0x6b>
      fileclose(proc->ofile[fd]);
801043ec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801043f5:	83 c2 08             	add    $0x8,%edx
801043f8:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801043fc:	89 04 24             	mov    %eax,(%esp)
801043ff:	e8 b6 cb ff ff       	call   80100fba <fileclose>
      proc->ofile[fd] = 0;
80104404:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010440a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010440d:	83 c2 08             	add    $0x8,%edx
80104410:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104417:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104418:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010441c:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104420:	7e b6                	jle    801043d8 <exit+0x2b>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  iput(proc->cwd);
80104422:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104428:	8b 40 68             	mov    0x68(%eax),%eax
8010442b:	89 04 24             	mov    %eax,(%esp)
8010442e:	e8 c7 d5 ff ff       	call   801019fa <iput>
  proc->cwd = 0;
80104433:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104439:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104440:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104447:	e8 fa 05 00 00       	call   80104a46 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
8010444c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104452:	8b 40 14             	mov    0x14(%eax),%eax
80104455:	89 04 24             	mov    %eax,(%esp)
80104458:	e8 ba 03 00 00       	call   80104817 <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010445d:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
80104464:	eb 38                	jmp    8010449e <exit+0xf1>
    if(p->parent == proc){
80104466:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104469:	8b 50 14             	mov    0x14(%eax),%edx
8010446c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104472:	39 c2                	cmp    %eax,%edx
80104474:	75 24                	jne    8010449a <exit+0xed>
      p->parent = initproc;
80104476:	8b 15 48 b6 10 80    	mov    0x8010b648,%edx
8010447c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010447f:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104482:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104485:	8b 40 0c             	mov    0xc(%eax),%eax
80104488:	83 f8 05             	cmp    $0x5,%eax
8010448b:	75 0d                	jne    8010449a <exit+0xed>
        wakeup1(initproc);
8010448d:	a1 48 b6 10 80       	mov    0x8010b648,%eax
80104492:	89 04 24             	mov    %eax,(%esp)
80104495:	e8 7d 03 00 00       	call   80104817 <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010449a:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
8010449e:	81 7d f4 54 1e 11 80 	cmpl   $0x80111e54,-0xc(%ebp)
801044a5:	72 bf                	jb     80104466 <exit+0xb9>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
801044a7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044ad:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
801044b4:	e8 b3 01 00 00       	call   8010466c <sched>
  panic("zombie exit");
801044b9:	c7 04 24 d5 82 10 80 	movl   $0x801082d5,(%esp)
801044c0:	e8 75 c0 ff ff       	call   8010053a <panic>

801044c5 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
801044c5:	55                   	push   %ebp
801044c6:	89 e5                	mov    %esp,%ebp
801044c8:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
801044cb:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801044d2:	e8 6f 05 00 00       	call   80104a46 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
801044d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044de:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
801044e5:	e9 9a 00 00 00       	jmp    80104584 <wait+0xbf>
      if(p->parent != proc)
801044ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ed:	8b 50 14             	mov    0x14(%eax),%edx
801044f0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044f6:	39 c2                	cmp    %eax,%edx
801044f8:	74 05                	je     801044ff <wait+0x3a>
        continue;
801044fa:	e9 81 00 00 00       	jmp    80104580 <wait+0xbb>
      havekids = 1;
801044ff:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104506:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104509:	8b 40 0c             	mov    0xc(%eax),%eax
8010450c:	83 f8 05             	cmp    $0x5,%eax
8010450f:	75 6f                	jne    80104580 <wait+0xbb>
        // Found one.
        pid = p->pid;
80104511:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104514:	8b 40 10             	mov    0x10(%eax),%eax
80104517:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
8010451a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010451d:	8b 40 08             	mov    0x8(%eax),%eax
80104520:	89 04 24             	mov    %eax,(%esp)
80104523:	e8 0d e5 ff ff       	call   80102a35 <kfree>
        p->kstack = 0;
80104528:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010452b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104532:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104535:	8b 40 04             	mov    0x4(%eax),%eax
80104538:	89 04 24             	mov    %eax,(%esp)
8010453b:	e8 94 37 00 00       	call   80107cd4 <freevm>
        p->state = UNUSED;
80104540:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104543:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
8010454a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010454d:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104554:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104557:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
8010455e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104561:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104565:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104568:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
8010456f:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104576:	e8 2d 05 00 00       	call   80104aa8 <release>
        return pid;
8010457b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010457e:	eb 52                	jmp    801045d2 <wait+0x10d>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104580:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104584:	81 7d f4 54 1e 11 80 	cmpl   $0x80111e54,-0xc(%ebp)
8010458b:	0f 82 59 ff ff ff    	jb     801044ea <wait+0x25>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104591:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104595:	74 0d                	je     801045a4 <wait+0xdf>
80104597:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010459d:	8b 40 24             	mov    0x24(%eax),%eax
801045a0:	85 c0                	test   %eax,%eax
801045a2:	74 13                	je     801045b7 <wait+0xf2>
      release(&ptable.lock);
801045a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801045ab:	e8 f8 04 00 00       	call   80104aa8 <release>
      return -1;
801045b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045b5:	eb 1b                	jmp    801045d2 <wait+0x10d>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
801045b7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045bd:	c7 44 24 04 20 ff 10 	movl   $0x8010ff20,0x4(%esp)
801045c4:	80 
801045c5:	89 04 24             	mov    %eax,(%esp)
801045c8:	e8 af 01 00 00       	call   8010477c <sleep>
  }
801045cd:	e9 05 ff ff ff       	jmp    801044d7 <wait+0x12>
}
801045d2:	c9                   	leave  
801045d3:	c3                   	ret    

801045d4 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801045d4:	55                   	push   %ebp
801045d5:	89 e5                	mov    %esp,%ebp
801045d7:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
801045da:	e8 85 f9 ff ff       	call   80103f64 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801045df:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801045e6:	e8 5b 04 00 00       	call   80104a46 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045eb:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
801045f2:	eb 5e                	jmp    80104652 <scheduler+0x7e>
      if(p->state != RUNNABLE)
801045f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045f7:	8b 40 0c             	mov    0xc(%eax),%eax
801045fa:	83 f8 03             	cmp    $0x3,%eax
801045fd:	74 02                	je     80104601 <scheduler+0x2d>
        continue;
801045ff:	eb 4d                	jmp    8010464e <scheduler+0x7a>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104601:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104604:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
8010460a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010460d:	89 04 24             	mov    %eax,(%esp)
80104610:	e8 4c 32 00 00       	call   80107861 <switchuvm>
      p->state = RUNNING;
80104615:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104618:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
8010461f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104625:	8b 40 1c             	mov    0x1c(%eax),%eax
80104628:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010462f:	83 c2 04             	add    $0x4,%edx
80104632:	89 44 24 04          	mov    %eax,0x4(%esp)
80104636:	89 14 24             	mov    %edx,(%esp)
80104639:	e8 ed 08 00 00       	call   80104f2b <swtch>
      switchkvm();
8010463e:	e8 01 32 00 00       	call   80107844 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104643:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010464a:	00 00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010464e:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104652:	81 7d f4 54 1e 11 80 	cmpl   $0x80111e54,-0xc(%ebp)
80104659:	72 99                	jb     801045f4 <scheduler+0x20>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
8010465b:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104662:	e8 41 04 00 00       	call   80104aa8 <release>

  }
80104667:	e9 6e ff ff ff       	jmp    801045da <scheduler+0x6>

8010466c <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
8010466c:	55                   	push   %ebp
8010466d:	89 e5                	mov    %esp,%ebp
8010466f:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
80104672:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104679:	e8 f2 04 00 00       	call   80104b70 <holding>
8010467e:	85 c0                	test   %eax,%eax
80104680:	75 0c                	jne    8010468e <sched+0x22>
    panic("sched ptable.lock");
80104682:	c7 04 24 e1 82 10 80 	movl   $0x801082e1,(%esp)
80104689:	e8 ac be ff ff       	call   8010053a <panic>
  if(cpu->ncli != 1)
8010468e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104694:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010469a:	83 f8 01             	cmp    $0x1,%eax
8010469d:	74 0c                	je     801046ab <sched+0x3f>
    panic("sched locks");
8010469f:	c7 04 24 f3 82 10 80 	movl   $0x801082f3,(%esp)
801046a6:	e8 8f be ff ff       	call   8010053a <panic>
  if(proc->state == RUNNING)
801046ab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046b1:	8b 40 0c             	mov    0xc(%eax),%eax
801046b4:	83 f8 04             	cmp    $0x4,%eax
801046b7:	75 0c                	jne    801046c5 <sched+0x59>
    panic("sched running");
801046b9:	c7 04 24 ff 82 10 80 	movl   $0x801082ff,(%esp)
801046c0:	e8 75 be ff ff       	call   8010053a <panic>
  if(readeflags()&FL_IF)
801046c5:	e8 8a f8 ff ff       	call   80103f54 <readeflags>
801046ca:	25 00 02 00 00       	and    $0x200,%eax
801046cf:	85 c0                	test   %eax,%eax
801046d1:	74 0c                	je     801046df <sched+0x73>
    panic("sched interruptible");
801046d3:	c7 04 24 0d 83 10 80 	movl   $0x8010830d,(%esp)
801046da:	e8 5b be ff ff       	call   8010053a <panic>
  intena = cpu->intena;
801046df:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801046e5:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801046eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
801046ee:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801046f4:	8b 40 04             	mov    0x4(%eax),%eax
801046f7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801046fe:	83 c2 1c             	add    $0x1c,%edx
80104701:	89 44 24 04          	mov    %eax,0x4(%esp)
80104705:	89 14 24             	mov    %edx,(%esp)
80104708:	e8 1e 08 00 00       	call   80104f2b <swtch>
  cpu->intena = intena;
8010470d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104713:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104716:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010471c:	c9                   	leave  
8010471d:	c3                   	ret    

8010471e <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
8010471e:	55                   	push   %ebp
8010471f:	89 e5                	mov    %esp,%ebp
80104721:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104724:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010472b:	e8 16 03 00 00       	call   80104a46 <acquire>
  proc->state = RUNNABLE;
80104730:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104736:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
8010473d:	e8 2a ff ff ff       	call   8010466c <sched>
  release(&ptable.lock);
80104742:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104749:	e8 5a 03 00 00       	call   80104aa8 <release>
}
8010474e:	c9                   	leave  
8010474f:	c3                   	ret    

80104750 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104756:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010475d:	e8 46 03 00 00       	call   80104aa8 <release>

  if (first) {
80104762:	a1 08 b0 10 80       	mov    0x8010b008,%eax
80104767:	85 c0                	test   %eax,%eax
80104769:	74 0f                	je     8010477a <forkret+0x2a>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
8010476b:	c7 05 08 b0 10 80 00 	movl   $0x0,0x8010b008
80104772:	00 00 00 
    initlog();
80104775:	e8 49 e8 ff ff       	call   80102fc3 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
8010477a:	c9                   	leave  
8010477b:	c3                   	ret    

8010477c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
8010477c:	55                   	push   %ebp
8010477d:	89 e5                	mov    %esp,%ebp
8010477f:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
80104782:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104788:	85 c0                	test   %eax,%eax
8010478a:	75 0c                	jne    80104798 <sleep+0x1c>
    panic("sleep");
8010478c:	c7 04 24 21 83 10 80 	movl   $0x80108321,(%esp)
80104793:	e8 a2 bd ff ff       	call   8010053a <panic>

  if(lk == 0)
80104798:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010479c:	75 0c                	jne    801047aa <sleep+0x2e>
    panic("sleep without lk");
8010479e:	c7 04 24 27 83 10 80 	movl   $0x80108327,(%esp)
801047a5:	e8 90 bd ff ff       	call   8010053a <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
801047aa:	81 7d 0c 20 ff 10 80 	cmpl   $0x8010ff20,0xc(%ebp)
801047b1:	74 17                	je     801047ca <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
801047b3:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801047ba:	e8 87 02 00 00       	call   80104a46 <acquire>
    release(lk);
801047bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801047c2:	89 04 24             	mov    %eax,(%esp)
801047c5:	e8 de 02 00 00       	call   80104aa8 <release>
  }

  // Go to sleep.
  proc->chan = chan;
801047ca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047d0:	8b 55 08             	mov    0x8(%ebp),%edx
801047d3:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
801047d6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047dc:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
801047e3:	e8 84 fe ff ff       	call   8010466c <sched>

  // Tidy up.
  proc->chan = 0;
801047e8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047ee:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
801047f5:	81 7d 0c 20 ff 10 80 	cmpl   $0x8010ff20,0xc(%ebp)
801047fc:	74 17                	je     80104815 <sleep+0x99>
    release(&ptable.lock);
801047fe:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104805:	e8 9e 02 00 00       	call   80104aa8 <release>
    acquire(lk);
8010480a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010480d:	89 04 24             	mov    %eax,(%esp)
80104810:	e8 31 02 00 00       	call   80104a46 <acquire>
  }
}
80104815:	c9                   	leave  
80104816:	c3                   	ret    

80104817 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104817:	55                   	push   %ebp
80104818:	89 e5                	mov    %esp,%ebp
8010481a:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010481d:	c7 45 fc 54 ff 10 80 	movl   $0x8010ff54,-0x4(%ebp)
80104824:	eb 24                	jmp    8010484a <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104826:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104829:	8b 40 0c             	mov    0xc(%eax),%eax
8010482c:	83 f8 02             	cmp    $0x2,%eax
8010482f:	75 15                	jne    80104846 <wakeup1+0x2f>
80104831:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104834:	8b 40 20             	mov    0x20(%eax),%eax
80104837:	3b 45 08             	cmp    0x8(%ebp),%eax
8010483a:	75 0a                	jne    80104846 <wakeup1+0x2f>
      p->state = RUNNABLE;
8010483c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010483f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104846:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
8010484a:	81 7d fc 54 1e 11 80 	cmpl   $0x80111e54,-0x4(%ebp)
80104851:	72 d3                	jb     80104826 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104853:	c9                   	leave  
80104854:	c3                   	ret    

80104855 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104855:	55                   	push   %ebp
80104856:	89 e5                	mov    %esp,%ebp
80104858:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
8010485b:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104862:	e8 df 01 00 00       	call   80104a46 <acquire>
  wakeup1(chan);
80104867:	8b 45 08             	mov    0x8(%ebp),%eax
8010486a:	89 04 24             	mov    %eax,(%esp)
8010486d:	e8 a5 ff ff ff       	call   80104817 <wakeup1>
  release(&ptable.lock);
80104872:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104879:	e8 2a 02 00 00       	call   80104aa8 <release>
}
8010487e:	c9                   	leave  
8010487f:	c3                   	ret    

80104880 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104886:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010488d:	e8 b4 01 00 00       	call   80104a46 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104892:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
80104899:	eb 41                	jmp    801048dc <kill+0x5c>
    if(p->pid == pid){
8010489b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010489e:	8b 40 10             	mov    0x10(%eax),%eax
801048a1:	3b 45 08             	cmp    0x8(%ebp),%eax
801048a4:	75 32                	jne    801048d8 <kill+0x58>
      p->killed = 1;
801048a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048a9:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801048b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048b3:	8b 40 0c             	mov    0xc(%eax),%eax
801048b6:	83 f8 02             	cmp    $0x2,%eax
801048b9:	75 0a                	jne    801048c5 <kill+0x45>
        p->state = RUNNABLE;
801048bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048be:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801048c5:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801048cc:	e8 d7 01 00 00       	call   80104aa8 <release>
      return 0;
801048d1:	b8 00 00 00 00       	mov    $0x0,%eax
801048d6:	eb 1e                	jmp    801048f6 <kill+0x76>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048d8:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801048dc:	81 7d f4 54 1e 11 80 	cmpl   $0x80111e54,-0xc(%ebp)
801048e3:	72 b6                	jb     8010489b <kill+0x1b>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801048e5:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801048ec:	e8 b7 01 00 00       	call   80104aa8 <release>
  return -1;
801048f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801048f6:	c9                   	leave  
801048f7:	c3                   	ret    

801048f8 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801048f8:	55                   	push   %ebp
801048f9:	89 e5                	mov    %esp,%ebp
801048fb:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048fe:	c7 45 f0 54 ff 10 80 	movl   $0x8010ff54,-0x10(%ebp)
80104905:	e9 d6 00 00 00       	jmp    801049e0 <procdump+0xe8>
    if(p->state == UNUSED)
8010490a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010490d:	8b 40 0c             	mov    0xc(%eax),%eax
80104910:	85 c0                	test   %eax,%eax
80104912:	75 05                	jne    80104919 <procdump+0x21>
      continue;
80104914:	e9 c3 00 00 00       	jmp    801049dc <procdump+0xe4>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104919:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010491c:	8b 40 0c             	mov    0xc(%eax),%eax
8010491f:	83 f8 05             	cmp    $0x5,%eax
80104922:	77 23                	ja     80104947 <procdump+0x4f>
80104924:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104927:	8b 40 0c             	mov    0xc(%eax),%eax
8010492a:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104931:	85 c0                	test   %eax,%eax
80104933:	74 12                	je     80104947 <procdump+0x4f>
      state = states[p->state];
80104935:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104938:	8b 40 0c             	mov    0xc(%eax),%eax
8010493b:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104942:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104945:	eb 07                	jmp    8010494e <procdump+0x56>
    else
      state = "???";
80104947:	c7 45 ec 38 83 10 80 	movl   $0x80108338,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
8010494e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104951:	8d 50 6c             	lea    0x6c(%eax),%edx
80104954:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104957:	8b 40 10             	mov    0x10(%eax),%eax
8010495a:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010495e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104961:	89 54 24 08          	mov    %edx,0x8(%esp)
80104965:	89 44 24 04          	mov    %eax,0x4(%esp)
80104969:	c7 04 24 3c 83 10 80 	movl   $0x8010833c,(%esp)
80104970:	e8 2b ba ff ff       	call   801003a0 <cprintf>
    if(p->state == SLEEPING){
80104975:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104978:	8b 40 0c             	mov    0xc(%eax),%eax
8010497b:	83 f8 02             	cmp    $0x2,%eax
8010497e:	75 50                	jne    801049d0 <procdump+0xd8>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104980:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104983:	8b 40 1c             	mov    0x1c(%eax),%eax
80104986:	8b 40 0c             	mov    0xc(%eax),%eax
80104989:	83 c0 08             	add    $0x8,%eax
8010498c:	8d 55 c4             	lea    -0x3c(%ebp),%edx
8010498f:	89 54 24 04          	mov    %edx,0x4(%esp)
80104993:	89 04 24             	mov    %eax,(%esp)
80104996:	e8 5c 01 00 00       	call   80104af7 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010499b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801049a2:	eb 1b                	jmp    801049bf <procdump+0xc7>
        cprintf(" %p", pc[i]);
801049a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049a7:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801049ab:	89 44 24 04          	mov    %eax,0x4(%esp)
801049af:	c7 04 24 45 83 10 80 	movl   $0x80108345,(%esp)
801049b6:	e8 e5 b9 ff ff       	call   801003a0 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801049bb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801049bf:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801049c3:	7f 0b                	jg     801049d0 <procdump+0xd8>
801049c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049c8:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
801049cc:	85 c0                	test   %eax,%eax
801049ce:	75 d4                	jne    801049a4 <procdump+0xac>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801049d0:	c7 04 24 49 83 10 80 	movl   $0x80108349,(%esp)
801049d7:	e8 c4 b9 ff ff       	call   801003a0 <cprintf>
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049dc:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
801049e0:	81 7d f0 54 1e 11 80 	cmpl   $0x80111e54,-0x10(%ebp)
801049e7:	0f 82 1d ff ff ff    	jb     8010490a <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801049ed:	c9                   	leave  
801049ee:	c3                   	ret    

801049ef <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801049ef:	55                   	push   %ebp
801049f0:	89 e5                	mov    %esp,%ebp
801049f2:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801049f5:	9c                   	pushf  
801049f6:	58                   	pop    %eax
801049f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801049fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801049fd:	c9                   	leave  
801049fe:	c3                   	ret    

801049ff <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801049ff:	55                   	push   %ebp
80104a00:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104a02:	fa                   	cli    
}
80104a03:	5d                   	pop    %ebp
80104a04:	c3                   	ret    

80104a05 <sti>:

static inline void
sti(void)
{
80104a05:	55                   	push   %ebp
80104a06:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104a08:	fb                   	sti    
}
80104a09:	5d                   	pop    %ebp
80104a0a:	c3                   	ret    

80104a0b <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104a0b:	55                   	push   %ebp
80104a0c:	89 e5                	mov    %esp,%ebp
80104a0e:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104a11:	8b 55 08             	mov    0x8(%ebp),%edx
80104a14:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a17:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a1a:	f0 87 02             	lock xchg %eax,(%edx)
80104a1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104a20:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104a23:	c9                   	leave  
80104a24:	c3                   	ret    

80104a25 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104a25:	55                   	push   %ebp
80104a26:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104a28:	8b 45 08             	mov    0x8(%ebp),%eax
80104a2b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a2e:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104a31:	8b 45 08             	mov    0x8(%ebp),%eax
80104a34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104a3a:	8b 45 08             	mov    0x8(%ebp),%eax
80104a3d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104a44:	5d                   	pop    %ebp
80104a45:	c3                   	ret    

80104a46 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104a46:	55                   	push   %ebp
80104a47:	89 e5                	mov    %esp,%ebp
80104a49:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104a4c:	e8 49 01 00 00       	call   80104b9a <pushcli>
  if(holding(lk))
80104a51:	8b 45 08             	mov    0x8(%ebp),%eax
80104a54:	89 04 24             	mov    %eax,(%esp)
80104a57:	e8 14 01 00 00       	call   80104b70 <holding>
80104a5c:	85 c0                	test   %eax,%eax
80104a5e:	74 0c                	je     80104a6c <acquire+0x26>
    panic("acquire");
80104a60:	c7 04 24 75 83 10 80 	movl   $0x80108375,(%esp)
80104a67:	e8 ce ba ff ff       	call   8010053a <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80104a6c:	90                   	nop
80104a6d:	8b 45 08             	mov    0x8(%ebp),%eax
80104a70:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104a77:	00 
80104a78:	89 04 24             	mov    %eax,(%esp)
80104a7b:	e8 8b ff ff ff       	call   80104a0b <xchg>
80104a80:	85 c0                	test   %eax,%eax
80104a82:	75 e9                	jne    80104a6d <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104a84:	8b 45 08             	mov    0x8(%ebp),%eax
80104a87:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104a8e:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80104a91:	8b 45 08             	mov    0x8(%ebp),%eax
80104a94:	83 c0 0c             	add    $0xc,%eax
80104a97:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a9b:	8d 45 08             	lea    0x8(%ebp),%eax
80104a9e:	89 04 24             	mov    %eax,(%esp)
80104aa1:	e8 51 00 00 00       	call   80104af7 <getcallerpcs>
}
80104aa6:	c9                   	leave  
80104aa7:	c3                   	ret    

80104aa8 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104aa8:	55                   	push   %ebp
80104aa9:	89 e5                	mov    %esp,%ebp
80104aab:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80104aae:	8b 45 08             	mov    0x8(%ebp),%eax
80104ab1:	89 04 24             	mov    %eax,(%esp)
80104ab4:	e8 b7 00 00 00       	call   80104b70 <holding>
80104ab9:	85 c0                	test   %eax,%eax
80104abb:	75 0c                	jne    80104ac9 <release+0x21>
    panic("release");
80104abd:	c7 04 24 7d 83 10 80 	movl   $0x8010837d,(%esp)
80104ac4:	e8 71 ba ff ff       	call   8010053a <panic>

  lk->pcs[0] = 0;
80104ac9:	8b 45 08             	mov    0x8(%ebp),%eax
80104acc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104ad3:	8b 45 08             	mov    0x8(%ebp),%eax
80104ad6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80104add:	8b 45 08             	mov    0x8(%ebp),%eax
80104ae0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104ae7:	00 
80104ae8:	89 04 24             	mov    %eax,(%esp)
80104aeb:	e8 1b ff ff ff       	call   80104a0b <xchg>

  popcli();
80104af0:	e8 e9 00 00 00       	call   80104bde <popcli>
}
80104af5:	c9                   	leave  
80104af6:	c3                   	ret    

80104af7 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104af7:	55                   	push   %ebp
80104af8:	89 e5                	mov    %esp,%ebp
80104afa:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80104afd:	8b 45 08             	mov    0x8(%ebp),%eax
80104b00:	83 e8 08             	sub    $0x8,%eax
80104b03:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104b06:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104b0d:	eb 38                	jmp    80104b47 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104b13:	74 38                	je     80104b4d <getcallerpcs+0x56>
80104b15:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104b1c:	76 2f                	jbe    80104b4d <getcallerpcs+0x56>
80104b1e:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104b22:	74 29                	je     80104b4d <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104b24:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104b27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104b2e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b31:	01 c2                	add    %eax,%edx
80104b33:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104b36:	8b 40 04             	mov    0x4(%eax),%eax
80104b39:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80104b3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104b3e:	8b 00                	mov    (%eax),%eax
80104b40:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104b43:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104b47:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104b4b:	7e c2                	jle    80104b0f <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104b4d:	eb 19                	jmp    80104b68 <getcallerpcs+0x71>
    pcs[i] = 0;
80104b4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104b52:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104b59:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b5c:	01 d0                	add    %edx,%eax
80104b5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104b64:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104b68:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104b6c:	7e e1                	jle    80104b4f <getcallerpcs+0x58>
    pcs[i] = 0;
}
80104b6e:	c9                   	leave  
80104b6f:	c3                   	ret    

80104b70 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80104b73:	8b 45 08             	mov    0x8(%ebp),%eax
80104b76:	8b 00                	mov    (%eax),%eax
80104b78:	85 c0                	test   %eax,%eax
80104b7a:	74 17                	je     80104b93 <holding+0x23>
80104b7c:	8b 45 08             	mov    0x8(%ebp),%eax
80104b7f:	8b 50 08             	mov    0x8(%eax),%edx
80104b82:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104b88:	39 c2                	cmp    %eax,%edx
80104b8a:	75 07                	jne    80104b93 <holding+0x23>
80104b8c:	b8 01 00 00 00       	mov    $0x1,%eax
80104b91:	eb 05                	jmp    80104b98 <holding+0x28>
80104b93:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104b98:	5d                   	pop    %ebp
80104b99:	c3                   	ret    

80104b9a <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104b9a:	55                   	push   %ebp
80104b9b:	89 e5                	mov    %esp,%ebp
80104b9d:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80104ba0:	e8 4a fe ff ff       	call   801049ef <readeflags>
80104ba5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80104ba8:	e8 52 fe ff ff       	call   801049ff <cli>
  if(cpu->ncli++ == 0)
80104bad:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104bb4:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80104bba:	8d 48 01             	lea    0x1(%eax),%ecx
80104bbd:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80104bc3:	85 c0                	test   %eax,%eax
80104bc5:	75 15                	jne    80104bdc <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80104bc7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104bcd:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104bd0:	81 e2 00 02 00 00    	and    $0x200,%edx
80104bd6:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104bdc:	c9                   	leave  
80104bdd:	c3                   	ret    

80104bde <popcli>:

void
popcli(void)
{
80104bde:	55                   	push   %ebp
80104bdf:	89 e5                	mov    %esp,%ebp
80104be1:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80104be4:	e8 06 fe ff ff       	call   801049ef <readeflags>
80104be9:	25 00 02 00 00       	and    $0x200,%eax
80104bee:	85 c0                	test   %eax,%eax
80104bf0:	74 0c                	je     80104bfe <popcli+0x20>
    panic("popcli - interruptible");
80104bf2:	c7 04 24 85 83 10 80 	movl   $0x80108385,(%esp)
80104bf9:	e8 3c b9 ff ff       	call   8010053a <panic>
  if(--cpu->ncli < 0)
80104bfe:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c04:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104c0a:	83 ea 01             	sub    $0x1,%edx
80104c0d:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80104c13:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104c19:	85 c0                	test   %eax,%eax
80104c1b:	79 0c                	jns    80104c29 <popcli+0x4b>
    panic("popcli");
80104c1d:	c7 04 24 9c 83 10 80 	movl   $0x8010839c,(%esp)
80104c24:	e8 11 b9 ff ff       	call   8010053a <panic>
  if(cpu->ncli == 0 && cpu->intena)
80104c29:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c2f:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104c35:	85 c0                	test   %eax,%eax
80104c37:	75 15                	jne    80104c4e <popcli+0x70>
80104c39:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c3f:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104c45:	85 c0                	test   %eax,%eax
80104c47:	74 05                	je     80104c4e <popcli+0x70>
    sti();
80104c49:	e8 b7 fd ff ff       	call   80104a05 <sti>
}
80104c4e:	c9                   	leave  
80104c4f:	c3                   	ret    

80104c50 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	57                   	push   %edi
80104c54:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80104c55:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104c58:	8b 55 10             	mov    0x10(%ebp),%edx
80104c5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c5e:	89 cb                	mov    %ecx,%ebx
80104c60:	89 df                	mov    %ebx,%edi
80104c62:	89 d1                	mov    %edx,%ecx
80104c64:	fc                   	cld    
80104c65:	f3 aa                	rep stos %al,%es:(%edi)
80104c67:	89 ca                	mov    %ecx,%edx
80104c69:	89 fb                	mov    %edi,%ebx
80104c6b:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104c6e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80104c71:	5b                   	pop    %ebx
80104c72:	5f                   	pop    %edi
80104c73:	5d                   	pop    %ebp
80104c74:	c3                   	ret    

80104c75 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80104c75:	55                   	push   %ebp
80104c76:	89 e5                	mov    %esp,%ebp
80104c78:	57                   	push   %edi
80104c79:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80104c7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104c7d:	8b 55 10             	mov    0x10(%ebp),%edx
80104c80:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c83:	89 cb                	mov    %ecx,%ebx
80104c85:	89 df                	mov    %ebx,%edi
80104c87:	89 d1                	mov    %edx,%ecx
80104c89:	fc                   	cld    
80104c8a:	f3 ab                	rep stos %eax,%es:(%edi)
80104c8c:	89 ca                	mov    %ecx,%edx
80104c8e:	89 fb                	mov    %edi,%ebx
80104c90:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104c93:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80104c96:	5b                   	pop    %ebx
80104c97:	5f                   	pop    %edi
80104c98:	5d                   	pop    %ebp
80104c99:	c3                   	ret    

80104c9a <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104c9a:	55                   	push   %ebp
80104c9b:	89 e5                	mov    %esp,%ebp
80104c9d:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80104ca0:	8b 45 08             	mov    0x8(%ebp),%eax
80104ca3:	83 e0 03             	and    $0x3,%eax
80104ca6:	85 c0                	test   %eax,%eax
80104ca8:	75 49                	jne    80104cf3 <memset+0x59>
80104caa:	8b 45 10             	mov    0x10(%ebp),%eax
80104cad:	83 e0 03             	and    $0x3,%eax
80104cb0:	85 c0                	test   %eax,%eax
80104cb2:	75 3f                	jne    80104cf3 <memset+0x59>
    c &= 0xFF;
80104cb4:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104cbb:	8b 45 10             	mov    0x10(%ebp),%eax
80104cbe:	c1 e8 02             	shr    $0x2,%eax
80104cc1:	89 c2                	mov    %eax,%edx
80104cc3:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cc6:	c1 e0 18             	shl    $0x18,%eax
80104cc9:	89 c1                	mov    %eax,%ecx
80104ccb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cce:	c1 e0 10             	shl    $0x10,%eax
80104cd1:	09 c1                	or     %eax,%ecx
80104cd3:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cd6:	c1 e0 08             	shl    $0x8,%eax
80104cd9:	09 c8                	or     %ecx,%eax
80104cdb:	0b 45 0c             	or     0xc(%ebp),%eax
80104cde:	89 54 24 08          	mov    %edx,0x8(%esp)
80104ce2:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ce6:	8b 45 08             	mov    0x8(%ebp),%eax
80104ce9:	89 04 24             	mov    %eax,(%esp)
80104cec:	e8 84 ff ff ff       	call   80104c75 <stosl>
80104cf1:	eb 19                	jmp    80104d0c <memset+0x72>
  } else
    stosb(dst, c, n);
80104cf3:	8b 45 10             	mov    0x10(%ebp),%eax
80104cf6:	89 44 24 08          	mov    %eax,0x8(%esp)
80104cfa:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cfd:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d01:	8b 45 08             	mov    0x8(%ebp),%eax
80104d04:	89 04 24             	mov    %eax,(%esp)
80104d07:	e8 44 ff ff ff       	call   80104c50 <stosb>
  return dst;
80104d0c:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104d0f:	c9                   	leave  
80104d10:	c3                   	ret    

80104d11 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104d11:	55                   	push   %ebp
80104d12:	89 e5                	mov    %esp,%ebp
80104d14:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80104d17:	8b 45 08             	mov    0x8(%ebp),%eax
80104d1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80104d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d20:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80104d23:	eb 30                	jmp    80104d55 <memcmp+0x44>
    if(*s1 != *s2)
80104d25:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d28:	0f b6 10             	movzbl (%eax),%edx
80104d2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104d2e:	0f b6 00             	movzbl (%eax),%eax
80104d31:	38 c2                	cmp    %al,%dl
80104d33:	74 18                	je     80104d4d <memcmp+0x3c>
      return *s1 - *s2;
80104d35:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d38:	0f b6 00             	movzbl (%eax),%eax
80104d3b:	0f b6 d0             	movzbl %al,%edx
80104d3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104d41:	0f b6 00             	movzbl (%eax),%eax
80104d44:	0f b6 c0             	movzbl %al,%eax
80104d47:	29 c2                	sub    %eax,%edx
80104d49:	89 d0                	mov    %edx,%eax
80104d4b:	eb 1a                	jmp    80104d67 <memcmp+0x56>
    s1++, s2++;
80104d4d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104d51:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104d55:	8b 45 10             	mov    0x10(%ebp),%eax
80104d58:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d5b:	89 55 10             	mov    %edx,0x10(%ebp)
80104d5e:	85 c0                	test   %eax,%eax
80104d60:	75 c3                	jne    80104d25 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104d62:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104d67:	c9                   	leave  
80104d68:	c3                   	ret    

80104d69 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104d69:	55                   	push   %ebp
80104d6a:	89 e5                	mov    %esp,%ebp
80104d6c:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80104d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d72:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80104d75:	8b 45 08             	mov    0x8(%ebp),%eax
80104d78:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80104d7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d7e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104d81:	73 3d                	jae    80104dc0 <memmove+0x57>
80104d83:	8b 45 10             	mov    0x10(%ebp),%eax
80104d86:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104d89:	01 d0                	add    %edx,%eax
80104d8b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104d8e:	76 30                	jbe    80104dc0 <memmove+0x57>
    s += n;
80104d90:	8b 45 10             	mov    0x10(%ebp),%eax
80104d93:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80104d96:	8b 45 10             	mov    0x10(%ebp),%eax
80104d99:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80104d9c:	eb 13                	jmp    80104db1 <memmove+0x48>
      *--d = *--s;
80104d9e:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80104da2:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80104da6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104da9:	0f b6 10             	movzbl (%eax),%edx
80104dac:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104daf:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104db1:	8b 45 10             	mov    0x10(%ebp),%eax
80104db4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104db7:	89 55 10             	mov    %edx,0x10(%ebp)
80104dba:	85 c0                	test   %eax,%eax
80104dbc:	75 e0                	jne    80104d9e <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104dbe:	eb 26                	jmp    80104de6 <memmove+0x7d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104dc0:	eb 17                	jmp    80104dd9 <memmove+0x70>
      *d++ = *s++;
80104dc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104dc5:	8d 50 01             	lea    0x1(%eax),%edx
80104dc8:	89 55 f8             	mov    %edx,-0x8(%ebp)
80104dcb:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104dce:	8d 4a 01             	lea    0x1(%edx),%ecx
80104dd1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80104dd4:	0f b6 12             	movzbl (%edx),%edx
80104dd7:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104dd9:	8b 45 10             	mov    0x10(%ebp),%eax
80104ddc:	8d 50 ff             	lea    -0x1(%eax),%edx
80104ddf:	89 55 10             	mov    %edx,0x10(%ebp)
80104de2:	85 c0                	test   %eax,%eax
80104de4:	75 dc                	jne    80104dc2 <memmove+0x59>
      *d++ = *s++;

  return dst;
80104de6:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104de9:	c9                   	leave  
80104dea:	c3                   	ret    

80104deb <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104deb:	55                   	push   %ebp
80104dec:	89 e5                	mov    %esp,%ebp
80104dee:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80104df1:	8b 45 10             	mov    0x10(%ebp),%eax
80104df4:	89 44 24 08          	mov    %eax,0x8(%esp)
80104df8:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dfb:	89 44 24 04          	mov    %eax,0x4(%esp)
80104dff:	8b 45 08             	mov    0x8(%ebp),%eax
80104e02:	89 04 24             	mov    %eax,(%esp)
80104e05:	e8 5f ff ff ff       	call   80104d69 <memmove>
}
80104e0a:	c9                   	leave  
80104e0b:	c3                   	ret    

80104e0c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104e0c:	55                   	push   %ebp
80104e0d:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80104e0f:	eb 0c                	jmp    80104e1d <strncmp+0x11>
    n--, p++, q++;
80104e11:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104e15:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80104e19:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104e1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104e21:	74 1a                	je     80104e3d <strncmp+0x31>
80104e23:	8b 45 08             	mov    0x8(%ebp),%eax
80104e26:	0f b6 00             	movzbl (%eax),%eax
80104e29:	84 c0                	test   %al,%al
80104e2b:	74 10                	je     80104e3d <strncmp+0x31>
80104e2d:	8b 45 08             	mov    0x8(%ebp),%eax
80104e30:	0f b6 10             	movzbl (%eax),%edx
80104e33:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e36:	0f b6 00             	movzbl (%eax),%eax
80104e39:	38 c2                	cmp    %al,%dl
80104e3b:	74 d4                	je     80104e11 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80104e3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104e41:	75 07                	jne    80104e4a <strncmp+0x3e>
    return 0;
80104e43:	b8 00 00 00 00       	mov    $0x0,%eax
80104e48:	eb 16                	jmp    80104e60 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80104e4a:	8b 45 08             	mov    0x8(%ebp),%eax
80104e4d:	0f b6 00             	movzbl (%eax),%eax
80104e50:	0f b6 d0             	movzbl %al,%edx
80104e53:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e56:	0f b6 00             	movzbl (%eax),%eax
80104e59:	0f b6 c0             	movzbl %al,%eax
80104e5c:	29 c2                	sub    %eax,%edx
80104e5e:	89 d0                	mov    %edx,%eax
}
80104e60:	5d                   	pop    %ebp
80104e61:	c3                   	ret    

80104e62 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104e62:	55                   	push   %ebp
80104e63:	89 e5                	mov    %esp,%ebp
80104e65:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80104e68:	8b 45 08             	mov    0x8(%ebp),%eax
80104e6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80104e6e:	90                   	nop
80104e6f:	8b 45 10             	mov    0x10(%ebp),%eax
80104e72:	8d 50 ff             	lea    -0x1(%eax),%edx
80104e75:	89 55 10             	mov    %edx,0x10(%ebp)
80104e78:	85 c0                	test   %eax,%eax
80104e7a:	7e 1e                	jle    80104e9a <strncpy+0x38>
80104e7c:	8b 45 08             	mov    0x8(%ebp),%eax
80104e7f:	8d 50 01             	lea    0x1(%eax),%edx
80104e82:	89 55 08             	mov    %edx,0x8(%ebp)
80104e85:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e88:	8d 4a 01             	lea    0x1(%edx),%ecx
80104e8b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80104e8e:	0f b6 12             	movzbl (%edx),%edx
80104e91:	88 10                	mov    %dl,(%eax)
80104e93:	0f b6 00             	movzbl (%eax),%eax
80104e96:	84 c0                	test   %al,%al
80104e98:	75 d5                	jne    80104e6f <strncpy+0xd>
    ;
  while(n-- > 0)
80104e9a:	eb 0c                	jmp    80104ea8 <strncpy+0x46>
    *s++ = 0;
80104e9c:	8b 45 08             	mov    0x8(%ebp),%eax
80104e9f:	8d 50 01             	lea    0x1(%eax),%edx
80104ea2:	89 55 08             	mov    %edx,0x8(%ebp)
80104ea5:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104ea8:	8b 45 10             	mov    0x10(%ebp),%eax
80104eab:	8d 50 ff             	lea    -0x1(%eax),%edx
80104eae:	89 55 10             	mov    %edx,0x10(%ebp)
80104eb1:	85 c0                	test   %eax,%eax
80104eb3:	7f e7                	jg     80104e9c <strncpy+0x3a>
    *s++ = 0;
  return os;
80104eb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104eb8:	c9                   	leave  
80104eb9:	c3                   	ret    

80104eba <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104eba:	55                   	push   %ebp
80104ebb:	89 e5                	mov    %esp,%ebp
80104ebd:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80104ec0:	8b 45 08             	mov    0x8(%ebp),%eax
80104ec3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80104ec6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104eca:	7f 05                	jg     80104ed1 <safestrcpy+0x17>
    return os;
80104ecc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ecf:	eb 31                	jmp    80104f02 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80104ed1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104ed5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104ed9:	7e 1e                	jle    80104ef9 <safestrcpy+0x3f>
80104edb:	8b 45 08             	mov    0x8(%ebp),%eax
80104ede:	8d 50 01             	lea    0x1(%eax),%edx
80104ee1:	89 55 08             	mov    %edx,0x8(%ebp)
80104ee4:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ee7:	8d 4a 01             	lea    0x1(%edx),%ecx
80104eea:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80104eed:	0f b6 12             	movzbl (%edx),%edx
80104ef0:	88 10                	mov    %dl,(%eax)
80104ef2:	0f b6 00             	movzbl (%eax),%eax
80104ef5:	84 c0                	test   %al,%al
80104ef7:	75 d8                	jne    80104ed1 <safestrcpy+0x17>
    ;
  *s = 0;
80104ef9:	8b 45 08             	mov    0x8(%ebp),%eax
80104efc:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80104eff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f02:	c9                   	leave  
80104f03:	c3                   	ret    

80104f04 <strlen>:

int
strlen(const char *s)
{
80104f04:	55                   	push   %ebp
80104f05:	89 e5                	mov    %esp,%ebp
80104f07:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80104f0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80104f11:	eb 04                	jmp    80104f17 <strlen+0x13>
80104f13:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104f17:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104f1a:	8b 45 08             	mov    0x8(%ebp),%eax
80104f1d:	01 d0                	add    %edx,%eax
80104f1f:	0f b6 00             	movzbl (%eax),%eax
80104f22:	84 c0                	test   %al,%al
80104f24:	75 ed                	jne    80104f13 <strlen+0xf>
    ;
  return n;
80104f26:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f29:	c9                   	leave  
80104f2a:	c3                   	ret    

80104f2b <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104f2b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104f2f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104f33:	55                   	push   %ebp
  pushl %ebx
80104f34:	53                   	push   %ebx
  pushl %esi
80104f35:	56                   	push   %esi
  pushl %edi
80104f36:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104f37:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104f39:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104f3b:	5f                   	pop    %edi
  popl %esi
80104f3c:	5e                   	pop    %esi
  popl %ebx
80104f3d:	5b                   	pop    %ebx
  popl %ebp
80104f3e:	5d                   	pop    %ebp
  ret
80104f3f:	c3                   	ret    

80104f40 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80104f43:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f49:	8b 00                	mov    (%eax),%eax
80104f4b:	3b 45 08             	cmp    0x8(%ebp),%eax
80104f4e:	76 12                	jbe    80104f62 <fetchint+0x22>
80104f50:	8b 45 08             	mov    0x8(%ebp),%eax
80104f53:	8d 50 04             	lea    0x4(%eax),%edx
80104f56:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f5c:	8b 00                	mov    (%eax),%eax
80104f5e:	39 c2                	cmp    %eax,%edx
80104f60:	76 07                	jbe    80104f69 <fetchint+0x29>
    return -1;
80104f62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f67:	eb 0f                	jmp    80104f78 <fetchint+0x38>
  *ip = *(int*)(addr);
80104f69:	8b 45 08             	mov    0x8(%ebp),%eax
80104f6c:	8b 10                	mov    (%eax),%edx
80104f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f71:	89 10                	mov    %edx,(%eax)
  return 0;
80104f73:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104f78:	5d                   	pop    %ebp
80104f79:	c3                   	ret    

80104f7a <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104f7a:	55                   	push   %ebp
80104f7b:	89 e5                	mov    %esp,%ebp
80104f7d:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80104f80:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f86:	8b 00                	mov    (%eax),%eax
80104f88:	3b 45 08             	cmp    0x8(%ebp),%eax
80104f8b:	77 07                	ja     80104f94 <fetchstr+0x1a>
    return -1;
80104f8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f92:	eb 46                	jmp    80104fda <fetchstr+0x60>
  *pp = (char*)addr;
80104f94:	8b 55 08             	mov    0x8(%ebp),%edx
80104f97:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f9a:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80104f9c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fa2:	8b 00                	mov    (%eax),%eax
80104fa4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80104fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104faa:	8b 00                	mov    (%eax),%eax
80104fac:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104faf:	eb 1c                	jmp    80104fcd <fetchstr+0x53>
    if(*s == 0)
80104fb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fb4:	0f b6 00             	movzbl (%eax),%eax
80104fb7:	84 c0                	test   %al,%al
80104fb9:	75 0e                	jne    80104fc9 <fetchstr+0x4f>
      return s - *pp;
80104fbb:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fc1:	8b 00                	mov    (%eax),%eax
80104fc3:	29 c2                	sub    %eax,%edx
80104fc5:	89 d0                	mov    %edx,%eax
80104fc7:	eb 11                	jmp    80104fda <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80104fc9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104fcd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fd0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104fd3:	72 dc                	jb     80104fb1 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80104fd5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fda:	c9                   	leave  
80104fdb:	c3                   	ret    

80104fdc <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104fdc:	55                   	push   %ebp
80104fdd:	89 e5                	mov    %esp,%ebp
80104fdf:	83 ec 08             	sub    $0x8,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104fe2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fe8:	8b 40 18             	mov    0x18(%eax),%eax
80104feb:	8b 50 44             	mov    0x44(%eax),%edx
80104fee:	8b 45 08             	mov    0x8(%ebp),%eax
80104ff1:	c1 e0 02             	shl    $0x2,%eax
80104ff4:	01 d0                	add    %edx,%eax
80104ff6:	8d 50 04             	lea    0x4(%eax),%edx
80104ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ffc:	89 44 24 04          	mov    %eax,0x4(%esp)
80105000:	89 14 24             	mov    %edx,(%esp)
80105003:	e8 38 ff ff ff       	call   80104f40 <fetchint>
}
80105008:	c9                   	leave  
80105009:	c3                   	ret    

8010500a <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010500a:	55                   	push   %ebp
8010500b:	89 e5                	mov    %esp,%ebp
8010500d:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105010:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105013:	89 44 24 04          	mov    %eax,0x4(%esp)
80105017:	8b 45 08             	mov    0x8(%ebp),%eax
8010501a:	89 04 24             	mov    %eax,(%esp)
8010501d:	e8 ba ff ff ff       	call   80104fdc <argint>
80105022:	85 c0                	test   %eax,%eax
80105024:	79 07                	jns    8010502d <argptr+0x23>
    return -1;
80105026:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010502b:	eb 3d                	jmp    8010506a <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
8010502d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105030:	89 c2                	mov    %eax,%edx
80105032:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105038:	8b 00                	mov    (%eax),%eax
8010503a:	39 c2                	cmp    %eax,%edx
8010503c:	73 16                	jae    80105054 <argptr+0x4a>
8010503e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105041:	89 c2                	mov    %eax,%edx
80105043:	8b 45 10             	mov    0x10(%ebp),%eax
80105046:	01 c2                	add    %eax,%edx
80105048:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010504e:	8b 00                	mov    (%eax),%eax
80105050:	39 c2                	cmp    %eax,%edx
80105052:	76 07                	jbe    8010505b <argptr+0x51>
    return -1;
80105054:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105059:	eb 0f                	jmp    8010506a <argptr+0x60>
  *pp = (char*)i;
8010505b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010505e:	89 c2                	mov    %eax,%edx
80105060:	8b 45 0c             	mov    0xc(%ebp),%eax
80105063:	89 10                	mov    %edx,(%eax)
  return 0;
80105065:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010506a:	c9                   	leave  
8010506b:	c3                   	ret    

8010506c <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
8010506c:	55                   	push   %ebp
8010506d:	89 e5                	mov    %esp,%ebp
8010506f:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105072:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105075:	89 44 24 04          	mov    %eax,0x4(%esp)
80105079:	8b 45 08             	mov    0x8(%ebp),%eax
8010507c:	89 04 24             	mov    %eax,(%esp)
8010507f:	e8 58 ff ff ff       	call   80104fdc <argint>
80105084:	85 c0                	test   %eax,%eax
80105086:	79 07                	jns    8010508f <argstr+0x23>
    return -1;
80105088:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010508d:	eb 12                	jmp    801050a1 <argstr+0x35>
  return fetchstr(addr, pp);
8010508f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105092:	8b 55 0c             	mov    0xc(%ebp),%edx
80105095:	89 54 24 04          	mov    %edx,0x4(%esp)
80105099:	89 04 24             	mov    %eax,(%esp)
8010509c:	e8 d9 fe ff ff       	call   80104f7a <fetchstr>
}
801050a1:	c9                   	leave  
801050a2:	c3                   	ret    

801050a3 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
801050a3:	55                   	push   %ebp
801050a4:	89 e5                	mov    %esp,%ebp
801050a6:	53                   	push   %ebx
801050a7:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
801050aa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050b0:	8b 40 18             	mov    0x18(%eax),%eax
801050b3:	8b 40 1c             	mov    0x1c(%eax),%eax
801050b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801050b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801050bd:	7e 30                	jle    801050ef <syscall+0x4c>
801050bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050c2:	83 f8 15             	cmp    $0x15,%eax
801050c5:	77 28                	ja     801050ef <syscall+0x4c>
801050c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050ca:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801050d1:	85 c0                	test   %eax,%eax
801050d3:	74 1a                	je     801050ef <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
801050d5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050db:	8b 58 18             	mov    0x18(%eax),%ebx
801050de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050e1:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801050e8:	ff d0                	call   *%eax
801050ea:	89 43 1c             	mov    %eax,0x1c(%ebx)
801050ed:	eb 3d                	jmp    8010512c <syscall+0x89>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
801050ef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050f5:	8d 48 6c             	lea    0x6c(%eax),%ecx
801050f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801050fe:	8b 40 10             	mov    0x10(%eax),%eax
80105101:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105104:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105108:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010510c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105110:	c7 04 24 a3 83 10 80 	movl   $0x801083a3,(%esp)
80105117:	e8 84 b2 ff ff       	call   801003a0 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
8010511c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105122:	8b 40 18             	mov    0x18(%eax),%eax
80105125:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
8010512c:	83 c4 24             	add    $0x24,%esp
8010512f:	5b                   	pop    %ebx
80105130:	5d                   	pop    %ebp
80105131:	c3                   	ret    

80105132 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105132:	55                   	push   %ebp
80105133:	89 e5                	mov    %esp,%ebp
80105135:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105138:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010513b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010513f:	8b 45 08             	mov    0x8(%ebp),%eax
80105142:	89 04 24             	mov    %eax,(%esp)
80105145:	e8 92 fe ff ff       	call   80104fdc <argint>
8010514a:	85 c0                	test   %eax,%eax
8010514c:	79 07                	jns    80105155 <argfd+0x23>
    return -1;
8010514e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105153:	eb 50                	jmp    801051a5 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105155:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105158:	85 c0                	test   %eax,%eax
8010515a:	78 21                	js     8010517d <argfd+0x4b>
8010515c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010515f:	83 f8 0f             	cmp    $0xf,%eax
80105162:	7f 19                	jg     8010517d <argfd+0x4b>
80105164:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010516a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010516d:	83 c2 08             	add    $0x8,%edx
80105170:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105174:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105177:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010517b:	75 07                	jne    80105184 <argfd+0x52>
    return -1;
8010517d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105182:	eb 21                	jmp    801051a5 <argfd+0x73>
  if(pfd)
80105184:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105188:	74 08                	je     80105192 <argfd+0x60>
    *pfd = fd;
8010518a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010518d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105190:	89 10                	mov    %edx,(%eax)
  if(pf)
80105192:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105196:	74 08                	je     801051a0 <argfd+0x6e>
    *pf = f;
80105198:	8b 45 10             	mov    0x10(%ebp),%eax
8010519b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010519e:	89 10                	mov    %edx,(%eax)
  return 0;
801051a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801051a5:	c9                   	leave  
801051a6:	c3                   	ret    

801051a7 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801051a7:	55                   	push   %ebp
801051a8:	89 e5                	mov    %esp,%ebp
801051aa:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801051ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801051b4:	eb 30                	jmp    801051e6 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
801051b6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
801051bf:	83 c2 08             	add    $0x8,%edx
801051c2:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801051c6:	85 c0                	test   %eax,%eax
801051c8:	75 18                	jne    801051e2 <fdalloc+0x3b>
      proc->ofile[fd] = f;
801051ca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
801051d3:	8d 4a 08             	lea    0x8(%edx),%ecx
801051d6:	8b 55 08             	mov    0x8(%ebp),%edx
801051d9:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801051dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051e0:	eb 0f                	jmp    801051f1 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801051e2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801051e6:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
801051ea:	7e ca                	jle    801051b6 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801051ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051f1:	c9                   	leave  
801051f2:	c3                   	ret    

801051f3 <sys_dup>:

int
sys_dup(void)
{
801051f3:	55                   	push   %ebp
801051f4:	89 e5                	mov    %esp,%ebp
801051f6:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
801051f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051fc:	89 44 24 08          	mov    %eax,0x8(%esp)
80105200:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105207:	00 
80105208:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010520f:	e8 1e ff ff ff       	call   80105132 <argfd>
80105214:	85 c0                	test   %eax,%eax
80105216:	79 07                	jns    8010521f <sys_dup+0x2c>
    return -1;
80105218:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010521d:	eb 29                	jmp    80105248 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
8010521f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105222:	89 04 24             	mov    %eax,(%esp)
80105225:	e8 7d ff ff ff       	call   801051a7 <fdalloc>
8010522a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010522d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105231:	79 07                	jns    8010523a <sys_dup+0x47>
    return -1;
80105233:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105238:	eb 0e                	jmp    80105248 <sys_dup+0x55>
  filedup(f);
8010523a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010523d:	89 04 24             	mov    %eax,(%esp)
80105240:	e8 2d bd ff ff       	call   80100f72 <filedup>
  return fd;
80105245:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105248:	c9                   	leave  
80105249:	c3                   	ret    

8010524a <sys_read>:

int
sys_read(void)
{
8010524a:	55                   	push   %ebp
8010524b:	89 e5                	mov    %esp,%ebp
8010524d:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105250:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105253:	89 44 24 08          	mov    %eax,0x8(%esp)
80105257:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010525e:	00 
8010525f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105266:	e8 c7 fe ff ff       	call   80105132 <argfd>
8010526b:	85 c0                	test   %eax,%eax
8010526d:	78 35                	js     801052a4 <sys_read+0x5a>
8010526f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105272:	89 44 24 04          	mov    %eax,0x4(%esp)
80105276:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010527d:	e8 5a fd ff ff       	call   80104fdc <argint>
80105282:	85 c0                	test   %eax,%eax
80105284:	78 1e                	js     801052a4 <sys_read+0x5a>
80105286:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105289:	89 44 24 08          	mov    %eax,0x8(%esp)
8010528d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105290:	89 44 24 04          	mov    %eax,0x4(%esp)
80105294:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010529b:	e8 6a fd ff ff       	call   8010500a <argptr>
801052a0:	85 c0                	test   %eax,%eax
801052a2:	79 07                	jns    801052ab <sys_read+0x61>
    return -1;
801052a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052a9:	eb 19                	jmp    801052c4 <sys_read+0x7a>
  return fileread(f, p, n);
801052ab:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801052ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
801052b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052b4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801052b8:	89 54 24 04          	mov    %edx,0x4(%esp)
801052bc:	89 04 24             	mov    %eax,(%esp)
801052bf:	e8 1b be ff ff       	call   801010df <fileread>
}
801052c4:	c9                   	leave  
801052c5:	c3                   	ret    

801052c6 <sys_write>:

int
sys_write(void)
{
801052c6:	55                   	push   %ebp
801052c7:	89 e5                	mov    %esp,%ebp
801052c9:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801052cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052cf:	89 44 24 08          	mov    %eax,0x8(%esp)
801052d3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801052da:	00 
801052db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052e2:	e8 4b fe ff ff       	call   80105132 <argfd>
801052e7:	85 c0                	test   %eax,%eax
801052e9:	78 35                	js     80105320 <sys_write+0x5a>
801052eb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052ee:	89 44 24 04          	mov    %eax,0x4(%esp)
801052f2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801052f9:	e8 de fc ff ff       	call   80104fdc <argint>
801052fe:	85 c0                	test   %eax,%eax
80105300:	78 1e                	js     80105320 <sys_write+0x5a>
80105302:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105305:	89 44 24 08          	mov    %eax,0x8(%esp)
80105309:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010530c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105310:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105317:	e8 ee fc ff ff       	call   8010500a <argptr>
8010531c:	85 c0                	test   %eax,%eax
8010531e:	79 07                	jns    80105327 <sys_write+0x61>
    return -1;
80105320:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105325:	eb 19                	jmp    80105340 <sys_write+0x7a>
  return filewrite(f, p, n);
80105327:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010532a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010532d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105330:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105334:	89 54 24 04          	mov    %edx,0x4(%esp)
80105338:	89 04 24             	mov    %eax,(%esp)
8010533b:	e8 5b be ff ff       	call   8010119b <filewrite>
}
80105340:	c9                   	leave  
80105341:	c3                   	ret    

80105342 <sys_close>:

int
sys_close(void)
{
80105342:	55                   	push   %ebp
80105343:	89 e5                	mov    %esp,%ebp
80105345:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105348:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010534b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010534f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105352:	89 44 24 04          	mov    %eax,0x4(%esp)
80105356:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010535d:	e8 d0 fd ff ff       	call   80105132 <argfd>
80105362:	85 c0                	test   %eax,%eax
80105364:	79 07                	jns    8010536d <sys_close+0x2b>
    return -1;
80105366:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010536b:	eb 24                	jmp    80105391 <sys_close+0x4f>
  proc->ofile[fd] = 0;
8010536d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105373:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105376:	83 c2 08             	add    $0x8,%edx
80105379:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105380:	00 
  fileclose(f);
80105381:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105384:	89 04 24             	mov    %eax,(%esp)
80105387:	e8 2e bc ff ff       	call   80100fba <fileclose>
  return 0;
8010538c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105391:	c9                   	leave  
80105392:	c3                   	ret    

80105393 <sys_fstat>:

int
sys_fstat(void)
{
80105393:	55                   	push   %ebp
80105394:	89 e5                	mov    %esp,%ebp
80105396:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105399:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010539c:	89 44 24 08          	mov    %eax,0x8(%esp)
801053a0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801053a7:	00 
801053a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053af:	e8 7e fd ff ff       	call   80105132 <argfd>
801053b4:	85 c0                	test   %eax,%eax
801053b6:	78 1f                	js     801053d7 <sys_fstat+0x44>
801053b8:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801053bf:	00 
801053c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801053c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801053ce:	e8 37 fc ff ff       	call   8010500a <argptr>
801053d3:	85 c0                	test   %eax,%eax
801053d5:	79 07                	jns    801053de <sys_fstat+0x4b>
    return -1;
801053d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053dc:	eb 12                	jmp    801053f0 <sys_fstat+0x5d>
  return filestat(f, st);
801053de:	8b 55 f0             	mov    -0x10(%ebp),%edx
801053e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053e4:	89 54 24 04          	mov    %edx,0x4(%esp)
801053e8:	89 04 24             	mov    %eax,(%esp)
801053eb:	e8 a0 bc ff ff       	call   80101090 <filestat>
}
801053f0:	c9                   	leave  
801053f1:	c3                   	ret    

801053f2 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801053f2:	55                   	push   %ebp
801053f3:	89 e5                	mov    %esp,%ebp
801053f5:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801053f8:	8d 45 d8             	lea    -0x28(%ebp),%eax
801053fb:	89 44 24 04          	mov    %eax,0x4(%esp)
801053ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105406:	e8 61 fc ff ff       	call   8010506c <argstr>
8010540b:	85 c0                	test   %eax,%eax
8010540d:	78 17                	js     80105426 <sys_link+0x34>
8010540f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105412:	89 44 24 04          	mov    %eax,0x4(%esp)
80105416:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010541d:	e8 4a fc ff ff       	call   8010506c <argstr>
80105422:	85 c0                	test   %eax,%eax
80105424:	79 0a                	jns    80105430 <sys_link+0x3e>
    return -1;
80105426:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010542b:	e9 3d 01 00 00       	jmp    8010556d <sys_link+0x17b>
  if((ip = namei(old)) == 0)
80105430:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105433:	89 04 24             	mov    %eax,(%esp)
80105436:	e8 b7 cf ff ff       	call   801023f2 <namei>
8010543b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010543e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105442:	75 0a                	jne    8010544e <sys_link+0x5c>
    return -1;
80105444:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105449:	e9 1f 01 00 00       	jmp    8010556d <sys_link+0x17b>

  begin_trans();
8010544e:	e8 7e dd ff ff       	call   801031d1 <begin_trans>

  ilock(ip);
80105453:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105456:	89 04 24             	mov    %eax,(%esp)
80105459:	e8 e9 c3 ff ff       	call   80101847 <ilock>
  if(ip->type == T_DIR){
8010545e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105461:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105465:	66 83 f8 01          	cmp    $0x1,%ax
80105469:	75 1a                	jne    80105485 <sys_link+0x93>
    iunlockput(ip);
8010546b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010546e:	89 04 24             	mov    %eax,(%esp)
80105471:	e8 55 c6 ff ff       	call   80101acb <iunlockput>
    commit_trans();
80105476:	e8 9f dd ff ff       	call   8010321a <commit_trans>
    return -1;
8010547b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105480:	e9 e8 00 00 00       	jmp    8010556d <sys_link+0x17b>
  }

  ip->nlink++;
80105485:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105488:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010548c:	8d 50 01             	lea    0x1(%eax),%edx
8010548f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105492:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105496:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105499:	89 04 24             	mov    %eax,(%esp)
8010549c:	e8 ea c1 ff ff       	call   8010168b <iupdate>
  iunlock(ip);
801054a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054a4:	89 04 24             	mov    %eax,(%esp)
801054a7:	e8 e9 c4 ff ff       	call   80101995 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
801054ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
801054af:	8d 55 e2             	lea    -0x1e(%ebp),%edx
801054b2:	89 54 24 04          	mov    %edx,0x4(%esp)
801054b6:	89 04 24             	mov    %eax,(%esp)
801054b9:	e8 56 cf ff ff       	call   80102414 <nameiparent>
801054be:	89 45 f0             	mov    %eax,-0x10(%ebp)
801054c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801054c5:	75 02                	jne    801054c9 <sys_link+0xd7>
    goto bad;
801054c7:	eb 68                	jmp    80105531 <sys_link+0x13f>
  ilock(dp);
801054c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054cc:	89 04 24             	mov    %eax,(%esp)
801054cf:	e8 73 c3 ff ff       	call   80101847 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801054d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054d7:	8b 10                	mov    (%eax),%edx
801054d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054dc:	8b 00                	mov    (%eax),%eax
801054de:	39 c2                	cmp    %eax,%edx
801054e0:	75 20                	jne    80105502 <sys_link+0x110>
801054e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054e5:	8b 40 04             	mov    0x4(%eax),%eax
801054e8:	89 44 24 08          	mov    %eax,0x8(%esp)
801054ec:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801054ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801054f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054f6:	89 04 24             	mov    %eax,(%esp)
801054f9:	e8 34 cc ff ff       	call   80102132 <dirlink>
801054fe:	85 c0                	test   %eax,%eax
80105500:	79 0d                	jns    8010550f <sys_link+0x11d>
    iunlockput(dp);
80105502:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105505:	89 04 24             	mov    %eax,(%esp)
80105508:	e8 be c5 ff ff       	call   80101acb <iunlockput>
    goto bad;
8010550d:	eb 22                	jmp    80105531 <sys_link+0x13f>
  }
  iunlockput(dp);
8010550f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105512:	89 04 24             	mov    %eax,(%esp)
80105515:	e8 b1 c5 ff ff       	call   80101acb <iunlockput>
  iput(ip);
8010551a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010551d:	89 04 24             	mov    %eax,(%esp)
80105520:	e8 d5 c4 ff ff       	call   801019fa <iput>

  commit_trans();
80105525:	e8 f0 dc ff ff       	call   8010321a <commit_trans>

  return 0;
8010552a:	b8 00 00 00 00       	mov    $0x0,%eax
8010552f:	eb 3c                	jmp    8010556d <sys_link+0x17b>

bad:
  ilock(ip);
80105531:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105534:	89 04 24             	mov    %eax,(%esp)
80105537:	e8 0b c3 ff ff       	call   80101847 <ilock>
  ip->nlink--;
8010553c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010553f:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105543:	8d 50 ff             	lea    -0x1(%eax),%edx
80105546:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105549:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010554d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105550:	89 04 24             	mov    %eax,(%esp)
80105553:	e8 33 c1 ff ff       	call   8010168b <iupdate>
  iunlockput(ip);
80105558:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010555b:	89 04 24             	mov    %eax,(%esp)
8010555e:	e8 68 c5 ff ff       	call   80101acb <iunlockput>
  commit_trans();
80105563:	e8 b2 dc ff ff       	call   8010321a <commit_trans>
  return -1;
80105568:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010556d:	c9                   	leave  
8010556e:	c3                   	ret    

8010556f <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
8010556f:	55                   	push   %ebp
80105570:	89 e5                	mov    %esp,%ebp
80105572:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105575:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
8010557c:	eb 4b                	jmp    801055c9 <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010557e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105581:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105588:	00 
80105589:	89 44 24 08          	mov    %eax,0x8(%esp)
8010558d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105590:	89 44 24 04          	mov    %eax,0x4(%esp)
80105594:	8b 45 08             	mov    0x8(%ebp),%eax
80105597:	89 04 24             	mov    %eax,(%esp)
8010559a:	e8 b5 c7 ff ff       	call   80101d54 <readi>
8010559f:	83 f8 10             	cmp    $0x10,%eax
801055a2:	74 0c                	je     801055b0 <isdirempty+0x41>
      panic("isdirempty: readi");
801055a4:	c7 04 24 bf 83 10 80 	movl   $0x801083bf,(%esp)
801055ab:	e8 8a af ff ff       	call   8010053a <panic>
    if(de.inum != 0)
801055b0:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801055b4:	66 85 c0             	test   %ax,%ax
801055b7:	74 07                	je     801055c0 <isdirempty+0x51>
      return 0;
801055b9:	b8 00 00 00 00       	mov    $0x0,%eax
801055be:	eb 1b                	jmp    801055db <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801055c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055c3:	83 c0 10             	add    $0x10,%eax
801055c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801055c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055cc:	8b 45 08             	mov    0x8(%ebp),%eax
801055cf:	8b 40 18             	mov    0x18(%eax),%eax
801055d2:	39 c2                	cmp    %eax,%edx
801055d4:	72 a8                	jb     8010557e <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
801055d6:	b8 01 00 00 00       	mov    $0x1,%eax
}
801055db:	c9                   	leave  
801055dc:	c3                   	ret    

801055dd <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801055dd:	55                   	push   %ebp
801055de:	89 e5                	mov    %esp,%ebp
801055e0:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801055e3:	8d 45 cc             	lea    -0x34(%ebp),%eax
801055e6:	89 44 24 04          	mov    %eax,0x4(%esp)
801055ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801055f1:	e8 76 fa ff ff       	call   8010506c <argstr>
801055f6:	85 c0                	test   %eax,%eax
801055f8:	79 0a                	jns    80105604 <sys_unlink+0x27>
    return -1;
801055fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055ff:	e9 aa 01 00 00       	jmp    801057ae <sys_unlink+0x1d1>
  if((dp = nameiparent(path, name)) == 0)
80105604:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105607:	8d 55 d2             	lea    -0x2e(%ebp),%edx
8010560a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010560e:	89 04 24             	mov    %eax,(%esp)
80105611:	e8 fe cd ff ff       	call   80102414 <nameiparent>
80105616:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105619:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010561d:	75 0a                	jne    80105629 <sys_unlink+0x4c>
    return -1;
8010561f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105624:	e9 85 01 00 00       	jmp    801057ae <sys_unlink+0x1d1>

  begin_trans();
80105629:	e8 a3 db ff ff       	call   801031d1 <begin_trans>

  ilock(dp);
8010562e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105631:	89 04 24             	mov    %eax,(%esp)
80105634:	e8 0e c2 ff ff       	call   80101847 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105639:	c7 44 24 04 d1 83 10 	movl   $0x801083d1,0x4(%esp)
80105640:	80 
80105641:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105644:	89 04 24             	mov    %eax,(%esp)
80105647:	e8 fb c9 ff ff       	call   80102047 <namecmp>
8010564c:	85 c0                	test   %eax,%eax
8010564e:	0f 84 45 01 00 00    	je     80105799 <sys_unlink+0x1bc>
80105654:	c7 44 24 04 d3 83 10 	movl   $0x801083d3,0x4(%esp)
8010565b:	80 
8010565c:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010565f:	89 04 24             	mov    %eax,(%esp)
80105662:	e8 e0 c9 ff ff       	call   80102047 <namecmp>
80105667:	85 c0                	test   %eax,%eax
80105669:	0f 84 2a 01 00 00    	je     80105799 <sys_unlink+0x1bc>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010566f:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105672:	89 44 24 08          	mov    %eax,0x8(%esp)
80105676:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105679:	89 44 24 04          	mov    %eax,0x4(%esp)
8010567d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105680:	89 04 24             	mov    %eax,(%esp)
80105683:	e8 e1 c9 ff ff       	call   80102069 <dirlookup>
80105688:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010568b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010568f:	75 05                	jne    80105696 <sys_unlink+0xb9>
    goto bad;
80105691:	e9 03 01 00 00       	jmp    80105799 <sys_unlink+0x1bc>
  ilock(ip);
80105696:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105699:	89 04 24             	mov    %eax,(%esp)
8010569c:	e8 a6 c1 ff ff       	call   80101847 <ilock>

  if(ip->nlink < 1)
801056a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056a4:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801056a8:	66 85 c0             	test   %ax,%ax
801056ab:	7f 0c                	jg     801056b9 <sys_unlink+0xdc>
    panic("unlink: nlink < 1");
801056ad:	c7 04 24 d6 83 10 80 	movl   $0x801083d6,(%esp)
801056b4:	e8 81 ae ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801056b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056bc:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801056c0:	66 83 f8 01          	cmp    $0x1,%ax
801056c4:	75 1f                	jne    801056e5 <sys_unlink+0x108>
801056c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056c9:	89 04 24             	mov    %eax,(%esp)
801056cc:	e8 9e fe ff ff       	call   8010556f <isdirempty>
801056d1:	85 c0                	test   %eax,%eax
801056d3:	75 10                	jne    801056e5 <sys_unlink+0x108>
    iunlockput(ip);
801056d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056d8:	89 04 24             	mov    %eax,(%esp)
801056db:	e8 eb c3 ff ff       	call   80101acb <iunlockput>
    goto bad;
801056e0:	e9 b4 00 00 00       	jmp    80105799 <sys_unlink+0x1bc>
  }

  memset(&de, 0, sizeof(de));
801056e5:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801056ec:	00 
801056ed:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801056f4:	00 
801056f5:	8d 45 e0             	lea    -0x20(%ebp),%eax
801056f8:	89 04 24             	mov    %eax,(%esp)
801056fb:	e8 9a f5 ff ff       	call   80104c9a <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105700:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105703:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010570a:	00 
8010570b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010570f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105712:	89 44 24 04          	mov    %eax,0x4(%esp)
80105716:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105719:	89 04 24             	mov    %eax,(%esp)
8010571c:	e8 97 c7 ff ff       	call   80101eb8 <writei>
80105721:	83 f8 10             	cmp    $0x10,%eax
80105724:	74 0c                	je     80105732 <sys_unlink+0x155>
    panic("unlink: writei");
80105726:	c7 04 24 e8 83 10 80 	movl   $0x801083e8,(%esp)
8010572d:	e8 08 ae ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR){
80105732:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105735:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105739:	66 83 f8 01          	cmp    $0x1,%ax
8010573d:	75 1c                	jne    8010575b <sys_unlink+0x17e>
    dp->nlink--;
8010573f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105742:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105746:	8d 50 ff             	lea    -0x1(%eax),%edx
80105749:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010574c:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105750:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105753:	89 04 24             	mov    %eax,(%esp)
80105756:	e8 30 bf ff ff       	call   8010168b <iupdate>
  }
  iunlockput(dp);
8010575b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010575e:	89 04 24             	mov    %eax,(%esp)
80105761:	e8 65 c3 ff ff       	call   80101acb <iunlockput>

  ip->nlink--;
80105766:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105769:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010576d:	8d 50 ff             	lea    -0x1(%eax),%edx
80105770:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105773:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105777:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010577a:	89 04 24             	mov    %eax,(%esp)
8010577d:	e8 09 bf ff ff       	call   8010168b <iupdate>
  iunlockput(ip);
80105782:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105785:	89 04 24             	mov    %eax,(%esp)
80105788:	e8 3e c3 ff ff       	call   80101acb <iunlockput>

  commit_trans();
8010578d:	e8 88 da ff ff       	call   8010321a <commit_trans>

  return 0;
80105792:	b8 00 00 00 00       	mov    $0x0,%eax
80105797:	eb 15                	jmp    801057ae <sys_unlink+0x1d1>

bad:
  iunlockput(dp);
80105799:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010579c:	89 04 24             	mov    %eax,(%esp)
8010579f:	e8 27 c3 ff ff       	call   80101acb <iunlockput>
  commit_trans();
801057a4:	e8 71 da ff ff       	call   8010321a <commit_trans>
  return -1;
801057a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057ae:	c9                   	leave  
801057af:	c3                   	ret    

801057b0 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
801057b0:	55                   	push   %ebp
801057b1:	89 e5                	mov    %esp,%ebp
801057b3:	83 ec 48             	sub    $0x48,%esp
801057b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801057b9:	8b 55 10             	mov    0x10(%ebp),%edx
801057bc:	8b 45 14             	mov    0x14(%ebp),%eax
801057bf:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
801057c3:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
801057c7:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801057cb:	8d 45 de             	lea    -0x22(%ebp),%eax
801057ce:	89 44 24 04          	mov    %eax,0x4(%esp)
801057d2:	8b 45 08             	mov    0x8(%ebp),%eax
801057d5:	89 04 24             	mov    %eax,(%esp)
801057d8:	e8 37 cc ff ff       	call   80102414 <nameiparent>
801057dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
801057e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801057e4:	75 0a                	jne    801057f0 <create+0x40>
    return 0;
801057e6:	b8 00 00 00 00       	mov    $0x0,%eax
801057eb:	e9 7e 01 00 00       	jmp    8010596e <create+0x1be>
  ilock(dp);
801057f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057f3:	89 04 24             	mov    %eax,(%esp)
801057f6:	e8 4c c0 ff ff       	call   80101847 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801057fb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801057fe:	89 44 24 08          	mov    %eax,0x8(%esp)
80105802:	8d 45 de             	lea    -0x22(%ebp),%eax
80105805:	89 44 24 04          	mov    %eax,0x4(%esp)
80105809:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010580c:	89 04 24             	mov    %eax,(%esp)
8010580f:	e8 55 c8 ff ff       	call   80102069 <dirlookup>
80105814:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105817:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010581b:	74 47                	je     80105864 <create+0xb4>
    iunlockput(dp);
8010581d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105820:	89 04 24             	mov    %eax,(%esp)
80105823:	e8 a3 c2 ff ff       	call   80101acb <iunlockput>
    ilock(ip);
80105828:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010582b:	89 04 24             	mov    %eax,(%esp)
8010582e:	e8 14 c0 ff ff       	call   80101847 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105833:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105838:	75 15                	jne    8010584f <create+0x9f>
8010583a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010583d:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105841:	66 83 f8 02          	cmp    $0x2,%ax
80105845:	75 08                	jne    8010584f <create+0x9f>
      return ip;
80105847:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010584a:	e9 1f 01 00 00       	jmp    8010596e <create+0x1be>
    iunlockput(ip);
8010584f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105852:	89 04 24             	mov    %eax,(%esp)
80105855:	e8 71 c2 ff ff       	call   80101acb <iunlockput>
    return 0;
8010585a:	b8 00 00 00 00       	mov    $0x0,%eax
8010585f:	e9 0a 01 00 00       	jmp    8010596e <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105864:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105868:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010586b:	8b 00                	mov    (%eax),%eax
8010586d:	89 54 24 04          	mov    %edx,0x4(%esp)
80105871:	89 04 24             	mov    %eax,(%esp)
80105874:	e8 33 bd ff ff       	call   801015ac <ialloc>
80105879:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010587c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105880:	75 0c                	jne    8010588e <create+0xde>
    panic("create: ialloc");
80105882:	c7 04 24 f7 83 10 80 	movl   $0x801083f7,(%esp)
80105889:	e8 ac ac ff ff       	call   8010053a <panic>

  ilock(ip);
8010588e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105891:	89 04 24             	mov    %eax,(%esp)
80105894:	e8 ae bf ff ff       	call   80101847 <ilock>
  ip->major = major;
80105899:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010589c:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
801058a0:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
801058a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058a7:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
801058ab:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
801058af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058b2:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
801058b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058bb:	89 04 24             	mov    %eax,(%esp)
801058be:	e8 c8 bd ff ff       	call   8010168b <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
801058c3:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801058c8:	75 6a                	jne    80105934 <create+0x184>
    dp->nlink++;  // for ".."
801058ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058cd:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801058d1:	8d 50 01             	lea    0x1(%eax),%edx
801058d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058d7:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801058db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058de:	89 04 24             	mov    %eax,(%esp)
801058e1:	e8 a5 bd ff ff       	call   8010168b <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801058e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058e9:	8b 40 04             	mov    0x4(%eax),%eax
801058ec:	89 44 24 08          	mov    %eax,0x8(%esp)
801058f0:	c7 44 24 04 d1 83 10 	movl   $0x801083d1,0x4(%esp)
801058f7:	80 
801058f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058fb:	89 04 24             	mov    %eax,(%esp)
801058fe:	e8 2f c8 ff ff       	call   80102132 <dirlink>
80105903:	85 c0                	test   %eax,%eax
80105905:	78 21                	js     80105928 <create+0x178>
80105907:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010590a:	8b 40 04             	mov    0x4(%eax),%eax
8010590d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105911:	c7 44 24 04 d3 83 10 	movl   $0x801083d3,0x4(%esp)
80105918:	80 
80105919:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010591c:	89 04 24             	mov    %eax,(%esp)
8010591f:	e8 0e c8 ff ff       	call   80102132 <dirlink>
80105924:	85 c0                	test   %eax,%eax
80105926:	79 0c                	jns    80105934 <create+0x184>
      panic("create dots");
80105928:	c7 04 24 06 84 10 80 	movl   $0x80108406,(%esp)
8010592f:	e8 06 ac ff ff       	call   8010053a <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105934:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105937:	8b 40 04             	mov    0x4(%eax),%eax
8010593a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010593e:	8d 45 de             	lea    -0x22(%ebp),%eax
80105941:	89 44 24 04          	mov    %eax,0x4(%esp)
80105945:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105948:	89 04 24             	mov    %eax,(%esp)
8010594b:	e8 e2 c7 ff ff       	call   80102132 <dirlink>
80105950:	85 c0                	test   %eax,%eax
80105952:	79 0c                	jns    80105960 <create+0x1b0>
    panic("create: dirlink");
80105954:	c7 04 24 12 84 10 80 	movl   $0x80108412,(%esp)
8010595b:	e8 da ab ff ff       	call   8010053a <panic>

  iunlockput(dp);
80105960:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105963:	89 04 24             	mov    %eax,(%esp)
80105966:	e8 60 c1 ff ff       	call   80101acb <iunlockput>

  return ip;
8010596b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010596e:	c9                   	leave  
8010596f:	c3                   	ret    

80105970 <sys_open>:

int
sys_open(void)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105976:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105979:	89 44 24 04          	mov    %eax,0x4(%esp)
8010597d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105984:	e8 e3 f6 ff ff       	call   8010506c <argstr>
80105989:	85 c0                	test   %eax,%eax
8010598b:	78 17                	js     801059a4 <sys_open+0x34>
8010598d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105990:	89 44 24 04          	mov    %eax,0x4(%esp)
80105994:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010599b:	e8 3c f6 ff ff       	call   80104fdc <argint>
801059a0:	85 c0                	test   %eax,%eax
801059a2:	79 0a                	jns    801059ae <sys_open+0x3e>
    return -1;
801059a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059a9:	e9 48 01 00 00       	jmp    80105af6 <sys_open+0x186>
  if(omode & O_CREATE){
801059ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801059b1:	25 00 02 00 00       	and    $0x200,%eax
801059b6:	85 c0                	test   %eax,%eax
801059b8:	74 40                	je     801059fa <sys_open+0x8a>
    begin_trans();
801059ba:	e8 12 d8 ff ff       	call   801031d1 <begin_trans>
    ip = create(path, T_FILE, 0, 0);
801059bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
801059c2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
801059c9:	00 
801059ca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801059d1:	00 
801059d2:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
801059d9:	00 
801059da:	89 04 24             	mov    %eax,(%esp)
801059dd:	e8 ce fd ff ff       	call   801057b0 <create>
801059e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
801059e5:	e8 30 d8 ff ff       	call   8010321a <commit_trans>
    if(ip == 0)
801059ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801059ee:	75 5c                	jne    80105a4c <sys_open+0xdc>
      return -1;
801059f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059f5:	e9 fc 00 00 00       	jmp    80105af6 <sys_open+0x186>
  } else {
    if((ip = namei(path)) == 0)
801059fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
801059fd:	89 04 24             	mov    %eax,(%esp)
80105a00:	e8 ed c9 ff ff       	call   801023f2 <namei>
80105a05:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a0c:	75 0a                	jne    80105a18 <sys_open+0xa8>
      return -1;
80105a0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a13:	e9 de 00 00 00       	jmp    80105af6 <sys_open+0x186>
    ilock(ip);
80105a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a1b:	89 04 24             	mov    %eax,(%esp)
80105a1e:	e8 24 be ff ff       	call   80101847 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a26:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105a2a:	66 83 f8 01          	cmp    $0x1,%ax
80105a2e:	75 1c                	jne    80105a4c <sys_open+0xdc>
80105a30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105a33:	85 c0                	test   %eax,%eax
80105a35:	74 15                	je     80105a4c <sys_open+0xdc>
      iunlockput(ip);
80105a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a3a:	89 04 24             	mov    %eax,(%esp)
80105a3d:	e8 89 c0 ff ff       	call   80101acb <iunlockput>
      return -1;
80105a42:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a47:	e9 aa 00 00 00       	jmp    80105af6 <sys_open+0x186>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105a4c:	e8 c1 b4 ff ff       	call   80100f12 <filealloc>
80105a51:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105a54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105a58:	74 14                	je     80105a6e <sys_open+0xfe>
80105a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a5d:	89 04 24             	mov    %eax,(%esp)
80105a60:	e8 42 f7 ff ff       	call   801051a7 <fdalloc>
80105a65:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105a68:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105a6c:	79 23                	jns    80105a91 <sys_open+0x121>
    if(f)
80105a6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105a72:	74 0b                	je     80105a7f <sys_open+0x10f>
      fileclose(f);
80105a74:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a77:	89 04 24             	mov    %eax,(%esp)
80105a7a:	e8 3b b5 ff ff       	call   80100fba <fileclose>
    iunlockput(ip);
80105a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a82:	89 04 24             	mov    %eax,(%esp)
80105a85:	e8 41 c0 ff ff       	call   80101acb <iunlockput>
    return -1;
80105a8a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a8f:	eb 65                	jmp    80105af6 <sys_open+0x186>
  }
  iunlock(ip);
80105a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a94:	89 04 24             	mov    %eax,(%esp)
80105a97:	e8 f9 be ff ff       	call   80101995 <iunlock>

  f->type = FD_INODE;
80105a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a9f:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105aa8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105aab:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ab1:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105ab8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105abb:	83 e0 01             	and    $0x1,%eax
80105abe:	85 c0                	test   %eax,%eax
80105ac0:	0f 94 c0             	sete   %al
80105ac3:	89 c2                	mov    %eax,%edx
80105ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ac8:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105acb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ace:	83 e0 01             	and    $0x1,%eax
80105ad1:	85 c0                	test   %eax,%eax
80105ad3:	75 0a                	jne    80105adf <sys_open+0x16f>
80105ad5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ad8:	83 e0 02             	and    $0x2,%eax
80105adb:	85 c0                	test   %eax,%eax
80105add:	74 07                	je     80105ae6 <sys_open+0x176>
80105adf:	b8 01 00 00 00       	mov    $0x1,%eax
80105ae4:	eb 05                	jmp    80105aeb <sys_open+0x17b>
80105ae6:	b8 00 00 00 00       	mov    $0x0,%eax
80105aeb:	89 c2                	mov    %eax,%edx
80105aed:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105af0:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105af3:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105af6:	c9                   	leave  
80105af7:	c3                   	ret    

80105af8 <sys_mkdir>:

int
sys_mkdir(void)
{
80105af8:	55                   	push   %ebp
80105af9:	89 e5                	mov    %esp,%ebp
80105afb:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_trans();
80105afe:	e8 ce d6 ff ff       	call   801031d1 <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105b03:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b06:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b0a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105b11:	e8 56 f5 ff ff       	call   8010506c <argstr>
80105b16:	85 c0                	test   %eax,%eax
80105b18:	78 2c                	js     80105b46 <sys_mkdir+0x4e>
80105b1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b1d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105b24:	00 
80105b25:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105b2c:	00 
80105b2d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80105b34:	00 
80105b35:	89 04 24             	mov    %eax,(%esp)
80105b38:	e8 73 fc ff ff       	call   801057b0 <create>
80105b3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b44:	75 0c                	jne    80105b52 <sys_mkdir+0x5a>
    commit_trans();
80105b46:	e8 cf d6 ff ff       	call   8010321a <commit_trans>
    return -1;
80105b4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b50:	eb 15                	jmp    80105b67 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
80105b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b55:	89 04 24             	mov    %eax,(%esp)
80105b58:	e8 6e bf ff ff       	call   80101acb <iunlockput>
  commit_trans();
80105b5d:	e8 b8 d6 ff ff       	call   8010321a <commit_trans>
  return 0;
80105b62:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b67:	c9                   	leave  
80105b68:	c3                   	ret    

80105b69 <sys_mknod>:

int
sys_mknod(void)
{
80105b69:	55                   	push   %ebp
80105b6a:	89 e5                	mov    %esp,%ebp
80105b6c:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
80105b6f:	e8 5d d6 ff ff       	call   801031d1 <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
80105b74:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b77:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b7b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105b82:	e8 e5 f4 ff ff       	call   8010506c <argstr>
80105b87:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b8e:	78 5e                	js     80105bee <sys_mknod+0x85>
     argint(1, &major) < 0 ||
80105b90:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105b93:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b97:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105b9e:	e8 39 f4 ff ff       	call   80104fdc <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
80105ba3:	85 c0                	test   %eax,%eax
80105ba5:	78 47                	js     80105bee <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105ba7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105baa:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bae:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105bb5:	e8 22 f4 ff ff       	call   80104fdc <argint>
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105bba:	85 c0                	test   %eax,%eax
80105bbc:	78 30                	js     80105bee <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80105bbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105bc1:	0f bf c8             	movswl %ax,%ecx
80105bc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105bc7:	0f bf d0             	movswl %ax,%edx
80105bca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105bcd:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80105bd1:	89 54 24 08          	mov    %edx,0x8(%esp)
80105bd5:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80105bdc:	00 
80105bdd:	89 04 24             	mov    %eax,(%esp)
80105be0:	e8 cb fb ff ff       	call   801057b0 <create>
80105be5:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105be8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105bec:	75 0c                	jne    80105bfa <sys_mknod+0x91>
     (ip = create(path, T_DEV, major, minor)) == 0){
    commit_trans();
80105bee:	e8 27 d6 ff ff       	call   8010321a <commit_trans>
    return -1;
80105bf3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bf8:	eb 15                	jmp    80105c0f <sys_mknod+0xa6>
  }
  iunlockput(ip);
80105bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bfd:	89 04 24             	mov    %eax,(%esp)
80105c00:	e8 c6 be ff ff       	call   80101acb <iunlockput>
  commit_trans();
80105c05:	e8 10 d6 ff ff       	call   8010321a <commit_trans>
  return 0;
80105c0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105c0f:	c9                   	leave  
80105c10:	c3                   	ret    

80105c11 <sys_chdir>:

int
sys_chdir(void)
{
80105c11:	55                   	push   %ebp
80105c12:	89 e5                	mov    %esp,%ebp
80105c14:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80105c17:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c1a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c1e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105c25:	e8 42 f4 ff ff       	call   8010506c <argstr>
80105c2a:	85 c0                	test   %eax,%eax
80105c2c:	78 14                	js     80105c42 <sys_chdir+0x31>
80105c2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c31:	89 04 24             	mov    %eax,(%esp)
80105c34:	e8 b9 c7 ff ff       	call   801023f2 <namei>
80105c39:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c40:	75 07                	jne    80105c49 <sys_chdir+0x38>
    return -1;
80105c42:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c47:	eb 57                	jmp    80105ca0 <sys_chdir+0x8f>
  ilock(ip);
80105c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c4c:	89 04 24             	mov    %eax,(%esp)
80105c4f:	e8 f3 bb ff ff       	call   80101847 <ilock>
  if(ip->type != T_DIR){
80105c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c57:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105c5b:	66 83 f8 01          	cmp    $0x1,%ax
80105c5f:	74 12                	je     80105c73 <sys_chdir+0x62>
    iunlockput(ip);
80105c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c64:	89 04 24             	mov    %eax,(%esp)
80105c67:	e8 5f be ff ff       	call   80101acb <iunlockput>
    return -1;
80105c6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c71:	eb 2d                	jmp    80105ca0 <sys_chdir+0x8f>
  }
  iunlock(ip);
80105c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c76:	89 04 24             	mov    %eax,(%esp)
80105c79:	e8 17 bd ff ff       	call   80101995 <iunlock>
  iput(proc->cwd);
80105c7e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c84:	8b 40 68             	mov    0x68(%eax),%eax
80105c87:	89 04 24             	mov    %eax,(%esp)
80105c8a:	e8 6b bd ff ff       	call   801019fa <iput>
  proc->cwd = ip;
80105c8f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c95:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c98:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80105c9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ca0:	c9                   	leave  
80105ca1:	c3                   	ret    

80105ca2 <sys_exec>:

int
sys_exec(void)
{
80105ca2:	55                   	push   %ebp
80105ca3:	89 e5                	mov    %esp,%ebp
80105ca5:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105cab:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105cae:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cb2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105cb9:	e8 ae f3 ff ff       	call   8010506c <argstr>
80105cbe:	85 c0                	test   %eax,%eax
80105cc0:	78 1a                	js     80105cdc <sys_exec+0x3a>
80105cc2:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80105cc8:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ccc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105cd3:	e8 04 f3 ff ff       	call   80104fdc <argint>
80105cd8:	85 c0                	test   %eax,%eax
80105cda:	79 0a                	jns    80105ce6 <sys_exec+0x44>
    return -1;
80105cdc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ce1:	e9 c8 00 00 00       	jmp    80105dae <sys_exec+0x10c>
  }
  memset(argv, 0, sizeof(argv));
80105ce6:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105ced:	00 
80105cee:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105cf5:	00 
80105cf6:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105cfc:	89 04 24             	mov    %eax,(%esp)
80105cff:	e8 96 ef ff ff       	call   80104c9a <memset>
  for(i=0;; i++){
80105d04:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80105d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d0e:	83 f8 1f             	cmp    $0x1f,%eax
80105d11:	76 0a                	jbe    80105d1d <sys_exec+0x7b>
      return -1;
80105d13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d18:	e9 91 00 00 00       	jmp    80105dae <sys_exec+0x10c>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d20:	c1 e0 02             	shl    $0x2,%eax
80105d23:	89 c2                	mov    %eax,%edx
80105d25:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80105d2b:	01 c2                	add    %eax,%edx
80105d2d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105d33:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d37:	89 14 24             	mov    %edx,(%esp)
80105d3a:	e8 01 f2 ff ff       	call   80104f40 <fetchint>
80105d3f:	85 c0                	test   %eax,%eax
80105d41:	79 07                	jns    80105d4a <sys_exec+0xa8>
      return -1;
80105d43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d48:	eb 64                	jmp    80105dae <sys_exec+0x10c>
    if(uarg == 0){
80105d4a:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105d50:	85 c0                	test   %eax,%eax
80105d52:	75 26                	jne    80105d7a <sys_exec+0xd8>
      argv[i] = 0;
80105d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d57:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80105d5e:	00 00 00 00 
      break;
80105d62:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105d63:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d66:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105d6c:	89 54 24 04          	mov    %edx,0x4(%esp)
80105d70:	89 04 24             	mov    %eax,(%esp)
80105d73:	e8 77 ad ff ff       	call   80100aef <exec>
80105d78:	eb 34                	jmp    80105dae <sys_exec+0x10c>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105d7a:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105d80:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d83:	c1 e2 02             	shl    $0x2,%edx
80105d86:	01 c2                	add    %eax,%edx
80105d88:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105d8e:	89 54 24 04          	mov    %edx,0x4(%esp)
80105d92:	89 04 24             	mov    %eax,(%esp)
80105d95:	e8 e0 f1 ff ff       	call   80104f7a <fetchstr>
80105d9a:	85 c0                	test   %eax,%eax
80105d9c:	79 07                	jns    80105da5 <sys_exec+0x103>
      return -1;
80105d9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105da3:	eb 09                	jmp    80105dae <sys_exec+0x10c>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105da5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80105da9:	e9 5d ff ff ff       	jmp    80105d0b <sys_exec+0x69>
  return exec(path, argv);
}
80105dae:	c9                   	leave  
80105daf:	c3                   	ret    

80105db0 <sys_pipe>:

int
sys_pipe(void)
{
80105db0:	55                   	push   %ebp
80105db1:	89 e5                	mov    %esp,%ebp
80105db3:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105db6:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105dbd:	00 
80105dbe:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105dc1:	89 44 24 04          	mov    %eax,0x4(%esp)
80105dc5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105dcc:	e8 39 f2 ff ff       	call   8010500a <argptr>
80105dd1:	85 c0                	test   %eax,%eax
80105dd3:	79 0a                	jns    80105ddf <sys_pipe+0x2f>
    return -1;
80105dd5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dda:	e9 9b 00 00 00       	jmp    80105e7a <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
80105ddf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105de2:	89 44 24 04          	mov    %eax,0x4(%esp)
80105de6:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105de9:	89 04 24             	mov    %eax,(%esp)
80105dec:	e8 ae dd ff ff       	call   80103b9f <pipealloc>
80105df1:	85 c0                	test   %eax,%eax
80105df3:	79 07                	jns    80105dfc <sys_pipe+0x4c>
    return -1;
80105df5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dfa:	eb 7e                	jmp    80105e7a <sys_pipe+0xca>
  fd0 = -1;
80105dfc:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e03:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105e06:	89 04 24             	mov    %eax,(%esp)
80105e09:	e8 99 f3 ff ff       	call   801051a7 <fdalloc>
80105e0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e15:	78 14                	js     80105e2b <sys_pipe+0x7b>
80105e17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e1a:	89 04 24             	mov    %eax,(%esp)
80105e1d:	e8 85 f3 ff ff       	call   801051a7 <fdalloc>
80105e22:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e29:	79 37                	jns    80105e62 <sys_pipe+0xb2>
    if(fd0 >= 0)
80105e2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e2f:	78 14                	js     80105e45 <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
80105e31:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e37:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e3a:	83 c2 08             	add    $0x8,%edx
80105e3d:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105e44:	00 
    fileclose(rf);
80105e45:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105e48:	89 04 24             	mov    %eax,(%esp)
80105e4b:	e8 6a b1 ff ff       	call   80100fba <fileclose>
    fileclose(wf);
80105e50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e53:	89 04 24             	mov    %eax,(%esp)
80105e56:	e8 5f b1 ff ff       	call   80100fba <fileclose>
    return -1;
80105e5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e60:	eb 18                	jmp    80105e7a <sys_pipe+0xca>
  }
  fd[0] = fd0;
80105e62:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105e65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e68:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80105e6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105e6d:	8d 50 04             	lea    0x4(%eax),%edx
80105e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e73:	89 02                	mov    %eax,(%edx)
  return 0;
80105e75:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e7a:	c9                   	leave  
80105e7b:	c3                   	ret    

80105e7c <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105e7c:	55                   	push   %ebp
80105e7d:	89 e5                	mov    %esp,%ebp
80105e7f:	83 ec 08             	sub    $0x8,%esp
  return fork();
80105e82:	e8 c3 e3 ff ff       	call   8010424a <fork>
}
80105e87:	c9                   	leave  
80105e88:	c3                   	ret    

80105e89 <sys_exit>:

int
sys_exit(void)
{
80105e89:	55                   	push   %ebp
80105e8a:	89 e5                	mov    %esp,%ebp
80105e8c:	83 ec 08             	sub    $0x8,%esp
  exit();
80105e8f:	e8 19 e5 ff ff       	call   801043ad <exit>
  return 0;  // not reached
80105e94:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e99:	c9                   	leave  
80105e9a:	c3                   	ret    

80105e9b <sys_wait>:

int
sys_wait(void)
{
80105e9b:	55                   	push   %ebp
80105e9c:	89 e5                	mov    %esp,%ebp
80105e9e:	83 ec 08             	sub    $0x8,%esp
  return wait();
80105ea1:	e8 1f e6 ff ff       	call   801044c5 <wait>
}
80105ea6:	c9                   	leave  
80105ea7:	c3                   	ret    

80105ea8 <sys_kill>:

int
sys_kill(void)
{
80105ea8:	55                   	push   %ebp
80105ea9:	89 e5                	mov    %esp,%ebp
80105eab:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105eae:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105eb1:	89 44 24 04          	mov    %eax,0x4(%esp)
80105eb5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ebc:	e8 1b f1 ff ff       	call   80104fdc <argint>
80105ec1:	85 c0                	test   %eax,%eax
80105ec3:	79 07                	jns    80105ecc <sys_kill+0x24>
    return -1;
80105ec5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eca:	eb 0b                	jmp    80105ed7 <sys_kill+0x2f>
  return kill(pid);
80105ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ecf:	89 04 24             	mov    %eax,(%esp)
80105ed2:	e8 a9 e9 ff ff       	call   80104880 <kill>
}
80105ed7:	c9                   	leave  
80105ed8:	c3                   	ret    

80105ed9 <sys_getpid>:

int
sys_getpid(void)
{
80105ed9:	55                   	push   %ebp
80105eda:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80105edc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ee2:	8b 40 10             	mov    0x10(%eax),%eax
}
80105ee5:	5d                   	pop    %ebp
80105ee6:	c3                   	ret    

80105ee7 <sys_sbrk>:

int
sys_sbrk(void)
{
80105ee7:	55                   	push   %ebp
80105ee8:	89 e5                	mov    %esp,%ebp
80105eea:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105eed:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ef0:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ef4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105efb:	e8 dc f0 ff ff       	call   80104fdc <argint>
80105f00:	85 c0                	test   %eax,%eax
80105f02:	79 07                	jns    80105f0b <sys_sbrk+0x24>
    return -1;
80105f04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f09:	eb 24                	jmp    80105f2f <sys_sbrk+0x48>
  addr = proc->sz;
80105f0b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f11:	8b 00                	mov    (%eax),%eax
80105f13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80105f16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f19:	89 04 24             	mov    %eax,(%esp)
80105f1c:	e8 84 e2 ff ff       	call   801041a5 <growproc>
80105f21:	85 c0                	test   %eax,%eax
80105f23:	79 07                	jns    80105f2c <sys_sbrk+0x45>
    return -1;
80105f25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f2a:	eb 03                	jmp    80105f2f <sys_sbrk+0x48>
  return addr;
80105f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105f2f:	c9                   	leave  
80105f30:	c3                   	ret    

80105f31 <sys_sleep>:

int
sys_sleep(void)
{
80105f31:	55                   	push   %ebp
80105f32:	89 e5                	mov    %esp,%ebp
80105f34:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80105f37:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f3a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f3e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f45:	e8 92 f0 ff ff       	call   80104fdc <argint>
80105f4a:	85 c0                	test   %eax,%eax
80105f4c:	79 07                	jns    80105f55 <sys_sleep+0x24>
    return -1;
80105f4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f53:	eb 6c                	jmp    80105fc1 <sys_sleep+0x90>
  acquire(&tickslock);
80105f55:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
80105f5c:	e8 e5 ea ff ff       	call   80104a46 <acquire>
  ticks0 = ticks;
80105f61:	a1 a0 26 11 80       	mov    0x801126a0,%eax
80105f66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80105f69:	eb 34                	jmp    80105f9f <sys_sleep+0x6e>
    if(proc->killed){
80105f6b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f71:	8b 40 24             	mov    0x24(%eax),%eax
80105f74:	85 c0                	test   %eax,%eax
80105f76:	74 13                	je     80105f8b <sys_sleep+0x5a>
      release(&tickslock);
80105f78:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
80105f7f:	e8 24 eb ff ff       	call   80104aa8 <release>
      return -1;
80105f84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f89:	eb 36                	jmp    80105fc1 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
80105f8b:	c7 44 24 04 60 1e 11 	movl   $0x80111e60,0x4(%esp)
80105f92:	80 
80105f93:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80105f9a:	e8 dd e7 ff ff       	call   8010477c <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105f9f:	a1 a0 26 11 80       	mov    0x801126a0,%eax
80105fa4:	2b 45 f4             	sub    -0xc(%ebp),%eax
80105fa7:	89 c2                	mov    %eax,%edx
80105fa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fac:	39 c2                	cmp    %eax,%edx
80105fae:	72 bb                	jb     80105f6b <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105fb0:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
80105fb7:	e8 ec ea ff ff       	call   80104aa8 <release>
  return 0;
80105fbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105fc1:	c9                   	leave  
80105fc2:	c3                   	ret    

80105fc3 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105fc3:	55                   	push   %ebp
80105fc4:	89 e5                	mov    %esp,%ebp
80105fc6:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
80105fc9:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
80105fd0:	e8 71 ea ff ff       	call   80104a46 <acquire>
  xticks = ticks;
80105fd5:	a1 a0 26 11 80       	mov    0x801126a0,%eax
80105fda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80105fdd:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
80105fe4:	e8 bf ea ff ff       	call   80104aa8 <release>
  return xticks;
80105fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105fec:	c9                   	leave  
80105fed:	c3                   	ret    

80105fee <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80105fee:	55                   	push   %ebp
80105fef:	89 e5                	mov    %esp,%ebp
80105ff1:	83 ec 08             	sub    $0x8,%esp
80105ff4:	8b 55 08             	mov    0x8(%ebp),%edx
80105ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ffa:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80105ffe:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106001:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106005:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106009:	ee                   	out    %al,(%dx)
}
8010600a:	c9                   	leave  
8010600b:	c3                   	ret    

8010600c <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
8010600c:	55                   	push   %ebp
8010600d:	89 e5                	mov    %esp,%ebp
8010600f:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106012:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
80106019:	00 
8010601a:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
80106021:	e8 c8 ff ff ff       	call   80105fee <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106026:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
8010602d:	00 
8010602e:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106035:	e8 b4 ff ff ff       	call   80105fee <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
8010603a:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
80106041:	00 
80106042:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106049:	e8 a0 ff ff ff       	call   80105fee <outb>
  picenable(IRQ_TIMER);
8010604e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106055:	e8 d8 d9 ff ff       	call   80103a32 <picenable>
}
8010605a:	c9                   	leave  
8010605b:	c3                   	ret    

8010605c <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010605c:	1e                   	push   %ds
  pushl %es
8010605d:	06                   	push   %es
  pushl %fs
8010605e:	0f a0                	push   %fs
  pushl %gs
80106060:	0f a8                	push   %gs
  pushal
80106062:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106063:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106067:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106069:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010606b:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
8010606f:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106071:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106073:	54                   	push   %esp
  call trap
80106074:	e8 d8 01 00 00       	call   80106251 <trap>
  addl $4, %esp
80106079:	83 c4 04             	add    $0x4,%esp

8010607c <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010607c:	61                   	popa   
  popl %gs
8010607d:	0f a9                	pop    %gs
  popl %fs
8010607f:	0f a1                	pop    %fs
  popl %es
80106081:	07                   	pop    %es
  popl %ds
80106082:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106083:	83 c4 08             	add    $0x8,%esp
  iret
80106086:	cf                   	iret   

80106087 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106087:	55                   	push   %ebp
80106088:	89 e5                	mov    %esp,%ebp
8010608a:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010608d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106090:	83 e8 01             	sub    $0x1,%eax
80106093:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106097:	8b 45 08             	mov    0x8(%ebp),%eax
8010609a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010609e:	8b 45 08             	mov    0x8(%ebp),%eax
801060a1:	c1 e8 10             	shr    $0x10,%eax
801060a4:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801060a8:	8d 45 fa             	lea    -0x6(%ebp),%eax
801060ab:	0f 01 18             	lidtl  (%eax)
}
801060ae:	c9                   	leave  
801060af:	c3                   	ret    

801060b0 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
801060b0:	55                   	push   %ebp
801060b1:	89 e5                	mov    %esp,%ebp
801060b3:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801060b6:	0f 20 d0             	mov    %cr2,%eax
801060b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
801060bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801060bf:	c9                   	leave  
801060c0:	c3                   	ret    

801060c1 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801060c1:	55                   	push   %ebp
801060c2:	89 e5                	mov    %esp,%ebp
801060c4:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
801060c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801060ce:	e9 c3 00 00 00       	jmp    80106196 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801060d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060d6:	8b 04 85 98 b0 10 80 	mov    -0x7fef4f68(,%eax,4),%eax
801060dd:	89 c2                	mov    %eax,%edx
801060df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060e2:	66 89 14 c5 a0 1e 11 	mov    %dx,-0x7feee160(,%eax,8)
801060e9:	80 
801060ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060ed:	66 c7 04 c5 a2 1e 11 	movw   $0x8,-0x7feee15e(,%eax,8)
801060f4:	80 08 00 
801060f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060fa:	0f b6 14 c5 a4 1e 11 	movzbl -0x7feee15c(,%eax,8),%edx
80106101:	80 
80106102:	83 e2 e0             	and    $0xffffffe0,%edx
80106105:	88 14 c5 a4 1e 11 80 	mov    %dl,-0x7feee15c(,%eax,8)
8010610c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010610f:	0f b6 14 c5 a4 1e 11 	movzbl -0x7feee15c(,%eax,8),%edx
80106116:	80 
80106117:	83 e2 1f             	and    $0x1f,%edx
8010611a:	88 14 c5 a4 1e 11 80 	mov    %dl,-0x7feee15c(,%eax,8)
80106121:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106124:	0f b6 14 c5 a5 1e 11 	movzbl -0x7feee15b(,%eax,8),%edx
8010612b:	80 
8010612c:	83 e2 f0             	and    $0xfffffff0,%edx
8010612f:	83 ca 0e             	or     $0xe,%edx
80106132:	88 14 c5 a5 1e 11 80 	mov    %dl,-0x7feee15b(,%eax,8)
80106139:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010613c:	0f b6 14 c5 a5 1e 11 	movzbl -0x7feee15b(,%eax,8),%edx
80106143:	80 
80106144:	83 e2 ef             	and    $0xffffffef,%edx
80106147:	88 14 c5 a5 1e 11 80 	mov    %dl,-0x7feee15b(,%eax,8)
8010614e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106151:	0f b6 14 c5 a5 1e 11 	movzbl -0x7feee15b(,%eax,8),%edx
80106158:	80 
80106159:	83 e2 9f             	and    $0xffffff9f,%edx
8010615c:	88 14 c5 a5 1e 11 80 	mov    %dl,-0x7feee15b(,%eax,8)
80106163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106166:	0f b6 14 c5 a5 1e 11 	movzbl -0x7feee15b(,%eax,8),%edx
8010616d:	80 
8010616e:	83 ca 80             	or     $0xffffff80,%edx
80106171:	88 14 c5 a5 1e 11 80 	mov    %dl,-0x7feee15b(,%eax,8)
80106178:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010617b:	8b 04 85 98 b0 10 80 	mov    -0x7fef4f68(,%eax,4),%eax
80106182:	c1 e8 10             	shr    $0x10,%eax
80106185:	89 c2                	mov    %eax,%edx
80106187:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010618a:	66 89 14 c5 a6 1e 11 	mov    %dx,-0x7feee15a(,%eax,8)
80106191:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106192:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106196:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
8010619d:	0f 8e 30 ff ff ff    	jle    801060d3 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061a3:	a1 98 b1 10 80       	mov    0x8010b198,%eax
801061a8:	66 a3 a0 20 11 80    	mov    %ax,0x801120a0
801061ae:	66 c7 05 a2 20 11 80 	movw   $0x8,0x801120a2
801061b5:	08 00 
801061b7:	0f b6 05 a4 20 11 80 	movzbl 0x801120a4,%eax
801061be:	83 e0 e0             	and    $0xffffffe0,%eax
801061c1:	a2 a4 20 11 80       	mov    %al,0x801120a4
801061c6:	0f b6 05 a4 20 11 80 	movzbl 0x801120a4,%eax
801061cd:	83 e0 1f             	and    $0x1f,%eax
801061d0:	a2 a4 20 11 80       	mov    %al,0x801120a4
801061d5:	0f b6 05 a5 20 11 80 	movzbl 0x801120a5,%eax
801061dc:	83 c8 0f             	or     $0xf,%eax
801061df:	a2 a5 20 11 80       	mov    %al,0x801120a5
801061e4:	0f b6 05 a5 20 11 80 	movzbl 0x801120a5,%eax
801061eb:	83 e0 ef             	and    $0xffffffef,%eax
801061ee:	a2 a5 20 11 80       	mov    %al,0x801120a5
801061f3:	0f b6 05 a5 20 11 80 	movzbl 0x801120a5,%eax
801061fa:	83 c8 60             	or     $0x60,%eax
801061fd:	a2 a5 20 11 80       	mov    %al,0x801120a5
80106202:	0f b6 05 a5 20 11 80 	movzbl 0x801120a5,%eax
80106209:	83 c8 80             	or     $0xffffff80,%eax
8010620c:	a2 a5 20 11 80       	mov    %al,0x801120a5
80106211:	a1 98 b1 10 80       	mov    0x8010b198,%eax
80106216:	c1 e8 10             	shr    $0x10,%eax
80106219:	66 a3 a6 20 11 80    	mov    %ax,0x801120a6
  
  initlock(&tickslock, "time");
8010621f:	c7 44 24 04 24 84 10 	movl   $0x80108424,0x4(%esp)
80106226:	80 
80106227:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
8010622e:	e8 f2 e7 ff ff       	call   80104a25 <initlock>
}
80106233:	c9                   	leave  
80106234:	c3                   	ret    

80106235 <idtinit>:

void
idtinit(void)
{
80106235:	55                   	push   %ebp
80106236:	89 e5                	mov    %esp,%ebp
80106238:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
8010623b:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80106242:	00 
80106243:	c7 04 24 a0 1e 11 80 	movl   $0x80111ea0,(%esp)
8010624a:	e8 38 fe ff ff       	call   80106087 <lidt>
}
8010624f:	c9                   	leave  
80106250:	c3                   	ret    

80106251 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106251:	55                   	push   %ebp
80106252:	89 e5                	mov    %esp,%ebp
80106254:	57                   	push   %edi
80106255:	56                   	push   %esi
80106256:	53                   	push   %ebx
80106257:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
8010625a:	8b 45 08             	mov    0x8(%ebp),%eax
8010625d:	8b 40 30             	mov    0x30(%eax),%eax
80106260:	83 f8 40             	cmp    $0x40,%eax
80106263:	75 3f                	jne    801062a4 <trap+0x53>
    if(proc->killed)
80106265:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010626b:	8b 40 24             	mov    0x24(%eax),%eax
8010626e:	85 c0                	test   %eax,%eax
80106270:	74 05                	je     80106277 <trap+0x26>
      exit();
80106272:	e8 36 e1 ff ff       	call   801043ad <exit>
    proc->tf = tf;
80106277:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010627d:	8b 55 08             	mov    0x8(%ebp),%edx
80106280:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106283:	e8 1b ee ff ff       	call   801050a3 <syscall>
    if(proc->killed)
80106288:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010628e:	8b 40 24             	mov    0x24(%eax),%eax
80106291:	85 c0                	test   %eax,%eax
80106293:	74 0a                	je     8010629f <trap+0x4e>
      exit();
80106295:	e8 13 e1 ff ff       	call   801043ad <exit>
    return;
8010629a:	e9 2d 02 00 00       	jmp    801064cc <trap+0x27b>
8010629f:	e9 28 02 00 00       	jmp    801064cc <trap+0x27b>
  }

  switch(tf->trapno){
801062a4:	8b 45 08             	mov    0x8(%ebp),%eax
801062a7:	8b 40 30             	mov    0x30(%eax),%eax
801062aa:	83 e8 20             	sub    $0x20,%eax
801062ad:	83 f8 1f             	cmp    $0x1f,%eax
801062b0:	0f 87 bc 00 00 00    	ja     80106372 <trap+0x121>
801062b6:	8b 04 85 cc 84 10 80 	mov    -0x7fef7b34(,%eax,4),%eax
801062bd:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
801062bf:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801062c5:	0f b6 00             	movzbl (%eax),%eax
801062c8:	84 c0                	test   %al,%al
801062ca:	75 31                	jne    801062fd <trap+0xac>
      acquire(&tickslock);
801062cc:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
801062d3:	e8 6e e7 ff ff       	call   80104a46 <acquire>
      ticks++;
801062d8:	a1 a0 26 11 80       	mov    0x801126a0,%eax
801062dd:	83 c0 01             	add    $0x1,%eax
801062e0:	a3 a0 26 11 80       	mov    %eax,0x801126a0
      wakeup(&ticks);
801062e5:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
801062ec:	e8 64 e5 ff ff       	call   80104855 <wakeup>
      release(&tickslock);
801062f1:	c7 04 24 60 1e 11 80 	movl   $0x80111e60,(%esp)
801062f8:	e8 ab e7 ff ff       	call   80104aa8 <release>
    }
    lapiceoi();
801062fd:	e8 9d cb ff ff       	call   80102e9f <lapiceoi>
    break;
80106302:	e9 41 01 00 00       	jmp    80106448 <trap+0x1f7>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106307:	e8 be c3 ff ff       	call   801026ca <ideintr>
    lapiceoi();
8010630c:	e8 8e cb ff ff       	call   80102e9f <lapiceoi>
    break;
80106311:	e9 32 01 00 00       	jmp    80106448 <trap+0x1f7>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106316:	e8 70 c9 ff ff       	call   80102c8b <kbdintr>
    lapiceoi();
8010631b:	e8 7f cb ff ff       	call   80102e9f <lapiceoi>
    break;
80106320:	e9 23 01 00 00       	jmp    80106448 <trap+0x1f7>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106325:	e8 97 03 00 00       	call   801066c1 <uartintr>
    lapiceoi();
8010632a:	e8 70 cb ff ff       	call   80102e9f <lapiceoi>
    break;
8010632f:	e9 14 01 00 00       	jmp    80106448 <trap+0x1f7>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106334:	8b 45 08             	mov    0x8(%ebp),%eax
80106337:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
8010633a:	8b 45 08             	mov    0x8(%ebp),%eax
8010633d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106341:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106344:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010634a:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010634d:	0f b6 c0             	movzbl %al,%eax
80106350:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106354:	89 54 24 08          	mov    %edx,0x8(%esp)
80106358:	89 44 24 04          	mov    %eax,0x4(%esp)
8010635c:	c7 04 24 2c 84 10 80 	movl   $0x8010842c,(%esp)
80106363:	e8 38 a0 ff ff       	call   801003a0 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106368:	e8 32 cb ff ff       	call   80102e9f <lapiceoi>
    break;
8010636d:	e9 d6 00 00 00       	jmp    80106448 <trap+0x1f7>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106372:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106378:	85 c0                	test   %eax,%eax
8010637a:	74 11                	je     8010638d <trap+0x13c>
8010637c:	8b 45 08             	mov    0x8(%ebp),%eax
8010637f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106383:	0f b7 c0             	movzwl %ax,%eax
80106386:	83 e0 03             	and    $0x3,%eax
80106389:	85 c0                	test   %eax,%eax
8010638b:	75 46                	jne    801063d3 <trap+0x182>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010638d:	e8 1e fd ff ff       	call   801060b0 <rcr2>
80106392:	8b 55 08             	mov    0x8(%ebp),%edx
80106395:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106398:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010639f:	0f b6 12             	movzbl (%edx),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801063a2:	0f b6 ca             	movzbl %dl,%ecx
801063a5:	8b 55 08             	mov    0x8(%ebp),%edx
801063a8:	8b 52 30             	mov    0x30(%edx),%edx
801063ab:	89 44 24 10          	mov    %eax,0x10(%esp)
801063af:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
801063b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801063b7:	89 54 24 04          	mov    %edx,0x4(%esp)
801063bb:	c7 04 24 50 84 10 80 	movl   $0x80108450,(%esp)
801063c2:	e8 d9 9f ff ff       	call   801003a0 <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
801063c7:	c7 04 24 82 84 10 80 	movl   $0x80108482,(%esp)
801063ce:	e8 67 a1 ff ff       	call   8010053a <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063d3:	e8 d8 fc ff ff       	call   801060b0 <rcr2>
801063d8:	89 c2                	mov    %eax,%edx
801063da:	8b 45 08             	mov    0x8(%ebp),%eax
801063dd:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801063e0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801063e6:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063e9:	0f b6 f0             	movzbl %al,%esi
801063ec:	8b 45 08             	mov    0x8(%ebp),%eax
801063ef:	8b 58 34             	mov    0x34(%eax),%ebx
801063f2:	8b 45 08             	mov    0x8(%ebp),%eax
801063f5:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801063f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063fe:	83 c0 6c             	add    $0x6c,%eax
80106401:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106404:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010640a:	8b 40 10             	mov    0x10(%eax),%eax
8010640d:	89 54 24 1c          	mov    %edx,0x1c(%esp)
80106411:	89 7c 24 18          	mov    %edi,0x18(%esp)
80106415:	89 74 24 14          	mov    %esi,0x14(%esp)
80106419:	89 5c 24 10          	mov    %ebx,0x10(%esp)
8010641d:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106421:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80106424:	89 74 24 08          	mov    %esi,0x8(%esp)
80106428:	89 44 24 04          	mov    %eax,0x4(%esp)
8010642c:	c7 04 24 88 84 10 80 	movl   $0x80108488,(%esp)
80106433:	e8 68 9f ff ff       	call   801003a0 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80106438:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010643e:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106445:	eb 01                	jmp    80106448 <trap+0x1f7>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106447:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106448:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010644e:	85 c0                	test   %eax,%eax
80106450:	74 24                	je     80106476 <trap+0x225>
80106452:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106458:	8b 40 24             	mov    0x24(%eax),%eax
8010645b:	85 c0                	test   %eax,%eax
8010645d:	74 17                	je     80106476 <trap+0x225>
8010645f:	8b 45 08             	mov    0x8(%ebp),%eax
80106462:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106466:	0f b7 c0             	movzwl %ax,%eax
80106469:	83 e0 03             	and    $0x3,%eax
8010646c:	83 f8 03             	cmp    $0x3,%eax
8010646f:	75 05                	jne    80106476 <trap+0x225>
    exit();
80106471:	e8 37 df ff ff       	call   801043ad <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106476:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010647c:	85 c0                	test   %eax,%eax
8010647e:	74 1e                	je     8010649e <trap+0x24d>
80106480:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106486:	8b 40 0c             	mov    0xc(%eax),%eax
80106489:	83 f8 04             	cmp    $0x4,%eax
8010648c:	75 10                	jne    8010649e <trap+0x24d>
8010648e:	8b 45 08             	mov    0x8(%ebp),%eax
80106491:	8b 40 30             	mov    0x30(%eax),%eax
80106494:	83 f8 20             	cmp    $0x20,%eax
80106497:	75 05                	jne    8010649e <trap+0x24d>
    yield();
80106499:	e8 80 e2 ff ff       	call   8010471e <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010649e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064a4:	85 c0                	test   %eax,%eax
801064a6:	74 24                	je     801064cc <trap+0x27b>
801064a8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064ae:	8b 40 24             	mov    0x24(%eax),%eax
801064b1:	85 c0                	test   %eax,%eax
801064b3:	74 17                	je     801064cc <trap+0x27b>
801064b5:	8b 45 08             	mov    0x8(%ebp),%eax
801064b8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801064bc:	0f b7 c0             	movzwl %ax,%eax
801064bf:	83 e0 03             	and    $0x3,%eax
801064c2:	83 f8 03             	cmp    $0x3,%eax
801064c5:	75 05                	jne    801064cc <trap+0x27b>
    exit();
801064c7:	e8 e1 de ff ff       	call   801043ad <exit>
}
801064cc:	83 c4 3c             	add    $0x3c,%esp
801064cf:	5b                   	pop    %ebx
801064d0:	5e                   	pop    %esi
801064d1:	5f                   	pop    %edi
801064d2:	5d                   	pop    %ebp
801064d3:	c3                   	ret    

801064d4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801064d4:	55                   	push   %ebp
801064d5:	89 e5                	mov    %esp,%ebp
801064d7:	83 ec 14             	sub    $0x14,%esp
801064da:	8b 45 08             	mov    0x8(%ebp),%eax
801064dd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801064e1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801064e5:	89 c2                	mov    %eax,%edx
801064e7:	ec                   	in     (%dx),%al
801064e8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801064eb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801064ef:	c9                   	leave  
801064f0:	c3                   	ret    

801064f1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801064f1:	55                   	push   %ebp
801064f2:	89 e5                	mov    %esp,%ebp
801064f4:	83 ec 08             	sub    $0x8,%esp
801064f7:	8b 55 08             	mov    0x8(%ebp),%edx
801064fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801064fd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106501:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106504:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106508:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010650c:	ee                   	out    %al,(%dx)
}
8010650d:	c9                   	leave  
8010650e:	c3                   	ret    

8010650f <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
8010650f:	55                   	push   %ebp
80106510:	89 e5                	mov    %esp,%ebp
80106512:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106515:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010651c:	00 
8010651d:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106524:	e8 c8 ff ff ff       	call   801064f1 <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106529:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106530:	00 
80106531:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106538:	e8 b4 ff ff ff       	call   801064f1 <outb>
  outb(COM1+0, 115200/9600);
8010653d:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80106544:	00 
80106545:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
8010654c:	e8 a0 ff ff ff       	call   801064f1 <outb>
  outb(COM1+1, 0);
80106551:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106558:	00 
80106559:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106560:	e8 8c ff ff ff       	call   801064f1 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106565:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
8010656c:	00 
8010656d:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106574:	e8 78 ff ff ff       	call   801064f1 <outb>
  outb(COM1+4, 0);
80106579:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106580:	00 
80106581:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80106588:	e8 64 ff ff ff       	call   801064f1 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
8010658d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106594:	00 
80106595:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
8010659c:	e8 50 ff ff ff       	call   801064f1 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801065a1:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801065a8:	e8 27 ff ff ff       	call   801064d4 <inb>
801065ad:	3c ff                	cmp    $0xff,%al
801065af:	75 02                	jne    801065b3 <uartinit+0xa4>
    return;
801065b1:	eb 6a                	jmp    8010661d <uartinit+0x10e>
  uart = 1;
801065b3:	c7 05 4c b6 10 80 01 	movl   $0x1,0x8010b64c
801065ba:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801065bd:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
801065c4:	e8 0b ff ff ff       	call   801064d4 <inb>
  inb(COM1+0);
801065c9:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801065d0:	e8 ff fe ff ff       	call   801064d4 <inb>
  picenable(IRQ_COM1);
801065d5:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801065dc:	e8 51 d4 ff ff       	call   80103a32 <picenable>
  ioapicenable(IRQ_COM1, 0);
801065e1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801065e8:	00 
801065e9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801065f0:	e8 54 c3 ff ff       	call   80102949 <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801065f5:	c7 45 f4 4c 85 10 80 	movl   $0x8010854c,-0xc(%ebp)
801065fc:	eb 15                	jmp    80106613 <uartinit+0x104>
    uartputc(*p);
801065fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106601:	0f b6 00             	movzbl (%eax),%eax
80106604:	0f be c0             	movsbl %al,%eax
80106607:	89 04 24             	mov    %eax,(%esp)
8010660a:	e8 10 00 00 00       	call   8010661f <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010660f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106613:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106616:	0f b6 00             	movzbl (%eax),%eax
80106619:	84 c0                	test   %al,%al
8010661b:	75 e1                	jne    801065fe <uartinit+0xef>
    uartputc(*p);
}
8010661d:	c9                   	leave  
8010661e:	c3                   	ret    

8010661f <uartputc>:

void
uartputc(int c)
{
8010661f:	55                   	push   %ebp
80106620:	89 e5                	mov    %esp,%ebp
80106622:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80106625:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
8010662a:	85 c0                	test   %eax,%eax
8010662c:	75 02                	jne    80106630 <uartputc+0x11>
    return;
8010662e:	eb 4b                	jmp    8010667b <uartputc+0x5c>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106630:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106637:	eb 10                	jmp    80106649 <uartputc+0x2a>
    microdelay(10);
80106639:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106640:	e8 7f c8 ff ff       	call   80102ec4 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106645:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106649:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
8010664d:	7f 16                	jg     80106665 <uartputc+0x46>
8010664f:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106656:	e8 79 fe ff ff       	call   801064d4 <inb>
8010665b:	0f b6 c0             	movzbl %al,%eax
8010665e:	83 e0 20             	and    $0x20,%eax
80106661:	85 c0                	test   %eax,%eax
80106663:	74 d4                	je     80106639 <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
80106665:	8b 45 08             	mov    0x8(%ebp),%eax
80106668:	0f b6 c0             	movzbl %al,%eax
8010666b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010666f:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106676:	e8 76 fe ff ff       	call   801064f1 <outb>
}
8010667b:	c9                   	leave  
8010667c:	c3                   	ret    

8010667d <uartgetc>:

static int
uartgetc(void)
{
8010667d:	55                   	push   %ebp
8010667e:	89 e5                	mov    %esp,%ebp
80106680:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80106683:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
80106688:	85 c0                	test   %eax,%eax
8010668a:	75 07                	jne    80106693 <uartgetc+0x16>
    return -1;
8010668c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106691:	eb 2c                	jmp    801066bf <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80106693:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
8010669a:	e8 35 fe ff ff       	call   801064d4 <inb>
8010669f:	0f b6 c0             	movzbl %al,%eax
801066a2:	83 e0 01             	and    $0x1,%eax
801066a5:	85 c0                	test   %eax,%eax
801066a7:	75 07                	jne    801066b0 <uartgetc+0x33>
    return -1;
801066a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066ae:	eb 0f                	jmp    801066bf <uartgetc+0x42>
  return inb(COM1+0);
801066b0:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801066b7:	e8 18 fe ff ff       	call   801064d4 <inb>
801066bc:	0f b6 c0             	movzbl %al,%eax
}
801066bf:	c9                   	leave  
801066c0:	c3                   	ret    

801066c1 <uartintr>:

void
uartintr(void)
{
801066c1:	55                   	push   %ebp
801066c2:	89 e5                	mov    %esp,%ebp
801066c4:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
801066c7:	c7 04 24 7d 66 10 80 	movl   $0x8010667d,(%esp)
801066ce:	e8 da a0 ff ff       	call   801007ad <consoleintr>
}
801066d3:	c9                   	leave  
801066d4:	c3                   	ret    

801066d5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801066d5:	6a 00                	push   $0x0
  pushl $0
801066d7:	6a 00                	push   $0x0
  jmp alltraps
801066d9:	e9 7e f9 ff ff       	jmp    8010605c <alltraps>

801066de <vector1>:
.globl vector1
vector1:
  pushl $0
801066de:	6a 00                	push   $0x0
  pushl $1
801066e0:	6a 01                	push   $0x1
  jmp alltraps
801066e2:	e9 75 f9 ff ff       	jmp    8010605c <alltraps>

801066e7 <vector2>:
.globl vector2
vector2:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $2
801066e9:	6a 02                	push   $0x2
  jmp alltraps
801066eb:	e9 6c f9 ff ff       	jmp    8010605c <alltraps>

801066f0 <vector3>:
.globl vector3
vector3:
  pushl $0
801066f0:	6a 00                	push   $0x0
  pushl $3
801066f2:	6a 03                	push   $0x3
  jmp alltraps
801066f4:	e9 63 f9 ff ff       	jmp    8010605c <alltraps>

801066f9 <vector4>:
.globl vector4
vector4:
  pushl $0
801066f9:	6a 00                	push   $0x0
  pushl $4
801066fb:	6a 04                	push   $0x4
  jmp alltraps
801066fd:	e9 5a f9 ff ff       	jmp    8010605c <alltraps>

80106702 <vector5>:
.globl vector5
vector5:
  pushl $0
80106702:	6a 00                	push   $0x0
  pushl $5
80106704:	6a 05                	push   $0x5
  jmp alltraps
80106706:	e9 51 f9 ff ff       	jmp    8010605c <alltraps>

8010670b <vector6>:
.globl vector6
vector6:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $6
8010670d:	6a 06                	push   $0x6
  jmp alltraps
8010670f:	e9 48 f9 ff ff       	jmp    8010605c <alltraps>

80106714 <vector7>:
.globl vector7
vector7:
  pushl $0
80106714:	6a 00                	push   $0x0
  pushl $7
80106716:	6a 07                	push   $0x7
  jmp alltraps
80106718:	e9 3f f9 ff ff       	jmp    8010605c <alltraps>

8010671d <vector8>:
.globl vector8
vector8:
  pushl $8
8010671d:	6a 08                	push   $0x8
  jmp alltraps
8010671f:	e9 38 f9 ff ff       	jmp    8010605c <alltraps>

80106724 <vector9>:
.globl vector9
vector9:
  pushl $0
80106724:	6a 00                	push   $0x0
  pushl $9
80106726:	6a 09                	push   $0x9
  jmp alltraps
80106728:	e9 2f f9 ff ff       	jmp    8010605c <alltraps>

8010672d <vector10>:
.globl vector10
vector10:
  pushl $10
8010672d:	6a 0a                	push   $0xa
  jmp alltraps
8010672f:	e9 28 f9 ff ff       	jmp    8010605c <alltraps>

80106734 <vector11>:
.globl vector11
vector11:
  pushl $11
80106734:	6a 0b                	push   $0xb
  jmp alltraps
80106736:	e9 21 f9 ff ff       	jmp    8010605c <alltraps>

8010673b <vector12>:
.globl vector12
vector12:
  pushl $12
8010673b:	6a 0c                	push   $0xc
  jmp alltraps
8010673d:	e9 1a f9 ff ff       	jmp    8010605c <alltraps>

80106742 <vector13>:
.globl vector13
vector13:
  pushl $13
80106742:	6a 0d                	push   $0xd
  jmp alltraps
80106744:	e9 13 f9 ff ff       	jmp    8010605c <alltraps>

80106749 <vector14>:
.globl vector14
vector14:
  pushl $14
80106749:	6a 0e                	push   $0xe
  jmp alltraps
8010674b:	e9 0c f9 ff ff       	jmp    8010605c <alltraps>

80106750 <vector15>:
.globl vector15
vector15:
  pushl $0
80106750:	6a 00                	push   $0x0
  pushl $15
80106752:	6a 0f                	push   $0xf
  jmp alltraps
80106754:	e9 03 f9 ff ff       	jmp    8010605c <alltraps>

80106759 <vector16>:
.globl vector16
vector16:
  pushl $0
80106759:	6a 00                	push   $0x0
  pushl $16
8010675b:	6a 10                	push   $0x10
  jmp alltraps
8010675d:	e9 fa f8 ff ff       	jmp    8010605c <alltraps>

80106762 <vector17>:
.globl vector17
vector17:
  pushl $17
80106762:	6a 11                	push   $0x11
  jmp alltraps
80106764:	e9 f3 f8 ff ff       	jmp    8010605c <alltraps>

80106769 <vector18>:
.globl vector18
vector18:
  pushl $0
80106769:	6a 00                	push   $0x0
  pushl $18
8010676b:	6a 12                	push   $0x12
  jmp alltraps
8010676d:	e9 ea f8 ff ff       	jmp    8010605c <alltraps>

80106772 <vector19>:
.globl vector19
vector19:
  pushl $0
80106772:	6a 00                	push   $0x0
  pushl $19
80106774:	6a 13                	push   $0x13
  jmp alltraps
80106776:	e9 e1 f8 ff ff       	jmp    8010605c <alltraps>

8010677b <vector20>:
.globl vector20
vector20:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $20
8010677d:	6a 14                	push   $0x14
  jmp alltraps
8010677f:	e9 d8 f8 ff ff       	jmp    8010605c <alltraps>

80106784 <vector21>:
.globl vector21
vector21:
  pushl $0
80106784:	6a 00                	push   $0x0
  pushl $21
80106786:	6a 15                	push   $0x15
  jmp alltraps
80106788:	e9 cf f8 ff ff       	jmp    8010605c <alltraps>

8010678d <vector22>:
.globl vector22
vector22:
  pushl $0
8010678d:	6a 00                	push   $0x0
  pushl $22
8010678f:	6a 16                	push   $0x16
  jmp alltraps
80106791:	e9 c6 f8 ff ff       	jmp    8010605c <alltraps>

80106796 <vector23>:
.globl vector23
vector23:
  pushl $0
80106796:	6a 00                	push   $0x0
  pushl $23
80106798:	6a 17                	push   $0x17
  jmp alltraps
8010679a:	e9 bd f8 ff ff       	jmp    8010605c <alltraps>

8010679f <vector24>:
.globl vector24
vector24:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $24
801067a1:	6a 18                	push   $0x18
  jmp alltraps
801067a3:	e9 b4 f8 ff ff       	jmp    8010605c <alltraps>

801067a8 <vector25>:
.globl vector25
vector25:
  pushl $0
801067a8:	6a 00                	push   $0x0
  pushl $25
801067aa:	6a 19                	push   $0x19
  jmp alltraps
801067ac:	e9 ab f8 ff ff       	jmp    8010605c <alltraps>

801067b1 <vector26>:
.globl vector26
vector26:
  pushl $0
801067b1:	6a 00                	push   $0x0
  pushl $26
801067b3:	6a 1a                	push   $0x1a
  jmp alltraps
801067b5:	e9 a2 f8 ff ff       	jmp    8010605c <alltraps>

801067ba <vector27>:
.globl vector27
vector27:
  pushl $0
801067ba:	6a 00                	push   $0x0
  pushl $27
801067bc:	6a 1b                	push   $0x1b
  jmp alltraps
801067be:	e9 99 f8 ff ff       	jmp    8010605c <alltraps>

801067c3 <vector28>:
.globl vector28
vector28:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $28
801067c5:	6a 1c                	push   $0x1c
  jmp alltraps
801067c7:	e9 90 f8 ff ff       	jmp    8010605c <alltraps>

801067cc <vector29>:
.globl vector29
vector29:
  pushl $0
801067cc:	6a 00                	push   $0x0
  pushl $29
801067ce:	6a 1d                	push   $0x1d
  jmp alltraps
801067d0:	e9 87 f8 ff ff       	jmp    8010605c <alltraps>

801067d5 <vector30>:
.globl vector30
vector30:
  pushl $0
801067d5:	6a 00                	push   $0x0
  pushl $30
801067d7:	6a 1e                	push   $0x1e
  jmp alltraps
801067d9:	e9 7e f8 ff ff       	jmp    8010605c <alltraps>

801067de <vector31>:
.globl vector31
vector31:
  pushl $0
801067de:	6a 00                	push   $0x0
  pushl $31
801067e0:	6a 1f                	push   $0x1f
  jmp alltraps
801067e2:	e9 75 f8 ff ff       	jmp    8010605c <alltraps>

801067e7 <vector32>:
.globl vector32
vector32:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $32
801067e9:	6a 20                	push   $0x20
  jmp alltraps
801067eb:	e9 6c f8 ff ff       	jmp    8010605c <alltraps>

801067f0 <vector33>:
.globl vector33
vector33:
  pushl $0
801067f0:	6a 00                	push   $0x0
  pushl $33
801067f2:	6a 21                	push   $0x21
  jmp alltraps
801067f4:	e9 63 f8 ff ff       	jmp    8010605c <alltraps>

801067f9 <vector34>:
.globl vector34
vector34:
  pushl $0
801067f9:	6a 00                	push   $0x0
  pushl $34
801067fb:	6a 22                	push   $0x22
  jmp alltraps
801067fd:	e9 5a f8 ff ff       	jmp    8010605c <alltraps>

80106802 <vector35>:
.globl vector35
vector35:
  pushl $0
80106802:	6a 00                	push   $0x0
  pushl $35
80106804:	6a 23                	push   $0x23
  jmp alltraps
80106806:	e9 51 f8 ff ff       	jmp    8010605c <alltraps>

8010680b <vector36>:
.globl vector36
vector36:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $36
8010680d:	6a 24                	push   $0x24
  jmp alltraps
8010680f:	e9 48 f8 ff ff       	jmp    8010605c <alltraps>

80106814 <vector37>:
.globl vector37
vector37:
  pushl $0
80106814:	6a 00                	push   $0x0
  pushl $37
80106816:	6a 25                	push   $0x25
  jmp alltraps
80106818:	e9 3f f8 ff ff       	jmp    8010605c <alltraps>

8010681d <vector38>:
.globl vector38
vector38:
  pushl $0
8010681d:	6a 00                	push   $0x0
  pushl $38
8010681f:	6a 26                	push   $0x26
  jmp alltraps
80106821:	e9 36 f8 ff ff       	jmp    8010605c <alltraps>

80106826 <vector39>:
.globl vector39
vector39:
  pushl $0
80106826:	6a 00                	push   $0x0
  pushl $39
80106828:	6a 27                	push   $0x27
  jmp alltraps
8010682a:	e9 2d f8 ff ff       	jmp    8010605c <alltraps>

8010682f <vector40>:
.globl vector40
vector40:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $40
80106831:	6a 28                	push   $0x28
  jmp alltraps
80106833:	e9 24 f8 ff ff       	jmp    8010605c <alltraps>

80106838 <vector41>:
.globl vector41
vector41:
  pushl $0
80106838:	6a 00                	push   $0x0
  pushl $41
8010683a:	6a 29                	push   $0x29
  jmp alltraps
8010683c:	e9 1b f8 ff ff       	jmp    8010605c <alltraps>

80106841 <vector42>:
.globl vector42
vector42:
  pushl $0
80106841:	6a 00                	push   $0x0
  pushl $42
80106843:	6a 2a                	push   $0x2a
  jmp alltraps
80106845:	e9 12 f8 ff ff       	jmp    8010605c <alltraps>

8010684a <vector43>:
.globl vector43
vector43:
  pushl $0
8010684a:	6a 00                	push   $0x0
  pushl $43
8010684c:	6a 2b                	push   $0x2b
  jmp alltraps
8010684e:	e9 09 f8 ff ff       	jmp    8010605c <alltraps>

80106853 <vector44>:
.globl vector44
vector44:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $44
80106855:	6a 2c                	push   $0x2c
  jmp alltraps
80106857:	e9 00 f8 ff ff       	jmp    8010605c <alltraps>

8010685c <vector45>:
.globl vector45
vector45:
  pushl $0
8010685c:	6a 00                	push   $0x0
  pushl $45
8010685e:	6a 2d                	push   $0x2d
  jmp alltraps
80106860:	e9 f7 f7 ff ff       	jmp    8010605c <alltraps>

80106865 <vector46>:
.globl vector46
vector46:
  pushl $0
80106865:	6a 00                	push   $0x0
  pushl $46
80106867:	6a 2e                	push   $0x2e
  jmp alltraps
80106869:	e9 ee f7 ff ff       	jmp    8010605c <alltraps>

8010686e <vector47>:
.globl vector47
vector47:
  pushl $0
8010686e:	6a 00                	push   $0x0
  pushl $47
80106870:	6a 2f                	push   $0x2f
  jmp alltraps
80106872:	e9 e5 f7 ff ff       	jmp    8010605c <alltraps>

80106877 <vector48>:
.globl vector48
vector48:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $48
80106879:	6a 30                	push   $0x30
  jmp alltraps
8010687b:	e9 dc f7 ff ff       	jmp    8010605c <alltraps>

80106880 <vector49>:
.globl vector49
vector49:
  pushl $0
80106880:	6a 00                	push   $0x0
  pushl $49
80106882:	6a 31                	push   $0x31
  jmp alltraps
80106884:	e9 d3 f7 ff ff       	jmp    8010605c <alltraps>

80106889 <vector50>:
.globl vector50
vector50:
  pushl $0
80106889:	6a 00                	push   $0x0
  pushl $50
8010688b:	6a 32                	push   $0x32
  jmp alltraps
8010688d:	e9 ca f7 ff ff       	jmp    8010605c <alltraps>

80106892 <vector51>:
.globl vector51
vector51:
  pushl $0
80106892:	6a 00                	push   $0x0
  pushl $51
80106894:	6a 33                	push   $0x33
  jmp alltraps
80106896:	e9 c1 f7 ff ff       	jmp    8010605c <alltraps>

8010689b <vector52>:
.globl vector52
vector52:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $52
8010689d:	6a 34                	push   $0x34
  jmp alltraps
8010689f:	e9 b8 f7 ff ff       	jmp    8010605c <alltraps>

801068a4 <vector53>:
.globl vector53
vector53:
  pushl $0
801068a4:	6a 00                	push   $0x0
  pushl $53
801068a6:	6a 35                	push   $0x35
  jmp alltraps
801068a8:	e9 af f7 ff ff       	jmp    8010605c <alltraps>

801068ad <vector54>:
.globl vector54
vector54:
  pushl $0
801068ad:	6a 00                	push   $0x0
  pushl $54
801068af:	6a 36                	push   $0x36
  jmp alltraps
801068b1:	e9 a6 f7 ff ff       	jmp    8010605c <alltraps>

801068b6 <vector55>:
.globl vector55
vector55:
  pushl $0
801068b6:	6a 00                	push   $0x0
  pushl $55
801068b8:	6a 37                	push   $0x37
  jmp alltraps
801068ba:	e9 9d f7 ff ff       	jmp    8010605c <alltraps>

801068bf <vector56>:
.globl vector56
vector56:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $56
801068c1:	6a 38                	push   $0x38
  jmp alltraps
801068c3:	e9 94 f7 ff ff       	jmp    8010605c <alltraps>

801068c8 <vector57>:
.globl vector57
vector57:
  pushl $0
801068c8:	6a 00                	push   $0x0
  pushl $57
801068ca:	6a 39                	push   $0x39
  jmp alltraps
801068cc:	e9 8b f7 ff ff       	jmp    8010605c <alltraps>

801068d1 <vector58>:
.globl vector58
vector58:
  pushl $0
801068d1:	6a 00                	push   $0x0
  pushl $58
801068d3:	6a 3a                	push   $0x3a
  jmp alltraps
801068d5:	e9 82 f7 ff ff       	jmp    8010605c <alltraps>

801068da <vector59>:
.globl vector59
vector59:
  pushl $0
801068da:	6a 00                	push   $0x0
  pushl $59
801068dc:	6a 3b                	push   $0x3b
  jmp alltraps
801068de:	e9 79 f7 ff ff       	jmp    8010605c <alltraps>

801068e3 <vector60>:
.globl vector60
vector60:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $60
801068e5:	6a 3c                	push   $0x3c
  jmp alltraps
801068e7:	e9 70 f7 ff ff       	jmp    8010605c <alltraps>

801068ec <vector61>:
.globl vector61
vector61:
  pushl $0
801068ec:	6a 00                	push   $0x0
  pushl $61
801068ee:	6a 3d                	push   $0x3d
  jmp alltraps
801068f0:	e9 67 f7 ff ff       	jmp    8010605c <alltraps>

801068f5 <vector62>:
.globl vector62
vector62:
  pushl $0
801068f5:	6a 00                	push   $0x0
  pushl $62
801068f7:	6a 3e                	push   $0x3e
  jmp alltraps
801068f9:	e9 5e f7 ff ff       	jmp    8010605c <alltraps>

801068fe <vector63>:
.globl vector63
vector63:
  pushl $0
801068fe:	6a 00                	push   $0x0
  pushl $63
80106900:	6a 3f                	push   $0x3f
  jmp alltraps
80106902:	e9 55 f7 ff ff       	jmp    8010605c <alltraps>

80106907 <vector64>:
.globl vector64
vector64:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $64
80106909:	6a 40                	push   $0x40
  jmp alltraps
8010690b:	e9 4c f7 ff ff       	jmp    8010605c <alltraps>

80106910 <vector65>:
.globl vector65
vector65:
  pushl $0
80106910:	6a 00                	push   $0x0
  pushl $65
80106912:	6a 41                	push   $0x41
  jmp alltraps
80106914:	e9 43 f7 ff ff       	jmp    8010605c <alltraps>

80106919 <vector66>:
.globl vector66
vector66:
  pushl $0
80106919:	6a 00                	push   $0x0
  pushl $66
8010691b:	6a 42                	push   $0x42
  jmp alltraps
8010691d:	e9 3a f7 ff ff       	jmp    8010605c <alltraps>

80106922 <vector67>:
.globl vector67
vector67:
  pushl $0
80106922:	6a 00                	push   $0x0
  pushl $67
80106924:	6a 43                	push   $0x43
  jmp alltraps
80106926:	e9 31 f7 ff ff       	jmp    8010605c <alltraps>

8010692b <vector68>:
.globl vector68
vector68:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $68
8010692d:	6a 44                	push   $0x44
  jmp alltraps
8010692f:	e9 28 f7 ff ff       	jmp    8010605c <alltraps>

80106934 <vector69>:
.globl vector69
vector69:
  pushl $0
80106934:	6a 00                	push   $0x0
  pushl $69
80106936:	6a 45                	push   $0x45
  jmp alltraps
80106938:	e9 1f f7 ff ff       	jmp    8010605c <alltraps>

8010693d <vector70>:
.globl vector70
vector70:
  pushl $0
8010693d:	6a 00                	push   $0x0
  pushl $70
8010693f:	6a 46                	push   $0x46
  jmp alltraps
80106941:	e9 16 f7 ff ff       	jmp    8010605c <alltraps>

80106946 <vector71>:
.globl vector71
vector71:
  pushl $0
80106946:	6a 00                	push   $0x0
  pushl $71
80106948:	6a 47                	push   $0x47
  jmp alltraps
8010694a:	e9 0d f7 ff ff       	jmp    8010605c <alltraps>

8010694f <vector72>:
.globl vector72
vector72:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $72
80106951:	6a 48                	push   $0x48
  jmp alltraps
80106953:	e9 04 f7 ff ff       	jmp    8010605c <alltraps>

80106958 <vector73>:
.globl vector73
vector73:
  pushl $0
80106958:	6a 00                	push   $0x0
  pushl $73
8010695a:	6a 49                	push   $0x49
  jmp alltraps
8010695c:	e9 fb f6 ff ff       	jmp    8010605c <alltraps>

80106961 <vector74>:
.globl vector74
vector74:
  pushl $0
80106961:	6a 00                	push   $0x0
  pushl $74
80106963:	6a 4a                	push   $0x4a
  jmp alltraps
80106965:	e9 f2 f6 ff ff       	jmp    8010605c <alltraps>

8010696a <vector75>:
.globl vector75
vector75:
  pushl $0
8010696a:	6a 00                	push   $0x0
  pushl $75
8010696c:	6a 4b                	push   $0x4b
  jmp alltraps
8010696e:	e9 e9 f6 ff ff       	jmp    8010605c <alltraps>

80106973 <vector76>:
.globl vector76
vector76:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $76
80106975:	6a 4c                	push   $0x4c
  jmp alltraps
80106977:	e9 e0 f6 ff ff       	jmp    8010605c <alltraps>

8010697c <vector77>:
.globl vector77
vector77:
  pushl $0
8010697c:	6a 00                	push   $0x0
  pushl $77
8010697e:	6a 4d                	push   $0x4d
  jmp alltraps
80106980:	e9 d7 f6 ff ff       	jmp    8010605c <alltraps>

80106985 <vector78>:
.globl vector78
vector78:
  pushl $0
80106985:	6a 00                	push   $0x0
  pushl $78
80106987:	6a 4e                	push   $0x4e
  jmp alltraps
80106989:	e9 ce f6 ff ff       	jmp    8010605c <alltraps>

8010698e <vector79>:
.globl vector79
vector79:
  pushl $0
8010698e:	6a 00                	push   $0x0
  pushl $79
80106990:	6a 4f                	push   $0x4f
  jmp alltraps
80106992:	e9 c5 f6 ff ff       	jmp    8010605c <alltraps>

80106997 <vector80>:
.globl vector80
vector80:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $80
80106999:	6a 50                	push   $0x50
  jmp alltraps
8010699b:	e9 bc f6 ff ff       	jmp    8010605c <alltraps>

801069a0 <vector81>:
.globl vector81
vector81:
  pushl $0
801069a0:	6a 00                	push   $0x0
  pushl $81
801069a2:	6a 51                	push   $0x51
  jmp alltraps
801069a4:	e9 b3 f6 ff ff       	jmp    8010605c <alltraps>

801069a9 <vector82>:
.globl vector82
vector82:
  pushl $0
801069a9:	6a 00                	push   $0x0
  pushl $82
801069ab:	6a 52                	push   $0x52
  jmp alltraps
801069ad:	e9 aa f6 ff ff       	jmp    8010605c <alltraps>

801069b2 <vector83>:
.globl vector83
vector83:
  pushl $0
801069b2:	6a 00                	push   $0x0
  pushl $83
801069b4:	6a 53                	push   $0x53
  jmp alltraps
801069b6:	e9 a1 f6 ff ff       	jmp    8010605c <alltraps>

801069bb <vector84>:
.globl vector84
vector84:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $84
801069bd:	6a 54                	push   $0x54
  jmp alltraps
801069bf:	e9 98 f6 ff ff       	jmp    8010605c <alltraps>

801069c4 <vector85>:
.globl vector85
vector85:
  pushl $0
801069c4:	6a 00                	push   $0x0
  pushl $85
801069c6:	6a 55                	push   $0x55
  jmp alltraps
801069c8:	e9 8f f6 ff ff       	jmp    8010605c <alltraps>

801069cd <vector86>:
.globl vector86
vector86:
  pushl $0
801069cd:	6a 00                	push   $0x0
  pushl $86
801069cf:	6a 56                	push   $0x56
  jmp alltraps
801069d1:	e9 86 f6 ff ff       	jmp    8010605c <alltraps>

801069d6 <vector87>:
.globl vector87
vector87:
  pushl $0
801069d6:	6a 00                	push   $0x0
  pushl $87
801069d8:	6a 57                	push   $0x57
  jmp alltraps
801069da:	e9 7d f6 ff ff       	jmp    8010605c <alltraps>

801069df <vector88>:
.globl vector88
vector88:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $88
801069e1:	6a 58                	push   $0x58
  jmp alltraps
801069e3:	e9 74 f6 ff ff       	jmp    8010605c <alltraps>

801069e8 <vector89>:
.globl vector89
vector89:
  pushl $0
801069e8:	6a 00                	push   $0x0
  pushl $89
801069ea:	6a 59                	push   $0x59
  jmp alltraps
801069ec:	e9 6b f6 ff ff       	jmp    8010605c <alltraps>

801069f1 <vector90>:
.globl vector90
vector90:
  pushl $0
801069f1:	6a 00                	push   $0x0
  pushl $90
801069f3:	6a 5a                	push   $0x5a
  jmp alltraps
801069f5:	e9 62 f6 ff ff       	jmp    8010605c <alltraps>

801069fa <vector91>:
.globl vector91
vector91:
  pushl $0
801069fa:	6a 00                	push   $0x0
  pushl $91
801069fc:	6a 5b                	push   $0x5b
  jmp alltraps
801069fe:	e9 59 f6 ff ff       	jmp    8010605c <alltraps>

80106a03 <vector92>:
.globl vector92
vector92:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $92
80106a05:	6a 5c                	push   $0x5c
  jmp alltraps
80106a07:	e9 50 f6 ff ff       	jmp    8010605c <alltraps>

80106a0c <vector93>:
.globl vector93
vector93:
  pushl $0
80106a0c:	6a 00                	push   $0x0
  pushl $93
80106a0e:	6a 5d                	push   $0x5d
  jmp alltraps
80106a10:	e9 47 f6 ff ff       	jmp    8010605c <alltraps>

80106a15 <vector94>:
.globl vector94
vector94:
  pushl $0
80106a15:	6a 00                	push   $0x0
  pushl $94
80106a17:	6a 5e                	push   $0x5e
  jmp alltraps
80106a19:	e9 3e f6 ff ff       	jmp    8010605c <alltraps>

80106a1e <vector95>:
.globl vector95
vector95:
  pushl $0
80106a1e:	6a 00                	push   $0x0
  pushl $95
80106a20:	6a 5f                	push   $0x5f
  jmp alltraps
80106a22:	e9 35 f6 ff ff       	jmp    8010605c <alltraps>

80106a27 <vector96>:
.globl vector96
vector96:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $96
80106a29:	6a 60                	push   $0x60
  jmp alltraps
80106a2b:	e9 2c f6 ff ff       	jmp    8010605c <alltraps>

80106a30 <vector97>:
.globl vector97
vector97:
  pushl $0
80106a30:	6a 00                	push   $0x0
  pushl $97
80106a32:	6a 61                	push   $0x61
  jmp alltraps
80106a34:	e9 23 f6 ff ff       	jmp    8010605c <alltraps>

80106a39 <vector98>:
.globl vector98
vector98:
  pushl $0
80106a39:	6a 00                	push   $0x0
  pushl $98
80106a3b:	6a 62                	push   $0x62
  jmp alltraps
80106a3d:	e9 1a f6 ff ff       	jmp    8010605c <alltraps>

80106a42 <vector99>:
.globl vector99
vector99:
  pushl $0
80106a42:	6a 00                	push   $0x0
  pushl $99
80106a44:	6a 63                	push   $0x63
  jmp alltraps
80106a46:	e9 11 f6 ff ff       	jmp    8010605c <alltraps>

80106a4b <vector100>:
.globl vector100
vector100:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $100
80106a4d:	6a 64                	push   $0x64
  jmp alltraps
80106a4f:	e9 08 f6 ff ff       	jmp    8010605c <alltraps>

80106a54 <vector101>:
.globl vector101
vector101:
  pushl $0
80106a54:	6a 00                	push   $0x0
  pushl $101
80106a56:	6a 65                	push   $0x65
  jmp alltraps
80106a58:	e9 ff f5 ff ff       	jmp    8010605c <alltraps>

80106a5d <vector102>:
.globl vector102
vector102:
  pushl $0
80106a5d:	6a 00                	push   $0x0
  pushl $102
80106a5f:	6a 66                	push   $0x66
  jmp alltraps
80106a61:	e9 f6 f5 ff ff       	jmp    8010605c <alltraps>

80106a66 <vector103>:
.globl vector103
vector103:
  pushl $0
80106a66:	6a 00                	push   $0x0
  pushl $103
80106a68:	6a 67                	push   $0x67
  jmp alltraps
80106a6a:	e9 ed f5 ff ff       	jmp    8010605c <alltraps>

80106a6f <vector104>:
.globl vector104
vector104:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $104
80106a71:	6a 68                	push   $0x68
  jmp alltraps
80106a73:	e9 e4 f5 ff ff       	jmp    8010605c <alltraps>

80106a78 <vector105>:
.globl vector105
vector105:
  pushl $0
80106a78:	6a 00                	push   $0x0
  pushl $105
80106a7a:	6a 69                	push   $0x69
  jmp alltraps
80106a7c:	e9 db f5 ff ff       	jmp    8010605c <alltraps>

80106a81 <vector106>:
.globl vector106
vector106:
  pushl $0
80106a81:	6a 00                	push   $0x0
  pushl $106
80106a83:	6a 6a                	push   $0x6a
  jmp alltraps
80106a85:	e9 d2 f5 ff ff       	jmp    8010605c <alltraps>

80106a8a <vector107>:
.globl vector107
vector107:
  pushl $0
80106a8a:	6a 00                	push   $0x0
  pushl $107
80106a8c:	6a 6b                	push   $0x6b
  jmp alltraps
80106a8e:	e9 c9 f5 ff ff       	jmp    8010605c <alltraps>

80106a93 <vector108>:
.globl vector108
vector108:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $108
80106a95:	6a 6c                	push   $0x6c
  jmp alltraps
80106a97:	e9 c0 f5 ff ff       	jmp    8010605c <alltraps>

80106a9c <vector109>:
.globl vector109
vector109:
  pushl $0
80106a9c:	6a 00                	push   $0x0
  pushl $109
80106a9e:	6a 6d                	push   $0x6d
  jmp alltraps
80106aa0:	e9 b7 f5 ff ff       	jmp    8010605c <alltraps>

80106aa5 <vector110>:
.globl vector110
vector110:
  pushl $0
80106aa5:	6a 00                	push   $0x0
  pushl $110
80106aa7:	6a 6e                	push   $0x6e
  jmp alltraps
80106aa9:	e9 ae f5 ff ff       	jmp    8010605c <alltraps>

80106aae <vector111>:
.globl vector111
vector111:
  pushl $0
80106aae:	6a 00                	push   $0x0
  pushl $111
80106ab0:	6a 6f                	push   $0x6f
  jmp alltraps
80106ab2:	e9 a5 f5 ff ff       	jmp    8010605c <alltraps>

80106ab7 <vector112>:
.globl vector112
vector112:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $112
80106ab9:	6a 70                	push   $0x70
  jmp alltraps
80106abb:	e9 9c f5 ff ff       	jmp    8010605c <alltraps>

80106ac0 <vector113>:
.globl vector113
vector113:
  pushl $0
80106ac0:	6a 00                	push   $0x0
  pushl $113
80106ac2:	6a 71                	push   $0x71
  jmp alltraps
80106ac4:	e9 93 f5 ff ff       	jmp    8010605c <alltraps>

80106ac9 <vector114>:
.globl vector114
vector114:
  pushl $0
80106ac9:	6a 00                	push   $0x0
  pushl $114
80106acb:	6a 72                	push   $0x72
  jmp alltraps
80106acd:	e9 8a f5 ff ff       	jmp    8010605c <alltraps>

80106ad2 <vector115>:
.globl vector115
vector115:
  pushl $0
80106ad2:	6a 00                	push   $0x0
  pushl $115
80106ad4:	6a 73                	push   $0x73
  jmp alltraps
80106ad6:	e9 81 f5 ff ff       	jmp    8010605c <alltraps>

80106adb <vector116>:
.globl vector116
vector116:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $116
80106add:	6a 74                	push   $0x74
  jmp alltraps
80106adf:	e9 78 f5 ff ff       	jmp    8010605c <alltraps>

80106ae4 <vector117>:
.globl vector117
vector117:
  pushl $0
80106ae4:	6a 00                	push   $0x0
  pushl $117
80106ae6:	6a 75                	push   $0x75
  jmp alltraps
80106ae8:	e9 6f f5 ff ff       	jmp    8010605c <alltraps>

80106aed <vector118>:
.globl vector118
vector118:
  pushl $0
80106aed:	6a 00                	push   $0x0
  pushl $118
80106aef:	6a 76                	push   $0x76
  jmp alltraps
80106af1:	e9 66 f5 ff ff       	jmp    8010605c <alltraps>

80106af6 <vector119>:
.globl vector119
vector119:
  pushl $0
80106af6:	6a 00                	push   $0x0
  pushl $119
80106af8:	6a 77                	push   $0x77
  jmp alltraps
80106afa:	e9 5d f5 ff ff       	jmp    8010605c <alltraps>

80106aff <vector120>:
.globl vector120
vector120:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $120
80106b01:	6a 78                	push   $0x78
  jmp alltraps
80106b03:	e9 54 f5 ff ff       	jmp    8010605c <alltraps>

80106b08 <vector121>:
.globl vector121
vector121:
  pushl $0
80106b08:	6a 00                	push   $0x0
  pushl $121
80106b0a:	6a 79                	push   $0x79
  jmp alltraps
80106b0c:	e9 4b f5 ff ff       	jmp    8010605c <alltraps>

80106b11 <vector122>:
.globl vector122
vector122:
  pushl $0
80106b11:	6a 00                	push   $0x0
  pushl $122
80106b13:	6a 7a                	push   $0x7a
  jmp alltraps
80106b15:	e9 42 f5 ff ff       	jmp    8010605c <alltraps>

80106b1a <vector123>:
.globl vector123
vector123:
  pushl $0
80106b1a:	6a 00                	push   $0x0
  pushl $123
80106b1c:	6a 7b                	push   $0x7b
  jmp alltraps
80106b1e:	e9 39 f5 ff ff       	jmp    8010605c <alltraps>

80106b23 <vector124>:
.globl vector124
vector124:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $124
80106b25:	6a 7c                	push   $0x7c
  jmp alltraps
80106b27:	e9 30 f5 ff ff       	jmp    8010605c <alltraps>

80106b2c <vector125>:
.globl vector125
vector125:
  pushl $0
80106b2c:	6a 00                	push   $0x0
  pushl $125
80106b2e:	6a 7d                	push   $0x7d
  jmp alltraps
80106b30:	e9 27 f5 ff ff       	jmp    8010605c <alltraps>

80106b35 <vector126>:
.globl vector126
vector126:
  pushl $0
80106b35:	6a 00                	push   $0x0
  pushl $126
80106b37:	6a 7e                	push   $0x7e
  jmp alltraps
80106b39:	e9 1e f5 ff ff       	jmp    8010605c <alltraps>

80106b3e <vector127>:
.globl vector127
vector127:
  pushl $0
80106b3e:	6a 00                	push   $0x0
  pushl $127
80106b40:	6a 7f                	push   $0x7f
  jmp alltraps
80106b42:	e9 15 f5 ff ff       	jmp    8010605c <alltraps>

80106b47 <vector128>:
.globl vector128
vector128:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $128
80106b49:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106b4e:	e9 09 f5 ff ff       	jmp    8010605c <alltraps>

80106b53 <vector129>:
.globl vector129
vector129:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $129
80106b55:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106b5a:	e9 fd f4 ff ff       	jmp    8010605c <alltraps>

80106b5f <vector130>:
.globl vector130
vector130:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $130
80106b61:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106b66:	e9 f1 f4 ff ff       	jmp    8010605c <alltraps>

80106b6b <vector131>:
.globl vector131
vector131:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $131
80106b6d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106b72:	e9 e5 f4 ff ff       	jmp    8010605c <alltraps>

80106b77 <vector132>:
.globl vector132
vector132:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $132
80106b79:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106b7e:	e9 d9 f4 ff ff       	jmp    8010605c <alltraps>

80106b83 <vector133>:
.globl vector133
vector133:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $133
80106b85:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106b8a:	e9 cd f4 ff ff       	jmp    8010605c <alltraps>

80106b8f <vector134>:
.globl vector134
vector134:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $134
80106b91:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106b96:	e9 c1 f4 ff ff       	jmp    8010605c <alltraps>

80106b9b <vector135>:
.globl vector135
vector135:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $135
80106b9d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106ba2:	e9 b5 f4 ff ff       	jmp    8010605c <alltraps>

80106ba7 <vector136>:
.globl vector136
vector136:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $136
80106ba9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106bae:	e9 a9 f4 ff ff       	jmp    8010605c <alltraps>

80106bb3 <vector137>:
.globl vector137
vector137:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $137
80106bb5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106bba:	e9 9d f4 ff ff       	jmp    8010605c <alltraps>

80106bbf <vector138>:
.globl vector138
vector138:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $138
80106bc1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106bc6:	e9 91 f4 ff ff       	jmp    8010605c <alltraps>

80106bcb <vector139>:
.globl vector139
vector139:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $139
80106bcd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106bd2:	e9 85 f4 ff ff       	jmp    8010605c <alltraps>

80106bd7 <vector140>:
.globl vector140
vector140:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $140
80106bd9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106bde:	e9 79 f4 ff ff       	jmp    8010605c <alltraps>

80106be3 <vector141>:
.globl vector141
vector141:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $141
80106be5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106bea:	e9 6d f4 ff ff       	jmp    8010605c <alltraps>

80106bef <vector142>:
.globl vector142
vector142:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $142
80106bf1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106bf6:	e9 61 f4 ff ff       	jmp    8010605c <alltraps>

80106bfb <vector143>:
.globl vector143
vector143:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $143
80106bfd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106c02:	e9 55 f4 ff ff       	jmp    8010605c <alltraps>

80106c07 <vector144>:
.globl vector144
vector144:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $144
80106c09:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106c0e:	e9 49 f4 ff ff       	jmp    8010605c <alltraps>

80106c13 <vector145>:
.globl vector145
vector145:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $145
80106c15:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106c1a:	e9 3d f4 ff ff       	jmp    8010605c <alltraps>

80106c1f <vector146>:
.globl vector146
vector146:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $146
80106c21:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106c26:	e9 31 f4 ff ff       	jmp    8010605c <alltraps>

80106c2b <vector147>:
.globl vector147
vector147:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $147
80106c2d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106c32:	e9 25 f4 ff ff       	jmp    8010605c <alltraps>

80106c37 <vector148>:
.globl vector148
vector148:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $148
80106c39:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106c3e:	e9 19 f4 ff ff       	jmp    8010605c <alltraps>

80106c43 <vector149>:
.globl vector149
vector149:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $149
80106c45:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106c4a:	e9 0d f4 ff ff       	jmp    8010605c <alltraps>

80106c4f <vector150>:
.globl vector150
vector150:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $150
80106c51:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106c56:	e9 01 f4 ff ff       	jmp    8010605c <alltraps>

80106c5b <vector151>:
.globl vector151
vector151:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $151
80106c5d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106c62:	e9 f5 f3 ff ff       	jmp    8010605c <alltraps>

80106c67 <vector152>:
.globl vector152
vector152:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $152
80106c69:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106c6e:	e9 e9 f3 ff ff       	jmp    8010605c <alltraps>

80106c73 <vector153>:
.globl vector153
vector153:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $153
80106c75:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106c7a:	e9 dd f3 ff ff       	jmp    8010605c <alltraps>

80106c7f <vector154>:
.globl vector154
vector154:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $154
80106c81:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106c86:	e9 d1 f3 ff ff       	jmp    8010605c <alltraps>

80106c8b <vector155>:
.globl vector155
vector155:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $155
80106c8d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106c92:	e9 c5 f3 ff ff       	jmp    8010605c <alltraps>

80106c97 <vector156>:
.globl vector156
vector156:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $156
80106c99:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106c9e:	e9 b9 f3 ff ff       	jmp    8010605c <alltraps>

80106ca3 <vector157>:
.globl vector157
vector157:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $157
80106ca5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106caa:	e9 ad f3 ff ff       	jmp    8010605c <alltraps>

80106caf <vector158>:
.globl vector158
vector158:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $158
80106cb1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106cb6:	e9 a1 f3 ff ff       	jmp    8010605c <alltraps>

80106cbb <vector159>:
.globl vector159
vector159:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $159
80106cbd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106cc2:	e9 95 f3 ff ff       	jmp    8010605c <alltraps>

80106cc7 <vector160>:
.globl vector160
vector160:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $160
80106cc9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106cce:	e9 89 f3 ff ff       	jmp    8010605c <alltraps>

80106cd3 <vector161>:
.globl vector161
vector161:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $161
80106cd5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106cda:	e9 7d f3 ff ff       	jmp    8010605c <alltraps>

80106cdf <vector162>:
.globl vector162
vector162:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $162
80106ce1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106ce6:	e9 71 f3 ff ff       	jmp    8010605c <alltraps>

80106ceb <vector163>:
.globl vector163
vector163:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $163
80106ced:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106cf2:	e9 65 f3 ff ff       	jmp    8010605c <alltraps>

80106cf7 <vector164>:
.globl vector164
vector164:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $164
80106cf9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106cfe:	e9 59 f3 ff ff       	jmp    8010605c <alltraps>

80106d03 <vector165>:
.globl vector165
vector165:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $165
80106d05:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106d0a:	e9 4d f3 ff ff       	jmp    8010605c <alltraps>

80106d0f <vector166>:
.globl vector166
vector166:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $166
80106d11:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106d16:	e9 41 f3 ff ff       	jmp    8010605c <alltraps>

80106d1b <vector167>:
.globl vector167
vector167:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $167
80106d1d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106d22:	e9 35 f3 ff ff       	jmp    8010605c <alltraps>

80106d27 <vector168>:
.globl vector168
vector168:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $168
80106d29:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106d2e:	e9 29 f3 ff ff       	jmp    8010605c <alltraps>

80106d33 <vector169>:
.globl vector169
vector169:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $169
80106d35:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106d3a:	e9 1d f3 ff ff       	jmp    8010605c <alltraps>

80106d3f <vector170>:
.globl vector170
vector170:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $170
80106d41:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106d46:	e9 11 f3 ff ff       	jmp    8010605c <alltraps>

80106d4b <vector171>:
.globl vector171
vector171:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $171
80106d4d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106d52:	e9 05 f3 ff ff       	jmp    8010605c <alltraps>

80106d57 <vector172>:
.globl vector172
vector172:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $172
80106d59:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106d5e:	e9 f9 f2 ff ff       	jmp    8010605c <alltraps>

80106d63 <vector173>:
.globl vector173
vector173:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $173
80106d65:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106d6a:	e9 ed f2 ff ff       	jmp    8010605c <alltraps>

80106d6f <vector174>:
.globl vector174
vector174:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $174
80106d71:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106d76:	e9 e1 f2 ff ff       	jmp    8010605c <alltraps>

80106d7b <vector175>:
.globl vector175
vector175:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $175
80106d7d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106d82:	e9 d5 f2 ff ff       	jmp    8010605c <alltraps>

80106d87 <vector176>:
.globl vector176
vector176:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $176
80106d89:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106d8e:	e9 c9 f2 ff ff       	jmp    8010605c <alltraps>

80106d93 <vector177>:
.globl vector177
vector177:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $177
80106d95:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106d9a:	e9 bd f2 ff ff       	jmp    8010605c <alltraps>

80106d9f <vector178>:
.globl vector178
vector178:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $178
80106da1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106da6:	e9 b1 f2 ff ff       	jmp    8010605c <alltraps>

80106dab <vector179>:
.globl vector179
vector179:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $179
80106dad:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106db2:	e9 a5 f2 ff ff       	jmp    8010605c <alltraps>

80106db7 <vector180>:
.globl vector180
vector180:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $180
80106db9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106dbe:	e9 99 f2 ff ff       	jmp    8010605c <alltraps>

80106dc3 <vector181>:
.globl vector181
vector181:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $181
80106dc5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106dca:	e9 8d f2 ff ff       	jmp    8010605c <alltraps>

80106dcf <vector182>:
.globl vector182
vector182:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $182
80106dd1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106dd6:	e9 81 f2 ff ff       	jmp    8010605c <alltraps>

80106ddb <vector183>:
.globl vector183
vector183:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $183
80106ddd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106de2:	e9 75 f2 ff ff       	jmp    8010605c <alltraps>

80106de7 <vector184>:
.globl vector184
vector184:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $184
80106de9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106dee:	e9 69 f2 ff ff       	jmp    8010605c <alltraps>

80106df3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $185
80106df5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106dfa:	e9 5d f2 ff ff       	jmp    8010605c <alltraps>

80106dff <vector186>:
.globl vector186
vector186:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $186
80106e01:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106e06:	e9 51 f2 ff ff       	jmp    8010605c <alltraps>

80106e0b <vector187>:
.globl vector187
vector187:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $187
80106e0d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106e12:	e9 45 f2 ff ff       	jmp    8010605c <alltraps>

80106e17 <vector188>:
.globl vector188
vector188:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $188
80106e19:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106e1e:	e9 39 f2 ff ff       	jmp    8010605c <alltraps>

80106e23 <vector189>:
.globl vector189
vector189:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $189
80106e25:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106e2a:	e9 2d f2 ff ff       	jmp    8010605c <alltraps>

80106e2f <vector190>:
.globl vector190
vector190:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $190
80106e31:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106e36:	e9 21 f2 ff ff       	jmp    8010605c <alltraps>

80106e3b <vector191>:
.globl vector191
vector191:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $191
80106e3d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106e42:	e9 15 f2 ff ff       	jmp    8010605c <alltraps>

80106e47 <vector192>:
.globl vector192
vector192:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $192
80106e49:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106e4e:	e9 09 f2 ff ff       	jmp    8010605c <alltraps>

80106e53 <vector193>:
.globl vector193
vector193:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $193
80106e55:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106e5a:	e9 fd f1 ff ff       	jmp    8010605c <alltraps>

80106e5f <vector194>:
.globl vector194
vector194:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $194
80106e61:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106e66:	e9 f1 f1 ff ff       	jmp    8010605c <alltraps>

80106e6b <vector195>:
.globl vector195
vector195:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $195
80106e6d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106e72:	e9 e5 f1 ff ff       	jmp    8010605c <alltraps>

80106e77 <vector196>:
.globl vector196
vector196:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $196
80106e79:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106e7e:	e9 d9 f1 ff ff       	jmp    8010605c <alltraps>

80106e83 <vector197>:
.globl vector197
vector197:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $197
80106e85:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106e8a:	e9 cd f1 ff ff       	jmp    8010605c <alltraps>

80106e8f <vector198>:
.globl vector198
vector198:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $198
80106e91:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106e96:	e9 c1 f1 ff ff       	jmp    8010605c <alltraps>

80106e9b <vector199>:
.globl vector199
vector199:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $199
80106e9d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106ea2:	e9 b5 f1 ff ff       	jmp    8010605c <alltraps>

80106ea7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $200
80106ea9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106eae:	e9 a9 f1 ff ff       	jmp    8010605c <alltraps>

80106eb3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $201
80106eb5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106eba:	e9 9d f1 ff ff       	jmp    8010605c <alltraps>

80106ebf <vector202>:
.globl vector202
vector202:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $202
80106ec1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106ec6:	e9 91 f1 ff ff       	jmp    8010605c <alltraps>

80106ecb <vector203>:
.globl vector203
vector203:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $203
80106ecd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106ed2:	e9 85 f1 ff ff       	jmp    8010605c <alltraps>

80106ed7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $204
80106ed9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106ede:	e9 79 f1 ff ff       	jmp    8010605c <alltraps>

80106ee3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $205
80106ee5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106eea:	e9 6d f1 ff ff       	jmp    8010605c <alltraps>

80106eef <vector206>:
.globl vector206
vector206:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $206
80106ef1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106ef6:	e9 61 f1 ff ff       	jmp    8010605c <alltraps>

80106efb <vector207>:
.globl vector207
vector207:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $207
80106efd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106f02:	e9 55 f1 ff ff       	jmp    8010605c <alltraps>

80106f07 <vector208>:
.globl vector208
vector208:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $208
80106f09:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106f0e:	e9 49 f1 ff ff       	jmp    8010605c <alltraps>

80106f13 <vector209>:
.globl vector209
vector209:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $209
80106f15:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106f1a:	e9 3d f1 ff ff       	jmp    8010605c <alltraps>

80106f1f <vector210>:
.globl vector210
vector210:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $210
80106f21:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106f26:	e9 31 f1 ff ff       	jmp    8010605c <alltraps>

80106f2b <vector211>:
.globl vector211
vector211:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $211
80106f2d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106f32:	e9 25 f1 ff ff       	jmp    8010605c <alltraps>

80106f37 <vector212>:
.globl vector212
vector212:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $212
80106f39:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106f3e:	e9 19 f1 ff ff       	jmp    8010605c <alltraps>

80106f43 <vector213>:
.globl vector213
vector213:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $213
80106f45:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106f4a:	e9 0d f1 ff ff       	jmp    8010605c <alltraps>

80106f4f <vector214>:
.globl vector214
vector214:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $214
80106f51:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106f56:	e9 01 f1 ff ff       	jmp    8010605c <alltraps>

80106f5b <vector215>:
.globl vector215
vector215:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $215
80106f5d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106f62:	e9 f5 f0 ff ff       	jmp    8010605c <alltraps>

80106f67 <vector216>:
.globl vector216
vector216:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $216
80106f69:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106f6e:	e9 e9 f0 ff ff       	jmp    8010605c <alltraps>

80106f73 <vector217>:
.globl vector217
vector217:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $217
80106f75:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106f7a:	e9 dd f0 ff ff       	jmp    8010605c <alltraps>

80106f7f <vector218>:
.globl vector218
vector218:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $218
80106f81:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106f86:	e9 d1 f0 ff ff       	jmp    8010605c <alltraps>

80106f8b <vector219>:
.globl vector219
vector219:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $219
80106f8d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106f92:	e9 c5 f0 ff ff       	jmp    8010605c <alltraps>

80106f97 <vector220>:
.globl vector220
vector220:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $220
80106f99:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106f9e:	e9 b9 f0 ff ff       	jmp    8010605c <alltraps>

80106fa3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $221
80106fa5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106faa:	e9 ad f0 ff ff       	jmp    8010605c <alltraps>

80106faf <vector222>:
.globl vector222
vector222:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $222
80106fb1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106fb6:	e9 a1 f0 ff ff       	jmp    8010605c <alltraps>

80106fbb <vector223>:
.globl vector223
vector223:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $223
80106fbd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106fc2:	e9 95 f0 ff ff       	jmp    8010605c <alltraps>

80106fc7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $224
80106fc9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106fce:	e9 89 f0 ff ff       	jmp    8010605c <alltraps>

80106fd3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $225
80106fd5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106fda:	e9 7d f0 ff ff       	jmp    8010605c <alltraps>

80106fdf <vector226>:
.globl vector226
vector226:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $226
80106fe1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106fe6:	e9 71 f0 ff ff       	jmp    8010605c <alltraps>

80106feb <vector227>:
.globl vector227
vector227:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $227
80106fed:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106ff2:	e9 65 f0 ff ff       	jmp    8010605c <alltraps>

80106ff7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $228
80106ff9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106ffe:	e9 59 f0 ff ff       	jmp    8010605c <alltraps>

80107003 <vector229>:
.globl vector229
vector229:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $229
80107005:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010700a:	e9 4d f0 ff ff       	jmp    8010605c <alltraps>

8010700f <vector230>:
.globl vector230
vector230:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $230
80107011:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107016:	e9 41 f0 ff ff       	jmp    8010605c <alltraps>

8010701b <vector231>:
.globl vector231
vector231:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $231
8010701d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107022:	e9 35 f0 ff ff       	jmp    8010605c <alltraps>

80107027 <vector232>:
.globl vector232
vector232:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $232
80107029:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010702e:	e9 29 f0 ff ff       	jmp    8010605c <alltraps>

80107033 <vector233>:
.globl vector233
vector233:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $233
80107035:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010703a:	e9 1d f0 ff ff       	jmp    8010605c <alltraps>

8010703f <vector234>:
.globl vector234
vector234:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $234
80107041:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107046:	e9 11 f0 ff ff       	jmp    8010605c <alltraps>

8010704b <vector235>:
.globl vector235
vector235:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $235
8010704d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107052:	e9 05 f0 ff ff       	jmp    8010605c <alltraps>

80107057 <vector236>:
.globl vector236
vector236:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $236
80107059:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010705e:	e9 f9 ef ff ff       	jmp    8010605c <alltraps>

80107063 <vector237>:
.globl vector237
vector237:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $237
80107065:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010706a:	e9 ed ef ff ff       	jmp    8010605c <alltraps>

8010706f <vector238>:
.globl vector238
vector238:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $238
80107071:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107076:	e9 e1 ef ff ff       	jmp    8010605c <alltraps>

8010707b <vector239>:
.globl vector239
vector239:
  pushl $0
8010707b:	6a 00                	push   $0x0
  pushl $239
8010707d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107082:	e9 d5 ef ff ff       	jmp    8010605c <alltraps>

80107087 <vector240>:
.globl vector240
vector240:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $240
80107089:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010708e:	e9 c9 ef ff ff       	jmp    8010605c <alltraps>

80107093 <vector241>:
.globl vector241
vector241:
  pushl $0
80107093:	6a 00                	push   $0x0
  pushl $241
80107095:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010709a:	e9 bd ef ff ff       	jmp    8010605c <alltraps>

8010709f <vector242>:
.globl vector242
vector242:
  pushl $0
8010709f:	6a 00                	push   $0x0
  pushl $242
801070a1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801070a6:	e9 b1 ef ff ff       	jmp    8010605c <alltraps>

801070ab <vector243>:
.globl vector243
vector243:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $243
801070ad:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801070b2:	e9 a5 ef ff ff       	jmp    8010605c <alltraps>

801070b7 <vector244>:
.globl vector244
vector244:
  pushl $0
801070b7:	6a 00                	push   $0x0
  pushl $244
801070b9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801070be:	e9 99 ef ff ff       	jmp    8010605c <alltraps>

801070c3 <vector245>:
.globl vector245
vector245:
  pushl $0
801070c3:	6a 00                	push   $0x0
  pushl $245
801070c5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801070ca:	e9 8d ef ff ff       	jmp    8010605c <alltraps>

801070cf <vector246>:
.globl vector246
vector246:
  pushl $0
801070cf:	6a 00                	push   $0x0
  pushl $246
801070d1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801070d6:	e9 81 ef ff ff       	jmp    8010605c <alltraps>

801070db <vector247>:
.globl vector247
vector247:
  pushl $0
801070db:	6a 00                	push   $0x0
  pushl $247
801070dd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801070e2:	e9 75 ef ff ff       	jmp    8010605c <alltraps>

801070e7 <vector248>:
.globl vector248
vector248:
  pushl $0
801070e7:	6a 00                	push   $0x0
  pushl $248
801070e9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801070ee:	e9 69 ef ff ff       	jmp    8010605c <alltraps>

801070f3 <vector249>:
.globl vector249
vector249:
  pushl $0
801070f3:	6a 00                	push   $0x0
  pushl $249
801070f5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801070fa:	e9 5d ef ff ff       	jmp    8010605c <alltraps>

801070ff <vector250>:
.globl vector250
vector250:
  pushl $0
801070ff:	6a 00                	push   $0x0
  pushl $250
80107101:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107106:	e9 51 ef ff ff       	jmp    8010605c <alltraps>

8010710b <vector251>:
.globl vector251
vector251:
  pushl $0
8010710b:	6a 00                	push   $0x0
  pushl $251
8010710d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107112:	e9 45 ef ff ff       	jmp    8010605c <alltraps>

80107117 <vector252>:
.globl vector252
vector252:
  pushl $0
80107117:	6a 00                	push   $0x0
  pushl $252
80107119:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010711e:	e9 39 ef ff ff       	jmp    8010605c <alltraps>

80107123 <vector253>:
.globl vector253
vector253:
  pushl $0
80107123:	6a 00                	push   $0x0
  pushl $253
80107125:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010712a:	e9 2d ef ff ff       	jmp    8010605c <alltraps>

8010712f <vector254>:
.globl vector254
vector254:
  pushl $0
8010712f:	6a 00                	push   $0x0
  pushl $254
80107131:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107136:	e9 21 ef ff ff       	jmp    8010605c <alltraps>

8010713b <vector255>:
.globl vector255
vector255:
  pushl $0
8010713b:	6a 00                	push   $0x0
  pushl $255
8010713d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107142:	e9 15 ef ff ff       	jmp    8010605c <alltraps>

80107147 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107147:	55                   	push   %ebp
80107148:	89 e5                	mov    %esp,%ebp
8010714a:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010714d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107150:	83 e8 01             	sub    $0x1,%eax
80107153:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107157:	8b 45 08             	mov    0x8(%ebp),%eax
8010715a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010715e:	8b 45 08             	mov    0x8(%ebp),%eax
80107161:	c1 e8 10             	shr    $0x10,%eax
80107164:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107168:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010716b:	0f 01 10             	lgdtl  (%eax)
}
8010716e:	c9                   	leave  
8010716f:	c3                   	ret    

80107170 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107170:	55                   	push   %ebp
80107171:	89 e5                	mov    %esp,%ebp
80107173:	83 ec 04             	sub    $0x4,%esp
80107176:	8b 45 08             	mov    0x8(%ebp),%eax
80107179:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
8010717d:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107181:	0f 00 d8             	ltr    %ax
}
80107184:	c9                   	leave  
80107185:	c3                   	ret    

80107186 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107186:	55                   	push   %ebp
80107187:	89 e5                	mov    %esp,%ebp
80107189:	83 ec 04             	sub    $0x4,%esp
8010718c:	8b 45 08             	mov    0x8(%ebp),%eax
8010718f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107193:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107197:	8e e8                	mov    %eax,%gs
}
80107199:	c9                   	leave  
8010719a:	c3                   	ret    

8010719b <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
8010719b:	55                   	push   %ebp
8010719c:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010719e:	8b 45 08             	mov    0x8(%ebp),%eax
801071a1:	0f 22 d8             	mov    %eax,%cr3
}
801071a4:	5d                   	pop    %ebp
801071a5:	c3                   	ret    

801071a6 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801071a6:	55                   	push   %ebp
801071a7:	89 e5                	mov    %esp,%ebp
801071a9:	8b 45 08             	mov    0x8(%ebp),%eax
801071ac:	05 00 00 00 80       	add    $0x80000000,%eax
801071b1:	5d                   	pop    %ebp
801071b2:	c3                   	ret    

801071b3 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801071b3:	55                   	push   %ebp
801071b4:	89 e5                	mov    %esp,%ebp
801071b6:	8b 45 08             	mov    0x8(%ebp),%eax
801071b9:	05 00 00 00 80       	add    $0x80000000,%eax
801071be:	5d                   	pop    %ebp
801071bf:	c3                   	ret    

801071c0 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801071c0:	55                   	push   %ebp
801071c1:	89 e5                	mov    %esp,%ebp
801071c3:	53                   	push   %ebx
801071c4:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
801071c7:	e8 7b bc ff ff       	call   80102e47 <cpunum>
801071cc:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801071d2:	05 20 f9 10 80       	add    $0x8010f920,%eax
801071d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801071da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071dd:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801071e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071e6:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801071ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071ef:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801071f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071f6:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801071fa:	83 e2 f0             	and    $0xfffffff0,%edx
801071fd:	83 ca 0a             	or     $0xa,%edx
80107200:	88 50 7d             	mov    %dl,0x7d(%eax)
80107203:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107206:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010720a:	83 ca 10             	or     $0x10,%edx
8010720d:	88 50 7d             	mov    %dl,0x7d(%eax)
80107210:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107213:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107217:	83 e2 9f             	and    $0xffffff9f,%edx
8010721a:	88 50 7d             	mov    %dl,0x7d(%eax)
8010721d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107220:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107224:	83 ca 80             	or     $0xffffff80,%edx
80107227:	88 50 7d             	mov    %dl,0x7d(%eax)
8010722a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010722d:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107231:	83 ca 0f             	or     $0xf,%edx
80107234:	88 50 7e             	mov    %dl,0x7e(%eax)
80107237:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010723a:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010723e:	83 e2 ef             	and    $0xffffffef,%edx
80107241:	88 50 7e             	mov    %dl,0x7e(%eax)
80107244:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107247:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010724b:	83 e2 df             	and    $0xffffffdf,%edx
8010724e:	88 50 7e             	mov    %dl,0x7e(%eax)
80107251:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107254:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107258:	83 ca 40             	or     $0x40,%edx
8010725b:	88 50 7e             	mov    %dl,0x7e(%eax)
8010725e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107261:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107265:	83 ca 80             	or     $0xffffff80,%edx
80107268:	88 50 7e             	mov    %dl,0x7e(%eax)
8010726b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010726e:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107272:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107275:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
8010727c:	ff ff 
8010727e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107281:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107288:	00 00 
8010728a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010728d:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107294:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107297:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010729e:	83 e2 f0             	and    $0xfffffff0,%edx
801072a1:	83 ca 02             	or     $0x2,%edx
801072a4:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801072aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072ad:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801072b4:	83 ca 10             	or     $0x10,%edx
801072b7:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801072bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072c0:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801072c7:	83 e2 9f             	and    $0xffffff9f,%edx
801072ca:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801072d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072d3:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801072da:	83 ca 80             	or     $0xffffff80,%edx
801072dd:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801072e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072e6:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801072ed:	83 ca 0f             	or     $0xf,%edx
801072f0:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801072f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072f9:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107300:	83 e2 ef             	and    $0xffffffef,%edx
80107303:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107309:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010730c:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107313:	83 e2 df             	and    $0xffffffdf,%edx
80107316:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010731c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010731f:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107326:	83 ca 40             	or     $0x40,%edx
80107329:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010732f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107332:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107339:	83 ca 80             	or     $0xffffff80,%edx
8010733c:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107342:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107345:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010734c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010734f:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107356:	ff ff 
80107358:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010735b:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107362:	00 00 
80107364:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107367:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
8010736e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107371:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107378:	83 e2 f0             	and    $0xfffffff0,%edx
8010737b:	83 ca 0a             	or     $0xa,%edx
8010737e:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107384:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107387:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010738e:	83 ca 10             	or     $0x10,%edx
80107391:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107397:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010739a:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801073a1:	83 ca 60             	or     $0x60,%edx
801073a4:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801073aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073ad:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801073b4:	83 ca 80             	or     $0xffffff80,%edx
801073b7:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801073bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073c0:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801073c7:	83 ca 0f             	or     $0xf,%edx
801073ca:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801073d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073d3:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801073da:	83 e2 ef             	and    $0xffffffef,%edx
801073dd:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801073e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073e6:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801073ed:	83 e2 df             	and    $0xffffffdf,%edx
801073f0:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801073f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073f9:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107400:	83 ca 40             	or     $0x40,%edx
80107403:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107409:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010740c:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107413:	83 ca 80             	or     $0xffffff80,%edx
80107416:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010741c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010741f:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107426:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107429:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107430:	ff ff 
80107432:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107435:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
8010743c:	00 00 
8010743e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107441:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107448:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010744b:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107452:	83 e2 f0             	and    $0xfffffff0,%edx
80107455:	83 ca 02             	or     $0x2,%edx
80107458:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010745e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107461:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107468:	83 ca 10             	or     $0x10,%edx
8010746b:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107471:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107474:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010747b:	83 ca 60             	or     $0x60,%edx
8010747e:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107484:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107487:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010748e:	83 ca 80             	or     $0xffffff80,%edx
80107491:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107497:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010749a:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801074a1:	83 ca 0f             	or     $0xf,%edx
801074a4:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801074aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074ad:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801074b4:	83 e2 ef             	and    $0xffffffef,%edx
801074b7:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801074bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074c0:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801074c7:	83 e2 df             	and    $0xffffffdf,%edx
801074ca:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801074d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074d3:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801074da:	83 ca 40             	or     $0x40,%edx
801074dd:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801074e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074e6:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801074ed:	83 ca 80             	or     $0xffffff80,%edx
801074f0:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801074f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074f9:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107500:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107503:	05 b4 00 00 00       	add    $0xb4,%eax
80107508:	89 c3                	mov    %eax,%ebx
8010750a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010750d:	05 b4 00 00 00       	add    $0xb4,%eax
80107512:	c1 e8 10             	shr    $0x10,%eax
80107515:	89 c1                	mov    %eax,%ecx
80107517:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010751a:	05 b4 00 00 00       	add    $0xb4,%eax
8010751f:	c1 e8 18             	shr    $0x18,%eax
80107522:	89 c2                	mov    %eax,%edx
80107524:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107527:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
8010752e:	00 00 
80107530:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107533:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
8010753a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010753d:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
80107543:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107546:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
8010754d:	83 e1 f0             	and    $0xfffffff0,%ecx
80107550:	83 c9 02             	or     $0x2,%ecx
80107553:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107559:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010755c:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107563:	83 c9 10             	or     $0x10,%ecx
80107566:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
8010756c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010756f:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107576:	83 e1 9f             	and    $0xffffff9f,%ecx
80107579:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
8010757f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107582:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107589:	83 c9 80             	or     $0xffffff80,%ecx
8010758c:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107592:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107595:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
8010759c:	83 e1 f0             	and    $0xfffffff0,%ecx
8010759f:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801075a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075a8:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801075af:	83 e1 ef             	and    $0xffffffef,%ecx
801075b2:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801075b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075bb:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801075c2:	83 e1 df             	and    $0xffffffdf,%ecx
801075c5:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801075cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075ce:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801075d5:	83 c9 40             	or     $0x40,%ecx
801075d8:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801075de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075e1:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
801075e8:	83 c9 80             	or     $0xffffff80,%ecx
801075eb:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801075f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075f4:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
801075fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075fd:	83 c0 70             	add    $0x70,%eax
80107600:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
80107607:	00 
80107608:	89 04 24             	mov    %eax,(%esp)
8010760b:	e8 37 fb ff ff       	call   80107147 <lgdt>
  loadgs(SEG_KCPU << 3);
80107610:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80107617:	e8 6a fb ff ff       	call   80107186 <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
8010761c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010761f:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107625:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010762c:	00 00 00 00 
}
80107630:	83 c4 24             	add    $0x24,%esp
80107633:	5b                   	pop    %ebx
80107634:	5d                   	pop    %ebp
80107635:	c3                   	ret    

80107636 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107636:	55                   	push   %ebp
80107637:	89 e5                	mov    %esp,%ebp
80107639:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010763c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010763f:	c1 e8 16             	shr    $0x16,%eax
80107642:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107649:	8b 45 08             	mov    0x8(%ebp),%eax
8010764c:	01 d0                	add    %edx,%eax
8010764e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107651:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107654:	8b 00                	mov    (%eax),%eax
80107656:	83 e0 01             	and    $0x1,%eax
80107659:	85 c0                	test   %eax,%eax
8010765b:	74 17                	je     80107674 <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
8010765d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107660:	8b 00                	mov    (%eax),%eax
80107662:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107667:	89 04 24             	mov    %eax,(%esp)
8010766a:	e8 44 fb ff ff       	call   801071b3 <p2v>
8010766f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107672:	eb 4b                	jmp    801076bf <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107674:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107678:	74 0e                	je     80107688 <walkpgdir+0x52>
8010767a:	e8 4f b4 ff ff       	call   80102ace <kalloc>
8010767f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107682:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107686:	75 07                	jne    8010768f <walkpgdir+0x59>
      return 0;
80107688:	b8 00 00 00 00       	mov    $0x0,%eax
8010768d:	eb 47                	jmp    801076d6 <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010768f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107696:	00 
80107697:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010769e:	00 
8010769f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076a2:	89 04 24             	mov    %eax,(%esp)
801076a5:	e8 f0 d5 ff ff       	call   80104c9a <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
801076aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ad:	89 04 24             	mov    %eax,(%esp)
801076b0:	e8 f1 fa ff ff       	call   801071a6 <v2p>
801076b5:	83 c8 07             	or     $0x7,%eax
801076b8:	89 c2                	mov    %eax,%edx
801076ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076bd:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801076bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801076c2:	c1 e8 0c             	shr    $0xc,%eax
801076c5:	25 ff 03 00 00       	and    $0x3ff,%eax
801076ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801076d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076d4:	01 d0                	add    %edx,%eax
}
801076d6:	c9                   	leave  
801076d7:	c3                   	ret    

801076d8 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801076d8:	55                   	push   %ebp
801076d9:	89 e5                	mov    %esp,%ebp
801076db:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
801076de:	8b 45 0c             	mov    0xc(%ebp),%eax
801076e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801076e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801076e9:	8b 55 0c             	mov    0xc(%ebp),%edx
801076ec:	8b 45 10             	mov    0x10(%ebp),%eax
801076ef:	01 d0                	add    %edx,%eax
801076f1:	83 e8 01             	sub    $0x1,%eax
801076f4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801076f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801076fc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80107703:	00 
80107704:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107707:	89 44 24 04          	mov    %eax,0x4(%esp)
8010770b:	8b 45 08             	mov    0x8(%ebp),%eax
8010770e:	89 04 24             	mov    %eax,(%esp)
80107711:	e8 20 ff ff ff       	call   80107636 <walkpgdir>
80107716:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107719:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010771d:	75 07                	jne    80107726 <mappages+0x4e>
      return -1;
8010771f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107724:	eb 48                	jmp    8010776e <mappages+0x96>
    if(*pte & PTE_P)
80107726:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107729:	8b 00                	mov    (%eax),%eax
8010772b:	83 e0 01             	and    $0x1,%eax
8010772e:	85 c0                	test   %eax,%eax
80107730:	74 0c                	je     8010773e <mappages+0x66>
      panic("remap");
80107732:	c7 04 24 54 85 10 80 	movl   $0x80108554,(%esp)
80107739:	e8 fc 8d ff ff       	call   8010053a <panic>
    *pte = pa | perm | PTE_P;
8010773e:	8b 45 18             	mov    0x18(%ebp),%eax
80107741:	0b 45 14             	or     0x14(%ebp),%eax
80107744:	83 c8 01             	or     $0x1,%eax
80107747:	89 c2                	mov    %eax,%edx
80107749:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010774c:	89 10                	mov    %edx,(%eax)
    if(a == last)
8010774e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107751:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107754:	75 08                	jne    8010775e <mappages+0x86>
      break;
80107756:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107757:	b8 00 00 00 00       	mov    $0x0,%eax
8010775c:	eb 10                	jmp    8010776e <mappages+0x96>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
8010775e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107765:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
8010776c:	eb 8e                	jmp    801076fc <mappages+0x24>
  return 0;
}
8010776e:	c9                   	leave  
8010776f:	c3                   	ret    

80107770 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107770:	55                   	push   %ebp
80107771:	89 e5                	mov    %esp,%ebp
80107773:	53                   	push   %ebx
80107774:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107777:	e8 52 b3 ff ff       	call   80102ace <kalloc>
8010777c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010777f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107783:	75 0a                	jne    8010778f <setupkvm+0x1f>
    return 0;
80107785:	b8 00 00 00 00       	mov    $0x0,%eax
8010778a:	e9 98 00 00 00       	jmp    80107827 <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
8010778f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107796:	00 
80107797:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010779e:	00 
8010779f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077a2:	89 04 24             	mov    %eax,(%esp)
801077a5:	e8 f0 d4 ff ff       	call   80104c9a <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
801077aa:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
801077b1:	e8 fd f9 ff ff       	call   801071b3 <p2v>
801077b6:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801077bb:	76 0c                	jbe    801077c9 <setupkvm+0x59>
    panic("PHYSTOP too high");
801077bd:	c7 04 24 5a 85 10 80 	movl   $0x8010855a,(%esp)
801077c4:	e8 71 8d ff ff       	call   8010053a <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801077c9:	c7 45 f4 a0 b4 10 80 	movl   $0x8010b4a0,-0xc(%ebp)
801077d0:	eb 49                	jmp    8010781b <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801077d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077d5:	8b 48 0c             	mov    0xc(%eax),%ecx
801077d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077db:	8b 50 04             	mov    0x4(%eax),%edx
801077de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077e1:	8b 58 08             	mov    0x8(%eax),%ebx
801077e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077e7:	8b 40 04             	mov    0x4(%eax),%eax
801077ea:	29 c3                	sub    %eax,%ebx
801077ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077ef:	8b 00                	mov    (%eax),%eax
801077f1:	89 4c 24 10          	mov    %ecx,0x10(%esp)
801077f5:	89 54 24 0c          	mov    %edx,0xc(%esp)
801077f9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801077fd:	89 44 24 04          	mov    %eax,0x4(%esp)
80107801:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107804:	89 04 24             	mov    %eax,(%esp)
80107807:	e8 cc fe ff ff       	call   801076d8 <mappages>
8010780c:	85 c0                	test   %eax,%eax
8010780e:	79 07                	jns    80107817 <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80107810:	b8 00 00 00 00       	mov    $0x0,%eax
80107815:	eb 10                	jmp    80107827 <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107817:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010781b:	81 7d f4 e0 b4 10 80 	cmpl   $0x8010b4e0,-0xc(%ebp)
80107822:	72 ae                	jb     801077d2 <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80107824:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107827:	83 c4 34             	add    $0x34,%esp
8010782a:	5b                   	pop    %ebx
8010782b:	5d                   	pop    %ebp
8010782c:	c3                   	ret    

8010782d <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
8010782d:	55                   	push   %ebp
8010782e:	89 e5                	mov    %esp,%ebp
80107830:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107833:	e8 38 ff ff ff       	call   80107770 <setupkvm>
80107838:	a3 f8 26 11 80       	mov    %eax,0x801126f8
  switchkvm();
8010783d:	e8 02 00 00 00       	call   80107844 <switchkvm>
}
80107842:	c9                   	leave  
80107843:	c3                   	ret    

80107844 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107844:	55                   	push   %ebp
80107845:	89 e5                	mov    %esp,%ebp
80107847:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
8010784a:	a1 f8 26 11 80       	mov    0x801126f8,%eax
8010784f:	89 04 24             	mov    %eax,(%esp)
80107852:	e8 4f f9 ff ff       	call   801071a6 <v2p>
80107857:	89 04 24             	mov    %eax,(%esp)
8010785a:	e8 3c f9 ff ff       	call   8010719b <lcr3>
}
8010785f:	c9                   	leave  
80107860:	c3                   	ret    

80107861 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107861:	55                   	push   %ebp
80107862:	89 e5                	mov    %esp,%ebp
80107864:	53                   	push   %ebx
80107865:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80107868:	e8 2d d3 ff ff       	call   80104b9a <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
8010786d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107873:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010787a:	83 c2 08             	add    $0x8,%edx
8010787d:	89 d3                	mov    %edx,%ebx
8010787f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107886:	83 c2 08             	add    $0x8,%edx
80107889:	c1 ea 10             	shr    $0x10,%edx
8010788c:	89 d1                	mov    %edx,%ecx
8010788e:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107895:	83 c2 08             	add    $0x8,%edx
80107898:	c1 ea 18             	shr    $0x18,%edx
8010789b:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801078a2:	67 00 
801078a4:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
801078ab:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
801078b1:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
801078b8:	83 e1 f0             	and    $0xfffffff0,%ecx
801078bb:	83 c9 09             	or     $0x9,%ecx
801078be:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
801078c4:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
801078cb:	83 c9 10             	or     $0x10,%ecx
801078ce:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
801078d4:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
801078db:	83 e1 9f             	and    $0xffffff9f,%ecx
801078de:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
801078e4:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
801078eb:	83 c9 80             	or     $0xffffff80,%ecx
801078ee:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
801078f4:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801078fb:	83 e1 f0             	and    $0xfffffff0,%ecx
801078fe:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107904:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
8010790b:	83 e1 ef             	and    $0xffffffef,%ecx
8010790e:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107914:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
8010791b:	83 e1 df             	and    $0xffffffdf,%ecx
8010791e:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107924:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
8010792b:	83 c9 40             	or     $0x40,%ecx
8010792e:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107934:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
8010793b:	83 e1 7f             	and    $0x7f,%ecx
8010793e:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107944:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
8010794a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107950:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107957:	83 e2 ef             	and    $0xffffffef,%edx
8010795a:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80107960:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107966:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
8010796c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107972:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80107979:	8b 52 08             	mov    0x8(%edx),%edx
8010797c:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107982:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80107985:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
8010798c:	e8 df f7 ff ff       	call   80107170 <ltr>
  if(p->pgdir == 0)
80107991:	8b 45 08             	mov    0x8(%ebp),%eax
80107994:	8b 40 04             	mov    0x4(%eax),%eax
80107997:	85 c0                	test   %eax,%eax
80107999:	75 0c                	jne    801079a7 <switchuvm+0x146>
    panic("switchuvm: no pgdir");
8010799b:	c7 04 24 6b 85 10 80 	movl   $0x8010856b,(%esp)
801079a2:	e8 93 8b ff ff       	call   8010053a <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
801079a7:	8b 45 08             	mov    0x8(%ebp),%eax
801079aa:	8b 40 04             	mov    0x4(%eax),%eax
801079ad:	89 04 24             	mov    %eax,(%esp)
801079b0:	e8 f1 f7 ff ff       	call   801071a6 <v2p>
801079b5:	89 04 24             	mov    %eax,(%esp)
801079b8:	e8 de f7 ff ff       	call   8010719b <lcr3>
  popcli();
801079bd:	e8 1c d2 ff ff       	call   80104bde <popcli>
}
801079c2:	83 c4 14             	add    $0x14,%esp
801079c5:	5b                   	pop    %ebx
801079c6:	5d                   	pop    %ebp
801079c7:	c3                   	ret    

801079c8 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801079c8:	55                   	push   %ebp
801079c9:	89 e5                	mov    %esp,%ebp
801079cb:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
801079ce:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801079d5:	76 0c                	jbe    801079e3 <inituvm+0x1b>
    panic("inituvm: more than a page");
801079d7:	c7 04 24 7f 85 10 80 	movl   $0x8010857f,(%esp)
801079de:	e8 57 8b ff ff       	call   8010053a <panic>
  mem = kalloc();
801079e3:	e8 e6 b0 ff ff       	call   80102ace <kalloc>
801079e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801079eb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801079f2:	00 
801079f3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801079fa:	00 
801079fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079fe:	89 04 24             	mov    %eax,(%esp)
80107a01:	e8 94 d2 ff ff       	call   80104c9a <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a09:	89 04 24             	mov    %eax,(%esp)
80107a0c:	e8 95 f7 ff ff       	call   801071a6 <v2p>
80107a11:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107a18:	00 
80107a19:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107a1d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107a24:	00 
80107a25:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107a2c:	00 
80107a2d:	8b 45 08             	mov    0x8(%ebp),%eax
80107a30:	89 04 24             	mov    %eax,(%esp)
80107a33:	e8 a0 fc ff ff       	call   801076d8 <mappages>
  memmove(mem, init, sz);
80107a38:	8b 45 10             	mov    0x10(%ebp),%eax
80107a3b:	89 44 24 08          	mov    %eax,0x8(%esp)
80107a3f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a42:	89 44 24 04          	mov    %eax,0x4(%esp)
80107a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a49:	89 04 24             	mov    %eax,(%esp)
80107a4c:	e8 18 d3 ff ff       	call   80104d69 <memmove>
}
80107a51:	c9                   	leave  
80107a52:	c3                   	ret    

80107a53 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107a53:	55                   	push   %ebp
80107a54:	89 e5                	mov    %esp,%ebp
80107a56:	53                   	push   %ebx
80107a57:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a5d:	25 ff 0f 00 00       	and    $0xfff,%eax
80107a62:	85 c0                	test   %eax,%eax
80107a64:	74 0c                	je     80107a72 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80107a66:	c7 04 24 9c 85 10 80 	movl   $0x8010859c,(%esp)
80107a6d:	e8 c8 8a ff ff       	call   8010053a <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107a72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107a79:	e9 a9 00 00 00       	jmp    80107b27 <loaduvm+0xd4>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a81:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a84:	01 d0                	add    %edx,%eax
80107a86:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107a8d:	00 
80107a8e:	89 44 24 04          	mov    %eax,0x4(%esp)
80107a92:	8b 45 08             	mov    0x8(%ebp),%eax
80107a95:	89 04 24             	mov    %eax,(%esp)
80107a98:	e8 99 fb ff ff       	call   80107636 <walkpgdir>
80107a9d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107aa0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107aa4:	75 0c                	jne    80107ab2 <loaduvm+0x5f>
      panic("loaduvm: address should exist");
80107aa6:	c7 04 24 bf 85 10 80 	movl   $0x801085bf,(%esp)
80107aad:	e8 88 8a ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80107ab2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107ab5:	8b 00                	mov    (%eax),%eax
80107ab7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107abc:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ac2:	8b 55 18             	mov    0x18(%ebp),%edx
80107ac5:	29 c2                	sub    %eax,%edx
80107ac7:	89 d0                	mov    %edx,%eax
80107ac9:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107ace:	77 0f                	ja     80107adf <loaduvm+0x8c>
      n = sz - i;
80107ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ad3:	8b 55 18             	mov    0x18(%ebp),%edx
80107ad6:	29 c2                	sub    %eax,%edx
80107ad8:	89 d0                	mov    %edx,%eax
80107ada:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107add:	eb 07                	jmp    80107ae6 <loaduvm+0x93>
    else
      n = PGSIZE;
80107adf:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80107ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ae9:	8b 55 14             	mov    0x14(%ebp),%edx
80107aec:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80107aef:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107af2:	89 04 24             	mov    %eax,(%esp)
80107af5:	e8 b9 f6 ff ff       	call   801071b3 <p2v>
80107afa:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107afd:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107b01:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107b05:	89 44 24 04          	mov    %eax,0x4(%esp)
80107b09:	8b 45 10             	mov    0x10(%ebp),%eax
80107b0c:	89 04 24             	mov    %eax,(%esp)
80107b0f:	e8 40 a2 ff ff       	call   80101d54 <readi>
80107b14:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107b17:	74 07                	je     80107b20 <loaduvm+0xcd>
      return -1;
80107b19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b1e:	eb 18                	jmp    80107b38 <loaduvm+0xe5>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107b20:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b2a:	3b 45 18             	cmp    0x18(%ebp),%eax
80107b2d:	0f 82 4b ff ff ff    	jb     80107a7e <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80107b33:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107b38:	83 c4 24             	add    $0x24,%esp
80107b3b:	5b                   	pop    %ebx
80107b3c:	5d                   	pop    %ebp
80107b3d:	c3                   	ret    

80107b3e <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107b3e:	55                   	push   %ebp
80107b3f:	89 e5                	mov    %esp,%ebp
80107b41:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107b44:	8b 45 10             	mov    0x10(%ebp),%eax
80107b47:	85 c0                	test   %eax,%eax
80107b49:	79 0a                	jns    80107b55 <allocuvm+0x17>
    return 0;
80107b4b:	b8 00 00 00 00       	mov    $0x0,%eax
80107b50:	e9 c1 00 00 00       	jmp    80107c16 <allocuvm+0xd8>
  if(newsz < oldsz)
80107b55:	8b 45 10             	mov    0x10(%ebp),%eax
80107b58:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107b5b:	73 08                	jae    80107b65 <allocuvm+0x27>
    return oldsz;
80107b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b60:	e9 b1 00 00 00       	jmp    80107c16 <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
80107b65:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b68:	05 ff 0f 00 00       	add    $0xfff,%eax
80107b6d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107b75:	e9 8d 00 00 00       	jmp    80107c07 <allocuvm+0xc9>
    mem = kalloc();
80107b7a:	e8 4f af ff ff       	call   80102ace <kalloc>
80107b7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107b82:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107b86:	75 2c                	jne    80107bb4 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
80107b88:	c7 04 24 dd 85 10 80 	movl   $0x801085dd,(%esp)
80107b8f:	e8 0c 88 ff ff       	call   801003a0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107b94:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b97:	89 44 24 08          	mov    %eax,0x8(%esp)
80107b9b:	8b 45 10             	mov    0x10(%ebp),%eax
80107b9e:	89 44 24 04          	mov    %eax,0x4(%esp)
80107ba2:	8b 45 08             	mov    0x8(%ebp),%eax
80107ba5:	89 04 24             	mov    %eax,(%esp)
80107ba8:	e8 6b 00 00 00       	call   80107c18 <deallocuvm>
      return 0;
80107bad:	b8 00 00 00 00       	mov    $0x0,%eax
80107bb2:	eb 62                	jmp    80107c16 <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
80107bb4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107bbb:	00 
80107bbc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107bc3:	00 
80107bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107bc7:	89 04 24             	mov    %eax,(%esp)
80107bca:	e8 cb d0 ff ff       	call   80104c9a <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107bcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107bd2:	89 04 24             	mov    %eax,(%esp)
80107bd5:	e8 cc f5 ff ff       	call   801071a6 <v2p>
80107bda:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107bdd:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107be4:	00 
80107be5:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107be9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107bf0:	00 
80107bf1:	89 54 24 04          	mov    %edx,0x4(%esp)
80107bf5:	8b 45 08             	mov    0x8(%ebp),%eax
80107bf8:	89 04 24             	mov    %eax,(%esp)
80107bfb:	e8 d8 fa ff ff       	call   801076d8 <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107c00:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c0a:	3b 45 10             	cmp    0x10(%ebp),%eax
80107c0d:	0f 82 67 ff ff ff    	jb     80107b7a <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80107c13:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107c16:	c9                   	leave  
80107c17:	c3                   	ret    

80107c18 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107c18:	55                   	push   %ebp
80107c19:	89 e5                	mov    %esp,%ebp
80107c1b:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107c1e:	8b 45 10             	mov    0x10(%ebp),%eax
80107c21:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107c24:	72 08                	jb     80107c2e <deallocuvm+0x16>
    return oldsz;
80107c26:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c29:	e9 a4 00 00 00       	jmp    80107cd2 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
80107c2e:	8b 45 10             	mov    0x10(%ebp),%eax
80107c31:	05 ff 0f 00 00       	add    $0xfff,%eax
80107c36:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107c3e:	e9 80 00 00 00       	jmp    80107cc3 <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c46:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107c4d:	00 
80107c4e:	89 44 24 04          	mov    %eax,0x4(%esp)
80107c52:	8b 45 08             	mov    0x8(%ebp),%eax
80107c55:	89 04 24             	mov    %eax,(%esp)
80107c58:	e8 d9 f9 ff ff       	call   80107636 <walkpgdir>
80107c5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80107c60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107c64:	75 09                	jne    80107c6f <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
80107c66:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80107c6d:	eb 4d                	jmp    80107cbc <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
80107c6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c72:	8b 00                	mov    (%eax),%eax
80107c74:	83 e0 01             	and    $0x1,%eax
80107c77:	85 c0                	test   %eax,%eax
80107c79:	74 41                	je     80107cbc <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
80107c7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c7e:	8b 00                	mov    (%eax),%eax
80107c80:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c85:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80107c88:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107c8c:	75 0c                	jne    80107c9a <deallocuvm+0x82>
        panic("kfree");
80107c8e:	c7 04 24 f5 85 10 80 	movl   $0x801085f5,(%esp)
80107c95:	e8 a0 88 ff ff       	call   8010053a <panic>
      char *v = p2v(pa);
80107c9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c9d:	89 04 24             	mov    %eax,(%esp)
80107ca0:	e8 0e f5 ff ff       	call   801071b3 <p2v>
80107ca5:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80107ca8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107cab:	89 04 24             	mov    %eax,(%esp)
80107cae:	e8 82 ad ff ff       	call   80102a35 <kfree>
      *pte = 0;
80107cb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107cb6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80107cbc:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cc6:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107cc9:	0f 82 74 ff ff ff    	jb     80107c43 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80107ccf:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107cd2:	c9                   	leave  
80107cd3:	c3                   	ret    

80107cd4 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107cd4:	55                   	push   %ebp
80107cd5:	89 e5                	mov    %esp,%ebp
80107cd7:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80107cda:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107cde:	75 0c                	jne    80107cec <freevm+0x18>
    panic("freevm: no pgdir");
80107ce0:	c7 04 24 fb 85 10 80 	movl   $0x801085fb,(%esp)
80107ce7:	e8 4e 88 ff ff       	call   8010053a <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80107cec:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107cf3:	00 
80107cf4:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80107cfb:	80 
80107cfc:	8b 45 08             	mov    0x8(%ebp),%eax
80107cff:	89 04 24             	mov    %eax,(%esp)
80107d02:	e8 11 ff ff ff       	call   80107c18 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80107d07:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107d0e:	eb 48                	jmp    80107d58 <freevm+0x84>
    if(pgdir[i] & PTE_P){
80107d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d13:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107d1a:	8b 45 08             	mov    0x8(%ebp),%eax
80107d1d:	01 d0                	add    %edx,%eax
80107d1f:	8b 00                	mov    (%eax),%eax
80107d21:	83 e0 01             	and    $0x1,%eax
80107d24:	85 c0                	test   %eax,%eax
80107d26:	74 2c                	je     80107d54 <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80107d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d2b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107d32:	8b 45 08             	mov    0x8(%ebp),%eax
80107d35:	01 d0                	add    %edx,%eax
80107d37:	8b 00                	mov    (%eax),%eax
80107d39:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d3e:	89 04 24             	mov    %eax,(%esp)
80107d41:	e8 6d f4 ff ff       	call   801071b3 <p2v>
80107d46:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80107d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d4c:	89 04 24             	mov    %eax,(%esp)
80107d4f:	e8 e1 ac ff ff       	call   80102a35 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107d54:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107d58:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80107d5f:	76 af                	jbe    80107d10 <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107d61:	8b 45 08             	mov    0x8(%ebp),%eax
80107d64:	89 04 24             	mov    %eax,(%esp)
80107d67:	e8 c9 ac ff ff       	call   80102a35 <kfree>
}
80107d6c:	c9                   	leave  
80107d6d:	c3                   	ret    

80107d6e <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107d6e:	55                   	push   %ebp
80107d6f:	89 e5                	mov    %esp,%ebp
80107d71:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107d74:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107d7b:	00 
80107d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d7f:	89 44 24 04          	mov    %eax,0x4(%esp)
80107d83:	8b 45 08             	mov    0x8(%ebp),%eax
80107d86:	89 04 24             	mov    %eax,(%esp)
80107d89:	e8 a8 f8 ff ff       	call   80107636 <walkpgdir>
80107d8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80107d91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107d95:	75 0c                	jne    80107da3 <clearpteu+0x35>
    panic("clearpteu");
80107d97:	c7 04 24 0c 86 10 80 	movl   $0x8010860c,(%esp)
80107d9e:	e8 97 87 ff ff       	call   8010053a <panic>
  *pte &= ~PTE_U;
80107da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107da6:	8b 00                	mov    (%eax),%eax
80107da8:	83 e0 fb             	and    $0xfffffffb,%eax
80107dab:	89 c2                	mov    %eax,%edx
80107dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107db0:	89 10                	mov    %edx,(%eax)
}
80107db2:	c9                   	leave  
80107db3:	c3                   	ret    

80107db4 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107db4:	55                   	push   %ebp
80107db5:	89 e5                	mov    %esp,%ebp
80107db7:	53                   	push   %ebx
80107db8:	83 ec 44             	sub    $0x44,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107dbb:	e8 b0 f9 ff ff       	call   80107770 <setupkvm>
80107dc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107dc3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107dc7:	75 0a                	jne    80107dd3 <copyuvm+0x1f>
    return 0;
80107dc9:	b8 00 00 00 00       	mov    $0x0,%eax
80107dce:	e9 fd 00 00 00       	jmp    80107ed0 <copyuvm+0x11c>
  for(i = 0; i < sz; i += PGSIZE){
80107dd3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107dda:	e9 d0 00 00 00       	jmp    80107eaf <copyuvm+0xfb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107de2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107de9:	00 
80107dea:	89 44 24 04          	mov    %eax,0x4(%esp)
80107dee:	8b 45 08             	mov    0x8(%ebp),%eax
80107df1:	89 04 24             	mov    %eax,(%esp)
80107df4:	e8 3d f8 ff ff       	call   80107636 <walkpgdir>
80107df9:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107dfc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107e00:	75 0c                	jne    80107e0e <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
80107e02:	c7 04 24 16 86 10 80 	movl   $0x80108616,(%esp)
80107e09:	e8 2c 87 ff ff       	call   8010053a <panic>
    if(!(*pte & PTE_P))
80107e0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107e11:	8b 00                	mov    (%eax),%eax
80107e13:	83 e0 01             	and    $0x1,%eax
80107e16:	85 c0                	test   %eax,%eax
80107e18:	75 0c                	jne    80107e26 <copyuvm+0x72>
      panic("copyuvm: page not present");
80107e1a:	c7 04 24 30 86 10 80 	movl   $0x80108630,(%esp)
80107e21:	e8 14 87 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80107e26:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107e29:	8b 00                	mov    (%eax),%eax
80107e2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107e30:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80107e33:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107e36:	8b 00                	mov    (%eax),%eax
80107e38:	25 ff 0f 00 00       	and    $0xfff,%eax
80107e3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107e40:	e8 89 ac ff ff       	call   80102ace <kalloc>
80107e45:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107e48:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80107e4c:	75 02                	jne    80107e50 <copyuvm+0x9c>
      goto bad;
80107e4e:	eb 70                	jmp    80107ec0 <copyuvm+0x10c>
    memmove(mem, (char*)p2v(pa), PGSIZE);
80107e50:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107e53:	89 04 24             	mov    %eax,(%esp)
80107e56:	e8 58 f3 ff ff       	call   801071b3 <p2v>
80107e5b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107e62:	00 
80107e63:	89 44 24 04          	mov    %eax,0x4(%esp)
80107e67:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107e6a:	89 04 24             	mov    %eax,(%esp)
80107e6d:	e8 f7 ce ff ff       	call   80104d69 <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80107e72:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80107e75:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107e78:	89 04 24             	mov    %eax,(%esp)
80107e7b:	e8 26 f3 ff ff       	call   801071a6 <v2p>
80107e80:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107e83:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80107e87:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107e8b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107e92:	00 
80107e93:	89 54 24 04          	mov    %edx,0x4(%esp)
80107e97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e9a:	89 04 24             	mov    %eax,(%esp)
80107e9d:	e8 36 f8 ff ff       	call   801076d8 <mappages>
80107ea2:	85 c0                	test   %eax,%eax
80107ea4:	79 02                	jns    80107ea8 <copyuvm+0xf4>
      goto bad;
80107ea6:	eb 18                	jmp    80107ec0 <copyuvm+0x10c>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107ea8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eb2:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107eb5:	0f 82 24 ff ff ff    	jb     80107ddf <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80107ebb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ebe:	eb 10                	jmp    80107ed0 <copyuvm+0x11c>

bad:
  freevm(d);
80107ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ec3:	89 04 24             	mov    %eax,(%esp)
80107ec6:	e8 09 fe ff ff       	call   80107cd4 <freevm>
  return 0;
80107ecb:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107ed0:	83 c4 44             	add    $0x44,%esp
80107ed3:	5b                   	pop    %ebx
80107ed4:	5d                   	pop    %ebp
80107ed5:	c3                   	ret    

80107ed6 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107ed6:	55                   	push   %ebp
80107ed7:	89 e5                	mov    %esp,%ebp
80107ed9:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107edc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107ee3:	00 
80107ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ee7:	89 44 24 04          	mov    %eax,0x4(%esp)
80107eeb:	8b 45 08             	mov    0x8(%ebp),%eax
80107eee:	89 04 24             	mov    %eax,(%esp)
80107ef1:	e8 40 f7 ff ff       	call   80107636 <walkpgdir>
80107ef6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80107ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107efc:	8b 00                	mov    (%eax),%eax
80107efe:	83 e0 01             	and    $0x1,%eax
80107f01:	85 c0                	test   %eax,%eax
80107f03:	75 07                	jne    80107f0c <uva2ka+0x36>
    return 0;
80107f05:	b8 00 00 00 00       	mov    $0x0,%eax
80107f0a:	eb 25                	jmp    80107f31 <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
80107f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f0f:	8b 00                	mov    (%eax),%eax
80107f11:	83 e0 04             	and    $0x4,%eax
80107f14:	85 c0                	test   %eax,%eax
80107f16:	75 07                	jne    80107f1f <uva2ka+0x49>
    return 0;
80107f18:	b8 00 00 00 00       	mov    $0x0,%eax
80107f1d:	eb 12                	jmp    80107f31 <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
80107f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f22:	8b 00                	mov    (%eax),%eax
80107f24:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f29:	89 04 24             	mov    %eax,(%esp)
80107f2c:	e8 82 f2 ff ff       	call   801071b3 <p2v>
}
80107f31:	c9                   	leave  
80107f32:	c3                   	ret    

80107f33 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107f33:	55                   	push   %ebp
80107f34:	89 e5                	mov    %esp,%ebp
80107f36:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80107f39:	8b 45 10             	mov    0x10(%ebp),%eax
80107f3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80107f3f:	e9 87 00 00 00       	jmp    80107fcb <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
80107f44:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f47:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80107f4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f52:	89 44 24 04          	mov    %eax,0x4(%esp)
80107f56:	8b 45 08             	mov    0x8(%ebp),%eax
80107f59:	89 04 24             	mov    %eax,(%esp)
80107f5c:	e8 75 ff ff ff       	call   80107ed6 <uva2ka>
80107f61:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80107f64:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80107f68:	75 07                	jne    80107f71 <copyout+0x3e>
      return -1;
80107f6a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f6f:	eb 69                	jmp    80107fda <copyout+0xa7>
    n = PGSIZE - (va - va0);
80107f71:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f74:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107f77:	29 c2                	sub    %eax,%edx
80107f79:	89 d0                	mov    %edx,%eax
80107f7b:	05 00 10 00 00       	add    $0x1000,%eax
80107f80:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80107f83:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f86:	3b 45 14             	cmp    0x14(%ebp),%eax
80107f89:	76 06                	jbe    80107f91 <copyout+0x5e>
      n = len;
80107f8b:	8b 45 14             	mov    0x14(%ebp),%eax
80107f8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80107f91:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f94:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f97:	29 c2                	sub    %eax,%edx
80107f99:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107f9c:	01 c2                	add    %eax,%edx
80107f9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107fa1:	89 44 24 08          	mov    %eax,0x8(%esp)
80107fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa8:	89 44 24 04          	mov    %eax,0x4(%esp)
80107fac:	89 14 24             	mov    %edx,(%esp)
80107faf:	e8 b5 cd ff ff       	call   80104d69 <memmove>
    len -= n;
80107fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107fb7:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80107fba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107fbd:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80107fc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107fc3:	05 00 10 00 00       	add    $0x1000,%eax
80107fc8:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107fcb:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80107fcf:	0f 85 6f ff ff ff    	jne    80107f44 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80107fd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107fda:	c9                   	leave  
80107fdb:	c3                   	ret    
