
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
80100028:	bc 70 c6 10 80       	mov    $0x8010c670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 23 34 10 80       	mov    $0x80103423,%eax
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
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 e0 82 10 80       	push   $0x801082e0
80100042:	68 80 c6 10 80       	push   $0x8010c680
80100047:	e8 89 4a 00 00       	call   80104ad5 <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 b0 db 10 80 a4 	movl   $0x8010dba4,0x8010dbb0
80100056:	db 10 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 b4 db 10 80 a4 	movl   $0x8010dba4,0x8010dbb4
80100060:	db 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 b4 c6 10 80 	movl   $0x8010c6b4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 b4 db 10 80    	mov    0x8010dbb4,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c a4 db 10 80 	movl   $0x8010dba4,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 b4 db 10 80       	mov    0x8010dbb4,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 b4 db 10 80       	mov    %eax,0x8010dbb4

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	81 7d f4 a4 db 10 80 	cmpl   $0x8010dba4,-0xc(%ebp)
801000ad:	72 bd                	jb     8010006c <binit+0x38>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000af:	c9                   	leave  
801000b0:	c3                   	ret    

801000b1 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate fresh block.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b1:	55                   	push   %ebp
801000b2:	89 e5                	mov    %esp,%ebp
801000b4:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b7:	83 ec 0c             	sub    $0xc,%esp
801000ba:	68 80 c6 10 80       	push   $0x8010c680
801000bf:	e8 32 4a 00 00       	call   80104af6 <acquire>
801000c4:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c7:	a1 b4 db 10 80       	mov    0x8010dbb4,%eax
801000cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000cf:	eb 67                	jmp    80100138 <bget+0x87>
    if(b->dev == dev && b->sector == sector){
801000d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d4:	8b 40 04             	mov    0x4(%eax),%eax
801000d7:	3b 45 08             	cmp    0x8(%ebp),%eax
801000da:	75 53                	jne    8010012f <bget+0x7e>
801000dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000df:	8b 40 08             	mov    0x8(%eax),%eax
801000e2:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e5:	75 48                	jne    8010012f <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ea:	8b 00                	mov    (%eax),%eax
801000ec:	83 e0 01             	and    $0x1,%eax
801000ef:	85 c0                	test   %eax,%eax
801000f1:	75 27                	jne    8010011a <bget+0x69>
        b->flags |= B_BUSY;
801000f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f6:	8b 00                	mov    (%eax),%eax
801000f8:	83 c8 01             	or     $0x1,%eax
801000fb:	89 c2                	mov    %eax,%edx
801000fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100100:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100102:	83 ec 0c             	sub    $0xc,%esp
80100105:	68 80 c6 10 80       	push   $0x8010c680
8010010a:	e8 4d 4a 00 00       	call   80104b5c <release>
8010010f:	83 c4 10             	add    $0x10,%esp
        return b;
80100112:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100115:	e9 98 00 00 00       	jmp    801001b2 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011a:	83 ec 08             	sub    $0x8,%esp
8010011d:	68 80 c6 10 80       	push   $0x8010c680
80100122:	ff 75 f4             	pushl  -0xc(%ebp)
80100125:	e8 de 46 00 00       	call   80104808 <sleep>
8010012a:	83 c4 10             	add    $0x10,%esp
      goto loop;
8010012d:	eb 98                	jmp    801000c7 <bget+0x16>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010012f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100132:	8b 40 10             	mov    0x10(%eax),%eax
80100135:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100138:	81 7d f4 a4 db 10 80 	cmpl   $0x8010dba4,-0xc(%ebp)
8010013f:	75 90                	jne    801000d1 <bget+0x20>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100141:	a1 b0 db 10 80       	mov    0x8010dbb0,%eax
80100146:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100149:	eb 51                	jmp    8010019c <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014e:	8b 00                	mov    (%eax),%eax
80100150:	83 e0 01             	and    $0x1,%eax
80100153:	85 c0                	test   %eax,%eax
80100155:	75 3c                	jne    80100193 <bget+0xe2>
80100157:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015a:	8b 00                	mov    (%eax),%eax
8010015c:	83 e0 04             	and    $0x4,%eax
8010015f:	85 c0                	test   %eax,%eax
80100161:	75 30                	jne    80100193 <bget+0xe2>
      b->dev = dev;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	8b 55 08             	mov    0x8(%ebp),%edx
80100169:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	8b 55 0c             	mov    0xc(%ebp),%edx
80100172:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100175:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100178:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
8010017e:	83 ec 0c             	sub    $0xc,%esp
80100181:	68 80 c6 10 80       	push   $0x8010c680
80100186:	e8 d1 49 00 00       	call   80104b5c <release>
8010018b:	83 c4 10             	add    $0x10,%esp
      return b;
8010018e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100191:	eb 1f                	jmp    801001b2 <bget+0x101>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100193:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100196:	8b 40 0c             	mov    0xc(%eax),%eax
80100199:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019c:	81 7d f4 a4 db 10 80 	cmpl   $0x8010dba4,-0xc(%ebp)
801001a3:	75 a6                	jne    8010014b <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a5:	83 ec 0c             	sub    $0xc,%esp
801001a8:	68 e7 82 10 80       	push   $0x801082e7
801001ad:	e8 aa 03 00 00       	call   8010055c <panic>
}
801001b2:	c9                   	leave  
801001b3:	c3                   	ret    

801001b4 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, sector);
801001ba:	83 ec 08             	sub    $0x8,%esp
801001bd:	ff 75 0c             	pushl  0xc(%ebp)
801001c0:	ff 75 08             	pushl  0x8(%ebp)
801001c3:	e8 e9 fe ff ff       	call   801000b1 <bget>
801001c8:	83 c4 10             	add    $0x10,%esp
801001cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d1:	8b 00                	mov    (%eax),%eax
801001d3:	83 e0 02             	and    $0x2,%eax
801001d6:	85 c0                	test   %eax,%eax
801001d8:	75 0e                	jne    801001e8 <bread+0x34>
    iderw(b);
801001da:	83 ec 0c             	sub    $0xc,%esp
801001dd:	ff 75 f4             	pushl  -0xc(%ebp)
801001e0:	e8 3b 26 00 00       	call   80102820 <iderw>
801001e5:	83 c4 10             	add    $0x10,%esp
  return b;
801001e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001eb:	c9                   	leave  
801001ec:	c3                   	ret    

801001ed <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001ed:	55                   	push   %ebp
801001ee:	89 e5                	mov    %esp,%ebp
801001f0:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f3:	8b 45 08             	mov    0x8(%ebp),%eax
801001f6:	8b 00                	mov    (%eax),%eax
801001f8:	83 e0 01             	and    $0x1,%eax
801001fb:	85 c0                	test   %eax,%eax
801001fd:	75 0d                	jne    8010020c <bwrite+0x1f>
    panic("bwrite");
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	68 f8 82 10 80       	push   $0x801082f8
80100207:	e8 50 03 00 00       	call   8010055c <panic>
  b->flags |= B_DIRTY;
8010020c:	8b 45 08             	mov    0x8(%ebp),%eax
8010020f:	8b 00                	mov    (%eax),%eax
80100211:	83 c8 04             	or     $0x4,%eax
80100214:	89 c2                	mov    %eax,%edx
80100216:	8b 45 08             	mov    0x8(%ebp),%eax
80100219:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021b:	83 ec 0c             	sub    $0xc,%esp
8010021e:	ff 75 08             	pushl  0x8(%ebp)
80100221:	e8 fa 25 00 00       	call   80102820 <iderw>
80100226:	83 c4 10             	add    $0x10,%esp
}
80100229:	c9                   	leave  
8010022a:	c3                   	ret    

8010022b <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022b:	55                   	push   %ebp
8010022c:	89 e5                	mov    %esp,%ebp
8010022e:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100231:	8b 45 08             	mov    0x8(%ebp),%eax
80100234:	8b 00                	mov    (%eax),%eax
80100236:	83 e0 01             	and    $0x1,%eax
80100239:	85 c0                	test   %eax,%eax
8010023b:	75 0d                	jne    8010024a <brelse+0x1f>
    panic("brelse");
8010023d:	83 ec 0c             	sub    $0xc,%esp
80100240:	68 ff 82 10 80       	push   $0x801082ff
80100245:	e8 12 03 00 00       	call   8010055c <panic>

  acquire(&bcache.lock);
8010024a:	83 ec 0c             	sub    $0xc,%esp
8010024d:	68 80 c6 10 80       	push   $0x8010c680
80100252:	e8 9f 48 00 00       	call   80104af6 <acquire>
80100257:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025a:	8b 45 08             	mov    0x8(%ebp),%eax
8010025d:	8b 40 10             	mov    0x10(%eax),%eax
80100260:	8b 55 08             	mov    0x8(%ebp),%edx
80100263:	8b 52 0c             	mov    0xc(%edx),%edx
80100266:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100269:	8b 45 08             	mov    0x8(%ebp),%eax
8010026c:	8b 40 0c             	mov    0xc(%eax),%eax
8010026f:	8b 55 08             	mov    0x8(%ebp),%edx
80100272:	8b 52 10             	mov    0x10(%edx),%edx
80100275:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
80100278:	8b 15 b4 db 10 80    	mov    0x8010dbb4,%edx
8010027e:	8b 45 08             	mov    0x8(%ebp),%eax
80100281:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100284:	8b 45 08             	mov    0x8(%ebp),%eax
80100287:	c7 40 0c a4 db 10 80 	movl   $0x8010dba4,0xc(%eax)
  bcache.head.next->prev = b;
8010028e:	a1 b4 db 10 80       	mov    0x8010dbb4,%eax
80100293:	8b 55 08             	mov    0x8(%ebp),%edx
80100296:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100299:	8b 45 08             	mov    0x8(%ebp),%eax
8010029c:	a3 b4 db 10 80       	mov    %eax,0x8010dbb4

  b->flags &= ~B_BUSY;
801002a1:	8b 45 08             	mov    0x8(%ebp),%eax
801002a4:	8b 00                	mov    (%eax),%eax
801002a6:	83 e0 fe             	and    $0xfffffffe,%eax
801002a9:	89 c2                	mov    %eax,%edx
801002ab:	8b 45 08             	mov    0x8(%ebp),%eax
801002ae:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b0:	83 ec 0c             	sub    $0xc,%esp
801002b3:	ff 75 08             	pushl  0x8(%ebp)
801002b6:	e8 36 46 00 00       	call   801048f1 <wakeup>
801002bb:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002be:	83 ec 0c             	sub    $0xc,%esp
801002c1:	68 80 c6 10 80       	push   $0x8010c680
801002c6:	e8 91 48 00 00       	call   80104b5c <release>
801002cb:	83 c4 10             	add    $0x10,%esp
}
801002ce:	c9                   	leave  
801002cf:	c3                   	ret    

801002d0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002d0:	55                   	push   %ebp
801002d1:	89 e5                	mov    %esp,%ebp
801002d3:	83 ec 14             	sub    $0x14,%esp
801002d6:	8b 45 08             	mov    0x8(%ebp),%eax
801002d9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002dd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e1:	89 c2                	mov    %eax,%edx
801002e3:	ec                   	in     (%dx),%al
801002e4:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002e7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002eb:	c9                   	leave  
801002ec:	c3                   	ret    

801002ed <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002ed:	55                   	push   %ebp
801002ee:	89 e5                	mov    %esp,%ebp
801002f0:	83 ec 08             	sub    $0x8,%esp
801002f3:	8b 55 08             	mov    0x8(%ebp),%edx
801002f6:	8b 45 0c             	mov    0xc(%ebp),%eax
801002f9:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002fd:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100300:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100304:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80100308:	ee                   	out    %al,(%dx)
}
80100309:	c9                   	leave  
8010030a:	c3                   	ret    

8010030b <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
8010030b:	55                   	push   %ebp
8010030c:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010030e:	fa                   	cli    
}
8010030f:	5d                   	pop    %ebp
80100310:	c3                   	ret    

80100311 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100311:	55                   	push   %ebp
80100312:	89 e5                	mov    %esp,%ebp
80100314:	53                   	push   %ebx
80100315:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100318:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010031c:	74 1c                	je     8010033a <printint+0x29>
8010031e:	8b 45 08             	mov    0x8(%ebp),%eax
80100321:	c1 e8 1f             	shr    $0x1f,%eax
80100324:	0f b6 c0             	movzbl %al,%eax
80100327:	89 45 10             	mov    %eax,0x10(%ebp)
8010032a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010032e:	74 0a                	je     8010033a <printint+0x29>
    x = -xx;
80100330:	8b 45 08             	mov    0x8(%ebp),%eax
80100333:	f7 d8                	neg    %eax
80100335:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100338:	eb 06                	jmp    80100340 <printint+0x2f>
  else
    x = xx;
8010033a:	8b 45 08             	mov    0x8(%ebp),%eax
8010033d:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100340:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100347:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010034a:	8d 41 01             	lea    0x1(%ecx),%eax
8010034d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100350:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100353:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100356:	ba 00 00 00 00       	mov    $0x0,%edx
8010035b:	f7 f3                	div    %ebx
8010035d:	89 d0                	mov    %edx,%eax
8010035f:	0f b6 80 04 90 10 80 	movzbl -0x7fef6ffc(%eax),%eax
80100366:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
8010036a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010036d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100370:	ba 00 00 00 00       	mov    $0x0,%edx
80100375:	f7 f3                	div    %ebx
80100377:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010037a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010037e:	75 c7                	jne    80100347 <printint+0x36>

  if(sign)
80100380:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100384:	74 0e                	je     80100394 <printint+0x83>
    buf[i++] = '-';
80100386:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100389:	8d 50 01             	lea    0x1(%eax),%edx
8010038c:	89 55 f4             	mov    %edx,-0xc(%ebp)
8010038f:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
80100394:	eb 1a                	jmp    801003b0 <printint+0x9f>
    consputc(buf[i]);
80100396:	8d 55 e0             	lea    -0x20(%ebp),%edx
80100399:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010039c:	01 d0                	add    %edx,%eax
8010039e:	0f b6 00             	movzbl (%eax),%eax
801003a1:	0f be c0             	movsbl %al,%eax
801003a4:	83 ec 0c             	sub    $0xc,%esp
801003a7:	50                   	push   %eax
801003a8:	e8 bf 03 00 00       	call   8010076c <consputc>
801003ad:	83 c4 10             	add    $0x10,%esp
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003b0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003b8:	79 dc                	jns    80100396 <printint+0x85>
    consputc(buf[i]);
}
801003ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801003bd:	c9                   	leave  
801003be:	c3                   	ret    

801003bf <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003bf:	55                   	push   %ebp
801003c0:	89 e5                	mov    %esp,%ebp
801003c2:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003c5:	a1 14 b6 10 80       	mov    0x8010b614,%eax
801003ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d1:	74 10                	je     801003e3 <cprintf+0x24>
    acquire(&cons.lock);
801003d3:	83 ec 0c             	sub    $0xc,%esp
801003d6:	68 e0 b5 10 80       	push   $0x8010b5e0
801003db:	e8 16 47 00 00       	call   80104af6 <acquire>
801003e0:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003e3:	8b 45 08             	mov    0x8(%ebp),%eax
801003e6:	85 c0                	test   %eax,%eax
801003e8:	75 0d                	jne    801003f7 <cprintf+0x38>
    panic("null fmt");
801003ea:	83 ec 0c             	sub    $0xc,%esp
801003ed:	68 06 83 10 80       	push   $0x80108306
801003f2:	e8 65 01 00 00       	call   8010055c <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003f7:	8d 45 0c             	lea    0xc(%ebp),%eax
801003fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100404:	e9 1b 01 00 00       	jmp    80100524 <cprintf+0x165>
    if(c != '%'){
80100409:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
8010040d:	74 13                	je     80100422 <cprintf+0x63>
      consputc(c);
8010040f:	83 ec 0c             	sub    $0xc,%esp
80100412:	ff 75 e4             	pushl  -0x1c(%ebp)
80100415:	e8 52 03 00 00       	call   8010076c <consputc>
8010041a:	83 c4 10             	add    $0x10,%esp
      continue;
8010041d:	e9 fe 00 00 00       	jmp    80100520 <cprintf+0x161>
    }
    c = fmt[++i] & 0xff;
80100422:	8b 55 08             	mov    0x8(%ebp),%edx
80100425:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100429:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010042c:	01 d0                	add    %edx,%eax
8010042e:	0f b6 00             	movzbl (%eax),%eax
80100431:	0f be c0             	movsbl %al,%eax
80100434:	25 ff 00 00 00       	and    $0xff,%eax
80100439:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
8010043c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100440:	75 05                	jne    80100447 <cprintf+0x88>
      break;
80100442:	e9 fd 00 00 00       	jmp    80100544 <cprintf+0x185>
    switch(c){
80100447:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010044a:	83 f8 70             	cmp    $0x70,%eax
8010044d:	74 47                	je     80100496 <cprintf+0xd7>
8010044f:	83 f8 70             	cmp    $0x70,%eax
80100452:	7f 13                	jg     80100467 <cprintf+0xa8>
80100454:	83 f8 25             	cmp    $0x25,%eax
80100457:	0f 84 98 00 00 00    	je     801004f5 <cprintf+0x136>
8010045d:	83 f8 64             	cmp    $0x64,%eax
80100460:	74 14                	je     80100476 <cprintf+0xb7>
80100462:	e9 9d 00 00 00       	jmp    80100504 <cprintf+0x145>
80100467:	83 f8 73             	cmp    $0x73,%eax
8010046a:	74 47                	je     801004b3 <cprintf+0xf4>
8010046c:	83 f8 78             	cmp    $0x78,%eax
8010046f:	74 25                	je     80100496 <cprintf+0xd7>
80100471:	e9 8e 00 00 00       	jmp    80100504 <cprintf+0x145>
    case 'd':
      printint(*argp++, 10, 1);
80100476:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100479:	8d 50 04             	lea    0x4(%eax),%edx
8010047c:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010047f:	8b 00                	mov    (%eax),%eax
80100481:	83 ec 04             	sub    $0x4,%esp
80100484:	6a 01                	push   $0x1
80100486:	6a 0a                	push   $0xa
80100488:	50                   	push   %eax
80100489:	e8 83 fe ff ff       	call   80100311 <printint>
8010048e:	83 c4 10             	add    $0x10,%esp
      break;
80100491:	e9 8a 00 00 00       	jmp    80100520 <cprintf+0x161>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100496:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100499:	8d 50 04             	lea    0x4(%eax),%edx
8010049c:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010049f:	8b 00                	mov    (%eax),%eax
801004a1:	83 ec 04             	sub    $0x4,%esp
801004a4:	6a 00                	push   $0x0
801004a6:	6a 10                	push   $0x10
801004a8:	50                   	push   %eax
801004a9:	e8 63 fe ff ff       	call   80100311 <printint>
801004ae:	83 c4 10             	add    $0x10,%esp
      break;
801004b1:	eb 6d                	jmp    80100520 <cprintf+0x161>
    case 's':
      if((s = (char*)*argp++) == 0)
801004b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004b6:	8d 50 04             	lea    0x4(%eax),%edx
801004b9:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004bc:	8b 00                	mov    (%eax),%eax
801004be:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004c5:	75 07                	jne    801004ce <cprintf+0x10f>
        s = "(null)";
801004c7:	c7 45 ec 0f 83 10 80 	movl   $0x8010830f,-0x14(%ebp)
      for(; *s; s++)
801004ce:	eb 19                	jmp    801004e9 <cprintf+0x12a>
        consputc(*s);
801004d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d3:	0f b6 00             	movzbl (%eax),%eax
801004d6:	0f be c0             	movsbl %al,%eax
801004d9:	83 ec 0c             	sub    $0xc,%esp
801004dc:	50                   	push   %eax
801004dd:	e8 8a 02 00 00       	call   8010076c <consputc>
801004e2:	83 c4 10             	add    $0x10,%esp
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004e5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004ec:	0f b6 00             	movzbl (%eax),%eax
801004ef:	84 c0                	test   %al,%al
801004f1:	75 dd                	jne    801004d0 <cprintf+0x111>
        consputc(*s);
      break;
801004f3:	eb 2b                	jmp    80100520 <cprintf+0x161>
    case '%':
      consputc('%');
801004f5:	83 ec 0c             	sub    $0xc,%esp
801004f8:	6a 25                	push   $0x25
801004fa:	e8 6d 02 00 00       	call   8010076c <consputc>
801004ff:	83 c4 10             	add    $0x10,%esp
      break;
80100502:	eb 1c                	jmp    80100520 <cprintf+0x161>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100504:	83 ec 0c             	sub    $0xc,%esp
80100507:	6a 25                	push   $0x25
80100509:	e8 5e 02 00 00       	call   8010076c <consputc>
8010050e:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100511:	83 ec 0c             	sub    $0xc,%esp
80100514:	ff 75 e4             	pushl  -0x1c(%ebp)
80100517:	e8 50 02 00 00       	call   8010076c <consputc>
8010051c:	83 c4 10             	add    $0x10,%esp
      break;
8010051f:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100520:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100524:	8b 55 08             	mov    0x8(%ebp),%edx
80100527:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010052a:	01 d0                	add    %edx,%eax
8010052c:	0f b6 00             	movzbl (%eax),%eax
8010052f:	0f be c0             	movsbl %al,%eax
80100532:	25 ff 00 00 00       	and    $0xff,%eax
80100537:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010053a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010053e:	0f 85 c5 fe ff ff    	jne    80100409 <cprintf+0x4a>
      consputc(c);
      break;
    }
  }

  if(locking)
80100544:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100548:	74 10                	je     8010055a <cprintf+0x19b>
    release(&cons.lock);
8010054a:	83 ec 0c             	sub    $0xc,%esp
8010054d:	68 e0 b5 10 80       	push   $0x8010b5e0
80100552:	e8 05 46 00 00       	call   80104b5c <release>
80100557:	83 c4 10             	add    $0x10,%esp
}
8010055a:	c9                   	leave  
8010055b:	c3                   	ret    

8010055c <panic>:

void
panic(char *s)
{
8010055c:	55                   	push   %ebp
8010055d:	89 e5                	mov    %esp,%ebp
8010055f:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
80100562:	e8 a4 fd ff ff       	call   8010030b <cli>
  cons.locking = 0;
80100567:	c7 05 14 b6 10 80 00 	movl   $0x0,0x8010b614
8010056e:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
80100571:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100577:	0f b6 00             	movzbl (%eax),%eax
8010057a:	0f b6 c0             	movzbl %al,%eax
8010057d:	83 ec 08             	sub    $0x8,%esp
80100580:	50                   	push   %eax
80100581:	68 16 83 10 80       	push   $0x80108316
80100586:	e8 34 fe ff ff       	call   801003bf <cprintf>
8010058b:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
8010058e:	8b 45 08             	mov    0x8(%ebp),%eax
80100591:	83 ec 0c             	sub    $0xc,%esp
80100594:	50                   	push   %eax
80100595:	e8 25 fe ff ff       	call   801003bf <cprintf>
8010059a:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
8010059d:	83 ec 0c             	sub    $0xc,%esp
801005a0:	68 25 83 10 80       	push   $0x80108325
801005a5:	e8 15 fe ff ff       	call   801003bf <cprintf>
801005aa:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005ad:	83 ec 08             	sub    $0x8,%esp
801005b0:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005b3:	50                   	push   %eax
801005b4:	8d 45 08             	lea    0x8(%ebp),%eax
801005b7:	50                   	push   %eax
801005b8:	e8 f0 45 00 00       	call   80104bad <getcallerpcs>
801005bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005c7:	eb 1c                	jmp    801005e5 <panic+0x89>
    cprintf(" %p", pcs[i]);
801005c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005cc:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005d0:	83 ec 08             	sub    $0x8,%esp
801005d3:	50                   	push   %eax
801005d4:	68 27 83 10 80       	push   $0x80108327
801005d9:	e8 e1 fd ff ff       	call   801003bf <cprintf>
801005de:	83 c4 10             	add    $0x10,%esp
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005e1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005e5:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005e9:	7e de                	jle    801005c9 <panic+0x6d>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005eb:	c7 05 c0 b5 10 80 01 	movl   $0x1,0x8010b5c0
801005f2:	00 00 00 
  for(;;)
    ;
801005f5:	eb fe                	jmp    801005f5 <panic+0x99>

801005f7 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005f7:	55                   	push   %ebp
801005f8:	89 e5                	mov    %esp,%ebp
801005fa:	83 ec 18             	sub    $0x18,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005fd:	6a 0e                	push   $0xe
801005ff:	68 d4 03 00 00       	push   $0x3d4
80100604:	e8 e4 fc ff ff       	call   801002ed <outb>
80100609:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
8010060c:	68 d5 03 00 00       	push   $0x3d5
80100611:	e8 ba fc ff ff       	call   801002d0 <inb>
80100616:	83 c4 04             	add    $0x4,%esp
80100619:	0f b6 c0             	movzbl %al,%eax
8010061c:	c1 e0 08             	shl    $0x8,%eax
8010061f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
80100622:	6a 0f                	push   $0xf
80100624:	68 d4 03 00 00       	push   $0x3d4
80100629:	e8 bf fc ff ff       	call   801002ed <outb>
8010062e:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
80100631:	68 d5 03 00 00       	push   $0x3d5
80100636:	e8 95 fc ff ff       	call   801002d0 <inb>
8010063b:	83 c4 04             	add    $0x4,%esp
8010063e:	0f b6 c0             	movzbl %al,%eax
80100641:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100644:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100648:	75 30                	jne    8010067a <cgaputc+0x83>
    pos += 80 - pos%80;
8010064a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010064d:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100652:	89 c8                	mov    %ecx,%eax
80100654:	f7 ea                	imul   %edx
80100656:	c1 fa 05             	sar    $0x5,%edx
80100659:	89 c8                	mov    %ecx,%eax
8010065b:	c1 f8 1f             	sar    $0x1f,%eax
8010065e:	29 c2                	sub    %eax,%edx
80100660:	89 d0                	mov    %edx,%eax
80100662:	c1 e0 02             	shl    $0x2,%eax
80100665:	01 d0                	add    %edx,%eax
80100667:	c1 e0 04             	shl    $0x4,%eax
8010066a:	29 c1                	sub    %eax,%ecx
8010066c:	89 ca                	mov    %ecx,%edx
8010066e:	b8 50 00 00 00       	mov    $0x50,%eax
80100673:	29 d0                	sub    %edx,%eax
80100675:	01 45 f4             	add    %eax,-0xc(%ebp)
80100678:	eb 35                	jmp    801006af <cgaputc+0xb8>
  else if(c == BACKSPACE){
8010067a:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100681:	75 0c                	jne    8010068f <cgaputc+0x98>
    if(pos > 0) --pos;
80100683:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100687:	7e 26                	jle    801006af <cgaputc+0xb8>
80100689:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
8010068d:	eb 20                	jmp    801006af <cgaputc+0xb8>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010068f:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
80100695:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100698:	8d 50 01             	lea    0x1(%eax),%edx
8010069b:	89 55 f4             	mov    %edx,-0xc(%ebp)
8010069e:	01 c0                	add    %eax,%eax
801006a0:	8d 14 01             	lea    (%ecx,%eax,1),%edx
801006a3:	8b 45 08             	mov    0x8(%ebp),%eax
801006a6:	0f b6 c0             	movzbl %al,%eax
801006a9:	80 cc 07             	or     $0x7,%ah
801006ac:	66 89 02             	mov    %ax,(%edx)
  
  if((pos/80) >= 24){  // Scroll up.
801006af:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006b6:	7e 4c                	jle    80100704 <cgaputc+0x10d>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006b8:	a1 00 90 10 80       	mov    0x80109000,%eax
801006bd:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006c3:	a1 00 90 10 80       	mov    0x80109000,%eax
801006c8:	83 ec 04             	sub    $0x4,%esp
801006cb:	68 60 0e 00 00       	push   $0xe60
801006d0:	52                   	push   %edx
801006d1:	50                   	push   %eax
801006d2:	e8 3a 47 00 00       	call   80104e11 <memmove>
801006d7:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006da:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006de:	b8 80 07 00 00       	mov    $0x780,%eax
801006e3:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006e6:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006e9:	a1 00 90 10 80       	mov    0x80109000,%eax
801006ee:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006f1:	01 c9                	add    %ecx,%ecx
801006f3:	01 c8                	add    %ecx,%eax
801006f5:	83 ec 04             	sub    $0x4,%esp
801006f8:	52                   	push   %edx
801006f9:	6a 00                	push   $0x0
801006fb:	50                   	push   %eax
801006fc:	e8 51 46 00 00       	call   80104d52 <memset>
80100701:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
80100704:	83 ec 08             	sub    $0x8,%esp
80100707:	6a 0e                	push   $0xe
80100709:	68 d4 03 00 00       	push   $0x3d4
8010070e:	e8 da fb ff ff       	call   801002ed <outb>
80100713:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
80100716:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100719:	c1 f8 08             	sar    $0x8,%eax
8010071c:	0f b6 c0             	movzbl %al,%eax
8010071f:	83 ec 08             	sub    $0x8,%esp
80100722:	50                   	push   %eax
80100723:	68 d5 03 00 00       	push   $0x3d5
80100728:	e8 c0 fb ff ff       	call   801002ed <outb>
8010072d:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
80100730:	83 ec 08             	sub    $0x8,%esp
80100733:	6a 0f                	push   $0xf
80100735:	68 d4 03 00 00       	push   $0x3d4
8010073a:	e8 ae fb ff ff       	call   801002ed <outb>
8010073f:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
80100742:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100745:	0f b6 c0             	movzbl %al,%eax
80100748:	83 ec 08             	sub    $0x8,%esp
8010074b:	50                   	push   %eax
8010074c:	68 d5 03 00 00       	push   $0x3d5
80100751:	e8 97 fb ff ff       	call   801002ed <outb>
80100756:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
80100759:	a1 00 90 10 80       	mov    0x80109000,%eax
8010075e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100761:	01 d2                	add    %edx,%edx
80100763:	01 d0                	add    %edx,%eax
80100765:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010076a:	c9                   	leave  
8010076b:	c3                   	ret    

8010076c <consputc>:

void
consputc(int c)
{
8010076c:	55                   	push   %ebp
8010076d:	89 e5                	mov    %esp,%ebp
8010076f:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
80100772:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
80100777:	85 c0                	test   %eax,%eax
80100779:	74 07                	je     80100782 <consputc+0x16>
    cli();
8010077b:	e8 8b fb ff ff       	call   8010030b <cli>
    for(;;)
      ;
80100780:	eb fe                	jmp    80100780 <consputc+0x14>
  }

  if(c == BACKSPACE){
80100782:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100789:	75 29                	jne    801007b4 <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010078b:	83 ec 0c             	sub    $0xc,%esp
8010078e:	6a 08                	push   $0x8
80100790:	e8 e5 61 00 00       	call   8010697a <uartputc>
80100795:	83 c4 10             	add    $0x10,%esp
80100798:	83 ec 0c             	sub    $0xc,%esp
8010079b:	6a 20                	push   $0x20
8010079d:	e8 d8 61 00 00       	call   8010697a <uartputc>
801007a2:	83 c4 10             	add    $0x10,%esp
801007a5:	83 ec 0c             	sub    $0xc,%esp
801007a8:	6a 08                	push   $0x8
801007aa:	e8 cb 61 00 00       	call   8010697a <uartputc>
801007af:	83 c4 10             	add    $0x10,%esp
801007b2:	eb 0e                	jmp    801007c2 <consputc+0x56>
  } else
    uartputc(c);
801007b4:	83 ec 0c             	sub    $0xc,%esp
801007b7:	ff 75 08             	pushl  0x8(%ebp)
801007ba:	e8 bb 61 00 00       	call   8010697a <uartputc>
801007bf:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801007c2:	83 ec 0c             	sub    $0xc,%esp
801007c5:	ff 75 08             	pushl  0x8(%ebp)
801007c8:	e8 2a fe ff ff       	call   801005f7 <cgaputc>
801007cd:	83 c4 10             	add    $0x10,%esp
}
801007d0:	c9                   	leave  
801007d1:	c3                   	ret    

801007d2 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007d2:	55                   	push   %ebp
801007d3:	89 e5                	mov    %esp,%ebp
801007d5:	83 ec 18             	sub    $0x18,%esp
  int c;

  acquire(&input.lock);
801007d8:	83 ec 0c             	sub    $0xc,%esp
801007db:	68 c0 dd 10 80       	push   $0x8010ddc0
801007e0:	e8 11 43 00 00       	call   80104af6 <acquire>
801007e5:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
801007e8:	e9 3c 01 00 00       	jmp    80100929 <consoleintr+0x157>
    switch(c){
801007ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007f0:	83 f8 10             	cmp    $0x10,%eax
801007f3:	74 1e                	je     80100813 <consoleintr+0x41>
801007f5:	83 f8 10             	cmp    $0x10,%eax
801007f8:	7f 0a                	jg     80100804 <consoleintr+0x32>
801007fa:	83 f8 08             	cmp    $0x8,%eax
801007fd:	74 65                	je     80100864 <consoleintr+0x92>
801007ff:	e9 91 00 00 00       	jmp    80100895 <consoleintr+0xc3>
80100804:	83 f8 15             	cmp    $0x15,%eax
80100807:	74 31                	je     8010083a <consoleintr+0x68>
80100809:	83 f8 7f             	cmp    $0x7f,%eax
8010080c:	74 56                	je     80100864 <consoleintr+0x92>
8010080e:	e9 82 00 00 00       	jmp    80100895 <consoleintr+0xc3>
    case C('P'):  // Process listing.
      procdump();
80100813:	e8 93 41 00 00       	call   801049ab <procdump>
      break;
80100818:	e9 0c 01 00 00       	jmp    80100929 <consoleintr+0x157>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
8010081d:	a1 7c de 10 80       	mov    0x8010de7c,%eax
80100822:	83 e8 01             	sub    $0x1,%eax
80100825:	a3 7c de 10 80       	mov    %eax,0x8010de7c
        consputc(BACKSPACE);
8010082a:	83 ec 0c             	sub    $0xc,%esp
8010082d:	68 00 01 00 00       	push   $0x100
80100832:	e8 35 ff ff ff       	call   8010076c <consputc>
80100837:	83 c4 10             	add    $0x10,%esp
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010083a:	8b 15 7c de 10 80    	mov    0x8010de7c,%edx
80100840:	a1 78 de 10 80       	mov    0x8010de78,%eax
80100845:	39 c2                	cmp    %eax,%edx
80100847:	74 16                	je     8010085f <consoleintr+0x8d>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100849:	a1 7c de 10 80       	mov    0x8010de7c,%eax
8010084e:	83 e8 01             	sub    $0x1,%eax
80100851:	83 e0 7f             	and    $0x7f,%eax
80100854:	0f b6 80 f4 dd 10 80 	movzbl -0x7fef220c(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010085b:	3c 0a                	cmp    $0xa,%al
8010085d:	75 be                	jne    8010081d <consoleintr+0x4b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
8010085f:	e9 c5 00 00 00       	jmp    80100929 <consoleintr+0x157>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100864:	8b 15 7c de 10 80    	mov    0x8010de7c,%edx
8010086a:	a1 78 de 10 80       	mov    0x8010de78,%eax
8010086f:	39 c2                	cmp    %eax,%edx
80100871:	74 1d                	je     80100890 <consoleintr+0xbe>
        input.e--;
80100873:	a1 7c de 10 80       	mov    0x8010de7c,%eax
80100878:	83 e8 01             	sub    $0x1,%eax
8010087b:	a3 7c de 10 80       	mov    %eax,0x8010de7c
        consputc(BACKSPACE);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 00 01 00 00       	push   $0x100
80100888:	e8 df fe ff ff       	call   8010076c <consputc>
8010088d:	83 c4 10             	add    $0x10,%esp
      }
      break;
80100890:	e9 94 00 00 00       	jmp    80100929 <consoleintr+0x157>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100895:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100899:	0f 84 89 00 00 00    	je     80100928 <consoleintr+0x156>
8010089f:	8b 15 7c de 10 80    	mov    0x8010de7c,%edx
801008a5:	a1 74 de 10 80       	mov    0x8010de74,%eax
801008aa:	29 c2                	sub    %eax,%edx
801008ac:	89 d0                	mov    %edx,%eax
801008ae:	83 f8 7f             	cmp    $0x7f,%eax
801008b1:	77 75                	ja     80100928 <consoleintr+0x156>
        c = (c == '\r') ? '\n' : c;
801008b3:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
801008b7:	74 05                	je     801008be <consoleintr+0xec>
801008b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008bc:	eb 05                	jmp    801008c3 <consoleintr+0xf1>
801008be:	b8 0a 00 00 00       	mov    $0xa,%eax
801008c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008c6:	a1 7c de 10 80       	mov    0x8010de7c,%eax
801008cb:	8d 50 01             	lea    0x1(%eax),%edx
801008ce:	89 15 7c de 10 80    	mov    %edx,0x8010de7c
801008d4:	83 e0 7f             	and    $0x7f,%eax
801008d7:	89 c2                	mov    %eax,%edx
801008d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008dc:	88 82 f4 dd 10 80    	mov    %al,-0x7fef220c(%edx)
        consputc(c);
801008e2:	83 ec 0c             	sub    $0xc,%esp
801008e5:	ff 75 f4             	pushl  -0xc(%ebp)
801008e8:	e8 7f fe ff ff       	call   8010076c <consputc>
801008ed:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f0:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008f4:	74 18                	je     8010090e <consoleintr+0x13c>
801008f6:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008fa:	74 12                	je     8010090e <consoleintr+0x13c>
801008fc:	a1 7c de 10 80       	mov    0x8010de7c,%eax
80100901:	8b 15 74 de 10 80    	mov    0x8010de74,%edx
80100907:	83 ea 80             	sub    $0xffffff80,%edx
8010090a:	39 d0                	cmp    %edx,%eax
8010090c:	75 1a                	jne    80100928 <consoleintr+0x156>
          input.w = input.e;
8010090e:	a1 7c de 10 80       	mov    0x8010de7c,%eax
80100913:	a3 78 de 10 80       	mov    %eax,0x8010de78
          wakeup(&input.r);
80100918:	83 ec 0c             	sub    $0xc,%esp
8010091b:	68 74 de 10 80       	push   $0x8010de74
80100920:	e8 cc 3f 00 00       	call   801048f1 <wakeup>
80100925:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
80100928:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
80100929:	8b 45 08             	mov    0x8(%ebp),%eax
8010092c:	ff d0                	call   *%eax
8010092e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100931:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100935:	0f 89 b2 fe ff ff    	jns    801007ed <consoleintr+0x1b>
        }
      }
      break;
    }
  }
  release(&input.lock);
8010093b:	83 ec 0c             	sub    $0xc,%esp
8010093e:	68 c0 dd 10 80       	push   $0x8010ddc0
80100943:	e8 14 42 00 00       	call   80104b5c <release>
80100948:	83 c4 10             	add    $0x10,%esp
}
8010094b:	c9                   	leave  
8010094c:	c3                   	ret    

8010094d <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010094d:	55                   	push   %ebp
8010094e:	89 e5                	mov    %esp,%ebp
80100950:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100953:	83 ec 0c             	sub    $0xc,%esp
80100956:	ff 75 08             	pushl  0x8(%ebp)
80100959:	e8 bc 10 00 00       	call   80101a1a <iunlock>
8010095e:	83 c4 10             	add    $0x10,%esp
  target = n;
80100961:	8b 45 10             	mov    0x10(%ebp),%eax
80100964:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100967:	83 ec 0c             	sub    $0xc,%esp
8010096a:	68 c0 dd 10 80       	push   $0x8010ddc0
8010096f:	e8 82 41 00 00       	call   80104af6 <acquire>
80100974:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
80100977:	e9 b2 00 00 00       	jmp    80100a2e <consoleread+0xe1>
    while(input.r == input.w){
8010097c:	eb 4a                	jmp    801009c8 <consoleread+0x7b>
      if(proc->killed){
8010097e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100984:	8b 40 24             	mov    0x24(%eax),%eax
80100987:	85 c0                	test   %eax,%eax
80100989:	74 28                	je     801009b3 <consoleread+0x66>
        release(&input.lock);
8010098b:	83 ec 0c             	sub    $0xc,%esp
8010098e:	68 c0 dd 10 80       	push   $0x8010ddc0
80100993:	e8 c4 41 00 00       	call   80104b5c <release>
80100998:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
8010099b:	83 ec 0c             	sub    $0xc,%esp
8010099e:	ff 75 08             	pushl  0x8(%ebp)
801009a1:	e8 1d 0f 00 00       	call   801018c3 <ilock>
801009a6:	83 c4 10             	add    $0x10,%esp
        return -1;
801009a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009ae:	e9 ad 00 00 00       	jmp    80100a60 <consoleread+0x113>
      }
      sleep(&input.r, &input.lock);
801009b3:	83 ec 08             	sub    $0x8,%esp
801009b6:	68 c0 dd 10 80       	push   $0x8010ddc0
801009bb:	68 74 de 10 80       	push   $0x8010de74
801009c0:	e8 43 3e 00 00       	call   80104808 <sleep>
801009c5:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
801009c8:	8b 15 74 de 10 80    	mov    0x8010de74,%edx
801009ce:	a1 78 de 10 80       	mov    0x8010de78,%eax
801009d3:	39 c2                	cmp    %eax,%edx
801009d5:	74 a7                	je     8010097e <consoleread+0x31>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801009d7:	a1 74 de 10 80       	mov    0x8010de74,%eax
801009dc:	8d 50 01             	lea    0x1(%eax),%edx
801009df:	89 15 74 de 10 80    	mov    %edx,0x8010de74
801009e5:	83 e0 7f             	and    $0x7f,%eax
801009e8:	0f b6 80 f4 dd 10 80 	movzbl -0x7fef220c(%eax),%eax
801009ef:	0f be c0             	movsbl %al,%eax
801009f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
801009f5:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801009f9:	75 19                	jne    80100a14 <consoleread+0xc7>
      if(n < target){
801009fb:	8b 45 10             	mov    0x10(%ebp),%eax
801009fe:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a01:	73 0f                	jae    80100a12 <consoleread+0xc5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a03:	a1 74 de 10 80       	mov    0x8010de74,%eax
80100a08:	83 e8 01             	sub    $0x1,%eax
80100a0b:	a3 74 de 10 80       	mov    %eax,0x8010de74
      }
      break;
80100a10:	eb 26                	jmp    80100a38 <consoleread+0xeb>
80100a12:	eb 24                	jmp    80100a38 <consoleread+0xeb>
    }
    *dst++ = c;
80100a14:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a17:	8d 50 01             	lea    0x1(%eax),%edx
80100a1a:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a1d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a20:	88 10                	mov    %dl,(%eax)
    --n;
80100a22:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a26:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a2a:	75 02                	jne    80100a2e <consoleread+0xe1>
      break;
80100a2c:	eb 0a                	jmp    80100a38 <consoleread+0xeb>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
80100a2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a32:	0f 8f 44 ff ff ff    	jg     8010097c <consoleread+0x2f>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
80100a38:	83 ec 0c             	sub    $0xc,%esp
80100a3b:	68 c0 dd 10 80       	push   $0x8010ddc0
80100a40:	e8 17 41 00 00       	call   80104b5c <release>
80100a45:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100a48:	83 ec 0c             	sub    $0xc,%esp
80100a4b:	ff 75 08             	pushl  0x8(%ebp)
80100a4e:	e8 70 0e 00 00       	call   801018c3 <ilock>
80100a53:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100a56:	8b 45 10             	mov    0x10(%ebp),%eax
80100a59:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a5c:	29 c2                	sub    %eax,%edx
80100a5e:	89 d0                	mov    %edx,%eax
}
80100a60:	c9                   	leave  
80100a61:	c3                   	ret    

80100a62 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a62:	55                   	push   %ebp
80100a63:	89 e5                	mov    %esp,%ebp
80100a65:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100a68:	83 ec 0c             	sub    $0xc,%esp
80100a6b:	ff 75 08             	pushl  0x8(%ebp)
80100a6e:	e8 a7 0f 00 00       	call   80101a1a <iunlock>
80100a73:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100a76:	83 ec 0c             	sub    $0xc,%esp
80100a79:	68 e0 b5 10 80       	push   $0x8010b5e0
80100a7e:	e8 73 40 00 00       	call   80104af6 <acquire>
80100a83:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100a86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a8d:	eb 21                	jmp    80100ab0 <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100a8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a92:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a95:	01 d0                	add    %edx,%eax
80100a97:	0f b6 00             	movzbl (%eax),%eax
80100a9a:	0f be c0             	movsbl %al,%eax
80100a9d:	0f b6 c0             	movzbl %al,%eax
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	50                   	push   %eax
80100aa4:	e8 c3 fc ff ff       	call   8010076c <consputc>
80100aa9:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100aac:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ab3:	3b 45 10             	cmp    0x10(%ebp),%eax
80100ab6:	7c d7                	jl     80100a8f <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100ab8:	83 ec 0c             	sub    $0xc,%esp
80100abb:	68 e0 b5 10 80       	push   $0x8010b5e0
80100ac0:	e8 97 40 00 00       	call   80104b5c <release>
80100ac5:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100ac8:	83 ec 0c             	sub    $0xc,%esp
80100acb:	ff 75 08             	pushl  0x8(%ebp)
80100ace:	e8 f0 0d 00 00       	call   801018c3 <ilock>
80100ad3:	83 c4 10             	add    $0x10,%esp

  return n;
80100ad6:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100ad9:	c9                   	leave  
80100ada:	c3                   	ret    

80100adb <consoleinit>:

void
consoleinit(void)
{
80100adb:	55                   	push   %ebp
80100adc:	89 e5                	mov    %esp,%ebp
80100ade:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100ae1:	83 ec 08             	sub    $0x8,%esp
80100ae4:	68 2b 83 10 80       	push   $0x8010832b
80100ae9:	68 e0 b5 10 80       	push   $0x8010b5e0
80100aee:	e8 e2 3f 00 00       	call   80104ad5 <initlock>
80100af3:	83 c4 10             	add    $0x10,%esp
  initlock(&input.lock, "input");
80100af6:	83 ec 08             	sub    $0x8,%esp
80100af9:	68 33 83 10 80       	push   $0x80108333
80100afe:	68 c0 dd 10 80       	push   $0x8010ddc0
80100b03:	e8 cd 3f 00 00       	call   80104ad5 <initlock>
80100b08:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b0b:	c7 05 4c e8 10 80 62 	movl   $0x80100a62,0x8010e84c
80100b12:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b15:	c7 05 48 e8 10 80 4d 	movl   $0x8010094d,0x8010e848
80100b1c:	09 10 80 
  cons.locking = 1;
80100b1f:	c7 05 14 b6 10 80 01 	movl   $0x1,0x8010b614
80100b26:	00 00 00 

  picenable(IRQ_KBD);
80100b29:	83 ec 0c             	sub    $0xc,%esp
80100b2c:	6a 01                	push   $0x1
80100b2e:	e8 4f 2f 00 00       	call   80103a82 <picenable>
80100b33:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100b36:	83 ec 08             	sub    $0x8,%esp
80100b39:	6a 00                	push   $0x0
80100b3b:	6a 01                	push   $0x1
80100b3d:	e8 a5 1e 00 00       	call   801029e7 <ioapicenable>
80100b42:	83 c4 10             	add    $0x10,%esp
}
80100b45:	c9                   	leave  
80100b46:	c3                   	ret    

80100b47 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b47:	55                   	push   %ebp
80100b48:	89 e5                	mov    %esp,%ebp
80100b4a:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  if((ip = namei(path)) == 0)
80100b50:	83 ec 0c             	sub    $0xc,%esp
80100b53:	ff 75 08             	pushl  0x8(%ebp)
80100b56:	e8 21 19 00 00       	call   8010247c <namei>
80100b5b:	83 c4 10             	add    $0x10,%esp
80100b5e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b61:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b65:	75 0a                	jne    80100b71 <exec+0x2a>
    return -1;
80100b67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b6c:	e9 af 03 00 00       	jmp    80100f20 <exec+0x3d9>
  ilock(ip);
80100b71:	83 ec 0c             	sub    $0xc,%esp
80100b74:	ff 75 d8             	pushl  -0x28(%ebp)
80100b77:	e8 47 0d 00 00       	call   801018c3 <ilock>
80100b7c:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100b7f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b86:	6a 34                	push   $0x34
80100b88:	6a 00                	push   $0x0
80100b8a:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100b90:	50                   	push   %eax
80100b91:	ff 75 d8             	pushl  -0x28(%ebp)
80100b94:	e8 8c 12 00 00       	call   80101e25 <readi>
80100b99:	83 c4 10             	add    $0x10,%esp
80100b9c:	83 f8 33             	cmp    $0x33,%eax
80100b9f:	77 05                	ja     80100ba6 <exec+0x5f>
    goto bad;
80100ba1:	e9 4d 03 00 00       	jmp    80100ef3 <exec+0x3ac>
  if(elf.magic != ELF_MAGIC)
80100ba6:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bac:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100bb1:	74 05                	je     80100bb8 <exec+0x71>
    goto bad;
80100bb3:	e9 3b 03 00 00       	jmp    80100ef3 <exec+0x3ac>

  if((pgdir = setupkvm()) == 0)
80100bb8:	e8 0d 6f 00 00       	call   80107aca <setupkvm>
80100bbd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100bc0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100bc4:	75 05                	jne    80100bcb <exec+0x84>
    goto bad;
80100bc6:	e9 28 03 00 00       	jmp    80100ef3 <exec+0x3ac>

  // Load program into memory.
  sz = 0;
80100bcb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bd2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100bd9:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100bdf:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100be2:	e9 ae 00 00 00       	jmp    80100c95 <exec+0x14e>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100be7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100bea:	6a 20                	push   $0x20
80100bec:	50                   	push   %eax
80100bed:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100bf3:	50                   	push   %eax
80100bf4:	ff 75 d8             	pushl  -0x28(%ebp)
80100bf7:	e8 29 12 00 00       	call   80101e25 <readi>
80100bfc:	83 c4 10             	add    $0x10,%esp
80100bff:	83 f8 20             	cmp    $0x20,%eax
80100c02:	74 05                	je     80100c09 <exec+0xc2>
      goto bad;
80100c04:	e9 ea 02 00 00       	jmp    80100ef3 <exec+0x3ac>
    if(ph.type != ELF_PROG_LOAD)
80100c09:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c0f:	83 f8 01             	cmp    $0x1,%eax
80100c12:	74 02                	je     80100c16 <exec+0xcf>
      continue;
80100c14:	eb 72                	jmp    80100c88 <exec+0x141>
    if(ph.memsz < ph.filesz)
80100c16:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c1c:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c22:	39 c2                	cmp    %eax,%edx
80100c24:	73 05                	jae    80100c2b <exec+0xe4>
      goto bad;
80100c26:	e9 c8 02 00 00       	jmp    80100ef3 <exec+0x3ac>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c2b:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c31:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c37:	01 d0                	add    %edx,%eax
80100c39:	83 ec 04             	sub    $0x4,%esp
80100c3c:	50                   	push   %eax
80100c3d:	ff 75 e0             	pushl  -0x20(%ebp)
80100c40:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c43:	e8 23 72 00 00       	call   80107e6b <allocuvm>
80100c48:	83 c4 10             	add    $0x10,%esp
80100c4b:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c4e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c52:	75 05                	jne    80100c59 <exec+0x112>
      goto bad;
80100c54:	e9 9a 02 00 00       	jmp    80100ef3 <exec+0x3ac>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c59:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100c5f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c65:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c6b:	83 ec 0c             	sub    $0xc,%esp
80100c6e:	51                   	push   %ecx
80100c6f:	52                   	push   %edx
80100c70:	ff 75 d8             	pushl  -0x28(%ebp)
80100c73:	50                   	push   %eax
80100c74:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c77:	e8 18 71 00 00       	call   80107d94 <loaduvm>
80100c7c:	83 c4 20             	add    $0x20,%esp
80100c7f:	85 c0                	test   %eax,%eax
80100c81:	79 05                	jns    80100c88 <exec+0x141>
      goto bad;
80100c83:	e9 6b 02 00 00       	jmp    80100ef3 <exec+0x3ac>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c88:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100c8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c8f:	83 c0 20             	add    $0x20,%eax
80100c92:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c95:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100c9c:	0f b7 c0             	movzwl %ax,%eax
80100c9f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100ca2:	0f 8f 3f ff ff ff    	jg     80100be7 <exec+0xa0>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100ca8:	83 ec 0c             	sub    $0xc,%esp
80100cab:	ff 75 d8             	pushl  -0x28(%ebp)
80100cae:	e8 c7 0e 00 00       	call   80101b7a <iunlockput>
80100cb3:	83 c4 10             	add    $0x10,%esp
  ip = 0;
80100cb6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100cbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cc0:	05 ff 0f 00 00       	add    $0xfff,%eax
80100cc5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100cca:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ccd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cd0:	05 00 20 00 00       	add    $0x2000,%eax
80100cd5:	83 ec 04             	sub    $0x4,%esp
80100cd8:	50                   	push   %eax
80100cd9:	ff 75 e0             	pushl  -0x20(%ebp)
80100cdc:	ff 75 d4             	pushl  -0x2c(%ebp)
80100cdf:	e8 87 71 00 00       	call   80107e6b <allocuvm>
80100ce4:	83 c4 10             	add    $0x10,%esp
80100ce7:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100cee:	75 05                	jne    80100cf5 <exec+0x1ae>
    goto bad;
80100cf0:	e9 fe 01 00 00       	jmp    80100ef3 <exec+0x3ac>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cf5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cf8:	2d 00 20 00 00       	sub    $0x2000,%eax
80100cfd:	83 ec 08             	sub    $0x8,%esp
80100d00:	50                   	push   %eax
80100d01:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d04:	e8 85 73 00 00       	call   8010808e <clearpteu>
80100d09:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100d0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d0f:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d12:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d19:	e9 98 00 00 00       	jmp    80100db6 <exec+0x26f>
    if(argc >= MAXARG)
80100d1e:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d22:	76 05                	jbe    80100d29 <exec+0x1e2>
      goto bad;
80100d24:	e9 ca 01 00 00       	jmp    80100ef3 <exec+0x3ac>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d2c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d33:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d36:	01 d0                	add    %edx,%eax
80100d38:	8b 00                	mov    (%eax),%eax
80100d3a:	83 ec 0c             	sub    $0xc,%esp
80100d3d:	50                   	push   %eax
80100d3e:	e8 5e 42 00 00       	call   80104fa1 <strlen>
80100d43:	83 c4 10             	add    $0x10,%esp
80100d46:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100d49:	29 c2                	sub    %eax,%edx
80100d4b:	89 d0                	mov    %edx,%eax
80100d4d:	83 e8 01             	sub    $0x1,%eax
80100d50:	83 e0 fc             	and    $0xfffffffc,%eax
80100d53:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d59:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d60:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d63:	01 d0                	add    %edx,%eax
80100d65:	8b 00                	mov    (%eax),%eax
80100d67:	83 ec 0c             	sub    $0xc,%esp
80100d6a:	50                   	push   %eax
80100d6b:	e8 31 42 00 00       	call   80104fa1 <strlen>
80100d70:	83 c4 10             	add    $0x10,%esp
80100d73:	83 c0 01             	add    $0x1,%eax
80100d76:	89 c2                	mov    %eax,%edx
80100d78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d7b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100d82:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d85:	01 c8                	add    %ecx,%eax
80100d87:	8b 00                	mov    (%eax),%eax
80100d89:	52                   	push   %edx
80100d8a:	50                   	push   %eax
80100d8b:	ff 75 dc             	pushl  -0x24(%ebp)
80100d8e:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d91:	e8 ac 74 00 00       	call   80108242 <copyout>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	85 c0                	test   %eax,%eax
80100d9b:	79 05                	jns    80100da2 <exec+0x25b>
      goto bad;
80100d9d:	e9 51 01 00 00       	jmp    80100ef3 <exec+0x3ac>
    ustack[3+argc] = sp;
80100da2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100da5:	8d 50 03             	lea    0x3(%eax),%edx
80100da8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dab:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100db2:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100db6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100db9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dc3:	01 d0                	add    %edx,%eax
80100dc5:	8b 00                	mov    (%eax),%eax
80100dc7:	85 c0                	test   %eax,%eax
80100dc9:	0f 85 4f ff ff ff    	jne    80100d1e <exec+0x1d7>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100dcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd2:	83 c0 03             	add    $0x3,%eax
80100dd5:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100ddc:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100de0:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100de7:	ff ff ff 
  ustack[1] = argc;
80100dea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ded:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100df3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100df6:	83 c0 01             	add    $0x1,%eax
80100df9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e00:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e03:	29 d0                	sub    %edx,%eax
80100e05:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100e0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e0e:	83 c0 04             	add    $0x4,%eax
80100e11:	c1 e0 02             	shl    $0x2,%eax
80100e14:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e1a:	83 c0 04             	add    $0x4,%eax
80100e1d:	c1 e0 02             	shl    $0x2,%eax
80100e20:	50                   	push   %eax
80100e21:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e27:	50                   	push   %eax
80100e28:	ff 75 dc             	pushl  -0x24(%ebp)
80100e2b:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e2e:	e8 0f 74 00 00       	call   80108242 <copyout>
80100e33:	83 c4 10             	add    $0x10,%esp
80100e36:	85 c0                	test   %eax,%eax
80100e38:	79 05                	jns    80100e3f <exec+0x2f8>
    goto bad;
80100e3a:	e9 b4 00 00 00       	jmp    80100ef3 <exec+0x3ac>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100e42:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e48:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e4b:	eb 17                	jmp    80100e64 <exec+0x31d>
    if(*s == '/')
80100e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e50:	0f b6 00             	movzbl (%eax),%eax
80100e53:	3c 2f                	cmp    $0x2f,%al
80100e55:	75 09                	jne    80100e60 <exec+0x319>
      last = s+1;
80100e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e5a:	83 c0 01             	add    $0x1,%eax
80100e5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e60:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e67:	0f b6 00             	movzbl (%eax),%eax
80100e6a:	84 c0                	test   %al,%al
80100e6c:	75 df                	jne    80100e4d <exec+0x306>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e6e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e74:	83 c0 6c             	add    $0x6c,%eax
80100e77:	83 ec 04             	sub    $0x4,%esp
80100e7a:	6a 10                	push   $0x10
80100e7c:	ff 75 f0             	pushl  -0x10(%ebp)
80100e7f:	50                   	push   %eax
80100e80:	e8 d2 40 00 00       	call   80104f57 <safestrcpy>
80100e85:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e88:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e8e:	8b 40 04             	mov    0x4(%eax),%eax
80100e91:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100e94:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e9a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100e9d:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100ea0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea6:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100ea9:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100eab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eb1:	8b 40 18             	mov    0x18(%eax),%eax
80100eb4:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100eba:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100ebd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ec3:	8b 40 18             	mov    0x18(%eax),%eax
80100ec6:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100ec9:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100ecc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ed2:	83 ec 0c             	sub    $0xc,%esp
80100ed5:	50                   	push   %eax
80100ed6:	e8 d4 6c 00 00       	call   80107baf <switchuvm>
80100edb:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100ede:	83 ec 0c             	sub    $0xc,%esp
80100ee1:	ff 75 d0             	pushl  -0x30(%ebp)
80100ee4:	e8 06 71 00 00       	call   80107fef <freevm>
80100ee9:	83 c4 10             	add    $0x10,%esp
  return 0;
80100eec:	b8 00 00 00 00       	mov    $0x0,%eax
80100ef1:	eb 2d                	jmp    80100f20 <exec+0x3d9>

 bad:
  if(pgdir)
80100ef3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100ef7:	74 0e                	je     80100f07 <exec+0x3c0>
    freevm(pgdir);
80100ef9:	83 ec 0c             	sub    $0xc,%esp
80100efc:	ff 75 d4             	pushl  -0x2c(%ebp)
80100eff:	e8 eb 70 00 00       	call   80107fef <freevm>
80100f04:	83 c4 10             	add    $0x10,%esp
  if(ip)
80100f07:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f0b:	74 0e                	je     80100f1b <exec+0x3d4>
    iunlockput(ip);
80100f0d:	83 ec 0c             	sub    $0xc,%esp
80100f10:	ff 75 d8             	pushl  -0x28(%ebp)
80100f13:	e8 62 0c 00 00       	call   80101b7a <iunlockput>
80100f18:	83 c4 10             	add    $0x10,%esp
  return -1;
80100f1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f20:	c9                   	leave  
80100f21:	c3                   	ret    

80100f22 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f22:	55                   	push   %ebp
80100f23:	89 e5                	mov    %esp,%ebp
80100f25:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100f28:	83 ec 08             	sub    $0x8,%esp
80100f2b:	68 39 83 10 80       	push   $0x80108339
80100f30:	68 80 de 10 80       	push   $0x8010de80
80100f35:	e8 9b 3b 00 00       	call   80104ad5 <initlock>
80100f3a:	83 c4 10             	add    $0x10,%esp
}
80100f3d:	c9                   	leave  
80100f3e:	c3                   	ret    

80100f3f <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f3f:	55                   	push   %ebp
80100f40:	89 e5                	mov    %esp,%ebp
80100f42:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f45:	83 ec 0c             	sub    $0xc,%esp
80100f48:	68 80 de 10 80       	push   $0x8010de80
80100f4d:	e8 a4 3b 00 00       	call   80104af6 <acquire>
80100f52:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f55:	c7 45 f4 b4 de 10 80 	movl   $0x8010deb4,-0xc(%ebp)
80100f5c:	eb 2d                	jmp    80100f8b <filealloc+0x4c>
    if(f->ref == 0){
80100f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f61:	8b 40 04             	mov    0x4(%eax),%eax
80100f64:	85 c0                	test   %eax,%eax
80100f66:	75 1f                	jne    80100f87 <filealloc+0x48>
      f->ref = 1;
80100f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f6b:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f72:	83 ec 0c             	sub    $0xc,%esp
80100f75:	68 80 de 10 80       	push   $0x8010de80
80100f7a:	e8 dd 3b 00 00       	call   80104b5c <release>
80100f7f:	83 c4 10             	add    $0x10,%esp
      return f;
80100f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f85:	eb 22                	jmp    80100fa9 <filealloc+0x6a>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f87:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f8b:	81 7d f4 14 e8 10 80 	cmpl   $0x8010e814,-0xc(%ebp)
80100f92:	72 ca                	jb     80100f5e <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f94:	83 ec 0c             	sub    $0xc,%esp
80100f97:	68 80 de 10 80       	push   $0x8010de80
80100f9c:	e8 bb 3b 00 00       	call   80104b5c <release>
80100fa1:	83 c4 10             	add    $0x10,%esp
  return 0;
80100fa4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100fa9:	c9                   	leave  
80100faa:	c3                   	ret    

80100fab <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fab:	55                   	push   %ebp
80100fac:	89 e5                	mov    %esp,%ebp
80100fae:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80100fb1:	83 ec 0c             	sub    $0xc,%esp
80100fb4:	68 80 de 10 80       	push   $0x8010de80
80100fb9:	e8 38 3b 00 00       	call   80104af6 <acquire>
80100fbe:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80100fc1:	8b 45 08             	mov    0x8(%ebp),%eax
80100fc4:	8b 40 04             	mov    0x4(%eax),%eax
80100fc7:	85 c0                	test   %eax,%eax
80100fc9:	7f 0d                	jg     80100fd8 <filedup+0x2d>
    panic("filedup");
80100fcb:	83 ec 0c             	sub    $0xc,%esp
80100fce:	68 40 83 10 80       	push   $0x80108340
80100fd3:	e8 84 f5 ff ff       	call   8010055c <panic>
  f->ref++;
80100fd8:	8b 45 08             	mov    0x8(%ebp),%eax
80100fdb:	8b 40 04             	mov    0x4(%eax),%eax
80100fde:	8d 50 01             	lea    0x1(%eax),%edx
80100fe1:	8b 45 08             	mov    0x8(%ebp),%eax
80100fe4:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fe7:	83 ec 0c             	sub    $0xc,%esp
80100fea:	68 80 de 10 80       	push   $0x8010de80
80100fef:	e8 68 3b 00 00       	call   80104b5c <release>
80100ff4:	83 c4 10             	add    $0x10,%esp
  return f;
80100ff7:	8b 45 08             	mov    0x8(%ebp),%eax
}
80100ffa:	c9                   	leave  
80100ffb:	c3                   	ret    

80100ffc <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ffc:	55                   	push   %ebp
80100ffd:	89 e5                	mov    %esp,%ebp
80100fff:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
80101002:	83 ec 0c             	sub    $0xc,%esp
80101005:	68 80 de 10 80       	push   $0x8010de80
8010100a:	e8 e7 3a 00 00       	call   80104af6 <acquire>
8010100f:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101012:	8b 45 08             	mov    0x8(%ebp),%eax
80101015:	8b 40 04             	mov    0x4(%eax),%eax
80101018:	85 c0                	test   %eax,%eax
8010101a:	7f 0d                	jg     80101029 <fileclose+0x2d>
    panic("fileclose");
8010101c:	83 ec 0c             	sub    $0xc,%esp
8010101f:	68 48 83 10 80       	push   $0x80108348
80101024:	e8 33 f5 ff ff       	call   8010055c <panic>
  if(--f->ref > 0){
80101029:	8b 45 08             	mov    0x8(%ebp),%eax
8010102c:	8b 40 04             	mov    0x4(%eax),%eax
8010102f:	8d 50 ff             	lea    -0x1(%eax),%edx
80101032:	8b 45 08             	mov    0x8(%ebp),%eax
80101035:	89 50 04             	mov    %edx,0x4(%eax)
80101038:	8b 45 08             	mov    0x8(%ebp),%eax
8010103b:	8b 40 04             	mov    0x4(%eax),%eax
8010103e:	85 c0                	test   %eax,%eax
80101040:	7e 15                	jle    80101057 <fileclose+0x5b>
    release(&ftable.lock);
80101042:	83 ec 0c             	sub    $0xc,%esp
80101045:	68 80 de 10 80       	push   $0x8010de80
8010104a:	e8 0d 3b 00 00       	call   80104b5c <release>
8010104f:	83 c4 10             	add    $0x10,%esp
80101052:	e9 8b 00 00 00       	jmp    801010e2 <fileclose+0xe6>
    return;
  }
  ff = *f;
80101057:	8b 45 08             	mov    0x8(%ebp),%eax
8010105a:	8b 10                	mov    (%eax),%edx
8010105c:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010105f:	8b 50 04             	mov    0x4(%eax),%edx
80101062:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101065:	8b 50 08             	mov    0x8(%eax),%edx
80101068:	89 55 e8             	mov    %edx,-0x18(%ebp)
8010106b:	8b 50 0c             	mov    0xc(%eax),%edx
8010106e:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101071:	8b 50 10             	mov    0x10(%eax),%edx
80101074:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101077:	8b 40 14             	mov    0x14(%eax),%eax
8010107a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
8010107d:	8b 45 08             	mov    0x8(%ebp),%eax
80101080:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101087:	8b 45 08             	mov    0x8(%ebp),%eax
8010108a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101090:	83 ec 0c             	sub    $0xc,%esp
80101093:	68 80 de 10 80       	push   $0x8010de80
80101098:	e8 bf 3a 00 00       	call   80104b5c <release>
8010109d:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
801010a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010a3:	83 f8 01             	cmp    $0x1,%eax
801010a6:	75 19                	jne    801010c1 <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
801010a8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
801010ac:	0f be d0             	movsbl %al,%edx
801010af:	8b 45 ec             	mov    -0x14(%ebp),%eax
801010b2:	83 ec 08             	sub    $0x8,%esp
801010b5:	52                   	push   %edx
801010b6:	50                   	push   %eax
801010b7:	e8 29 2c 00 00       	call   80103ce5 <pipeclose>
801010bc:	83 c4 10             	add    $0x10,%esp
801010bf:	eb 21                	jmp    801010e2 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
801010c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010c4:	83 f8 02             	cmp    $0x2,%eax
801010c7:	75 19                	jne    801010e2 <fileclose+0xe6>
    begin_trans();
801010c9:	e8 59 21 00 00       	call   80103227 <begin_trans>
    iput(ff.ip);
801010ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801010d1:	83 ec 0c             	sub    $0xc,%esp
801010d4:	50                   	push   %eax
801010d5:	e8 b1 09 00 00       	call   80101a8b <iput>
801010da:	83 c4 10             	add    $0x10,%esp
    commit_trans();
801010dd:	e8 97 21 00 00       	call   80103279 <commit_trans>
  }
}
801010e2:	c9                   	leave  
801010e3:	c3                   	ret    

801010e4 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010e4:	55                   	push   %ebp
801010e5:	89 e5                	mov    %esp,%ebp
801010e7:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
801010ea:	8b 45 08             	mov    0x8(%ebp),%eax
801010ed:	8b 00                	mov    (%eax),%eax
801010ef:	83 f8 02             	cmp    $0x2,%eax
801010f2:	75 40                	jne    80101134 <filestat+0x50>
    ilock(f->ip);
801010f4:	8b 45 08             	mov    0x8(%ebp),%eax
801010f7:	8b 40 10             	mov    0x10(%eax),%eax
801010fa:	83 ec 0c             	sub    $0xc,%esp
801010fd:	50                   	push   %eax
801010fe:	e8 c0 07 00 00       	call   801018c3 <ilock>
80101103:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
80101106:	8b 45 08             	mov    0x8(%ebp),%eax
80101109:	8b 40 10             	mov    0x10(%eax),%eax
8010110c:	83 ec 08             	sub    $0x8,%esp
8010110f:	ff 75 0c             	pushl  0xc(%ebp)
80101112:	50                   	push   %eax
80101113:	e8 c8 0c 00 00       	call   80101de0 <stati>
80101118:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
8010111b:	8b 45 08             	mov    0x8(%ebp),%eax
8010111e:	8b 40 10             	mov    0x10(%eax),%eax
80101121:	83 ec 0c             	sub    $0xc,%esp
80101124:	50                   	push   %eax
80101125:	e8 f0 08 00 00       	call   80101a1a <iunlock>
8010112a:	83 c4 10             	add    $0x10,%esp
    return 0;
8010112d:	b8 00 00 00 00       	mov    $0x0,%eax
80101132:	eb 05                	jmp    80101139 <filestat+0x55>
  }
  return -1;
80101134:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101139:	c9                   	leave  
8010113a:	c3                   	ret    

8010113b <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
8010113b:	55                   	push   %ebp
8010113c:	89 e5                	mov    %esp,%ebp
8010113e:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
80101141:	8b 45 08             	mov    0x8(%ebp),%eax
80101144:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101148:	84 c0                	test   %al,%al
8010114a:	75 0a                	jne    80101156 <fileread+0x1b>
    return -1;
8010114c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101151:	e9 9b 00 00 00       	jmp    801011f1 <fileread+0xb6>
  if(f->type == FD_PIPE)
80101156:	8b 45 08             	mov    0x8(%ebp),%eax
80101159:	8b 00                	mov    (%eax),%eax
8010115b:	83 f8 01             	cmp    $0x1,%eax
8010115e:	75 1a                	jne    8010117a <fileread+0x3f>
    return piperead(f->pipe, addr, n);
80101160:	8b 45 08             	mov    0x8(%ebp),%eax
80101163:	8b 40 0c             	mov    0xc(%eax),%eax
80101166:	83 ec 04             	sub    $0x4,%esp
80101169:	ff 75 10             	pushl  0x10(%ebp)
8010116c:	ff 75 0c             	pushl  0xc(%ebp)
8010116f:	50                   	push   %eax
80101170:	e8 1d 2d 00 00       	call   80103e92 <piperead>
80101175:	83 c4 10             	add    $0x10,%esp
80101178:	eb 77                	jmp    801011f1 <fileread+0xb6>
  if(f->type == FD_INODE){
8010117a:	8b 45 08             	mov    0x8(%ebp),%eax
8010117d:	8b 00                	mov    (%eax),%eax
8010117f:	83 f8 02             	cmp    $0x2,%eax
80101182:	75 60                	jne    801011e4 <fileread+0xa9>
    ilock(f->ip);
80101184:	8b 45 08             	mov    0x8(%ebp),%eax
80101187:	8b 40 10             	mov    0x10(%eax),%eax
8010118a:	83 ec 0c             	sub    $0xc,%esp
8010118d:	50                   	push   %eax
8010118e:	e8 30 07 00 00       	call   801018c3 <ilock>
80101193:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101196:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101199:	8b 45 08             	mov    0x8(%ebp),%eax
8010119c:	8b 50 14             	mov    0x14(%eax),%edx
8010119f:	8b 45 08             	mov    0x8(%ebp),%eax
801011a2:	8b 40 10             	mov    0x10(%eax),%eax
801011a5:	51                   	push   %ecx
801011a6:	52                   	push   %edx
801011a7:	ff 75 0c             	pushl  0xc(%ebp)
801011aa:	50                   	push   %eax
801011ab:	e8 75 0c 00 00       	call   80101e25 <readi>
801011b0:	83 c4 10             	add    $0x10,%esp
801011b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801011b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801011ba:	7e 11                	jle    801011cd <fileread+0x92>
      f->off += r;
801011bc:	8b 45 08             	mov    0x8(%ebp),%eax
801011bf:	8b 50 14             	mov    0x14(%eax),%edx
801011c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011c5:	01 c2                	add    %eax,%edx
801011c7:	8b 45 08             	mov    0x8(%ebp),%eax
801011ca:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801011cd:	8b 45 08             	mov    0x8(%ebp),%eax
801011d0:	8b 40 10             	mov    0x10(%eax),%eax
801011d3:	83 ec 0c             	sub    $0xc,%esp
801011d6:	50                   	push   %eax
801011d7:	e8 3e 08 00 00       	call   80101a1a <iunlock>
801011dc:	83 c4 10             	add    $0x10,%esp
    return r;
801011df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011e2:	eb 0d                	jmp    801011f1 <fileread+0xb6>
  }
  panic("fileread");
801011e4:	83 ec 0c             	sub    $0xc,%esp
801011e7:	68 52 83 10 80       	push   $0x80108352
801011ec:	e8 6b f3 ff ff       	call   8010055c <panic>
}
801011f1:	c9                   	leave  
801011f2:	c3                   	ret    

801011f3 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011f3:	55                   	push   %ebp
801011f4:	89 e5                	mov    %esp,%ebp
801011f6:	53                   	push   %ebx
801011f7:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
801011fa:	8b 45 08             	mov    0x8(%ebp),%eax
801011fd:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80101201:	84 c0                	test   %al,%al
80101203:	75 0a                	jne    8010120f <filewrite+0x1c>
    return -1;
80101205:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010120a:	e9 1a 01 00 00       	jmp    80101329 <filewrite+0x136>
  if(f->type == FD_PIPE)
8010120f:	8b 45 08             	mov    0x8(%ebp),%eax
80101212:	8b 00                	mov    (%eax),%eax
80101214:	83 f8 01             	cmp    $0x1,%eax
80101217:	75 1d                	jne    80101236 <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
80101219:	8b 45 08             	mov    0x8(%ebp),%eax
8010121c:	8b 40 0c             	mov    0xc(%eax),%eax
8010121f:	83 ec 04             	sub    $0x4,%esp
80101222:	ff 75 10             	pushl  0x10(%ebp)
80101225:	ff 75 0c             	pushl  0xc(%ebp)
80101228:	50                   	push   %eax
80101229:	e8 60 2b 00 00       	call   80103d8e <pipewrite>
8010122e:	83 c4 10             	add    $0x10,%esp
80101231:	e9 f3 00 00 00       	jmp    80101329 <filewrite+0x136>
  if(f->type == FD_INODE){
80101236:	8b 45 08             	mov    0x8(%ebp),%eax
80101239:	8b 00                	mov    (%eax),%eax
8010123b:	83 f8 02             	cmp    $0x2,%eax
8010123e:	0f 85 d8 00 00 00    	jne    8010131c <filewrite+0x129>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101244:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
8010124b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101252:	e9 a5 00 00 00       	jmp    801012fc <filewrite+0x109>
      int n1 = n - i;
80101257:	8b 45 10             	mov    0x10(%ebp),%eax
8010125a:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010125d:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101260:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101263:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101266:	7e 06                	jle    8010126e <filewrite+0x7b>
        n1 = max;
80101268:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010126b:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_trans();
8010126e:	e8 b4 1f 00 00       	call   80103227 <begin_trans>
      ilock(f->ip);
80101273:	8b 45 08             	mov    0x8(%ebp),%eax
80101276:	8b 40 10             	mov    0x10(%eax),%eax
80101279:	83 ec 0c             	sub    $0xc,%esp
8010127c:	50                   	push   %eax
8010127d:	e8 41 06 00 00       	call   801018c3 <ilock>
80101282:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101285:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101288:	8b 45 08             	mov    0x8(%ebp),%eax
8010128b:	8b 50 14             	mov    0x14(%eax),%edx
8010128e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101291:	8b 45 0c             	mov    0xc(%ebp),%eax
80101294:	01 c3                	add    %eax,%ebx
80101296:	8b 45 08             	mov    0x8(%ebp),%eax
80101299:	8b 40 10             	mov    0x10(%eax),%eax
8010129c:	51                   	push   %ecx
8010129d:	52                   	push   %edx
8010129e:	53                   	push   %ebx
8010129f:	50                   	push   %eax
801012a0:	e8 dc 0c 00 00       	call   80101f81 <writei>
801012a5:	83 c4 10             	add    $0x10,%esp
801012a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
801012ab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012af:	7e 11                	jle    801012c2 <filewrite+0xcf>
        f->off += r;
801012b1:	8b 45 08             	mov    0x8(%ebp),%eax
801012b4:	8b 50 14             	mov    0x14(%eax),%edx
801012b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012ba:	01 c2                	add    %eax,%edx
801012bc:	8b 45 08             	mov    0x8(%ebp),%eax
801012bf:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801012c2:	8b 45 08             	mov    0x8(%ebp),%eax
801012c5:	8b 40 10             	mov    0x10(%eax),%eax
801012c8:	83 ec 0c             	sub    $0xc,%esp
801012cb:	50                   	push   %eax
801012cc:	e8 49 07 00 00       	call   80101a1a <iunlock>
801012d1:	83 c4 10             	add    $0x10,%esp
      commit_trans();
801012d4:	e8 a0 1f 00 00       	call   80103279 <commit_trans>

      if(r < 0)
801012d9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012dd:	79 02                	jns    801012e1 <filewrite+0xee>
        break;
801012df:	eb 27                	jmp    80101308 <filewrite+0x115>
      if(r != n1)
801012e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012e4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801012e7:	74 0d                	je     801012f6 <filewrite+0x103>
        panic("short filewrite");
801012e9:	83 ec 0c             	sub    $0xc,%esp
801012ec:	68 5b 83 10 80       	push   $0x8010835b
801012f1:	e8 66 f2 ff ff       	call   8010055c <panic>
      i += r;
801012f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012f9:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012ff:	3b 45 10             	cmp    0x10(%ebp),%eax
80101302:	0f 8c 4f ff ff ff    	jl     80101257 <filewrite+0x64>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101308:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010130b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010130e:	75 05                	jne    80101315 <filewrite+0x122>
80101310:	8b 45 10             	mov    0x10(%ebp),%eax
80101313:	eb 14                	jmp    80101329 <filewrite+0x136>
80101315:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010131a:	eb 0d                	jmp    80101329 <filewrite+0x136>
  }
  panic("filewrite");
8010131c:	83 ec 0c             	sub    $0xc,%esp
8010131f:	68 6b 83 10 80       	push   $0x8010836b
80101324:	e8 33 f2 ff ff       	call   8010055c <panic>
}
80101329:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010132c:	c9                   	leave  
8010132d:	c3                   	ret    

8010132e <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
8010132e:	55                   	push   %ebp
8010132f:	89 e5                	mov    %esp,%ebp
80101331:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101334:	8b 45 08             	mov    0x8(%ebp),%eax
80101337:	83 ec 08             	sub    $0x8,%esp
8010133a:	6a 01                	push   $0x1
8010133c:	50                   	push   %eax
8010133d:	e8 72 ee ff ff       	call   801001b4 <bread>
80101342:	83 c4 10             	add    $0x10,%esp
80101345:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101348:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010134b:	83 c0 18             	add    $0x18,%eax
8010134e:	83 ec 04             	sub    $0x4,%esp
80101351:	6a 10                	push   $0x10
80101353:	50                   	push   %eax
80101354:	ff 75 0c             	pushl  0xc(%ebp)
80101357:	e8 b5 3a 00 00       	call   80104e11 <memmove>
8010135c:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010135f:	83 ec 0c             	sub    $0xc,%esp
80101362:	ff 75 f4             	pushl  -0xc(%ebp)
80101365:	e8 c1 ee ff ff       	call   8010022b <brelse>
8010136a:	83 c4 10             	add    $0x10,%esp
}
8010136d:	c9                   	leave  
8010136e:	c3                   	ret    

8010136f <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010136f:	55                   	push   %ebp
80101370:	89 e5                	mov    %esp,%ebp
80101372:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101375:	8b 55 0c             	mov    0xc(%ebp),%edx
80101378:	8b 45 08             	mov    0x8(%ebp),%eax
8010137b:	83 ec 08             	sub    $0x8,%esp
8010137e:	52                   	push   %edx
8010137f:	50                   	push   %eax
80101380:	e8 2f ee ff ff       	call   801001b4 <bread>
80101385:	83 c4 10             	add    $0x10,%esp
80101388:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
8010138b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010138e:	83 c0 18             	add    $0x18,%eax
80101391:	83 ec 04             	sub    $0x4,%esp
80101394:	68 00 02 00 00       	push   $0x200
80101399:	6a 00                	push   $0x0
8010139b:	50                   	push   %eax
8010139c:	e8 b1 39 00 00       	call   80104d52 <memset>
801013a1:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801013a4:	83 ec 0c             	sub    $0xc,%esp
801013a7:	ff 75 f4             	pushl  -0xc(%ebp)
801013aa:	e8 2e 1f 00 00       	call   801032dd <log_write>
801013af:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801013b2:	83 ec 0c             	sub    $0xc,%esp
801013b5:	ff 75 f4             	pushl  -0xc(%ebp)
801013b8:	e8 6e ee ff ff       	call   8010022b <brelse>
801013bd:	83 c4 10             	add    $0x10,%esp
}
801013c0:	c9                   	leave  
801013c1:	c3                   	ret    

801013c2 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013c2:	55                   	push   %ebp
801013c3:	89 e5                	mov    %esp,%ebp
801013c5:	83 ec 28             	sub    $0x28,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
801013c8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
801013cf:	8b 45 08             	mov    0x8(%ebp),%eax
801013d2:	83 ec 08             	sub    $0x8,%esp
801013d5:	8d 55 d8             	lea    -0x28(%ebp),%edx
801013d8:	52                   	push   %edx
801013d9:	50                   	push   %eax
801013da:	e8 4f ff ff ff       	call   8010132e <readsb>
801013df:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
801013e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801013e9:	e9 11 01 00 00       	jmp    801014ff <balloc+0x13d>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
801013ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013f1:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801013f7:	85 c0                	test   %eax,%eax
801013f9:	0f 48 c2             	cmovs  %edx,%eax
801013fc:	c1 f8 0c             	sar    $0xc,%eax
801013ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101402:	c1 ea 03             	shr    $0x3,%edx
80101405:	01 d0                	add    %edx,%eax
80101407:	83 c0 03             	add    $0x3,%eax
8010140a:	83 ec 08             	sub    $0x8,%esp
8010140d:	50                   	push   %eax
8010140e:	ff 75 08             	pushl  0x8(%ebp)
80101411:	e8 9e ed ff ff       	call   801001b4 <bread>
80101416:	83 c4 10             	add    $0x10,%esp
80101419:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010141c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101423:	e9 a4 00 00 00       	jmp    801014cc <balloc+0x10a>
      m = 1 << (bi % 8);
80101428:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010142b:	99                   	cltd   
8010142c:	c1 ea 1d             	shr    $0x1d,%edx
8010142f:	01 d0                	add    %edx,%eax
80101431:	83 e0 07             	and    $0x7,%eax
80101434:	29 d0                	sub    %edx,%eax
80101436:	ba 01 00 00 00       	mov    $0x1,%edx
8010143b:	89 c1                	mov    %eax,%ecx
8010143d:	d3 e2                	shl    %cl,%edx
8010143f:	89 d0                	mov    %edx,%eax
80101441:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101444:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101447:	8d 50 07             	lea    0x7(%eax),%edx
8010144a:	85 c0                	test   %eax,%eax
8010144c:	0f 48 c2             	cmovs  %edx,%eax
8010144f:	c1 f8 03             	sar    $0x3,%eax
80101452:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101455:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
8010145a:	0f b6 c0             	movzbl %al,%eax
8010145d:	23 45 e8             	and    -0x18(%ebp),%eax
80101460:	85 c0                	test   %eax,%eax
80101462:	75 64                	jne    801014c8 <balloc+0x106>
        bp->data[bi/8] |= m;  // Mark block in use.
80101464:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101467:	8d 50 07             	lea    0x7(%eax),%edx
8010146a:	85 c0                	test   %eax,%eax
8010146c:	0f 48 c2             	cmovs  %edx,%eax
8010146f:	c1 f8 03             	sar    $0x3,%eax
80101472:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101475:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010147a:	89 d1                	mov    %edx,%ecx
8010147c:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010147f:	09 ca                	or     %ecx,%edx
80101481:	89 d1                	mov    %edx,%ecx
80101483:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101486:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
8010148a:	83 ec 0c             	sub    $0xc,%esp
8010148d:	ff 75 ec             	pushl  -0x14(%ebp)
80101490:	e8 48 1e 00 00       	call   801032dd <log_write>
80101495:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
80101498:	83 ec 0c             	sub    $0xc,%esp
8010149b:	ff 75 ec             	pushl  -0x14(%ebp)
8010149e:	e8 88 ed ff ff       	call   8010022b <brelse>
801014a3:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
801014a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014ac:	01 c2                	add    %eax,%edx
801014ae:	8b 45 08             	mov    0x8(%ebp),%eax
801014b1:	83 ec 08             	sub    $0x8,%esp
801014b4:	52                   	push   %edx
801014b5:	50                   	push   %eax
801014b6:	e8 b4 fe ff ff       	call   8010136f <bzero>
801014bb:	83 c4 10             	add    $0x10,%esp
        return b + bi;
801014be:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014c4:	01 d0                	add    %edx,%eax
801014c6:	eb 52                	jmp    8010151a <balloc+0x158>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014c8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801014cc:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801014d3:	7f 15                	jg     801014ea <balloc+0x128>
801014d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014db:	01 d0                	add    %edx,%eax
801014dd:	89 c2                	mov    %eax,%edx
801014df:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014e2:	39 c2                	cmp    %eax,%edx
801014e4:	0f 82 3e ff ff ff    	jb     80101428 <balloc+0x66>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014ea:	83 ec 0c             	sub    $0xc,%esp
801014ed:	ff 75 ec             	pushl  -0x14(%ebp)
801014f0:	e8 36 ed ff ff       	call   8010022b <brelse>
801014f5:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
801014f8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801014ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101502:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101505:	39 c2                	cmp    %eax,%edx
80101507:	0f 82 e1 fe ff ff    	jb     801013ee <balloc+0x2c>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010150d:	83 ec 0c             	sub    $0xc,%esp
80101510:	68 75 83 10 80       	push   $0x80108375
80101515:	e8 42 f0 ff ff       	call   8010055c <panic>
}
8010151a:	c9                   	leave  
8010151b:	c3                   	ret    

8010151c <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
8010151c:	55                   	push   %ebp
8010151d:	89 e5                	mov    %esp,%ebp
8010151f:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
80101522:	83 ec 08             	sub    $0x8,%esp
80101525:	8d 45 dc             	lea    -0x24(%ebp),%eax
80101528:	50                   	push   %eax
80101529:	ff 75 08             	pushl  0x8(%ebp)
8010152c:	e8 fd fd ff ff       	call   8010132e <readsb>
80101531:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb.ninodes));
80101534:	8b 45 0c             	mov    0xc(%ebp),%eax
80101537:	c1 e8 0c             	shr    $0xc,%eax
8010153a:	89 c2                	mov    %eax,%edx
8010153c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010153f:	c1 e8 03             	shr    $0x3,%eax
80101542:	01 d0                	add    %edx,%eax
80101544:	8d 50 03             	lea    0x3(%eax),%edx
80101547:	8b 45 08             	mov    0x8(%ebp),%eax
8010154a:	83 ec 08             	sub    $0x8,%esp
8010154d:	52                   	push   %edx
8010154e:	50                   	push   %eax
8010154f:	e8 60 ec ff ff       	call   801001b4 <bread>
80101554:	83 c4 10             	add    $0x10,%esp
80101557:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
8010155a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010155d:	25 ff 0f 00 00       	and    $0xfff,%eax
80101562:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101565:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101568:	99                   	cltd   
80101569:	c1 ea 1d             	shr    $0x1d,%edx
8010156c:	01 d0                	add    %edx,%eax
8010156e:	83 e0 07             	and    $0x7,%eax
80101571:	29 d0                	sub    %edx,%eax
80101573:	ba 01 00 00 00       	mov    $0x1,%edx
80101578:	89 c1                	mov    %eax,%ecx
8010157a:	d3 e2                	shl    %cl,%edx
8010157c:	89 d0                	mov    %edx,%eax
8010157e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101581:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101584:	8d 50 07             	lea    0x7(%eax),%edx
80101587:	85 c0                	test   %eax,%eax
80101589:	0f 48 c2             	cmovs  %edx,%eax
8010158c:	c1 f8 03             	sar    $0x3,%eax
8010158f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101592:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101597:	0f b6 c0             	movzbl %al,%eax
8010159a:	23 45 ec             	and    -0x14(%ebp),%eax
8010159d:	85 c0                	test   %eax,%eax
8010159f:	75 0d                	jne    801015ae <bfree+0x92>
    panic("freeing free block");
801015a1:	83 ec 0c             	sub    $0xc,%esp
801015a4:	68 8b 83 10 80       	push   $0x8010838b
801015a9:	e8 ae ef ff ff       	call   8010055c <panic>
  bp->data[bi/8] &= ~m;
801015ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015b1:	8d 50 07             	lea    0x7(%eax),%edx
801015b4:	85 c0                	test   %eax,%eax
801015b6:	0f 48 c2             	cmovs  %edx,%eax
801015b9:	c1 f8 03             	sar    $0x3,%eax
801015bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015bf:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801015c4:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801015c7:	f7 d1                	not    %ecx
801015c9:	21 ca                	and    %ecx,%edx
801015cb:	89 d1                	mov    %edx,%ecx
801015cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015d0:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
801015d4:	83 ec 0c             	sub    $0xc,%esp
801015d7:	ff 75 f4             	pushl  -0xc(%ebp)
801015da:	e8 fe 1c 00 00       	call   801032dd <log_write>
801015df:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801015e2:	83 ec 0c             	sub    $0xc,%esp
801015e5:	ff 75 f4             	pushl  -0xc(%ebp)
801015e8:	e8 3e ec ff ff       	call   8010022b <brelse>
801015ed:	83 c4 10             	add    $0x10,%esp
}
801015f0:	c9                   	leave  
801015f1:	c3                   	ret    

801015f2 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
801015f2:	55                   	push   %ebp
801015f3:	89 e5                	mov    %esp,%ebp
801015f5:	83 ec 08             	sub    $0x8,%esp
  initlock(&icache.lock, "icache");
801015f8:	83 ec 08             	sub    $0x8,%esp
801015fb:	68 9e 83 10 80       	push   $0x8010839e
80101600:	68 c0 e8 10 80       	push   $0x8010e8c0
80101605:	e8 cb 34 00 00       	call   80104ad5 <initlock>
8010160a:	83 c4 10             	add    $0x10,%esp
}
8010160d:	c9                   	leave  
8010160e:	c3                   	ret    

8010160f <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
8010160f:	55                   	push   %ebp
80101610:	89 e5                	mov    %esp,%ebp
80101612:	83 ec 38             	sub    $0x38,%esp
80101615:	8b 45 0c             	mov    0xc(%ebp),%eax
80101618:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
8010161c:	8b 45 08             	mov    0x8(%ebp),%eax
8010161f:	83 ec 08             	sub    $0x8,%esp
80101622:	8d 55 dc             	lea    -0x24(%ebp),%edx
80101625:	52                   	push   %edx
80101626:	50                   	push   %eax
80101627:	e8 02 fd ff ff       	call   8010132e <readsb>
8010162c:	83 c4 10             	add    $0x10,%esp

  for(inum = 1; inum < sb.ninodes; inum++){
8010162f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101636:	e9 98 00 00 00       	jmp    801016d3 <ialloc+0xc4>
    bp = bread(dev, IBLOCK(inum));
8010163b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010163e:	c1 e8 03             	shr    $0x3,%eax
80101641:	83 c0 02             	add    $0x2,%eax
80101644:	83 ec 08             	sub    $0x8,%esp
80101647:	50                   	push   %eax
80101648:	ff 75 08             	pushl  0x8(%ebp)
8010164b:	e8 64 eb ff ff       	call   801001b4 <bread>
80101650:	83 c4 10             	add    $0x10,%esp
80101653:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101656:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101659:	8d 50 18             	lea    0x18(%eax),%edx
8010165c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010165f:	83 e0 07             	and    $0x7,%eax
80101662:	c1 e0 06             	shl    $0x6,%eax
80101665:	01 d0                	add    %edx,%eax
80101667:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
8010166a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010166d:	0f b7 00             	movzwl (%eax),%eax
80101670:	66 85 c0             	test   %ax,%ax
80101673:	75 4c                	jne    801016c1 <ialloc+0xb2>
      memset(dip, 0, sizeof(*dip));
80101675:	83 ec 04             	sub    $0x4,%esp
80101678:	6a 40                	push   $0x40
8010167a:	6a 00                	push   $0x0
8010167c:	ff 75 ec             	pushl  -0x14(%ebp)
8010167f:	e8 ce 36 00 00       	call   80104d52 <memset>
80101684:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
80101687:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010168a:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
8010168e:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101691:	83 ec 0c             	sub    $0xc,%esp
80101694:	ff 75 f0             	pushl  -0x10(%ebp)
80101697:	e8 41 1c 00 00       	call   801032dd <log_write>
8010169c:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
8010169f:	83 ec 0c             	sub    $0xc,%esp
801016a2:	ff 75 f0             	pushl  -0x10(%ebp)
801016a5:	e8 81 eb ff ff       	call   8010022b <brelse>
801016aa:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801016ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016b0:	83 ec 08             	sub    $0x8,%esp
801016b3:	50                   	push   %eax
801016b4:	ff 75 08             	pushl  0x8(%ebp)
801016b7:	e8 ee 00 00 00       	call   801017aa <iget>
801016bc:	83 c4 10             	add    $0x10,%esp
801016bf:	eb 2d                	jmp    801016ee <ialloc+0xdf>
    }
    brelse(bp);
801016c1:	83 ec 0c             	sub    $0xc,%esp
801016c4:	ff 75 f0             	pushl  -0x10(%ebp)
801016c7:	e8 5f eb ff ff       	call   8010022b <brelse>
801016cc:	83 c4 10             	add    $0x10,%esp
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
801016cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801016d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801016d9:	39 c2                	cmp    %eax,%edx
801016db:	0f 82 5a ff ff ff    	jb     8010163b <ialloc+0x2c>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801016e1:	83 ec 0c             	sub    $0xc,%esp
801016e4:	68 a5 83 10 80       	push   $0x801083a5
801016e9:	e8 6e ee ff ff       	call   8010055c <panic>
}
801016ee:	c9                   	leave  
801016ef:	c3                   	ret    

801016f0 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
801016f6:	8b 45 08             	mov    0x8(%ebp),%eax
801016f9:	8b 40 04             	mov    0x4(%eax),%eax
801016fc:	c1 e8 03             	shr    $0x3,%eax
801016ff:	8d 50 02             	lea    0x2(%eax),%edx
80101702:	8b 45 08             	mov    0x8(%ebp),%eax
80101705:	8b 00                	mov    (%eax),%eax
80101707:	83 ec 08             	sub    $0x8,%esp
8010170a:	52                   	push   %edx
8010170b:	50                   	push   %eax
8010170c:	e8 a3 ea ff ff       	call   801001b4 <bread>
80101711:	83 c4 10             	add    $0x10,%esp
80101714:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101717:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010171a:	8d 50 18             	lea    0x18(%eax),%edx
8010171d:	8b 45 08             	mov    0x8(%ebp),%eax
80101720:	8b 40 04             	mov    0x4(%eax),%eax
80101723:	83 e0 07             	and    $0x7,%eax
80101726:	c1 e0 06             	shl    $0x6,%eax
80101729:	01 d0                	add    %edx,%eax
8010172b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
8010172e:	8b 45 08             	mov    0x8(%ebp),%eax
80101731:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101735:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101738:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010173b:	8b 45 08             	mov    0x8(%ebp),%eax
8010173e:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101742:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101745:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101749:	8b 45 08             	mov    0x8(%ebp),%eax
8010174c:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101750:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101753:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101757:	8b 45 08             	mov    0x8(%ebp),%eax
8010175a:	0f b7 50 16          	movzwl 0x16(%eax),%edx
8010175e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101761:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101765:	8b 45 08             	mov    0x8(%ebp),%eax
80101768:	8b 50 18             	mov    0x18(%eax),%edx
8010176b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010176e:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101771:	8b 45 08             	mov    0x8(%ebp),%eax
80101774:	8d 50 1c             	lea    0x1c(%eax),%edx
80101777:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010177a:	83 c0 0c             	add    $0xc,%eax
8010177d:	83 ec 04             	sub    $0x4,%esp
80101780:	6a 34                	push   $0x34
80101782:	52                   	push   %edx
80101783:	50                   	push   %eax
80101784:	e8 88 36 00 00       	call   80104e11 <memmove>
80101789:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
8010178c:	83 ec 0c             	sub    $0xc,%esp
8010178f:	ff 75 f4             	pushl  -0xc(%ebp)
80101792:	e8 46 1b 00 00       	call   801032dd <log_write>
80101797:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010179a:	83 ec 0c             	sub    $0xc,%esp
8010179d:	ff 75 f4             	pushl  -0xc(%ebp)
801017a0:	e8 86 ea ff ff       	call   8010022b <brelse>
801017a5:	83 c4 10             	add    $0x10,%esp
}
801017a8:	c9                   	leave  
801017a9:	c3                   	ret    

801017aa <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801017aa:	55                   	push   %ebp
801017ab:	89 e5                	mov    %esp,%ebp
801017ad:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801017b0:	83 ec 0c             	sub    $0xc,%esp
801017b3:	68 c0 e8 10 80       	push   $0x8010e8c0
801017b8:	e8 39 33 00 00       	call   80104af6 <acquire>
801017bd:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
801017c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017c7:	c7 45 f4 f4 e8 10 80 	movl   $0x8010e8f4,-0xc(%ebp)
801017ce:	eb 5d                	jmp    8010182d <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801017d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017d3:	8b 40 08             	mov    0x8(%eax),%eax
801017d6:	85 c0                	test   %eax,%eax
801017d8:	7e 39                	jle    80101813 <iget+0x69>
801017da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017dd:	8b 00                	mov    (%eax),%eax
801017df:	3b 45 08             	cmp    0x8(%ebp),%eax
801017e2:	75 2f                	jne    80101813 <iget+0x69>
801017e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017e7:	8b 40 04             	mov    0x4(%eax),%eax
801017ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
801017ed:	75 24                	jne    80101813 <iget+0x69>
      ip->ref++;
801017ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f2:	8b 40 08             	mov    0x8(%eax),%eax
801017f5:	8d 50 01             	lea    0x1(%eax),%edx
801017f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017fb:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801017fe:	83 ec 0c             	sub    $0xc,%esp
80101801:	68 c0 e8 10 80       	push   $0x8010e8c0
80101806:	e8 51 33 00 00       	call   80104b5c <release>
8010180b:	83 c4 10             	add    $0x10,%esp
      return ip;
8010180e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101811:	eb 74                	jmp    80101887 <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101813:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101817:	75 10                	jne    80101829 <iget+0x7f>
80101819:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010181c:	8b 40 08             	mov    0x8(%eax),%eax
8010181f:	85 c0                	test   %eax,%eax
80101821:	75 06                	jne    80101829 <iget+0x7f>
      empty = ip;
80101823:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101826:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101829:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
8010182d:	81 7d f4 94 f8 10 80 	cmpl   $0x8010f894,-0xc(%ebp)
80101834:	72 9a                	jb     801017d0 <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101836:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010183a:	75 0d                	jne    80101849 <iget+0x9f>
    panic("iget: no inodes");
8010183c:	83 ec 0c             	sub    $0xc,%esp
8010183f:	68 b7 83 10 80       	push   $0x801083b7
80101844:	e8 13 ed ff ff       	call   8010055c <panic>

  ip = empty;
80101849:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010184c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
8010184f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101852:	8b 55 08             	mov    0x8(%ebp),%edx
80101855:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101857:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010185a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010185d:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101860:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101863:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
8010186a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010186d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101874:	83 ec 0c             	sub    $0xc,%esp
80101877:	68 c0 e8 10 80       	push   $0x8010e8c0
8010187c:	e8 db 32 00 00       	call   80104b5c <release>
80101881:	83 c4 10             	add    $0x10,%esp

  return ip;
80101884:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101887:	c9                   	leave  
80101888:	c3                   	ret    

80101889 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101889:	55                   	push   %ebp
8010188a:	89 e5                	mov    %esp,%ebp
8010188c:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
8010188f:	83 ec 0c             	sub    $0xc,%esp
80101892:	68 c0 e8 10 80       	push   $0x8010e8c0
80101897:	e8 5a 32 00 00       	call   80104af6 <acquire>
8010189c:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
8010189f:	8b 45 08             	mov    0x8(%ebp),%eax
801018a2:	8b 40 08             	mov    0x8(%eax),%eax
801018a5:	8d 50 01             	lea    0x1(%eax),%edx
801018a8:	8b 45 08             	mov    0x8(%ebp),%eax
801018ab:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801018ae:	83 ec 0c             	sub    $0xc,%esp
801018b1:	68 c0 e8 10 80       	push   $0x8010e8c0
801018b6:	e8 a1 32 00 00       	call   80104b5c <release>
801018bb:	83 c4 10             	add    $0x10,%esp
  return ip;
801018be:	8b 45 08             	mov    0x8(%ebp),%eax
}
801018c1:	c9                   	leave  
801018c2:	c3                   	ret    

801018c3 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801018c3:	55                   	push   %ebp
801018c4:	89 e5                	mov    %esp,%ebp
801018c6:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801018c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801018cd:	74 0a                	je     801018d9 <ilock+0x16>
801018cf:	8b 45 08             	mov    0x8(%ebp),%eax
801018d2:	8b 40 08             	mov    0x8(%eax),%eax
801018d5:	85 c0                	test   %eax,%eax
801018d7:	7f 0d                	jg     801018e6 <ilock+0x23>
    panic("ilock");
801018d9:	83 ec 0c             	sub    $0xc,%esp
801018dc:	68 c7 83 10 80       	push   $0x801083c7
801018e1:	e8 76 ec ff ff       	call   8010055c <panic>

  acquire(&icache.lock);
801018e6:	83 ec 0c             	sub    $0xc,%esp
801018e9:	68 c0 e8 10 80       	push   $0x8010e8c0
801018ee:	e8 03 32 00 00       	call   80104af6 <acquire>
801018f3:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
801018f6:	eb 13                	jmp    8010190b <ilock+0x48>
    sleep(ip, &icache.lock);
801018f8:	83 ec 08             	sub    $0x8,%esp
801018fb:	68 c0 e8 10 80       	push   $0x8010e8c0
80101900:	ff 75 08             	pushl  0x8(%ebp)
80101903:	e8 00 2f 00 00       	call   80104808 <sleep>
80101908:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
8010190b:	8b 45 08             	mov    0x8(%ebp),%eax
8010190e:	8b 40 0c             	mov    0xc(%eax),%eax
80101911:	83 e0 01             	and    $0x1,%eax
80101914:	85 c0                	test   %eax,%eax
80101916:	75 e0                	jne    801018f8 <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101918:	8b 45 08             	mov    0x8(%ebp),%eax
8010191b:	8b 40 0c             	mov    0xc(%eax),%eax
8010191e:	83 c8 01             	or     $0x1,%eax
80101921:	89 c2                	mov    %eax,%edx
80101923:	8b 45 08             	mov    0x8(%ebp),%eax
80101926:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101929:	83 ec 0c             	sub    $0xc,%esp
8010192c:	68 c0 e8 10 80       	push   $0x8010e8c0
80101931:	e8 26 32 00 00       	call   80104b5c <release>
80101936:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101939:	8b 45 08             	mov    0x8(%ebp),%eax
8010193c:	8b 40 0c             	mov    0xc(%eax),%eax
8010193f:	83 e0 02             	and    $0x2,%eax
80101942:	85 c0                	test   %eax,%eax
80101944:	0f 85 ce 00 00 00    	jne    80101a18 <ilock+0x155>
    bp = bread(ip->dev, IBLOCK(ip->inum));
8010194a:	8b 45 08             	mov    0x8(%ebp),%eax
8010194d:	8b 40 04             	mov    0x4(%eax),%eax
80101950:	c1 e8 03             	shr    $0x3,%eax
80101953:	8d 50 02             	lea    0x2(%eax),%edx
80101956:	8b 45 08             	mov    0x8(%ebp),%eax
80101959:	8b 00                	mov    (%eax),%eax
8010195b:	83 ec 08             	sub    $0x8,%esp
8010195e:	52                   	push   %edx
8010195f:	50                   	push   %eax
80101960:	e8 4f e8 ff ff       	call   801001b4 <bread>
80101965:	83 c4 10             	add    $0x10,%esp
80101968:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010196b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010196e:	8d 50 18             	lea    0x18(%eax),%edx
80101971:	8b 45 08             	mov    0x8(%ebp),%eax
80101974:	8b 40 04             	mov    0x4(%eax),%eax
80101977:	83 e0 07             	and    $0x7,%eax
8010197a:	c1 e0 06             	shl    $0x6,%eax
8010197d:	01 d0                	add    %edx,%eax
8010197f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101982:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101985:	0f b7 10             	movzwl (%eax),%edx
80101988:	8b 45 08             	mov    0x8(%ebp),%eax
8010198b:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
8010198f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101992:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101996:	8b 45 08             	mov    0x8(%ebp),%eax
80101999:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
8010199d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019a0:	0f b7 50 04          	movzwl 0x4(%eax),%edx
801019a4:	8b 45 08             	mov    0x8(%ebp),%eax
801019a7:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
801019ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019ae:	0f b7 50 06          	movzwl 0x6(%eax),%edx
801019b2:	8b 45 08             	mov    0x8(%ebp),%eax
801019b5:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
801019b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019bc:	8b 50 08             	mov    0x8(%eax),%edx
801019bf:	8b 45 08             	mov    0x8(%ebp),%eax
801019c2:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019c8:	8d 50 0c             	lea    0xc(%eax),%edx
801019cb:	8b 45 08             	mov    0x8(%ebp),%eax
801019ce:	83 c0 1c             	add    $0x1c,%eax
801019d1:	83 ec 04             	sub    $0x4,%esp
801019d4:	6a 34                	push   $0x34
801019d6:	52                   	push   %edx
801019d7:	50                   	push   %eax
801019d8:	e8 34 34 00 00       	call   80104e11 <memmove>
801019dd:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801019e0:	83 ec 0c             	sub    $0xc,%esp
801019e3:	ff 75 f4             	pushl  -0xc(%ebp)
801019e6:	e8 40 e8 ff ff       	call   8010022b <brelse>
801019eb:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
801019ee:	8b 45 08             	mov    0x8(%ebp),%eax
801019f1:	8b 40 0c             	mov    0xc(%eax),%eax
801019f4:	83 c8 02             	or     $0x2,%eax
801019f7:	89 c2                	mov    %eax,%edx
801019f9:	8b 45 08             	mov    0x8(%ebp),%eax
801019fc:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
801019ff:	8b 45 08             	mov    0x8(%ebp),%eax
80101a02:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101a06:	66 85 c0             	test   %ax,%ax
80101a09:	75 0d                	jne    80101a18 <ilock+0x155>
      panic("ilock: no type");
80101a0b:	83 ec 0c             	sub    $0xc,%esp
80101a0e:	68 cd 83 10 80       	push   $0x801083cd
80101a13:	e8 44 eb ff ff       	call   8010055c <panic>
  }
}
80101a18:	c9                   	leave  
80101a19:	c3                   	ret    

80101a1a <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101a1a:	55                   	push   %ebp
80101a1b:	89 e5                	mov    %esp,%ebp
80101a1d:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101a20:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a24:	74 17                	je     80101a3d <iunlock+0x23>
80101a26:	8b 45 08             	mov    0x8(%ebp),%eax
80101a29:	8b 40 0c             	mov    0xc(%eax),%eax
80101a2c:	83 e0 01             	and    $0x1,%eax
80101a2f:	85 c0                	test   %eax,%eax
80101a31:	74 0a                	je     80101a3d <iunlock+0x23>
80101a33:	8b 45 08             	mov    0x8(%ebp),%eax
80101a36:	8b 40 08             	mov    0x8(%eax),%eax
80101a39:	85 c0                	test   %eax,%eax
80101a3b:	7f 0d                	jg     80101a4a <iunlock+0x30>
    panic("iunlock");
80101a3d:	83 ec 0c             	sub    $0xc,%esp
80101a40:	68 dc 83 10 80       	push   $0x801083dc
80101a45:	e8 12 eb ff ff       	call   8010055c <panic>

  acquire(&icache.lock);
80101a4a:	83 ec 0c             	sub    $0xc,%esp
80101a4d:	68 c0 e8 10 80       	push   $0x8010e8c0
80101a52:	e8 9f 30 00 00       	call   80104af6 <acquire>
80101a57:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101a5a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5d:	8b 40 0c             	mov    0xc(%eax),%eax
80101a60:	83 e0 fe             	and    $0xfffffffe,%eax
80101a63:	89 c2                	mov    %eax,%edx
80101a65:	8b 45 08             	mov    0x8(%ebp),%eax
80101a68:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101a6b:	83 ec 0c             	sub    $0xc,%esp
80101a6e:	ff 75 08             	pushl  0x8(%ebp)
80101a71:	e8 7b 2e 00 00       	call   801048f1 <wakeup>
80101a76:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101a79:	83 ec 0c             	sub    $0xc,%esp
80101a7c:	68 c0 e8 10 80       	push   $0x8010e8c0
80101a81:	e8 d6 30 00 00       	call   80104b5c <release>
80101a86:	83 c4 10             	add    $0x10,%esp
}
80101a89:	c9                   	leave  
80101a8a:	c3                   	ret    

80101a8b <iput>:
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
void
iput(struct inode *ip)
{
80101a8b:	55                   	push   %ebp
80101a8c:	89 e5                	mov    %esp,%ebp
80101a8e:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101a91:	83 ec 0c             	sub    $0xc,%esp
80101a94:	68 c0 e8 10 80       	push   $0x8010e8c0
80101a99:	e8 58 30 00 00       	call   80104af6 <acquire>
80101a9e:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101aa1:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa4:	8b 40 08             	mov    0x8(%eax),%eax
80101aa7:	83 f8 01             	cmp    $0x1,%eax
80101aaa:	0f 85 a9 00 00 00    	jne    80101b59 <iput+0xce>
80101ab0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab3:	8b 40 0c             	mov    0xc(%eax),%eax
80101ab6:	83 e0 02             	and    $0x2,%eax
80101ab9:	85 c0                	test   %eax,%eax
80101abb:	0f 84 98 00 00 00    	je     80101b59 <iput+0xce>
80101ac1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac4:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101ac8:	66 85 c0             	test   %ax,%ax
80101acb:	0f 85 88 00 00 00    	jne    80101b59 <iput+0xce>
    // inode has no links: truncate and free inode.
    if(ip->flags & I_BUSY)
80101ad1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad4:	8b 40 0c             	mov    0xc(%eax),%eax
80101ad7:	83 e0 01             	and    $0x1,%eax
80101ada:	85 c0                	test   %eax,%eax
80101adc:	74 0d                	je     80101aeb <iput+0x60>
      panic("iput busy");
80101ade:	83 ec 0c             	sub    $0xc,%esp
80101ae1:	68 e4 83 10 80       	push   $0x801083e4
80101ae6:	e8 71 ea ff ff       	call   8010055c <panic>
    ip->flags |= I_BUSY;
80101aeb:	8b 45 08             	mov    0x8(%ebp),%eax
80101aee:	8b 40 0c             	mov    0xc(%eax),%eax
80101af1:	83 c8 01             	or     $0x1,%eax
80101af4:	89 c2                	mov    %eax,%edx
80101af6:	8b 45 08             	mov    0x8(%ebp),%eax
80101af9:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101afc:	83 ec 0c             	sub    $0xc,%esp
80101aff:	68 c0 e8 10 80       	push   $0x8010e8c0
80101b04:	e8 53 30 00 00       	call   80104b5c <release>
80101b09:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101b0c:	83 ec 0c             	sub    $0xc,%esp
80101b0f:	ff 75 08             	pushl  0x8(%ebp)
80101b12:	e8 a6 01 00 00       	call   80101cbd <itrunc>
80101b17:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101b1a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1d:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101b23:	83 ec 0c             	sub    $0xc,%esp
80101b26:	ff 75 08             	pushl  0x8(%ebp)
80101b29:	e8 c2 fb ff ff       	call   801016f0 <iupdate>
80101b2e:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101b31:	83 ec 0c             	sub    $0xc,%esp
80101b34:	68 c0 e8 10 80       	push   $0x8010e8c0
80101b39:	e8 b8 2f 00 00       	call   80104af6 <acquire>
80101b3e:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101b41:	8b 45 08             	mov    0x8(%ebp),%eax
80101b44:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101b4b:	83 ec 0c             	sub    $0xc,%esp
80101b4e:	ff 75 08             	pushl  0x8(%ebp)
80101b51:	e8 9b 2d 00 00       	call   801048f1 <wakeup>
80101b56:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101b59:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5c:	8b 40 08             	mov    0x8(%eax),%eax
80101b5f:	8d 50 ff             	lea    -0x1(%eax),%edx
80101b62:	8b 45 08             	mov    0x8(%ebp),%eax
80101b65:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b68:	83 ec 0c             	sub    $0xc,%esp
80101b6b:	68 c0 e8 10 80       	push   $0x8010e8c0
80101b70:	e8 e7 2f 00 00       	call   80104b5c <release>
80101b75:	83 c4 10             	add    $0x10,%esp
}
80101b78:	c9                   	leave  
80101b79:	c3                   	ret    

80101b7a <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b7a:	55                   	push   %ebp
80101b7b:	89 e5                	mov    %esp,%ebp
80101b7d:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101b80:	83 ec 0c             	sub    $0xc,%esp
80101b83:	ff 75 08             	pushl  0x8(%ebp)
80101b86:	e8 8f fe ff ff       	call   80101a1a <iunlock>
80101b8b:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101b8e:	83 ec 0c             	sub    $0xc,%esp
80101b91:	ff 75 08             	pushl  0x8(%ebp)
80101b94:	e8 f2 fe ff ff       	call   80101a8b <iput>
80101b99:	83 c4 10             	add    $0x10,%esp
}
80101b9c:	c9                   	leave  
80101b9d:	c3                   	ret    

80101b9e <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b9e:	55                   	push   %ebp
80101b9f:	89 e5                	mov    %esp,%ebp
80101ba1:	53                   	push   %ebx
80101ba2:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101ba5:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101ba9:	77 42                	ja     80101bed <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101bab:	8b 45 08             	mov    0x8(%ebp),%eax
80101bae:	8b 55 0c             	mov    0xc(%ebp),%edx
80101bb1:	83 c2 04             	add    $0x4,%edx
80101bb4:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101bb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101bbf:	75 24                	jne    80101be5 <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101bc1:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc4:	8b 00                	mov    (%eax),%eax
80101bc6:	83 ec 0c             	sub    $0xc,%esp
80101bc9:	50                   	push   %eax
80101bca:	e8 f3 f7 ff ff       	call   801013c2 <balloc>
80101bcf:	83 c4 10             	add    $0x10,%esp
80101bd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bd5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd8:	8b 55 0c             	mov    0xc(%ebp),%edx
80101bdb:	8d 4a 04             	lea    0x4(%edx),%ecx
80101bde:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101be1:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101be8:	e9 cb 00 00 00       	jmp    80101cb8 <bmap+0x11a>
  }
  bn -= NDIRECT;
80101bed:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101bf1:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101bf5:	0f 87 b0 00 00 00    	ja     80101cab <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101bfb:	8b 45 08             	mov    0x8(%ebp),%eax
80101bfe:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c01:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c08:	75 1d                	jne    80101c27 <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101c0a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0d:	8b 00                	mov    (%eax),%eax
80101c0f:	83 ec 0c             	sub    $0xc,%esp
80101c12:	50                   	push   %eax
80101c13:	e8 aa f7 ff ff       	call   801013c2 <balloc>
80101c18:	83 c4 10             	add    $0x10,%esp
80101c1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c21:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c24:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101c27:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2a:	8b 00                	mov    (%eax),%eax
80101c2c:	83 ec 08             	sub    $0x8,%esp
80101c2f:	ff 75 f4             	pushl  -0xc(%ebp)
80101c32:	50                   	push   %eax
80101c33:	e8 7c e5 ff ff       	call   801001b4 <bread>
80101c38:	83 c4 10             	add    $0x10,%esp
80101c3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101c3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c41:	83 c0 18             	add    $0x18,%eax
80101c44:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101c47:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c4a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c51:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c54:	01 d0                	add    %edx,%eax
80101c56:	8b 00                	mov    (%eax),%eax
80101c58:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c5f:	75 37                	jne    80101c98 <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101c61:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c64:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c6e:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101c71:	8b 45 08             	mov    0x8(%ebp),%eax
80101c74:	8b 00                	mov    (%eax),%eax
80101c76:	83 ec 0c             	sub    $0xc,%esp
80101c79:	50                   	push   %eax
80101c7a:	e8 43 f7 ff ff       	call   801013c2 <balloc>
80101c7f:	83 c4 10             	add    $0x10,%esp
80101c82:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c88:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101c8a:	83 ec 0c             	sub    $0xc,%esp
80101c8d:	ff 75 f0             	pushl  -0x10(%ebp)
80101c90:	e8 48 16 00 00       	call   801032dd <log_write>
80101c95:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101c98:	83 ec 0c             	sub    $0xc,%esp
80101c9b:	ff 75 f0             	pushl  -0x10(%ebp)
80101c9e:	e8 88 e5 ff ff       	call   8010022b <brelse>
80101ca3:	83 c4 10             	add    $0x10,%esp
    return addr;
80101ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ca9:	eb 0d                	jmp    80101cb8 <bmap+0x11a>
  }

  panic("bmap: out of range");
80101cab:	83 ec 0c             	sub    $0xc,%esp
80101cae:	68 ee 83 10 80       	push   $0x801083ee
80101cb3:	e8 a4 e8 ff ff       	call   8010055c <panic>
}
80101cb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101cbb:	c9                   	leave  
80101cbc:	c3                   	ret    

80101cbd <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101cbd:	55                   	push   %ebp
80101cbe:	89 e5                	mov    %esp,%ebp
80101cc0:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101cc3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101cca:	eb 45                	jmp    80101d11 <itrunc+0x54>
    if(ip->addrs[i]){
80101ccc:	8b 45 08             	mov    0x8(%ebp),%eax
80101ccf:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cd2:	83 c2 04             	add    $0x4,%edx
80101cd5:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101cd9:	85 c0                	test   %eax,%eax
80101cdb:	74 30                	je     80101d0d <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101cdd:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101ce3:	83 c2 04             	add    $0x4,%edx
80101ce6:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101cea:	8b 45 08             	mov    0x8(%ebp),%eax
80101ced:	8b 00                	mov    (%eax),%eax
80101cef:	83 ec 08             	sub    $0x8,%esp
80101cf2:	52                   	push   %edx
80101cf3:	50                   	push   %eax
80101cf4:	e8 23 f8 ff ff       	call   8010151c <bfree>
80101cf9:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101cfc:	8b 45 08             	mov    0x8(%ebp),%eax
80101cff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d02:	83 c2 04             	add    $0x4,%edx
80101d05:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101d0c:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d0d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101d11:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101d15:	7e b5                	jle    80101ccc <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101d17:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1a:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d1d:	85 c0                	test   %eax,%eax
80101d1f:	0f 84 a1 00 00 00    	je     80101dc6 <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101d25:	8b 45 08             	mov    0x8(%ebp),%eax
80101d28:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d2b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2e:	8b 00                	mov    (%eax),%eax
80101d30:	83 ec 08             	sub    $0x8,%esp
80101d33:	52                   	push   %edx
80101d34:	50                   	push   %eax
80101d35:	e8 7a e4 ff ff       	call   801001b4 <bread>
80101d3a:	83 c4 10             	add    $0x10,%esp
80101d3d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101d40:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d43:	83 c0 18             	add    $0x18,%eax
80101d46:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101d49:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101d50:	eb 3c                	jmp    80101d8e <itrunc+0xd1>
      if(a[j])
80101d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d55:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101d5f:	01 d0                	add    %edx,%eax
80101d61:	8b 00                	mov    (%eax),%eax
80101d63:	85 c0                	test   %eax,%eax
80101d65:	74 23                	je     80101d8a <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101d67:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d6a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d71:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101d74:	01 d0                	add    %edx,%eax
80101d76:	8b 10                	mov    (%eax),%edx
80101d78:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7b:	8b 00                	mov    (%eax),%eax
80101d7d:	83 ec 08             	sub    $0x8,%esp
80101d80:	52                   	push   %edx
80101d81:	50                   	push   %eax
80101d82:	e8 95 f7 ff ff       	call   8010151c <bfree>
80101d87:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101d8a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101d8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d91:	83 f8 7f             	cmp    $0x7f,%eax
80101d94:	76 bc                	jbe    80101d52 <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101d96:	83 ec 0c             	sub    $0xc,%esp
80101d99:	ff 75 ec             	pushl  -0x14(%ebp)
80101d9c:	e8 8a e4 ff ff       	call   8010022b <brelse>
80101da1:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101da4:	8b 45 08             	mov    0x8(%ebp),%eax
80101da7:	8b 50 4c             	mov    0x4c(%eax),%edx
80101daa:	8b 45 08             	mov    0x8(%ebp),%eax
80101dad:	8b 00                	mov    (%eax),%eax
80101daf:	83 ec 08             	sub    $0x8,%esp
80101db2:	52                   	push   %edx
80101db3:	50                   	push   %eax
80101db4:	e8 63 f7 ff ff       	call   8010151c <bfree>
80101db9:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101dbc:	8b 45 08             	mov    0x8(%ebp),%eax
80101dbf:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101dc6:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc9:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101dd0:	83 ec 0c             	sub    $0xc,%esp
80101dd3:	ff 75 08             	pushl  0x8(%ebp)
80101dd6:	e8 15 f9 ff ff       	call   801016f0 <iupdate>
80101ddb:	83 c4 10             	add    $0x10,%esp
}
80101dde:	c9                   	leave  
80101ddf:	c3                   	ret    

80101de0 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101de0:	55                   	push   %ebp
80101de1:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101de3:	8b 45 08             	mov    0x8(%ebp),%eax
80101de6:	8b 00                	mov    (%eax),%eax
80101de8:	89 c2                	mov    %eax,%edx
80101dea:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ded:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101df0:	8b 45 08             	mov    0x8(%ebp),%eax
80101df3:	8b 50 04             	mov    0x4(%eax),%edx
80101df6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101df9:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101dfc:	8b 45 08             	mov    0x8(%ebp),%eax
80101dff:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101e03:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e06:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101e09:	8b 45 08             	mov    0x8(%ebp),%eax
80101e0c:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101e10:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e13:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101e17:	8b 45 08             	mov    0x8(%ebp),%eax
80101e1a:	8b 50 18             	mov    0x18(%eax),%edx
80101e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e20:	89 50 10             	mov    %edx,0x10(%eax)
}
80101e23:	5d                   	pop    %ebp
80101e24:	c3                   	ret    

80101e25 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101e25:	55                   	push   %ebp
80101e26:	89 e5                	mov    %esp,%ebp
80101e28:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e2b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e2e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101e32:	66 83 f8 03          	cmp    $0x3,%ax
80101e36:	75 5c                	jne    80101e94 <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101e38:	8b 45 08             	mov    0x8(%ebp),%eax
80101e3b:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e3f:	66 85 c0             	test   %ax,%ax
80101e42:	78 20                	js     80101e64 <readi+0x3f>
80101e44:	8b 45 08             	mov    0x8(%ebp),%eax
80101e47:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e4b:	66 83 f8 09          	cmp    $0x9,%ax
80101e4f:	7f 13                	jg     80101e64 <readi+0x3f>
80101e51:	8b 45 08             	mov    0x8(%ebp),%eax
80101e54:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e58:	98                   	cwtl   
80101e59:	8b 04 c5 40 e8 10 80 	mov    -0x7fef17c0(,%eax,8),%eax
80101e60:	85 c0                	test   %eax,%eax
80101e62:	75 0a                	jne    80101e6e <readi+0x49>
      return -1;
80101e64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e69:	e9 11 01 00 00       	jmp    80101f7f <readi+0x15a>
    return devsw[ip->major].read(ip, dst, n);
80101e6e:	8b 45 08             	mov    0x8(%ebp),%eax
80101e71:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101e75:	98                   	cwtl   
80101e76:	8b 04 c5 40 e8 10 80 	mov    -0x7fef17c0(,%eax,8),%eax
80101e7d:	8b 55 14             	mov    0x14(%ebp),%edx
80101e80:	83 ec 04             	sub    $0x4,%esp
80101e83:	52                   	push   %edx
80101e84:	ff 75 0c             	pushl  0xc(%ebp)
80101e87:	ff 75 08             	pushl  0x8(%ebp)
80101e8a:	ff d0                	call   *%eax
80101e8c:	83 c4 10             	add    $0x10,%esp
80101e8f:	e9 eb 00 00 00       	jmp    80101f7f <readi+0x15a>
  }

  if(off > ip->size || off + n < off)
80101e94:	8b 45 08             	mov    0x8(%ebp),%eax
80101e97:	8b 40 18             	mov    0x18(%eax),%eax
80101e9a:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e9d:	72 0d                	jb     80101eac <readi+0x87>
80101e9f:	8b 55 10             	mov    0x10(%ebp),%edx
80101ea2:	8b 45 14             	mov    0x14(%ebp),%eax
80101ea5:	01 d0                	add    %edx,%eax
80101ea7:	3b 45 10             	cmp    0x10(%ebp),%eax
80101eaa:	73 0a                	jae    80101eb6 <readi+0x91>
    return -1;
80101eac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eb1:	e9 c9 00 00 00       	jmp    80101f7f <readi+0x15a>
  if(off + n > ip->size)
80101eb6:	8b 55 10             	mov    0x10(%ebp),%edx
80101eb9:	8b 45 14             	mov    0x14(%ebp),%eax
80101ebc:	01 c2                	add    %eax,%edx
80101ebe:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec1:	8b 40 18             	mov    0x18(%eax),%eax
80101ec4:	39 c2                	cmp    %eax,%edx
80101ec6:	76 0c                	jbe    80101ed4 <readi+0xaf>
    n = ip->size - off;
80101ec8:	8b 45 08             	mov    0x8(%ebp),%eax
80101ecb:	8b 40 18             	mov    0x18(%eax),%eax
80101ece:	2b 45 10             	sub    0x10(%ebp),%eax
80101ed1:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ed4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101edb:	e9 90 00 00 00       	jmp    80101f70 <readi+0x14b>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ee0:	8b 45 10             	mov    0x10(%ebp),%eax
80101ee3:	c1 e8 09             	shr    $0x9,%eax
80101ee6:	83 ec 08             	sub    $0x8,%esp
80101ee9:	50                   	push   %eax
80101eea:	ff 75 08             	pushl  0x8(%ebp)
80101eed:	e8 ac fc ff ff       	call   80101b9e <bmap>
80101ef2:	83 c4 10             	add    $0x10,%esp
80101ef5:	8b 55 08             	mov    0x8(%ebp),%edx
80101ef8:	8b 12                	mov    (%edx),%edx
80101efa:	83 ec 08             	sub    $0x8,%esp
80101efd:	50                   	push   %eax
80101efe:	52                   	push   %edx
80101eff:	e8 b0 e2 ff ff       	call   801001b4 <bread>
80101f04:	83 c4 10             	add    $0x10,%esp
80101f07:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101f0a:	8b 45 10             	mov    0x10(%ebp),%eax
80101f0d:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f12:	89 c2                	mov    %eax,%edx
80101f14:	b8 00 02 00 00       	mov    $0x200,%eax
80101f19:	29 d0                	sub    %edx,%eax
80101f1b:	89 c2                	mov    %eax,%edx
80101f1d:	8b 45 14             	mov    0x14(%ebp),%eax
80101f20:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101f23:	39 c2                	cmp    %eax,%edx
80101f25:	0f 46 c2             	cmovbe %edx,%eax
80101f28:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101f2b:	8b 45 10             	mov    0x10(%ebp),%eax
80101f2e:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f33:	8d 50 10             	lea    0x10(%eax),%edx
80101f36:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f39:	01 d0                	add    %edx,%eax
80101f3b:	83 c0 08             	add    $0x8,%eax
80101f3e:	83 ec 04             	sub    $0x4,%esp
80101f41:	ff 75 ec             	pushl  -0x14(%ebp)
80101f44:	50                   	push   %eax
80101f45:	ff 75 0c             	pushl  0xc(%ebp)
80101f48:	e8 c4 2e 00 00       	call   80104e11 <memmove>
80101f4d:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101f50:	83 ec 0c             	sub    $0xc,%esp
80101f53:	ff 75 f0             	pushl  -0x10(%ebp)
80101f56:	e8 d0 e2 ff ff       	call   8010022b <brelse>
80101f5b:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f61:	01 45 f4             	add    %eax,-0xc(%ebp)
80101f64:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f67:	01 45 10             	add    %eax,0x10(%ebp)
80101f6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f6d:	01 45 0c             	add    %eax,0xc(%ebp)
80101f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f73:	3b 45 14             	cmp    0x14(%ebp),%eax
80101f76:	0f 82 64 ff ff ff    	jb     80101ee0 <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101f7c:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101f7f:	c9                   	leave  
80101f80:	c3                   	ret    

80101f81 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101f81:	55                   	push   %ebp
80101f82:	89 e5                	mov    %esp,%ebp
80101f84:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f87:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101f8e:	66 83 f8 03          	cmp    $0x3,%ax
80101f92:	75 5c                	jne    80101ff0 <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101f94:	8b 45 08             	mov    0x8(%ebp),%eax
80101f97:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f9b:	66 85 c0             	test   %ax,%ax
80101f9e:	78 20                	js     80101fc0 <writei+0x3f>
80101fa0:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa3:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fa7:	66 83 f8 09          	cmp    $0x9,%ax
80101fab:	7f 13                	jg     80101fc0 <writei+0x3f>
80101fad:	8b 45 08             	mov    0x8(%ebp),%eax
80101fb0:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fb4:	98                   	cwtl   
80101fb5:	8b 04 c5 44 e8 10 80 	mov    -0x7fef17bc(,%eax,8),%eax
80101fbc:	85 c0                	test   %eax,%eax
80101fbe:	75 0a                	jne    80101fca <writei+0x49>
      return -1;
80101fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fc5:	e9 42 01 00 00       	jmp    8010210c <writei+0x18b>
    return devsw[ip->major].write(ip, src, n);
80101fca:	8b 45 08             	mov    0x8(%ebp),%eax
80101fcd:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fd1:	98                   	cwtl   
80101fd2:	8b 04 c5 44 e8 10 80 	mov    -0x7fef17bc(,%eax,8),%eax
80101fd9:	8b 55 14             	mov    0x14(%ebp),%edx
80101fdc:	83 ec 04             	sub    $0x4,%esp
80101fdf:	52                   	push   %edx
80101fe0:	ff 75 0c             	pushl  0xc(%ebp)
80101fe3:	ff 75 08             	pushl  0x8(%ebp)
80101fe6:	ff d0                	call   *%eax
80101fe8:	83 c4 10             	add    $0x10,%esp
80101feb:	e9 1c 01 00 00       	jmp    8010210c <writei+0x18b>
  }

  if(off > ip->size || off + n < off)
80101ff0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ff3:	8b 40 18             	mov    0x18(%eax),%eax
80101ff6:	3b 45 10             	cmp    0x10(%ebp),%eax
80101ff9:	72 0d                	jb     80102008 <writei+0x87>
80101ffb:	8b 55 10             	mov    0x10(%ebp),%edx
80101ffe:	8b 45 14             	mov    0x14(%ebp),%eax
80102001:	01 d0                	add    %edx,%eax
80102003:	3b 45 10             	cmp    0x10(%ebp),%eax
80102006:	73 0a                	jae    80102012 <writei+0x91>
    return -1;
80102008:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010200d:	e9 fa 00 00 00       	jmp    8010210c <writei+0x18b>
  if(off + n > MAXFILE*BSIZE)
80102012:	8b 55 10             	mov    0x10(%ebp),%edx
80102015:	8b 45 14             	mov    0x14(%ebp),%eax
80102018:	01 d0                	add    %edx,%eax
8010201a:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010201f:	76 0a                	jbe    8010202b <writei+0xaa>
    return -1;
80102021:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102026:	e9 e1 00 00 00       	jmp    8010210c <writei+0x18b>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010202b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102032:	e9 9e 00 00 00       	jmp    801020d5 <writei+0x154>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102037:	8b 45 10             	mov    0x10(%ebp),%eax
8010203a:	c1 e8 09             	shr    $0x9,%eax
8010203d:	83 ec 08             	sub    $0x8,%esp
80102040:	50                   	push   %eax
80102041:	ff 75 08             	pushl  0x8(%ebp)
80102044:	e8 55 fb ff ff       	call   80101b9e <bmap>
80102049:	83 c4 10             	add    $0x10,%esp
8010204c:	8b 55 08             	mov    0x8(%ebp),%edx
8010204f:	8b 12                	mov    (%edx),%edx
80102051:	83 ec 08             	sub    $0x8,%esp
80102054:	50                   	push   %eax
80102055:	52                   	push   %edx
80102056:	e8 59 e1 ff ff       	call   801001b4 <bread>
8010205b:	83 c4 10             	add    $0x10,%esp
8010205e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102061:	8b 45 10             	mov    0x10(%ebp),%eax
80102064:	25 ff 01 00 00       	and    $0x1ff,%eax
80102069:	89 c2                	mov    %eax,%edx
8010206b:	b8 00 02 00 00       	mov    $0x200,%eax
80102070:	29 d0                	sub    %edx,%eax
80102072:	89 c2                	mov    %eax,%edx
80102074:	8b 45 14             	mov    0x14(%ebp),%eax
80102077:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010207a:	39 c2                	cmp    %eax,%edx
8010207c:	0f 46 c2             	cmovbe %edx,%eax
8010207f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102082:	8b 45 10             	mov    0x10(%ebp),%eax
80102085:	25 ff 01 00 00       	and    $0x1ff,%eax
8010208a:	8d 50 10             	lea    0x10(%eax),%edx
8010208d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102090:	01 d0                	add    %edx,%eax
80102092:	83 c0 08             	add    $0x8,%eax
80102095:	83 ec 04             	sub    $0x4,%esp
80102098:	ff 75 ec             	pushl  -0x14(%ebp)
8010209b:	ff 75 0c             	pushl  0xc(%ebp)
8010209e:	50                   	push   %eax
8010209f:	e8 6d 2d 00 00       	call   80104e11 <memmove>
801020a4:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
801020a7:	83 ec 0c             	sub    $0xc,%esp
801020aa:	ff 75 f0             	pushl  -0x10(%ebp)
801020ad:	e8 2b 12 00 00       	call   801032dd <log_write>
801020b2:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801020b5:	83 ec 0c             	sub    $0xc,%esp
801020b8:	ff 75 f0             	pushl  -0x10(%ebp)
801020bb:	e8 6b e1 ff ff       	call   8010022b <brelse>
801020c0:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020c6:	01 45 f4             	add    %eax,-0xc(%ebp)
801020c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020cc:	01 45 10             	add    %eax,0x10(%ebp)
801020cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020d2:	01 45 0c             	add    %eax,0xc(%ebp)
801020d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020d8:	3b 45 14             	cmp    0x14(%ebp),%eax
801020db:	0f 82 56 ff ff ff    	jb     80102037 <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
801020e1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801020e5:	74 22                	je     80102109 <writei+0x188>
801020e7:	8b 45 08             	mov    0x8(%ebp),%eax
801020ea:	8b 40 18             	mov    0x18(%eax),%eax
801020ed:	3b 45 10             	cmp    0x10(%ebp),%eax
801020f0:	73 17                	jae    80102109 <writei+0x188>
    ip->size = off;
801020f2:	8b 45 08             	mov    0x8(%ebp),%eax
801020f5:	8b 55 10             	mov    0x10(%ebp),%edx
801020f8:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
801020fb:	83 ec 0c             	sub    $0xc,%esp
801020fe:	ff 75 08             	pushl  0x8(%ebp)
80102101:	e8 ea f5 ff ff       	call   801016f0 <iupdate>
80102106:	83 c4 10             	add    $0x10,%esp
  }
  return n;
80102109:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010210c:	c9                   	leave  
8010210d:	c3                   	ret    

8010210e <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
8010210e:	55                   	push   %ebp
8010210f:	89 e5                	mov    %esp,%ebp
80102111:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
80102114:	83 ec 04             	sub    $0x4,%esp
80102117:	6a 0e                	push   $0xe
80102119:	ff 75 0c             	pushl  0xc(%ebp)
8010211c:	ff 75 08             	pushl  0x8(%ebp)
8010211f:	e8 85 2d 00 00       	call   80104ea9 <strncmp>
80102124:	83 c4 10             	add    $0x10,%esp
}
80102127:	c9                   	leave  
80102128:	c3                   	ret    

80102129 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102129:	55                   	push   %ebp
8010212a:	89 e5                	mov    %esp,%ebp
8010212c:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010212f:	8b 45 08             	mov    0x8(%ebp),%eax
80102132:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102136:	66 83 f8 01          	cmp    $0x1,%ax
8010213a:	74 0d                	je     80102149 <dirlookup+0x20>
    panic("dirlookup not DIR");
8010213c:	83 ec 0c             	sub    $0xc,%esp
8010213f:	68 01 84 10 80       	push   $0x80108401
80102144:	e8 13 e4 ff ff       	call   8010055c <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102149:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102150:	eb 7c                	jmp    801021ce <dirlookup+0xa5>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102152:	6a 10                	push   $0x10
80102154:	ff 75 f4             	pushl  -0xc(%ebp)
80102157:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010215a:	50                   	push   %eax
8010215b:	ff 75 08             	pushl  0x8(%ebp)
8010215e:	e8 c2 fc ff ff       	call   80101e25 <readi>
80102163:	83 c4 10             	add    $0x10,%esp
80102166:	83 f8 10             	cmp    $0x10,%eax
80102169:	74 0d                	je     80102178 <dirlookup+0x4f>
      panic("dirlink read");
8010216b:	83 ec 0c             	sub    $0xc,%esp
8010216e:	68 13 84 10 80       	push   $0x80108413
80102173:	e8 e4 e3 ff ff       	call   8010055c <panic>
    if(de.inum == 0)
80102178:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010217c:	66 85 c0             	test   %ax,%ax
8010217f:	75 02                	jne    80102183 <dirlookup+0x5a>
      continue;
80102181:	eb 47                	jmp    801021ca <dirlookup+0xa1>
    if(namecmp(name, de.name) == 0){
80102183:	83 ec 08             	sub    $0x8,%esp
80102186:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102189:	83 c0 02             	add    $0x2,%eax
8010218c:	50                   	push   %eax
8010218d:	ff 75 0c             	pushl  0xc(%ebp)
80102190:	e8 79 ff ff ff       	call   8010210e <namecmp>
80102195:	83 c4 10             	add    $0x10,%esp
80102198:	85 c0                	test   %eax,%eax
8010219a:	75 2e                	jne    801021ca <dirlookup+0xa1>
      // entry matches path element
      if(poff)
8010219c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801021a0:	74 08                	je     801021aa <dirlookup+0x81>
        *poff = off;
801021a2:	8b 45 10             	mov    0x10(%ebp),%eax
801021a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801021a8:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
801021aa:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021ae:	0f b7 c0             	movzwl %ax,%eax
801021b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
801021b4:	8b 45 08             	mov    0x8(%ebp),%eax
801021b7:	8b 00                	mov    (%eax),%eax
801021b9:	83 ec 08             	sub    $0x8,%esp
801021bc:	ff 75 f0             	pushl  -0x10(%ebp)
801021bf:	50                   	push   %eax
801021c0:	e8 e5 f5 ff ff       	call   801017aa <iget>
801021c5:	83 c4 10             	add    $0x10,%esp
801021c8:	eb 18                	jmp    801021e2 <dirlookup+0xb9>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801021ca:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801021ce:	8b 45 08             	mov    0x8(%ebp),%eax
801021d1:	8b 40 18             	mov    0x18(%eax),%eax
801021d4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801021d7:	0f 87 75 ff ff ff    	ja     80102152 <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
801021dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801021e2:	c9                   	leave  
801021e3:	c3                   	ret    

801021e4 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801021e4:	55                   	push   %ebp
801021e5:	89 e5                	mov    %esp,%ebp
801021e7:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801021ea:	83 ec 04             	sub    $0x4,%esp
801021ed:	6a 00                	push   $0x0
801021ef:	ff 75 0c             	pushl  0xc(%ebp)
801021f2:	ff 75 08             	pushl  0x8(%ebp)
801021f5:	e8 2f ff ff ff       	call   80102129 <dirlookup>
801021fa:	83 c4 10             	add    $0x10,%esp
801021fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102200:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102204:	74 18                	je     8010221e <dirlink+0x3a>
    iput(ip);
80102206:	83 ec 0c             	sub    $0xc,%esp
80102209:	ff 75 f0             	pushl  -0x10(%ebp)
8010220c:	e8 7a f8 ff ff       	call   80101a8b <iput>
80102211:	83 c4 10             	add    $0x10,%esp
    return -1;
80102214:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102219:	e9 9b 00 00 00       	jmp    801022b9 <dirlink+0xd5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010221e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102225:	eb 3b                	jmp    80102262 <dirlink+0x7e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102227:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010222a:	6a 10                	push   $0x10
8010222c:	50                   	push   %eax
8010222d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102230:	50                   	push   %eax
80102231:	ff 75 08             	pushl  0x8(%ebp)
80102234:	e8 ec fb ff ff       	call   80101e25 <readi>
80102239:	83 c4 10             	add    $0x10,%esp
8010223c:	83 f8 10             	cmp    $0x10,%eax
8010223f:	74 0d                	je     8010224e <dirlink+0x6a>
      panic("dirlink read");
80102241:	83 ec 0c             	sub    $0xc,%esp
80102244:	68 13 84 10 80       	push   $0x80108413
80102249:	e8 0e e3 ff ff       	call   8010055c <panic>
    if(de.inum == 0)
8010224e:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102252:	66 85 c0             	test   %ax,%ax
80102255:	75 02                	jne    80102259 <dirlink+0x75>
      break;
80102257:	eb 16                	jmp    8010226f <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102259:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010225c:	83 c0 10             	add    $0x10,%eax
8010225f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102262:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102265:	8b 45 08             	mov    0x8(%ebp),%eax
80102268:	8b 40 18             	mov    0x18(%eax),%eax
8010226b:	39 c2                	cmp    %eax,%edx
8010226d:	72 b8                	jb     80102227 <dirlink+0x43>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
8010226f:	83 ec 04             	sub    $0x4,%esp
80102272:	6a 0e                	push   $0xe
80102274:	ff 75 0c             	pushl  0xc(%ebp)
80102277:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010227a:	83 c0 02             	add    $0x2,%eax
8010227d:	50                   	push   %eax
8010227e:	e8 7c 2c 00 00       	call   80104eff <strncpy>
80102283:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
80102286:	8b 45 10             	mov    0x10(%ebp),%eax
80102289:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010228d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102290:	6a 10                	push   $0x10
80102292:	50                   	push   %eax
80102293:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102296:	50                   	push   %eax
80102297:	ff 75 08             	pushl  0x8(%ebp)
8010229a:	e8 e2 fc ff ff       	call   80101f81 <writei>
8010229f:	83 c4 10             	add    $0x10,%esp
801022a2:	83 f8 10             	cmp    $0x10,%eax
801022a5:	74 0d                	je     801022b4 <dirlink+0xd0>
    panic("dirlink");
801022a7:	83 ec 0c             	sub    $0xc,%esp
801022aa:	68 20 84 10 80       	push   $0x80108420
801022af:	e8 a8 e2 ff ff       	call   8010055c <panic>
  
  return 0;
801022b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801022b9:	c9                   	leave  
801022ba:	c3                   	ret    

801022bb <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801022bb:	55                   	push   %ebp
801022bc:	89 e5                	mov    %esp,%ebp
801022be:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
801022c1:	eb 04                	jmp    801022c7 <skipelem+0xc>
    path++;
801022c3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
801022c7:	8b 45 08             	mov    0x8(%ebp),%eax
801022ca:	0f b6 00             	movzbl (%eax),%eax
801022cd:	3c 2f                	cmp    $0x2f,%al
801022cf:	74 f2                	je     801022c3 <skipelem+0x8>
    path++;
  if(*path == 0)
801022d1:	8b 45 08             	mov    0x8(%ebp),%eax
801022d4:	0f b6 00             	movzbl (%eax),%eax
801022d7:	84 c0                	test   %al,%al
801022d9:	75 07                	jne    801022e2 <skipelem+0x27>
    return 0;
801022db:	b8 00 00 00 00       	mov    $0x0,%eax
801022e0:	eb 7b                	jmp    8010235d <skipelem+0xa2>
  s = path;
801022e2:	8b 45 08             	mov    0x8(%ebp),%eax
801022e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801022e8:	eb 04                	jmp    801022ee <skipelem+0x33>
    path++;
801022ea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801022ee:	8b 45 08             	mov    0x8(%ebp),%eax
801022f1:	0f b6 00             	movzbl (%eax),%eax
801022f4:	3c 2f                	cmp    $0x2f,%al
801022f6:	74 0a                	je     80102302 <skipelem+0x47>
801022f8:	8b 45 08             	mov    0x8(%ebp),%eax
801022fb:	0f b6 00             	movzbl (%eax),%eax
801022fe:	84 c0                	test   %al,%al
80102300:	75 e8                	jne    801022ea <skipelem+0x2f>
    path++;
  len = path - s;
80102302:	8b 55 08             	mov    0x8(%ebp),%edx
80102305:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102308:	29 c2                	sub    %eax,%edx
8010230a:	89 d0                	mov    %edx,%eax
8010230c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
8010230f:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102313:	7e 15                	jle    8010232a <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
80102315:	83 ec 04             	sub    $0x4,%esp
80102318:	6a 0e                	push   $0xe
8010231a:	ff 75 f4             	pushl  -0xc(%ebp)
8010231d:	ff 75 0c             	pushl  0xc(%ebp)
80102320:	e8 ec 2a 00 00       	call   80104e11 <memmove>
80102325:	83 c4 10             	add    $0x10,%esp
80102328:	eb 20                	jmp    8010234a <skipelem+0x8f>
  else {
    memmove(name, s, len);
8010232a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010232d:	83 ec 04             	sub    $0x4,%esp
80102330:	50                   	push   %eax
80102331:	ff 75 f4             	pushl  -0xc(%ebp)
80102334:	ff 75 0c             	pushl  0xc(%ebp)
80102337:	e8 d5 2a 00 00       	call   80104e11 <memmove>
8010233c:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
8010233f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102342:	8b 45 0c             	mov    0xc(%ebp),%eax
80102345:	01 d0                	add    %edx,%eax
80102347:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
8010234a:	eb 04                	jmp    80102350 <skipelem+0x95>
    path++;
8010234c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102350:	8b 45 08             	mov    0x8(%ebp),%eax
80102353:	0f b6 00             	movzbl (%eax),%eax
80102356:	3c 2f                	cmp    $0x2f,%al
80102358:	74 f2                	je     8010234c <skipelem+0x91>
    path++;
  return path;
8010235a:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010235d:	c9                   	leave  
8010235e:	c3                   	ret    

8010235f <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
namex(char *path, int nameiparent, char *name)
{
8010235f:	55                   	push   %ebp
80102360:	89 e5                	mov    %esp,%ebp
80102362:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102365:	8b 45 08             	mov    0x8(%ebp),%eax
80102368:	0f b6 00             	movzbl (%eax),%eax
8010236b:	3c 2f                	cmp    $0x2f,%al
8010236d:	75 14                	jne    80102383 <namex+0x24>
    ip = iget(ROOTDEV, ROOTINO);
8010236f:	83 ec 08             	sub    $0x8,%esp
80102372:	6a 01                	push   $0x1
80102374:	6a 01                	push   $0x1
80102376:	e8 2f f4 ff ff       	call   801017aa <iget>
8010237b:	83 c4 10             	add    $0x10,%esp
8010237e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102381:	eb 18                	jmp    8010239b <namex+0x3c>
  else
    ip = idup(proc->cwd);
80102383:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102389:	8b 40 68             	mov    0x68(%eax),%eax
8010238c:	83 ec 0c             	sub    $0xc,%esp
8010238f:	50                   	push   %eax
80102390:	e8 f4 f4 ff ff       	call   80101889 <idup>
80102395:	83 c4 10             	add    $0x10,%esp
80102398:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
8010239b:	e9 9e 00 00 00       	jmp    8010243e <namex+0xdf>
    ilock(ip);
801023a0:	83 ec 0c             	sub    $0xc,%esp
801023a3:	ff 75 f4             	pushl  -0xc(%ebp)
801023a6:	e8 18 f5 ff ff       	call   801018c3 <ilock>
801023ab:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
801023ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023b1:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801023b5:	66 83 f8 01          	cmp    $0x1,%ax
801023b9:	74 18                	je     801023d3 <namex+0x74>
      iunlockput(ip);
801023bb:	83 ec 0c             	sub    $0xc,%esp
801023be:	ff 75 f4             	pushl  -0xc(%ebp)
801023c1:	e8 b4 f7 ff ff       	call   80101b7a <iunlockput>
801023c6:	83 c4 10             	add    $0x10,%esp
      return 0;
801023c9:	b8 00 00 00 00       	mov    $0x0,%eax
801023ce:	e9 a7 00 00 00       	jmp    8010247a <namex+0x11b>
    }
    if(nameiparent && *path == '\0'){
801023d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023d7:	74 20                	je     801023f9 <namex+0x9a>
801023d9:	8b 45 08             	mov    0x8(%ebp),%eax
801023dc:	0f b6 00             	movzbl (%eax),%eax
801023df:	84 c0                	test   %al,%al
801023e1:	75 16                	jne    801023f9 <namex+0x9a>
      // Stop one level early.
      iunlock(ip);
801023e3:	83 ec 0c             	sub    $0xc,%esp
801023e6:	ff 75 f4             	pushl  -0xc(%ebp)
801023e9:	e8 2c f6 ff ff       	call   80101a1a <iunlock>
801023ee:	83 c4 10             	add    $0x10,%esp
      return ip;
801023f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023f4:	e9 81 00 00 00       	jmp    8010247a <namex+0x11b>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801023f9:	83 ec 04             	sub    $0x4,%esp
801023fc:	6a 00                	push   $0x0
801023fe:	ff 75 10             	pushl  0x10(%ebp)
80102401:	ff 75 f4             	pushl  -0xc(%ebp)
80102404:	e8 20 fd ff ff       	call   80102129 <dirlookup>
80102409:	83 c4 10             	add    $0x10,%esp
8010240c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010240f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102413:	75 15                	jne    8010242a <namex+0xcb>
      iunlockput(ip);
80102415:	83 ec 0c             	sub    $0xc,%esp
80102418:	ff 75 f4             	pushl  -0xc(%ebp)
8010241b:	e8 5a f7 ff ff       	call   80101b7a <iunlockput>
80102420:	83 c4 10             	add    $0x10,%esp
      return 0;
80102423:	b8 00 00 00 00       	mov    $0x0,%eax
80102428:	eb 50                	jmp    8010247a <namex+0x11b>
    }
    iunlockput(ip);
8010242a:	83 ec 0c             	sub    $0xc,%esp
8010242d:	ff 75 f4             	pushl  -0xc(%ebp)
80102430:	e8 45 f7 ff ff       	call   80101b7a <iunlockput>
80102435:	83 c4 10             	add    $0x10,%esp
    ip = next;
80102438:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010243b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
8010243e:	83 ec 08             	sub    $0x8,%esp
80102441:	ff 75 10             	pushl  0x10(%ebp)
80102444:	ff 75 08             	pushl  0x8(%ebp)
80102447:	e8 6f fe ff ff       	call   801022bb <skipelem>
8010244c:	83 c4 10             	add    $0x10,%esp
8010244f:	89 45 08             	mov    %eax,0x8(%ebp)
80102452:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102456:	0f 85 44 ff ff ff    	jne    801023a0 <namex+0x41>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
8010245c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102460:	74 15                	je     80102477 <namex+0x118>
    iput(ip);
80102462:	83 ec 0c             	sub    $0xc,%esp
80102465:	ff 75 f4             	pushl  -0xc(%ebp)
80102468:	e8 1e f6 ff ff       	call   80101a8b <iput>
8010246d:	83 c4 10             	add    $0x10,%esp
    return 0;
80102470:	b8 00 00 00 00       	mov    $0x0,%eax
80102475:	eb 03                	jmp    8010247a <namex+0x11b>
  }
  return ip;
80102477:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010247a:	c9                   	leave  
8010247b:	c3                   	ret    

8010247c <namei>:

struct inode*
namei(char *path)
{
8010247c:	55                   	push   %ebp
8010247d:	89 e5                	mov    %esp,%ebp
8010247f:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102482:	83 ec 04             	sub    $0x4,%esp
80102485:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102488:	50                   	push   %eax
80102489:	6a 00                	push   $0x0
8010248b:	ff 75 08             	pushl  0x8(%ebp)
8010248e:	e8 cc fe ff ff       	call   8010235f <namex>
80102493:	83 c4 10             	add    $0x10,%esp
}
80102496:	c9                   	leave  
80102497:	c3                   	ret    

80102498 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102498:	55                   	push   %ebp
80102499:	89 e5                	mov    %esp,%ebp
8010249b:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
8010249e:	83 ec 04             	sub    $0x4,%esp
801024a1:	ff 75 0c             	pushl  0xc(%ebp)
801024a4:	6a 01                	push   $0x1
801024a6:	ff 75 08             	pushl  0x8(%ebp)
801024a9:	e8 b1 fe ff ff       	call   8010235f <namex>
801024ae:	83 c4 10             	add    $0x10,%esp
}
801024b1:	c9                   	leave  
801024b2:	c3                   	ret    

801024b3 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801024b3:	55                   	push   %ebp
801024b4:	89 e5                	mov    %esp,%ebp
801024b6:	83 ec 14             	sub    $0x14,%esp
801024b9:	8b 45 08             	mov    0x8(%ebp),%eax
801024bc:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024c0:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801024c4:	89 c2                	mov    %eax,%edx
801024c6:	ec                   	in     (%dx),%al
801024c7:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801024ca:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801024ce:	c9                   	leave  
801024cf:	c3                   	ret    

801024d0 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801024d0:	55                   	push   %ebp
801024d1:	89 e5                	mov    %esp,%ebp
801024d3:	57                   	push   %edi
801024d4:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801024d5:	8b 55 08             	mov    0x8(%ebp),%edx
801024d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024db:	8b 45 10             	mov    0x10(%ebp),%eax
801024de:	89 cb                	mov    %ecx,%ebx
801024e0:	89 df                	mov    %ebx,%edi
801024e2:	89 c1                	mov    %eax,%ecx
801024e4:	fc                   	cld    
801024e5:	f3 6d                	rep insl (%dx),%es:(%edi)
801024e7:	89 c8                	mov    %ecx,%eax
801024e9:	89 fb                	mov    %edi,%ebx
801024eb:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024ee:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
801024f1:	5b                   	pop    %ebx
801024f2:	5f                   	pop    %edi
801024f3:	5d                   	pop    %ebp
801024f4:	c3                   	ret    

801024f5 <outb>:

static inline void
outb(ushort port, uchar data)
{
801024f5:	55                   	push   %ebp
801024f6:	89 e5                	mov    %esp,%ebp
801024f8:	83 ec 08             	sub    $0x8,%esp
801024fb:	8b 55 08             	mov    0x8(%ebp),%edx
801024fe:	8b 45 0c             	mov    0xc(%ebp),%eax
80102501:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102505:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102508:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010250c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102510:	ee                   	out    %al,(%dx)
}
80102511:	c9                   	leave  
80102512:	c3                   	ret    

80102513 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102513:	55                   	push   %ebp
80102514:	89 e5                	mov    %esp,%ebp
80102516:	56                   	push   %esi
80102517:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102518:	8b 55 08             	mov    0x8(%ebp),%edx
8010251b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010251e:	8b 45 10             	mov    0x10(%ebp),%eax
80102521:	89 cb                	mov    %ecx,%ebx
80102523:	89 de                	mov    %ebx,%esi
80102525:	89 c1                	mov    %eax,%ecx
80102527:	fc                   	cld    
80102528:	f3 6f                	rep outsl %ds:(%esi),(%dx)
8010252a:	89 c8                	mov    %ecx,%eax
8010252c:	89 f3                	mov    %esi,%ebx
8010252e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102531:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102534:	5b                   	pop    %ebx
80102535:	5e                   	pop    %esi
80102536:	5d                   	pop    %ebp
80102537:	c3                   	ret    

80102538 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102538:	55                   	push   %ebp
80102539:	89 e5                	mov    %esp,%ebp
8010253b:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
8010253e:	90                   	nop
8010253f:	68 f7 01 00 00       	push   $0x1f7
80102544:	e8 6a ff ff ff       	call   801024b3 <inb>
80102549:	83 c4 04             	add    $0x4,%esp
8010254c:	0f b6 c0             	movzbl %al,%eax
8010254f:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102552:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102555:	25 c0 00 00 00       	and    $0xc0,%eax
8010255a:	83 f8 40             	cmp    $0x40,%eax
8010255d:	75 e0                	jne    8010253f <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010255f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102563:	74 11                	je     80102576 <idewait+0x3e>
80102565:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102568:	83 e0 21             	and    $0x21,%eax
8010256b:	85 c0                	test   %eax,%eax
8010256d:	74 07                	je     80102576 <idewait+0x3e>
    return -1;
8010256f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102574:	eb 05                	jmp    8010257b <idewait+0x43>
  return 0;
80102576:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010257b:	c9                   	leave  
8010257c:	c3                   	ret    

8010257d <ideinit>:

void
ideinit(void)
{
8010257d:	55                   	push   %ebp
8010257e:	89 e5                	mov    %esp,%ebp
80102580:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80102583:	83 ec 08             	sub    $0x8,%esp
80102586:	68 28 84 10 80       	push   $0x80108428
8010258b:	68 20 b6 10 80       	push   $0x8010b620
80102590:	e8 40 25 00 00       	call   80104ad5 <initlock>
80102595:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
80102598:	83 ec 0c             	sub    $0xc,%esp
8010259b:	6a 0e                	push   $0xe
8010259d:	e8 e0 14 00 00       	call   80103a82 <picenable>
801025a2:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
801025a5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801025aa:	83 e8 01             	sub    $0x1,%eax
801025ad:	83 ec 08             	sub    $0x8,%esp
801025b0:	50                   	push   %eax
801025b1:	6a 0e                	push   $0xe
801025b3:	e8 2f 04 00 00       	call   801029e7 <ioapicenable>
801025b8:	83 c4 10             	add    $0x10,%esp
  idewait(0);
801025bb:	83 ec 0c             	sub    $0xc,%esp
801025be:	6a 00                	push   $0x0
801025c0:	e8 73 ff ff ff       	call   80102538 <idewait>
801025c5:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801025c8:	83 ec 08             	sub    $0x8,%esp
801025cb:	68 f0 00 00 00       	push   $0xf0
801025d0:	68 f6 01 00 00       	push   $0x1f6
801025d5:	e8 1b ff ff ff       	call   801024f5 <outb>
801025da:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
801025dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801025e4:	eb 24                	jmp    8010260a <ideinit+0x8d>
    if(inb(0x1f7) != 0){
801025e6:	83 ec 0c             	sub    $0xc,%esp
801025e9:	68 f7 01 00 00       	push   $0x1f7
801025ee:	e8 c0 fe ff ff       	call   801024b3 <inb>
801025f3:	83 c4 10             	add    $0x10,%esp
801025f6:	84 c0                	test   %al,%al
801025f8:	74 0c                	je     80102606 <ideinit+0x89>
      havedisk1 = 1;
801025fa:	c7 05 58 b6 10 80 01 	movl   $0x1,0x8010b658
80102601:	00 00 00 
      break;
80102604:	eb 0d                	jmp    80102613 <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102606:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010260a:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102611:	7e d3                	jle    801025e6 <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102613:	83 ec 08             	sub    $0x8,%esp
80102616:	68 e0 00 00 00       	push   $0xe0
8010261b:	68 f6 01 00 00       	push   $0x1f6
80102620:	e8 d0 fe ff ff       	call   801024f5 <outb>
80102625:	83 c4 10             	add    $0x10,%esp
}
80102628:	c9                   	leave  
80102629:	c3                   	ret    

8010262a <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
8010262a:	55                   	push   %ebp
8010262b:	89 e5                	mov    %esp,%ebp
8010262d:	83 ec 08             	sub    $0x8,%esp
  if(b == 0)
80102630:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102634:	75 0d                	jne    80102643 <idestart+0x19>
    panic("idestart");
80102636:	83 ec 0c             	sub    $0xc,%esp
80102639:	68 2c 84 10 80       	push   $0x8010842c
8010263e:	e8 19 df ff ff       	call   8010055c <panic>

  idewait(0);
80102643:	83 ec 0c             	sub    $0xc,%esp
80102646:	6a 00                	push   $0x0
80102648:	e8 eb fe ff ff       	call   80102538 <idewait>
8010264d:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
80102650:	83 ec 08             	sub    $0x8,%esp
80102653:	6a 00                	push   $0x0
80102655:	68 f6 03 00 00       	push   $0x3f6
8010265a:	e8 96 fe ff ff       	call   801024f5 <outb>
8010265f:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, 1);  // number of sectors
80102662:	83 ec 08             	sub    $0x8,%esp
80102665:	6a 01                	push   $0x1
80102667:	68 f2 01 00 00       	push   $0x1f2
8010266c:	e8 84 fe ff ff       	call   801024f5 <outb>
80102671:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, b->sector & 0xff);
80102674:	8b 45 08             	mov    0x8(%ebp),%eax
80102677:	8b 40 08             	mov    0x8(%eax),%eax
8010267a:	0f b6 c0             	movzbl %al,%eax
8010267d:	83 ec 08             	sub    $0x8,%esp
80102680:	50                   	push   %eax
80102681:	68 f3 01 00 00       	push   $0x1f3
80102686:	e8 6a fe ff ff       	call   801024f5 <outb>
8010268b:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (b->sector >> 8) & 0xff);
8010268e:	8b 45 08             	mov    0x8(%ebp),%eax
80102691:	8b 40 08             	mov    0x8(%eax),%eax
80102694:	c1 e8 08             	shr    $0x8,%eax
80102697:	0f b6 c0             	movzbl %al,%eax
8010269a:	83 ec 08             	sub    $0x8,%esp
8010269d:	50                   	push   %eax
8010269e:	68 f4 01 00 00       	push   $0x1f4
801026a3:	e8 4d fe ff ff       	call   801024f5 <outb>
801026a8:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (b->sector >> 16) & 0xff);
801026ab:	8b 45 08             	mov    0x8(%ebp),%eax
801026ae:	8b 40 08             	mov    0x8(%eax),%eax
801026b1:	c1 e8 10             	shr    $0x10,%eax
801026b4:	0f b6 c0             	movzbl %al,%eax
801026b7:	83 ec 08             	sub    $0x8,%esp
801026ba:	50                   	push   %eax
801026bb:	68 f5 01 00 00       	push   $0x1f5
801026c0:	e8 30 fe ff ff       	call   801024f5 <outb>
801026c5:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
801026c8:	8b 45 08             	mov    0x8(%ebp),%eax
801026cb:	8b 40 04             	mov    0x4(%eax),%eax
801026ce:	83 e0 01             	and    $0x1,%eax
801026d1:	c1 e0 04             	shl    $0x4,%eax
801026d4:	89 c2                	mov    %eax,%edx
801026d6:	8b 45 08             	mov    0x8(%ebp),%eax
801026d9:	8b 40 08             	mov    0x8(%eax),%eax
801026dc:	c1 e8 18             	shr    $0x18,%eax
801026df:	83 e0 0f             	and    $0xf,%eax
801026e2:	09 d0                	or     %edx,%eax
801026e4:	83 c8 e0             	or     $0xffffffe0,%eax
801026e7:	0f b6 c0             	movzbl %al,%eax
801026ea:	83 ec 08             	sub    $0x8,%esp
801026ed:	50                   	push   %eax
801026ee:	68 f6 01 00 00       	push   $0x1f6
801026f3:	e8 fd fd ff ff       	call   801024f5 <outb>
801026f8:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
801026fb:	8b 45 08             	mov    0x8(%ebp),%eax
801026fe:	8b 00                	mov    (%eax),%eax
80102700:	83 e0 04             	and    $0x4,%eax
80102703:	85 c0                	test   %eax,%eax
80102705:	74 30                	je     80102737 <idestart+0x10d>
    outb(0x1f7, IDE_CMD_WRITE);
80102707:	83 ec 08             	sub    $0x8,%esp
8010270a:	6a 30                	push   $0x30
8010270c:	68 f7 01 00 00       	push   $0x1f7
80102711:	e8 df fd ff ff       	call   801024f5 <outb>
80102716:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, 512/4);
80102719:	8b 45 08             	mov    0x8(%ebp),%eax
8010271c:	83 c0 18             	add    $0x18,%eax
8010271f:	83 ec 04             	sub    $0x4,%esp
80102722:	68 80 00 00 00       	push   $0x80
80102727:	50                   	push   %eax
80102728:	68 f0 01 00 00       	push   $0x1f0
8010272d:	e8 e1 fd ff ff       	call   80102513 <outsl>
80102732:	83 c4 10             	add    $0x10,%esp
80102735:	eb 12                	jmp    80102749 <idestart+0x11f>
  } else {
    outb(0x1f7, IDE_CMD_READ);
80102737:	83 ec 08             	sub    $0x8,%esp
8010273a:	6a 20                	push   $0x20
8010273c:	68 f7 01 00 00       	push   $0x1f7
80102741:	e8 af fd ff ff       	call   801024f5 <outb>
80102746:	83 c4 10             	add    $0x10,%esp
  }
}
80102749:	c9                   	leave  
8010274a:	c3                   	ret    

8010274b <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
8010274b:	55                   	push   %ebp
8010274c:	89 e5                	mov    %esp,%ebp
8010274e:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102751:	83 ec 0c             	sub    $0xc,%esp
80102754:	68 20 b6 10 80       	push   $0x8010b620
80102759:	e8 98 23 00 00       	call   80104af6 <acquire>
8010275e:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
80102761:	a1 54 b6 10 80       	mov    0x8010b654,%eax
80102766:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102769:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010276d:	75 15                	jne    80102784 <ideintr+0x39>
    release(&idelock);
8010276f:	83 ec 0c             	sub    $0xc,%esp
80102772:	68 20 b6 10 80       	push   $0x8010b620
80102777:	e8 e0 23 00 00       	call   80104b5c <release>
8010277c:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
8010277f:	e9 9a 00 00 00       	jmp    8010281e <ideintr+0xd3>
  }
  idequeue = b->qnext;
80102784:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102787:	8b 40 14             	mov    0x14(%eax),%eax
8010278a:	a3 54 b6 10 80       	mov    %eax,0x8010b654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010278f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102792:	8b 00                	mov    (%eax),%eax
80102794:	83 e0 04             	and    $0x4,%eax
80102797:	85 c0                	test   %eax,%eax
80102799:	75 2d                	jne    801027c8 <ideintr+0x7d>
8010279b:	83 ec 0c             	sub    $0xc,%esp
8010279e:	6a 01                	push   $0x1
801027a0:	e8 93 fd ff ff       	call   80102538 <idewait>
801027a5:	83 c4 10             	add    $0x10,%esp
801027a8:	85 c0                	test   %eax,%eax
801027aa:	78 1c                	js     801027c8 <ideintr+0x7d>
    insl(0x1f0, b->data, 512/4);
801027ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027af:	83 c0 18             	add    $0x18,%eax
801027b2:	83 ec 04             	sub    $0x4,%esp
801027b5:	68 80 00 00 00       	push   $0x80
801027ba:	50                   	push   %eax
801027bb:	68 f0 01 00 00       	push   $0x1f0
801027c0:	e8 0b fd ff ff       	call   801024d0 <insl>
801027c5:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027cb:	8b 00                	mov    (%eax),%eax
801027cd:	83 c8 02             	or     $0x2,%eax
801027d0:	89 c2                	mov    %eax,%edx
801027d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027d5:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
801027d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027da:	8b 00                	mov    (%eax),%eax
801027dc:	83 e0 fb             	and    $0xfffffffb,%eax
801027df:	89 c2                	mov    %eax,%edx
801027e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027e4:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801027e6:	83 ec 0c             	sub    $0xc,%esp
801027e9:	ff 75 f4             	pushl  -0xc(%ebp)
801027ec:	e8 00 21 00 00       	call   801048f1 <wakeup>
801027f1:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
801027f4:	a1 54 b6 10 80       	mov    0x8010b654,%eax
801027f9:	85 c0                	test   %eax,%eax
801027fb:	74 11                	je     8010280e <ideintr+0xc3>
    idestart(idequeue);
801027fd:	a1 54 b6 10 80       	mov    0x8010b654,%eax
80102802:	83 ec 0c             	sub    $0xc,%esp
80102805:	50                   	push   %eax
80102806:	e8 1f fe ff ff       	call   8010262a <idestart>
8010280b:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
8010280e:	83 ec 0c             	sub    $0xc,%esp
80102811:	68 20 b6 10 80       	push   $0x8010b620
80102816:	e8 41 23 00 00       	call   80104b5c <release>
8010281b:	83 c4 10             	add    $0x10,%esp
}
8010281e:	c9                   	leave  
8010281f:	c3                   	ret    

80102820 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102820:	55                   	push   %ebp
80102821:	89 e5                	mov    %esp,%ebp
80102823:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102826:	8b 45 08             	mov    0x8(%ebp),%eax
80102829:	8b 00                	mov    (%eax),%eax
8010282b:	83 e0 01             	and    $0x1,%eax
8010282e:	85 c0                	test   %eax,%eax
80102830:	75 0d                	jne    8010283f <iderw+0x1f>
    panic("iderw: buf not busy");
80102832:	83 ec 0c             	sub    $0xc,%esp
80102835:	68 35 84 10 80       	push   $0x80108435
8010283a:	e8 1d dd ff ff       	call   8010055c <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010283f:	8b 45 08             	mov    0x8(%ebp),%eax
80102842:	8b 00                	mov    (%eax),%eax
80102844:	83 e0 06             	and    $0x6,%eax
80102847:	83 f8 02             	cmp    $0x2,%eax
8010284a:	75 0d                	jne    80102859 <iderw+0x39>
    panic("iderw: nothing to do");
8010284c:	83 ec 0c             	sub    $0xc,%esp
8010284f:	68 49 84 10 80       	push   $0x80108449
80102854:	e8 03 dd ff ff       	call   8010055c <panic>
  if(b->dev != 0 && !havedisk1)
80102859:	8b 45 08             	mov    0x8(%ebp),%eax
8010285c:	8b 40 04             	mov    0x4(%eax),%eax
8010285f:	85 c0                	test   %eax,%eax
80102861:	74 16                	je     80102879 <iderw+0x59>
80102863:	a1 58 b6 10 80       	mov    0x8010b658,%eax
80102868:	85 c0                	test   %eax,%eax
8010286a:	75 0d                	jne    80102879 <iderw+0x59>
    panic("iderw: ide disk 1 not present");
8010286c:	83 ec 0c             	sub    $0xc,%esp
8010286f:	68 5e 84 10 80       	push   $0x8010845e
80102874:	e8 e3 dc ff ff       	call   8010055c <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102879:	83 ec 0c             	sub    $0xc,%esp
8010287c:	68 20 b6 10 80       	push   $0x8010b620
80102881:	e8 70 22 00 00       	call   80104af6 <acquire>
80102886:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102889:	8b 45 08             	mov    0x8(%ebp),%eax
8010288c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102893:	c7 45 f4 54 b6 10 80 	movl   $0x8010b654,-0xc(%ebp)
8010289a:	eb 0b                	jmp    801028a7 <iderw+0x87>
8010289c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010289f:	8b 00                	mov    (%eax),%eax
801028a1:	83 c0 14             	add    $0x14,%eax
801028a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028aa:	8b 00                	mov    (%eax),%eax
801028ac:	85 c0                	test   %eax,%eax
801028ae:	75 ec                	jne    8010289c <iderw+0x7c>
    ;
  *pp = b;
801028b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028b3:	8b 55 08             	mov    0x8(%ebp),%edx
801028b6:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
801028b8:	a1 54 b6 10 80       	mov    0x8010b654,%eax
801028bd:	3b 45 08             	cmp    0x8(%ebp),%eax
801028c0:	75 0e                	jne    801028d0 <iderw+0xb0>
    idestart(b);
801028c2:	83 ec 0c             	sub    $0xc,%esp
801028c5:	ff 75 08             	pushl  0x8(%ebp)
801028c8:	e8 5d fd ff ff       	call   8010262a <idestart>
801028cd:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801028d0:	eb 13                	jmp    801028e5 <iderw+0xc5>
    sleep(b, &idelock);
801028d2:	83 ec 08             	sub    $0x8,%esp
801028d5:	68 20 b6 10 80       	push   $0x8010b620
801028da:	ff 75 08             	pushl  0x8(%ebp)
801028dd:	e8 26 1f 00 00       	call   80104808 <sleep>
801028e2:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801028e5:	8b 45 08             	mov    0x8(%ebp),%eax
801028e8:	8b 00                	mov    (%eax),%eax
801028ea:	83 e0 06             	and    $0x6,%eax
801028ed:	83 f8 02             	cmp    $0x2,%eax
801028f0:	75 e0                	jne    801028d2 <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
801028f2:	83 ec 0c             	sub    $0xc,%esp
801028f5:	68 20 b6 10 80       	push   $0x8010b620
801028fa:	e8 5d 22 00 00       	call   80104b5c <release>
801028ff:	83 c4 10             	add    $0x10,%esp
}
80102902:	c9                   	leave  
80102903:	c3                   	ret    

80102904 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102904:	55                   	push   %ebp
80102905:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102907:	a1 94 f8 10 80       	mov    0x8010f894,%eax
8010290c:	8b 55 08             	mov    0x8(%ebp),%edx
8010290f:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102911:	a1 94 f8 10 80       	mov    0x8010f894,%eax
80102916:	8b 40 10             	mov    0x10(%eax),%eax
}
80102919:	5d                   	pop    %ebp
8010291a:	c3                   	ret    

8010291b <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
8010291b:	55                   	push   %ebp
8010291c:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010291e:	a1 94 f8 10 80       	mov    0x8010f894,%eax
80102923:	8b 55 08             	mov    0x8(%ebp),%edx
80102926:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102928:	a1 94 f8 10 80       	mov    0x8010f894,%eax
8010292d:	8b 55 0c             	mov    0xc(%ebp),%edx
80102930:	89 50 10             	mov    %edx,0x10(%eax)
}
80102933:	5d                   	pop    %ebp
80102934:	c3                   	ret    

80102935 <ioapicinit>:

void
ioapicinit(void)
{
80102935:	55                   	push   %ebp
80102936:	89 e5                	mov    %esp,%ebp
80102938:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
8010293b:	a1 84 f9 10 80       	mov    0x8010f984,%eax
80102940:	85 c0                	test   %eax,%eax
80102942:	75 05                	jne    80102949 <ioapicinit+0x14>
    return;
80102944:	e9 9c 00 00 00       	jmp    801029e5 <ioapicinit+0xb0>

  ioapic = (volatile struct ioapic*)IOAPIC;
80102949:	c7 05 94 f8 10 80 00 	movl   $0xfec00000,0x8010f894
80102950:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102953:	6a 01                	push   $0x1
80102955:	e8 aa ff ff ff       	call   80102904 <ioapicread>
8010295a:	83 c4 04             	add    $0x4,%esp
8010295d:	c1 e8 10             	shr    $0x10,%eax
80102960:	25 ff 00 00 00       	and    $0xff,%eax
80102965:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102968:	6a 00                	push   $0x0
8010296a:	e8 95 ff ff ff       	call   80102904 <ioapicread>
8010296f:	83 c4 04             	add    $0x4,%esp
80102972:	c1 e8 18             	shr    $0x18,%eax
80102975:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102978:	0f b6 05 80 f9 10 80 	movzbl 0x8010f980,%eax
8010297f:	0f b6 c0             	movzbl %al,%eax
80102982:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102985:	74 10                	je     80102997 <ioapicinit+0x62>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102987:	83 ec 0c             	sub    $0xc,%esp
8010298a:	68 7c 84 10 80       	push   $0x8010847c
8010298f:	e8 2b da ff ff       	call   801003bf <cprintf>
80102994:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102997:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010299e:	eb 3d                	jmp    801029dd <ioapicinit+0xa8>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801029a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029a3:	83 c0 20             	add    $0x20,%eax
801029a6:	0d 00 00 01 00       	or     $0x10000,%eax
801029ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
801029ae:	83 c2 08             	add    $0x8,%edx
801029b1:	01 d2                	add    %edx,%edx
801029b3:	83 ec 08             	sub    $0x8,%esp
801029b6:	50                   	push   %eax
801029b7:	52                   	push   %edx
801029b8:	e8 5e ff ff ff       	call   8010291b <ioapicwrite>
801029bd:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
801029c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029c3:	83 c0 08             	add    $0x8,%eax
801029c6:	01 c0                	add    %eax,%eax
801029c8:	83 c0 01             	add    $0x1,%eax
801029cb:	83 ec 08             	sub    $0x8,%esp
801029ce:	6a 00                	push   $0x0
801029d0:	50                   	push   %eax
801029d1:	e8 45 ff ff ff       	call   8010291b <ioapicwrite>
801029d6:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801029d9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801029dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029e0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801029e3:	7e bb                	jle    801029a0 <ioapicinit+0x6b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801029e5:	c9                   	leave  
801029e6:	c3                   	ret    

801029e7 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801029e7:	55                   	push   %ebp
801029e8:	89 e5                	mov    %esp,%ebp
  if(!ismp)
801029ea:	a1 84 f9 10 80       	mov    0x8010f984,%eax
801029ef:	85 c0                	test   %eax,%eax
801029f1:	75 02                	jne    801029f5 <ioapicenable+0xe>
    return;
801029f3:	eb 33                	jmp    80102a28 <ioapicenable+0x41>

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801029f5:	8b 45 08             	mov    0x8(%ebp),%eax
801029f8:	83 c0 20             	add    $0x20,%eax
801029fb:	8b 55 08             	mov    0x8(%ebp),%edx
801029fe:	83 c2 08             	add    $0x8,%edx
80102a01:	01 d2                	add    %edx,%edx
80102a03:	50                   	push   %eax
80102a04:	52                   	push   %edx
80102a05:	e8 11 ff ff ff       	call   8010291b <ioapicwrite>
80102a0a:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a0d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a10:	c1 e0 18             	shl    $0x18,%eax
80102a13:	8b 55 08             	mov    0x8(%ebp),%edx
80102a16:	83 c2 08             	add    $0x8,%edx
80102a19:	01 d2                	add    %edx,%edx
80102a1b:	83 c2 01             	add    $0x1,%edx
80102a1e:	50                   	push   %eax
80102a1f:	52                   	push   %edx
80102a20:	e8 f6 fe ff ff       	call   8010291b <ioapicwrite>
80102a25:	83 c4 08             	add    $0x8,%esp
}
80102a28:	c9                   	leave  
80102a29:	c3                   	ret    

80102a2a <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102a2a:	55                   	push   %ebp
80102a2b:	89 e5                	mov    %esp,%ebp
80102a2d:	8b 45 08             	mov    0x8(%ebp),%eax
80102a30:	05 00 00 00 80       	add    $0x80000000,%eax
80102a35:	5d                   	pop    %ebp
80102a36:	c3                   	ret    

80102a37 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102a37:	55                   	push   %ebp
80102a38:	89 e5                	mov    %esp,%ebp
80102a3a:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102a3d:	83 ec 08             	sub    $0x8,%esp
80102a40:	68 ae 84 10 80       	push   $0x801084ae
80102a45:	68 a0 f8 10 80       	push   $0x8010f8a0
80102a4a:	e8 86 20 00 00       	call   80104ad5 <initlock>
80102a4f:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102a52:	c7 05 d4 f8 10 80 00 	movl   $0x0,0x8010f8d4
80102a59:	00 00 00 
  freerange(vstart, vend);
80102a5c:	83 ec 08             	sub    $0x8,%esp
80102a5f:	ff 75 0c             	pushl  0xc(%ebp)
80102a62:	ff 75 08             	pushl  0x8(%ebp)
80102a65:	e8 28 00 00 00       	call   80102a92 <freerange>
80102a6a:	83 c4 10             	add    $0x10,%esp
}
80102a6d:	c9                   	leave  
80102a6e:	c3                   	ret    

80102a6f <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102a6f:	55                   	push   %ebp
80102a70:	89 e5                	mov    %esp,%ebp
80102a72:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102a75:	83 ec 08             	sub    $0x8,%esp
80102a78:	ff 75 0c             	pushl  0xc(%ebp)
80102a7b:	ff 75 08             	pushl  0x8(%ebp)
80102a7e:	e8 0f 00 00 00       	call   80102a92 <freerange>
80102a83:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102a86:	c7 05 d4 f8 10 80 01 	movl   $0x1,0x8010f8d4
80102a8d:	00 00 00 
}
80102a90:	c9                   	leave  
80102a91:	c3                   	ret    

80102a92 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102a92:	55                   	push   %ebp
80102a93:	89 e5                	mov    %esp,%ebp
80102a95:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102a98:	8b 45 08             	mov    0x8(%ebp),%eax
80102a9b:	05 ff 0f 00 00       	add    $0xfff,%eax
80102aa0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102aa5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102aa8:	eb 15                	jmp    80102abf <freerange+0x2d>
    kfree(p);
80102aaa:	83 ec 0c             	sub    $0xc,%esp
80102aad:	ff 75 f4             	pushl  -0xc(%ebp)
80102ab0:	e8 19 00 00 00       	call   80102ace <kfree>
80102ab5:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ab8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ac2:	05 00 10 00 00       	add    $0x1000,%eax
80102ac7:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102aca:	76 de                	jbe    80102aaa <freerange+0x18>
    kfree(p);
}
80102acc:	c9                   	leave  
80102acd:	c3                   	ret    

80102ace <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102ace:	55                   	push   %ebp
80102acf:	89 e5                	mov    %esp,%ebp
80102ad1:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102ad4:	8b 45 08             	mov    0x8(%ebp),%eax
80102ad7:	25 ff 0f 00 00       	and    $0xfff,%eax
80102adc:	85 c0                	test   %eax,%eax
80102ade:	75 1b                	jne    80102afb <kfree+0x2d>
80102ae0:	81 7d 08 9c 27 11 80 	cmpl   $0x8011279c,0x8(%ebp)
80102ae7:	72 12                	jb     80102afb <kfree+0x2d>
80102ae9:	ff 75 08             	pushl  0x8(%ebp)
80102aec:	e8 39 ff ff ff       	call   80102a2a <v2p>
80102af1:	83 c4 04             	add    $0x4,%esp
80102af4:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102af9:	76 0d                	jbe    80102b08 <kfree+0x3a>
    panic("kfree");
80102afb:	83 ec 0c             	sub    $0xc,%esp
80102afe:	68 b3 84 10 80       	push   $0x801084b3
80102b03:	e8 54 da ff ff       	call   8010055c <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b08:	83 ec 04             	sub    $0x4,%esp
80102b0b:	68 00 10 00 00       	push   $0x1000
80102b10:	6a 01                	push   $0x1
80102b12:	ff 75 08             	pushl  0x8(%ebp)
80102b15:	e8 38 22 00 00       	call   80104d52 <memset>
80102b1a:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102b1d:	a1 d4 f8 10 80       	mov    0x8010f8d4,%eax
80102b22:	85 c0                	test   %eax,%eax
80102b24:	74 10                	je     80102b36 <kfree+0x68>
    acquire(&kmem.lock);
80102b26:	83 ec 0c             	sub    $0xc,%esp
80102b29:	68 a0 f8 10 80       	push   $0x8010f8a0
80102b2e:	e8 c3 1f 00 00       	call   80104af6 <acquire>
80102b33:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102b36:	8b 45 08             	mov    0x8(%ebp),%eax
80102b39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102b3c:	8b 15 d8 f8 10 80    	mov    0x8010f8d8,%edx
80102b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b45:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b4a:	a3 d8 f8 10 80       	mov    %eax,0x8010f8d8
  if(kmem.use_lock)
80102b4f:	a1 d4 f8 10 80       	mov    0x8010f8d4,%eax
80102b54:	85 c0                	test   %eax,%eax
80102b56:	74 10                	je     80102b68 <kfree+0x9a>
    release(&kmem.lock);
80102b58:	83 ec 0c             	sub    $0xc,%esp
80102b5b:	68 a0 f8 10 80       	push   $0x8010f8a0
80102b60:	e8 f7 1f 00 00       	call   80104b5c <release>
80102b65:	83 c4 10             	add    $0x10,%esp
}
80102b68:	c9                   	leave  
80102b69:	c3                   	ret    

80102b6a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102b6a:	55                   	push   %ebp
80102b6b:	89 e5                	mov    %esp,%ebp
80102b6d:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102b70:	a1 d4 f8 10 80       	mov    0x8010f8d4,%eax
80102b75:	85 c0                	test   %eax,%eax
80102b77:	74 10                	je     80102b89 <kalloc+0x1f>
    acquire(&kmem.lock);
80102b79:	83 ec 0c             	sub    $0xc,%esp
80102b7c:	68 a0 f8 10 80       	push   $0x8010f8a0
80102b81:	e8 70 1f 00 00       	call   80104af6 <acquire>
80102b86:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102b89:	a1 d8 f8 10 80       	mov    0x8010f8d8,%eax
80102b8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102b91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b95:	74 0a                	je     80102ba1 <kalloc+0x37>
    kmem.freelist = r->next;
80102b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b9a:	8b 00                	mov    (%eax),%eax
80102b9c:	a3 d8 f8 10 80       	mov    %eax,0x8010f8d8
  if(kmem.use_lock)
80102ba1:	a1 d4 f8 10 80       	mov    0x8010f8d4,%eax
80102ba6:	85 c0                	test   %eax,%eax
80102ba8:	74 10                	je     80102bba <kalloc+0x50>
    release(&kmem.lock);
80102baa:	83 ec 0c             	sub    $0xc,%esp
80102bad:	68 a0 f8 10 80       	push   $0x8010f8a0
80102bb2:	e8 a5 1f 00 00       	call   80104b5c <release>
80102bb7:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102bbd:	c9                   	leave  
80102bbe:	c3                   	ret    

80102bbf <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102bbf:	55                   	push   %ebp
80102bc0:	89 e5                	mov    %esp,%ebp
80102bc2:	83 ec 14             	sub    $0x14,%esp
80102bc5:	8b 45 08             	mov    0x8(%ebp),%eax
80102bc8:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bcc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102bd0:	89 c2                	mov    %eax,%edx
80102bd2:	ec                   	in     (%dx),%al
80102bd3:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102bd6:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102bda:	c9                   	leave  
80102bdb:	c3                   	ret    

80102bdc <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102bdc:	55                   	push   %ebp
80102bdd:	89 e5                	mov    %esp,%ebp
80102bdf:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102be2:	6a 64                	push   $0x64
80102be4:	e8 d6 ff ff ff       	call   80102bbf <inb>
80102be9:	83 c4 04             	add    $0x4,%esp
80102bec:	0f b6 c0             	movzbl %al,%eax
80102bef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bf5:	83 e0 01             	and    $0x1,%eax
80102bf8:	85 c0                	test   %eax,%eax
80102bfa:	75 0a                	jne    80102c06 <kbdgetc+0x2a>
    return -1;
80102bfc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102c01:	e9 23 01 00 00       	jmp    80102d29 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102c06:	6a 60                	push   $0x60
80102c08:	e8 b2 ff ff ff       	call   80102bbf <inb>
80102c0d:	83 c4 04             	add    $0x4,%esp
80102c10:	0f b6 c0             	movzbl %al,%eax
80102c13:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102c16:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102c1d:	75 17                	jne    80102c36 <kbdgetc+0x5a>
    shift |= E0ESC;
80102c1f:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c24:	83 c8 40             	or     $0x40,%eax
80102c27:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
    return 0;
80102c2c:	b8 00 00 00 00       	mov    $0x0,%eax
80102c31:	e9 f3 00 00 00       	jmp    80102d29 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102c36:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c39:	25 80 00 00 00       	and    $0x80,%eax
80102c3e:	85 c0                	test   %eax,%eax
80102c40:	74 45                	je     80102c87 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102c42:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c47:	83 e0 40             	and    $0x40,%eax
80102c4a:	85 c0                	test   %eax,%eax
80102c4c:	75 08                	jne    80102c56 <kbdgetc+0x7a>
80102c4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c51:	83 e0 7f             	and    $0x7f,%eax
80102c54:	eb 03                	jmp    80102c59 <kbdgetc+0x7d>
80102c56:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c59:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102c5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c5f:	05 40 90 10 80       	add    $0x80109040,%eax
80102c64:	0f b6 00             	movzbl (%eax),%eax
80102c67:	83 c8 40             	or     $0x40,%eax
80102c6a:	0f b6 c0             	movzbl %al,%eax
80102c6d:	f7 d0                	not    %eax
80102c6f:	89 c2                	mov    %eax,%edx
80102c71:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c76:	21 d0                	and    %edx,%eax
80102c78:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
    return 0;
80102c7d:	b8 00 00 00 00       	mov    $0x0,%eax
80102c82:	e9 a2 00 00 00       	jmp    80102d29 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102c87:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c8c:	83 e0 40             	and    $0x40,%eax
80102c8f:	85 c0                	test   %eax,%eax
80102c91:	74 14                	je     80102ca7 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102c93:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102c9a:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c9f:	83 e0 bf             	and    $0xffffffbf,%eax
80102ca2:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  }

  shift |= shiftcode[data];
80102ca7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102caa:	05 40 90 10 80       	add    $0x80109040,%eax
80102caf:	0f b6 00             	movzbl (%eax),%eax
80102cb2:	0f b6 d0             	movzbl %al,%edx
80102cb5:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102cba:	09 d0                	or     %edx,%eax
80102cbc:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  shift ^= togglecode[data];
80102cc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cc4:	05 40 91 10 80       	add    $0x80109140,%eax
80102cc9:	0f b6 00             	movzbl (%eax),%eax
80102ccc:	0f b6 d0             	movzbl %al,%edx
80102ccf:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102cd4:	31 d0                	xor    %edx,%eax
80102cd6:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102cdb:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102ce0:	83 e0 03             	and    $0x3,%eax
80102ce3:	8b 14 85 40 95 10 80 	mov    -0x7fef6ac0(,%eax,4),%edx
80102cea:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ced:	01 d0                	add    %edx,%eax
80102cef:	0f b6 00             	movzbl (%eax),%eax
80102cf2:	0f b6 c0             	movzbl %al,%eax
80102cf5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102cf8:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102cfd:	83 e0 08             	and    $0x8,%eax
80102d00:	85 c0                	test   %eax,%eax
80102d02:	74 22                	je     80102d26 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102d04:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102d08:	76 0c                	jbe    80102d16 <kbdgetc+0x13a>
80102d0a:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102d0e:	77 06                	ja     80102d16 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102d10:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102d14:	eb 10                	jmp    80102d26 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102d16:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102d1a:	76 0a                	jbe    80102d26 <kbdgetc+0x14a>
80102d1c:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102d20:	77 04                	ja     80102d26 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102d22:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102d26:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102d29:	c9                   	leave  
80102d2a:	c3                   	ret    

80102d2b <kbdintr>:

void
kbdintr(void)
{
80102d2b:	55                   	push   %ebp
80102d2c:	89 e5                	mov    %esp,%ebp
80102d2e:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102d31:	83 ec 0c             	sub    $0xc,%esp
80102d34:	68 dc 2b 10 80       	push   $0x80102bdc
80102d39:	e8 94 da ff ff       	call   801007d2 <consoleintr>
80102d3e:	83 c4 10             	add    $0x10,%esp
}
80102d41:	c9                   	leave  
80102d42:	c3                   	ret    

80102d43 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102d43:	55                   	push   %ebp
80102d44:	89 e5                	mov    %esp,%ebp
80102d46:	83 ec 08             	sub    $0x8,%esp
80102d49:	8b 55 08             	mov    0x8(%ebp),%edx
80102d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d4f:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102d53:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d56:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102d5a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102d5e:	ee                   	out    %al,(%dx)
}
80102d5f:	c9                   	leave  
80102d60:	c3                   	ret    

80102d61 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102d61:	55                   	push   %ebp
80102d62:	89 e5                	mov    %esp,%ebp
80102d64:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102d67:	9c                   	pushf  
80102d68:	58                   	pop    %eax
80102d69:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102d6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102d6f:	c9                   	leave  
80102d70:	c3                   	ret    

80102d71 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102d71:	55                   	push   %ebp
80102d72:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102d74:	a1 dc f8 10 80       	mov    0x8010f8dc,%eax
80102d79:	8b 55 08             	mov    0x8(%ebp),%edx
80102d7c:	c1 e2 02             	shl    $0x2,%edx
80102d7f:	01 c2                	add    %eax,%edx
80102d81:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d84:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102d86:	a1 dc f8 10 80       	mov    0x8010f8dc,%eax
80102d8b:	83 c0 20             	add    $0x20,%eax
80102d8e:	8b 00                	mov    (%eax),%eax
}
80102d90:	5d                   	pop    %ebp
80102d91:	c3                   	ret    

80102d92 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102d92:	55                   	push   %ebp
80102d93:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102d95:	a1 dc f8 10 80       	mov    0x8010f8dc,%eax
80102d9a:	85 c0                	test   %eax,%eax
80102d9c:	75 05                	jne    80102da3 <lapicinit+0x11>
    return;
80102d9e:	e9 09 01 00 00       	jmp    80102eac <lapicinit+0x11a>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102da3:	68 3f 01 00 00       	push   $0x13f
80102da8:	6a 3c                	push   $0x3c
80102daa:	e8 c2 ff ff ff       	call   80102d71 <lapicw>
80102daf:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102db2:	6a 0b                	push   $0xb
80102db4:	68 f8 00 00 00       	push   $0xf8
80102db9:	e8 b3 ff ff ff       	call   80102d71 <lapicw>
80102dbe:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102dc1:	68 20 00 02 00       	push   $0x20020
80102dc6:	68 c8 00 00 00       	push   $0xc8
80102dcb:	e8 a1 ff ff ff       	call   80102d71 <lapicw>
80102dd0:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
80102dd3:	68 80 96 98 00       	push   $0x989680
80102dd8:	68 e0 00 00 00       	push   $0xe0
80102ddd:	e8 8f ff ff ff       	call   80102d71 <lapicw>
80102de2:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102de5:	68 00 00 01 00       	push   $0x10000
80102dea:	68 d4 00 00 00       	push   $0xd4
80102def:	e8 7d ff ff ff       	call   80102d71 <lapicw>
80102df4:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102df7:	68 00 00 01 00       	push   $0x10000
80102dfc:	68 d8 00 00 00       	push   $0xd8
80102e01:	e8 6b ff ff ff       	call   80102d71 <lapicw>
80102e06:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102e09:	a1 dc f8 10 80       	mov    0x8010f8dc,%eax
80102e0e:	83 c0 30             	add    $0x30,%eax
80102e11:	8b 00                	mov    (%eax),%eax
80102e13:	c1 e8 10             	shr    $0x10,%eax
80102e16:	0f b6 c0             	movzbl %al,%eax
80102e19:	83 f8 03             	cmp    $0x3,%eax
80102e1c:	76 12                	jbe    80102e30 <lapicinit+0x9e>
    lapicw(PCINT, MASKED);
80102e1e:	68 00 00 01 00       	push   $0x10000
80102e23:	68 d0 00 00 00       	push   $0xd0
80102e28:	e8 44 ff ff ff       	call   80102d71 <lapicw>
80102e2d:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102e30:	6a 33                	push   $0x33
80102e32:	68 dc 00 00 00       	push   $0xdc
80102e37:	e8 35 ff ff ff       	call   80102d71 <lapicw>
80102e3c:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102e3f:	6a 00                	push   $0x0
80102e41:	68 a0 00 00 00       	push   $0xa0
80102e46:	e8 26 ff ff ff       	call   80102d71 <lapicw>
80102e4b:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102e4e:	6a 00                	push   $0x0
80102e50:	68 a0 00 00 00       	push   $0xa0
80102e55:	e8 17 ff ff ff       	call   80102d71 <lapicw>
80102e5a:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102e5d:	6a 00                	push   $0x0
80102e5f:	6a 2c                	push   $0x2c
80102e61:	e8 0b ff ff ff       	call   80102d71 <lapicw>
80102e66:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102e69:	6a 00                	push   $0x0
80102e6b:	68 c4 00 00 00       	push   $0xc4
80102e70:	e8 fc fe ff ff       	call   80102d71 <lapicw>
80102e75:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102e78:	68 00 85 08 00       	push   $0x88500
80102e7d:	68 c0 00 00 00       	push   $0xc0
80102e82:	e8 ea fe ff ff       	call   80102d71 <lapicw>
80102e87:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102e8a:	90                   	nop
80102e8b:	a1 dc f8 10 80       	mov    0x8010f8dc,%eax
80102e90:	05 00 03 00 00       	add    $0x300,%eax
80102e95:	8b 00                	mov    (%eax),%eax
80102e97:	25 00 10 00 00       	and    $0x1000,%eax
80102e9c:	85 c0                	test   %eax,%eax
80102e9e:	75 eb                	jne    80102e8b <lapicinit+0xf9>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102ea0:	6a 00                	push   $0x0
80102ea2:	6a 20                	push   $0x20
80102ea4:	e8 c8 fe ff ff       	call   80102d71 <lapicw>
80102ea9:	83 c4 08             	add    $0x8,%esp
}
80102eac:	c9                   	leave  
80102ead:	c3                   	ret    

80102eae <cpunum>:

int
cpunum(void)
{
80102eae:	55                   	push   %ebp
80102eaf:	89 e5                	mov    %esp,%ebp
80102eb1:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102eb4:	e8 a8 fe ff ff       	call   80102d61 <readeflags>
80102eb9:	25 00 02 00 00       	and    $0x200,%eax
80102ebe:	85 c0                	test   %eax,%eax
80102ec0:	74 26                	je     80102ee8 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
80102ec2:	a1 60 b6 10 80       	mov    0x8010b660,%eax
80102ec7:	8d 50 01             	lea    0x1(%eax),%edx
80102eca:	89 15 60 b6 10 80    	mov    %edx,0x8010b660
80102ed0:	85 c0                	test   %eax,%eax
80102ed2:	75 14                	jne    80102ee8 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
80102ed4:	8b 45 04             	mov    0x4(%ebp),%eax
80102ed7:	83 ec 08             	sub    $0x8,%esp
80102eda:	50                   	push   %eax
80102edb:	68 bc 84 10 80       	push   $0x801084bc
80102ee0:	e8 da d4 ff ff       	call   801003bf <cprintf>
80102ee5:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80102ee8:	a1 dc f8 10 80       	mov    0x8010f8dc,%eax
80102eed:	85 c0                	test   %eax,%eax
80102eef:	74 0f                	je     80102f00 <cpunum+0x52>
    return lapic[ID]>>24;
80102ef1:	a1 dc f8 10 80       	mov    0x8010f8dc,%eax
80102ef6:	83 c0 20             	add    $0x20,%eax
80102ef9:	8b 00                	mov    (%eax),%eax
80102efb:	c1 e8 18             	shr    $0x18,%eax
80102efe:	eb 05                	jmp    80102f05 <cpunum+0x57>
  return 0;
80102f00:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102f05:	c9                   	leave  
80102f06:	c3                   	ret    

80102f07 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102f07:	55                   	push   %ebp
80102f08:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102f0a:	a1 dc f8 10 80       	mov    0x8010f8dc,%eax
80102f0f:	85 c0                	test   %eax,%eax
80102f11:	74 0c                	je     80102f1f <lapiceoi+0x18>
    lapicw(EOI, 0);
80102f13:	6a 00                	push   $0x0
80102f15:	6a 2c                	push   $0x2c
80102f17:	e8 55 fe ff ff       	call   80102d71 <lapicw>
80102f1c:	83 c4 08             	add    $0x8,%esp
}
80102f1f:	c9                   	leave  
80102f20:	c3                   	ret    

80102f21 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f21:	55                   	push   %ebp
80102f22:	89 e5                	mov    %esp,%ebp
}
80102f24:	5d                   	pop    %ebp
80102f25:	c3                   	ret    

80102f26 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f26:	55                   	push   %ebp
80102f27:	89 e5                	mov    %esp,%ebp
80102f29:	83 ec 14             	sub    $0x14,%esp
80102f2c:	8b 45 08             	mov    0x8(%ebp),%eax
80102f2f:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
80102f32:	6a 0f                	push   $0xf
80102f34:	6a 70                	push   $0x70
80102f36:	e8 08 fe ff ff       	call   80102d43 <outb>
80102f3b:	83 c4 08             	add    $0x8,%esp
  outb(IO_RTC+1, 0x0A);
80102f3e:	6a 0a                	push   $0xa
80102f40:	6a 71                	push   $0x71
80102f42:	e8 fc fd ff ff       	call   80102d43 <outb>
80102f47:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102f4a:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102f51:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f54:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102f59:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f5c:	8d 50 02             	lea    0x2(%eax),%edx
80102f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f62:	c1 e8 04             	shr    $0x4,%eax
80102f65:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102f68:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102f6c:	c1 e0 18             	shl    $0x18,%eax
80102f6f:	50                   	push   %eax
80102f70:	68 c4 00 00 00       	push   $0xc4
80102f75:	e8 f7 fd ff ff       	call   80102d71 <lapicw>
80102f7a:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102f7d:	68 00 c5 00 00       	push   $0xc500
80102f82:	68 c0 00 00 00       	push   $0xc0
80102f87:	e8 e5 fd ff ff       	call   80102d71 <lapicw>
80102f8c:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80102f8f:	68 c8 00 00 00       	push   $0xc8
80102f94:	e8 88 ff ff ff       	call   80102f21 <microdelay>
80102f99:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80102f9c:	68 00 85 00 00       	push   $0x8500
80102fa1:	68 c0 00 00 00       	push   $0xc0
80102fa6:	e8 c6 fd ff ff       	call   80102d71 <lapicw>
80102fab:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102fae:	6a 64                	push   $0x64
80102fb0:	e8 6c ff ff ff       	call   80102f21 <microdelay>
80102fb5:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102fb8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80102fbf:	eb 3d                	jmp    80102ffe <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
80102fc1:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102fc5:	c1 e0 18             	shl    $0x18,%eax
80102fc8:	50                   	push   %eax
80102fc9:	68 c4 00 00 00       	push   $0xc4
80102fce:	e8 9e fd ff ff       	call   80102d71 <lapicw>
80102fd3:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80102fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
80102fd9:	c1 e8 0c             	shr    $0xc,%eax
80102fdc:	80 cc 06             	or     $0x6,%ah
80102fdf:	50                   	push   %eax
80102fe0:	68 c0 00 00 00       	push   $0xc0
80102fe5:	e8 87 fd ff ff       	call   80102d71 <lapicw>
80102fea:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
80102fed:	68 c8 00 00 00       	push   $0xc8
80102ff2:	e8 2a ff ff ff       	call   80102f21 <microdelay>
80102ff7:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102ffa:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80102ffe:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103002:	7e bd                	jle    80102fc1 <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80103004:	c9                   	leave  
80103005:	c3                   	ret    

80103006 <initlog>:

static void recover_from_log(void);

void
initlog(void)
{
80103006:	55                   	push   %ebp
80103007:	89 e5                	mov    %esp,%ebp
80103009:	83 ec 18             	sub    $0x18,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010300c:	83 ec 08             	sub    $0x8,%esp
8010300f:	68 e8 84 10 80       	push   $0x801084e8
80103014:	68 00 f9 10 80       	push   $0x8010f900
80103019:	e8 b7 1a 00 00       	call   80104ad5 <initlock>
8010301e:	83 c4 10             	add    $0x10,%esp
  readsb(ROOTDEV, &sb);
80103021:	83 ec 08             	sub    $0x8,%esp
80103024:	8d 45 e8             	lea    -0x18(%ebp),%eax
80103027:	50                   	push   %eax
80103028:	6a 01                	push   $0x1
8010302a:	e8 ff e2 ff ff       	call   8010132e <readsb>
8010302f:	83 c4 10             	add    $0x10,%esp
  log.start = sb.size - sb.nlog;
80103032:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103035:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103038:	29 c2                	sub    %eax,%edx
8010303a:	89 d0                	mov    %edx,%eax
8010303c:	a3 34 f9 10 80       	mov    %eax,0x8010f934
  log.size = sb.nlog;
80103041:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103044:	a3 38 f9 10 80       	mov    %eax,0x8010f938
  log.dev = ROOTDEV;
80103049:	c7 05 40 f9 10 80 01 	movl   $0x1,0x8010f940
80103050:	00 00 00 
  recover_from_log();
80103053:	e8 ae 01 00 00       	call   80103206 <recover_from_log>
}
80103058:	c9                   	leave  
80103059:	c3                   	ret    

8010305a <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
8010305a:	55                   	push   %ebp
8010305b:	89 e5                	mov    %esp,%ebp
8010305d:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103060:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103067:	e9 95 00 00 00       	jmp    80103101 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
8010306c:	8b 15 34 f9 10 80    	mov    0x8010f934,%edx
80103072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103075:	01 d0                	add    %edx,%eax
80103077:	83 c0 01             	add    $0x1,%eax
8010307a:	89 c2                	mov    %eax,%edx
8010307c:	a1 40 f9 10 80       	mov    0x8010f940,%eax
80103081:	83 ec 08             	sub    $0x8,%esp
80103084:	52                   	push   %edx
80103085:	50                   	push   %eax
80103086:	e8 29 d1 ff ff       	call   801001b4 <bread>
8010308b:	83 c4 10             	add    $0x10,%esp
8010308e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
80103091:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103094:	83 c0 10             	add    $0x10,%eax
80103097:	8b 04 85 08 f9 10 80 	mov    -0x7fef06f8(,%eax,4),%eax
8010309e:	89 c2                	mov    %eax,%edx
801030a0:	a1 40 f9 10 80       	mov    0x8010f940,%eax
801030a5:	83 ec 08             	sub    $0x8,%esp
801030a8:	52                   	push   %edx
801030a9:	50                   	push   %eax
801030aa:	e8 05 d1 ff ff       	call   801001b4 <bread>
801030af:	83 c4 10             	add    $0x10,%esp
801030b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801030b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801030b8:	8d 50 18             	lea    0x18(%eax),%edx
801030bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801030be:	83 c0 18             	add    $0x18,%eax
801030c1:	83 ec 04             	sub    $0x4,%esp
801030c4:	68 00 02 00 00       	push   $0x200
801030c9:	52                   	push   %edx
801030ca:	50                   	push   %eax
801030cb:	e8 41 1d 00 00       	call   80104e11 <memmove>
801030d0:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
801030d3:	83 ec 0c             	sub    $0xc,%esp
801030d6:	ff 75 ec             	pushl  -0x14(%ebp)
801030d9:	e8 0f d1 ff ff       	call   801001ed <bwrite>
801030de:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
801030e1:	83 ec 0c             	sub    $0xc,%esp
801030e4:	ff 75 f0             	pushl  -0x10(%ebp)
801030e7:	e8 3f d1 ff ff       	call   8010022b <brelse>
801030ec:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
801030ef:	83 ec 0c             	sub    $0xc,%esp
801030f2:	ff 75 ec             	pushl  -0x14(%ebp)
801030f5:	e8 31 d1 ff ff       	call   8010022b <brelse>
801030fa:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801030fd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103101:	a1 44 f9 10 80       	mov    0x8010f944,%eax
80103106:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103109:	0f 8f 5d ff ff ff    	jg     8010306c <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
8010310f:	c9                   	leave  
80103110:	c3                   	ret    

80103111 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103111:	55                   	push   %ebp
80103112:	89 e5                	mov    %esp,%ebp
80103114:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103117:	a1 34 f9 10 80       	mov    0x8010f934,%eax
8010311c:	89 c2                	mov    %eax,%edx
8010311e:	a1 40 f9 10 80       	mov    0x8010f940,%eax
80103123:	83 ec 08             	sub    $0x8,%esp
80103126:	52                   	push   %edx
80103127:	50                   	push   %eax
80103128:	e8 87 d0 ff ff       	call   801001b4 <bread>
8010312d:	83 c4 10             	add    $0x10,%esp
80103130:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103133:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103136:	83 c0 18             	add    $0x18,%eax
80103139:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
8010313c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010313f:	8b 00                	mov    (%eax),%eax
80103141:	a3 44 f9 10 80       	mov    %eax,0x8010f944
  for (i = 0; i < log.lh.n; i++) {
80103146:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010314d:	eb 1b                	jmp    8010316a <read_head+0x59>
    log.lh.sector[i] = lh->sector[i];
8010314f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103152:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103155:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103159:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010315c:	83 c2 10             	add    $0x10,%edx
8010315f:	89 04 95 08 f9 10 80 	mov    %eax,-0x7fef06f8(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103166:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010316a:	a1 44 f9 10 80       	mov    0x8010f944,%eax
8010316f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103172:	7f db                	jg     8010314f <read_head+0x3e>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
80103174:	83 ec 0c             	sub    $0xc,%esp
80103177:	ff 75 f0             	pushl  -0x10(%ebp)
8010317a:	e8 ac d0 ff ff       	call   8010022b <brelse>
8010317f:	83 c4 10             	add    $0x10,%esp
}
80103182:	c9                   	leave  
80103183:	c3                   	ret    

80103184 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103184:	55                   	push   %ebp
80103185:	89 e5                	mov    %esp,%ebp
80103187:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
8010318a:	a1 34 f9 10 80       	mov    0x8010f934,%eax
8010318f:	89 c2                	mov    %eax,%edx
80103191:	a1 40 f9 10 80       	mov    0x8010f940,%eax
80103196:	83 ec 08             	sub    $0x8,%esp
80103199:	52                   	push   %edx
8010319a:	50                   	push   %eax
8010319b:	e8 14 d0 ff ff       	call   801001b4 <bread>
801031a0:	83 c4 10             	add    $0x10,%esp
801031a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801031a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031a9:	83 c0 18             	add    $0x18,%eax
801031ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801031af:	8b 15 44 f9 10 80    	mov    0x8010f944,%edx
801031b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031b8:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801031ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801031c1:	eb 1b                	jmp    801031de <write_head+0x5a>
    hb->sector[i] = log.lh.sector[i];
801031c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031c6:	83 c0 10             	add    $0x10,%eax
801031c9:	8b 0c 85 08 f9 10 80 	mov    -0x7fef06f8(,%eax,4),%ecx
801031d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801031d6:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801031da:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801031de:	a1 44 f9 10 80       	mov    0x8010f944,%eax
801031e3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801031e6:	7f db                	jg     801031c3 <write_head+0x3f>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
801031e8:	83 ec 0c             	sub    $0xc,%esp
801031eb:	ff 75 f0             	pushl  -0x10(%ebp)
801031ee:	e8 fa cf ff ff       	call   801001ed <bwrite>
801031f3:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
801031f6:	83 ec 0c             	sub    $0xc,%esp
801031f9:	ff 75 f0             	pushl  -0x10(%ebp)
801031fc:	e8 2a d0 ff ff       	call   8010022b <brelse>
80103201:	83 c4 10             	add    $0x10,%esp
}
80103204:	c9                   	leave  
80103205:	c3                   	ret    

80103206 <recover_from_log>:

static void
recover_from_log(void)
{
80103206:	55                   	push   %ebp
80103207:	89 e5                	mov    %esp,%ebp
80103209:	83 ec 08             	sub    $0x8,%esp
  read_head();      
8010320c:	e8 00 ff ff ff       	call   80103111 <read_head>
  install_trans(); // if committed, copy from log to disk
80103211:	e8 44 fe ff ff       	call   8010305a <install_trans>
  log.lh.n = 0;
80103216:	c7 05 44 f9 10 80 00 	movl   $0x0,0x8010f944
8010321d:	00 00 00 
  write_head(); // clear the log
80103220:	e8 5f ff ff ff       	call   80103184 <write_head>
}
80103225:	c9                   	leave  
80103226:	c3                   	ret    

80103227 <begin_trans>:

void
begin_trans(void)
{
80103227:	55                   	push   %ebp
80103228:	89 e5                	mov    %esp,%ebp
8010322a:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
8010322d:	83 ec 0c             	sub    $0xc,%esp
80103230:	68 00 f9 10 80       	push   $0x8010f900
80103235:	e8 bc 18 00 00       	call   80104af6 <acquire>
8010323a:	83 c4 10             	add    $0x10,%esp
  while (log.busy) {
8010323d:	eb 15                	jmp    80103254 <begin_trans+0x2d>
    sleep(&log, &log.lock);
8010323f:	83 ec 08             	sub    $0x8,%esp
80103242:	68 00 f9 10 80       	push   $0x8010f900
80103247:	68 00 f9 10 80       	push   $0x8010f900
8010324c:	e8 b7 15 00 00       	call   80104808 <sleep>
80103251:	83 c4 10             	add    $0x10,%esp

void
begin_trans(void)
{
  acquire(&log.lock);
  while (log.busy) {
80103254:	a1 3c f9 10 80       	mov    0x8010f93c,%eax
80103259:	85 c0                	test   %eax,%eax
8010325b:	75 e2                	jne    8010323f <begin_trans+0x18>
    sleep(&log, &log.lock);
  }
  log.busy = 1;
8010325d:	c7 05 3c f9 10 80 01 	movl   $0x1,0x8010f93c
80103264:	00 00 00 
  release(&log.lock);
80103267:	83 ec 0c             	sub    $0xc,%esp
8010326a:	68 00 f9 10 80       	push   $0x8010f900
8010326f:	e8 e8 18 00 00       	call   80104b5c <release>
80103274:	83 c4 10             	add    $0x10,%esp
}
80103277:	c9                   	leave  
80103278:	c3                   	ret    

80103279 <commit_trans>:

void
commit_trans(void)
{
80103279:	55                   	push   %ebp
8010327a:	89 e5                	mov    %esp,%ebp
8010327c:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
8010327f:	a1 44 f9 10 80       	mov    0x8010f944,%eax
80103284:	85 c0                	test   %eax,%eax
80103286:	7e 19                	jle    801032a1 <commit_trans+0x28>
    write_head();    // Write header to disk -- the real commit
80103288:	e8 f7 fe ff ff       	call   80103184 <write_head>
    install_trans(); // Now install writes to home locations
8010328d:	e8 c8 fd ff ff       	call   8010305a <install_trans>
    log.lh.n = 0; 
80103292:	c7 05 44 f9 10 80 00 	movl   $0x0,0x8010f944
80103299:	00 00 00 
    write_head();    // Erase the transaction from the log
8010329c:	e8 e3 fe ff ff       	call   80103184 <write_head>
  }
  
  acquire(&log.lock);
801032a1:	83 ec 0c             	sub    $0xc,%esp
801032a4:	68 00 f9 10 80       	push   $0x8010f900
801032a9:	e8 48 18 00 00       	call   80104af6 <acquire>
801032ae:	83 c4 10             	add    $0x10,%esp
  log.busy = 0;
801032b1:	c7 05 3c f9 10 80 00 	movl   $0x0,0x8010f93c
801032b8:	00 00 00 
  wakeup(&log);
801032bb:	83 ec 0c             	sub    $0xc,%esp
801032be:	68 00 f9 10 80       	push   $0x8010f900
801032c3:	e8 29 16 00 00       	call   801048f1 <wakeup>
801032c8:	83 c4 10             	add    $0x10,%esp
  release(&log.lock);
801032cb:	83 ec 0c             	sub    $0xc,%esp
801032ce:	68 00 f9 10 80       	push   $0x8010f900
801032d3:	e8 84 18 00 00       	call   80104b5c <release>
801032d8:	83 c4 10             	add    $0x10,%esp
}
801032db:	c9                   	leave  
801032dc:	c3                   	ret    

801032dd <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801032dd:	55                   	push   %ebp
801032de:	89 e5                	mov    %esp,%ebp
801032e0:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801032e3:	a1 44 f9 10 80       	mov    0x8010f944,%eax
801032e8:	83 f8 09             	cmp    $0x9,%eax
801032eb:	7f 12                	jg     801032ff <log_write+0x22>
801032ed:	a1 44 f9 10 80       	mov    0x8010f944,%eax
801032f2:	8b 15 38 f9 10 80    	mov    0x8010f938,%edx
801032f8:	83 ea 01             	sub    $0x1,%edx
801032fb:	39 d0                	cmp    %edx,%eax
801032fd:	7c 0d                	jl     8010330c <log_write+0x2f>
    panic("too big a transaction");
801032ff:	83 ec 0c             	sub    $0xc,%esp
80103302:	68 ec 84 10 80       	push   $0x801084ec
80103307:	e8 50 d2 ff ff       	call   8010055c <panic>
  if (!log.busy)
8010330c:	a1 3c f9 10 80       	mov    0x8010f93c,%eax
80103311:	85 c0                	test   %eax,%eax
80103313:	75 0d                	jne    80103322 <log_write+0x45>
    panic("write outside of trans");
80103315:	83 ec 0c             	sub    $0xc,%esp
80103318:	68 02 85 10 80       	push   $0x80108502
8010331d:	e8 3a d2 ff ff       	call   8010055c <panic>

  for (i = 0; i < log.lh.n; i++) {
80103322:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103329:	eb 1f                	jmp    8010334a <log_write+0x6d>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
8010332b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010332e:	83 c0 10             	add    $0x10,%eax
80103331:	8b 04 85 08 f9 10 80 	mov    -0x7fef06f8(,%eax,4),%eax
80103338:	89 c2                	mov    %eax,%edx
8010333a:	8b 45 08             	mov    0x8(%ebp),%eax
8010333d:	8b 40 08             	mov    0x8(%eax),%eax
80103340:	39 c2                	cmp    %eax,%edx
80103342:	75 02                	jne    80103346 <log_write+0x69>
      break;
80103344:	eb 0e                	jmp    80103354 <log_write+0x77>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (!log.busy)
    panic("write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
80103346:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010334a:	a1 44 f9 10 80       	mov    0x8010f944,%eax
8010334f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103352:	7f d7                	jg     8010332b <log_write+0x4e>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
      break;
  }
  log.lh.sector[i] = b->sector;
80103354:	8b 45 08             	mov    0x8(%ebp),%eax
80103357:	8b 40 08             	mov    0x8(%eax),%eax
8010335a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010335d:	83 c2 10             	add    $0x10,%edx
80103360:	89 04 95 08 f9 10 80 	mov    %eax,-0x7fef06f8(,%edx,4)
  struct buf *lbuf = bread(b->dev, log.start+i+1);
80103367:	8b 15 34 f9 10 80    	mov    0x8010f934,%edx
8010336d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103370:	01 d0                	add    %edx,%eax
80103372:	83 c0 01             	add    $0x1,%eax
80103375:	89 c2                	mov    %eax,%edx
80103377:	8b 45 08             	mov    0x8(%ebp),%eax
8010337a:	8b 40 04             	mov    0x4(%eax),%eax
8010337d:	83 ec 08             	sub    $0x8,%esp
80103380:	52                   	push   %edx
80103381:	50                   	push   %eax
80103382:	e8 2d ce ff ff       	call   801001b4 <bread>
80103387:	83 c4 10             	add    $0x10,%esp
8010338a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(lbuf->data, b->data, BSIZE);
8010338d:	8b 45 08             	mov    0x8(%ebp),%eax
80103390:	8d 50 18             	lea    0x18(%eax),%edx
80103393:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103396:	83 c0 18             	add    $0x18,%eax
80103399:	83 ec 04             	sub    $0x4,%esp
8010339c:	68 00 02 00 00       	push   $0x200
801033a1:	52                   	push   %edx
801033a2:	50                   	push   %eax
801033a3:	e8 69 1a 00 00       	call   80104e11 <memmove>
801033a8:	83 c4 10             	add    $0x10,%esp
  bwrite(lbuf);
801033ab:	83 ec 0c             	sub    $0xc,%esp
801033ae:	ff 75 f0             	pushl  -0x10(%ebp)
801033b1:	e8 37 ce ff ff       	call   801001ed <bwrite>
801033b6:	83 c4 10             	add    $0x10,%esp
  brelse(lbuf);
801033b9:	83 ec 0c             	sub    $0xc,%esp
801033bc:	ff 75 f0             	pushl  -0x10(%ebp)
801033bf:	e8 67 ce ff ff       	call   8010022b <brelse>
801033c4:	83 c4 10             	add    $0x10,%esp
  if (i == log.lh.n)
801033c7:	a1 44 f9 10 80       	mov    0x8010f944,%eax
801033cc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033cf:	75 0d                	jne    801033de <log_write+0x101>
    log.lh.n++;
801033d1:	a1 44 f9 10 80       	mov    0x8010f944,%eax
801033d6:	83 c0 01             	add    $0x1,%eax
801033d9:	a3 44 f9 10 80       	mov    %eax,0x8010f944
  b->flags |= B_DIRTY; // XXX prevent eviction
801033de:	8b 45 08             	mov    0x8(%ebp),%eax
801033e1:	8b 00                	mov    (%eax),%eax
801033e3:	83 c8 04             	or     $0x4,%eax
801033e6:	89 c2                	mov    %eax,%edx
801033e8:	8b 45 08             	mov    0x8(%ebp),%eax
801033eb:	89 10                	mov    %edx,(%eax)
}
801033ed:	c9                   	leave  
801033ee:	c3                   	ret    

801033ef <v2p>:
801033ef:	55                   	push   %ebp
801033f0:	89 e5                	mov    %esp,%ebp
801033f2:	8b 45 08             	mov    0x8(%ebp),%eax
801033f5:	05 00 00 00 80       	add    $0x80000000,%eax
801033fa:	5d                   	pop    %ebp
801033fb:	c3                   	ret    

801033fc <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801033fc:	55                   	push   %ebp
801033fd:	89 e5                	mov    %esp,%ebp
801033ff:	8b 45 08             	mov    0x8(%ebp),%eax
80103402:	05 00 00 00 80       	add    $0x80000000,%eax
80103407:	5d                   	pop    %ebp
80103408:	c3                   	ret    

80103409 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103409:	55                   	push   %ebp
8010340a:	89 e5                	mov    %esp,%ebp
8010340c:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010340f:	8b 55 08             	mov    0x8(%ebp),%edx
80103412:	8b 45 0c             	mov    0xc(%ebp),%eax
80103415:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103418:	f0 87 02             	lock xchg %eax,(%edx)
8010341b:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
8010341e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103421:	c9                   	leave  
80103422:	c3                   	ret    

80103423 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103423:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103427:	83 e4 f0             	and    $0xfffffff0,%esp
8010342a:	ff 71 fc             	pushl  -0x4(%ecx)
8010342d:	55                   	push   %ebp
8010342e:	89 e5                	mov    %esp,%ebp
80103430:	51                   	push   %ecx
80103431:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103434:	83 ec 08             	sub    $0x8,%esp
80103437:	68 00 00 40 80       	push   $0x80400000
8010343c:	68 9c 27 11 80       	push   $0x8011279c
80103441:	e8 f1 f5 ff ff       	call   80102a37 <kinit1>
80103446:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103449:	e8 2e 47 00 00       	call   80107b7c <kvmalloc>
  mpinit();        // collect info about this machine
8010344e:	e8 09 04 00 00       	call   8010385c <mpinit>
  lapicinit();
80103453:	e8 3a f9 ff ff       	call   80102d92 <lapicinit>
  seginit();       // set up segments
80103458:	e8 c7 40 00 00       	call   80107524 <seginit>
  //cprintf("\nkernel: initializing all devices\n\n", cpu->id);
  //cprintf("Qwin "VERSION" (console)\n\n");
  picinit();       // interrupt controller
8010345d:	e8 4c 06 00 00       	call   80103aae <picinit>
  ioapicinit();    // another interrupt controller
80103462:	e8 ce f4 ff ff       	call   80102935 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103467:	e8 6f d6 ff ff       	call   80100adb <consoleinit>
  uartinit();      // serial port
8010346c:	e8 16 34 00 00       	call   80106887 <uartinit>
  pinit();         // process table
80103471:	e8 33 0b 00 00       	call   80103fa9 <pinit>
  tvinit();        // trap vectors
80103476:	e8 da 2f 00 00       	call   80106455 <tvinit>
  binit();         // buffer cache
8010347b:	e8 b4 cb ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103480:	e8 9d da ff ff       	call   80100f22 <fileinit>
  iinit();         // inode cache
80103485:	e8 68 e1 ff ff       	call   801015f2 <iinit>
  ideinit();       // disk
8010348a:	e8 ee f0 ff ff       	call   8010257d <ideinit>
  if(!ismp)
8010348f:	a1 84 f9 10 80       	mov    0x8010f984,%eax
80103494:	85 c0                	test   %eax,%eax
80103496:	75 05                	jne    8010349d <main+0x7a>
    timerinit();   // uniprocessor timer
80103498:	e8 17 2f 00 00       	call   801063b4 <timerinit>
  startothers();   // start other processors
8010349d:	e8 62 00 00 00       	call   80103504 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801034a2:	83 ec 08             	sub    $0x8,%esp
801034a5:	68 00 00 00 8e       	push   $0x8e000000
801034aa:	68 00 00 40 80       	push   $0x80400000
801034af:	e8 bb f5 ff ff       	call   80102a6f <kinit2>
801034b4:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
801034b7:	e8 0d 0c 00 00       	call   801040c9 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
801034bc:	e8 1a 00 00 00       	call   801034db <mpmain>

801034c1 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801034c1:	55                   	push   %ebp
801034c2:	89 e5                	mov    %esp,%ebp
801034c4:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
801034c7:	e8 c7 46 00 00       	call   80107b93 <switchkvm>
  seginit();
801034cc:	e8 53 40 00 00       	call   80107524 <seginit>
  lapicinit();
801034d1:	e8 bc f8 ff ff       	call   80102d92 <lapicinit>
  mpmain();
801034d6:	e8 00 00 00 00       	call   801034db <mpmain>

801034db <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801034db:	55                   	push   %ebp
801034dc:	89 e5                	mov    %esp,%ebp
801034de:	83 ec 08             	sub    $0x8,%esp
  //cprintf("cpu%d: starting\n", cpu->id);  //Bug with multicore CPUs
  idtinit();       // load idt register
801034e1:	e8 e4 30 00 00       	call   801065ca <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801034e6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034ec:	05 a8 00 00 00       	add    $0xa8,%eax
801034f1:	83 ec 08             	sub    $0x8,%esp
801034f4:	6a 01                	push   $0x1
801034f6:	50                   	push   %eax
801034f7:	e8 0d ff ff ff       	call   80103409 <xchg>
801034fc:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
801034ff:	e8 3b 11 00 00       	call   8010463f <scheduler>

80103504 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103504:	55                   	push   %ebp
80103505:	89 e5                	mov    %esp,%ebp
80103507:	53                   	push   %ebx
80103508:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
8010350b:	68 00 70 00 00       	push   $0x7000
80103510:	e8 e7 fe ff ff       	call   801033fc <p2v>
80103515:	83 c4 04             	add    $0x4,%esp
80103518:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
8010351b:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103520:	83 ec 04             	sub    $0x4,%esp
80103523:	50                   	push   %eax
80103524:	68 2c b5 10 80       	push   $0x8010b52c
80103529:	ff 75 f0             	pushl  -0x10(%ebp)
8010352c:	e8 e0 18 00 00       	call   80104e11 <memmove>
80103531:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103534:	c7 45 f4 c0 f9 10 80 	movl   $0x8010f9c0,-0xc(%ebp)
8010353b:	e9 8d 00 00 00       	jmp    801035cd <startothers+0xc9>
    if(c == cpus+cpunum())  // We've started already.
80103540:	e8 69 f9 ff ff       	call   80102eae <cpunum>
80103545:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010354b:	05 c0 f9 10 80       	add    $0x8010f9c0,%eax
80103550:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103553:	75 02                	jne    80103557 <startothers+0x53>
      continue;
80103555:	eb 6f                	jmp    801035c6 <startothers+0xc2>

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103557:	e8 0e f6 ff ff       	call   80102b6a <kalloc>
8010355c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
8010355f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103562:	83 e8 04             	sub    $0x4,%eax
80103565:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103568:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010356e:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103570:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103573:	83 e8 08             	sub    $0x8,%eax
80103576:	c7 00 c1 34 10 80    	movl   $0x801034c1,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
8010357c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010357f:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103582:	83 ec 0c             	sub    $0xc,%esp
80103585:	68 00 a0 10 80       	push   $0x8010a000
8010358a:	e8 60 fe ff ff       	call   801033ef <v2p>
8010358f:	83 c4 10             	add    $0x10,%esp
80103592:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103594:	83 ec 0c             	sub    $0xc,%esp
80103597:	ff 75 f0             	pushl  -0x10(%ebp)
8010359a:	e8 50 fe ff ff       	call   801033ef <v2p>
8010359f:	83 c4 10             	add    $0x10,%esp
801035a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801035a5:	0f b6 12             	movzbl (%edx),%edx
801035a8:	0f b6 d2             	movzbl %dl,%edx
801035ab:	83 ec 08             	sub    $0x8,%esp
801035ae:	50                   	push   %eax
801035af:	52                   	push   %edx
801035b0:	e8 71 f9 ff ff       	call   80102f26 <lapicstartap>
801035b5:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801035b8:	90                   	nop
801035b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035bc:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801035c2:	85 c0                	test   %eax,%eax
801035c4:	74 f3                	je     801035b9 <startothers+0xb5>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801035c6:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
801035cd:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801035d2:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801035d8:	05 c0 f9 10 80       	add    $0x8010f9c0,%eax
801035dd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801035e0:	0f 87 5a ff ff ff    	ja     80103540 <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
801035e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801035e9:	c9                   	leave  
801035ea:	c3                   	ret    

801035eb <p2v>:
801035eb:	55                   	push   %ebp
801035ec:	89 e5                	mov    %esp,%ebp
801035ee:	8b 45 08             	mov    0x8(%ebp),%eax
801035f1:	05 00 00 00 80       	add    $0x80000000,%eax
801035f6:	5d                   	pop    %ebp
801035f7:	c3                   	ret    

801035f8 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801035f8:	55                   	push   %ebp
801035f9:	89 e5                	mov    %esp,%ebp
801035fb:	83 ec 14             	sub    $0x14,%esp
801035fe:	8b 45 08             	mov    0x8(%ebp),%eax
80103601:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103605:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103609:	89 c2                	mov    %eax,%edx
8010360b:	ec                   	in     (%dx),%al
8010360c:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010360f:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103613:	c9                   	leave  
80103614:	c3                   	ret    

80103615 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103615:	55                   	push   %ebp
80103616:	89 e5                	mov    %esp,%ebp
80103618:	83 ec 08             	sub    $0x8,%esp
8010361b:	8b 55 08             	mov    0x8(%ebp),%edx
8010361e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103621:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103625:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103628:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010362c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103630:	ee                   	out    %al,(%dx)
}
80103631:	c9                   	leave  
80103632:	c3                   	ret    

80103633 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103633:	55                   	push   %ebp
80103634:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103636:	a1 64 b6 10 80       	mov    0x8010b664,%eax
8010363b:	89 c2                	mov    %eax,%edx
8010363d:	b8 c0 f9 10 80       	mov    $0x8010f9c0,%eax
80103642:	29 c2                	sub    %eax,%edx
80103644:	89 d0                	mov    %edx,%eax
80103646:	c1 f8 02             	sar    $0x2,%eax
80103649:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
8010364f:	5d                   	pop    %ebp
80103650:	c3                   	ret    

80103651 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103651:	55                   	push   %ebp
80103652:	89 e5                	mov    %esp,%ebp
80103654:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103657:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
8010365e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103665:	eb 15                	jmp    8010367c <sum+0x2b>
    sum += addr[i];
80103667:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010366a:	8b 45 08             	mov    0x8(%ebp),%eax
8010366d:	01 d0                	add    %edx,%eax
8010366f:	0f b6 00             	movzbl (%eax),%eax
80103672:	0f b6 c0             	movzbl %al,%eax
80103675:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103678:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010367c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010367f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103682:	7c e3                	jl     80103667 <sum+0x16>
    sum += addr[i];
  return sum;
80103684:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103687:	c9                   	leave  
80103688:	c3                   	ret    

80103689 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103689:	55                   	push   %ebp
8010368a:	89 e5                	mov    %esp,%ebp
8010368c:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
8010368f:	ff 75 08             	pushl  0x8(%ebp)
80103692:	e8 54 ff ff ff       	call   801035eb <p2v>
80103697:	83 c4 04             	add    $0x4,%esp
8010369a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
8010369d:	8b 55 0c             	mov    0xc(%ebp),%edx
801036a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036a3:	01 d0                	add    %edx,%eax
801036a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
801036a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
801036ae:	eb 36                	jmp    801036e6 <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801036b0:	83 ec 04             	sub    $0x4,%esp
801036b3:	6a 04                	push   $0x4
801036b5:	68 1c 85 10 80       	push   $0x8010851c
801036ba:	ff 75 f4             	pushl  -0xc(%ebp)
801036bd:	e8 f7 16 00 00       	call   80104db9 <memcmp>
801036c2:	83 c4 10             	add    $0x10,%esp
801036c5:	85 c0                	test   %eax,%eax
801036c7:	75 19                	jne    801036e2 <mpsearch1+0x59>
801036c9:	83 ec 08             	sub    $0x8,%esp
801036cc:	6a 10                	push   $0x10
801036ce:	ff 75 f4             	pushl  -0xc(%ebp)
801036d1:	e8 7b ff ff ff       	call   80103651 <sum>
801036d6:	83 c4 10             	add    $0x10,%esp
801036d9:	84 c0                	test   %al,%al
801036db:	75 05                	jne    801036e2 <mpsearch1+0x59>
      return (struct mp*)p;
801036dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036e0:	eb 11                	jmp    801036f3 <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
801036e2:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801036e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036e9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801036ec:	72 c2                	jb     801036b0 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
801036ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
801036f3:	c9                   	leave  
801036f4:	c3                   	ret    

801036f5 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
801036f5:	55                   	push   %ebp
801036f6:	89 e5                	mov    %esp,%ebp
801036f8:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
801036fb:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103702:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103705:	83 c0 0f             	add    $0xf,%eax
80103708:	0f b6 00             	movzbl (%eax),%eax
8010370b:	0f b6 c0             	movzbl %al,%eax
8010370e:	c1 e0 08             	shl    $0x8,%eax
80103711:	89 c2                	mov    %eax,%edx
80103713:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103716:	83 c0 0e             	add    $0xe,%eax
80103719:	0f b6 00             	movzbl (%eax),%eax
8010371c:	0f b6 c0             	movzbl %al,%eax
8010371f:	09 d0                	or     %edx,%eax
80103721:	c1 e0 04             	shl    $0x4,%eax
80103724:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103727:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010372b:	74 21                	je     8010374e <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
8010372d:	83 ec 08             	sub    $0x8,%esp
80103730:	68 00 04 00 00       	push   $0x400
80103735:	ff 75 f0             	pushl  -0x10(%ebp)
80103738:	e8 4c ff ff ff       	call   80103689 <mpsearch1>
8010373d:	83 c4 10             	add    $0x10,%esp
80103740:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103743:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103747:	74 51                	je     8010379a <mpsearch+0xa5>
      return mp;
80103749:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010374c:	eb 61                	jmp    801037af <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
8010374e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103751:	83 c0 14             	add    $0x14,%eax
80103754:	0f b6 00             	movzbl (%eax),%eax
80103757:	0f b6 c0             	movzbl %al,%eax
8010375a:	c1 e0 08             	shl    $0x8,%eax
8010375d:	89 c2                	mov    %eax,%edx
8010375f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103762:	83 c0 13             	add    $0x13,%eax
80103765:	0f b6 00             	movzbl (%eax),%eax
80103768:	0f b6 c0             	movzbl %al,%eax
8010376b:	09 d0                	or     %edx,%eax
8010376d:	c1 e0 0a             	shl    $0xa,%eax
80103770:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103773:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103776:	2d 00 04 00 00       	sub    $0x400,%eax
8010377b:	83 ec 08             	sub    $0x8,%esp
8010377e:	68 00 04 00 00       	push   $0x400
80103783:	50                   	push   %eax
80103784:	e8 00 ff ff ff       	call   80103689 <mpsearch1>
80103789:	83 c4 10             	add    $0x10,%esp
8010378c:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010378f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103793:	74 05                	je     8010379a <mpsearch+0xa5>
      return mp;
80103795:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103798:	eb 15                	jmp    801037af <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
8010379a:	83 ec 08             	sub    $0x8,%esp
8010379d:	68 00 00 01 00       	push   $0x10000
801037a2:	68 00 00 0f 00       	push   $0xf0000
801037a7:	e8 dd fe ff ff       	call   80103689 <mpsearch1>
801037ac:	83 c4 10             	add    $0x10,%esp
}
801037af:	c9                   	leave  
801037b0:	c3                   	ret    

801037b1 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
801037b1:	55                   	push   %ebp
801037b2:	89 e5                	mov    %esp,%ebp
801037b4:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801037b7:	e8 39 ff ff ff       	call   801036f5 <mpsearch>
801037bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801037bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801037c3:	74 0a                	je     801037cf <mpconfig+0x1e>
801037c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037c8:	8b 40 04             	mov    0x4(%eax),%eax
801037cb:	85 c0                	test   %eax,%eax
801037cd:	75 0a                	jne    801037d9 <mpconfig+0x28>
    return 0;
801037cf:	b8 00 00 00 00       	mov    $0x0,%eax
801037d4:	e9 81 00 00 00       	jmp    8010385a <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
801037d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037dc:	8b 40 04             	mov    0x4(%eax),%eax
801037df:	83 ec 0c             	sub    $0xc,%esp
801037e2:	50                   	push   %eax
801037e3:	e8 03 fe ff ff       	call   801035eb <p2v>
801037e8:	83 c4 10             	add    $0x10,%esp
801037eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801037ee:	83 ec 04             	sub    $0x4,%esp
801037f1:	6a 04                	push   $0x4
801037f3:	68 21 85 10 80       	push   $0x80108521
801037f8:	ff 75 f0             	pushl  -0x10(%ebp)
801037fb:	e8 b9 15 00 00       	call   80104db9 <memcmp>
80103800:	83 c4 10             	add    $0x10,%esp
80103803:	85 c0                	test   %eax,%eax
80103805:	74 07                	je     8010380e <mpconfig+0x5d>
    return 0;
80103807:	b8 00 00 00 00       	mov    $0x0,%eax
8010380c:	eb 4c                	jmp    8010385a <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
8010380e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103811:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103815:	3c 01                	cmp    $0x1,%al
80103817:	74 12                	je     8010382b <mpconfig+0x7a>
80103819:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010381c:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103820:	3c 04                	cmp    $0x4,%al
80103822:	74 07                	je     8010382b <mpconfig+0x7a>
    return 0;
80103824:	b8 00 00 00 00       	mov    $0x0,%eax
80103829:	eb 2f                	jmp    8010385a <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
8010382b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010382e:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103832:	0f b7 c0             	movzwl %ax,%eax
80103835:	83 ec 08             	sub    $0x8,%esp
80103838:	50                   	push   %eax
80103839:	ff 75 f0             	pushl  -0x10(%ebp)
8010383c:	e8 10 fe ff ff       	call   80103651 <sum>
80103841:	83 c4 10             	add    $0x10,%esp
80103844:	84 c0                	test   %al,%al
80103846:	74 07                	je     8010384f <mpconfig+0x9e>
    return 0;
80103848:	b8 00 00 00 00       	mov    $0x0,%eax
8010384d:	eb 0b                	jmp    8010385a <mpconfig+0xa9>
  *pmp = mp;
8010384f:	8b 45 08             	mov    0x8(%ebp),%eax
80103852:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103855:	89 10                	mov    %edx,(%eax)
  return conf;
80103857:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010385a:	c9                   	leave  
8010385b:	c3                   	ret    

8010385c <mpinit>:

void
mpinit(void)
{
8010385c:	55                   	push   %ebp
8010385d:	89 e5                	mov    %esp,%ebp
8010385f:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103862:	c7 05 64 b6 10 80 c0 	movl   $0x8010f9c0,0x8010b664
80103869:	f9 10 80 
  if((conf = mpconfig(&mp)) == 0)
8010386c:	83 ec 0c             	sub    $0xc,%esp
8010386f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103872:	50                   	push   %eax
80103873:	e8 39 ff ff ff       	call   801037b1 <mpconfig>
80103878:	83 c4 10             	add    $0x10,%esp
8010387b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010387e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103882:	75 05                	jne    80103889 <mpinit+0x2d>
    return;
80103884:	e9 95 01 00 00       	jmp    80103a1e <mpinit+0x1c2>
  ismp = 1;
80103889:	c7 05 84 f9 10 80 01 	movl   $0x1,0x8010f984
80103890:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103893:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103896:	8b 40 24             	mov    0x24(%eax),%eax
80103899:	a3 dc f8 10 80       	mov    %eax,0x8010f8dc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010389e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038a1:	83 c0 2c             	add    $0x2c,%eax
801038a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801038a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038aa:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801038ae:	0f b7 d0             	movzwl %ax,%edx
801038b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038b4:	01 d0                	add    %edx,%eax
801038b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
801038b9:	e9 f3 00 00 00       	jmp    801039b1 <mpinit+0x155>
    switch(*p){
801038be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038c1:	0f b6 00             	movzbl (%eax),%eax
801038c4:	0f b6 c0             	movzbl %al,%eax
801038c7:	83 f8 04             	cmp    $0x4,%eax
801038ca:	0f 87 bd 00 00 00    	ja     8010398d <mpinit+0x131>
801038d0:	8b 04 85 64 85 10 80 	mov    -0x7fef7a9c(,%eax,4),%eax
801038d7:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
801038d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
801038df:	8b 45 e8             	mov    -0x18(%ebp),%eax
801038e2:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801038e6:	0f b6 d0             	movzbl %al,%edx
801038e9:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801038ee:	39 c2                	cmp    %eax,%edx
801038f0:	74 2b                	je     8010391d <mpinit+0xc1>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
801038f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801038f5:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801038f9:	0f b6 d0             	movzbl %al,%edx
801038fc:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
80103901:	83 ec 04             	sub    $0x4,%esp
80103904:	52                   	push   %edx
80103905:	50                   	push   %eax
80103906:	68 26 85 10 80       	push   $0x80108526
8010390b:	e8 af ca ff ff       	call   801003bf <cprintf>
80103910:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103913:	c7 05 84 f9 10 80 00 	movl   $0x0,0x8010f984
8010391a:	00 00 00 
      }
      if(proc->flags & MPBOOT)
8010391d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103920:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103924:	0f b6 c0             	movzbl %al,%eax
80103927:	83 e0 02             	and    $0x2,%eax
8010392a:	85 c0                	test   %eax,%eax
8010392c:	74 15                	je     80103943 <mpinit+0xe7>
        bcpu = &cpus[ncpu];
8010392e:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
80103933:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103939:	05 c0 f9 10 80       	add    $0x8010f9c0,%eax
8010393e:	a3 64 b6 10 80       	mov    %eax,0x8010b664
      cpus[ncpu].id = ncpu;
80103943:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
80103949:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
8010394e:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
80103954:	81 c2 c0 f9 10 80    	add    $0x8010f9c0,%edx
8010395a:	88 02                	mov    %al,(%edx)
      ncpu++;
8010395c:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
80103961:	83 c0 01             	add    $0x1,%eax
80103964:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
      p += sizeof(struct mpproc);
80103969:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
8010396d:	eb 42                	jmp    801039b1 <mpinit+0x155>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
8010396f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103972:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103975:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103978:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010397c:	a2 80 f9 10 80       	mov    %al,0x8010f980
      p += sizeof(struct mpioapic);
80103981:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103985:	eb 2a                	jmp    801039b1 <mpinit+0x155>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103987:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
8010398b:	eb 24                	jmp    801039b1 <mpinit+0x155>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
8010398d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103990:	0f b6 00             	movzbl (%eax),%eax
80103993:	0f b6 c0             	movzbl %al,%eax
80103996:	83 ec 08             	sub    $0x8,%esp
80103999:	50                   	push   %eax
8010399a:	68 44 85 10 80       	push   $0x80108544
8010399f:	e8 1b ca ff ff       	call   801003bf <cprintf>
801039a4:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
801039a7:	c7 05 84 f9 10 80 00 	movl   $0x0,0x8010f984
801039ae:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801039b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039b4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801039b7:	0f 82 01 ff ff ff    	jb     801038be <mpinit+0x62>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
801039bd:	a1 84 f9 10 80       	mov    0x8010f984,%eax
801039c2:	85 c0                	test   %eax,%eax
801039c4:	75 1d                	jne    801039e3 <mpinit+0x187>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
801039c6:	c7 05 a0 ff 10 80 01 	movl   $0x1,0x8010ffa0
801039cd:	00 00 00 
    lapic = 0;
801039d0:	c7 05 dc f8 10 80 00 	movl   $0x0,0x8010f8dc
801039d7:	00 00 00 
    ioapicid = 0;
801039da:	c6 05 80 f9 10 80 00 	movb   $0x0,0x8010f980
    return;
801039e1:	eb 3b                	jmp    80103a1e <mpinit+0x1c2>
  }

  if(mp->imcrp){
801039e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801039e6:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
801039ea:	84 c0                	test   %al,%al
801039ec:	74 30                	je     80103a1e <mpinit+0x1c2>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
801039ee:	83 ec 08             	sub    $0x8,%esp
801039f1:	6a 70                	push   $0x70
801039f3:	6a 22                	push   $0x22
801039f5:	e8 1b fc ff ff       	call   80103615 <outb>
801039fa:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801039fd:	83 ec 0c             	sub    $0xc,%esp
80103a00:	6a 23                	push   $0x23
80103a02:	e8 f1 fb ff ff       	call   801035f8 <inb>
80103a07:	83 c4 10             	add    $0x10,%esp
80103a0a:	83 c8 01             	or     $0x1,%eax
80103a0d:	0f b6 c0             	movzbl %al,%eax
80103a10:	83 ec 08             	sub    $0x8,%esp
80103a13:	50                   	push   %eax
80103a14:	6a 23                	push   $0x23
80103a16:	e8 fa fb ff ff       	call   80103615 <outb>
80103a1b:	83 c4 10             	add    $0x10,%esp
  }
}
80103a1e:	c9                   	leave  
80103a1f:	c3                   	ret    

80103a20 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	83 ec 08             	sub    $0x8,%esp
80103a26:	8b 55 08             	mov    0x8(%ebp),%edx
80103a29:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a2c:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103a30:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a33:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103a37:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a3b:	ee                   	out    %al,(%dx)
}
80103a3c:	c9                   	leave  
80103a3d:	c3                   	ret    

80103a3e <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103a3e:	55                   	push   %ebp
80103a3f:	89 e5                	mov    %esp,%ebp
80103a41:	83 ec 04             	sub    $0x4,%esp
80103a44:	8b 45 08             	mov    0x8(%ebp),%eax
80103a47:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103a4b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a4f:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
80103a55:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a59:	0f b6 c0             	movzbl %al,%eax
80103a5c:	50                   	push   %eax
80103a5d:	6a 21                	push   $0x21
80103a5f:	e8 bc ff ff ff       	call   80103a20 <outb>
80103a64:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80103a67:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a6b:	66 c1 e8 08          	shr    $0x8,%ax
80103a6f:	0f b6 c0             	movzbl %al,%eax
80103a72:	50                   	push   %eax
80103a73:	68 a1 00 00 00       	push   $0xa1
80103a78:	e8 a3 ff ff ff       	call   80103a20 <outb>
80103a7d:	83 c4 08             	add    $0x8,%esp
}
80103a80:	c9                   	leave  
80103a81:	c3                   	ret    

80103a82 <picenable>:

void
picenable(int irq)
{
80103a82:	55                   	push   %ebp
80103a83:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80103a85:	8b 45 08             	mov    0x8(%ebp),%eax
80103a88:	ba 01 00 00 00       	mov    $0x1,%edx
80103a8d:	89 c1                	mov    %eax,%ecx
80103a8f:	d3 e2                	shl    %cl,%edx
80103a91:	89 d0                	mov    %edx,%eax
80103a93:	f7 d0                	not    %eax
80103a95:	89 c2                	mov    %eax,%edx
80103a97:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103a9e:	21 d0                	and    %edx,%eax
80103aa0:	0f b7 c0             	movzwl %ax,%eax
80103aa3:	50                   	push   %eax
80103aa4:	e8 95 ff ff ff       	call   80103a3e <picsetmask>
80103aa9:	83 c4 04             	add    $0x4,%esp
}
80103aac:	c9                   	leave  
80103aad:	c3                   	ret    

80103aae <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103aae:	55                   	push   %ebp
80103aaf:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103ab1:	68 ff 00 00 00       	push   $0xff
80103ab6:	6a 21                	push   $0x21
80103ab8:	e8 63 ff ff ff       	call   80103a20 <outb>
80103abd:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103ac0:	68 ff 00 00 00       	push   $0xff
80103ac5:	68 a1 00 00 00       	push   $0xa1
80103aca:	e8 51 ff ff ff       	call   80103a20 <outb>
80103acf:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103ad2:	6a 11                	push   $0x11
80103ad4:	6a 20                	push   $0x20
80103ad6:	e8 45 ff ff ff       	call   80103a20 <outb>
80103adb:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103ade:	6a 20                	push   $0x20
80103ae0:	6a 21                	push   $0x21
80103ae2:	e8 39 ff ff ff       	call   80103a20 <outb>
80103ae7:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103aea:	6a 04                	push   $0x4
80103aec:	6a 21                	push   $0x21
80103aee:	e8 2d ff ff ff       	call   80103a20 <outb>
80103af3:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103af6:	6a 03                	push   $0x3
80103af8:	6a 21                	push   $0x21
80103afa:	e8 21 ff ff ff       	call   80103a20 <outb>
80103aff:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103b02:	6a 11                	push   $0x11
80103b04:	68 a0 00 00 00       	push   $0xa0
80103b09:	e8 12 ff ff ff       	call   80103a20 <outb>
80103b0e:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103b11:	6a 28                	push   $0x28
80103b13:	68 a1 00 00 00       	push   $0xa1
80103b18:	e8 03 ff ff ff       	call   80103a20 <outb>
80103b1d:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103b20:	6a 02                	push   $0x2
80103b22:	68 a1 00 00 00       	push   $0xa1
80103b27:	e8 f4 fe ff ff       	call   80103a20 <outb>
80103b2c:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103b2f:	6a 03                	push   $0x3
80103b31:	68 a1 00 00 00       	push   $0xa1
80103b36:	e8 e5 fe ff ff       	call   80103a20 <outb>
80103b3b:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103b3e:	6a 68                	push   $0x68
80103b40:	6a 20                	push   $0x20
80103b42:	e8 d9 fe ff ff       	call   80103a20 <outb>
80103b47:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103b4a:	6a 0a                	push   $0xa
80103b4c:	6a 20                	push   $0x20
80103b4e:	e8 cd fe ff ff       	call   80103a20 <outb>
80103b53:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
80103b56:	6a 68                	push   $0x68
80103b58:	68 a0 00 00 00       	push   $0xa0
80103b5d:	e8 be fe ff ff       	call   80103a20 <outb>
80103b62:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
80103b65:	6a 0a                	push   $0xa
80103b67:	68 a0 00 00 00       	push   $0xa0
80103b6c:	e8 af fe ff ff       	call   80103a20 <outb>
80103b71:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
80103b74:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103b7b:	66 83 f8 ff          	cmp    $0xffff,%ax
80103b7f:	74 13                	je     80103b94 <picinit+0xe6>
    picsetmask(irqmask);
80103b81:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103b88:	0f b7 c0             	movzwl %ax,%eax
80103b8b:	50                   	push   %eax
80103b8c:	e8 ad fe ff ff       	call   80103a3e <picsetmask>
80103b91:	83 c4 04             	add    $0x4,%esp
}
80103b94:	c9                   	leave  
80103b95:	c3                   	ret    

80103b96 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103b96:	55                   	push   %ebp
80103b97:	89 e5                	mov    %esp,%ebp
80103b99:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80103b9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103ba3:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ba6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103bac:	8b 45 0c             	mov    0xc(%ebp),%eax
80103baf:	8b 10                	mov    (%eax),%edx
80103bb1:	8b 45 08             	mov    0x8(%ebp),%eax
80103bb4:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103bb6:	e8 84 d3 ff ff       	call   80100f3f <filealloc>
80103bbb:	8b 55 08             	mov    0x8(%ebp),%edx
80103bbe:	89 02                	mov    %eax,(%edx)
80103bc0:	8b 45 08             	mov    0x8(%ebp),%eax
80103bc3:	8b 00                	mov    (%eax),%eax
80103bc5:	85 c0                	test   %eax,%eax
80103bc7:	0f 84 c9 00 00 00    	je     80103c96 <pipealloc+0x100>
80103bcd:	e8 6d d3 ff ff       	call   80100f3f <filealloc>
80103bd2:	8b 55 0c             	mov    0xc(%ebp),%edx
80103bd5:	89 02                	mov    %eax,(%edx)
80103bd7:	8b 45 0c             	mov    0xc(%ebp),%eax
80103bda:	8b 00                	mov    (%eax),%eax
80103bdc:	85 c0                	test   %eax,%eax
80103bde:	0f 84 b2 00 00 00    	je     80103c96 <pipealloc+0x100>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103be4:	e8 81 ef ff ff       	call   80102b6a <kalloc>
80103be9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103bec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103bf0:	75 05                	jne    80103bf7 <pipealloc+0x61>
    goto bad;
80103bf2:	e9 9f 00 00 00       	jmp    80103c96 <pipealloc+0x100>
  p->readopen = 1;
80103bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bfa:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103c01:	00 00 00 
  p->writeopen = 1;
80103c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c07:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103c0e:	00 00 00 
  p->nwrite = 0;
80103c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c14:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103c1b:	00 00 00 
  p->nread = 0;
80103c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c21:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103c28:	00 00 00 
  initlock(&p->lock, "pipe");
80103c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c2e:	83 ec 08             	sub    $0x8,%esp
80103c31:	68 78 85 10 80       	push   $0x80108578
80103c36:	50                   	push   %eax
80103c37:	e8 99 0e 00 00       	call   80104ad5 <initlock>
80103c3c:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103c3f:	8b 45 08             	mov    0x8(%ebp),%eax
80103c42:	8b 00                	mov    (%eax),%eax
80103c44:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103c4a:	8b 45 08             	mov    0x8(%ebp),%eax
80103c4d:	8b 00                	mov    (%eax),%eax
80103c4f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103c53:	8b 45 08             	mov    0x8(%ebp),%eax
80103c56:	8b 00                	mov    (%eax),%eax
80103c58:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103c5c:	8b 45 08             	mov    0x8(%ebp),%eax
80103c5f:	8b 00                	mov    (%eax),%eax
80103c61:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c64:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103c67:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c6a:	8b 00                	mov    (%eax),%eax
80103c6c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103c72:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c75:	8b 00                	mov    (%eax),%eax
80103c77:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103c7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c7e:	8b 00                	mov    (%eax),%eax
80103c80:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103c84:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c87:	8b 00                	mov    (%eax),%eax
80103c89:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c8c:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103c8f:	b8 00 00 00 00       	mov    $0x0,%eax
80103c94:	eb 4d                	jmp    80103ce3 <pipealloc+0x14d>

//PAGEBREAK: 20
 bad:
  if(p)
80103c96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103c9a:	74 0e                	je     80103caa <pipealloc+0x114>
    kfree((char*)p);
80103c9c:	83 ec 0c             	sub    $0xc,%esp
80103c9f:	ff 75 f4             	pushl  -0xc(%ebp)
80103ca2:	e8 27 ee ff ff       	call   80102ace <kfree>
80103ca7:	83 c4 10             	add    $0x10,%esp
  if(*f0)
80103caa:	8b 45 08             	mov    0x8(%ebp),%eax
80103cad:	8b 00                	mov    (%eax),%eax
80103caf:	85 c0                	test   %eax,%eax
80103cb1:	74 11                	je     80103cc4 <pipealloc+0x12e>
    fileclose(*f0);
80103cb3:	8b 45 08             	mov    0x8(%ebp),%eax
80103cb6:	8b 00                	mov    (%eax),%eax
80103cb8:	83 ec 0c             	sub    $0xc,%esp
80103cbb:	50                   	push   %eax
80103cbc:	e8 3b d3 ff ff       	call   80100ffc <fileclose>
80103cc1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cc7:	8b 00                	mov    (%eax),%eax
80103cc9:	85 c0                	test   %eax,%eax
80103ccb:	74 11                	je     80103cde <pipealloc+0x148>
    fileclose(*f1);
80103ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cd0:	8b 00                	mov    (%eax),%eax
80103cd2:	83 ec 0c             	sub    $0xc,%esp
80103cd5:	50                   	push   %eax
80103cd6:	e8 21 d3 ff ff       	call   80100ffc <fileclose>
80103cdb:	83 c4 10             	add    $0x10,%esp
  return -1;
80103cde:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103ce3:	c9                   	leave  
80103ce4:	c3                   	ret    

80103ce5 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103ce5:	55                   	push   %ebp
80103ce6:	89 e5                	mov    %esp,%ebp
80103ce8:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
80103ceb:	8b 45 08             	mov    0x8(%ebp),%eax
80103cee:	83 ec 0c             	sub    $0xc,%esp
80103cf1:	50                   	push   %eax
80103cf2:	e8 ff 0d 00 00       	call   80104af6 <acquire>
80103cf7:	83 c4 10             	add    $0x10,%esp
  if(writable){
80103cfa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103cfe:	74 23                	je     80103d23 <pipeclose+0x3e>
    p->writeopen = 0;
80103d00:	8b 45 08             	mov    0x8(%ebp),%eax
80103d03:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103d0a:	00 00 00 
    wakeup(&p->nread);
80103d0d:	8b 45 08             	mov    0x8(%ebp),%eax
80103d10:	05 34 02 00 00       	add    $0x234,%eax
80103d15:	83 ec 0c             	sub    $0xc,%esp
80103d18:	50                   	push   %eax
80103d19:	e8 d3 0b 00 00       	call   801048f1 <wakeup>
80103d1e:	83 c4 10             	add    $0x10,%esp
80103d21:	eb 21                	jmp    80103d44 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
80103d23:	8b 45 08             	mov    0x8(%ebp),%eax
80103d26:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103d2d:	00 00 00 
    wakeup(&p->nwrite);
80103d30:	8b 45 08             	mov    0x8(%ebp),%eax
80103d33:	05 38 02 00 00       	add    $0x238,%eax
80103d38:	83 ec 0c             	sub    $0xc,%esp
80103d3b:	50                   	push   %eax
80103d3c:	e8 b0 0b 00 00       	call   801048f1 <wakeup>
80103d41:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103d44:	8b 45 08             	mov    0x8(%ebp),%eax
80103d47:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103d4d:	85 c0                	test   %eax,%eax
80103d4f:	75 2c                	jne    80103d7d <pipeclose+0x98>
80103d51:	8b 45 08             	mov    0x8(%ebp),%eax
80103d54:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103d5a:	85 c0                	test   %eax,%eax
80103d5c:	75 1f                	jne    80103d7d <pipeclose+0x98>
    release(&p->lock);
80103d5e:	8b 45 08             	mov    0x8(%ebp),%eax
80103d61:	83 ec 0c             	sub    $0xc,%esp
80103d64:	50                   	push   %eax
80103d65:	e8 f2 0d 00 00       	call   80104b5c <release>
80103d6a:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
80103d6d:	83 ec 0c             	sub    $0xc,%esp
80103d70:	ff 75 08             	pushl  0x8(%ebp)
80103d73:	e8 56 ed ff ff       	call   80102ace <kfree>
80103d78:	83 c4 10             	add    $0x10,%esp
80103d7b:	eb 0f                	jmp    80103d8c <pipeclose+0xa7>
  } else
    release(&p->lock);
80103d7d:	8b 45 08             	mov    0x8(%ebp),%eax
80103d80:	83 ec 0c             	sub    $0xc,%esp
80103d83:	50                   	push   %eax
80103d84:	e8 d3 0d 00 00       	call   80104b5c <release>
80103d89:	83 c4 10             	add    $0x10,%esp
}
80103d8c:	c9                   	leave  
80103d8d:	c3                   	ret    

80103d8e <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103d8e:	55                   	push   %ebp
80103d8f:	89 e5                	mov    %esp,%ebp
80103d91:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
80103d94:	8b 45 08             	mov    0x8(%ebp),%eax
80103d97:	83 ec 0c             	sub    $0xc,%esp
80103d9a:	50                   	push   %eax
80103d9b:	e8 56 0d 00 00       	call   80104af6 <acquire>
80103da0:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
80103da3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103daa:	e9 af 00 00 00       	jmp    80103e5e <pipewrite+0xd0>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103daf:	eb 60                	jmp    80103e11 <pipewrite+0x83>
      if(p->readopen == 0 || proc->killed){
80103db1:	8b 45 08             	mov    0x8(%ebp),%eax
80103db4:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103dba:	85 c0                	test   %eax,%eax
80103dbc:	74 0d                	je     80103dcb <pipewrite+0x3d>
80103dbe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103dc4:	8b 40 24             	mov    0x24(%eax),%eax
80103dc7:	85 c0                	test   %eax,%eax
80103dc9:	74 19                	je     80103de4 <pipewrite+0x56>
        release(&p->lock);
80103dcb:	8b 45 08             	mov    0x8(%ebp),%eax
80103dce:	83 ec 0c             	sub    $0xc,%esp
80103dd1:	50                   	push   %eax
80103dd2:	e8 85 0d 00 00       	call   80104b5c <release>
80103dd7:	83 c4 10             	add    $0x10,%esp
        return -1;
80103dda:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ddf:	e9 ac 00 00 00       	jmp    80103e90 <pipewrite+0x102>
      }
      wakeup(&p->nread);
80103de4:	8b 45 08             	mov    0x8(%ebp),%eax
80103de7:	05 34 02 00 00       	add    $0x234,%eax
80103dec:	83 ec 0c             	sub    $0xc,%esp
80103def:	50                   	push   %eax
80103df0:	e8 fc 0a 00 00       	call   801048f1 <wakeup>
80103df5:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103df8:	8b 45 08             	mov    0x8(%ebp),%eax
80103dfb:	8b 55 08             	mov    0x8(%ebp),%edx
80103dfe:	81 c2 38 02 00 00    	add    $0x238,%edx
80103e04:	83 ec 08             	sub    $0x8,%esp
80103e07:	50                   	push   %eax
80103e08:	52                   	push   %edx
80103e09:	e8 fa 09 00 00       	call   80104808 <sleep>
80103e0e:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e11:	8b 45 08             	mov    0x8(%ebp),%eax
80103e14:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103e1a:	8b 45 08             	mov    0x8(%ebp),%eax
80103e1d:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103e23:	05 00 02 00 00       	add    $0x200,%eax
80103e28:	39 c2                	cmp    %eax,%edx
80103e2a:	74 85                	je     80103db1 <pipewrite+0x23>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103e2c:	8b 45 08             	mov    0x8(%ebp),%eax
80103e2f:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103e35:	8d 48 01             	lea    0x1(%eax),%ecx
80103e38:	8b 55 08             	mov    0x8(%ebp),%edx
80103e3b:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80103e41:	25 ff 01 00 00       	and    $0x1ff,%eax
80103e46:	89 c1                	mov    %eax,%ecx
80103e48:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e4e:	01 d0                	add    %edx,%eax
80103e50:	0f b6 10             	movzbl (%eax),%edx
80103e53:	8b 45 08             	mov    0x8(%ebp),%eax
80103e56:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103e5a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e61:	3b 45 10             	cmp    0x10(%ebp),%eax
80103e64:	0f 8c 45 ff ff ff    	jl     80103daf <pipewrite+0x21>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103e6a:	8b 45 08             	mov    0x8(%ebp),%eax
80103e6d:	05 34 02 00 00       	add    $0x234,%eax
80103e72:	83 ec 0c             	sub    $0xc,%esp
80103e75:	50                   	push   %eax
80103e76:	e8 76 0a 00 00       	call   801048f1 <wakeup>
80103e7b:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103e7e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e81:	83 ec 0c             	sub    $0xc,%esp
80103e84:	50                   	push   %eax
80103e85:	e8 d2 0c 00 00       	call   80104b5c <release>
80103e8a:	83 c4 10             	add    $0x10,%esp
  return n;
80103e8d:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103e90:	c9                   	leave  
80103e91:	c3                   	ret    

80103e92 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103e92:	55                   	push   %ebp
80103e93:	89 e5                	mov    %esp,%ebp
80103e95:	53                   	push   %ebx
80103e96:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
80103e99:	8b 45 08             	mov    0x8(%ebp),%eax
80103e9c:	83 ec 0c             	sub    $0xc,%esp
80103e9f:	50                   	push   %eax
80103ea0:	e8 51 0c 00 00       	call   80104af6 <acquire>
80103ea5:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103ea8:	eb 3f                	jmp    80103ee9 <piperead+0x57>
    if(proc->killed){
80103eaa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103eb0:	8b 40 24             	mov    0x24(%eax),%eax
80103eb3:	85 c0                	test   %eax,%eax
80103eb5:	74 19                	je     80103ed0 <piperead+0x3e>
      release(&p->lock);
80103eb7:	8b 45 08             	mov    0x8(%ebp),%eax
80103eba:	83 ec 0c             	sub    $0xc,%esp
80103ebd:	50                   	push   %eax
80103ebe:	e8 99 0c 00 00       	call   80104b5c <release>
80103ec3:	83 c4 10             	add    $0x10,%esp
      return -1;
80103ec6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ecb:	e9 be 00 00 00       	jmp    80103f8e <piperead+0xfc>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103ed0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ed3:	8b 55 08             	mov    0x8(%ebp),%edx
80103ed6:	81 c2 34 02 00 00    	add    $0x234,%edx
80103edc:	83 ec 08             	sub    $0x8,%esp
80103edf:	50                   	push   %eax
80103ee0:	52                   	push   %edx
80103ee1:	e8 22 09 00 00       	call   80104808 <sleep>
80103ee6:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103ee9:	8b 45 08             	mov    0x8(%ebp),%eax
80103eec:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103ef2:	8b 45 08             	mov    0x8(%ebp),%eax
80103ef5:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103efb:	39 c2                	cmp    %eax,%edx
80103efd:	75 0d                	jne    80103f0c <piperead+0x7a>
80103eff:	8b 45 08             	mov    0x8(%ebp),%eax
80103f02:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103f08:	85 c0                	test   %eax,%eax
80103f0a:	75 9e                	jne    80103eaa <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f0c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103f13:	eb 4b                	jmp    80103f60 <piperead+0xce>
    if(p->nread == p->nwrite)
80103f15:	8b 45 08             	mov    0x8(%ebp),%eax
80103f18:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f1e:	8b 45 08             	mov    0x8(%ebp),%eax
80103f21:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f27:	39 c2                	cmp    %eax,%edx
80103f29:	75 02                	jne    80103f2d <piperead+0x9b>
      break;
80103f2b:	eb 3b                	jmp    80103f68 <piperead+0xd6>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103f2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103f30:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f33:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80103f36:	8b 45 08             	mov    0x8(%ebp),%eax
80103f39:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103f3f:	8d 48 01             	lea    0x1(%eax),%ecx
80103f42:	8b 55 08             	mov    0x8(%ebp),%edx
80103f45:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80103f4b:	25 ff 01 00 00       	and    $0x1ff,%eax
80103f50:	89 c2                	mov    %eax,%edx
80103f52:	8b 45 08             	mov    0x8(%ebp),%eax
80103f55:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80103f5a:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f5c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f63:	3b 45 10             	cmp    0x10(%ebp),%eax
80103f66:	7c ad                	jl     80103f15 <piperead+0x83>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103f68:	8b 45 08             	mov    0x8(%ebp),%eax
80103f6b:	05 38 02 00 00       	add    $0x238,%eax
80103f70:	83 ec 0c             	sub    $0xc,%esp
80103f73:	50                   	push   %eax
80103f74:	e8 78 09 00 00       	call   801048f1 <wakeup>
80103f79:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103f7c:	8b 45 08             	mov    0x8(%ebp),%eax
80103f7f:	83 ec 0c             	sub    $0xc,%esp
80103f82:	50                   	push   %eax
80103f83:	e8 d4 0b 00 00       	call   80104b5c <release>
80103f88:	83 c4 10             	add    $0x10,%esp
  return i;
80103f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103f8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f91:	c9                   	leave  
80103f92:	c3                   	ret    

80103f93 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80103f93:	55                   	push   %ebp
80103f94:	89 e5                	mov    %esp,%ebp
80103f96:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f99:	9c                   	pushf  
80103f9a:	58                   	pop    %eax
80103f9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80103f9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103fa1:	c9                   	leave  
80103fa2:	c3                   	ret    

80103fa3 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80103fa3:	55                   	push   %ebp
80103fa4:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80103fa6:	fb                   	sti    
}
80103fa7:	5d                   	pop    %ebp
80103fa8:	c3                   	ret    

80103fa9 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103fa9:	55                   	push   %ebp
80103faa:	89 e5                	mov    %esp,%ebp
80103fac:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
80103faf:	83 ec 08             	sub    $0x8,%esp
80103fb2:	68 7d 85 10 80       	push   $0x8010857d
80103fb7:	68 c0 ff 10 80       	push   $0x8010ffc0
80103fbc:	e8 14 0b 00 00       	call   80104ad5 <initlock>
80103fc1:	83 c4 10             	add    $0x10,%esp
}
80103fc4:	c9                   	leave  
80103fc5:	c3                   	ret    

80103fc6 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103fc6:	55                   	push   %ebp
80103fc7:	89 e5                	mov    %esp,%ebp
80103fc9:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80103fcc:	83 ec 0c             	sub    $0xc,%esp
80103fcf:	68 c0 ff 10 80       	push   $0x8010ffc0
80103fd4:	e8 1d 0b 00 00       	call   80104af6 <acquire>
80103fd9:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fdc:	c7 45 f4 f4 ff 10 80 	movl   $0x8010fff4,-0xc(%ebp)
80103fe3:	eb 54                	jmp    80104039 <allocproc+0x73>
    if(p->state == UNUSED)
80103fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fe8:	8b 40 0c             	mov    0xc(%eax),%eax
80103feb:	85 c0                	test   %eax,%eax
80103fed:	75 46                	jne    80104035 <allocproc+0x6f>
      goto found;
80103fef:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ff3:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80103ffa:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80103fff:	8d 50 01             	lea    0x1(%eax),%edx
80104002:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
80104008:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010400b:	89 42 10             	mov    %eax,0x10(%edx)
  release(&ptable.lock);
8010400e:	83 ec 0c             	sub    $0xc,%esp
80104011:	68 c0 ff 10 80       	push   $0x8010ffc0
80104016:	e8 41 0b 00 00       	call   80104b5c <release>
8010401b:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010401e:	e8 47 eb ff ff       	call   80102b6a <kalloc>
80104023:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104026:	89 42 08             	mov    %eax,0x8(%edx)
80104029:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010402c:	8b 40 08             	mov    0x8(%eax),%eax
8010402f:	85 c0                	test   %eax,%eax
80104031:	75 37                	jne    8010406a <allocproc+0xa4>
80104033:	eb 24                	jmp    80104059 <allocproc+0x93>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104035:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104039:	81 7d f4 f4 1e 11 80 	cmpl   $0x80111ef4,-0xc(%ebp)
80104040:	72 a3                	jb     80103fe5 <allocproc+0x1f>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
80104042:	83 ec 0c             	sub    $0xc,%esp
80104045:	68 c0 ff 10 80       	push   $0x8010ffc0
8010404a:	e8 0d 0b 00 00       	call   80104b5c <release>
8010404f:	83 c4 10             	add    $0x10,%esp
  return 0;
80104052:	b8 00 00 00 00       	mov    $0x0,%eax
80104057:	eb 6e                	jmp    801040c7 <allocproc+0x101>
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80104059:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010405c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104063:	b8 00 00 00 00       	mov    $0x0,%eax
80104068:	eb 5d                	jmp    801040c7 <allocproc+0x101>
  }
  sp = p->kstack + KSTACKSIZE;
8010406a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010406d:	8b 40 08             	mov    0x8(%eax),%eax
80104070:	05 00 10 00 00       	add    $0x1000,%eax
80104075:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104078:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
8010407c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010407f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104082:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104085:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104089:	ba 10 64 10 80       	mov    $0x80106410,%edx
8010408e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104091:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104093:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010409a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010409d:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801040a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040a3:	8b 40 1c             	mov    0x1c(%eax),%eax
801040a6:	83 ec 04             	sub    $0x4,%esp
801040a9:	6a 14                	push   $0x14
801040ab:	6a 00                	push   $0x0
801040ad:	50                   	push   %eax
801040ae:	e8 9f 0c 00 00       	call   80104d52 <memset>
801040b3:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801040b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040b9:	8b 40 1c             	mov    0x1c(%eax),%eax
801040bc:	ba d8 47 10 80       	mov    $0x801047d8,%edx
801040c1:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801040c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801040c7:	c9                   	leave  
801040c8:	c3                   	ret    

801040c9 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801040c9:	55                   	push   %ebp
801040ca:	89 e5                	mov    %esp,%ebp
801040cc:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
801040cf:	e8 f2 fe ff ff       	call   80103fc6 <allocproc>
801040d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
801040d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040da:	a3 68 b6 10 80       	mov    %eax,0x8010b668
  if((p->pgdir = setupkvm()) == 0)
801040df:	e8 e6 39 00 00       	call   80107aca <setupkvm>
801040e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040e7:	89 42 04             	mov    %eax,0x4(%edx)
801040ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040ed:	8b 40 04             	mov    0x4(%eax),%eax
801040f0:	85 c0                	test   %eax,%eax
801040f2:	75 0d                	jne    80104101 <userinit+0x38>
    panic("userinit: out of memory?");
801040f4:	83 ec 0c             	sub    $0xc,%esp
801040f7:	68 84 85 10 80       	push   $0x80108584
801040fc:	e8 5b c4 ff ff       	call   8010055c <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104101:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104106:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104109:	8b 40 04             	mov    0x4(%eax),%eax
8010410c:	83 ec 04             	sub    $0x4,%esp
8010410f:	52                   	push   %edx
80104110:	68 00 b5 10 80       	push   $0x8010b500
80104115:	50                   	push   %eax
80104116:	e8 04 3c 00 00       	call   80107d1f <inituvm>
8010411b:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
8010411e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104121:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104127:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010412a:	8b 40 18             	mov    0x18(%eax),%eax
8010412d:	83 ec 04             	sub    $0x4,%esp
80104130:	6a 4c                	push   $0x4c
80104132:	6a 00                	push   $0x0
80104134:	50                   	push   %eax
80104135:	e8 18 0c 00 00       	call   80104d52 <memset>
8010413a:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010413d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104140:	8b 40 18             	mov    0x18(%eax),%eax
80104143:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104149:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010414c:	8b 40 18             	mov    0x18(%eax),%eax
8010414f:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104155:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104158:	8b 40 18             	mov    0x18(%eax),%eax
8010415b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010415e:	8b 52 18             	mov    0x18(%edx),%edx
80104161:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104165:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104169:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010416c:	8b 40 18             	mov    0x18(%eax),%eax
8010416f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104172:	8b 52 18             	mov    0x18(%edx),%edx
80104175:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104179:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010417d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104180:	8b 40 18             	mov    0x18(%eax),%eax
80104183:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010418a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010418d:	8b 40 18             	mov    0x18(%eax),%eax
80104190:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104197:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010419a:	8b 40 18             	mov    0x18(%eax),%eax
8010419d:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801041a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041a7:	83 c0 6c             	add    $0x6c,%eax
801041aa:	83 ec 04             	sub    $0x4,%esp
801041ad:	6a 10                	push   $0x10
801041af:	68 9d 85 10 80       	push   $0x8010859d
801041b4:	50                   	push   %eax
801041b5:	e8 9d 0d 00 00       	call   80104f57 <safestrcpy>
801041ba:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
801041bd:	83 ec 0c             	sub    $0xc,%esp
801041c0:	68 a6 85 10 80       	push   $0x801085a6
801041c5:	e8 b2 e2 ff ff       	call   8010247c <namei>
801041ca:	83 c4 10             	add    $0x10,%esp
801041cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041d0:	89 42 68             	mov    %eax,0x68(%edx)

  p->state = RUNNABLE;
801041d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041d6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
801041dd:	c9                   	leave  
801041de:	c3                   	ret    

801041df <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801041df:	55                   	push   %ebp
801041e0:	89 e5                	mov    %esp,%ebp
801041e2:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
801041e5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801041eb:	8b 00                	mov    (%eax),%eax
801041ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801041f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801041f4:	7e 31                	jle    80104227 <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801041f6:	8b 55 08             	mov    0x8(%ebp),%edx
801041f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041fc:	01 c2                	add    %eax,%edx
801041fe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104204:	8b 40 04             	mov    0x4(%eax),%eax
80104207:	83 ec 04             	sub    $0x4,%esp
8010420a:	52                   	push   %edx
8010420b:	ff 75 f4             	pushl  -0xc(%ebp)
8010420e:	50                   	push   %eax
8010420f:	e8 57 3c 00 00       	call   80107e6b <allocuvm>
80104214:	83 c4 10             	add    $0x10,%esp
80104217:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010421a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010421e:	75 3e                	jne    8010425e <growproc+0x7f>
      return -1;
80104220:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104225:	eb 59                	jmp    80104280 <growproc+0xa1>
  } else if(n < 0){
80104227:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010422b:	79 31                	jns    8010425e <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
8010422d:	8b 55 08             	mov    0x8(%ebp),%edx
80104230:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104233:	01 c2                	add    %eax,%edx
80104235:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010423b:	8b 40 04             	mov    0x4(%eax),%eax
8010423e:	83 ec 04             	sub    $0x4,%esp
80104241:	52                   	push   %edx
80104242:	ff 75 f4             	pushl  -0xc(%ebp)
80104245:	50                   	push   %eax
80104246:	e8 e7 3c 00 00       	call   80107f32 <deallocuvm>
8010424b:	83 c4 10             	add    $0x10,%esp
8010424e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104251:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104255:	75 07                	jne    8010425e <growproc+0x7f>
      return -1;
80104257:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010425c:	eb 22                	jmp    80104280 <growproc+0xa1>
  }
  proc->sz = sz;
8010425e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104264:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104267:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104269:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010426f:	83 ec 0c             	sub    $0xc,%esp
80104272:	50                   	push   %eax
80104273:	e8 37 39 00 00       	call   80107baf <switchuvm>
80104278:	83 c4 10             	add    $0x10,%esp
  return 0;
8010427b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104280:	c9                   	leave  
80104281:	c3                   	ret    

80104282 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104282:	55                   	push   %ebp
80104283:	89 e5                	mov    %esp,%ebp
80104285:	57                   	push   %edi
80104286:	56                   	push   %esi
80104287:	53                   	push   %ebx
80104288:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
8010428b:	e8 36 fd ff ff       	call   80103fc6 <allocproc>
80104290:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104293:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104297:	75 0a                	jne    801042a3 <fork+0x21>
    return -1;
80104299:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010429e:	e9 42 01 00 00       	jmp    801043e5 <fork+0x163>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801042a3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042a9:	8b 10                	mov    (%eax),%edx
801042ab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042b1:	8b 40 04             	mov    0x4(%eax),%eax
801042b4:	83 ec 08             	sub    $0x8,%esp
801042b7:	52                   	push   %edx
801042b8:	50                   	push   %eax
801042b9:	e8 10 3e 00 00       	call   801080ce <copyuvm>
801042be:	83 c4 10             	add    $0x10,%esp
801042c1:	8b 55 e0             	mov    -0x20(%ebp),%edx
801042c4:	89 42 04             	mov    %eax,0x4(%edx)
801042c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801042ca:	8b 40 04             	mov    0x4(%eax),%eax
801042cd:	85 c0                	test   %eax,%eax
801042cf:	75 30                	jne    80104301 <fork+0x7f>
    kfree(np->kstack);
801042d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801042d4:	8b 40 08             	mov    0x8(%eax),%eax
801042d7:	83 ec 0c             	sub    $0xc,%esp
801042da:	50                   	push   %eax
801042db:	e8 ee e7 ff ff       	call   80102ace <kfree>
801042e0:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
801042e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801042e6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
801042ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
801042f0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
801042f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042fc:	e9 e4 00 00 00       	jmp    801043e5 <fork+0x163>
  }
  np->sz = proc->sz;
80104301:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104307:	8b 10                	mov    (%eax),%edx
80104309:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010430c:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
8010430e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104315:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104318:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
8010431b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010431e:	8b 50 18             	mov    0x18(%eax),%edx
80104321:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104327:	8b 40 18             	mov    0x18(%eax),%eax
8010432a:	89 c3                	mov    %eax,%ebx
8010432c:	b8 13 00 00 00       	mov    $0x13,%eax
80104331:	89 d7                	mov    %edx,%edi
80104333:	89 de                	mov    %ebx,%esi
80104335:	89 c1                	mov    %eax,%ecx
80104337:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104339:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010433c:	8b 40 18             	mov    0x18(%eax),%eax
8010433f:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104346:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010434d:	eb 41                	jmp    80104390 <fork+0x10e>
    if(proc->ofile[i])
8010434f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104355:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104358:	83 c2 08             	add    $0x8,%edx
8010435b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010435f:	85 c0                	test   %eax,%eax
80104361:	74 29                	je     8010438c <fork+0x10a>
      np->ofile[i] = filedup(proc->ofile[i]);
80104363:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104369:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010436c:	83 c2 08             	add    $0x8,%edx
8010436f:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104373:	83 ec 0c             	sub    $0xc,%esp
80104376:	50                   	push   %eax
80104377:	e8 2f cc ff ff       	call   80100fab <filedup>
8010437c:	83 c4 10             	add    $0x10,%esp
8010437f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104382:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104385:	83 c1 08             	add    $0x8,%ecx
80104388:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010438c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104390:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104394:	7e b9                	jle    8010434f <fork+0xcd>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104396:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010439c:	8b 40 68             	mov    0x68(%eax),%eax
8010439f:	83 ec 0c             	sub    $0xc,%esp
801043a2:	50                   	push   %eax
801043a3:	e8 e1 d4 ff ff       	call   80101889 <idup>
801043a8:	83 c4 10             	add    $0x10,%esp
801043ab:	8b 55 e0             	mov    -0x20(%ebp),%edx
801043ae:	89 42 68             	mov    %eax,0x68(%edx)
 
  pid = np->pid;
801043b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043b4:	8b 40 10             	mov    0x10(%eax),%eax
801043b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  np->state = RUNNABLE;
801043ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043bd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  safestrcpy(np->name, proc->name, sizeof(proc->name));
801043c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043ca:	8d 50 6c             	lea    0x6c(%eax),%edx
801043cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043d0:	83 c0 6c             	add    $0x6c,%eax
801043d3:	83 ec 04             	sub    $0x4,%esp
801043d6:	6a 10                	push   $0x10
801043d8:	52                   	push   %edx
801043d9:	50                   	push   %eax
801043da:	e8 78 0b 00 00       	call   80104f57 <safestrcpy>
801043df:	83 c4 10             	add    $0x10,%esp
  return pid;
801043e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
801043e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043e8:	5b                   	pop    %ebx
801043e9:	5e                   	pop    %esi
801043ea:	5f                   	pop    %edi
801043eb:	5d                   	pop    %ebp
801043ec:	c3                   	ret    

801043ed <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
801043ed:	55                   	push   %ebp
801043ee:	89 e5                	mov    %esp,%ebp
801043f0:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
801043f3:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801043fa:	a1 68 b6 10 80       	mov    0x8010b668,%eax
801043ff:	39 c2                	cmp    %eax,%edx
80104401:	75 0d                	jne    80104410 <exit+0x23>
    panic("init exiting");
80104403:	83 ec 0c             	sub    $0xc,%esp
80104406:	68 a8 85 10 80       	push   $0x801085a8
8010440b:	e8 4c c1 ff ff       	call   8010055c <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104410:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104417:	eb 48                	jmp    80104461 <exit+0x74>
    if(proc->ofile[fd]){
80104419:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010441f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104422:	83 c2 08             	add    $0x8,%edx
80104425:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104429:	85 c0                	test   %eax,%eax
8010442b:	74 30                	je     8010445d <exit+0x70>
      fileclose(proc->ofile[fd]);
8010442d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104433:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104436:	83 c2 08             	add    $0x8,%edx
80104439:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010443d:	83 ec 0c             	sub    $0xc,%esp
80104440:	50                   	push   %eax
80104441:	e8 b6 cb ff ff       	call   80100ffc <fileclose>
80104446:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104449:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010444f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104452:	83 c2 08             	add    $0x8,%edx
80104455:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010445c:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
8010445d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104461:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104465:	7e b2                	jle    80104419 <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  iput(proc->cwd);
80104467:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010446d:	8b 40 68             	mov    0x68(%eax),%eax
80104470:	83 ec 0c             	sub    $0xc,%esp
80104473:	50                   	push   %eax
80104474:	e8 12 d6 ff ff       	call   80101a8b <iput>
80104479:	83 c4 10             	add    $0x10,%esp
  proc->cwd = 0;
8010447c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104482:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104489:	83 ec 0c             	sub    $0xc,%esp
8010448c:	68 c0 ff 10 80       	push   $0x8010ffc0
80104491:	e8 60 06 00 00       	call   80104af6 <acquire>
80104496:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104499:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010449f:	8b 40 14             	mov    0x14(%eax),%eax
801044a2:	83 ec 0c             	sub    $0xc,%esp
801044a5:	50                   	push   %eax
801044a6:	e8 08 04 00 00       	call   801048b3 <wakeup1>
801044ab:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044ae:	c7 45 f4 f4 ff 10 80 	movl   $0x8010fff4,-0xc(%ebp)
801044b5:	eb 3c                	jmp    801044f3 <exit+0x106>
    if(p->parent == proc){
801044b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ba:	8b 50 14             	mov    0x14(%eax),%edx
801044bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044c3:	39 c2                	cmp    %eax,%edx
801044c5:	75 28                	jne    801044ef <exit+0x102>
      p->parent = initproc;
801044c7:	8b 15 68 b6 10 80    	mov    0x8010b668,%edx
801044cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044d0:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
801044d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044d6:	8b 40 0c             	mov    0xc(%eax),%eax
801044d9:	83 f8 05             	cmp    $0x5,%eax
801044dc:	75 11                	jne    801044ef <exit+0x102>
        wakeup1(initproc);
801044de:	a1 68 b6 10 80       	mov    0x8010b668,%eax
801044e3:	83 ec 0c             	sub    $0xc,%esp
801044e6:	50                   	push   %eax
801044e7:	e8 c7 03 00 00       	call   801048b3 <wakeup1>
801044ec:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044ef:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801044f3:	81 7d f4 f4 1e 11 80 	cmpl   $0x80111ef4,-0xc(%ebp)
801044fa:	72 bb                	jb     801044b7 <exit+0xca>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
801044fc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104502:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104509:	e8 d5 01 00 00       	call   801046e3 <sched>
  panic("zombie exit");
8010450e:	83 ec 0c             	sub    $0xc,%esp
80104511:	68 b5 85 10 80       	push   $0x801085b5
80104516:	e8 41 c0 ff ff       	call   8010055c <panic>

8010451b <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
8010451b:	55                   	push   %ebp
8010451c:	89 e5                	mov    %esp,%ebp
8010451e:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104521:	83 ec 0c             	sub    $0xc,%esp
80104524:	68 c0 ff 10 80       	push   $0x8010ffc0
80104529:	e8 c8 05 00 00       	call   80104af6 <acquire>
8010452e:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104531:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104538:	c7 45 f4 f4 ff 10 80 	movl   $0x8010fff4,-0xc(%ebp)
8010453f:	e9 a6 00 00 00       	jmp    801045ea <wait+0xcf>
      if(p->parent != proc)
80104544:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104547:	8b 50 14             	mov    0x14(%eax),%edx
8010454a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104550:	39 c2                	cmp    %eax,%edx
80104552:	74 05                	je     80104559 <wait+0x3e>
        continue;
80104554:	e9 8d 00 00 00       	jmp    801045e6 <wait+0xcb>
      havekids = 1;
80104559:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104560:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104563:	8b 40 0c             	mov    0xc(%eax),%eax
80104566:	83 f8 05             	cmp    $0x5,%eax
80104569:	75 7b                	jne    801045e6 <wait+0xcb>
        // Found one.
        pid = p->pid;
8010456b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010456e:	8b 40 10             	mov    0x10(%eax),%eax
80104571:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104574:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104577:	8b 40 08             	mov    0x8(%eax),%eax
8010457a:	83 ec 0c             	sub    $0xc,%esp
8010457d:	50                   	push   %eax
8010457e:	e8 4b e5 ff ff       	call   80102ace <kfree>
80104583:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104586:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104589:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104590:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104593:	8b 40 04             	mov    0x4(%eax),%eax
80104596:	83 ec 0c             	sub    $0xc,%esp
80104599:	50                   	push   %eax
8010459a:	e8 50 3a 00 00       	call   80107fef <freevm>
8010459f:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
801045a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
801045ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045af:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
801045b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b9:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
801045c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c3:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
801045c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ca:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
801045d1:	83 ec 0c             	sub    $0xc,%esp
801045d4:	68 c0 ff 10 80       	push   $0x8010ffc0
801045d9:	e8 7e 05 00 00       	call   80104b5c <release>
801045de:	83 c4 10             	add    $0x10,%esp
        return pid;
801045e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801045e4:	eb 57                	jmp    8010463d <wait+0x122>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045e6:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801045ea:	81 7d f4 f4 1e 11 80 	cmpl   $0x80111ef4,-0xc(%ebp)
801045f1:	0f 82 4d ff ff ff    	jb     80104544 <wait+0x29>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
801045f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801045fb:	74 0d                	je     8010460a <wait+0xef>
801045fd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104603:	8b 40 24             	mov    0x24(%eax),%eax
80104606:	85 c0                	test   %eax,%eax
80104608:	74 17                	je     80104621 <wait+0x106>
      release(&ptable.lock);
8010460a:	83 ec 0c             	sub    $0xc,%esp
8010460d:	68 c0 ff 10 80       	push   $0x8010ffc0
80104612:	e8 45 05 00 00       	call   80104b5c <release>
80104617:	83 c4 10             	add    $0x10,%esp
      return -1;
8010461a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010461f:	eb 1c                	jmp    8010463d <wait+0x122>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104621:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104627:	83 ec 08             	sub    $0x8,%esp
8010462a:	68 c0 ff 10 80       	push   $0x8010ffc0
8010462f:	50                   	push   %eax
80104630:	e8 d3 01 00 00       	call   80104808 <sleep>
80104635:	83 c4 10             	add    $0x10,%esp
  }
80104638:	e9 f4 fe ff ff       	jmp    80104531 <wait+0x16>
}
8010463d:	c9                   	leave  
8010463e:	c3                   	ret    

8010463f <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
8010463f:	55                   	push   %ebp
80104640:	89 e5                	mov    %esp,%ebp
80104642:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104645:	e8 59 f9 ff ff       	call   80103fa3 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
8010464a:	83 ec 0c             	sub    $0xc,%esp
8010464d:	68 c0 ff 10 80       	push   $0x8010ffc0
80104652:	e8 9f 04 00 00       	call   80104af6 <acquire>
80104657:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010465a:	c7 45 f4 f4 ff 10 80 	movl   $0x8010fff4,-0xc(%ebp)
80104661:	eb 62                	jmp    801046c5 <scheduler+0x86>
      if(p->state != RUNNABLE)
80104663:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104666:	8b 40 0c             	mov    0xc(%eax),%eax
80104669:	83 f8 03             	cmp    $0x3,%eax
8010466c:	74 02                	je     80104670 <scheduler+0x31>
        continue;
8010466e:	eb 51                	jmp    801046c1 <scheduler+0x82>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104670:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104673:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104679:	83 ec 0c             	sub    $0xc,%esp
8010467c:	ff 75 f4             	pushl  -0xc(%ebp)
8010467f:	e8 2b 35 00 00       	call   80107baf <switchuvm>
80104684:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104687:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010468a:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104691:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104697:	8b 40 1c             	mov    0x1c(%eax),%eax
8010469a:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801046a1:	83 c2 04             	add    $0x4,%edx
801046a4:	83 ec 08             	sub    $0x8,%esp
801046a7:	50                   	push   %eax
801046a8:	52                   	push   %edx
801046a9:	e8 1a 09 00 00       	call   80104fc8 <swtch>
801046ae:	83 c4 10             	add    $0x10,%esp
      switchkvm();
801046b1:	e8 dd 34 00 00       	call   80107b93 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
801046b6:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801046bd:	00 00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046c1:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
801046c5:	81 7d f4 f4 1e 11 80 	cmpl   $0x80111ef4,-0xc(%ebp)
801046cc:	72 95                	jb     80104663 <scheduler+0x24>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
801046ce:	83 ec 0c             	sub    $0xc,%esp
801046d1:	68 c0 ff 10 80       	push   $0x8010ffc0
801046d6:	e8 81 04 00 00       	call   80104b5c <release>
801046db:	83 c4 10             	add    $0x10,%esp

  }
801046de:	e9 62 ff ff ff       	jmp    80104645 <scheduler+0x6>

801046e3 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
801046e3:	55                   	push   %ebp
801046e4:	89 e5                	mov    %esp,%ebp
801046e6:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if(!holding(&ptable.lock))
801046e9:	83 ec 0c             	sub    $0xc,%esp
801046ec:	68 c0 ff 10 80       	push   $0x8010ffc0
801046f1:	e8 30 05 00 00       	call   80104c26 <holding>
801046f6:	83 c4 10             	add    $0x10,%esp
801046f9:	85 c0                	test   %eax,%eax
801046fb:	75 0d                	jne    8010470a <sched+0x27>
    panic("sched ptable.lock");
801046fd:	83 ec 0c             	sub    $0xc,%esp
80104700:	68 c1 85 10 80       	push   $0x801085c1
80104705:	e8 52 be ff ff       	call   8010055c <panic>
  if(cpu->ncli != 1)
8010470a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104710:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104716:	83 f8 01             	cmp    $0x1,%eax
80104719:	74 0d                	je     80104728 <sched+0x45>
    panic("sched locks");
8010471b:	83 ec 0c             	sub    $0xc,%esp
8010471e:	68 d3 85 10 80       	push   $0x801085d3
80104723:	e8 34 be ff ff       	call   8010055c <panic>
  if(proc->state == RUNNING)
80104728:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010472e:	8b 40 0c             	mov    0xc(%eax),%eax
80104731:	83 f8 04             	cmp    $0x4,%eax
80104734:	75 0d                	jne    80104743 <sched+0x60>
    panic("sched running");
80104736:	83 ec 0c             	sub    $0xc,%esp
80104739:	68 df 85 10 80       	push   $0x801085df
8010473e:	e8 19 be ff ff       	call   8010055c <panic>
  if(readeflags()&FL_IF)
80104743:	e8 4b f8 ff ff       	call   80103f93 <readeflags>
80104748:	25 00 02 00 00       	and    $0x200,%eax
8010474d:	85 c0                	test   %eax,%eax
8010474f:	74 0d                	je     8010475e <sched+0x7b>
    panic("sched interruptible");
80104751:	83 ec 0c             	sub    $0xc,%esp
80104754:	68 ed 85 10 80       	push   $0x801085ed
80104759:	e8 fe bd ff ff       	call   8010055c <panic>
  intena = cpu->intena;
8010475e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104764:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010476a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
8010476d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104773:	8b 40 04             	mov    0x4(%eax),%eax
80104776:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010477d:	83 c2 1c             	add    $0x1c,%edx
80104780:	83 ec 08             	sub    $0x8,%esp
80104783:	50                   	push   %eax
80104784:	52                   	push   %edx
80104785:	e8 3e 08 00 00       	call   80104fc8 <swtch>
8010478a:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
8010478d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104793:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104796:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010479c:	c9                   	leave  
8010479d:	c3                   	ret    

8010479e <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
8010479e:	55                   	push   %ebp
8010479f:	89 e5                	mov    %esp,%ebp
801047a1:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801047a4:	83 ec 0c             	sub    $0xc,%esp
801047a7:	68 c0 ff 10 80       	push   $0x8010ffc0
801047ac:	e8 45 03 00 00       	call   80104af6 <acquire>
801047b1:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
801047b4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047ba:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
801047c1:	e8 1d ff ff ff       	call   801046e3 <sched>
  release(&ptable.lock);
801047c6:	83 ec 0c             	sub    $0xc,%esp
801047c9:	68 c0 ff 10 80       	push   $0x8010ffc0
801047ce:	e8 89 03 00 00       	call   80104b5c <release>
801047d3:	83 c4 10             	add    $0x10,%esp
}
801047d6:	c9                   	leave  
801047d7:	c3                   	ret    

801047d8 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801047d8:	55                   	push   %ebp
801047d9:	89 e5                	mov    %esp,%ebp
801047db:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801047de:	83 ec 0c             	sub    $0xc,%esp
801047e1:	68 c0 ff 10 80       	push   $0x8010ffc0
801047e6:	e8 71 03 00 00       	call   80104b5c <release>
801047eb:	83 c4 10             	add    $0x10,%esp

  if (first) {
801047ee:	a1 08 b0 10 80       	mov    0x8010b008,%eax
801047f3:	85 c0                	test   %eax,%eax
801047f5:	74 0f                	je     80104806 <forkret+0x2e>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
801047f7:	c7 05 08 b0 10 80 00 	movl   $0x0,0x8010b008
801047fe:	00 00 00 
    initlog();
80104801:	e8 00 e8 ff ff       	call   80103006 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104806:	c9                   	leave  
80104807:	c3                   	ret    

80104808 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104808:	55                   	push   %ebp
80104809:	89 e5                	mov    %esp,%ebp
8010480b:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
8010480e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104814:	85 c0                	test   %eax,%eax
80104816:	75 0d                	jne    80104825 <sleep+0x1d>
    panic("sleep");
80104818:	83 ec 0c             	sub    $0xc,%esp
8010481b:	68 01 86 10 80       	push   $0x80108601
80104820:	e8 37 bd ff ff       	call   8010055c <panic>

  if(lk == 0)
80104825:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104829:	75 0d                	jne    80104838 <sleep+0x30>
    panic("sleep without lk");
8010482b:	83 ec 0c             	sub    $0xc,%esp
8010482e:	68 07 86 10 80       	push   $0x80108607
80104833:	e8 24 bd ff ff       	call   8010055c <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104838:	81 7d 0c c0 ff 10 80 	cmpl   $0x8010ffc0,0xc(%ebp)
8010483f:	74 1e                	je     8010485f <sleep+0x57>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104841:	83 ec 0c             	sub    $0xc,%esp
80104844:	68 c0 ff 10 80       	push   $0x8010ffc0
80104849:	e8 a8 02 00 00       	call   80104af6 <acquire>
8010484e:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104851:	83 ec 0c             	sub    $0xc,%esp
80104854:	ff 75 0c             	pushl  0xc(%ebp)
80104857:	e8 00 03 00 00       	call   80104b5c <release>
8010485c:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
8010485f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104865:	8b 55 08             	mov    0x8(%ebp),%edx
80104868:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
8010486b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104871:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104878:	e8 66 fe ff ff       	call   801046e3 <sched>

  // Tidy up.
  proc->chan = 0;
8010487d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104883:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
8010488a:	81 7d 0c c0 ff 10 80 	cmpl   $0x8010ffc0,0xc(%ebp)
80104891:	74 1e                	je     801048b1 <sleep+0xa9>
    release(&ptable.lock);
80104893:	83 ec 0c             	sub    $0xc,%esp
80104896:	68 c0 ff 10 80       	push   $0x8010ffc0
8010489b:	e8 bc 02 00 00       	call   80104b5c <release>
801048a0:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
801048a3:	83 ec 0c             	sub    $0xc,%esp
801048a6:	ff 75 0c             	pushl  0xc(%ebp)
801048a9:	e8 48 02 00 00       	call   80104af6 <acquire>
801048ae:	83 c4 10             	add    $0x10,%esp
  }
}
801048b1:	c9                   	leave  
801048b2:	c3                   	ret    

801048b3 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
801048b3:	55                   	push   %ebp
801048b4:	89 e5                	mov    %esp,%ebp
801048b6:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048b9:	c7 45 fc f4 ff 10 80 	movl   $0x8010fff4,-0x4(%ebp)
801048c0:	eb 24                	jmp    801048e6 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
801048c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801048c5:	8b 40 0c             	mov    0xc(%eax),%eax
801048c8:	83 f8 02             	cmp    $0x2,%eax
801048cb:	75 15                	jne    801048e2 <wakeup1+0x2f>
801048cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801048d0:	8b 40 20             	mov    0x20(%eax),%eax
801048d3:	3b 45 08             	cmp    0x8(%ebp),%eax
801048d6:	75 0a                	jne    801048e2 <wakeup1+0x2f>
      p->state = RUNNABLE;
801048d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801048db:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048e2:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
801048e6:	81 7d fc f4 1e 11 80 	cmpl   $0x80111ef4,-0x4(%ebp)
801048ed:	72 d3                	jb     801048c2 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
801048ef:	c9                   	leave  
801048f0:	c3                   	ret    

801048f1 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801048f1:	55                   	push   %ebp
801048f2:	89 e5                	mov    %esp,%ebp
801048f4:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
801048f7:	83 ec 0c             	sub    $0xc,%esp
801048fa:	68 c0 ff 10 80       	push   $0x8010ffc0
801048ff:	e8 f2 01 00 00       	call   80104af6 <acquire>
80104904:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104907:	83 ec 0c             	sub    $0xc,%esp
8010490a:	ff 75 08             	pushl  0x8(%ebp)
8010490d:	e8 a1 ff ff ff       	call   801048b3 <wakeup1>
80104912:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104915:	83 ec 0c             	sub    $0xc,%esp
80104918:	68 c0 ff 10 80       	push   $0x8010ffc0
8010491d:	e8 3a 02 00 00       	call   80104b5c <release>
80104922:	83 c4 10             	add    $0x10,%esp
}
80104925:	c9                   	leave  
80104926:	c3                   	ret    

80104927 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104927:	55                   	push   %ebp
80104928:	89 e5                	mov    %esp,%ebp
8010492a:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
8010492d:	83 ec 0c             	sub    $0xc,%esp
80104930:	68 c0 ff 10 80       	push   $0x8010ffc0
80104935:	e8 bc 01 00 00       	call   80104af6 <acquire>
8010493a:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010493d:	c7 45 f4 f4 ff 10 80 	movl   $0x8010fff4,-0xc(%ebp)
80104944:	eb 45                	jmp    8010498b <kill+0x64>
    if(p->pid == pid){
80104946:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104949:	8b 40 10             	mov    0x10(%eax),%eax
8010494c:	3b 45 08             	cmp    0x8(%ebp),%eax
8010494f:	75 36                	jne    80104987 <kill+0x60>
      p->killed = 1;
80104951:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104954:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010495b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010495e:	8b 40 0c             	mov    0xc(%eax),%eax
80104961:	83 f8 02             	cmp    $0x2,%eax
80104964:	75 0a                	jne    80104970 <kill+0x49>
        p->state = RUNNABLE;
80104966:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104969:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104970:	83 ec 0c             	sub    $0xc,%esp
80104973:	68 c0 ff 10 80       	push   $0x8010ffc0
80104978:	e8 df 01 00 00       	call   80104b5c <release>
8010497d:	83 c4 10             	add    $0x10,%esp
      return 0;
80104980:	b8 00 00 00 00       	mov    $0x0,%eax
80104985:	eb 22                	jmp    801049a9 <kill+0x82>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104987:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
8010498b:	81 7d f4 f4 1e 11 80 	cmpl   $0x80111ef4,-0xc(%ebp)
80104992:	72 b2                	jb     80104946 <kill+0x1f>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104994:	83 ec 0c             	sub    $0xc,%esp
80104997:	68 c0 ff 10 80       	push   $0x8010ffc0
8010499c:	e8 bb 01 00 00       	call   80104b5c <release>
801049a1:	83 c4 10             	add    $0x10,%esp
  return -1;
801049a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049a9:	c9                   	leave  
801049aa:	c3                   	ret    

801049ab <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801049ab:	55                   	push   %ebp
801049ac:	89 e5                	mov    %esp,%ebp
801049ae:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049b1:	c7 45 f0 f4 ff 10 80 	movl   $0x8010fff4,-0x10(%ebp)
801049b8:	e9 d3 00 00 00       	jmp    80104a90 <procdump+0xe5>
    if(p->state == UNUSED)
801049bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049c0:	8b 40 0c             	mov    0xc(%eax),%eax
801049c3:	85 c0                	test   %eax,%eax
801049c5:	75 05                	jne    801049cc <procdump+0x21>
      continue;
801049c7:	e9 c0 00 00 00       	jmp    80104a8c <procdump+0xe1>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801049cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049cf:	8b 40 0c             	mov    0xc(%eax),%eax
801049d2:	83 f8 05             	cmp    $0x5,%eax
801049d5:	77 23                	ja     801049fa <procdump+0x4f>
801049d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049da:	8b 40 0c             	mov    0xc(%eax),%eax
801049dd:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
801049e4:	85 c0                	test   %eax,%eax
801049e6:	74 12                	je     801049fa <procdump+0x4f>
      state = states[p->state];
801049e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049eb:	8b 40 0c             	mov    0xc(%eax),%eax
801049ee:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
801049f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
801049f8:	eb 07                	jmp    80104a01 <procdump+0x56>
    else
      state = "???";
801049fa:	c7 45 ec 18 86 10 80 	movl   $0x80108618,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104a01:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a04:	8d 50 6c             	lea    0x6c(%eax),%edx
80104a07:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a0a:	8b 40 10             	mov    0x10(%eax),%eax
80104a0d:	52                   	push   %edx
80104a0e:	ff 75 ec             	pushl  -0x14(%ebp)
80104a11:	50                   	push   %eax
80104a12:	68 1c 86 10 80       	push   $0x8010861c
80104a17:	e8 a3 b9 ff ff       	call   801003bf <cprintf>
80104a1c:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80104a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a22:	8b 40 0c             	mov    0xc(%eax),%eax
80104a25:	83 f8 02             	cmp    $0x2,%eax
80104a28:	75 52                	jne    80104a7c <procdump+0xd1>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a2d:	8b 40 1c             	mov    0x1c(%eax),%eax
80104a30:	8b 40 0c             	mov    0xc(%eax),%eax
80104a33:	83 c0 08             	add    $0x8,%eax
80104a36:	83 ec 08             	sub    $0x8,%esp
80104a39:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104a3c:	52                   	push   %edx
80104a3d:	50                   	push   %eax
80104a3e:	e8 6a 01 00 00       	call   80104bad <getcallerpcs>
80104a43:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104a46:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104a4d:	eb 1c                	jmp    80104a6b <procdump+0xc0>
        cprintf(" %p", pc[i]);
80104a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a52:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104a56:	83 ec 08             	sub    $0x8,%esp
80104a59:	50                   	push   %eax
80104a5a:	68 25 86 10 80       	push   $0x80108625
80104a5f:	e8 5b b9 ff ff       	call   801003bf <cprintf>
80104a64:	83 c4 10             	add    $0x10,%esp
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104a67:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104a6b:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104a6f:	7f 0b                	jg     80104a7c <procdump+0xd1>
80104a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a74:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104a78:	85 c0                	test   %eax,%eax
80104a7a:	75 d3                	jne    80104a4f <procdump+0xa4>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104a7c:	83 ec 0c             	sub    $0xc,%esp
80104a7f:	68 29 86 10 80       	push   $0x80108629
80104a84:	e8 36 b9 ff ff       	call   801003bf <cprintf>
80104a89:	83 c4 10             	add    $0x10,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a8c:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80104a90:	81 7d f0 f4 1e 11 80 	cmpl   $0x80111ef4,-0x10(%ebp)
80104a97:	0f 82 20 ff ff ff    	jb     801049bd <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104a9d:	c9                   	leave  
80104a9e:	c3                   	ret    

80104a9f <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104a9f:	55                   	push   %ebp
80104aa0:	89 e5                	mov    %esp,%ebp
80104aa2:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104aa5:	9c                   	pushf  
80104aa6:	58                   	pop    %eax
80104aa7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104aaa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104aad:	c9                   	leave  
80104aae:	c3                   	ret    

80104aaf <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104aaf:	55                   	push   %ebp
80104ab0:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104ab2:	fa                   	cli    
}
80104ab3:	5d                   	pop    %ebp
80104ab4:	c3                   	ret    

80104ab5 <sti>:

static inline void
sti(void)
{
80104ab5:	55                   	push   %ebp
80104ab6:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104ab8:	fb                   	sti    
}
80104ab9:	5d                   	pop    %ebp
80104aba:	c3                   	ret    

80104abb <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104abb:	55                   	push   %ebp
80104abc:	89 e5                	mov    %esp,%ebp
80104abe:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104ac1:	8b 55 08             	mov    0x8(%ebp),%edx
80104ac4:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ac7:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104aca:	f0 87 02             	lock xchg %eax,(%edx)
80104acd:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104ad0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104ad3:	c9                   	leave  
80104ad4:	c3                   	ret    

80104ad5 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104ad5:	55                   	push   %ebp
80104ad6:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104ad8:	8b 45 08             	mov    0x8(%ebp),%eax
80104adb:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ade:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104ae1:	8b 45 08             	mov    0x8(%ebp),%eax
80104ae4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104aea:	8b 45 08             	mov    0x8(%ebp),%eax
80104aed:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104af4:	5d                   	pop    %ebp
80104af5:	c3                   	ret    

80104af6 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104af6:	55                   	push   %ebp
80104af7:	89 e5                	mov    %esp,%ebp
80104af9:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104afc:	e8 4f 01 00 00       	call   80104c50 <pushcli>
  if(holding(lk))
80104b01:	8b 45 08             	mov    0x8(%ebp),%eax
80104b04:	83 ec 0c             	sub    $0xc,%esp
80104b07:	50                   	push   %eax
80104b08:	e8 19 01 00 00       	call   80104c26 <holding>
80104b0d:	83 c4 10             	add    $0x10,%esp
80104b10:	85 c0                	test   %eax,%eax
80104b12:	74 0d                	je     80104b21 <acquire+0x2b>
    panic("acquire");
80104b14:	83 ec 0c             	sub    $0xc,%esp
80104b17:	68 55 86 10 80       	push   $0x80108655
80104b1c:	e8 3b ba ff ff       	call   8010055c <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80104b21:	90                   	nop
80104b22:	8b 45 08             	mov    0x8(%ebp),%eax
80104b25:	83 ec 08             	sub    $0x8,%esp
80104b28:	6a 01                	push   $0x1
80104b2a:	50                   	push   %eax
80104b2b:	e8 8b ff ff ff       	call   80104abb <xchg>
80104b30:	83 c4 10             	add    $0x10,%esp
80104b33:	85 c0                	test   %eax,%eax
80104b35:	75 eb                	jne    80104b22 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104b37:	8b 45 08             	mov    0x8(%ebp),%eax
80104b3a:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104b41:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80104b44:	8b 45 08             	mov    0x8(%ebp),%eax
80104b47:	83 c0 0c             	add    $0xc,%eax
80104b4a:	83 ec 08             	sub    $0x8,%esp
80104b4d:	50                   	push   %eax
80104b4e:	8d 45 08             	lea    0x8(%ebp),%eax
80104b51:	50                   	push   %eax
80104b52:	e8 56 00 00 00       	call   80104bad <getcallerpcs>
80104b57:	83 c4 10             	add    $0x10,%esp
}
80104b5a:	c9                   	leave  
80104b5b:	c3                   	ret    

80104b5c <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104b5c:	55                   	push   %ebp
80104b5d:	89 e5                	mov    %esp,%ebp
80104b5f:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80104b62:	83 ec 0c             	sub    $0xc,%esp
80104b65:	ff 75 08             	pushl  0x8(%ebp)
80104b68:	e8 b9 00 00 00       	call   80104c26 <holding>
80104b6d:	83 c4 10             	add    $0x10,%esp
80104b70:	85 c0                	test   %eax,%eax
80104b72:	75 0d                	jne    80104b81 <release+0x25>
    panic("release");
80104b74:	83 ec 0c             	sub    $0xc,%esp
80104b77:	68 5d 86 10 80       	push   $0x8010865d
80104b7c:	e8 db b9 ff ff       	call   8010055c <panic>

  lk->pcs[0] = 0;
80104b81:	8b 45 08             	mov    0x8(%ebp),%eax
80104b84:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104b8b:	8b 45 08             	mov    0x8(%ebp),%eax
80104b8e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80104b95:	8b 45 08             	mov    0x8(%ebp),%eax
80104b98:	83 ec 08             	sub    $0x8,%esp
80104b9b:	6a 00                	push   $0x0
80104b9d:	50                   	push   %eax
80104b9e:	e8 18 ff ff ff       	call   80104abb <xchg>
80104ba3:	83 c4 10             	add    $0x10,%esp

  popcli();
80104ba6:	e8 e9 00 00 00       	call   80104c94 <popcli>
}
80104bab:	c9                   	leave  
80104bac:	c3                   	ret    

80104bad <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104bad:	55                   	push   %ebp
80104bae:	89 e5                	mov    %esp,%ebp
80104bb0:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80104bb3:	8b 45 08             	mov    0x8(%ebp),%eax
80104bb6:	83 e8 08             	sub    $0x8,%eax
80104bb9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104bbc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104bc3:	eb 38                	jmp    80104bfd <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104bc5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104bc9:	74 38                	je     80104c03 <getcallerpcs+0x56>
80104bcb:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104bd2:	76 2f                	jbe    80104c03 <getcallerpcs+0x56>
80104bd4:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104bd8:	74 29                	je     80104c03 <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104bda:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104bdd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104be4:	8b 45 0c             	mov    0xc(%ebp),%eax
80104be7:	01 c2                	add    %eax,%edx
80104be9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104bec:	8b 40 04             	mov    0x4(%eax),%eax
80104bef:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80104bf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104bf4:	8b 00                	mov    (%eax),%eax
80104bf6:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104bf9:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104bfd:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104c01:	7e c2                	jle    80104bc5 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104c03:	eb 19                	jmp    80104c1e <getcallerpcs+0x71>
    pcs[i] = 0;
80104c05:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104c08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c12:	01 d0                	add    %edx,%eax
80104c14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104c1a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104c1e:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104c22:	7e e1                	jle    80104c05 <getcallerpcs+0x58>
    pcs[i] = 0;
}
80104c24:	c9                   	leave  
80104c25:	c3                   	ret    

80104c26 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104c26:	55                   	push   %ebp
80104c27:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80104c29:	8b 45 08             	mov    0x8(%ebp),%eax
80104c2c:	8b 00                	mov    (%eax),%eax
80104c2e:	85 c0                	test   %eax,%eax
80104c30:	74 17                	je     80104c49 <holding+0x23>
80104c32:	8b 45 08             	mov    0x8(%ebp),%eax
80104c35:	8b 50 08             	mov    0x8(%eax),%edx
80104c38:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c3e:	39 c2                	cmp    %eax,%edx
80104c40:	75 07                	jne    80104c49 <holding+0x23>
80104c42:	b8 01 00 00 00       	mov    $0x1,%eax
80104c47:	eb 05                	jmp    80104c4e <holding+0x28>
80104c49:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104c4e:	5d                   	pop    %ebp
80104c4f:	c3                   	ret    

80104c50 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80104c56:	e8 44 fe ff ff       	call   80104a9f <readeflags>
80104c5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80104c5e:	e8 4c fe ff ff       	call   80104aaf <cli>
  if(cpu->ncli++ == 0)
80104c63:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104c6a:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80104c70:	8d 48 01             	lea    0x1(%eax),%ecx
80104c73:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80104c79:	85 c0                	test   %eax,%eax
80104c7b:	75 15                	jne    80104c92 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80104c7d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c83:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104c86:	81 e2 00 02 00 00    	and    $0x200,%edx
80104c8c:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104c92:	c9                   	leave  
80104c93:	c3                   	ret    

80104c94 <popcli>:

void
popcli(void)
{
80104c94:	55                   	push   %ebp
80104c95:	89 e5                	mov    %esp,%ebp
80104c97:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80104c9a:	e8 00 fe ff ff       	call   80104a9f <readeflags>
80104c9f:	25 00 02 00 00       	and    $0x200,%eax
80104ca4:	85 c0                	test   %eax,%eax
80104ca6:	74 0d                	je     80104cb5 <popcli+0x21>
    panic("popcli - interruptible");
80104ca8:	83 ec 0c             	sub    $0xc,%esp
80104cab:	68 65 86 10 80       	push   $0x80108665
80104cb0:	e8 a7 b8 ff ff       	call   8010055c <panic>
  if(--cpu->ncli < 0)
80104cb5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104cbb:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104cc1:	83 ea 01             	sub    $0x1,%edx
80104cc4:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80104cca:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104cd0:	85 c0                	test   %eax,%eax
80104cd2:	79 0d                	jns    80104ce1 <popcli+0x4d>
    panic("popcli");
80104cd4:	83 ec 0c             	sub    $0xc,%esp
80104cd7:	68 7c 86 10 80       	push   $0x8010867c
80104cdc:	e8 7b b8 ff ff       	call   8010055c <panic>
  if(cpu->ncli == 0 && cpu->intena)
80104ce1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104ce7:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104ced:	85 c0                	test   %eax,%eax
80104cef:	75 15                	jne    80104d06 <popcli+0x72>
80104cf1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104cf7:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104cfd:	85 c0                	test   %eax,%eax
80104cff:	74 05                	je     80104d06 <popcli+0x72>
    sti();
80104d01:	e8 af fd ff ff       	call   80104ab5 <sti>
}
80104d06:	c9                   	leave  
80104d07:	c3                   	ret    

80104d08 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80104d08:	55                   	push   %ebp
80104d09:	89 e5                	mov    %esp,%ebp
80104d0b:	57                   	push   %edi
80104d0c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80104d0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104d10:	8b 55 10             	mov    0x10(%ebp),%edx
80104d13:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d16:	89 cb                	mov    %ecx,%ebx
80104d18:	89 df                	mov    %ebx,%edi
80104d1a:	89 d1                	mov    %edx,%ecx
80104d1c:	fc                   	cld    
80104d1d:	f3 aa                	rep stos %al,%es:(%edi)
80104d1f:	89 ca                	mov    %ecx,%edx
80104d21:	89 fb                	mov    %edi,%ebx
80104d23:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104d26:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80104d29:	5b                   	pop    %ebx
80104d2a:	5f                   	pop    %edi
80104d2b:	5d                   	pop    %ebp
80104d2c:	c3                   	ret    

80104d2d <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80104d2d:	55                   	push   %ebp
80104d2e:	89 e5                	mov    %esp,%ebp
80104d30:	57                   	push   %edi
80104d31:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80104d32:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104d35:	8b 55 10             	mov    0x10(%ebp),%edx
80104d38:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d3b:	89 cb                	mov    %ecx,%ebx
80104d3d:	89 df                	mov    %ebx,%edi
80104d3f:	89 d1                	mov    %edx,%ecx
80104d41:	fc                   	cld    
80104d42:	f3 ab                	rep stos %eax,%es:(%edi)
80104d44:	89 ca                	mov    %ecx,%edx
80104d46:	89 fb                	mov    %edi,%ebx
80104d48:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104d4b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80104d4e:	5b                   	pop    %ebx
80104d4f:	5f                   	pop    %edi
80104d50:	5d                   	pop    %ebp
80104d51:	c3                   	ret    

80104d52 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104d52:	55                   	push   %ebp
80104d53:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80104d55:	8b 45 08             	mov    0x8(%ebp),%eax
80104d58:	83 e0 03             	and    $0x3,%eax
80104d5b:	85 c0                	test   %eax,%eax
80104d5d:	75 43                	jne    80104da2 <memset+0x50>
80104d5f:	8b 45 10             	mov    0x10(%ebp),%eax
80104d62:	83 e0 03             	and    $0x3,%eax
80104d65:	85 c0                	test   %eax,%eax
80104d67:	75 39                	jne    80104da2 <memset+0x50>
    c &= 0xFF;
80104d69:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104d70:	8b 45 10             	mov    0x10(%ebp),%eax
80104d73:	c1 e8 02             	shr    $0x2,%eax
80104d76:	89 c2                	mov    %eax,%edx
80104d78:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d7b:	c1 e0 18             	shl    $0x18,%eax
80104d7e:	89 c1                	mov    %eax,%ecx
80104d80:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d83:	c1 e0 10             	shl    $0x10,%eax
80104d86:	09 c1                	or     %eax,%ecx
80104d88:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d8b:	c1 e0 08             	shl    $0x8,%eax
80104d8e:	09 c8                	or     %ecx,%eax
80104d90:	0b 45 0c             	or     0xc(%ebp),%eax
80104d93:	52                   	push   %edx
80104d94:	50                   	push   %eax
80104d95:	ff 75 08             	pushl  0x8(%ebp)
80104d98:	e8 90 ff ff ff       	call   80104d2d <stosl>
80104d9d:	83 c4 0c             	add    $0xc,%esp
80104da0:	eb 12                	jmp    80104db4 <memset+0x62>
  } else
    stosb(dst, c, n);
80104da2:	8b 45 10             	mov    0x10(%ebp),%eax
80104da5:	50                   	push   %eax
80104da6:	ff 75 0c             	pushl  0xc(%ebp)
80104da9:	ff 75 08             	pushl  0x8(%ebp)
80104dac:	e8 57 ff ff ff       	call   80104d08 <stosb>
80104db1:	83 c4 0c             	add    $0xc,%esp
  return dst;
80104db4:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104db7:	c9                   	leave  
80104db8:	c3                   	ret    

80104db9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104db9:	55                   	push   %ebp
80104dba:	89 e5                	mov    %esp,%ebp
80104dbc:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80104dbf:	8b 45 08             	mov    0x8(%ebp),%eax
80104dc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80104dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dc8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80104dcb:	eb 30                	jmp    80104dfd <memcmp+0x44>
    if(*s1 != *s2)
80104dcd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104dd0:	0f b6 10             	movzbl (%eax),%edx
80104dd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104dd6:	0f b6 00             	movzbl (%eax),%eax
80104dd9:	38 c2                	cmp    %al,%dl
80104ddb:	74 18                	je     80104df5 <memcmp+0x3c>
      return *s1 - *s2;
80104ddd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104de0:	0f b6 00             	movzbl (%eax),%eax
80104de3:	0f b6 d0             	movzbl %al,%edx
80104de6:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104de9:	0f b6 00             	movzbl (%eax),%eax
80104dec:	0f b6 c0             	movzbl %al,%eax
80104def:	29 c2                	sub    %eax,%edx
80104df1:	89 d0                	mov    %edx,%eax
80104df3:	eb 1a                	jmp    80104e0f <memcmp+0x56>
    s1++, s2++;
80104df5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104df9:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104dfd:	8b 45 10             	mov    0x10(%ebp),%eax
80104e00:	8d 50 ff             	lea    -0x1(%eax),%edx
80104e03:	89 55 10             	mov    %edx,0x10(%ebp)
80104e06:	85 c0                	test   %eax,%eax
80104e08:	75 c3                	jne    80104dcd <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104e0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104e0f:	c9                   	leave  
80104e10:	c3                   	ret    

80104e11 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104e11:	55                   	push   %ebp
80104e12:	89 e5                	mov    %esp,%ebp
80104e14:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80104e17:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80104e1d:	8b 45 08             	mov    0x8(%ebp),%eax
80104e20:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80104e23:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e26:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104e29:	73 3d                	jae    80104e68 <memmove+0x57>
80104e2b:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104e2e:	8b 45 10             	mov    0x10(%ebp),%eax
80104e31:	01 d0                	add    %edx,%eax
80104e33:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104e36:	76 30                	jbe    80104e68 <memmove+0x57>
    s += n;
80104e38:	8b 45 10             	mov    0x10(%ebp),%eax
80104e3b:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80104e3e:	8b 45 10             	mov    0x10(%ebp),%eax
80104e41:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80104e44:	eb 13                	jmp    80104e59 <memmove+0x48>
      *--d = *--s;
80104e46:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80104e4a:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80104e4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e51:	0f b6 10             	movzbl (%eax),%edx
80104e54:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104e57:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104e59:	8b 45 10             	mov    0x10(%ebp),%eax
80104e5c:	8d 50 ff             	lea    -0x1(%eax),%edx
80104e5f:	89 55 10             	mov    %edx,0x10(%ebp)
80104e62:	85 c0                	test   %eax,%eax
80104e64:	75 e0                	jne    80104e46 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104e66:	eb 26                	jmp    80104e8e <memmove+0x7d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104e68:	eb 17                	jmp    80104e81 <memmove+0x70>
      *d++ = *s++;
80104e6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104e6d:	8d 50 01             	lea    0x1(%eax),%edx
80104e70:	89 55 f8             	mov    %edx,-0x8(%ebp)
80104e73:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104e76:	8d 4a 01             	lea    0x1(%edx),%ecx
80104e79:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80104e7c:	0f b6 12             	movzbl (%edx),%edx
80104e7f:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104e81:	8b 45 10             	mov    0x10(%ebp),%eax
80104e84:	8d 50 ff             	lea    -0x1(%eax),%edx
80104e87:	89 55 10             	mov    %edx,0x10(%ebp)
80104e8a:	85 c0                	test   %eax,%eax
80104e8c:	75 dc                	jne    80104e6a <memmove+0x59>
      *d++ = *s++;

  return dst;
80104e8e:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104e91:	c9                   	leave  
80104e92:	c3                   	ret    

80104e93 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104e93:	55                   	push   %ebp
80104e94:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80104e96:	ff 75 10             	pushl  0x10(%ebp)
80104e99:	ff 75 0c             	pushl  0xc(%ebp)
80104e9c:	ff 75 08             	pushl  0x8(%ebp)
80104e9f:	e8 6d ff ff ff       	call   80104e11 <memmove>
80104ea4:	83 c4 0c             	add    $0xc,%esp
}
80104ea7:	c9                   	leave  
80104ea8:	c3                   	ret    

80104ea9 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104ea9:	55                   	push   %ebp
80104eaa:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80104eac:	eb 0c                	jmp    80104eba <strncmp+0x11>
    n--, p++, q++;
80104eae:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104eb2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80104eb6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104eba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104ebe:	74 1a                	je     80104eda <strncmp+0x31>
80104ec0:	8b 45 08             	mov    0x8(%ebp),%eax
80104ec3:	0f b6 00             	movzbl (%eax),%eax
80104ec6:	84 c0                	test   %al,%al
80104ec8:	74 10                	je     80104eda <strncmp+0x31>
80104eca:	8b 45 08             	mov    0x8(%ebp),%eax
80104ecd:	0f b6 10             	movzbl (%eax),%edx
80104ed0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ed3:	0f b6 00             	movzbl (%eax),%eax
80104ed6:	38 c2                	cmp    %al,%dl
80104ed8:	74 d4                	je     80104eae <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80104eda:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104ede:	75 07                	jne    80104ee7 <strncmp+0x3e>
    return 0;
80104ee0:	b8 00 00 00 00       	mov    $0x0,%eax
80104ee5:	eb 16                	jmp    80104efd <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80104ee7:	8b 45 08             	mov    0x8(%ebp),%eax
80104eea:	0f b6 00             	movzbl (%eax),%eax
80104eed:	0f b6 d0             	movzbl %al,%edx
80104ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ef3:	0f b6 00             	movzbl (%eax),%eax
80104ef6:	0f b6 c0             	movzbl %al,%eax
80104ef9:	29 c2                	sub    %eax,%edx
80104efb:	89 d0                	mov    %edx,%eax
}
80104efd:	5d                   	pop    %ebp
80104efe:	c3                   	ret    

80104eff <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104eff:	55                   	push   %ebp
80104f00:	89 e5                	mov    %esp,%ebp
80104f02:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80104f05:	8b 45 08             	mov    0x8(%ebp),%eax
80104f08:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80104f0b:	90                   	nop
80104f0c:	8b 45 10             	mov    0x10(%ebp),%eax
80104f0f:	8d 50 ff             	lea    -0x1(%eax),%edx
80104f12:	89 55 10             	mov    %edx,0x10(%ebp)
80104f15:	85 c0                	test   %eax,%eax
80104f17:	7e 1e                	jle    80104f37 <strncpy+0x38>
80104f19:	8b 45 08             	mov    0x8(%ebp),%eax
80104f1c:	8d 50 01             	lea    0x1(%eax),%edx
80104f1f:	89 55 08             	mov    %edx,0x8(%ebp)
80104f22:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f25:	8d 4a 01             	lea    0x1(%edx),%ecx
80104f28:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80104f2b:	0f b6 12             	movzbl (%edx),%edx
80104f2e:	88 10                	mov    %dl,(%eax)
80104f30:	0f b6 00             	movzbl (%eax),%eax
80104f33:	84 c0                	test   %al,%al
80104f35:	75 d5                	jne    80104f0c <strncpy+0xd>
    ;
  while(n-- > 0)
80104f37:	eb 0c                	jmp    80104f45 <strncpy+0x46>
    *s++ = 0;
80104f39:	8b 45 08             	mov    0x8(%ebp),%eax
80104f3c:	8d 50 01             	lea    0x1(%eax),%edx
80104f3f:	89 55 08             	mov    %edx,0x8(%ebp)
80104f42:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104f45:	8b 45 10             	mov    0x10(%ebp),%eax
80104f48:	8d 50 ff             	lea    -0x1(%eax),%edx
80104f4b:	89 55 10             	mov    %edx,0x10(%ebp)
80104f4e:	85 c0                	test   %eax,%eax
80104f50:	7f e7                	jg     80104f39 <strncpy+0x3a>
    *s++ = 0;
  return os;
80104f52:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f55:	c9                   	leave  
80104f56:	c3                   	ret    

80104f57 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104f57:	55                   	push   %ebp
80104f58:	89 e5                	mov    %esp,%ebp
80104f5a:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80104f5d:	8b 45 08             	mov    0x8(%ebp),%eax
80104f60:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80104f63:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104f67:	7f 05                	jg     80104f6e <safestrcpy+0x17>
    return os;
80104f69:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f6c:	eb 31                	jmp    80104f9f <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80104f6e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80104f72:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104f76:	7e 1e                	jle    80104f96 <safestrcpy+0x3f>
80104f78:	8b 45 08             	mov    0x8(%ebp),%eax
80104f7b:	8d 50 01             	lea    0x1(%eax),%edx
80104f7e:	89 55 08             	mov    %edx,0x8(%ebp)
80104f81:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f84:	8d 4a 01             	lea    0x1(%edx),%ecx
80104f87:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80104f8a:	0f b6 12             	movzbl (%edx),%edx
80104f8d:	88 10                	mov    %dl,(%eax)
80104f8f:	0f b6 00             	movzbl (%eax),%eax
80104f92:	84 c0                	test   %al,%al
80104f94:	75 d8                	jne    80104f6e <safestrcpy+0x17>
    ;
  *s = 0;
80104f96:	8b 45 08             	mov    0x8(%ebp),%eax
80104f99:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80104f9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f9f:	c9                   	leave  
80104fa0:	c3                   	ret    

80104fa1 <strlen>:

int
strlen(const char *s)
{
80104fa1:	55                   	push   %ebp
80104fa2:	89 e5                	mov    %esp,%ebp
80104fa4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80104fa7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80104fae:	eb 04                	jmp    80104fb4 <strlen+0x13>
80104fb0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104fb4:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104fb7:	8b 45 08             	mov    0x8(%ebp),%eax
80104fba:	01 d0                	add    %edx,%eax
80104fbc:	0f b6 00             	movzbl (%eax),%eax
80104fbf:	84 c0                	test   %al,%al
80104fc1:	75 ed                	jne    80104fb0 <strlen+0xf>
    ;
  return n;
80104fc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104fc6:	c9                   	leave  
80104fc7:	c3                   	ret    

80104fc8 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104fc8:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104fcc:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104fd0:	55                   	push   %ebp
  pushl %ebx
80104fd1:	53                   	push   %ebx
  pushl %esi
80104fd2:	56                   	push   %esi
  pushl %edi
80104fd3:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104fd4:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104fd6:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104fd8:	5f                   	pop    %edi
  popl %esi
80104fd9:	5e                   	pop    %esi
  popl %ebx
80104fda:	5b                   	pop    %ebx
  popl %ebp
80104fdb:	5d                   	pop    %ebp
  ret
80104fdc:	c3                   	ret    

80104fdd <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104fdd:	55                   	push   %ebp
80104fde:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80104fe0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fe6:	8b 00                	mov    (%eax),%eax
80104fe8:	3b 45 08             	cmp    0x8(%ebp),%eax
80104feb:	76 12                	jbe    80104fff <fetchint+0x22>
80104fed:	8b 45 08             	mov    0x8(%ebp),%eax
80104ff0:	8d 50 04             	lea    0x4(%eax),%edx
80104ff3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ff9:	8b 00                	mov    (%eax),%eax
80104ffb:	39 c2                	cmp    %eax,%edx
80104ffd:	76 07                	jbe    80105006 <fetchint+0x29>
    return -1;
80104fff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105004:	eb 0f                	jmp    80105015 <fetchint+0x38>
  *ip = *(int*)(addr);
80105006:	8b 45 08             	mov    0x8(%ebp),%eax
80105009:	8b 10                	mov    (%eax),%edx
8010500b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010500e:	89 10                	mov    %edx,(%eax)
  return 0;
80105010:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105015:	5d                   	pop    %ebp
80105016:	c3                   	ret    

80105017 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105017:	55                   	push   %ebp
80105018:	89 e5                	mov    %esp,%ebp
8010501a:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
8010501d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105023:	8b 00                	mov    (%eax),%eax
80105025:	3b 45 08             	cmp    0x8(%ebp),%eax
80105028:	77 07                	ja     80105031 <fetchstr+0x1a>
    return -1;
8010502a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010502f:	eb 46                	jmp    80105077 <fetchstr+0x60>
  *pp = (char*)addr;
80105031:	8b 55 08             	mov    0x8(%ebp),%edx
80105034:	8b 45 0c             	mov    0xc(%ebp),%eax
80105037:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105039:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010503f:	8b 00                	mov    (%eax),%eax
80105041:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105044:	8b 45 0c             	mov    0xc(%ebp),%eax
80105047:	8b 00                	mov    (%eax),%eax
80105049:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010504c:	eb 1c                	jmp    8010506a <fetchstr+0x53>
    if(*s == 0)
8010504e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105051:	0f b6 00             	movzbl (%eax),%eax
80105054:	84 c0                	test   %al,%al
80105056:	75 0e                	jne    80105066 <fetchstr+0x4f>
      return s - *pp;
80105058:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010505b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010505e:	8b 00                	mov    (%eax),%eax
80105060:	29 c2                	sub    %eax,%edx
80105062:	89 d0                	mov    %edx,%eax
80105064:	eb 11                	jmp    80105077 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80105066:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010506a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010506d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105070:	72 dc                	jb     8010504e <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80105072:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105077:	c9                   	leave  
80105078:	c3                   	ret    

80105079 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105079:	55                   	push   %ebp
8010507a:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010507c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105082:	8b 40 18             	mov    0x18(%eax),%eax
80105085:	8b 50 44             	mov    0x44(%eax),%edx
80105088:	8b 45 08             	mov    0x8(%ebp),%eax
8010508b:	c1 e0 02             	shl    $0x2,%eax
8010508e:	01 d0                	add    %edx,%eax
80105090:	83 c0 04             	add    $0x4,%eax
80105093:	ff 75 0c             	pushl  0xc(%ebp)
80105096:	50                   	push   %eax
80105097:	e8 41 ff ff ff       	call   80104fdd <fetchint>
8010509c:	83 c4 08             	add    $0x8,%esp
}
8010509f:	c9                   	leave  
801050a0:	c3                   	ret    

801050a1 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801050a1:	55                   	push   %ebp
801050a2:	89 e5                	mov    %esp,%ebp
801050a4:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
801050a7:	8d 45 fc             	lea    -0x4(%ebp),%eax
801050aa:	50                   	push   %eax
801050ab:	ff 75 08             	pushl  0x8(%ebp)
801050ae:	e8 c6 ff ff ff       	call   80105079 <argint>
801050b3:	83 c4 08             	add    $0x8,%esp
801050b6:	85 c0                	test   %eax,%eax
801050b8:	79 07                	jns    801050c1 <argptr+0x20>
    return -1;
801050ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050bf:	eb 3d                	jmp    801050fe <argptr+0x5d>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
801050c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050c4:	89 c2                	mov    %eax,%edx
801050c6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050cc:	8b 00                	mov    (%eax),%eax
801050ce:	39 c2                	cmp    %eax,%edx
801050d0:	73 16                	jae    801050e8 <argptr+0x47>
801050d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050d5:	89 c2                	mov    %eax,%edx
801050d7:	8b 45 10             	mov    0x10(%ebp),%eax
801050da:	01 c2                	add    %eax,%edx
801050dc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050e2:	8b 00                	mov    (%eax),%eax
801050e4:	39 c2                	cmp    %eax,%edx
801050e6:	76 07                	jbe    801050ef <argptr+0x4e>
    return -1;
801050e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050ed:	eb 0f                	jmp    801050fe <argptr+0x5d>
  *pp = (char*)i;
801050ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050f2:	89 c2                	mov    %eax,%edx
801050f4:	8b 45 0c             	mov    0xc(%ebp),%eax
801050f7:	89 10                	mov    %edx,(%eax)
  return 0;
801050f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801050fe:	c9                   	leave  
801050ff:	c3                   	ret    

80105100 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105106:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105109:	50                   	push   %eax
8010510a:	ff 75 08             	pushl  0x8(%ebp)
8010510d:	e8 67 ff ff ff       	call   80105079 <argint>
80105112:	83 c4 08             	add    $0x8,%esp
80105115:	85 c0                	test   %eax,%eax
80105117:	79 07                	jns    80105120 <argstr+0x20>
    return -1;
80105119:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010511e:	eb 0f                	jmp    8010512f <argstr+0x2f>
  return fetchstr(addr, pp);
80105120:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105123:	ff 75 0c             	pushl  0xc(%ebp)
80105126:	50                   	push   %eax
80105127:	e8 eb fe ff ff       	call   80105017 <fetchstr>
8010512c:	83 c4 08             	add    $0x8,%esp
}
8010512f:	c9                   	leave  
80105130:	c3                   	ret    

80105131 <syscall>:
[SYS_lseek] sys_lseek,
};

void
syscall(void)
{
80105131:	55                   	push   %ebp
80105132:	89 e5                	mov    %esp,%ebp
80105134:	53                   	push   %ebx
80105135:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80105138:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010513e:	8b 40 18             	mov    0x18(%eax),%eax
80105141:	8b 40 1c             	mov    0x1c(%eax),%eax
80105144:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105147:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010514b:	7e 30                	jle    8010517d <syscall+0x4c>
8010514d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105150:	83 f8 19             	cmp    $0x19,%eax
80105153:	77 28                	ja     8010517d <syscall+0x4c>
80105155:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105158:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
8010515f:	85 c0                	test   %eax,%eax
80105161:	74 1a                	je     8010517d <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105163:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105169:	8b 58 18             	mov    0x18(%eax),%ebx
8010516c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010516f:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105176:	ff d0                	call   *%eax
80105178:	89 43 1c             	mov    %eax,0x1c(%ebx)
8010517b:	eb 34                	jmp    801051b1 <syscall+0x80>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
8010517d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105183:	8d 50 6c             	lea    0x6c(%eax),%edx
80105186:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010518c:	8b 40 10             	mov    0x10(%eax),%eax
8010518f:	ff 75 f4             	pushl  -0xc(%ebp)
80105192:	52                   	push   %edx
80105193:	50                   	push   %eax
80105194:	68 83 86 10 80       	push   $0x80108683
80105199:	e8 21 b2 ff ff       	call   801003bf <cprintf>
8010519e:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
801051a1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051a7:	8b 40 18             	mov    0x18(%eax),%eax
801051aa:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801051b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051b4:	c9                   	leave  
801051b5:	c3                   	ret    

801051b6 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801051b6:	55                   	push   %ebp
801051b7:	89 e5                	mov    %esp,%ebp
801051b9:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801051bc:	83 ec 08             	sub    $0x8,%esp
801051bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051c2:	50                   	push   %eax
801051c3:	ff 75 08             	pushl  0x8(%ebp)
801051c6:	e8 ae fe ff ff       	call   80105079 <argint>
801051cb:	83 c4 10             	add    $0x10,%esp
801051ce:	85 c0                	test   %eax,%eax
801051d0:	79 07                	jns    801051d9 <argfd+0x23>
    return -1;
801051d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051d7:	eb 50                	jmp    80105229 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
801051d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051dc:	85 c0                	test   %eax,%eax
801051de:	78 21                	js     80105201 <argfd+0x4b>
801051e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051e3:	83 f8 0f             	cmp    $0xf,%eax
801051e6:	7f 19                	jg     80105201 <argfd+0x4b>
801051e8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
801051f1:	83 c2 08             	add    $0x8,%edx
801051f4:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801051f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801051fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801051ff:	75 07                	jne    80105208 <argfd+0x52>
    return -1;
80105201:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105206:	eb 21                	jmp    80105229 <argfd+0x73>
  if(pfd)
80105208:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010520c:	74 08                	je     80105216 <argfd+0x60>
    *pfd = fd;
8010520e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105211:	8b 45 0c             	mov    0xc(%ebp),%eax
80105214:	89 10                	mov    %edx,(%eax)
  if(pf)
80105216:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010521a:	74 08                	je     80105224 <argfd+0x6e>
    *pf = f;
8010521c:	8b 45 10             	mov    0x10(%ebp),%eax
8010521f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105222:	89 10                	mov    %edx,(%eax)
  return 0;
80105224:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105229:	c9                   	leave  
8010522a:	c3                   	ret    

8010522b <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010522b:	55                   	push   %ebp
8010522c:	89 e5                	mov    %esp,%ebp
8010522e:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105231:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105238:	eb 30                	jmp    8010526a <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
8010523a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105240:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105243:	83 c2 08             	add    $0x8,%edx
80105246:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010524a:	85 c0                	test   %eax,%eax
8010524c:	75 18                	jne    80105266 <fdalloc+0x3b>
      proc->ofile[fd] = f;
8010524e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105254:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105257:	8d 4a 08             	lea    0x8(%edx),%ecx
8010525a:	8b 55 08             	mov    0x8(%ebp),%edx
8010525d:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105261:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105264:	eb 0f                	jmp    80105275 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105266:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010526a:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
8010526e:	7e ca                	jle    8010523a <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105270:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105275:	c9                   	leave  
80105276:	c3                   	ret    

80105277 <sys_dup>:

int
sys_dup(void)
{
80105277:	55                   	push   %ebp
80105278:	89 e5                	mov    %esp,%ebp
8010527a:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
8010527d:	83 ec 04             	sub    $0x4,%esp
80105280:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105283:	50                   	push   %eax
80105284:	6a 00                	push   $0x0
80105286:	6a 00                	push   $0x0
80105288:	e8 29 ff ff ff       	call   801051b6 <argfd>
8010528d:	83 c4 10             	add    $0x10,%esp
80105290:	85 c0                	test   %eax,%eax
80105292:	79 07                	jns    8010529b <sys_dup+0x24>
    return -1;
80105294:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105299:	eb 31                	jmp    801052cc <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
8010529b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010529e:	83 ec 0c             	sub    $0xc,%esp
801052a1:	50                   	push   %eax
801052a2:	e8 84 ff ff ff       	call   8010522b <fdalloc>
801052a7:	83 c4 10             	add    $0x10,%esp
801052aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
801052ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801052b1:	79 07                	jns    801052ba <sys_dup+0x43>
    return -1;
801052b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052b8:	eb 12                	jmp    801052cc <sys_dup+0x55>
  filedup(f);
801052ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052bd:	83 ec 0c             	sub    $0xc,%esp
801052c0:	50                   	push   %eax
801052c1:	e8 e5 bc ff ff       	call   80100fab <filedup>
801052c6:	83 c4 10             	add    $0x10,%esp
  return fd;
801052c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801052cc:	c9                   	leave  
801052cd:	c3                   	ret    

801052ce <sys_read>:

int
sys_read(void)
{
801052ce:	55                   	push   %ebp
801052cf:	89 e5                	mov    %esp,%ebp
801052d1:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801052d4:	83 ec 04             	sub    $0x4,%esp
801052d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052da:	50                   	push   %eax
801052db:	6a 00                	push   $0x0
801052dd:	6a 00                	push   $0x0
801052df:	e8 d2 fe ff ff       	call   801051b6 <argfd>
801052e4:	83 c4 10             	add    $0x10,%esp
801052e7:	85 c0                	test   %eax,%eax
801052e9:	78 2e                	js     80105319 <sys_read+0x4b>
801052eb:	83 ec 08             	sub    $0x8,%esp
801052ee:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052f1:	50                   	push   %eax
801052f2:	6a 02                	push   $0x2
801052f4:	e8 80 fd ff ff       	call   80105079 <argint>
801052f9:	83 c4 10             	add    $0x10,%esp
801052fc:	85 c0                	test   %eax,%eax
801052fe:	78 19                	js     80105319 <sys_read+0x4b>
80105300:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105303:	83 ec 04             	sub    $0x4,%esp
80105306:	50                   	push   %eax
80105307:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010530a:	50                   	push   %eax
8010530b:	6a 01                	push   $0x1
8010530d:	e8 8f fd ff ff       	call   801050a1 <argptr>
80105312:	83 c4 10             	add    $0x10,%esp
80105315:	85 c0                	test   %eax,%eax
80105317:	79 07                	jns    80105320 <sys_read+0x52>
    return -1;
80105319:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010531e:	eb 17                	jmp    80105337 <sys_read+0x69>
  return fileread(f, p, n);
80105320:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105323:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105326:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105329:	83 ec 04             	sub    $0x4,%esp
8010532c:	51                   	push   %ecx
8010532d:	52                   	push   %edx
8010532e:	50                   	push   %eax
8010532f:	e8 07 be ff ff       	call   8010113b <fileread>
80105334:	83 c4 10             	add    $0x10,%esp
}
80105337:	c9                   	leave  
80105338:	c3                   	ret    

80105339 <sys_write>:

int
sys_write(void)
{
80105339:	55                   	push   %ebp
8010533a:	89 e5                	mov    %esp,%ebp
8010533c:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010533f:	83 ec 04             	sub    $0x4,%esp
80105342:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105345:	50                   	push   %eax
80105346:	6a 00                	push   $0x0
80105348:	6a 00                	push   $0x0
8010534a:	e8 67 fe ff ff       	call   801051b6 <argfd>
8010534f:	83 c4 10             	add    $0x10,%esp
80105352:	85 c0                	test   %eax,%eax
80105354:	78 2e                	js     80105384 <sys_write+0x4b>
80105356:	83 ec 08             	sub    $0x8,%esp
80105359:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010535c:	50                   	push   %eax
8010535d:	6a 02                	push   $0x2
8010535f:	e8 15 fd ff ff       	call   80105079 <argint>
80105364:	83 c4 10             	add    $0x10,%esp
80105367:	85 c0                	test   %eax,%eax
80105369:	78 19                	js     80105384 <sys_write+0x4b>
8010536b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010536e:	83 ec 04             	sub    $0x4,%esp
80105371:	50                   	push   %eax
80105372:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105375:	50                   	push   %eax
80105376:	6a 01                	push   $0x1
80105378:	e8 24 fd ff ff       	call   801050a1 <argptr>
8010537d:	83 c4 10             	add    $0x10,%esp
80105380:	85 c0                	test   %eax,%eax
80105382:	79 07                	jns    8010538b <sys_write+0x52>
    return -1;
80105384:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105389:	eb 17                	jmp    801053a2 <sys_write+0x69>
  return filewrite(f, p, n);
8010538b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010538e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105391:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105394:	83 ec 04             	sub    $0x4,%esp
80105397:	51                   	push   %ecx
80105398:	52                   	push   %edx
80105399:	50                   	push   %eax
8010539a:	e8 54 be ff ff       	call   801011f3 <filewrite>
8010539f:	83 c4 10             	add    $0x10,%esp
}
801053a2:	c9                   	leave  
801053a3:	c3                   	ret    

801053a4 <sys_lseek>:

// Very shitty code

int
sys_lseek(void)
{
801053a4:	55                   	push   %ebp
801053a5:	89 e5                	mov    %esp,%ebp
801053a7:	83 ec 18             	sub    $0x18,%esp
int offset;
int base;

struct file *f;

argfd(0, &fd, &f);
801053aa:	83 ec 04             	sub    $0x4,%esp
801053ad:	8d 45 e8             	lea    -0x18(%ebp),%eax
801053b0:	50                   	push   %eax
801053b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053b4:	50                   	push   %eax
801053b5:	6a 00                	push   $0x0
801053b7:	e8 fa fd ff ff       	call   801051b6 <argfd>
801053bc:	83 c4 10             	add    $0x10,%esp
argint(1, &offset);
801053bf:	83 ec 08             	sub    $0x8,%esp
801053c2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053c5:	50                   	push   %eax
801053c6:	6a 01                	push   $0x1
801053c8:	e8 ac fc ff ff       	call   80105079 <argint>
801053cd:	83 c4 10             	add    $0x10,%esp
argint(2, &base);
801053d0:	83 ec 08             	sub    $0x8,%esp
801053d3:	8d 45 ec             	lea    -0x14(%ebp),%eax
801053d6:	50                   	push   %eax
801053d7:	6a 02                	push   $0x2
801053d9:	e8 9b fc ff ff       	call   80105079 <argint>
801053de:	83 c4 10             	add    $0x10,%esp

if( base == SEEK_SET) {
801053e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801053e4:	85 c0                	test   %eax,%eax
801053e6:	75 22                	jne    8010540a <sys_lseek+0x66>
f->off = offset;
801053e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801053eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
801053ee:	89 50 14             	mov    %edx,0x14(%eax)
cprintf("lseek %d, %d, %d", fd, offset, base);
801053f1:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801053f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801053f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053fa:	51                   	push   %ecx
801053fb:	52                   	push   %edx
801053fc:	50                   	push   %eax
801053fd:	68 a0 86 10 80       	push   $0x801086a0
80105402:	e8 b8 af ff ff       	call   801003bf <cprintf>
80105407:	83 c4 10             	add    $0x10,%esp
}

if (base == SEEK_CUR)
8010540a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010540d:	83 f8 01             	cmp    $0x1,%eax
80105410:	75 11                	jne    80105423 <sys_lseek+0x7f>
f->off += offset;
80105412:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105415:	8b 55 e8             	mov    -0x18(%ebp),%edx
80105418:	8b 4a 14             	mov    0x14(%edx),%ecx
8010541b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010541e:	01 ca                	add    %ecx,%edx
80105420:	89 50 14             	mov    %edx,0x14(%eax)
return 0;
80105423:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105428:	c9                   	leave  
80105429:	c3                   	ret    

8010542a <sys_close>:

int
sys_close(void)
{
8010542a:	55                   	push   %ebp
8010542b:	89 e5                	mov    %esp,%ebp
8010542d:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105430:	83 ec 04             	sub    $0x4,%esp
80105433:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105436:	50                   	push   %eax
80105437:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010543a:	50                   	push   %eax
8010543b:	6a 00                	push   $0x0
8010543d:	e8 74 fd ff ff       	call   801051b6 <argfd>
80105442:	83 c4 10             	add    $0x10,%esp
80105445:	85 c0                	test   %eax,%eax
80105447:	79 07                	jns    80105450 <sys_close+0x26>
    return -1;
80105449:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010544e:	eb 28                	jmp    80105478 <sys_close+0x4e>
  proc->ofile[fd] = 0;
80105450:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105456:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105459:	83 c2 08             	add    $0x8,%edx
8010545c:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105463:	00 
  fileclose(f);
80105464:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105467:	83 ec 0c             	sub    $0xc,%esp
8010546a:	50                   	push   %eax
8010546b:	e8 8c bb ff ff       	call   80100ffc <fileclose>
80105470:	83 c4 10             	add    $0x10,%esp
  return 0;
80105473:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105478:	c9                   	leave  
80105479:	c3                   	ret    

8010547a <sys_fstat>:

int
sys_fstat(void)
{
8010547a:	55                   	push   %ebp
8010547b:	89 e5                	mov    %esp,%ebp
8010547d:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105480:	83 ec 04             	sub    $0x4,%esp
80105483:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105486:	50                   	push   %eax
80105487:	6a 00                	push   $0x0
80105489:	6a 00                	push   $0x0
8010548b:	e8 26 fd ff ff       	call   801051b6 <argfd>
80105490:	83 c4 10             	add    $0x10,%esp
80105493:	85 c0                	test   %eax,%eax
80105495:	78 17                	js     801054ae <sys_fstat+0x34>
80105497:	83 ec 04             	sub    $0x4,%esp
8010549a:	6a 14                	push   $0x14
8010549c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010549f:	50                   	push   %eax
801054a0:	6a 01                	push   $0x1
801054a2:	e8 fa fb ff ff       	call   801050a1 <argptr>
801054a7:	83 c4 10             	add    $0x10,%esp
801054aa:	85 c0                	test   %eax,%eax
801054ac:	79 07                	jns    801054b5 <sys_fstat+0x3b>
    return -1;
801054ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054b3:	eb 13                	jmp    801054c8 <sys_fstat+0x4e>
  return filestat(f, st);
801054b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801054b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054bb:	83 ec 08             	sub    $0x8,%esp
801054be:	52                   	push   %edx
801054bf:	50                   	push   %eax
801054c0:	e8 1f bc ff ff       	call   801010e4 <filestat>
801054c5:	83 c4 10             	add    $0x10,%esp
}
801054c8:	c9                   	leave  
801054c9:	c3                   	ret    

801054ca <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801054ca:	55                   	push   %ebp
801054cb:	89 e5                	mov    %esp,%ebp
801054cd:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801054d0:	83 ec 08             	sub    $0x8,%esp
801054d3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801054d6:	50                   	push   %eax
801054d7:	6a 00                	push   $0x0
801054d9:	e8 22 fc ff ff       	call   80105100 <argstr>
801054de:	83 c4 10             	add    $0x10,%esp
801054e1:	85 c0                	test   %eax,%eax
801054e3:	78 15                	js     801054fa <sys_link+0x30>
801054e5:	83 ec 08             	sub    $0x8,%esp
801054e8:	8d 45 dc             	lea    -0x24(%ebp),%eax
801054eb:	50                   	push   %eax
801054ec:	6a 01                	push   $0x1
801054ee:	e8 0d fc ff ff       	call   80105100 <argstr>
801054f3:	83 c4 10             	add    $0x10,%esp
801054f6:	85 c0                	test   %eax,%eax
801054f8:	79 0a                	jns    80105504 <sys_link+0x3a>
    return -1;
801054fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ff:	e9 60 01 00 00       	jmp    80105664 <sys_link+0x19a>
  if((ip = namei(old)) == 0)
80105504:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105507:	83 ec 0c             	sub    $0xc,%esp
8010550a:	50                   	push   %eax
8010550b:	e8 6c cf ff ff       	call   8010247c <namei>
80105510:	83 c4 10             	add    $0x10,%esp
80105513:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105516:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010551a:	75 0a                	jne    80105526 <sys_link+0x5c>
    return -1;
8010551c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105521:	e9 3e 01 00 00       	jmp    80105664 <sys_link+0x19a>

  begin_trans();
80105526:	e8 fc dc ff ff       	call   80103227 <begin_trans>

  ilock(ip);
8010552b:	83 ec 0c             	sub    $0xc,%esp
8010552e:	ff 75 f4             	pushl  -0xc(%ebp)
80105531:	e8 8d c3 ff ff       	call   801018c3 <ilock>
80105536:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105539:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010553c:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105540:	66 83 f8 01          	cmp    $0x1,%ax
80105544:	75 1d                	jne    80105563 <sys_link+0x99>
    iunlockput(ip);
80105546:	83 ec 0c             	sub    $0xc,%esp
80105549:	ff 75 f4             	pushl  -0xc(%ebp)
8010554c:	e8 29 c6 ff ff       	call   80101b7a <iunlockput>
80105551:	83 c4 10             	add    $0x10,%esp
    commit_trans();
80105554:	e8 20 dd ff ff       	call   80103279 <commit_trans>
    return -1;
80105559:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010555e:	e9 01 01 00 00       	jmp    80105664 <sys_link+0x19a>
  }

  ip->nlink++;
80105563:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105566:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010556a:	8d 50 01             	lea    0x1(%eax),%edx
8010556d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105570:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105574:	83 ec 0c             	sub    $0xc,%esp
80105577:	ff 75 f4             	pushl  -0xc(%ebp)
8010557a:	e8 71 c1 ff ff       	call   801016f0 <iupdate>
8010557f:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105582:	83 ec 0c             	sub    $0xc,%esp
80105585:	ff 75 f4             	pushl  -0xc(%ebp)
80105588:	e8 8d c4 ff ff       	call   80101a1a <iunlock>
8010558d:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105590:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105593:	83 ec 08             	sub    $0x8,%esp
80105596:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105599:	52                   	push   %edx
8010559a:	50                   	push   %eax
8010559b:	e8 f8 ce ff ff       	call   80102498 <nameiparent>
801055a0:	83 c4 10             	add    $0x10,%esp
801055a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
801055a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801055aa:	75 02                	jne    801055ae <sys_link+0xe4>
    goto bad;
801055ac:	eb 71                	jmp    8010561f <sys_link+0x155>
  ilock(dp);
801055ae:	83 ec 0c             	sub    $0xc,%esp
801055b1:	ff 75 f0             	pushl  -0x10(%ebp)
801055b4:	e8 0a c3 ff ff       	call   801018c3 <ilock>
801055b9:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801055bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055bf:	8b 10                	mov    (%eax),%edx
801055c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055c4:	8b 00                	mov    (%eax),%eax
801055c6:	39 c2                	cmp    %eax,%edx
801055c8:	75 1d                	jne    801055e7 <sys_link+0x11d>
801055ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055cd:	8b 40 04             	mov    0x4(%eax),%eax
801055d0:	83 ec 04             	sub    $0x4,%esp
801055d3:	50                   	push   %eax
801055d4:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801055d7:	50                   	push   %eax
801055d8:	ff 75 f0             	pushl  -0x10(%ebp)
801055db:	e8 04 cc ff ff       	call   801021e4 <dirlink>
801055e0:	83 c4 10             	add    $0x10,%esp
801055e3:	85 c0                	test   %eax,%eax
801055e5:	79 10                	jns    801055f7 <sys_link+0x12d>
    iunlockput(dp);
801055e7:	83 ec 0c             	sub    $0xc,%esp
801055ea:	ff 75 f0             	pushl  -0x10(%ebp)
801055ed:	e8 88 c5 ff ff       	call   80101b7a <iunlockput>
801055f2:	83 c4 10             	add    $0x10,%esp
    goto bad;
801055f5:	eb 28                	jmp    8010561f <sys_link+0x155>
  }
  iunlockput(dp);
801055f7:	83 ec 0c             	sub    $0xc,%esp
801055fa:	ff 75 f0             	pushl  -0x10(%ebp)
801055fd:	e8 78 c5 ff ff       	call   80101b7a <iunlockput>
80105602:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105605:	83 ec 0c             	sub    $0xc,%esp
80105608:	ff 75 f4             	pushl  -0xc(%ebp)
8010560b:	e8 7b c4 ff ff       	call   80101a8b <iput>
80105610:	83 c4 10             	add    $0x10,%esp

  commit_trans();
80105613:	e8 61 dc ff ff       	call   80103279 <commit_trans>

  return 0;
80105618:	b8 00 00 00 00       	mov    $0x0,%eax
8010561d:	eb 45                	jmp    80105664 <sys_link+0x19a>

bad:
  ilock(ip);
8010561f:	83 ec 0c             	sub    $0xc,%esp
80105622:	ff 75 f4             	pushl  -0xc(%ebp)
80105625:	e8 99 c2 ff ff       	call   801018c3 <ilock>
8010562a:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
8010562d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105630:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105634:	8d 50 ff             	lea    -0x1(%eax),%edx
80105637:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010563a:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010563e:	83 ec 0c             	sub    $0xc,%esp
80105641:	ff 75 f4             	pushl  -0xc(%ebp)
80105644:	e8 a7 c0 ff ff       	call   801016f0 <iupdate>
80105649:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
8010564c:	83 ec 0c             	sub    $0xc,%esp
8010564f:	ff 75 f4             	pushl  -0xc(%ebp)
80105652:	e8 23 c5 ff ff       	call   80101b7a <iunlockput>
80105657:	83 c4 10             	add    $0x10,%esp
  commit_trans();
8010565a:	e8 1a dc ff ff       	call   80103279 <commit_trans>
  return -1;
8010565f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105664:	c9                   	leave  
80105665:	c3                   	ret    

80105666 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105666:	55                   	push   %ebp
80105667:	89 e5                	mov    %esp,%ebp
80105669:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010566c:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105673:	eb 40                	jmp    801056b5 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105675:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105678:	6a 10                	push   $0x10
8010567a:	50                   	push   %eax
8010567b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010567e:	50                   	push   %eax
8010567f:	ff 75 08             	pushl  0x8(%ebp)
80105682:	e8 9e c7 ff ff       	call   80101e25 <readi>
80105687:	83 c4 10             	add    $0x10,%esp
8010568a:	83 f8 10             	cmp    $0x10,%eax
8010568d:	74 0d                	je     8010569c <isdirempty+0x36>
      panic("isdirempty: readi");
8010568f:	83 ec 0c             	sub    $0xc,%esp
80105692:	68 b1 86 10 80       	push   $0x801086b1
80105697:	e8 c0 ae ff ff       	call   8010055c <panic>
    if(de.inum != 0)
8010569c:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801056a0:	66 85 c0             	test   %ax,%ax
801056a3:	74 07                	je     801056ac <isdirempty+0x46>
      return 0;
801056a5:	b8 00 00 00 00       	mov    $0x0,%eax
801056aa:	eb 1b                	jmp    801056c7 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801056ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056af:	83 c0 10             	add    $0x10,%eax
801056b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801056b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056b8:	8b 45 08             	mov    0x8(%ebp),%eax
801056bb:	8b 40 18             	mov    0x18(%eax),%eax
801056be:	39 c2                	cmp    %eax,%edx
801056c0:	72 b3                	jb     80105675 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
801056c2:	b8 01 00 00 00       	mov    $0x1,%eax
}
801056c7:	c9                   	leave  
801056c8:	c3                   	ret    

801056c9 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801056c9:	55                   	push   %ebp
801056ca:	89 e5                	mov    %esp,%ebp
801056cc:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801056cf:	83 ec 08             	sub    $0x8,%esp
801056d2:	8d 45 cc             	lea    -0x34(%ebp),%eax
801056d5:	50                   	push   %eax
801056d6:	6a 00                	push   $0x0
801056d8:	e8 23 fa ff ff       	call   80105100 <argstr>
801056dd:	83 c4 10             	add    $0x10,%esp
801056e0:	85 c0                	test   %eax,%eax
801056e2:	79 0a                	jns    801056ee <sys_unlink+0x25>
    return -1;
801056e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056e9:	e9 b3 01 00 00       	jmp    801058a1 <sys_unlink+0x1d8>
  if((dp = nameiparent(path, name)) == 0)
801056ee:	8b 45 cc             	mov    -0x34(%ebp),%eax
801056f1:	83 ec 08             	sub    $0x8,%esp
801056f4:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801056f7:	52                   	push   %edx
801056f8:	50                   	push   %eax
801056f9:	e8 9a cd ff ff       	call   80102498 <nameiparent>
801056fe:	83 c4 10             	add    $0x10,%esp
80105701:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105704:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105708:	75 0a                	jne    80105714 <sys_unlink+0x4b>
    return -1;
8010570a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010570f:	e9 8d 01 00 00       	jmp    801058a1 <sys_unlink+0x1d8>

  begin_trans();
80105714:	e8 0e db ff ff       	call   80103227 <begin_trans>

  ilock(dp);
80105719:	83 ec 0c             	sub    $0xc,%esp
8010571c:	ff 75 f4             	pushl  -0xc(%ebp)
8010571f:	e8 9f c1 ff ff       	call   801018c3 <ilock>
80105724:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105727:	83 ec 08             	sub    $0x8,%esp
8010572a:	68 c3 86 10 80       	push   $0x801086c3
8010572f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105732:	50                   	push   %eax
80105733:	e8 d6 c9 ff ff       	call   8010210e <namecmp>
80105738:	83 c4 10             	add    $0x10,%esp
8010573b:	85 c0                	test   %eax,%eax
8010573d:	0f 84 46 01 00 00    	je     80105889 <sys_unlink+0x1c0>
80105743:	83 ec 08             	sub    $0x8,%esp
80105746:	68 c5 86 10 80       	push   $0x801086c5
8010574b:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010574e:	50                   	push   %eax
8010574f:	e8 ba c9 ff ff       	call   8010210e <namecmp>
80105754:	83 c4 10             	add    $0x10,%esp
80105757:	85 c0                	test   %eax,%eax
80105759:	0f 84 2a 01 00 00    	je     80105889 <sys_unlink+0x1c0>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010575f:	83 ec 04             	sub    $0x4,%esp
80105762:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105765:	50                   	push   %eax
80105766:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105769:	50                   	push   %eax
8010576a:	ff 75 f4             	pushl  -0xc(%ebp)
8010576d:	e8 b7 c9 ff ff       	call   80102129 <dirlookup>
80105772:	83 c4 10             	add    $0x10,%esp
80105775:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105778:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010577c:	75 05                	jne    80105783 <sys_unlink+0xba>
    goto bad;
8010577e:	e9 06 01 00 00       	jmp    80105889 <sys_unlink+0x1c0>
  ilock(ip);
80105783:	83 ec 0c             	sub    $0xc,%esp
80105786:	ff 75 f0             	pushl  -0x10(%ebp)
80105789:	e8 35 c1 ff ff       	call   801018c3 <ilock>
8010578e:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105791:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105794:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105798:	66 85 c0             	test   %ax,%ax
8010579b:	7f 0d                	jg     801057aa <sys_unlink+0xe1>
    panic("unlink: nlink < 1");
8010579d:	83 ec 0c             	sub    $0xc,%esp
801057a0:	68 c8 86 10 80       	push   $0x801086c8
801057a5:	e8 b2 ad ff ff       	call   8010055c <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801057aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057ad:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801057b1:	66 83 f8 01          	cmp    $0x1,%ax
801057b5:	75 25                	jne    801057dc <sys_unlink+0x113>
801057b7:	83 ec 0c             	sub    $0xc,%esp
801057ba:	ff 75 f0             	pushl  -0x10(%ebp)
801057bd:	e8 a4 fe ff ff       	call   80105666 <isdirempty>
801057c2:	83 c4 10             	add    $0x10,%esp
801057c5:	85 c0                	test   %eax,%eax
801057c7:	75 13                	jne    801057dc <sys_unlink+0x113>
    iunlockput(ip);
801057c9:	83 ec 0c             	sub    $0xc,%esp
801057cc:	ff 75 f0             	pushl  -0x10(%ebp)
801057cf:	e8 a6 c3 ff ff       	call   80101b7a <iunlockput>
801057d4:	83 c4 10             	add    $0x10,%esp
    goto bad;
801057d7:	e9 ad 00 00 00       	jmp    80105889 <sys_unlink+0x1c0>
  }

  memset(&de, 0, sizeof(de));
801057dc:	83 ec 04             	sub    $0x4,%esp
801057df:	6a 10                	push   $0x10
801057e1:	6a 00                	push   $0x0
801057e3:	8d 45 e0             	lea    -0x20(%ebp),%eax
801057e6:	50                   	push   %eax
801057e7:	e8 66 f5 ff ff       	call   80104d52 <memset>
801057ec:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801057ef:	8b 45 c8             	mov    -0x38(%ebp),%eax
801057f2:	6a 10                	push   $0x10
801057f4:	50                   	push   %eax
801057f5:	8d 45 e0             	lea    -0x20(%ebp),%eax
801057f8:	50                   	push   %eax
801057f9:	ff 75 f4             	pushl  -0xc(%ebp)
801057fc:	e8 80 c7 ff ff       	call   80101f81 <writei>
80105801:	83 c4 10             	add    $0x10,%esp
80105804:	83 f8 10             	cmp    $0x10,%eax
80105807:	74 0d                	je     80105816 <sys_unlink+0x14d>
    panic("unlink: writei");
80105809:	83 ec 0c             	sub    $0xc,%esp
8010580c:	68 da 86 10 80       	push   $0x801086da
80105811:	e8 46 ad ff ff       	call   8010055c <panic>
  if(ip->type == T_DIR){
80105816:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105819:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010581d:	66 83 f8 01          	cmp    $0x1,%ax
80105821:	75 1f                	jne    80105842 <sys_unlink+0x179>
    dp->nlink--;
80105823:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105826:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010582a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010582d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105830:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105834:	83 ec 0c             	sub    $0xc,%esp
80105837:	ff 75 f4             	pushl  -0xc(%ebp)
8010583a:	e8 b1 be ff ff       	call   801016f0 <iupdate>
8010583f:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105842:	83 ec 0c             	sub    $0xc,%esp
80105845:	ff 75 f4             	pushl  -0xc(%ebp)
80105848:	e8 2d c3 ff ff       	call   80101b7a <iunlockput>
8010584d:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80105850:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105853:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105857:	8d 50 ff             	lea    -0x1(%eax),%edx
8010585a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010585d:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105861:	83 ec 0c             	sub    $0xc,%esp
80105864:	ff 75 f0             	pushl  -0x10(%ebp)
80105867:	e8 84 be ff ff       	call   801016f0 <iupdate>
8010586c:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
8010586f:	83 ec 0c             	sub    $0xc,%esp
80105872:	ff 75 f0             	pushl  -0x10(%ebp)
80105875:	e8 00 c3 ff ff       	call   80101b7a <iunlockput>
8010587a:	83 c4 10             	add    $0x10,%esp

  commit_trans();
8010587d:	e8 f7 d9 ff ff       	call   80103279 <commit_trans>

  return 0;
80105882:	b8 00 00 00 00       	mov    $0x0,%eax
80105887:	eb 18                	jmp    801058a1 <sys_unlink+0x1d8>

bad:
  iunlockput(dp);
80105889:	83 ec 0c             	sub    $0xc,%esp
8010588c:	ff 75 f4             	pushl  -0xc(%ebp)
8010588f:	e8 e6 c2 ff ff       	call   80101b7a <iunlockput>
80105894:	83 c4 10             	add    $0x10,%esp
  commit_trans();
80105897:	e8 dd d9 ff ff       	call   80103279 <commit_trans>
  return -1;
8010589c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058a1:	c9                   	leave  
801058a2:	c3                   	ret    

801058a3 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
801058a3:	55                   	push   %ebp
801058a4:	89 e5                	mov    %esp,%ebp
801058a6:	83 ec 38             	sub    $0x38,%esp
801058a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801058ac:	8b 55 10             	mov    0x10(%ebp),%edx
801058af:	8b 45 14             	mov    0x14(%ebp),%eax
801058b2:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
801058b6:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
801058ba:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801058be:	83 ec 08             	sub    $0x8,%esp
801058c1:	8d 45 de             	lea    -0x22(%ebp),%eax
801058c4:	50                   	push   %eax
801058c5:	ff 75 08             	pushl  0x8(%ebp)
801058c8:	e8 cb cb ff ff       	call   80102498 <nameiparent>
801058cd:	83 c4 10             	add    $0x10,%esp
801058d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801058d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801058d7:	75 0a                	jne    801058e3 <create+0x40>
    return 0;
801058d9:	b8 00 00 00 00       	mov    $0x0,%eax
801058de:	e9 8e 01 00 00       	jmp    80105a71 <create+0x1ce>
  ilock(dp);
801058e3:	83 ec 0c             	sub    $0xc,%esp
801058e6:	ff 75 f4             	pushl  -0xc(%ebp)
801058e9:	e8 d5 bf ff ff       	call   801018c3 <ilock>
801058ee:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
801058f1:	83 ec 04             	sub    $0x4,%esp
801058f4:	8d 45 ec             	lea    -0x14(%ebp),%eax
801058f7:	50                   	push   %eax
801058f8:	8d 45 de             	lea    -0x22(%ebp),%eax
801058fb:	50                   	push   %eax
801058fc:	ff 75 f4             	pushl  -0xc(%ebp)
801058ff:	e8 25 c8 ff ff       	call   80102129 <dirlookup>
80105904:	83 c4 10             	add    $0x10,%esp
80105907:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010590a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010590e:	74 50                	je     80105960 <create+0xbd>
    iunlockput(dp);
80105910:	83 ec 0c             	sub    $0xc,%esp
80105913:	ff 75 f4             	pushl  -0xc(%ebp)
80105916:	e8 5f c2 ff ff       	call   80101b7a <iunlockput>
8010591b:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
8010591e:	83 ec 0c             	sub    $0xc,%esp
80105921:	ff 75 f0             	pushl  -0x10(%ebp)
80105924:	e8 9a bf ff ff       	call   801018c3 <ilock>
80105929:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
8010592c:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105931:	75 15                	jne    80105948 <create+0xa5>
80105933:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105936:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010593a:	66 83 f8 02          	cmp    $0x2,%ax
8010593e:	75 08                	jne    80105948 <create+0xa5>
      return ip;
80105940:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105943:	e9 29 01 00 00       	jmp    80105a71 <create+0x1ce>
    iunlockput(ip);
80105948:	83 ec 0c             	sub    $0xc,%esp
8010594b:	ff 75 f0             	pushl  -0x10(%ebp)
8010594e:	e8 27 c2 ff ff       	call   80101b7a <iunlockput>
80105953:	83 c4 10             	add    $0x10,%esp
    return 0;
80105956:	b8 00 00 00 00       	mov    $0x0,%eax
8010595b:	e9 11 01 00 00       	jmp    80105a71 <create+0x1ce>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105960:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105964:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105967:	8b 00                	mov    (%eax),%eax
80105969:	83 ec 08             	sub    $0x8,%esp
8010596c:	52                   	push   %edx
8010596d:	50                   	push   %eax
8010596e:	e8 9c bc ff ff       	call   8010160f <ialloc>
80105973:	83 c4 10             	add    $0x10,%esp
80105976:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105979:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010597d:	75 0d                	jne    8010598c <create+0xe9>
    panic("create: ialloc");
8010597f:	83 ec 0c             	sub    $0xc,%esp
80105982:	68 e9 86 10 80       	push   $0x801086e9
80105987:	e8 d0 ab ff ff       	call   8010055c <panic>

  ilock(ip);
8010598c:	83 ec 0c             	sub    $0xc,%esp
8010598f:	ff 75 f0             	pushl  -0x10(%ebp)
80105992:	e8 2c bf ff ff       	call   801018c3 <ilock>
80105997:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
8010599a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010599d:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
801059a1:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
801059a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059a8:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
801059ac:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
801059b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059b3:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
801059b9:	83 ec 0c             	sub    $0xc,%esp
801059bc:	ff 75 f0             	pushl  -0x10(%ebp)
801059bf:	e8 2c bd ff ff       	call   801016f0 <iupdate>
801059c4:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
801059c7:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801059cc:	75 68                	jne    80105a36 <create+0x193>
    dp->nlink++;  // for ".."
801059ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059d1:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801059d5:	8d 50 01             	lea    0x1(%eax),%edx
801059d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059db:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801059df:	83 ec 0c             	sub    $0xc,%esp
801059e2:	ff 75 f4             	pushl  -0xc(%ebp)
801059e5:	e8 06 bd ff ff       	call   801016f0 <iupdate>
801059ea:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801059ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059f0:	8b 40 04             	mov    0x4(%eax),%eax
801059f3:	83 ec 04             	sub    $0x4,%esp
801059f6:	50                   	push   %eax
801059f7:	68 c3 86 10 80       	push   $0x801086c3
801059fc:	ff 75 f0             	pushl  -0x10(%ebp)
801059ff:	e8 e0 c7 ff ff       	call   801021e4 <dirlink>
80105a04:	83 c4 10             	add    $0x10,%esp
80105a07:	85 c0                	test   %eax,%eax
80105a09:	78 1e                	js     80105a29 <create+0x186>
80105a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a0e:	8b 40 04             	mov    0x4(%eax),%eax
80105a11:	83 ec 04             	sub    $0x4,%esp
80105a14:	50                   	push   %eax
80105a15:	68 c5 86 10 80       	push   $0x801086c5
80105a1a:	ff 75 f0             	pushl  -0x10(%ebp)
80105a1d:	e8 c2 c7 ff ff       	call   801021e4 <dirlink>
80105a22:	83 c4 10             	add    $0x10,%esp
80105a25:	85 c0                	test   %eax,%eax
80105a27:	79 0d                	jns    80105a36 <create+0x193>
      panic("create dots");
80105a29:	83 ec 0c             	sub    $0xc,%esp
80105a2c:	68 f8 86 10 80       	push   $0x801086f8
80105a31:	e8 26 ab ff ff       	call   8010055c <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a39:	8b 40 04             	mov    0x4(%eax),%eax
80105a3c:	83 ec 04             	sub    $0x4,%esp
80105a3f:	50                   	push   %eax
80105a40:	8d 45 de             	lea    -0x22(%ebp),%eax
80105a43:	50                   	push   %eax
80105a44:	ff 75 f4             	pushl  -0xc(%ebp)
80105a47:	e8 98 c7 ff ff       	call   801021e4 <dirlink>
80105a4c:	83 c4 10             	add    $0x10,%esp
80105a4f:	85 c0                	test   %eax,%eax
80105a51:	79 0d                	jns    80105a60 <create+0x1bd>
    panic("create: dirlink");
80105a53:	83 ec 0c             	sub    $0xc,%esp
80105a56:	68 04 87 10 80       	push   $0x80108704
80105a5b:	e8 fc aa ff ff       	call   8010055c <panic>

  iunlockput(dp);
80105a60:	83 ec 0c             	sub    $0xc,%esp
80105a63:	ff 75 f4             	pushl  -0xc(%ebp)
80105a66:	e8 0f c1 ff ff       	call   80101b7a <iunlockput>
80105a6b:	83 c4 10             	add    $0x10,%esp

  return ip;
80105a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105a71:	c9                   	leave  
80105a72:	c3                   	ret    

80105a73 <sys_open>:

int
sys_open(void)
{
80105a73:	55                   	push   %ebp
80105a74:	89 e5                	mov    %esp,%ebp
80105a76:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a79:	83 ec 08             	sub    $0x8,%esp
80105a7c:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105a7f:	50                   	push   %eax
80105a80:	6a 00                	push   $0x0
80105a82:	e8 79 f6 ff ff       	call   80105100 <argstr>
80105a87:	83 c4 10             	add    $0x10,%esp
80105a8a:	85 c0                	test   %eax,%eax
80105a8c:	78 15                	js     80105aa3 <sys_open+0x30>
80105a8e:	83 ec 08             	sub    $0x8,%esp
80105a91:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a94:	50                   	push   %eax
80105a95:	6a 01                	push   $0x1
80105a97:	e8 dd f5 ff ff       	call   80105079 <argint>
80105a9c:	83 c4 10             	add    $0x10,%esp
80105a9f:	85 c0                	test   %eax,%eax
80105aa1:	79 0a                	jns    80105aad <sys_open+0x3a>
    return -1;
80105aa3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aa8:	e9 4d 01 00 00       	jmp    80105bfa <sys_open+0x187>
  if(omode & O_CREATE){
80105aad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ab0:	25 00 02 00 00       	and    $0x200,%eax
80105ab5:	85 c0                	test   %eax,%eax
80105ab7:	74 2f                	je     80105ae8 <sys_open+0x75>
    begin_trans();
80105ab9:	e8 69 d7 ff ff       	call   80103227 <begin_trans>
    ip = create(path, T_FILE, 0, 0);
80105abe:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105ac1:	6a 00                	push   $0x0
80105ac3:	6a 00                	push   $0x0
80105ac5:	6a 02                	push   $0x2
80105ac7:	50                   	push   %eax
80105ac8:	e8 d6 fd ff ff       	call   801058a3 <create>
80105acd:	83 c4 10             	add    $0x10,%esp
80105ad0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
80105ad3:	e8 a1 d7 ff ff       	call   80103279 <commit_trans>
    if(ip == 0)
80105ad8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105adc:	75 66                	jne    80105b44 <sys_open+0xd1>
      return -1;
80105ade:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ae3:	e9 12 01 00 00       	jmp    80105bfa <sys_open+0x187>
  } else {
    if((ip = namei(path)) == 0)
80105ae8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105aeb:	83 ec 0c             	sub    $0xc,%esp
80105aee:	50                   	push   %eax
80105aef:	e8 88 c9 ff ff       	call   8010247c <namei>
80105af4:	83 c4 10             	add    $0x10,%esp
80105af7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105afa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105afe:	75 0a                	jne    80105b0a <sys_open+0x97>
      return -1;
80105b00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b05:	e9 f0 00 00 00       	jmp    80105bfa <sys_open+0x187>
    ilock(ip);
80105b0a:	83 ec 0c             	sub    $0xc,%esp
80105b0d:	ff 75 f4             	pushl  -0xc(%ebp)
80105b10:	e8 ae bd ff ff       	call   801018c3 <ilock>
80105b15:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b1b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105b1f:	66 83 f8 01          	cmp    $0x1,%ax
80105b23:	75 1f                	jne    80105b44 <sys_open+0xd1>
80105b25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105b28:	85 c0                	test   %eax,%eax
80105b2a:	74 18                	je     80105b44 <sys_open+0xd1>
      iunlockput(ip);
80105b2c:	83 ec 0c             	sub    $0xc,%esp
80105b2f:	ff 75 f4             	pushl  -0xc(%ebp)
80105b32:	e8 43 c0 ff ff       	call   80101b7a <iunlockput>
80105b37:	83 c4 10             	add    $0x10,%esp
      return -1;
80105b3a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b3f:	e9 b6 00 00 00       	jmp    80105bfa <sys_open+0x187>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105b44:	e8 f6 b3 ff ff       	call   80100f3f <filealloc>
80105b49:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b50:	74 17                	je     80105b69 <sys_open+0xf6>
80105b52:	83 ec 0c             	sub    $0xc,%esp
80105b55:	ff 75 f0             	pushl  -0x10(%ebp)
80105b58:	e8 ce f6 ff ff       	call   8010522b <fdalloc>
80105b5d:	83 c4 10             	add    $0x10,%esp
80105b60:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105b63:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105b67:	79 29                	jns    80105b92 <sys_open+0x11f>
    if(f)
80105b69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b6d:	74 0e                	je     80105b7d <sys_open+0x10a>
      fileclose(f);
80105b6f:	83 ec 0c             	sub    $0xc,%esp
80105b72:	ff 75 f0             	pushl  -0x10(%ebp)
80105b75:	e8 82 b4 ff ff       	call   80100ffc <fileclose>
80105b7a:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105b7d:	83 ec 0c             	sub    $0xc,%esp
80105b80:	ff 75 f4             	pushl  -0xc(%ebp)
80105b83:	e8 f2 bf ff ff       	call   80101b7a <iunlockput>
80105b88:	83 c4 10             	add    $0x10,%esp
    return -1;
80105b8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b90:	eb 68                	jmp    80105bfa <sys_open+0x187>
  }
  iunlock(ip);
80105b92:	83 ec 0c             	sub    $0xc,%esp
80105b95:	ff 75 f4             	pushl  -0xc(%ebp)
80105b98:	e8 7d be ff ff       	call   80101a1a <iunlock>
80105b9d:	83 c4 10             	add    $0x10,%esp

  f->type = FD_INODE;
80105ba0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ba3:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105ba9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bac:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105baf:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105bb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bb5:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105bbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105bbf:	83 e0 01             	and    $0x1,%eax
80105bc2:	85 c0                	test   %eax,%eax
80105bc4:	0f 94 c0             	sete   %al
80105bc7:	89 c2                	mov    %eax,%edx
80105bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bcc:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105bcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105bd2:	83 e0 01             	and    $0x1,%eax
80105bd5:	85 c0                	test   %eax,%eax
80105bd7:	75 0a                	jne    80105be3 <sys_open+0x170>
80105bd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105bdc:	83 e0 02             	and    $0x2,%eax
80105bdf:	85 c0                	test   %eax,%eax
80105be1:	74 07                	je     80105bea <sys_open+0x177>
80105be3:	b8 01 00 00 00       	mov    $0x1,%eax
80105be8:	eb 05                	jmp    80105bef <sys_open+0x17c>
80105bea:	b8 00 00 00 00       	mov    $0x0,%eax
80105bef:	89 c2                	mov    %eax,%edx
80105bf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bf4:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105bf7:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105bfa:	c9                   	leave  
80105bfb:	c3                   	ret    

80105bfc <sys_mkdir>:

int
sys_mkdir(void)
{
80105bfc:	55                   	push   %ebp
80105bfd:	89 e5                	mov    %esp,%ebp
80105bff:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_trans();
80105c02:	e8 20 d6 ff ff       	call   80103227 <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105c07:	83 ec 08             	sub    $0x8,%esp
80105c0a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c0d:	50                   	push   %eax
80105c0e:	6a 00                	push   $0x0
80105c10:	e8 eb f4 ff ff       	call   80105100 <argstr>
80105c15:	83 c4 10             	add    $0x10,%esp
80105c18:	85 c0                	test   %eax,%eax
80105c1a:	78 1b                	js     80105c37 <sys_mkdir+0x3b>
80105c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c1f:	6a 00                	push   $0x0
80105c21:	6a 00                	push   $0x0
80105c23:	6a 01                	push   $0x1
80105c25:	50                   	push   %eax
80105c26:	e8 78 fc ff ff       	call   801058a3 <create>
80105c2b:	83 c4 10             	add    $0x10,%esp
80105c2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c35:	75 0c                	jne    80105c43 <sys_mkdir+0x47>
    commit_trans();
80105c37:	e8 3d d6 ff ff       	call   80103279 <commit_trans>
    return -1;
80105c3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c41:	eb 18                	jmp    80105c5b <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80105c43:	83 ec 0c             	sub    $0xc,%esp
80105c46:	ff 75 f4             	pushl  -0xc(%ebp)
80105c49:	e8 2c bf ff ff       	call   80101b7a <iunlockput>
80105c4e:	83 c4 10             	add    $0x10,%esp
  commit_trans();
80105c51:	e8 23 d6 ff ff       	call   80103279 <commit_trans>
  return 0;
80105c56:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105c5b:	c9                   	leave  
80105c5c:	c3                   	ret    

80105c5d <sys_mknod>:

int
sys_mknod(void)
{
80105c5d:	55                   	push   %ebp
80105c5e:	89 e5                	mov    %esp,%ebp
80105c60:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
80105c63:	e8 bf d5 ff ff       	call   80103227 <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
80105c68:	83 ec 08             	sub    $0x8,%esp
80105c6b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c6e:	50                   	push   %eax
80105c6f:	6a 00                	push   $0x0
80105c71:	e8 8a f4 ff ff       	call   80105100 <argstr>
80105c76:	83 c4 10             	add    $0x10,%esp
80105c79:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c80:	78 4f                	js     80105cd1 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
80105c82:	83 ec 08             	sub    $0x8,%esp
80105c85:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105c88:	50                   	push   %eax
80105c89:	6a 01                	push   $0x1
80105c8b:	e8 e9 f3 ff ff       	call   80105079 <argint>
80105c90:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
80105c93:	85 c0                	test   %eax,%eax
80105c95:	78 3a                	js     80105cd1 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105c97:	83 ec 08             	sub    $0x8,%esp
80105c9a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c9d:	50                   	push   %eax
80105c9e:	6a 02                	push   $0x2
80105ca0:	e8 d4 f3 ff ff       	call   80105079 <argint>
80105ca5:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105ca8:	85 c0                	test   %eax,%eax
80105caa:	78 25                	js     80105cd1 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80105cac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105caf:	0f bf c8             	movswl %ax,%ecx
80105cb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105cb5:	0f bf d0             	movswl %ax,%edx
80105cb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105cbb:	51                   	push   %ecx
80105cbc:	52                   	push   %edx
80105cbd:	6a 03                	push   $0x3
80105cbf:	50                   	push   %eax
80105cc0:	e8 de fb ff ff       	call   801058a3 <create>
80105cc5:	83 c4 10             	add    $0x10,%esp
80105cc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105ccb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ccf:	75 0c                	jne    80105cdd <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    commit_trans();
80105cd1:	e8 a3 d5 ff ff       	call   80103279 <commit_trans>
    return -1;
80105cd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cdb:	eb 18                	jmp    80105cf5 <sys_mknod+0x98>
  }
  iunlockput(ip);
80105cdd:	83 ec 0c             	sub    $0xc,%esp
80105ce0:	ff 75 f0             	pushl  -0x10(%ebp)
80105ce3:	e8 92 be ff ff       	call   80101b7a <iunlockput>
80105ce8:	83 c4 10             	add    $0x10,%esp
  commit_trans();
80105ceb:	e8 89 d5 ff ff       	call   80103279 <commit_trans>
  return 0;
80105cf0:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105cf5:	c9                   	leave  
80105cf6:	c3                   	ret    

80105cf7 <sys_chdir>:

int
sys_chdir(void)
{
80105cf7:	55                   	push   %ebp
80105cf8:	89 e5                	mov    %esp,%ebp
80105cfa:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80105cfd:	83 ec 08             	sub    $0x8,%esp
80105d00:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d03:	50                   	push   %eax
80105d04:	6a 00                	push   $0x0
80105d06:	e8 f5 f3 ff ff       	call   80105100 <argstr>
80105d0b:	83 c4 10             	add    $0x10,%esp
80105d0e:	85 c0                	test   %eax,%eax
80105d10:	78 18                	js     80105d2a <sys_chdir+0x33>
80105d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d15:	83 ec 0c             	sub    $0xc,%esp
80105d18:	50                   	push   %eax
80105d19:	e8 5e c7 ff ff       	call   8010247c <namei>
80105d1e:	83 c4 10             	add    $0x10,%esp
80105d21:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d28:	75 07                	jne    80105d31 <sys_chdir+0x3a>
    return -1;
80105d2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d2f:	eb 64                	jmp    80105d95 <sys_chdir+0x9e>
  ilock(ip);
80105d31:	83 ec 0c             	sub    $0xc,%esp
80105d34:	ff 75 f4             	pushl  -0xc(%ebp)
80105d37:	e8 87 bb ff ff       	call   801018c3 <ilock>
80105d3c:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80105d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d42:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105d46:	66 83 f8 01          	cmp    $0x1,%ax
80105d4a:	74 15                	je     80105d61 <sys_chdir+0x6a>
    iunlockput(ip);
80105d4c:	83 ec 0c             	sub    $0xc,%esp
80105d4f:	ff 75 f4             	pushl  -0xc(%ebp)
80105d52:	e8 23 be ff ff       	call   80101b7a <iunlockput>
80105d57:	83 c4 10             	add    $0x10,%esp
    return -1;
80105d5a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d5f:	eb 34                	jmp    80105d95 <sys_chdir+0x9e>
  }
  iunlock(ip);
80105d61:	83 ec 0c             	sub    $0xc,%esp
80105d64:	ff 75 f4             	pushl  -0xc(%ebp)
80105d67:	e8 ae bc ff ff       	call   80101a1a <iunlock>
80105d6c:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80105d6f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d75:	8b 40 68             	mov    0x68(%eax),%eax
80105d78:	83 ec 0c             	sub    $0xc,%esp
80105d7b:	50                   	push   %eax
80105d7c:	e8 0a bd ff ff       	call   80101a8b <iput>
80105d81:	83 c4 10             	add    $0x10,%esp
  proc->cwd = ip;
80105d84:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d8d:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80105d90:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d95:	c9                   	leave  
80105d96:	c3                   	ret    

80105d97 <sys_exec>:

int
sys_exec(void)
{
80105d97:	55                   	push   %ebp
80105d98:	89 e5                	mov    %esp,%ebp
80105d9a:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105da0:	83 ec 08             	sub    $0x8,%esp
80105da3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105da6:	50                   	push   %eax
80105da7:	6a 00                	push   $0x0
80105da9:	e8 52 f3 ff ff       	call   80105100 <argstr>
80105dae:	83 c4 10             	add    $0x10,%esp
80105db1:	85 c0                	test   %eax,%eax
80105db3:	78 18                	js     80105dcd <sys_exec+0x36>
80105db5:	83 ec 08             	sub    $0x8,%esp
80105db8:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80105dbe:	50                   	push   %eax
80105dbf:	6a 01                	push   $0x1
80105dc1:	e8 b3 f2 ff ff       	call   80105079 <argint>
80105dc6:	83 c4 10             	add    $0x10,%esp
80105dc9:	85 c0                	test   %eax,%eax
80105dcb:	79 0a                	jns    80105dd7 <sys_exec+0x40>
    return -1;
80105dcd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dd2:	e9 c6 00 00 00       	jmp    80105e9d <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80105dd7:	83 ec 04             	sub    $0x4,%esp
80105dda:	68 80 00 00 00       	push   $0x80
80105ddf:	6a 00                	push   $0x0
80105de1:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105de7:	50                   	push   %eax
80105de8:	e8 65 ef ff ff       	call   80104d52 <memset>
80105ded:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80105df0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80105df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dfa:	83 f8 1f             	cmp    $0x1f,%eax
80105dfd:	76 0a                	jbe    80105e09 <sys_exec+0x72>
      return -1;
80105dff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e04:	e9 94 00 00 00       	jmp    80105e9d <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e0c:	c1 e0 02             	shl    $0x2,%eax
80105e0f:	89 c2                	mov    %eax,%edx
80105e11:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80105e17:	01 c2                	add    %eax,%edx
80105e19:	83 ec 08             	sub    $0x8,%esp
80105e1c:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105e22:	50                   	push   %eax
80105e23:	52                   	push   %edx
80105e24:	e8 b4 f1 ff ff       	call   80104fdd <fetchint>
80105e29:	83 c4 10             	add    $0x10,%esp
80105e2c:	85 c0                	test   %eax,%eax
80105e2e:	79 07                	jns    80105e37 <sys_exec+0xa0>
      return -1;
80105e30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e35:	eb 66                	jmp    80105e9d <sys_exec+0x106>
    if(uarg == 0){
80105e37:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105e3d:	85 c0                	test   %eax,%eax
80105e3f:	75 27                	jne    80105e68 <sys_exec+0xd1>
      argv[i] = 0;
80105e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e44:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80105e4b:	00 00 00 00 
      break;
80105e4f:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e53:	83 ec 08             	sub    $0x8,%esp
80105e56:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105e5c:	52                   	push   %edx
80105e5d:	50                   	push   %eax
80105e5e:	e8 e4 ac ff ff       	call   80100b47 <exec>
80105e63:	83 c4 10             	add    $0x10,%esp
80105e66:	eb 35                	jmp    80105e9d <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105e68:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105e6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e71:	c1 e2 02             	shl    $0x2,%edx
80105e74:	01 c2                	add    %eax,%edx
80105e76:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105e7c:	83 ec 08             	sub    $0x8,%esp
80105e7f:	52                   	push   %edx
80105e80:	50                   	push   %eax
80105e81:	e8 91 f1 ff ff       	call   80105017 <fetchstr>
80105e86:	83 c4 10             	add    $0x10,%esp
80105e89:	85 c0                	test   %eax,%eax
80105e8b:	79 07                	jns    80105e94 <sys_exec+0xfd>
      return -1;
80105e8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e92:	eb 09                	jmp    80105e9d <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105e94:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80105e98:	e9 5a ff ff ff       	jmp    80105df7 <sys_exec+0x60>
  return exec(path, argv);
}
80105e9d:	c9                   	leave  
80105e9e:	c3                   	ret    

80105e9f <sys_pipe>:

int
sys_pipe(void)
{
80105e9f:	55                   	push   %ebp
80105ea0:	89 e5                	mov    %esp,%ebp
80105ea2:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105ea5:	83 ec 04             	sub    $0x4,%esp
80105ea8:	6a 08                	push   $0x8
80105eaa:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ead:	50                   	push   %eax
80105eae:	6a 00                	push   $0x0
80105eb0:	e8 ec f1 ff ff       	call   801050a1 <argptr>
80105eb5:	83 c4 10             	add    $0x10,%esp
80105eb8:	85 c0                	test   %eax,%eax
80105eba:	79 0a                	jns    80105ec6 <sys_pipe+0x27>
    return -1;
80105ebc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ec1:	e9 af 00 00 00       	jmp    80105f75 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80105ec6:	83 ec 08             	sub    $0x8,%esp
80105ec9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ecc:	50                   	push   %eax
80105ecd:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105ed0:	50                   	push   %eax
80105ed1:	e8 c0 dc ff ff       	call   80103b96 <pipealloc>
80105ed6:	83 c4 10             	add    $0x10,%esp
80105ed9:	85 c0                	test   %eax,%eax
80105edb:	79 0a                	jns    80105ee7 <sys_pipe+0x48>
    return -1;
80105edd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ee2:	e9 8e 00 00 00       	jmp    80105f75 <sys_pipe+0xd6>
  fd0 = -1;
80105ee7:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105eee:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105ef1:	83 ec 0c             	sub    $0xc,%esp
80105ef4:	50                   	push   %eax
80105ef5:	e8 31 f3 ff ff       	call   8010522b <fdalloc>
80105efa:	83 c4 10             	add    $0x10,%esp
80105efd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f04:	78 18                	js     80105f1e <sys_pipe+0x7f>
80105f06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f09:	83 ec 0c             	sub    $0xc,%esp
80105f0c:	50                   	push   %eax
80105f0d:	e8 19 f3 ff ff       	call   8010522b <fdalloc>
80105f12:	83 c4 10             	add    $0x10,%esp
80105f15:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f1c:	79 3f                	jns    80105f5d <sys_pipe+0xbe>
    if(fd0 >= 0)
80105f1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f22:	78 14                	js     80105f38 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80105f24:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f2d:	83 c2 08             	add    $0x8,%edx
80105f30:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105f37:	00 
    fileclose(rf);
80105f38:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105f3b:	83 ec 0c             	sub    $0xc,%esp
80105f3e:	50                   	push   %eax
80105f3f:	e8 b8 b0 ff ff       	call   80100ffc <fileclose>
80105f44:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80105f47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f4a:	83 ec 0c             	sub    $0xc,%esp
80105f4d:	50                   	push   %eax
80105f4e:	e8 a9 b0 ff ff       	call   80100ffc <fileclose>
80105f53:	83 c4 10             	add    $0x10,%esp
    return -1;
80105f56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f5b:	eb 18                	jmp    80105f75 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80105f5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105f60:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f63:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80105f65:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105f68:	8d 50 04             	lea    0x4(%eax),%edx
80105f6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f6e:	89 02                	mov    %eax,(%edx)
  return 0;
80105f70:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f75:	c9                   	leave  
80105f76:	c3                   	ret    

80105f77 <name_of_inode>:

int
name_of_inode(struct inode *ip, struct inode *parent, char buf[DIRSIZ]) {
80105f77:	55                   	push   %ebp
80105f78:	89 e5                	mov    %esp,%ebp
80105f7a:	83 ec 28             	sub    $0x28,%esp
  uint off;
  struct dirent de;
  for (off = 0; off < parent->size; off += sizeof(de)) {
80105f7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105f84:	eb 59                	jmp    80105fdf <name_of_inode+0x68>
    if (readi(parent, (char*)&de, off, sizeof(de)) != sizeof(de))
80105f86:	6a 10                	push   $0x10
80105f88:	ff 75 f4             	pushl  -0xc(%ebp)
80105f8b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105f8e:	50                   	push   %eax
80105f8f:	ff 75 0c             	pushl  0xc(%ebp)
80105f92:	e8 8e be ff ff       	call   80101e25 <readi>
80105f97:	83 c4 10             	add    $0x10,%esp
80105f9a:	83 f8 10             	cmp    $0x10,%eax
80105f9d:	74 0d                	je     80105fac <name_of_inode+0x35>
      panic("can't read directory");
80105f9f:	83 ec 0c             	sub    $0xc,%esp
80105fa2:	68 14 87 10 80       	push   $0x80108714
80105fa7:	e8 b0 a5 ff ff       	call   8010055c <panic>
    if (de.inum == ip->inum) {
80105fac:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105fb0:	0f b7 d0             	movzwl %ax,%edx
80105fb3:	8b 45 08             	mov    0x8(%ebp),%eax
80105fb6:	8b 40 04             	mov    0x4(%eax),%eax
80105fb9:	39 c2                	cmp    %eax,%edx
80105fbb:	75 1e                	jne    80105fdb <name_of_inode+0x64>
      safestrcpy(buf, de.name, DIRSIZ);
80105fbd:	83 ec 04             	sub    $0x4,%esp
80105fc0:	6a 0e                	push   $0xe
80105fc2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105fc5:	83 c0 02             	add    $0x2,%eax
80105fc8:	50                   	push   %eax
80105fc9:	ff 75 10             	pushl  0x10(%ebp)
80105fcc:	e8 86 ef ff ff       	call   80104f57 <safestrcpy>
80105fd1:	83 c4 10             	add    $0x10,%esp
      return 0;
80105fd4:	b8 00 00 00 00       	mov    $0x0,%eax
80105fd9:	eb 14                	jmp    80105fef <name_of_inode+0x78>

int
name_of_inode(struct inode *ip, struct inode *parent, char buf[DIRSIZ]) {
  uint off;
  struct dirent de;
  for (off = 0; off < parent->size; off += sizeof(de)) {
80105fdb:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80105fdf:	8b 45 0c             	mov    0xc(%ebp),%eax
80105fe2:	8b 40 18             	mov    0x18(%eax),%eax
80105fe5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105fe8:	77 9c                	ja     80105f86 <name_of_inode+0xf>
    if (de.inum == ip->inum) {
      safestrcpy(buf, de.name, DIRSIZ);
      return 0;
    }
  }
  return -1;
80105fea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fef:	c9                   	leave  
80105ff0:	c3                   	ret    

80105ff1 <name_for_inode>:

int
name_for_inode(char* buf, int n, struct inode *ip) {
80105ff1:	55                   	push   %ebp
80105ff2:	89 e5                	mov    %esp,%ebp
80105ff4:	53                   	push   %ebx
80105ff5:	83 ec 24             	sub    $0x24,%esp
  int path_offset;
  struct inode *parent;
  char node_name[DIRSIZ];
  if (ip->inum == namei("/")->inum) {  
80105ff8:	8b 45 10             	mov    0x10(%ebp),%eax
80105ffb:	8b 58 04             	mov    0x4(%eax),%ebx
80105ffe:	83 ec 0c             	sub    $0xc,%esp
80106001:	68 29 87 10 80       	push   $0x80108729
80106006:	e8 71 c4 ff ff       	call   8010247c <namei>
8010600b:	83 c4 10             	add    $0x10,%esp
8010600e:	8b 40 04             	mov    0x4(%eax),%eax
80106011:	39 c3                	cmp    %eax,%ebx
80106013:	75 10                	jne    80106025 <name_for_inode+0x34>
    buf[0] = '/';
80106015:	8b 45 08             	mov    0x8(%ebp),%eax
80106018:	c6 00 2f             	movb   $0x2f,(%eax)
    return 1;
8010601b:	b8 01 00 00 00       	mov    $0x1,%eax
80106020:	e9 1a 01 00 00       	jmp    8010613f <name_for_inode+0x14e>
  } else if (ip->type == T_DIR) {
80106025:	8b 45 10             	mov    0x10(%ebp),%eax
80106028:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010602c:	66 83 f8 01          	cmp    $0x1,%ax
80106030:	0f 85 d5 00 00 00    	jne    8010610b <name_for_inode+0x11a>
    parent = dirlookup(ip, "..", 0);
80106036:	83 ec 04             	sub    $0x4,%esp
80106039:	6a 00                	push   $0x0
8010603b:	68 c5 86 10 80       	push   $0x801086c5
80106040:	ff 75 10             	pushl  0x10(%ebp)
80106043:	e8 e1 c0 ff ff       	call   80102129 <dirlookup>
80106048:	83 c4 10             	add    $0x10,%esp
8010604b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    ilock(parent);
8010604e:	83 ec 0c             	sub    $0xc,%esp
80106051:	ff 75 f4             	pushl  -0xc(%ebp)
80106054:	e8 6a b8 ff ff       	call   801018c3 <ilock>
80106059:	83 c4 10             	add    $0x10,%esp
    if (name_of_inode(ip, parent, node_name)) {
8010605c:	83 ec 04             	sub    $0x4,%esp
8010605f:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106062:	50                   	push   %eax
80106063:	ff 75 f4             	pushl  -0xc(%ebp)
80106066:	ff 75 10             	pushl  0x10(%ebp)
80106069:	e8 09 ff ff ff       	call   80105f77 <name_of_inode>
8010606e:	83 c4 10             	add    $0x10,%esp
80106071:	85 c0                	test   %eax,%eax
80106073:	74 0d                	je     80106082 <name_for_inode+0x91>
      panic("could not find name of inode");
80106075:	83 ec 0c             	sub    $0xc,%esp
80106078:	68 2b 87 10 80       	push   $0x8010872b
8010607d:	e8 da a4 ff ff       	call   8010055c <panic>
    }
    path_offset = name_for_inode(buf, n, parent);
80106082:	83 ec 04             	sub    $0x4,%esp
80106085:	ff 75 f4             	pushl  -0xc(%ebp)
80106088:	ff 75 0c             	pushl  0xc(%ebp)
8010608b:	ff 75 08             	pushl  0x8(%ebp)
8010608e:	e8 5e ff ff ff       	call   80105ff1 <name_for_inode>
80106093:	83 c4 10             	add    $0x10,%esp
80106096:	89 45 f0             	mov    %eax,-0x10(%ebp)
    safestrcpy(buf + path_offset, node_name, n - path_offset);
80106099:	8b 45 0c             	mov    0xc(%ebp),%eax
8010609c:	2b 45 f0             	sub    -0x10(%ebp),%eax
8010609f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801060a2:	8b 55 08             	mov    0x8(%ebp),%edx
801060a5:	01 ca                	add    %ecx,%edx
801060a7:	83 ec 04             	sub    $0x4,%esp
801060aa:	50                   	push   %eax
801060ab:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801060ae:	50                   	push   %eax
801060af:	52                   	push   %edx
801060b0:	e8 a2 ee ff ff       	call   80104f57 <safestrcpy>
801060b5:	83 c4 10             	add    $0x10,%esp
    path_offset += strlen(node_name);
801060b8:	83 ec 0c             	sub    $0xc,%esp
801060bb:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801060be:	50                   	push   %eax
801060bf:	e8 dd ee ff ff       	call   80104fa1 <strlen>
801060c4:	83 c4 10             	add    $0x10,%esp
801060c7:	01 45 f0             	add    %eax,-0x10(%ebp)
    if (path_offset == n - 1) {
801060ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801060cd:	83 e8 01             	sub    $0x1,%eax
801060d0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801060d3:	75 10                	jne    801060e5 <name_for_inode+0xf4>
      buf[path_offset] = '\0';
801060d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801060d8:	8b 45 08             	mov    0x8(%ebp),%eax
801060db:	01 d0                	add    %edx,%eax
801060dd:	c6 00 00             	movb   $0x0,(%eax)
      return n;
801060e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801060e3:	eb 5a                	jmp    8010613f <name_for_inode+0x14e>
    } else {
      buf[path_offset++] = '/';
801060e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060e8:	8d 50 01             	lea    0x1(%eax),%edx
801060eb:	89 55 f0             	mov    %edx,-0x10(%ebp)
801060ee:	89 c2                	mov    %eax,%edx
801060f0:	8b 45 08             	mov    0x8(%ebp),%eax
801060f3:	01 d0                	add    %edx,%eax
801060f5:	c6 00 2f             	movb   $0x2f,(%eax)
    }
    iput(parent); //free
801060f8:	83 ec 0c             	sub    $0xc,%esp
801060fb:	ff 75 f4             	pushl  -0xc(%ebp)
801060fe:	e8 88 b9 ff ff       	call   80101a8b <iput>
80106103:	83 c4 10             	add    $0x10,%esp
    return path_offset;
80106106:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106109:	eb 34                	jmp    8010613f <name_for_inode+0x14e>
  } else if (ip->type == T_DEV || ip->type == T_FILE) {
8010610b:	8b 45 10             	mov    0x10(%ebp),%eax
8010610e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106112:	66 83 f8 03          	cmp    $0x3,%ax
80106116:	74 0d                	je     80106125 <name_for_inode+0x134>
80106118:	8b 45 10             	mov    0x10(%ebp),%eax
8010611b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010611f:	66 83 f8 02          	cmp    $0x2,%ax
80106123:	75 0d                	jne    80106132 <name_for_inode+0x141>
    panic("process cwd is not a directory");
80106125:	83 ec 0c             	sub    $0xc,%esp
80106128:	68 48 87 10 80       	push   $0x80108748
8010612d:	e8 2a a4 ff ff       	call   8010055c <panic>
  } else {
    panic("unknown inode type");
80106132:	83 ec 0c             	sub    $0xc,%esp
80106135:	68 67 87 10 80       	push   $0x80108767
8010613a:	e8 1d a4 ff ff       	call   8010055c <panic>
  }
}
8010613f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106142:	c9                   	leave  
80106143:	c3                   	ret    

80106144 <sys_getcwd>:

int
sys_getcwd(void)
{
80106144:	55                   	push   %ebp
80106145:	89 e5                	mov    %esp,%ebp
80106147:	83 ec 18             	sub    $0x18,%esp
  char *p;
  int n;
  if(argint(1, &n) < 0 || argptr(0, &p, n) < 0)
8010614a:	83 ec 08             	sub    $0x8,%esp
8010614d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106150:	50                   	push   %eax
80106151:	6a 01                	push   $0x1
80106153:	e8 21 ef ff ff       	call   80105079 <argint>
80106158:	83 c4 10             	add    $0x10,%esp
8010615b:	85 c0                	test   %eax,%eax
8010615d:	78 19                	js     80106178 <sys_getcwd+0x34>
8010615f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106162:	83 ec 04             	sub    $0x4,%esp
80106165:	50                   	push   %eax
80106166:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106169:	50                   	push   %eax
8010616a:	6a 00                	push   $0x0
8010616c:	e8 30 ef ff ff       	call   801050a1 <argptr>
80106171:	83 c4 10             	add    $0x10,%esp
80106174:	85 c0                	test   %eax,%eax
80106176:	79 07                	jns    8010617f <sys_getcwd+0x3b>
    return -1;
80106178:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010617d:	eb 1d                	jmp    8010619c <sys_getcwd+0x58>
  return name_for_inode(p, n, proc->cwd);
8010617f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106185:	8b 48 68             	mov    0x68(%eax),%ecx
80106188:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010618b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010618e:	83 ec 04             	sub    $0x4,%esp
80106191:	51                   	push   %ecx
80106192:	52                   	push   %edx
80106193:	50                   	push   %eax
80106194:	e8 58 fe ff ff       	call   80105ff1 <name_for_inode>
80106199:	83 c4 10             	add    $0x10,%esp
}
8010619c:	c9                   	leave  
8010619d:	c3                   	ret    

8010619e <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
8010619e:	55                   	push   %ebp
8010619f:	89 e5                	mov    %esp,%ebp
801061a1:	83 ec 08             	sub    $0x8,%esp
801061a4:	8b 55 08             	mov    0x8(%ebp),%edx
801061a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801061aa:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801061ae:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801061b2:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
801061b6:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801061ba:	66 ef                	out    %ax,(%dx)
}
801061bc:	c9                   	leave  
801061bd:	c3                   	ret    

801061be <sys_fork>:
#include "proc.h"
#include "version.h"

int
sys_fork(void)
{
801061be:	55                   	push   %ebp
801061bf:	89 e5                	mov    %esp,%ebp
801061c1:	83 ec 08             	sub    $0x8,%esp
  return fork();
801061c4:	e8 b9 e0 ff ff       	call   80104282 <fork>
}
801061c9:	c9                   	leave  
801061ca:	c3                   	ret    

801061cb <sys_exit>:

int
sys_exit(void)
{
801061cb:	55                   	push   %ebp
801061cc:	89 e5                	mov    %esp,%ebp
801061ce:	83 ec 08             	sub    $0x8,%esp
  exit();
801061d1:	e8 17 e2 ff ff       	call   801043ed <exit>
  return 0;  // not reached
801061d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061db:	c9                   	leave  
801061dc:	c3                   	ret    

801061dd <sys_wait>:

int
sys_wait(void)
{
801061dd:	55                   	push   %ebp
801061de:	89 e5                	mov    %esp,%ebp
801061e0:	83 ec 08             	sub    $0x8,%esp
  return wait();
801061e3:	e8 33 e3 ff ff       	call   8010451b <wait>
}
801061e8:	c9                   	leave  
801061e9:	c3                   	ret    

801061ea <sys_kill>:

int
sys_kill(void)
{
801061ea:	55                   	push   %ebp
801061eb:	89 e5                	mov    %esp,%ebp
801061ed:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
801061f0:	83 ec 08             	sub    $0x8,%esp
801061f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061f6:	50                   	push   %eax
801061f7:	6a 00                	push   $0x0
801061f9:	e8 7b ee ff ff       	call   80105079 <argint>
801061fe:	83 c4 10             	add    $0x10,%esp
80106201:	85 c0                	test   %eax,%eax
80106203:	79 07                	jns    8010620c <sys_kill+0x22>
    return -1;
80106205:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010620a:	eb 0f                	jmp    8010621b <sys_kill+0x31>
  return kill(pid);
8010620c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010620f:	83 ec 0c             	sub    $0xc,%esp
80106212:	50                   	push   %eax
80106213:	e8 0f e7 ff ff       	call   80104927 <kill>
80106218:	83 c4 10             	add    $0x10,%esp
}
8010621b:	c9                   	leave  
8010621c:	c3                   	ret    

8010621d <sys_getpid>:

int
sys_getpid(void)
{
8010621d:	55                   	push   %ebp
8010621e:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106220:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106226:	8b 40 10             	mov    0x10(%eax),%eax
}
80106229:	5d                   	pop    %ebp
8010622a:	c3                   	ret    

8010622b <sys_sbrk>:

int
sys_sbrk(void)
{
8010622b:	55                   	push   %ebp
8010622c:	89 e5                	mov    %esp,%ebp
8010622e:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106231:	83 ec 08             	sub    $0x8,%esp
80106234:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106237:	50                   	push   %eax
80106238:	6a 00                	push   $0x0
8010623a:	e8 3a ee ff ff       	call   80105079 <argint>
8010623f:	83 c4 10             	add    $0x10,%esp
80106242:	85 c0                	test   %eax,%eax
80106244:	79 07                	jns    8010624d <sys_sbrk+0x22>
    return -1;
80106246:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010624b:	eb 28                	jmp    80106275 <sys_sbrk+0x4a>
  addr = proc->sz;
8010624d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106253:	8b 00                	mov    (%eax),%eax
80106255:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106258:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010625b:	83 ec 0c             	sub    $0xc,%esp
8010625e:	50                   	push   %eax
8010625f:	e8 7b df ff ff       	call   801041df <growproc>
80106264:	83 c4 10             	add    $0x10,%esp
80106267:	85 c0                	test   %eax,%eax
80106269:	79 07                	jns    80106272 <sys_sbrk+0x47>
    return -1;
8010626b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106270:	eb 03                	jmp    80106275 <sys_sbrk+0x4a>
  return addr;
80106272:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106275:	c9                   	leave  
80106276:	c3                   	ret    

80106277 <sys_sleep>:

int
sys_sleep(void)
{
80106277:	55                   	push   %ebp
80106278:	89 e5                	mov    %esp,%ebp
8010627a:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
8010627d:	83 ec 08             	sub    $0x8,%esp
80106280:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106283:	50                   	push   %eax
80106284:	6a 00                	push   $0x0
80106286:	e8 ee ed ff ff       	call   80105079 <argint>
8010628b:	83 c4 10             	add    $0x10,%esp
8010628e:	85 c0                	test   %eax,%eax
80106290:	79 07                	jns    80106299 <sys_sleep+0x22>
    return -1;
80106292:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106297:	eb 79                	jmp    80106312 <sys_sleep+0x9b>
  acquire(&tickslock);
80106299:	83 ec 0c             	sub    $0xc,%esp
8010629c:	68 00 1f 11 80       	push   $0x80111f00
801062a1:	e8 50 e8 ff ff       	call   80104af6 <acquire>
801062a6:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801062a9:	a1 40 27 11 80       	mov    0x80112740,%eax
801062ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801062b1:	eb 39                	jmp    801062ec <sys_sleep+0x75>
    if(proc->killed){
801062b3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801062b9:	8b 40 24             	mov    0x24(%eax),%eax
801062bc:	85 c0                	test   %eax,%eax
801062be:	74 17                	je     801062d7 <sys_sleep+0x60>
      release(&tickslock);
801062c0:	83 ec 0c             	sub    $0xc,%esp
801062c3:	68 00 1f 11 80       	push   $0x80111f00
801062c8:	e8 8f e8 ff ff       	call   80104b5c <release>
801062cd:	83 c4 10             	add    $0x10,%esp
      return -1;
801062d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062d5:	eb 3b                	jmp    80106312 <sys_sleep+0x9b>
    }
    sleep(&ticks, &tickslock);
801062d7:	83 ec 08             	sub    $0x8,%esp
801062da:	68 00 1f 11 80       	push   $0x80111f00
801062df:	68 40 27 11 80       	push   $0x80112740
801062e4:	e8 1f e5 ff ff       	call   80104808 <sleep>
801062e9:	83 c4 10             	add    $0x10,%esp
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801062ec:	a1 40 27 11 80       	mov    0x80112740,%eax
801062f1:	2b 45 f4             	sub    -0xc(%ebp),%eax
801062f4:	89 c2                	mov    %eax,%edx
801062f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062f9:	39 c2                	cmp    %eax,%edx
801062fb:	72 b6                	jb     801062b3 <sys_sleep+0x3c>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801062fd:	83 ec 0c             	sub    $0xc,%esp
80106300:	68 00 1f 11 80       	push   $0x80111f00
80106305:	e8 52 e8 ff ff       	call   80104b5c <release>
8010630a:	83 c4 10             	add    $0x10,%esp
  return 0;
8010630d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106312:	c9                   	leave  
80106313:	c3                   	ret    

80106314 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106314:	55                   	push   %ebp
80106315:	89 e5                	mov    %esp,%ebp
80106317:	83 ec 18             	sub    $0x18,%esp
  uint xticks;
  
  acquire(&tickslock);
8010631a:	83 ec 0c             	sub    $0xc,%esp
8010631d:	68 00 1f 11 80       	push   $0x80111f00
80106322:	e8 cf e7 ff ff       	call   80104af6 <acquire>
80106327:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
8010632a:	a1 40 27 11 80       	mov    0x80112740,%eax
8010632f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106332:	83 ec 0c             	sub    $0xc,%esp
80106335:	68 00 1f 11 80       	push   $0x80111f00
8010633a:	e8 1d e8 ff ff       	call   80104b5c <release>
8010633f:	83 c4 10             	add    $0x10,%esp
  return xticks;
80106342:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106345:	c9                   	leave  
80106346:	c3                   	ret    

80106347 <sys_shutdown>:

int
sys_shutdown(void)
{
80106347:	55                   	push   %ebp
80106348:	89 e5                	mov    %esp,%ebp
8010634a:	83 ec 08             	sub    $0x8,%esp

cprintf("halt signal is sent");
8010634d:	83 ec 0c             	sub    $0xc,%esp
80106350:	68 7c 87 10 80       	push   $0x8010877c
80106355:	e8 65 a0 ff ff       	call   801003bf <cprintf>
8010635a:	83 c4 10             	add    $0x10,%esp
outw( 0xB004, 0x0 | 0x2000 );
8010635d:	83 ec 08             	sub    $0x8,%esp
80106360:	68 00 20 00 00       	push   $0x2000
80106365:	68 04 b0 00 00       	push   $0xb004
8010636a:	e8 2f fe ff ff       	call   8010619e <outw>
8010636f:	83 c4 10             	add    $0x10,%esp

return 0;
80106372:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106377:	c9                   	leave  
80106378:	c3                   	ret    

80106379 <sys_buildinfo>:


int
sys_buildinfo(void)
{
80106379:	55                   	push   %ebp
8010637a:	89 e5                	mov    %esp,%ebp
8010637c:	83 ec 08             	sub    $0x8,%esp
  cprintf(UNAME" "VERSION" "DATE" "TIME"\n");
8010637f:	83 ec 0c             	sub    $0xc,%esp
80106382:	68 90 87 10 80       	push   $0x80108790
80106387:	e8 33 a0 ff ff       	call   801003bf <cprintf>
8010638c:	83 c4 10             	add    $0x10,%esp
  return 1;
8010638f:	b8 01 00 00 00       	mov    $0x1,%eax
}
80106394:	c9                   	leave  
80106395:	c3                   	ret    

80106396 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106396:	55                   	push   %ebp
80106397:	89 e5                	mov    %esp,%ebp
80106399:	83 ec 08             	sub    $0x8,%esp
8010639c:	8b 55 08             	mov    0x8(%ebp),%edx
8010639f:	8b 45 0c             	mov    0xc(%ebp),%eax
801063a2:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801063a6:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801063a9:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801063ad:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801063b1:	ee                   	out    %al,(%dx)
}
801063b2:	c9                   	leave  
801063b3:	c3                   	ret    

801063b4 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801063b4:	55                   	push   %ebp
801063b5:	89 e5                	mov    %esp,%ebp
801063b7:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
801063ba:	6a 34                	push   $0x34
801063bc:	6a 43                	push   $0x43
801063be:	e8 d3 ff ff ff       	call   80106396 <outb>
801063c3:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
801063c6:	68 9c 00 00 00       	push   $0x9c
801063cb:	6a 40                	push   $0x40
801063cd:	e8 c4 ff ff ff       	call   80106396 <outb>
801063d2:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
801063d5:	6a 2e                	push   $0x2e
801063d7:	6a 40                	push   $0x40
801063d9:	e8 b8 ff ff ff       	call   80106396 <outb>
801063de:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
801063e1:	83 ec 0c             	sub    $0xc,%esp
801063e4:	6a 00                	push   $0x0
801063e6:	e8 97 d6 ff ff       	call   80103a82 <picenable>
801063eb:	83 c4 10             	add    $0x10,%esp
}
801063ee:	c9                   	leave  
801063ef:	c3                   	ret    

801063f0 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801063f0:	1e                   	push   %ds
  pushl %es
801063f1:	06                   	push   %es
  pushl %fs
801063f2:	0f a0                	push   %fs
  pushl %gs
801063f4:	0f a8                	push   %gs
  pushal
801063f6:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
801063f7:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801063fb:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801063fd:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
801063ff:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106403:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106405:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106407:	54                   	push   %esp
  call trap
80106408:	e8 d4 01 00 00       	call   801065e1 <trap>
  addl $4, %esp
8010640d:	83 c4 04             	add    $0x4,%esp

80106410 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106410:	61                   	popa   
  popl %gs
80106411:	0f a9                	pop    %gs
  popl %fs
80106413:	0f a1                	pop    %fs
  popl %es
80106415:	07                   	pop    %es
  popl %ds
80106416:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106417:	83 c4 08             	add    $0x8,%esp
  iret
8010641a:	cf                   	iret   

8010641b <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
8010641b:	55                   	push   %ebp
8010641c:	89 e5                	mov    %esp,%ebp
8010641e:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106421:	8b 45 0c             	mov    0xc(%ebp),%eax
80106424:	83 e8 01             	sub    $0x1,%eax
80106427:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010642b:	8b 45 08             	mov    0x8(%ebp),%eax
8010642e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106432:	8b 45 08             	mov    0x8(%ebp),%eax
80106435:	c1 e8 10             	shr    $0x10,%eax
80106438:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010643c:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010643f:	0f 01 18             	lidtl  (%eax)
}
80106442:	c9                   	leave  
80106443:	c3                   	ret    

80106444 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106444:	55                   	push   %ebp
80106445:	89 e5                	mov    %esp,%ebp
80106447:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010644a:	0f 20 d0             	mov    %cr2,%eax
8010644d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106450:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106453:	c9                   	leave  
80106454:	c3                   	ret    

80106455 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106455:	55                   	push   %ebp
80106456:	89 e5                	mov    %esp,%ebp
80106458:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
8010645b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106462:	e9 c3 00 00 00       	jmp    8010652a <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106467:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010646a:	8b 04 85 a8 b0 10 80 	mov    -0x7fef4f58(,%eax,4),%eax
80106471:	89 c2                	mov    %eax,%edx
80106473:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106476:	66 89 14 c5 40 1f 11 	mov    %dx,-0x7feee0c0(,%eax,8)
8010647d:	80 
8010647e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106481:	66 c7 04 c5 42 1f 11 	movw   $0x8,-0x7feee0be(,%eax,8)
80106488:	80 08 00 
8010648b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010648e:	0f b6 14 c5 44 1f 11 	movzbl -0x7feee0bc(,%eax,8),%edx
80106495:	80 
80106496:	83 e2 e0             	and    $0xffffffe0,%edx
80106499:	88 14 c5 44 1f 11 80 	mov    %dl,-0x7feee0bc(,%eax,8)
801064a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064a3:	0f b6 14 c5 44 1f 11 	movzbl -0x7feee0bc(,%eax,8),%edx
801064aa:	80 
801064ab:	83 e2 1f             	and    $0x1f,%edx
801064ae:	88 14 c5 44 1f 11 80 	mov    %dl,-0x7feee0bc(,%eax,8)
801064b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064b8:	0f b6 14 c5 45 1f 11 	movzbl -0x7feee0bb(,%eax,8),%edx
801064bf:	80 
801064c0:	83 e2 f0             	and    $0xfffffff0,%edx
801064c3:	83 ca 0e             	or     $0xe,%edx
801064c6:	88 14 c5 45 1f 11 80 	mov    %dl,-0x7feee0bb(,%eax,8)
801064cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064d0:	0f b6 14 c5 45 1f 11 	movzbl -0x7feee0bb(,%eax,8),%edx
801064d7:	80 
801064d8:	83 e2 ef             	and    $0xffffffef,%edx
801064db:	88 14 c5 45 1f 11 80 	mov    %dl,-0x7feee0bb(,%eax,8)
801064e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064e5:	0f b6 14 c5 45 1f 11 	movzbl -0x7feee0bb(,%eax,8),%edx
801064ec:	80 
801064ed:	83 e2 9f             	and    $0xffffff9f,%edx
801064f0:	88 14 c5 45 1f 11 80 	mov    %dl,-0x7feee0bb(,%eax,8)
801064f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064fa:	0f b6 14 c5 45 1f 11 	movzbl -0x7feee0bb(,%eax,8),%edx
80106501:	80 
80106502:	83 ca 80             	or     $0xffffff80,%edx
80106505:	88 14 c5 45 1f 11 80 	mov    %dl,-0x7feee0bb(,%eax,8)
8010650c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010650f:	8b 04 85 a8 b0 10 80 	mov    -0x7fef4f58(,%eax,4),%eax
80106516:	c1 e8 10             	shr    $0x10,%eax
80106519:	89 c2                	mov    %eax,%edx
8010651b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010651e:	66 89 14 c5 46 1f 11 	mov    %dx,-0x7feee0ba(,%eax,8)
80106525:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106526:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010652a:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106531:	0f 8e 30 ff ff ff    	jle    80106467 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106537:	a1 a8 b1 10 80       	mov    0x8010b1a8,%eax
8010653c:	66 a3 40 21 11 80    	mov    %ax,0x80112140
80106542:	66 c7 05 42 21 11 80 	movw   $0x8,0x80112142
80106549:	08 00 
8010654b:	0f b6 05 44 21 11 80 	movzbl 0x80112144,%eax
80106552:	83 e0 e0             	and    $0xffffffe0,%eax
80106555:	a2 44 21 11 80       	mov    %al,0x80112144
8010655a:	0f b6 05 44 21 11 80 	movzbl 0x80112144,%eax
80106561:	83 e0 1f             	and    $0x1f,%eax
80106564:	a2 44 21 11 80       	mov    %al,0x80112144
80106569:	0f b6 05 45 21 11 80 	movzbl 0x80112145,%eax
80106570:	83 c8 0f             	or     $0xf,%eax
80106573:	a2 45 21 11 80       	mov    %al,0x80112145
80106578:	0f b6 05 45 21 11 80 	movzbl 0x80112145,%eax
8010657f:	83 e0 ef             	and    $0xffffffef,%eax
80106582:	a2 45 21 11 80       	mov    %al,0x80112145
80106587:	0f b6 05 45 21 11 80 	movzbl 0x80112145,%eax
8010658e:	83 c8 60             	or     $0x60,%eax
80106591:	a2 45 21 11 80       	mov    %al,0x80112145
80106596:	0f b6 05 45 21 11 80 	movzbl 0x80112145,%eax
8010659d:	83 c8 80             	or     $0xffffff80,%eax
801065a0:	a2 45 21 11 80       	mov    %al,0x80112145
801065a5:	a1 a8 b1 10 80       	mov    0x8010b1a8,%eax
801065aa:	c1 e8 10             	shr    $0x10,%eax
801065ad:	66 a3 46 21 11 80    	mov    %ax,0x80112146
  
  initlock(&tickslock, "time");
801065b3:	83 ec 08             	sub    $0x8,%esp
801065b6:	68 b0 87 10 80       	push   $0x801087b0
801065bb:	68 00 1f 11 80       	push   $0x80111f00
801065c0:	e8 10 e5 ff ff       	call   80104ad5 <initlock>
801065c5:	83 c4 10             	add    $0x10,%esp
}
801065c8:	c9                   	leave  
801065c9:	c3                   	ret    

801065ca <idtinit>:

void
idtinit(void)
{
801065ca:	55                   	push   %ebp
801065cb:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
801065cd:	68 00 08 00 00       	push   $0x800
801065d2:	68 40 1f 11 80       	push   $0x80111f40
801065d7:	e8 3f fe ff ff       	call   8010641b <lidt>
801065dc:	83 c4 08             	add    $0x8,%esp
}
801065df:	c9                   	leave  
801065e0:	c3                   	ret    

801065e1 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801065e1:	55                   	push   %ebp
801065e2:	89 e5                	mov    %esp,%ebp
801065e4:	57                   	push   %edi
801065e5:	56                   	push   %esi
801065e6:	53                   	push   %ebx
801065e7:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
801065ea:	8b 45 08             	mov    0x8(%ebp),%eax
801065ed:	8b 40 30             	mov    0x30(%eax),%eax
801065f0:	83 f8 40             	cmp    $0x40,%eax
801065f3:	75 3f                	jne    80106634 <trap+0x53>
    if(proc->killed)
801065f5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065fb:	8b 40 24             	mov    0x24(%eax),%eax
801065fe:	85 c0                	test   %eax,%eax
80106600:	74 05                	je     80106607 <trap+0x26>
      exit();
80106602:	e8 e6 dd ff ff       	call   801043ed <exit>
    proc->tf = tf;
80106607:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010660d:	8b 55 08             	mov    0x8(%ebp),%edx
80106610:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106613:	e8 19 eb ff ff       	call   80105131 <syscall>
    if(proc->killed)
80106618:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010661e:	8b 40 24             	mov    0x24(%eax),%eax
80106621:	85 c0                	test   %eax,%eax
80106623:	74 0a                	je     8010662f <trap+0x4e>
      exit();
80106625:	e8 c3 dd ff ff       	call   801043ed <exit>
    return;
8010662a:	e9 15 02 00 00       	jmp    80106844 <trap+0x263>
8010662f:	e9 10 02 00 00       	jmp    80106844 <trap+0x263>
  }

  switch(tf->trapno){
80106634:	8b 45 08             	mov    0x8(%ebp),%eax
80106637:	8b 40 30             	mov    0x30(%eax),%eax
8010663a:	83 e8 20             	sub    $0x20,%eax
8010663d:	83 f8 1f             	cmp    $0x1f,%eax
80106640:	0f 87 c0 00 00 00    	ja     80106706 <trap+0x125>
80106646:	8b 04 85 58 88 10 80 	mov    -0x7fef77a8(,%eax,4),%eax
8010664d:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
8010664f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106655:	0f b6 00             	movzbl (%eax),%eax
80106658:	84 c0                	test   %al,%al
8010665a:	75 3d                	jne    80106699 <trap+0xb8>
      acquire(&tickslock);
8010665c:	83 ec 0c             	sub    $0xc,%esp
8010665f:	68 00 1f 11 80       	push   $0x80111f00
80106664:	e8 8d e4 ff ff       	call   80104af6 <acquire>
80106669:	83 c4 10             	add    $0x10,%esp
      ticks++;
8010666c:	a1 40 27 11 80       	mov    0x80112740,%eax
80106671:	83 c0 01             	add    $0x1,%eax
80106674:	a3 40 27 11 80       	mov    %eax,0x80112740
      wakeup(&ticks);
80106679:	83 ec 0c             	sub    $0xc,%esp
8010667c:	68 40 27 11 80       	push   $0x80112740
80106681:	e8 6b e2 ff ff       	call   801048f1 <wakeup>
80106686:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106689:	83 ec 0c             	sub    $0xc,%esp
8010668c:	68 00 1f 11 80       	push   $0x80111f00
80106691:	e8 c6 e4 ff ff       	call   80104b5c <release>
80106696:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106699:	e8 69 c8 ff ff       	call   80102f07 <lapiceoi>
    break;
8010669e:	e9 1d 01 00 00       	jmp    801067c0 <trap+0x1df>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801066a3:	e8 a3 c0 ff ff       	call   8010274b <ideintr>
    lapiceoi();
801066a8:	e8 5a c8 ff ff       	call   80102f07 <lapiceoi>
    break;
801066ad:	e9 0e 01 00 00       	jmp    801067c0 <trap+0x1df>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801066b2:	e8 74 c6 ff ff       	call   80102d2b <kbdintr>
    lapiceoi();
801066b7:	e8 4b c8 ff ff       	call   80102f07 <lapiceoi>
    break;
801066bc:	e9 ff 00 00 00       	jmp    801067c0 <trap+0x1df>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801066c1:	e8 5b 03 00 00       	call   80106a21 <uartintr>
    lapiceoi();
801066c6:	e8 3c c8 ff ff       	call   80102f07 <lapiceoi>
    break;
801066cb:	e9 f0 00 00 00       	jmp    801067c0 <trap+0x1df>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801066d0:	8b 45 08             	mov    0x8(%ebp),%eax
801066d3:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
801066d6:	8b 45 08             	mov    0x8(%ebp),%eax
801066d9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801066dd:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
801066e0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801066e6:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801066e9:	0f b6 c0             	movzbl %al,%eax
801066ec:	51                   	push   %ecx
801066ed:	52                   	push   %edx
801066ee:	50                   	push   %eax
801066ef:	68 b8 87 10 80       	push   $0x801087b8
801066f4:	e8 c6 9c ff ff       	call   801003bf <cprintf>
801066f9:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
801066fc:	e8 06 c8 ff ff       	call   80102f07 <lapiceoi>
    break;
80106701:	e9 ba 00 00 00       	jmp    801067c0 <trap+0x1df>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106706:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010670c:	85 c0                	test   %eax,%eax
8010670e:	74 11                	je     80106721 <trap+0x140>
80106710:	8b 45 08             	mov    0x8(%ebp),%eax
80106713:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106717:	0f b7 c0             	movzwl %ax,%eax
8010671a:	83 e0 03             	and    $0x3,%eax
8010671d:	85 c0                	test   %eax,%eax
8010671f:	75 3f                	jne    80106760 <trap+0x17f>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106721:	e8 1e fd ff ff       	call   80106444 <rcr2>
80106726:	8b 55 08             	mov    0x8(%ebp),%edx
80106729:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
8010672c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106733:	0f b6 12             	movzbl (%edx),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106736:	0f b6 ca             	movzbl %dl,%ecx
80106739:	8b 55 08             	mov    0x8(%ebp),%edx
8010673c:	8b 52 30             	mov    0x30(%edx),%edx
8010673f:	83 ec 0c             	sub    $0xc,%esp
80106742:	50                   	push   %eax
80106743:	53                   	push   %ebx
80106744:	51                   	push   %ecx
80106745:	52                   	push   %edx
80106746:	68 dc 87 10 80       	push   $0x801087dc
8010674b:	e8 6f 9c ff ff       	call   801003bf <cprintf>
80106750:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106753:	83 ec 0c             	sub    $0xc,%esp
80106756:	68 0e 88 10 80       	push   $0x8010880e
8010675b:	e8 fc 9d ff ff       	call   8010055c <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106760:	e8 df fc ff ff       	call   80106444 <rcr2>
80106765:	89 c2                	mov    %eax,%edx
80106767:	8b 45 08             	mov    0x8(%ebp),%eax
8010676a:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010676d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106773:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106776:	0f b6 f0             	movzbl %al,%esi
80106779:	8b 45 08             	mov    0x8(%ebp),%eax
8010677c:	8b 58 34             	mov    0x34(%eax),%ebx
8010677f:	8b 45 08             	mov    0x8(%ebp),%eax
80106782:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106785:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010678b:	83 c0 6c             	add    $0x6c,%eax
8010678e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106791:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106797:	8b 40 10             	mov    0x10(%eax),%eax
8010679a:	52                   	push   %edx
8010679b:	57                   	push   %edi
8010679c:	56                   	push   %esi
8010679d:	53                   	push   %ebx
8010679e:	51                   	push   %ecx
8010679f:	ff 75 e4             	pushl  -0x1c(%ebp)
801067a2:	50                   	push   %eax
801067a3:	68 14 88 10 80       	push   $0x80108814
801067a8:	e8 12 9c ff ff       	call   801003bf <cprintf>
801067ad:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
801067b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067b6:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801067bd:	eb 01                	jmp    801067c0 <trap+0x1df>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
801067bf:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801067c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067c6:	85 c0                	test   %eax,%eax
801067c8:	74 24                	je     801067ee <trap+0x20d>
801067ca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067d0:	8b 40 24             	mov    0x24(%eax),%eax
801067d3:	85 c0                	test   %eax,%eax
801067d5:	74 17                	je     801067ee <trap+0x20d>
801067d7:	8b 45 08             	mov    0x8(%ebp),%eax
801067da:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801067de:	0f b7 c0             	movzwl %ax,%eax
801067e1:	83 e0 03             	and    $0x3,%eax
801067e4:	83 f8 03             	cmp    $0x3,%eax
801067e7:	75 05                	jne    801067ee <trap+0x20d>
    exit();
801067e9:	e8 ff db ff ff       	call   801043ed <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
801067ee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067f4:	85 c0                	test   %eax,%eax
801067f6:	74 1e                	je     80106816 <trap+0x235>
801067f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067fe:	8b 40 0c             	mov    0xc(%eax),%eax
80106801:	83 f8 04             	cmp    $0x4,%eax
80106804:	75 10                	jne    80106816 <trap+0x235>
80106806:	8b 45 08             	mov    0x8(%ebp),%eax
80106809:	8b 40 30             	mov    0x30(%eax),%eax
8010680c:	83 f8 20             	cmp    $0x20,%eax
8010680f:	75 05                	jne    80106816 <trap+0x235>
    yield();
80106811:	e8 88 df ff ff       	call   8010479e <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106816:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010681c:	85 c0                	test   %eax,%eax
8010681e:	74 24                	je     80106844 <trap+0x263>
80106820:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106826:	8b 40 24             	mov    0x24(%eax),%eax
80106829:	85 c0                	test   %eax,%eax
8010682b:	74 17                	je     80106844 <trap+0x263>
8010682d:	8b 45 08             	mov    0x8(%ebp),%eax
80106830:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106834:	0f b7 c0             	movzwl %ax,%eax
80106837:	83 e0 03             	and    $0x3,%eax
8010683a:	83 f8 03             	cmp    $0x3,%eax
8010683d:	75 05                	jne    80106844 <trap+0x263>
    exit();
8010683f:	e8 a9 db ff ff       	call   801043ed <exit>
}
80106844:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106847:	5b                   	pop    %ebx
80106848:	5e                   	pop    %esi
80106849:	5f                   	pop    %edi
8010684a:	5d                   	pop    %ebp
8010684b:	c3                   	ret    

8010684c <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010684c:	55                   	push   %ebp
8010684d:	89 e5                	mov    %esp,%ebp
8010684f:	83 ec 14             	sub    $0x14,%esp
80106852:	8b 45 08             	mov    0x8(%ebp),%eax
80106855:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106859:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010685d:	89 c2                	mov    %eax,%edx
8010685f:	ec                   	in     (%dx),%al
80106860:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106863:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106867:	c9                   	leave  
80106868:	c3                   	ret    

80106869 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106869:	55                   	push   %ebp
8010686a:	89 e5                	mov    %esp,%ebp
8010686c:	83 ec 08             	sub    $0x8,%esp
8010686f:	8b 55 08             	mov    0x8(%ebp),%edx
80106872:	8b 45 0c             	mov    0xc(%ebp),%eax
80106875:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106879:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010687c:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106880:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106884:	ee                   	out    %al,(%dx)
}
80106885:	c9                   	leave  
80106886:	c3                   	ret    

80106887 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106887:	55                   	push   %ebp
80106888:	89 e5                	mov    %esp,%ebp
8010688a:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
8010688d:	6a 00                	push   $0x0
8010688f:	68 fa 03 00 00       	push   $0x3fa
80106894:	e8 d0 ff ff ff       	call   80106869 <outb>
80106899:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
8010689c:	68 80 00 00 00       	push   $0x80
801068a1:	68 fb 03 00 00       	push   $0x3fb
801068a6:	e8 be ff ff ff       	call   80106869 <outb>
801068ab:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
801068ae:	6a 0c                	push   $0xc
801068b0:	68 f8 03 00 00       	push   $0x3f8
801068b5:	e8 af ff ff ff       	call   80106869 <outb>
801068ba:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
801068bd:	6a 00                	push   $0x0
801068bf:	68 f9 03 00 00       	push   $0x3f9
801068c4:	e8 a0 ff ff ff       	call   80106869 <outb>
801068c9:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801068cc:	6a 03                	push   $0x3
801068ce:	68 fb 03 00 00       	push   $0x3fb
801068d3:	e8 91 ff ff ff       	call   80106869 <outb>
801068d8:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
801068db:	6a 00                	push   $0x0
801068dd:	68 fc 03 00 00       	push   $0x3fc
801068e2:	e8 82 ff ff ff       	call   80106869 <outb>
801068e7:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
801068ea:	6a 01                	push   $0x1
801068ec:	68 f9 03 00 00       	push   $0x3f9
801068f1:	e8 73 ff ff ff       	call   80106869 <outb>
801068f6:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801068f9:	68 fd 03 00 00       	push   $0x3fd
801068fe:	e8 49 ff ff ff       	call   8010684c <inb>
80106903:	83 c4 04             	add    $0x4,%esp
80106906:	3c ff                	cmp    $0xff,%al
80106908:	75 02                	jne    8010690c <uartinit+0x85>
    return;
8010690a:	eb 6c                	jmp    80106978 <uartinit+0xf1>
  uart = 1;
8010690c:	c7 05 6c b6 10 80 01 	movl   $0x1,0x8010b66c
80106913:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106916:	68 fa 03 00 00       	push   $0x3fa
8010691b:	e8 2c ff ff ff       	call   8010684c <inb>
80106920:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80106923:	68 f8 03 00 00       	push   $0x3f8
80106928:	e8 1f ff ff ff       	call   8010684c <inb>
8010692d:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80106930:	83 ec 0c             	sub    $0xc,%esp
80106933:	6a 04                	push   $0x4
80106935:	e8 48 d1 ff ff       	call   80103a82 <picenable>
8010693a:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
8010693d:	83 ec 08             	sub    $0x8,%esp
80106940:	6a 00                	push   $0x0
80106942:	6a 04                	push   $0x4
80106944:	e8 9e c0 ff ff       	call   801029e7 <ioapicenable>
80106949:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010694c:	c7 45 f4 d8 88 10 80 	movl   $0x801088d8,-0xc(%ebp)
80106953:	eb 19                	jmp    8010696e <uartinit+0xe7>
    uartputc(*p);
80106955:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106958:	0f b6 00             	movzbl (%eax),%eax
8010695b:	0f be c0             	movsbl %al,%eax
8010695e:	83 ec 0c             	sub    $0xc,%esp
80106961:	50                   	push   %eax
80106962:	e8 13 00 00 00       	call   8010697a <uartputc>
80106967:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010696a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010696e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106971:	0f b6 00             	movzbl (%eax),%eax
80106974:	84 c0                	test   %al,%al
80106976:	75 dd                	jne    80106955 <uartinit+0xce>
    uartputc(*p);
}
80106978:	c9                   	leave  
80106979:	c3                   	ret    

8010697a <uartputc>:

void
uartputc(int c)
{
8010697a:	55                   	push   %ebp
8010697b:	89 e5                	mov    %esp,%ebp
8010697d:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80106980:	a1 6c b6 10 80       	mov    0x8010b66c,%eax
80106985:	85 c0                	test   %eax,%eax
80106987:	75 02                	jne    8010698b <uartputc+0x11>
    return;
80106989:	eb 51                	jmp    801069dc <uartputc+0x62>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010698b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106992:	eb 11                	jmp    801069a5 <uartputc+0x2b>
    microdelay(10);
80106994:	83 ec 0c             	sub    $0xc,%esp
80106997:	6a 0a                	push   $0xa
80106999:	e8 83 c5 ff ff       	call   80102f21 <microdelay>
8010699e:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801069a1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801069a5:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801069a9:	7f 1a                	jg     801069c5 <uartputc+0x4b>
801069ab:	83 ec 0c             	sub    $0xc,%esp
801069ae:	68 fd 03 00 00       	push   $0x3fd
801069b3:	e8 94 fe ff ff       	call   8010684c <inb>
801069b8:	83 c4 10             	add    $0x10,%esp
801069bb:	0f b6 c0             	movzbl %al,%eax
801069be:	83 e0 20             	and    $0x20,%eax
801069c1:	85 c0                	test   %eax,%eax
801069c3:	74 cf                	je     80106994 <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
801069c5:	8b 45 08             	mov    0x8(%ebp),%eax
801069c8:	0f b6 c0             	movzbl %al,%eax
801069cb:	83 ec 08             	sub    $0x8,%esp
801069ce:	50                   	push   %eax
801069cf:	68 f8 03 00 00       	push   $0x3f8
801069d4:	e8 90 fe ff ff       	call   80106869 <outb>
801069d9:	83 c4 10             	add    $0x10,%esp
}
801069dc:	c9                   	leave  
801069dd:	c3                   	ret    

801069de <uartgetc>:

static int
uartgetc(void)
{
801069de:	55                   	push   %ebp
801069df:	89 e5                	mov    %esp,%ebp
  if(!uart)
801069e1:	a1 6c b6 10 80       	mov    0x8010b66c,%eax
801069e6:	85 c0                	test   %eax,%eax
801069e8:	75 07                	jne    801069f1 <uartgetc+0x13>
    return -1;
801069ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069ef:	eb 2e                	jmp    80106a1f <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
801069f1:	68 fd 03 00 00       	push   $0x3fd
801069f6:	e8 51 fe ff ff       	call   8010684c <inb>
801069fb:	83 c4 04             	add    $0x4,%esp
801069fe:	0f b6 c0             	movzbl %al,%eax
80106a01:	83 e0 01             	and    $0x1,%eax
80106a04:	85 c0                	test   %eax,%eax
80106a06:	75 07                	jne    80106a0f <uartgetc+0x31>
    return -1;
80106a08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a0d:	eb 10                	jmp    80106a1f <uartgetc+0x41>
  return inb(COM1+0);
80106a0f:	68 f8 03 00 00       	push   $0x3f8
80106a14:	e8 33 fe ff ff       	call   8010684c <inb>
80106a19:	83 c4 04             	add    $0x4,%esp
80106a1c:	0f b6 c0             	movzbl %al,%eax
}
80106a1f:	c9                   	leave  
80106a20:	c3                   	ret    

80106a21 <uartintr>:

void
uartintr(void)
{
80106a21:	55                   	push   %ebp
80106a22:	89 e5                	mov    %esp,%ebp
80106a24:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80106a27:	83 ec 0c             	sub    $0xc,%esp
80106a2a:	68 de 69 10 80       	push   $0x801069de
80106a2f:	e8 9e 9d ff ff       	call   801007d2 <consoleintr>
80106a34:	83 c4 10             	add    $0x10,%esp
}
80106a37:	c9                   	leave  
80106a38:	c3                   	ret    

80106a39 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106a39:	6a 00                	push   $0x0
  pushl $0
80106a3b:	6a 00                	push   $0x0
  jmp alltraps
80106a3d:	e9 ae f9 ff ff       	jmp    801063f0 <alltraps>

80106a42 <vector1>:
.globl vector1
vector1:
  pushl $0
80106a42:	6a 00                	push   $0x0
  pushl $1
80106a44:	6a 01                	push   $0x1
  jmp alltraps
80106a46:	e9 a5 f9 ff ff       	jmp    801063f0 <alltraps>

80106a4b <vector2>:
.globl vector2
vector2:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $2
80106a4d:	6a 02                	push   $0x2
  jmp alltraps
80106a4f:	e9 9c f9 ff ff       	jmp    801063f0 <alltraps>

80106a54 <vector3>:
.globl vector3
vector3:
  pushl $0
80106a54:	6a 00                	push   $0x0
  pushl $3
80106a56:	6a 03                	push   $0x3
  jmp alltraps
80106a58:	e9 93 f9 ff ff       	jmp    801063f0 <alltraps>

80106a5d <vector4>:
.globl vector4
vector4:
  pushl $0
80106a5d:	6a 00                	push   $0x0
  pushl $4
80106a5f:	6a 04                	push   $0x4
  jmp alltraps
80106a61:	e9 8a f9 ff ff       	jmp    801063f0 <alltraps>

80106a66 <vector5>:
.globl vector5
vector5:
  pushl $0
80106a66:	6a 00                	push   $0x0
  pushl $5
80106a68:	6a 05                	push   $0x5
  jmp alltraps
80106a6a:	e9 81 f9 ff ff       	jmp    801063f0 <alltraps>

80106a6f <vector6>:
.globl vector6
vector6:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $6
80106a71:	6a 06                	push   $0x6
  jmp alltraps
80106a73:	e9 78 f9 ff ff       	jmp    801063f0 <alltraps>

80106a78 <vector7>:
.globl vector7
vector7:
  pushl $0
80106a78:	6a 00                	push   $0x0
  pushl $7
80106a7a:	6a 07                	push   $0x7
  jmp alltraps
80106a7c:	e9 6f f9 ff ff       	jmp    801063f0 <alltraps>

80106a81 <vector8>:
.globl vector8
vector8:
  pushl $8
80106a81:	6a 08                	push   $0x8
  jmp alltraps
80106a83:	e9 68 f9 ff ff       	jmp    801063f0 <alltraps>

80106a88 <vector9>:
.globl vector9
vector9:
  pushl $0
80106a88:	6a 00                	push   $0x0
  pushl $9
80106a8a:	6a 09                	push   $0x9
  jmp alltraps
80106a8c:	e9 5f f9 ff ff       	jmp    801063f0 <alltraps>

80106a91 <vector10>:
.globl vector10
vector10:
  pushl $10
80106a91:	6a 0a                	push   $0xa
  jmp alltraps
80106a93:	e9 58 f9 ff ff       	jmp    801063f0 <alltraps>

80106a98 <vector11>:
.globl vector11
vector11:
  pushl $11
80106a98:	6a 0b                	push   $0xb
  jmp alltraps
80106a9a:	e9 51 f9 ff ff       	jmp    801063f0 <alltraps>

80106a9f <vector12>:
.globl vector12
vector12:
  pushl $12
80106a9f:	6a 0c                	push   $0xc
  jmp alltraps
80106aa1:	e9 4a f9 ff ff       	jmp    801063f0 <alltraps>

80106aa6 <vector13>:
.globl vector13
vector13:
  pushl $13
80106aa6:	6a 0d                	push   $0xd
  jmp alltraps
80106aa8:	e9 43 f9 ff ff       	jmp    801063f0 <alltraps>

80106aad <vector14>:
.globl vector14
vector14:
  pushl $14
80106aad:	6a 0e                	push   $0xe
  jmp alltraps
80106aaf:	e9 3c f9 ff ff       	jmp    801063f0 <alltraps>

80106ab4 <vector15>:
.globl vector15
vector15:
  pushl $0
80106ab4:	6a 00                	push   $0x0
  pushl $15
80106ab6:	6a 0f                	push   $0xf
  jmp alltraps
80106ab8:	e9 33 f9 ff ff       	jmp    801063f0 <alltraps>

80106abd <vector16>:
.globl vector16
vector16:
  pushl $0
80106abd:	6a 00                	push   $0x0
  pushl $16
80106abf:	6a 10                	push   $0x10
  jmp alltraps
80106ac1:	e9 2a f9 ff ff       	jmp    801063f0 <alltraps>

80106ac6 <vector17>:
.globl vector17
vector17:
  pushl $17
80106ac6:	6a 11                	push   $0x11
  jmp alltraps
80106ac8:	e9 23 f9 ff ff       	jmp    801063f0 <alltraps>

80106acd <vector18>:
.globl vector18
vector18:
  pushl $0
80106acd:	6a 00                	push   $0x0
  pushl $18
80106acf:	6a 12                	push   $0x12
  jmp alltraps
80106ad1:	e9 1a f9 ff ff       	jmp    801063f0 <alltraps>

80106ad6 <vector19>:
.globl vector19
vector19:
  pushl $0
80106ad6:	6a 00                	push   $0x0
  pushl $19
80106ad8:	6a 13                	push   $0x13
  jmp alltraps
80106ada:	e9 11 f9 ff ff       	jmp    801063f0 <alltraps>

80106adf <vector20>:
.globl vector20
vector20:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $20
80106ae1:	6a 14                	push   $0x14
  jmp alltraps
80106ae3:	e9 08 f9 ff ff       	jmp    801063f0 <alltraps>

80106ae8 <vector21>:
.globl vector21
vector21:
  pushl $0
80106ae8:	6a 00                	push   $0x0
  pushl $21
80106aea:	6a 15                	push   $0x15
  jmp alltraps
80106aec:	e9 ff f8 ff ff       	jmp    801063f0 <alltraps>

80106af1 <vector22>:
.globl vector22
vector22:
  pushl $0
80106af1:	6a 00                	push   $0x0
  pushl $22
80106af3:	6a 16                	push   $0x16
  jmp alltraps
80106af5:	e9 f6 f8 ff ff       	jmp    801063f0 <alltraps>

80106afa <vector23>:
.globl vector23
vector23:
  pushl $0
80106afa:	6a 00                	push   $0x0
  pushl $23
80106afc:	6a 17                	push   $0x17
  jmp alltraps
80106afe:	e9 ed f8 ff ff       	jmp    801063f0 <alltraps>

80106b03 <vector24>:
.globl vector24
vector24:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $24
80106b05:	6a 18                	push   $0x18
  jmp alltraps
80106b07:	e9 e4 f8 ff ff       	jmp    801063f0 <alltraps>

80106b0c <vector25>:
.globl vector25
vector25:
  pushl $0
80106b0c:	6a 00                	push   $0x0
  pushl $25
80106b0e:	6a 19                	push   $0x19
  jmp alltraps
80106b10:	e9 db f8 ff ff       	jmp    801063f0 <alltraps>

80106b15 <vector26>:
.globl vector26
vector26:
  pushl $0
80106b15:	6a 00                	push   $0x0
  pushl $26
80106b17:	6a 1a                	push   $0x1a
  jmp alltraps
80106b19:	e9 d2 f8 ff ff       	jmp    801063f0 <alltraps>

80106b1e <vector27>:
.globl vector27
vector27:
  pushl $0
80106b1e:	6a 00                	push   $0x0
  pushl $27
80106b20:	6a 1b                	push   $0x1b
  jmp alltraps
80106b22:	e9 c9 f8 ff ff       	jmp    801063f0 <alltraps>

80106b27 <vector28>:
.globl vector28
vector28:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $28
80106b29:	6a 1c                	push   $0x1c
  jmp alltraps
80106b2b:	e9 c0 f8 ff ff       	jmp    801063f0 <alltraps>

80106b30 <vector29>:
.globl vector29
vector29:
  pushl $0
80106b30:	6a 00                	push   $0x0
  pushl $29
80106b32:	6a 1d                	push   $0x1d
  jmp alltraps
80106b34:	e9 b7 f8 ff ff       	jmp    801063f0 <alltraps>

80106b39 <vector30>:
.globl vector30
vector30:
  pushl $0
80106b39:	6a 00                	push   $0x0
  pushl $30
80106b3b:	6a 1e                	push   $0x1e
  jmp alltraps
80106b3d:	e9 ae f8 ff ff       	jmp    801063f0 <alltraps>

80106b42 <vector31>:
.globl vector31
vector31:
  pushl $0
80106b42:	6a 00                	push   $0x0
  pushl $31
80106b44:	6a 1f                	push   $0x1f
  jmp alltraps
80106b46:	e9 a5 f8 ff ff       	jmp    801063f0 <alltraps>

80106b4b <vector32>:
.globl vector32
vector32:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $32
80106b4d:	6a 20                	push   $0x20
  jmp alltraps
80106b4f:	e9 9c f8 ff ff       	jmp    801063f0 <alltraps>

80106b54 <vector33>:
.globl vector33
vector33:
  pushl $0
80106b54:	6a 00                	push   $0x0
  pushl $33
80106b56:	6a 21                	push   $0x21
  jmp alltraps
80106b58:	e9 93 f8 ff ff       	jmp    801063f0 <alltraps>

80106b5d <vector34>:
.globl vector34
vector34:
  pushl $0
80106b5d:	6a 00                	push   $0x0
  pushl $34
80106b5f:	6a 22                	push   $0x22
  jmp alltraps
80106b61:	e9 8a f8 ff ff       	jmp    801063f0 <alltraps>

80106b66 <vector35>:
.globl vector35
vector35:
  pushl $0
80106b66:	6a 00                	push   $0x0
  pushl $35
80106b68:	6a 23                	push   $0x23
  jmp alltraps
80106b6a:	e9 81 f8 ff ff       	jmp    801063f0 <alltraps>

80106b6f <vector36>:
.globl vector36
vector36:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $36
80106b71:	6a 24                	push   $0x24
  jmp alltraps
80106b73:	e9 78 f8 ff ff       	jmp    801063f0 <alltraps>

80106b78 <vector37>:
.globl vector37
vector37:
  pushl $0
80106b78:	6a 00                	push   $0x0
  pushl $37
80106b7a:	6a 25                	push   $0x25
  jmp alltraps
80106b7c:	e9 6f f8 ff ff       	jmp    801063f0 <alltraps>

80106b81 <vector38>:
.globl vector38
vector38:
  pushl $0
80106b81:	6a 00                	push   $0x0
  pushl $38
80106b83:	6a 26                	push   $0x26
  jmp alltraps
80106b85:	e9 66 f8 ff ff       	jmp    801063f0 <alltraps>

80106b8a <vector39>:
.globl vector39
vector39:
  pushl $0
80106b8a:	6a 00                	push   $0x0
  pushl $39
80106b8c:	6a 27                	push   $0x27
  jmp alltraps
80106b8e:	e9 5d f8 ff ff       	jmp    801063f0 <alltraps>

80106b93 <vector40>:
.globl vector40
vector40:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $40
80106b95:	6a 28                	push   $0x28
  jmp alltraps
80106b97:	e9 54 f8 ff ff       	jmp    801063f0 <alltraps>

80106b9c <vector41>:
.globl vector41
vector41:
  pushl $0
80106b9c:	6a 00                	push   $0x0
  pushl $41
80106b9e:	6a 29                	push   $0x29
  jmp alltraps
80106ba0:	e9 4b f8 ff ff       	jmp    801063f0 <alltraps>

80106ba5 <vector42>:
.globl vector42
vector42:
  pushl $0
80106ba5:	6a 00                	push   $0x0
  pushl $42
80106ba7:	6a 2a                	push   $0x2a
  jmp alltraps
80106ba9:	e9 42 f8 ff ff       	jmp    801063f0 <alltraps>

80106bae <vector43>:
.globl vector43
vector43:
  pushl $0
80106bae:	6a 00                	push   $0x0
  pushl $43
80106bb0:	6a 2b                	push   $0x2b
  jmp alltraps
80106bb2:	e9 39 f8 ff ff       	jmp    801063f0 <alltraps>

80106bb7 <vector44>:
.globl vector44
vector44:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $44
80106bb9:	6a 2c                	push   $0x2c
  jmp alltraps
80106bbb:	e9 30 f8 ff ff       	jmp    801063f0 <alltraps>

80106bc0 <vector45>:
.globl vector45
vector45:
  pushl $0
80106bc0:	6a 00                	push   $0x0
  pushl $45
80106bc2:	6a 2d                	push   $0x2d
  jmp alltraps
80106bc4:	e9 27 f8 ff ff       	jmp    801063f0 <alltraps>

80106bc9 <vector46>:
.globl vector46
vector46:
  pushl $0
80106bc9:	6a 00                	push   $0x0
  pushl $46
80106bcb:	6a 2e                	push   $0x2e
  jmp alltraps
80106bcd:	e9 1e f8 ff ff       	jmp    801063f0 <alltraps>

80106bd2 <vector47>:
.globl vector47
vector47:
  pushl $0
80106bd2:	6a 00                	push   $0x0
  pushl $47
80106bd4:	6a 2f                	push   $0x2f
  jmp alltraps
80106bd6:	e9 15 f8 ff ff       	jmp    801063f0 <alltraps>

80106bdb <vector48>:
.globl vector48
vector48:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $48
80106bdd:	6a 30                	push   $0x30
  jmp alltraps
80106bdf:	e9 0c f8 ff ff       	jmp    801063f0 <alltraps>

80106be4 <vector49>:
.globl vector49
vector49:
  pushl $0
80106be4:	6a 00                	push   $0x0
  pushl $49
80106be6:	6a 31                	push   $0x31
  jmp alltraps
80106be8:	e9 03 f8 ff ff       	jmp    801063f0 <alltraps>

80106bed <vector50>:
.globl vector50
vector50:
  pushl $0
80106bed:	6a 00                	push   $0x0
  pushl $50
80106bef:	6a 32                	push   $0x32
  jmp alltraps
80106bf1:	e9 fa f7 ff ff       	jmp    801063f0 <alltraps>

80106bf6 <vector51>:
.globl vector51
vector51:
  pushl $0
80106bf6:	6a 00                	push   $0x0
  pushl $51
80106bf8:	6a 33                	push   $0x33
  jmp alltraps
80106bfa:	e9 f1 f7 ff ff       	jmp    801063f0 <alltraps>

80106bff <vector52>:
.globl vector52
vector52:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $52
80106c01:	6a 34                	push   $0x34
  jmp alltraps
80106c03:	e9 e8 f7 ff ff       	jmp    801063f0 <alltraps>

80106c08 <vector53>:
.globl vector53
vector53:
  pushl $0
80106c08:	6a 00                	push   $0x0
  pushl $53
80106c0a:	6a 35                	push   $0x35
  jmp alltraps
80106c0c:	e9 df f7 ff ff       	jmp    801063f0 <alltraps>

80106c11 <vector54>:
.globl vector54
vector54:
  pushl $0
80106c11:	6a 00                	push   $0x0
  pushl $54
80106c13:	6a 36                	push   $0x36
  jmp alltraps
80106c15:	e9 d6 f7 ff ff       	jmp    801063f0 <alltraps>

80106c1a <vector55>:
.globl vector55
vector55:
  pushl $0
80106c1a:	6a 00                	push   $0x0
  pushl $55
80106c1c:	6a 37                	push   $0x37
  jmp alltraps
80106c1e:	e9 cd f7 ff ff       	jmp    801063f0 <alltraps>

80106c23 <vector56>:
.globl vector56
vector56:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $56
80106c25:	6a 38                	push   $0x38
  jmp alltraps
80106c27:	e9 c4 f7 ff ff       	jmp    801063f0 <alltraps>

80106c2c <vector57>:
.globl vector57
vector57:
  pushl $0
80106c2c:	6a 00                	push   $0x0
  pushl $57
80106c2e:	6a 39                	push   $0x39
  jmp alltraps
80106c30:	e9 bb f7 ff ff       	jmp    801063f0 <alltraps>

80106c35 <vector58>:
.globl vector58
vector58:
  pushl $0
80106c35:	6a 00                	push   $0x0
  pushl $58
80106c37:	6a 3a                	push   $0x3a
  jmp alltraps
80106c39:	e9 b2 f7 ff ff       	jmp    801063f0 <alltraps>

80106c3e <vector59>:
.globl vector59
vector59:
  pushl $0
80106c3e:	6a 00                	push   $0x0
  pushl $59
80106c40:	6a 3b                	push   $0x3b
  jmp alltraps
80106c42:	e9 a9 f7 ff ff       	jmp    801063f0 <alltraps>

80106c47 <vector60>:
.globl vector60
vector60:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $60
80106c49:	6a 3c                	push   $0x3c
  jmp alltraps
80106c4b:	e9 a0 f7 ff ff       	jmp    801063f0 <alltraps>

80106c50 <vector61>:
.globl vector61
vector61:
  pushl $0
80106c50:	6a 00                	push   $0x0
  pushl $61
80106c52:	6a 3d                	push   $0x3d
  jmp alltraps
80106c54:	e9 97 f7 ff ff       	jmp    801063f0 <alltraps>

80106c59 <vector62>:
.globl vector62
vector62:
  pushl $0
80106c59:	6a 00                	push   $0x0
  pushl $62
80106c5b:	6a 3e                	push   $0x3e
  jmp alltraps
80106c5d:	e9 8e f7 ff ff       	jmp    801063f0 <alltraps>

80106c62 <vector63>:
.globl vector63
vector63:
  pushl $0
80106c62:	6a 00                	push   $0x0
  pushl $63
80106c64:	6a 3f                	push   $0x3f
  jmp alltraps
80106c66:	e9 85 f7 ff ff       	jmp    801063f0 <alltraps>

80106c6b <vector64>:
.globl vector64
vector64:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $64
80106c6d:	6a 40                	push   $0x40
  jmp alltraps
80106c6f:	e9 7c f7 ff ff       	jmp    801063f0 <alltraps>

80106c74 <vector65>:
.globl vector65
vector65:
  pushl $0
80106c74:	6a 00                	push   $0x0
  pushl $65
80106c76:	6a 41                	push   $0x41
  jmp alltraps
80106c78:	e9 73 f7 ff ff       	jmp    801063f0 <alltraps>

80106c7d <vector66>:
.globl vector66
vector66:
  pushl $0
80106c7d:	6a 00                	push   $0x0
  pushl $66
80106c7f:	6a 42                	push   $0x42
  jmp alltraps
80106c81:	e9 6a f7 ff ff       	jmp    801063f0 <alltraps>

80106c86 <vector67>:
.globl vector67
vector67:
  pushl $0
80106c86:	6a 00                	push   $0x0
  pushl $67
80106c88:	6a 43                	push   $0x43
  jmp alltraps
80106c8a:	e9 61 f7 ff ff       	jmp    801063f0 <alltraps>

80106c8f <vector68>:
.globl vector68
vector68:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $68
80106c91:	6a 44                	push   $0x44
  jmp alltraps
80106c93:	e9 58 f7 ff ff       	jmp    801063f0 <alltraps>

80106c98 <vector69>:
.globl vector69
vector69:
  pushl $0
80106c98:	6a 00                	push   $0x0
  pushl $69
80106c9a:	6a 45                	push   $0x45
  jmp alltraps
80106c9c:	e9 4f f7 ff ff       	jmp    801063f0 <alltraps>

80106ca1 <vector70>:
.globl vector70
vector70:
  pushl $0
80106ca1:	6a 00                	push   $0x0
  pushl $70
80106ca3:	6a 46                	push   $0x46
  jmp alltraps
80106ca5:	e9 46 f7 ff ff       	jmp    801063f0 <alltraps>

80106caa <vector71>:
.globl vector71
vector71:
  pushl $0
80106caa:	6a 00                	push   $0x0
  pushl $71
80106cac:	6a 47                	push   $0x47
  jmp alltraps
80106cae:	e9 3d f7 ff ff       	jmp    801063f0 <alltraps>

80106cb3 <vector72>:
.globl vector72
vector72:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $72
80106cb5:	6a 48                	push   $0x48
  jmp alltraps
80106cb7:	e9 34 f7 ff ff       	jmp    801063f0 <alltraps>

80106cbc <vector73>:
.globl vector73
vector73:
  pushl $0
80106cbc:	6a 00                	push   $0x0
  pushl $73
80106cbe:	6a 49                	push   $0x49
  jmp alltraps
80106cc0:	e9 2b f7 ff ff       	jmp    801063f0 <alltraps>

80106cc5 <vector74>:
.globl vector74
vector74:
  pushl $0
80106cc5:	6a 00                	push   $0x0
  pushl $74
80106cc7:	6a 4a                	push   $0x4a
  jmp alltraps
80106cc9:	e9 22 f7 ff ff       	jmp    801063f0 <alltraps>

80106cce <vector75>:
.globl vector75
vector75:
  pushl $0
80106cce:	6a 00                	push   $0x0
  pushl $75
80106cd0:	6a 4b                	push   $0x4b
  jmp alltraps
80106cd2:	e9 19 f7 ff ff       	jmp    801063f0 <alltraps>

80106cd7 <vector76>:
.globl vector76
vector76:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $76
80106cd9:	6a 4c                	push   $0x4c
  jmp alltraps
80106cdb:	e9 10 f7 ff ff       	jmp    801063f0 <alltraps>

80106ce0 <vector77>:
.globl vector77
vector77:
  pushl $0
80106ce0:	6a 00                	push   $0x0
  pushl $77
80106ce2:	6a 4d                	push   $0x4d
  jmp alltraps
80106ce4:	e9 07 f7 ff ff       	jmp    801063f0 <alltraps>

80106ce9 <vector78>:
.globl vector78
vector78:
  pushl $0
80106ce9:	6a 00                	push   $0x0
  pushl $78
80106ceb:	6a 4e                	push   $0x4e
  jmp alltraps
80106ced:	e9 fe f6 ff ff       	jmp    801063f0 <alltraps>

80106cf2 <vector79>:
.globl vector79
vector79:
  pushl $0
80106cf2:	6a 00                	push   $0x0
  pushl $79
80106cf4:	6a 4f                	push   $0x4f
  jmp alltraps
80106cf6:	e9 f5 f6 ff ff       	jmp    801063f0 <alltraps>

80106cfb <vector80>:
.globl vector80
vector80:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $80
80106cfd:	6a 50                	push   $0x50
  jmp alltraps
80106cff:	e9 ec f6 ff ff       	jmp    801063f0 <alltraps>

80106d04 <vector81>:
.globl vector81
vector81:
  pushl $0
80106d04:	6a 00                	push   $0x0
  pushl $81
80106d06:	6a 51                	push   $0x51
  jmp alltraps
80106d08:	e9 e3 f6 ff ff       	jmp    801063f0 <alltraps>

80106d0d <vector82>:
.globl vector82
vector82:
  pushl $0
80106d0d:	6a 00                	push   $0x0
  pushl $82
80106d0f:	6a 52                	push   $0x52
  jmp alltraps
80106d11:	e9 da f6 ff ff       	jmp    801063f0 <alltraps>

80106d16 <vector83>:
.globl vector83
vector83:
  pushl $0
80106d16:	6a 00                	push   $0x0
  pushl $83
80106d18:	6a 53                	push   $0x53
  jmp alltraps
80106d1a:	e9 d1 f6 ff ff       	jmp    801063f0 <alltraps>

80106d1f <vector84>:
.globl vector84
vector84:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $84
80106d21:	6a 54                	push   $0x54
  jmp alltraps
80106d23:	e9 c8 f6 ff ff       	jmp    801063f0 <alltraps>

80106d28 <vector85>:
.globl vector85
vector85:
  pushl $0
80106d28:	6a 00                	push   $0x0
  pushl $85
80106d2a:	6a 55                	push   $0x55
  jmp alltraps
80106d2c:	e9 bf f6 ff ff       	jmp    801063f0 <alltraps>

80106d31 <vector86>:
.globl vector86
vector86:
  pushl $0
80106d31:	6a 00                	push   $0x0
  pushl $86
80106d33:	6a 56                	push   $0x56
  jmp alltraps
80106d35:	e9 b6 f6 ff ff       	jmp    801063f0 <alltraps>

80106d3a <vector87>:
.globl vector87
vector87:
  pushl $0
80106d3a:	6a 00                	push   $0x0
  pushl $87
80106d3c:	6a 57                	push   $0x57
  jmp alltraps
80106d3e:	e9 ad f6 ff ff       	jmp    801063f0 <alltraps>

80106d43 <vector88>:
.globl vector88
vector88:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $88
80106d45:	6a 58                	push   $0x58
  jmp alltraps
80106d47:	e9 a4 f6 ff ff       	jmp    801063f0 <alltraps>

80106d4c <vector89>:
.globl vector89
vector89:
  pushl $0
80106d4c:	6a 00                	push   $0x0
  pushl $89
80106d4e:	6a 59                	push   $0x59
  jmp alltraps
80106d50:	e9 9b f6 ff ff       	jmp    801063f0 <alltraps>

80106d55 <vector90>:
.globl vector90
vector90:
  pushl $0
80106d55:	6a 00                	push   $0x0
  pushl $90
80106d57:	6a 5a                	push   $0x5a
  jmp alltraps
80106d59:	e9 92 f6 ff ff       	jmp    801063f0 <alltraps>

80106d5e <vector91>:
.globl vector91
vector91:
  pushl $0
80106d5e:	6a 00                	push   $0x0
  pushl $91
80106d60:	6a 5b                	push   $0x5b
  jmp alltraps
80106d62:	e9 89 f6 ff ff       	jmp    801063f0 <alltraps>

80106d67 <vector92>:
.globl vector92
vector92:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $92
80106d69:	6a 5c                	push   $0x5c
  jmp alltraps
80106d6b:	e9 80 f6 ff ff       	jmp    801063f0 <alltraps>

80106d70 <vector93>:
.globl vector93
vector93:
  pushl $0
80106d70:	6a 00                	push   $0x0
  pushl $93
80106d72:	6a 5d                	push   $0x5d
  jmp alltraps
80106d74:	e9 77 f6 ff ff       	jmp    801063f0 <alltraps>

80106d79 <vector94>:
.globl vector94
vector94:
  pushl $0
80106d79:	6a 00                	push   $0x0
  pushl $94
80106d7b:	6a 5e                	push   $0x5e
  jmp alltraps
80106d7d:	e9 6e f6 ff ff       	jmp    801063f0 <alltraps>

80106d82 <vector95>:
.globl vector95
vector95:
  pushl $0
80106d82:	6a 00                	push   $0x0
  pushl $95
80106d84:	6a 5f                	push   $0x5f
  jmp alltraps
80106d86:	e9 65 f6 ff ff       	jmp    801063f0 <alltraps>

80106d8b <vector96>:
.globl vector96
vector96:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $96
80106d8d:	6a 60                	push   $0x60
  jmp alltraps
80106d8f:	e9 5c f6 ff ff       	jmp    801063f0 <alltraps>

80106d94 <vector97>:
.globl vector97
vector97:
  pushl $0
80106d94:	6a 00                	push   $0x0
  pushl $97
80106d96:	6a 61                	push   $0x61
  jmp alltraps
80106d98:	e9 53 f6 ff ff       	jmp    801063f0 <alltraps>

80106d9d <vector98>:
.globl vector98
vector98:
  pushl $0
80106d9d:	6a 00                	push   $0x0
  pushl $98
80106d9f:	6a 62                	push   $0x62
  jmp alltraps
80106da1:	e9 4a f6 ff ff       	jmp    801063f0 <alltraps>

80106da6 <vector99>:
.globl vector99
vector99:
  pushl $0
80106da6:	6a 00                	push   $0x0
  pushl $99
80106da8:	6a 63                	push   $0x63
  jmp alltraps
80106daa:	e9 41 f6 ff ff       	jmp    801063f0 <alltraps>

80106daf <vector100>:
.globl vector100
vector100:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $100
80106db1:	6a 64                	push   $0x64
  jmp alltraps
80106db3:	e9 38 f6 ff ff       	jmp    801063f0 <alltraps>

80106db8 <vector101>:
.globl vector101
vector101:
  pushl $0
80106db8:	6a 00                	push   $0x0
  pushl $101
80106dba:	6a 65                	push   $0x65
  jmp alltraps
80106dbc:	e9 2f f6 ff ff       	jmp    801063f0 <alltraps>

80106dc1 <vector102>:
.globl vector102
vector102:
  pushl $0
80106dc1:	6a 00                	push   $0x0
  pushl $102
80106dc3:	6a 66                	push   $0x66
  jmp alltraps
80106dc5:	e9 26 f6 ff ff       	jmp    801063f0 <alltraps>

80106dca <vector103>:
.globl vector103
vector103:
  pushl $0
80106dca:	6a 00                	push   $0x0
  pushl $103
80106dcc:	6a 67                	push   $0x67
  jmp alltraps
80106dce:	e9 1d f6 ff ff       	jmp    801063f0 <alltraps>

80106dd3 <vector104>:
.globl vector104
vector104:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $104
80106dd5:	6a 68                	push   $0x68
  jmp alltraps
80106dd7:	e9 14 f6 ff ff       	jmp    801063f0 <alltraps>

80106ddc <vector105>:
.globl vector105
vector105:
  pushl $0
80106ddc:	6a 00                	push   $0x0
  pushl $105
80106dde:	6a 69                	push   $0x69
  jmp alltraps
80106de0:	e9 0b f6 ff ff       	jmp    801063f0 <alltraps>

80106de5 <vector106>:
.globl vector106
vector106:
  pushl $0
80106de5:	6a 00                	push   $0x0
  pushl $106
80106de7:	6a 6a                	push   $0x6a
  jmp alltraps
80106de9:	e9 02 f6 ff ff       	jmp    801063f0 <alltraps>

80106dee <vector107>:
.globl vector107
vector107:
  pushl $0
80106dee:	6a 00                	push   $0x0
  pushl $107
80106df0:	6a 6b                	push   $0x6b
  jmp alltraps
80106df2:	e9 f9 f5 ff ff       	jmp    801063f0 <alltraps>

80106df7 <vector108>:
.globl vector108
vector108:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $108
80106df9:	6a 6c                	push   $0x6c
  jmp alltraps
80106dfb:	e9 f0 f5 ff ff       	jmp    801063f0 <alltraps>

80106e00 <vector109>:
.globl vector109
vector109:
  pushl $0
80106e00:	6a 00                	push   $0x0
  pushl $109
80106e02:	6a 6d                	push   $0x6d
  jmp alltraps
80106e04:	e9 e7 f5 ff ff       	jmp    801063f0 <alltraps>

80106e09 <vector110>:
.globl vector110
vector110:
  pushl $0
80106e09:	6a 00                	push   $0x0
  pushl $110
80106e0b:	6a 6e                	push   $0x6e
  jmp alltraps
80106e0d:	e9 de f5 ff ff       	jmp    801063f0 <alltraps>

80106e12 <vector111>:
.globl vector111
vector111:
  pushl $0
80106e12:	6a 00                	push   $0x0
  pushl $111
80106e14:	6a 6f                	push   $0x6f
  jmp alltraps
80106e16:	e9 d5 f5 ff ff       	jmp    801063f0 <alltraps>

80106e1b <vector112>:
.globl vector112
vector112:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $112
80106e1d:	6a 70                	push   $0x70
  jmp alltraps
80106e1f:	e9 cc f5 ff ff       	jmp    801063f0 <alltraps>

80106e24 <vector113>:
.globl vector113
vector113:
  pushl $0
80106e24:	6a 00                	push   $0x0
  pushl $113
80106e26:	6a 71                	push   $0x71
  jmp alltraps
80106e28:	e9 c3 f5 ff ff       	jmp    801063f0 <alltraps>

80106e2d <vector114>:
.globl vector114
vector114:
  pushl $0
80106e2d:	6a 00                	push   $0x0
  pushl $114
80106e2f:	6a 72                	push   $0x72
  jmp alltraps
80106e31:	e9 ba f5 ff ff       	jmp    801063f0 <alltraps>

80106e36 <vector115>:
.globl vector115
vector115:
  pushl $0
80106e36:	6a 00                	push   $0x0
  pushl $115
80106e38:	6a 73                	push   $0x73
  jmp alltraps
80106e3a:	e9 b1 f5 ff ff       	jmp    801063f0 <alltraps>

80106e3f <vector116>:
.globl vector116
vector116:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $116
80106e41:	6a 74                	push   $0x74
  jmp alltraps
80106e43:	e9 a8 f5 ff ff       	jmp    801063f0 <alltraps>

80106e48 <vector117>:
.globl vector117
vector117:
  pushl $0
80106e48:	6a 00                	push   $0x0
  pushl $117
80106e4a:	6a 75                	push   $0x75
  jmp alltraps
80106e4c:	e9 9f f5 ff ff       	jmp    801063f0 <alltraps>

80106e51 <vector118>:
.globl vector118
vector118:
  pushl $0
80106e51:	6a 00                	push   $0x0
  pushl $118
80106e53:	6a 76                	push   $0x76
  jmp alltraps
80106e55:	e9 96 f5 ff ff       	jmp    801063f0 <alltraps>

80106e5a <vector119>:
.globl vector119
vector119:
  pushl $0
80106e5a:	6a 00                	push   $0x0
  pushl $119
80106e5c:	6a 77                	push   $0x77
  jmp alltraps
80106e5e:	e9 8d f5 ff ff       	jmp    801063f0 <alltraps>

80106e63 <vector120>:
.globl vector120
vector120:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $120
80106e65:	6a 78                	push   $0x78
  jmp alltraps
80106e67:	e9 84 f5 ff ff       	jmp    801063f0 <alltraps>

80106e6c <vector121>:
.globl vector121
vector121:
  pushl $0
80106e6c:	6a 00                	push   $0x0
  pushl $121
80106e6e:	6a 79                	push   $0x79
  jmp alltraps
80106e70:	e9 7b f5 ff ff       	jmp    801063f0 <alltraps>

80106e75 <vector122>:
.globl vector122
vector122:
  pushl $0
80106e75:	6a 00                	push   $0x0
  pushl $122
80106e77:	6a 7a                	push   $0x7a
  jmp alltraps
80106e79:	e9 72 f5 ff ff       	jmp    801063f0 <alltraps>

80106e7e <vector123>:
.globl vector123
vector123:
  pushl $0
80106e7e:	6a 00                	push   $0x0
  pushl $123
80106e80:	6a 7b                	push   $0x7b
  jmp alltraps
80106e82:	e9 69 f5 ff ff       	jmp    801063f0 <alltraps>

80106e87 <vector124>:
.globl vector124
vector124:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $124
80106e89:	6a 7c                	push   $0x7c
  jmp alltraps
80106e8b:	e9 60 f5 ff ff       	jmp    801063f0 <alltraps>

80106e90 <vector125>:
.globl vector125
vector125:
  pushl $0
80106e90:	6a 00                	push   $0x0
  pushl $125
80106e92:	6a 7d                	push   $0x7d
  jmp alltraps
80106e94:	e9 57 f5 ff ff       	jmp    801063f0 <alltraps>

80106e99 <vector126>:
.globl vector126
vector126:
  pushl $0
80106e99:	6a 00                	push   $0x0
  pushl $126
80106e9b:	6a 7e                	push   $0x7e
  jmp alltraps
80106e9d:	e9 4e f5 ff ff       	jmp    801063f0 <alltraps>

80106ea2 <vector127>:
.globl vector127
vector127:
  pushl $0
80106ea2:	6a 00                	push   $0x0
  pushl $127
80106ea4:	6a 7f                	push   $0x7f
  jmp alltraps
80106ea6:	e9 45 f5 ff ff       	jmp    801063f0 <alltraps>

80106eab <vector128>:
.globl vector128
vector128:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $128
80106ead:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106eb2:	e9 39 f5 ff ff       	jmp    801063f0 <alltraps>

80106eb7 <vector129>:
.globl vector129
vector129:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $129
80106eb9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106ebe:	e9 2d f5 ff ff       	jmp    801063f0 <alltraps>

80106ec3 <vector130>:
.globl vector130
vector130:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $130
80106ec5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106eca:	e9 21 f5 ff ff       	jmp    801063f0 <alltraps>

80106ecf <vector131>:
.globl vector131
vector131:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $131
80106ed1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106ed6:	e9 15 f5 ff ff       	jmp    801063f0 <alltraps>

80106edb <vector132>:
.globl vector132
vector132:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $132
80106edd:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106ee2:	e9 09 f5 ff ff       	jmp    801063f0 <alltraps>

80106ee7 <vector133>:
.globl vector133
vector133:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $133
80106ee9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106eee:	e9 fd f4 ff ff       	jmp    801063f0 <alltraps>

80106ef3 <vector134>:
.globl vector134
vector134:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $134
80106ef5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106efa:	e9 f1 f4 ff ff       	jmp    801063f0 <alltraps>

80106eff <vector135>:
.globl vector135
vector135:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $135
80106f01:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106f06:	e9 e5 f4 ff ff       	jmp    801063f0 <alltraps>

80106f0b <vector136>:
.globl vector136
vector136:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $136
80106f0d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106f12:	e9 d9 f4 ff ff       	jmp    801063f0 <alltraps>

80106f17 <vector137>:
.globl vector137
vector137:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $137
80106f19:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106f1e:	e9 cd f4 ff ff       	jmp    801063f0 <alltraps>

80106f23 <vector138>:
.globl vector138
vector138:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $138
80106f25:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106f2a:	e9 c1 f4 ff ff       	jmp    801063f0 <alltraps>

80106f2f <vector139>:
.globl vector139
vector139:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $139
80106f31:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106f36:	e9 b5 f4 ff ff       	jmp    801063f0 <alltraps>

80106f3b <vector140>:
.globl vector140
vector140:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $140
80106f3d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106f42:	e9 a9 f4 ff ff       	jmp    801063f0 <alltraps>

80106f47 <vector141>:
.globl vector141
vector141:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $141
80106f49:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106f4e:	e9 9d f4 ff ff       	jmp    801063f0 <alltraps>

80106f53 <vector142>:
.globl vector142
vector142:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $142
80106f55:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106f5a:	e9 91 f4 ff ff       	jmp    801063f0 <alltraps>

80106f5f <vector143>:
.globl vector143
vector143:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $143
80106f61:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106f66:	e9 85 f4 ff ff       	jmp    801063f0 <alltraps>

80106f6b <vector144>:
.globl vector144
vector144:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $144
80106f6d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106f72:	e9 79 f4 ff ff       	jmp    801063f0 <alltraps>

80106f77 <vector145>:
.globl vector145
vector145:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $145
80106f79:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106f7e:	e9 6d f4 ff ff       	jmp    801063f0 <alltraps>

80106f83 <vector146>:
.globl vector146
vector146:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $146
80106f85:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106f8a:	e9 61 f4 ff ff       	jmp    801063f0 <alltraps>

80106f8f <vector147>:
.globl vector147
vector147:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $147
80106f91:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106f96:	e9 55 f4 ff ff       	jmp    801063f0 <alltraps>

80106f9b <vector148>:
.globl vector148
vector148:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $148
80106f9d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106fa2:	e9 49 f4 ff ff       	jmp    801063f0 <alltraps>

80106fa7 <vector149>:
.globl vector149
vector149:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $149
80106fa9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106fae:	e9 3d f4 ff ff       	jmp    801063f0 <alltraps>

80106fb3 <vector150>:
.globl vector150
vector150:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $150
80106fb5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106fba:	e9 31 f4 ff ff       	jmp    801063f0 <alltraps>

80106fbf <vector151>:
.globl vector151
vector151:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $151
80106fc1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106fc6:	e9 25 f4 ff ff       	jmp    801063f0 <alltraps>

80106fcb <vector152>:
.globl vector152
vector152:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $152
80106fcd:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106fd2:	e9 19 f4 ff ff       	jmp    801063f0 <alltraps>

80106fd7 <vector153>:
.globl vector153
vector153:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $153
80106fd9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106fde:	e9 0d f4 ff ff       	jmp    801063f0 <alltraps>

80106fe3 <vector154>:
.globl vector154
vector154:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $154
80106fe5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106fea:	e9 01 f4 ff ff       	jmp    801063f0 <alltraps>

80106fef <vector155>:
.globl vector155
vector155:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $155
80106ff1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106ff6:	e9 f5 f3 ff ff       	jmp    801063f0 <alltraps>

80106ffb <vector156>:
.globl vector156
vector156:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $156
80106ffd:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107002:	e9 e9 f3 ff ff       	jmp    801063f0 <alltraps>

80107007 <vector157>:
.globl vector157
vector157:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $157
80107009:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010700e:	e9 dd f3 ff ff       	jmp    801063f0 <alltraps>

80107013 <vector158>:
.globl vector158
vector158:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $158
80107015:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010701a:	e9 d1 f3 ff ff       	jmp    801063f0 <alltraps>

8010701f <vector159>:
.globl vector159
vector159:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $159
80107021:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107026:	e9 c5 f3 ff ff       	jmp    801063f0 <alltraps>

8010702b <vector160>:
.globl vector160
vector160:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $160
8010702d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107032:	e9 b9 f3 ff ff       	jmp    801063f0 <alltraps>

80107037 <vector161>:
.globl vector161
vector161:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $161
80107039:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010703e:	e9 ad f3 ff ff       	jmp    801063f0 <alltraps>

80107043 <vector162>:
.globl vector162
vector162:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $162
80107045:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010704a:	e9 a1 f3 ff ff       	jmp    801063f0 <alltraps>

8010704f <vector163>:
.globl vector163
vector163:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $163
80107051:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107056:	e9 95 f3 ff ff       	jmp    801063f0 <alltraps>

8010705b <vector164>:
.globl vector164
vector164:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $164
8010705d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107062:	e9 89 f3 ff ff       	jmp    801063f0 <alltraps>

80107067 <vector165>:
.globl vector165
vector165:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $165
80107069:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010706e:	e9 7d f3 ff ff       	jmp    801063f0 <alltraps>

80107073 <vector166>:
.globl vector166
vector166:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $166
80107075:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010707a:	e9 71 f3 ff ff       	jmp    801063f0 <alltraps>

8010707f <vector167>:
.globl vector167
vector167:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $167
80107081:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107086:	e9 65 f3 ff ff       	jmp    801063f0 <alltraps>

8010708b <vector168>:
.globl vector168
vector168:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $168
8010708d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107092:	e9 59 f3 ff ff       	jmp    801063f0 <alltraps>

80107097 <vector169>:
.globl vector169
vector169:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $169
80107099:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010709e:	e9 4d f3 ff ff       	jmp    801063f0 <alltraps>

801070a3 <vector170>:
.globl vector170
vector170:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $170
801070a5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801070aa:	e9 41 f3 ff ff       	jmp    801063f0 <alltraps>

801070af <vector171>:
.globl vector171
vector171:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $171
801070b1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801070b6:	e9 35 f3 ff ff       	jmp    801063f0 <alltraps>

801070bb <vector172>:
.globl vector172
vector172:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $172
801070bd:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801070c2:	e9 29 f3 ff ff       	jmp    801063f0 <alltraps>

801070c7 <vector173>:
.globl vector173
vector173:
  pushl $0
801070c7:	6a 00                	push   $0x0
  pushl $173
801070c9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801070ce:	e9 1d f3 ff ff       	jmp    801063f0 <alltraps>

801070d3 <vector174>:
.globl vector174
vector174:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $174
801070d5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801070da:	e9 11 f3 ff ff       	jmp    801063f0 <alltraps>

801070df <vector175>:
.globl vector175
vector175:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $175
801070e1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801070e6:	e9 05 f3 ff ff       	jmp    801063f0 <alltraps>

801070eb <vector176>:
.globl vector176
vector176:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $176
801070ed:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801070f2:	e9 f9 f2 ff ff       	jmp    801063f0 <alltraps>

801070f7 <vector177>:
.globl vector177
vector177:
  pushl $0
801070f7:	6a 00                	push   $0x0
  pushl $177
801070f9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801070fe:	e9 ed f2 ff ff       	jmp    801063f0 <alltraps>

80107103 <vector178>:
.globl vector178
vector178:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $178
80107105:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010710a:	e9 e1 f2 ff ff       	jmp    801063f0 <alltraps>

8010710f <vector179>:
.globl vector179
vector179:
  pushl $0
8010710f:	6a 00                	push   $0x0
  pushl $179
80107111:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107116:	e9 d5 f2 ff ff       	jmp    801063f0 <alltraps>

8010711b <vector180>:
.globl vector180
vector180:
  pushl $0
8010711b:	6a 00                	push   $0x0
  pushl $180
8010711d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107122:	e9 c9 f2 ff ff       	jmp    801063f0 <alltraps>

80107127 <vector181>:
.globl vector181
vector181:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $181
80107129:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010712e:	e9 bd f2 ff ff       	jmp    801063f0 <alltraps>

80107133 <vector182>:
.globl vector182
vector182:
  pushl $0
80107133:	6a 00                	push   $0x0
  pushl $182
80107135:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010713a:	e9 b1 f2 ff ff       	jmp    801063f0 <alltraps>

8010713f <vector183>:
.globl vector183
vector183:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $183
80107141:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107146:	e9 a5 f2 ff ff       	jmp    801063f0 <alltraps>

8010714b <vector184>:
.globl vector184
vector184:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $184
8010714d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107152:	e9 99 f2 ff ff       	jmp    801063f0 <alltraps>

80107157 <vector185>:
.globl vector185
vector185:
  pushl $0
80107157:	6a 00                	push   $0x0
  pushl $185
80107159:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010715e:	e9 8d f2 ff ff       	jmp    801063f0 <alltraps>

80107163 <vector186>:
.globl vector186
vector186:
  pushl $0
80107163:	6a 00                	push   $0x0
  pushl $186
80107165:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010716a:	e9 81 f2 ff ff       	jmp    801063f0 <alltraps>

8010716f <vector187>:
.globl vector187
vector187:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $187
80107171:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107176:	e9 75 f2 ff ff       	jmp    801063f0 <alltraps>

8010717b <vector188>:
.globl vector188
vector188:
  pushl $0
8010717b:	6a 00                	push   $0x0
  pushl $188
8010717d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107182:	e9 69 f2 ff ff       	jmp    801063f0 <alltraps>

80107187 <vector189>:
.globl vector189
vector189:
  pushl $0
80107187:	6a 00                	push   $0x0
  pushl $189
80107189:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010718e:	e9 5d f2 ff ff       	jmp    801063f0 <alltraps>

80107193 <vector190>:
.globl vector190
vector190:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $190
80107195:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010719a:	e9 51 f2 ff ff       	jmp    801063f0 <alltraps>

8010719f <vector191>:
.globl vector191
vector191:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $191
801071a1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801071a6:	e9 45 f2 ff ff       	jmp    801063f0 <alltraps>

801071ab <vector192>:
.globl vector192
vector192:
  pushl $0
801071ab:	6a 00                	push   $0x0
  pushl $192
801071ad:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801071b2:	e9 39 f2 ff ff       	jmp    801063f0 <alltraps>

801071b7 <vector193>:
.globl vector193
vector193:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $193
801071b9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801071be:	e9 2d f2 ff ff       	jmp    801063f0 <alltraps>

801071c3 <vector194>:
.globl vector194
vector194:
  pushl $0
801071c3:	6a 00                	push   $0x0
  pushl $194
801071c5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801071ca:	e9 21 f2 ff ff       	jmp    801063f0 <alltraps>

801071cf <vector195>:
.globl vector195
vector195:
  pushl $0
801071cf:	6a 00                	push   $0x0
  pushl $195
801071d1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801071d6:	e9 15 f2 ff ff       	jmp    801063f0 <alltraps>

801071db <vector196>:
.globl vector196
vector196:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $196
801071dd:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801071e2:	e9 09 f2 ff ff       	jmp    801063f0 <alltraps>

801071e7 <vector197>:
.globl vector197
vector197:
  pushl $0
801071e7:	6a 00                	push   $0x0
  pushl $197
801071e9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801071ee:	e9 fd f1 ff ff       	jmp    801063f0 <alltraps>

801071f3 <vector198>:
.globl vector198
vector198:
  pushl $0
801071f3:	6a 00                	push   $0x0
  pushl $198
801071f5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801071fa:	e9 f1 f1 ff ff       	jmp    801063f0 <alltraps>

801071ff <vector199>:
.globl vector199
vector199:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $199
80107201:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107206:	e9 e5 f1 ff ff       	jmp    801063f0 <alltraps>

8010720b <vector200>:
.globl vector200
vector200:
  pushl $0
8010720b:	6a 00                	push   $0x0
  pushl $200
8010720d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107212:	e9 d9 f1 ff ff       	jmp    801063f0 <alltraps>

80107217 <vector201>:
.globl vector201
vector201:
  pushl $0
80107217:	6a 00                	push   $0x0
  pushl $201
80107219:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010721e:	e9 cd f1 ff ff       	jmp    801063f0 <alltraps>

80107223 <vector202>:
.globl vector202
vector202:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $202
80107225:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010722a:	e9 c1 f1 ff ff       	jmp    801063f0 <alltraps>

8010722f <vector203>:
.globl vector203
vector203:
  pushl $0
8010722f:	6a 00                	push   $0x0
  pushl $203
80107231:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107236:	e9 b5 f1 ff ff       	jmp    801063f0 <alltraps>

8010723b <vector204>:
.globl vector204
vector204:
  pushl $0
8010723b:	6a 00                	push   $0x0
  pushl $204
8010723d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107242:	e9 a9 f1 ff ff       	jmp    801063f0 <alltraps>

80107247 <vector205>:
.globl vector205
vector205:
  pushl $0
80107247:	6a 00                	push   $0x0
  pushl $205
80107249:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010724e:	e9 9d f1 ff ff       	jmp    801063f0 <alltraps>

80107253 <vector206>:
.globl vector206
vector206:
  pushl $0
80107253:	6a 00                	push   $0x0
  pushl $206
80107255:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010725a:	e9 91 f1 ff ff       	jmp    801063f0 <alltraps>

8010725f <vector207>:
.globl vector207
vector207:
  pushl $0
8010725f:	6a 00                	push   $0x0
  pushl $207
80107261:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107266:	e9 85 f1 ff ff       	jmp    801063f0 <alltraps>

8010726b <vector208>:
.globl vector208
vector208:
  pushl $0
8010726b:	6a 00                	push   $0x0
  pushl $208
8010726d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107272:	e9 79 f1 ff ff       	jmp    801063f0 <alltraps>

80107277 <vector209>:
.globl vector209
vector209:
  pushl $0
80107277:	6a 00                	push   $0x0
  pushl $209
80107279:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010727e:	e9 6d f1 ff ff       	jmp    801063f0 <alltraps>

80107283 <vector210>:
.globl vector210
vector210:
  pushl $0
80107283:	6a 00                	push   $0x0
  pushl $210
80107285:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010728a:	e9 61 f1 ff ff       	jmp    801063f0 <alltraps>

8010728f <vector211>:
.globl vector211
vector211:
  pushl $0
8010728f:	6a 00                	push   $0x0
  pushl $211
80107291:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107296:	e9 55 f1 ff ff       	jmp    801063f0 <alltraps>

8010729b <vector212>:
.globl vector212
vector212:
  pushl $0
8010729b:	6a 00                	push   $0x0
  pushl $212
8010729d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801072a2:	e9 49 f1 ff ff       	jmp    801063f0 <alltraps>

801072a7 <vector213>:
.globl vector213
vector213:
  pushl $0
801072a7:	6a 00                	push   $0x0
  pushl $213
801072a9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801072ae:	e9 3d f1 ff ff       	jmp    801063f0 <alltraps>

801072b3 <vector214>:
.globl vector214
vector214:
  pushl $0
801072b3:	6a 00                	push   $0x0
  pushl $214
801072b5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801072ba:	e9 31 f1 ff ff       	jmp    801063f0 <alltraps>

801072bf <vector215>:
.globl vector215
vector215:
  pushl $0
801072bf:	6a 00                	push   $0x0
  pushl $215
801072c1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801072c6:	e9 25 f1 ff ff       	jmp    801063f0 <alltraps>

801072cb <vector216>:
.globl vector216
vector216:
  pushl $0
801072cb:	6a 00                	push   $0x0
  pushl $216
801072cd:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801072d2:	e9 19 f1 ff ff       	jmp    801063f0 <alltraps>

801072d7 <vector217>:
.globl vector217
vector217:
  pushl $0
801072d7:	6a 00                	push   $0x0
  pushl $217
801072d9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801072de:	e9 0d f1 ff ff       	jmp    801063f0 <alltraps>

801072e3 <vector218>:
.globl vector218
vector218:
  pushl $0
801072e3:	6a 00                	push   $0x0
  pushl $218
801072e5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801072ea:	e9 01 f1 ff ff       	jmp    801063f0 <alltraps>

801072ef <vector219>:
.globl vector219
vector219:
  pushl $0
801072ef:	6a 00                	push   $0x0
  pushl $219
801072f1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801072f6:	e9 f5 f0 ff ff       	jmp    801063f0 <alltraps>

801072fb <vector220>:
.globl vector220
vector220:
  pushl $0
801072fb:	6a 00                	push   $0x0
  pushl $220
801072fd:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107302:	e9 e9 f0 ff ff       	jmp    801063f0 <alltraps>

80107307 <vector221>:
.globl vector221
vector221:
  pushl $0
80107307:	6a 00                	push   $0x0
  pushl $221
80107309:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010730e:	e9 dd f0 ff ff       	jmp    801063f0 <alltraps>

80107313 <vector222>:
.globl vector222
vector222:
  pushl $0
80107313:	6a 00                	push   $0x0
  pushl $222
80107315:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010731a:	e9 d1 f0 ff ff       	jmp    801063f0 <alltraps>

8010731f <vector223>:
.globl vector223
vector223:
  pushl $0
8010731f:	6a 00                	push   $0x0
  pushl $223
80107321:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107326:	e9 c5 f0 ff ff       	jmp    801063f0 <alltraps>

8010732b <vector224>:
.globl vector224
vector224:
  pushl $0
8010732b:	6a 00                	push   $0x0
  pushl $224
8010732d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107332:	e9 b9 f0 ff ff       	jmp    801063f0 <alltraps>

80107337 <vector225>:
.globl vector225
vector225:
  pushl $0
80107337:	6a 00                	push   $0x0
  pushl $225
80107339:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010733e:	e9 ad f0 ff ff       	jmp    801063f0 <alltraps>

80107343 <vector226>:
.globl vector226
vector226:
  pushl $0
80107343:	6a 00                	push   $0x0
  pushl $226
80107345:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010734a:	e9 a1 f0 ff ff       	jmp    801063f0 <alltraps>

8010734f <vector227>:
.globl vector227
vector227:
  pushl $0
8010734f:	6a 00                	push   $0x0
  pushl $227
80107351:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107356:	e9 95 f0 ff ff       	jmp    801063f0 <alltraps>

8010735b <vector228>:
.globl vector228
vector228:
  pushl $0
8010735b:	6a 00                	push   $0x0
  pushl $228
8010735d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107362:	e9 89 f0 ff ff       	jmp    801063f0 <alltraps>

80107367 <vector229>:
.globl vector229
vector229:
  pushl $0
80107367:	6a 00                	push   $0x0
  pushl $229
80107369:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010736e:	e9 7d f0 ff ff       	jmp    801063f0 <alltraps>

80107373 <vector230>:
.globl vector230
vector230:
  pushl $0
80107373:	6a 00                	push   $0x0
  pushl $230
80107375:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010737a:	e9 71 f0 ff ff       	jmp    801063f0 <alltraps>

8010737f <vector231>:
.globl vector231
vector231:
  pushl $0
8010737f:	6a 00                	push   $0x0
  pushl $231
80107381:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107386:	e9 65 f0 ff ff       	jmp    801063f0 <alltraps>

8010738b <vector232>:
.globl vector232
vector232:
  pushl $0
8010738b:	6a 00                	push   $0x0
  pushl $232
8010738d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107392:	e9 59 f0 ff ff       	jmp    801063f0 <alltraps>

80107397 <vector233>:
.globl vector233
vector233:
  pushl $0
80107397:	6a 00                	push   $0x0
  pushl $233
80107399:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010739e:	e9 4d f0 ff ff       	jmp    801063f0 <alltraps>

801073a3 <vector234>:
.globl vector234
vector234:
  pushl $0
801073a3:	6a 00                	push   $0x0
  pushl $234
801073a5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801073aa:	e9 41 f0 ff ff       	jmp    801063f0 <alltraps>

801073af <vector235>:
.globl vector235
vector235:
  pushl $0
801073af:	6a 00                	push   $0x0
  pushl $235
801073b1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801073b6:	e9 35 f0 ff ff       	jmp    801063f0 <alltraps>

801073bb <vector236>:
.globl vector236
vector236:
  pushl $0
801073bb:	6a 00                	push   $0x0
  pushl $236
801073bd:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801073c2:	e9 29 f0 ff ff       	jmp    801063f0 <alltraps>

801073c7 <vector237>:
.globl vector237
vector237:
  pushl $0
801073c7:	6a 00                	push   $0x0
  pushl $237
801073c9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801073ce:	e9 1d f0 ff ff       	jmp    801063f0 <alltraps>

801073d3 <vector238>:
.globl vector238
vector238:
  pushl $0
801073d3:	6a 00                	push   $0x0
  pushl $238
801073d5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801073da:	e9 11 f0 ff ff       	jmp    801063f0 <alltraps>

801073df <vector239>:
.globl vector239
vector239:
  pushl $0
801073df:	6a 00                	push   $0x0
  pushl $239
801073e1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801073e6:	e9 05 f0 ff ff       	jmp    801063f0 <alltraps>

801073eb <vector240>:
.globl vector240
vector240:
  pushl $0
801073eb:	6a 00                	push   $0x0
  pushl $240
801073ed:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801073f2:	e9 f9 ef ff ff       	jmp    801063f0 <alltraps>

801073f7 <vector241>:
.globl vector241
vector241:
  pushl $0
801073f7:	6a 00                	push   $0x0
  pushl $241
801073f9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801073fe:	e9 ed ef ff ff       	jmp    801063f0 <alltraps>

80107403 <vector242>:
.globl vector242
vector242:
  pushl $0
80107403:	6a 00                	push   $0x0
  pushl $242
80107405:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010740a:	e9 e1 ef ff ff       	jmp    801063f0 <alltraps>

8010740f <vector243>:
.globl vector243
vector243:
  pushl $0
8010740f:	6a 00                	push   $0x0
  pushl $243
80107411:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107416:	e9 d5 ef ff ff       	jmp    801063f0 <alltraps>

8010741b <vector244>:
.globl vector244
vector244:
  pushl $0
8010741b:	6a 00                	push   $0x0
  pushl $244
8010741d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107422:	e9 c9 ef ff ff       	jmp    801063f0 <alltraps>

80107427 <vector245>:
.globl vector245
vector245:
  pushl $0
80107427:	6a 00                	push   $0x0
  pushl $245
80107429:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010742e:	e9 bd ef ff ff       	jmp    801063f0 <alltraps>

80107433 <vector246>:
.globl vector246
vector246:
  pushl $0
80107433:	6a 00                	push   $0x0
  pushl $246
80107435:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010743a:	e9 b1 ef ff ff       	jmp    801063f0 <alltraps>

8010743f <vector247>:
.globl vector247
vector247:
  pushl $0
8010743f:	6a 00                	push   $0x0
  pushl $247
80107441:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107446:	e9 a5 ef ff ff       	jmp    801063f0 <alltraps>

8010744b <vector248>:
.globl vector248
vector248:
  pushl $0
8010744b:	6a 00                	push   $0x0
  pushl $248
8010744d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107452:	e9 99 ef ff ff       	jmp    801063f0 <alltraps>

80107457 <vector249>:
.globl vector249
vector249:
  pushl $0
80107457:	6a 00                	push   $0x0
  pushl $249
80107459:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010745e:	e9 8d ef ff ff       	jmp    801063f0 <alltraps>

80107463 <vector250>:
.globl vector250
vector250:
  pushl $0
80107463:	6a 00                	push   $0x0
  pushl $250
80107465:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010746a:	e9 81 ef ff ff       	jmp    801063f0 <alltraps>

8010746f <vector251>:
.globl vector251
vector251:
  pushl $0
8010746f:	6a 00                	push   $0x0
  pushl $251
80107471:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107476:	e9 75 ef ff ff       	jmp    801063f0 <alltraps>

8010747b <vector252>:
.globl vector252
vector252:
  pushl $0
8010747b:	6a 00                	push   $0x0
  pushl $252
8010747d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107482:	e9 69 ef ff ff       	jmp    801063f0 <alltraps>

80107487 <vector253>:
.globl vector253
vector253:
  pushl $0
80107487:	6a 00                	push   $0x0
  pushl $253
80107489:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010748e:	e9 5d ef ff ff       	jmp    801063f0 <alltraps>

80107493 <vector254>:
.globl vector254
vector254:
  pushl $0
80107493:	6a 00                	push   $0x0
  pushl $254
80107495:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010749a:	e9 51 ef ff ff       	jmp    801063f0 <alltraps>

8010749f <vector255>:
.globl vector255
vector255:
  pushl $0
8010749f:	6a 00                	push   $0x0
  pushl $255
801074a1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801074a6:	e9 45 ef ff ff       	jmp    801063f0 <alltraps>

801074ab <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
801074ab:	55                   	push   %ebp
801074ac:	89 e5                	mov    %esp,%ebp
801074ae:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801074b1:	8b 45 0c             	mov    0xc(%ebp),%eax
801074b4:	83 e8 01             	sub    $0x1,%eax
801074b7:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801074bb:	8b 45 08             	mov    0x8(%ebp),%eax
801074be:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801074c2:	8b 45 08             	mov    0x8(%ebp),%eax
801074c5:	c1 e8 10             	shr    $0x10,%eax
801074c8:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801074cc:	8d 45 fa             	lea    -0x6(%ebp),%eax
801074cf:	0f 01 10             	lgdtl  (%eax)
}
801074d2:	c9                   	leave  
801074d3:	c3                   	ret    

801074d4 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
801074d4:	55                   	push   %ebp
801074d5:	89 e5                	mov    %esp,%ebp
801074d7:	83 ec 04             	sub    $0x4,%esp
801074da:	8b 45 08             	mov    0x8(%ebp),%eax
801074dd:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
801074e1:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801074e5:	0f 00 d8             	ltr    %ax
}
801074e8:	c9                   	leave  
801074e9:	c3                   	ret    

801074ea <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
801074ea:	55                   	push   %ebp
801074eb:	89 e5                	mov    %esp,%ebp
801074ed:	83 ec 04             	sub    $0x4,%esp
801074f0:	8b 45 08             	mov    0x8(%ebp),%eax
801074f3:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
801074f7:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801074fb:	8e e8                	mov    %eax,%gs
}
801074fd:	c9                   	leave  
801074fe:	c3                   	ret    

801074ff <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
801074ff:	55                   	push   %ebp
80107500:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107502:	8b 45 08             	mov    0x8(%ebp),%eax
80107505:	0f 22 d8             	mov    %eax,%cr3
}
80107508:	5d                   	pop    %ebp
80107509:	c3                   	ret    

8010750a <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
8010750a:	55                   	push   %ebp
8010750b:	89 e5                	mov    %esp,%ebp
8010750d:	8b 45 08             	mov    0x8(%ebp),%eax
80107510:	05 00 00 00 80       	add    $0x80000000,%eax
80107515:	5d                   	pop    %ebp
80107516:	c3                   	ret    

80107517 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107517:	55                   	push   %ebp
80107518:	89 e5                	mov    %esp,%ebp
8010751a:	8b 45 08             	mov    0x8(%ebp),%eax
8010751d:	05 00 00 00 80       	add    $0x80000000,%eax
80107522:	5d                   	pop    %ebp
80107523:	c3                   	ret    

80107524 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107524:	55                   	push   %ebp
80107525:	89 e5                	mov    %esp,%ebp
80107527:	53                   	push   %ebx
80107528:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
8010752b:	e8 7e b9 ff ff       	call   80102eae <cpunum>
80107530:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107536:	05 c0 f9 10 80       	add    $0x8010f9c0,%eax
8010753b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010753e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107541:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107547:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010754a:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107550:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107553:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107557:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010755a:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010755e:	83 e2 f0             	and    $0xfffffff0,%edx
80107561:	83 ca 0a             	or     $0xa,%edx
80107564:	88 50 7d             	mov    %dl,0x7d(%eax)
80107567:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010756a:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010756e:	83 ca 10             	or     $0x10,%edx
80107571:	88 50 7d             	mov    %dl,0x7d(%eax)
80107574:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107577:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010757b:	83 e2 9f             	and    $0xffffff9f,%edx
8010757e:	88 50 7d             	mov    %dl,0x7d(%eax)
80107581:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107584:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107588:	83 ca 80             	or     $0xffffff80,%edx
8010758b:	88 50 7d             	mov    %dl,0x7d(%eax)
8010758e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107591:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107595:	83 ca 0f             	or     $0xf,%edx
80107598:	88 50 7e             	mov    %dl,0x7e(%eax)
8010759b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010759e:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801075a2:	83 e2 ef             	and    $0xffffffef,%edx
801075a5:	88 50 7e             	mov    %dl,0x7e(%eax)
801075a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075ab:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801075af:	83 e2 df             	and    $0xffffffdf,%edx
801075b2:	88 50 7e             	mov    %dl,0x7e(%eax)
801075b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075b8:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801075bc:	83 ca 40             	or     $0x40,%edx
801075bf:	88 50 7e             	mov    %dl,0x7e(%eax)
801075c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075c5:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801075c9:	83 ca 80             	or     $0xffffff80,%edx
801075cc:	88 50 7e             	mov    %dl,0x7e(%eax)
801075cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075d2:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801075d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075d9:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
801075e0:	ff ff 
801075e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075e5:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
801075ec:	00 00 
801075ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075f1:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801075f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075fb:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107602:	83 e2 f0             	and    $0xfffffff0,%edx
80107605:	83 ca 02             	or     $0x2,%edx
80107608:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010760e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107611:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107618:	83 ca 10             	or     $0x10,%edx
8010761b:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107621:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107624:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010762b:	83 e2 9f             	and    $0xffffff9f,%edx
8010762e:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107634:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107637:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010763e:	83 ca 80             	or     $0xffffff80,%edx
80107641:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107647:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010764a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107651:	83 ca 0f             	or     $0xf,%edx
80107654:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010765a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010765d:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107664:	83 e2 ef             	and    $0xffffffef,%edx
80107667:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010766d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107670:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107677:	83 e2 df             	and    $0xffffffdf,%edx
8010767a:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107680:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107683:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010768a:	83 ca 40             	or     $0x40,%edx
8010768d:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107693:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107696:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010769d:	83 ca 80             	or     $0xffffff80,%edx
801076a0:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801076a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076a9:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801076b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076b3:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801076ba:	ff ff 
801076bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076bf:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801076c6:	00 00 
801076c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076cb:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801076d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076d5:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801076dc:	83 e2 f0             	and    $0xfffffff0,%edx
801076df:	83 ca 0a             	or     $0xa,%edx
801076e2:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801076e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076eb:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801076f2:	83 ca 10             	or     $0x10,%edx
801076f5:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801076fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076fe:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107705:	83 ca 60             	or     $0x60,%edx
80107708:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010770e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107711:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107718:	83 ca 80             	or     $0xffffff80,%edx
8010771b:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107721:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107724:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010772b:	83 ca 0f             	or     $0xf,%edx
8010772e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107734:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107737:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010773e:	83 e2 ef             	and    $0xffffffef,%edx
80107741:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107747:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010774a:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107751:	83 e2 df             	and    $0xffffffdf,%edx
80107754:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010775a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010775d:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107764:	83 ca 40             	or     $0x40,%edx
80107767:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010776d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107770:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107777:	83 ca 80             	or     $0xffffff80,%edx
8010777a:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107780:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107783:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010778a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010778d:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107794:	ff ff 
80107796:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107799:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
801077a0:	00 00 
801077a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077a5:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
801077ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077af:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801077b6:	83 e2 f0             	and    $0xfffffff0,%edx
801077b9:	83 ca 02             	or     $0x2,%edx
801077bc:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801077c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077c5:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801077cc:	83 ca 10             	or     $0x10,%edx
801077cf:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801077d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077d8:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801077df:	83 ca 60             	or     $0x60,%edx
801077e2:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801077e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077eb:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801077f2:	83 ca 80             	or     $0xffffff80,%edx
801077f5:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801077fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077fe:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107805:	83 ca 0f             	or     $0xf,%edx
80107808:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010780e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107811:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107818:	83 e2 ef             	and    $0xffffffef,%edx
8010781b:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107821:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107824:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010782b:	83 e2 df             	and    $0xffffffdf,%edx
8010782e:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107834:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107837:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010783e:	83 ca 40             	or     $0x40,%edx
80107841:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107847:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010784a:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107851:	83 ca 80             	or     $0xffffff80,%edx
80107854:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010785a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010785d:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107864:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107867:	05 b4 00 00 00       	add    $0xb4,%eax
8010786c:	89 c3                	mov    %eax,%ebx
8010786e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107871:	05 b4 00 00 00       	add    $0xb4,%eax
80107876:	c1 e8 10             	shr    $0x10,%eax
80107879:	89 c1                	mov    %eax,%ecx
8010787b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010787e:	05 b4 00 00 00       	add    $0xb4,%eax
80107883:	c1 e8 18             	shr    $0x18,%eax
80107886:	89 c2                	mov    %eax,%edx
80107888:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010788b:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107892:	00 00 
80107894:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107897:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
8010789e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078a1:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
801078a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078aa:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801078b1:	83 e1 f0             	and    $0xfffffff0,%ecx
801078b4:	83 c9 02             	or     $0x2,%ecx
801078b7:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801078bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078c0:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801078c7:	83 c9 10             	or     $0x10,%ecx
801078ca:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801078d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078d3:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801078da:	83 e1 9f             	and    $0xffffff9f,%ecx
801078dd:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801078e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078e6:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801078ed:	83 c9 80             	or     $0xffffff80,%ecx
801078f0:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801078f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078f9:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107900:	83 e1 f0             	and    $0xfffffff0,%ecx
80107903:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107909:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010790c:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107913:	83 e1 ef             	and    $0xffffffef,%ecx
80107916:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010791c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010791f:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107926:	83 e1 df             	and    $0xffffffdf,%ecx
80107929:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010792f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107932:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107939:	83 c9 40             	or     $0x40,%ecx
8010793c:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107942:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107945:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
8010794c:	83 c9 80             	or     $0xffffff80,%ecx
8010794f:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107955:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107958:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
8010795e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107961:	83 c0 70             	add    $0x70,%eax
80107964:	83 ec 08             	sub    $0x8,%esp
80107967:	6a 38                	push   $0x38
80107969:	50                   	push   %eax
8010796a:	e8 3c fb ff ff       	call   801074ab <lgdt>
8010796f:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80107972:	83 ec 0c             	sub    $0xc,%esp
80107975:	6a 18                	push   $0x18
80107977:	e8 6e fb ff ff       	call   801074ea <loadgs>
8010797c:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
8010797f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107982:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107988:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010798f:	00 00 00 00 
}
80107993:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107996:	c9                   	leave  
80107997:	c3                   	ret    

80107998 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107998:	55                   	push   %ebp
80107999:	89 e5                	mov    %esp,%ebp
8010799b:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010799e:	8b 45 0c             	mov    0xc(%ebp),%eax
801079a1:	c1 e8 16             	shr    $0x16,%eax
801079a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801079ab:	8b 45 08             	mov    0x8(%ebp),%eax
801079ae:	01 d0                	add    %edx,%eax
801079b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801079b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079b6:	8b 00                	mov    (%eax),%eax
801079b8:	83 e0 01             	and    $0x1,%eax
801079bb:	85 c0                	test   %eax,%eax
801079bd:	74 18                	je     801079d7 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
801079bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079c2:	8b 00                	mov    (%eax),%eax
801079c4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801079c9:	50                   	push   %eax
801079ca:	e8 48 fb ff ff       	call   80107517 <p2v>
801079cf:	83 c4 04             	add    $0x4,%esp
801079d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801079d5:	eb 48                	jmp    80107a1f <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801079d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801079db:	74 0e                	je     801079eb <walkpgdir+0x53>
801079dd:	e8 88 b1 ff ff       	call   80102b6a <kalloc>
801079e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801079e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801079e9:	75 07                	jne    801079f2 <walkpgdir+0x5a>
      return 0;
801079eb:	b8 00 00 00 00       	mov    $0x0,%eax
801079f0:	eb 44                	jmp    80107a36 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801079f2:	83 ec 04             	sub    $0x4,%esp
801079f5:	68 00 10 00 00       	push   $0x1000
801079fa:	6a 00                	push   $0x0
801079fc:	ff 75 f4             	pushl  -0xc(%ebp)
801079ff:	e8 4e d3 ff ff       	call   80104d52 <memset>
80107a04:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80107a07:	83 ec 0c             	sub    $0xc,%esp
80107a0a:	ff 75 f4             	pushl  -0xc(%ebp)
80107a0d:	e8 f8 fa ff ff       	call   8010750a <v2p>
80107a12:	83 c4 10             	add    $0x10,%esp
80107a15:	83 c8 07             	or     $0x7,%eax
80107a18:	89 c2                	mov    %eax,%edx
80107a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a1d:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a22:	c1 e8 0c             	shr    $0xc,%eax
80107a25:	25 ff 03 00 00       	and    $0x3ff,%eax
80107a2a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a34:	01 d0                	add    %edx,%eax
}
80107a36:	c9                   	leave  
80107a37:	c3                   	ret    

80107a38 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107a38:	55                   	push   %ebp
80107a39:	89 e5                	mov    %esp,%ebp
80107a3b:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80107a3e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a41:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107a46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107a49:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a4c:	8b 45 10             	mov    0x10(%ebp),%eax
80107a4f:	01 d0                	add    %edx,%eax
80107a51:	83 e8 01             	sub    $0x1,%eax
80107a54:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107a59:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107a5c:	83 ec 04             	sub    $0x4,%esp
80107a5f:	6a 01                	push   $0x1
80107a61:	ff 75 f4             	pushl  -0xc(%ebp)
80107a64:	ff 75 08             	pushl  0x8(%ebp)
80107a67:	e8 2c ff ff ff       	call   80107998 <walkpgdir>
80107a6c:	83 c4 10             	add    $0x10,%esp
80107a6f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107a72:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107a76:	75 07                	jne    80107a7f <mappages+0x47>
      return -1;
80107a78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a7d:	eb 49                	jmp    80107ac8 <mappages+0x90>
    if(*pte & PTE_P)
80107a7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107a82:	8b 00                	mov    (%eax),%eax
80107a84:	83 e0 01             	and    $0x1,%eax
80107a87:	85 c0                	test   %eax,%eax
80107a89:	74 0d                	je     80107a98 <mappages+0x60>
      panic("remap");
80107a8b:	83 ec 0c             	sub    $0xc,%esp
80107a8e:	68 e0 88 10 80       	push   $0x801088e0
80107a93:	e8 c4 8a ff ff       	call   8010055c <panic>
    *pte = pa | perm | PTE_P;
80107a98:	8b 45 18             	mov    0x18(%ebp),%eax
80107a9b:	0b 45 14             	or     0x14(%ebp),%eax
80107a9e:	83 c8 01             	or     $0x1,%eax
80107aa1:	89 c2                	mov    %eax,%edx
80107aa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107aa6:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aab:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107aae:	75 08                	jne    80107ab8 <mappages+0x80>
      break;
80107ab0:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107ab1:	b8 00 00 00 00       	mov    $0x0,%eax
80107ab6:	eb 10                	jmp    80107ac8 <mappages+0x90>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
80107ab8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107abf:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107ac6:	eb 94                	jmp    80107a5c <mappages+0x24>
  return 0;
}
80107ac8:	c9                   	leave  
80107ac9:	c3                   	ret    

80107aca <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107aca:	55                   	push   %ebp
80107acb:	89 e5                	mov    %esp,%ebp
80107acd:	53                   	push   %ebx
80107ace:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107ad1:	e8 94 b0 ff ff       	call   80102b6a <kalloc>
80107ad6:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107ad9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107add:	75 0a                	jne    80107ae9 <setupkvm+0x1f>
    return 0;
80107adf:	b8 00 00 00 00       	mov    $0x0,%eax
80107ae4:	e9 8e 00 00 00       	jmp    80107b77 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80107ae9:	83 ec 04             	sub    $0x4,%esp
80107aec:	68 00 10 00 00       	push   $0x1000
80107af1:	6a 00                	push   $0x0
80107af3:	ff 75 f0             	pushl  -0x10(%ebp)
80107af6:	e8 57 d2 ff ff       	call   80104d52 <memset>
80107afb:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80107afe:	83 ec 0c             	sub    $0xc,%esp
80107b01:	68 00 00 00 0e       	push   $0xe000000
80107b06:	e8 0c fa ff ff       	call   80107517 <p2v>
80107b0b:	83 c4 10             	add    $0x10,%esp
80107b0e:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80107b13:	76 0d                	jbe    80107b22 <setupkvm+0x58>
    panic("PHYSTOP too high");
80107b15:	83 ec 0c             	sub    $0xc,%esp
80107b18:	68 e6 88 10 80       	push   $0x801088e6
80107b1d:	e8 3a 8a ff ff       	call   8010055c <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107b22:	c7 45 f4 c0 b4 10 80 	movl   $0x8010b4c0,-0xc(%ebp)
80107b29:	eb 40                	jmp    80107b6b <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b2e:	8b 48 0c             	mov    0xc(%eax),%ecx
80107b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b34:	8b 50 04             	mov    0x4(%eax),%edx
80107b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b3a:	8b 58 08             	mov    0x8(%eax),%ebx
80107b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b40:	8b 40 04             	mov    0x4(%eax),%eax
80107b43:	29 c3                	sub    %eax,%ebx
80107b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b48:	8b 00                	mov    (%eax),%eax
80107b4a:	83 ec 0c             	sub    $0xc,%esp
80107b4d:	51                   	push   %ecx
80107b4e:	52                   	push   %edx
80107b4f:	53                   	push   %ebx
80107b50:	50                   	push   %eax
80107b51:	ff 75 f0             	pushl  -0x10(%ebp)
80107b54:	e8 df fe ff ff       	call   80107a38 <mappages>
80107b59:	83 c4 20             	add    $0x20,%esp
80107b5c:	85 c0                	test   %eax,%eax
80107b5e:	79 07                	jns    80107b67 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80107b60:	b8 00 00 00 00       	mov    $0x0,%eax
80107b65:	eb 10                	jmp    80107b77 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107b67:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107b6b:	81 7d f4 00 b5 10 80 	cmpl   $0x8010b500,-0xc(%ebp)
80107b72:	72 b7                	jb     80107b2b <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80107b74:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107b77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107b7a:	c9                   	leave  
80107b7b:	c3                   	ret    

80107b7c <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107b7c:	55                   	push   %ebp
80107b7d:	89 e5                	mov    %esp,%ebp
80107b7f:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107b82:	e8 43 ff ff ff       	call   80107aca <setupkvm>
80107b87:	a3 98 27 11 80       	mov    %eax,0x80112798
  switchkvm();
80107b8c:	e8 02 00 00 00       	call   80107b93 <switchkvm>
}
80107b91:	c9                   	leave  
80107b92:	c3                   	ret    

80107b93 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107b93:	55                   	push   %ebp
80107b94:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80107b96:	a1 98 27 11 80       	mov    0x80112798,%eax
80107b9b:	50                   	push   %eax
80107b9c:	e8 69 f9 ff ff       	call   8010750a <v2p>
80107ba1:	83 c4 04             	add    $0x4,%esp
80107ba4:	50                   	push   %eax
80107ba5:	e8 55 f9 ff ff       	call   801074ff <lcr3>
80107baa:	83 c4 04             	add    $0x4,%esp
}
80107bad:	c9                   	leave  
80107bae:	c3                   	ret    

80107baf <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107baf:	55                   	push   %ebp
80107bb0:	89 e5                	mov    %esp,%ebp
80107bb2:	53                   	push   %ebx
80107bb3:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80107bb6:	e8 95 d0 ff ff       	call   80104c50 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80107bbb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107bc1:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107bc8:	83 c2 08             	add    $0x8,%edx
80107bcb:	89 d3                	mov    %edx,%ebx
80107bcd:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107bd4:	83 c2 08             	add    $0x8,%edx
80107bd7:	c1 ea 10             	shr    $0x10,%edx
80107bda:	89 d1                	mov    %edx,%ecx
80107bdc:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107be3:	83 c2 08             	add    $0x8,%edx
80107be6:	c1 ea 18             	shr    $0x18,%edx
80107be9:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80107bf0:	67 00 
80107bf2:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
80107bf9:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
80107bff:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107c06:	83 e1 f0             	and    $0xfffffff0,%ecx
80107c09:	83 c9 09             	or     $0x9,%ecx
80107c0c:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107c12:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107c19:	83 c9 10             	or     $0x10,%ecx
80107c1c:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107c22:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107c29:	83 e1 9f             	and    $0xffffff9f,%ecx
80107c2c:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107c32:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107c39:	83 c9 80             	or     $0xffffff80,%ecx
80107c3c:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107c42:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107c49:	83 e1 f0             	and    $0xfffffff0,%ecx
80107c4c:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107c52:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107c59:	83 e1 ef             	and    $0xffffffef,%ecx
80107c5c:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107c62:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107c69:	83 e1 df             	and    $0xffffffdf,%ecx
80107c6c:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107c72:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107c79:	83 c9 40             	or     $0x40,%ecx
80107c7c:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107c82:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107c89:	83 e1 7f             	and    $0x7f,%ecx
80107c8c:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107c92:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80107c98:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107c9e:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107ca5:	83 e2 ef             	and    $0xffffffef,%edx
80107ca8:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80107cae:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107cb4:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80107cba:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107cc0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80107cc7:	8b 52 08             	mov    0x8(%edx),%edx
80107cca:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107cd0:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80107cd3:	83 ec 0c             	sub    $0xc,%esp
80107cd6:	6a 30                	push   $0x30
80107cd8:	e8 f7 f7 ff ff       	call   801074d4 <ltr>
80107cdd:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80107ce0:	8b 45 08             	mov    0x8(%ebp),%eax
80107ce3:	8b 40 04             	mov    0x4(%eax),%eax
80107ce6:	85 c0                	test   %eax,%eax
80107ce8:	75 0d                	jne    80107cf7 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80107cea:	83 ec 0c             	sub    $0xc,%esp
80107ced:	68 f7 88 10 80       	push   $0x801088f7
80107cf2:	e8 65 88 ff ff       	call   8010055c <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80107cf7:	8b 45 08             	mov    0x8(%ebp),%eax
80107cfa:	8b 40 04             	mov    0x4(%eax),%eax
80107cfd:	83 ec 0c             	sub    $0xc,%esp
80107d00:	50                   	push   %eax
80107d01:	e8 04 f8 ff ff       	call   8010750a <v2p>
80107d06:	83 c4 10             	add    $0x10,%esp
80107d09:	83 ec 0c             	sub    $0xc,%esp
80107d0c:	50                   	push   %eax
80107d0d:	e8 ed f7 ff ff       	call   801074ff <lcr3>
80107d12:	83 c4 10             	add    $0x10,%esp
  popcli();
80107d15:	e8 7a cf ff ff       	call   80104c94 <popcli>
}
80107d1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107d1d:	c9                   	leave  
80107d1e:	c3                   	ret    

80107d1f <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107d1f:	55                   	push   %ebp
80107d20:	89 e5                	mov    %esp,%ebp
80107d22:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80107d25:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107d2c:	76 0d                	jbe    80107d3b <inituvm+0x1c>
    panic("inituvm: more than a page");
80107d2e:	83 ec 0c             	sub    $0xc,%esp
80107d31:	68 0b 89 10 80       	push   $0x8010890b
80107d36:	e8 21 88 ff ff       	call   8010055c <panic>
  mem = kalloc();
80107d3b:	e8 2a ae ff ff       	call   80102b6a <kalloc>
80107d40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107d43:	83 ec 04             	sub    $0x4,%esp
80107d46:	68 00 10 00 00       	push   $0x1000
80107d4b:	6a 00                	push   $0x0
80107d4d:	ff 75 f4             	pushl  -0xc(%ebp)
80107d50:	e8 fd cf ff ff       	call   80104d52 <memset>
80107d55:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107d58:	83 ec 0c             	sub    $0xc,%esp
80107d5b:	ff 75 f4             	pushl  -0xc(%ebp)
80107d5e:	e8 a7 f7 ff ff       	call   8010750a <v2p>
80107d63:	83 c4 10             	add    $0x10,%esp
80107d66:	83 ec 0c             	sub    $0xc,%esp
80107d69:	6a 06                	push   $0x6
80107d6b:	50                   	push   %eax
80107d6c:	68 00 10 00 00       	push   $0x1000
80107d71:	6a 00                	push   $0x0
80107d73:	ff 75 08             	pushl  0x8(%ebp)
80107d76:	e8 bd fc ff ff       	call   80107a38 <mappages>
80107d7b:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80107d7e:	83 ec 04             	sub    $0x4,%esp
80107d81:	ff 75 10             	pushl  0x10(%ebp)
80107d84:	ff 75 0c             	pushl  0xc(%ebp)
80107d87:	ff 75 f4             	pushl  -0xc(%ebp)
80107d8a:	e8 82 d0 ff ff       	call   80104e11 <memmove>
80107d8f:	83 c4 10             	add    $0x10,%esp
}
80107d92:	c9                   	leave  
80107d93:	c3                   	ret    

80107d94 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107d94:	55                   	push   %ebp
80107d95:	89 e5                	mov    %esp,%ebp
80107d97:	53                   	push   %ebx
80107d98:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d9e:	25 ff 0f 00 00       	and    $0xfff,%eax
80107da3:	85 c0                	test   %eax,%eax
80107da5:	74 0d                	je     80107db4 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80107da7:	83 ec 0c             	sub    $0xc,%esp
80107daa:	68 28 89 10 80       	push   $0x80108928
80107daf:	e8 a8 87 ff ff       	call   8010055c <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107db4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107dbb:	e9 95 00 00 00       	jmp    80107e55 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107dc0:	8b 55 0c             	mov    0xc(%ebp),%edx
80107dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dc6:	01 d0                	add    %edx,%eax
80107dc8:	83 ec 04             	sub    $0x4,%esp
80107dcb:	6a 00                	push   $0x0
80107dcd:	50                   	push   %eax
80107dce:	ff 75 08             	pushl  0x8(%ebp)
80107dd1:	e8 c2 fb ff ff       	call   80107998 <walkpgdir>
80107dd6:	83 c4 10             	add    $0x10,%esp
80107dd9:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107ddc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107de0:	75 0d                	jne    80107def <loaduvm+0x5b>
      panic("loaduvm: address should exist");
80107de2:	83 ec 0c             	sub    $0xc,%esp
80107de5:	68 4b 89 10 80       	push   $0x8010894b
80107dea:	e8 6d 87 ff ff       	call   8010055c <panic>
    pa = PTE_ADDR(*pte);
80107def:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107df2:	8b 00                	mov    (%eax),%eax
80107df4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107df9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107dfc:	8b 45 18             	mov    0x18(%ebp),%eax
80107dff:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107e02:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107e07:	77 0b                	ja     80107e14 <loaduvm+0x80>
      n = sz - i;
80107e09:	8b 45 18             	mov    0x18(%ebp),%eax
80107e0c:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107e0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107e12:	eb 07                	jmp    80107e1b <loaduvm+0x87>
    else
      n = PGSIZE;
80107e14:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80107e1b:	8b 55 14             	mov    0x14(%ebp),%edx
80107e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e21:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80107e24:	83 ec 0c             	sub    $0xc,%esp
80107e27:	ff 75 e8             	pushl  -0x18(%ebp)
80107e2a:	e8 e8 f6 ff ff       	call   80107517 <p2v>
80107e2f:	83 c4 10             	add    $0x10,%esp
80107e32:	ff 75 f0             	pushl  -0x10(%ebp)
80107e35:	53                   	push   %ebx
80107e36:	50                   	push   %eax
80107e37:	ff 75 10             	pushl  0x10(%ebp)
80107e3a:	e8 e6 9f ff ff       	call   80101e25 <readi>
80107e3f:	83 c4 10             	add    $0x10,%esp
80107e42:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107e45:	74 07                	je     80107e4e <loaduvm+0xba>
      return -1;
80107e47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e4c:	eb 18                	jmp    80107e66 <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107e4e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e58:	3b 45 18             	cmp    0x18(%ebp),%eax
80107e5b:	0f 82 5f ff ff ff    	jb     80107dc0 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80107e61:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107e66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107e69:	c9                   	leave  
80107e6a:	c3                   	ret    

80107e6b <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107e6b:	55                   	push   %ebp
80107e6c:	89 e5                	mov    %esp,%ebp
80107e6e:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107e71:	8b 45 10             	mov    0x10(%ebp),%eax
80107e74:	85 c0                	test   %eax,%eax
80107e76:	79 0a                	jns    80107e82 <allocuvm+0x17>
    return 0;
80107e78:	b8 00 00 00 00       	mov    $0x0,%eax
80107e7d:	e9 ae 00 00 00       	jmp    80107f30 <allocuvm+0xc5>
  if(newsz < oldsz)
80107e82:	8b 45 10             	mov    0x10(%ebp),%eax
80107e85:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107e88:	73 08                	jae    80107e92 <allocuvm+0x27>
    return oldsz;
80107e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e8d:	e9 9e 00 00 00       	jmp    80107f30 <allocuvm+0xc5>

  a = PGROUNDUP(oldsz);
80107e92:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e95:	05 ff 0f 00 00       	add    $0xfff,%eax
80107e9a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107e9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107ea2:	eb 7d                	jmp    80107f21 <allocuvm+0xb6>
    mem = kalloc();
80107ea4:	e8 c1 ac ff ff       	call   80102b6a <kalloc>
80107ea9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107eac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107eb0:	75 2b                	jne    80107edd <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80107eb2:	83 ec 0c             	sub    $0xc,%esp
80107eb5:	68 69 89 10 80       	push   $0x80108969
80107eba:	e8 00 85 ff ff       	call   801003bf <cprintf>
80107ebf:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80107ec2:	83 ec 04             	sub    $0x4,%esp
80107ec5:	ff 75 0c             	pushl  0xc(%ebp)
80107ec8:	ff 75 10             	pushl  0x10(%ebp)
80107ecb:	ff 75 08             	pushl  0x8(%ebp)
80107ece:	e8 5f 00 00 00       	call   80107f32 <deallocuvm>
80107ed3:	83 c4 10             	add    $0x10,%esp
      return 0;
80107ed6:	b8 00 00 00 00       	mov    $0x0,%eax
80107edb:	eb 53                	jmp    80107f30 <allocuvm+0xc5>
    }
    memset(mem, 0, PGSIZE);
80107edd:	83 ec 04             	sub    $0x4,%esp
80107ee0:	68 00 10 00 00       	push   $0x1000
80107ee5:	6a 00                	push   $0x0
80107ee7:	ff 75 f0             	pushl  -0x10(%ebp)
80107eea:	e8 63 ce ff ff       	call   80104d52 <memset>
80107eef:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107ef2:	83 ec 0c             	sub    $0xc,%esp
80107ef5:	ff 75 f0             	pushl  -0x10(%ebp)
80107ef8:	e8 0d f6 ff ff       	call   8010750a <v2p>
80107efd:	83 c4 10             	add    $0x10,%esp
80107f00:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107f03:	83 ec 0c             	sub    $0xc,%esp
80107f06:	6a 06                	push   $0x6
80107f08:	50                   	push   %eax
80107f09:	68 00 10 00 00       	push   $0x1000
80107f0e:	52                   	push   %edx
80107f0f:	ff 75 08             	pushl  0x8(%ebp)
80107f12:	e8 21 fb ff ff       	call   80107a38 <mappages>
80107f17:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107f1a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f24:	3b 45 10             	cmp    0x10(%ebp),%eax
80107f27:	0f 82 77 ff ff ff    	jb     80107ea4 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80107f2d:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107f30:	c9                   	leave  
80107f31:	c3                   	ret    

80107f32 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107f32:	55                   	push   %ebp
80107f33:	89 e5                	mov    %esp,%ebp
80107f35:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107f38:	8b 45 10             	mov    0x10(%ebp),%eax
80107f3b:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107f3e:	72 08                	jb     80107f48 <deallocuvm+0x16>
    return oldsz;
80107f40:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f43:	e9 a5 00 00 00       	jmp    80107fed <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80107f48:	8b 45 10             	mov    0x10(%ebp),%eax
80107f4b:	05 ff 0f 00 00       	add    $0xfff,%eax
80107f50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107f58:	e9 81 00 00 00       	jmp    80107fde <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f60:	83 ec 04             	sub    $0x4,%esp
80107f63:	6a 00                	push   $0x0
80107f65:	50                   	push   %eax
80107f66:	ff 75 08             	pushl  0x8(%ebp)
80107f69:	e8 2a fa ff ff       	call   80107998 <walkpgdir>
80107f6e:	83 c4 10             	add    $0x10,%esp
80107f71:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80107f74:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107f78:	75 09                	jne    80107f83 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80107f7a:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80107f81:	eb 54                	jmp    80107fd7 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80107f83:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f86:	8b 00                	mov    (%eax),%eax
80107f88:	83 e0 01             	and    $0x1,%eax
80107f8b:	85 c0                	test   %eax,%eax
80107f8d:	74 48                	je     80107fd7 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80107f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f92:	8b 00                	mov    (%eax),%eax
80107f94:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f99:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80107f9c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107fa0:	75 0d                	jne    80107faf <deallocuvm+0x7d>
        panic("kfree");
80107fa2:	83 ec 0c             	sub    $0xc,%esp
80107fa5:	68 81 89 10 80       	push   $0x80108981
80107faa:	e8 ad 85 ff ff       	call   8010055c <panic>
      char *v = p2v(pa);
80107faf:	83 ec 0c             	sub    $0xc,%esp
80107fb2:	ff 75 ec             	pushl  -0x14(%ebp)
80107fb5:	e8 5d f5 ff ff       	call   80107517 <p2v>
80107fba:	83 c4 10             	add    $0x10,%esp
80107fbd:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80107fc0:	83 ec 0c             	sub    $0xc,%esp
80107fc3:	ff 75 e8             	pushl  -0x18(%ebp)
80107fc6:	e8 03 ab ff ff       	call   80102ace <kfree>
80107fcb:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80107fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107fd1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80107fd7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe1:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107fe4:	0f 82 73 ff ff ff    	jb     80107f5d <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80107fea:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107fed:	c9                   	leave  
80107fee:	c3                   	ret    

80107fef <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107fef:	55                   	push   %ebp
80107ff0:	89 e5                	mov    %esp,%ebp
80107ff2:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80107ff5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107ff9:	75 0d                	jne    80108008 <freevm+0x19>
    panic("freevm: no pgdir");
80107ffb:	83 ec 0c             	sub    $0xc,%esp
80107ffe:	68 87 89 10 80       	push   $0x80108987
80108003:	e8 54 85 ff ff       	call   8010055c <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108008:	83 ec 04             	sub    $0x4,%esp
8010800b:	6a 00                	push   $0x0
8010800d:	68 00 00 00 80       	push   $0x80000000
80108012:	ff 75 08             	pushl  0x8(%ebp)
80108015:	e8 18 ff ff ff       	call   80107f32 <deallocuvm>
8010801a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010801d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108024:	eb 4f                	jmp    80108075 <freevm+0x86>
    if(pgdir[i] & PTE_P){
80108026:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108029:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108030:	8b 45 08             	mov    0x8(%ebp),%eax
80108033:	01 d0                	add    %edx,%eax
80108035:	8b 00                	mov    (%eax),%eax
80108037:	83 e0 01             	and    $0x1,%eax
8010803a:	85 c0                	test   %eax,%eax
8010803c:	74 33                	je     80108071 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
8010803e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108041:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108048:	8b 45 08             	mov    0x8(%ebp),%eax
8010804b:	01 d0                	add    %edx,%eax
8010804d:	8b 00                	mov    (%eax),%eax
8010804f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108054:	83 ec 0c             	sub    $0xc,%esp
80108057:	50                   	push   %eax
80108058:	e8 ba f4 ff ff       	call   80107517 <p2v>
8010805d:	83 c4 10             	add    $0x10,%esp
80108060:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108063:	83 ec 0c             	sub    $0xc,%esp
80108066:	ff 75 f0             	pushl  -0x10(%ebp)
80108069:	e8 60 aa ff ff       	call   80102ace <kfree>
8010806e:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108071:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108075:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
8010807c:	76 a8                	jbe    80108026 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
8010807e:	83 ec 0c             	sub    $0xc,%esp
80108081:	ff 75 08             	pushl  0x8(%ebp)
80108084:	e8 45 aa ff ff       	call   80102ace <kfree>
80108089:	83 c4 10             	add    $0x10,%esp
}
8010808c:	c9                   	leave  
8010808d:	c3                   	ret    

8010808e <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
8010808e:	55                   	push   %ebp
8010808f:	89 e5                	mov    %esp,%ebp
80108091:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108094:	83 ec 04             	sub    $0x4,%esp
80108097:	6a 00                	push   $0x0
80108099:	ff 75 0c             	pushl  0xc(%ebp)
8010809c:	ff 75 08             	pushl  0x8(%ebp)
8010809f:	e8 f4 f8 ff ff       	call   80107998 <walkpgdir>
801080a4:	83 c4 10             	add    $0x10,%esp
801080a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
801080aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801080ae:	75 0d                	jne    801080bd <clearpteu+0x2f>
    panic("clearpteu");
801080b0:	83 ec 0c             	sub    $0xc,%esp
801080b3:	68 98 89 10 80       	push   $0x80108998
801080b8:	e8 9f 84 ff ff       	call   8010055c <panic>
  *pte &= ~PTE_U;
801080bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c0:	8b 00                	mov    (%eax),%eax
801080c2:	83 e0 fb             	and    $0xfffffffb,%eax
801080c5:	89 c2                	mov    %eax,%edx
801080c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ca:	89 10                	mov    %edx,(%eax)
}
801080cc:	c9                   	leave  
801080cd:	c3                   	ret    

801080ce <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801080ce:	55                   	push   %ebp
801080cf:	89 e5                	mov    %esp,%ebp
801080d1:	53                   	push   %ebx
801080d2:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801080d5:	e8 f0 f9 ff ff       	call   80107aca <setupkvm>
801080da:	89 45 f0             	mov    %eax,-0x10(%ebp)
801080dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801080e1:	75 0a                	jne    801080ed <copyuvm+0x1f>
    return 0;
801080e3:	b8 00 00 00 00       	mov    $0x0,%eax
801080e8:	e9 f6 00 00 00       	jmp    801081e3 <copyuvm+0x115>
  for(i = 0; i < sz; i += PGSIZE){
801080ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801080f4:	e9 c6 00 00 00       	jmp    801081bf <copyuvm+0xf1>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801080f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080fc:	83 ec 04             	sub    $0x4,%esp
801080ff:	6a 00                	push   $0x0
80108101:	50                   	push   %eax
80108102:	ff 75 08             	pushl  0x8(%ebp)
80108105:	e8 8e f8 ff ff       	call   80107998 <walkpgdir>
8010810a:	83 c4 10             	add    $0x10,%esp
8010810d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108110:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108114:	75 0d                	jne    80108123 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80108116:	83 ec 0c             	sub    $0xc,%esp
80108119:	68 a2 89 10 80       	push   $0x801089a2
8010811e:	e8 39 84 ff ff       	call   8010055c <panic>
    if(!(*pte & PTE_P))
80108123:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108126:	8b 00                	mov    (%eax),%eax
80108128:	83 e0 01             	and    $0x1,%eax
8010812b:	85 c0                	test   %eax,%eax
8010812d:	75 0d                	jne    8010813c <copyuvm+0x6e>
      panic("copyuvm: page not present");
8010812f:	83 ec 0c             	sub    $0xc,%esp
80108132:	68 bc 89 10 80       	push   $0x801089bc
80108137:	e8 20 84 ff ff       	call   8010055c <panic>
    pa = PTE_ADDR(*pte);
8010813c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010813f:	8b 00                	mov    (%eax),%eax
80108141:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108146:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108149:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010814c:	8b 00                	mov    (%eax),%eax
8010814e:	25 ff 0f 00 00       	and    $0xfff,%eax
80108153:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108156:	e8 0f aa ff ff       	call   80102b6a <kalloc>
8010815b:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010815e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108162:	75 02                	jne    80108166 <copyuvm+0x98>
      goto bad;
80108164:	eb 6a                	jmp    801081d0 <copyuvm+0x102>
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108166:	83 ec 0c             	sub    $0xc,%esp
80108169:	ff 75 e8             	pushl  -0x18(%ebp)
8010816c:	e8 a6 f3 ff ff       	call   80107517 <p2v>
80108171:	83 c4 10             	add    $0x10,%esp
80108174:	83 ec 04             	sub    $0x4,%esp
80108177:	68 00 10 00 00       	push   $0x1000
8010817c:	50                   	push   %eax
8010817d:	ff 75 e0             	pushl  -0x20(%ebp)
80108180:	e8 8c cc ff ff       	call   80104e11 <memmove>
80108185:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108188:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010818b:	83 ec 0c             	sub    $0xc,%esp
8010818e:	ff 75 e0             	pushl  -0x20(%ebp)
80108191:	e8 74 f3 ff ff       	call   8010750a <v2p>
80108196:	83 c4 10             	add    $0x10,%esp
80108199:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010819c:	83 ec 0c             	sub    $0xc,%esp
8010819f:	53                   	push   %ebx
801081a0:	50                   	push   %eax
801081a1:	68 00 10 00 00       	push   $0x1000
801081a6:	52                   	push   %edx
801081a7:	ff 75 f0             	pushl  -0x10(%ebp)
801081aa:	e8 89 f8 ff ff       	call   80107a38 <mappages>
801081af:	83 c4 20             	add    $0x20,%esp
801081b2:	85 c0                	test   %eax,%eax
801081b4:	79 02                	jns    801081b8 <copyuvm+0xea>
      goto bad;
801081b6:	eb 18                	jmp    801081d0 <copyuvm+0x102>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801081b8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801081bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081c2:	3b 45 0c             	cmp    0xc(%ebp),%eax
801081c5:	0f 82 2e ff ff ff    	jb     801080f9 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
801081cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081ce:	eb 13                	jmp    801081e3 <copyuvm+0x115>

bad:
  freevm(d);
801081d0:	83 ec 0c             	sub    $0xc,%esp
801081d3:	ff 75 f0             	pushl  -0x10(%ebp)
801081d6:	e8 14 fe ff ff       	call   80107fef <freevm>
801081db:	83 c4 10             	add    $0x10,%esp
  return 0;
801081de:	b8 00 00 00 00       	mov    $0x0,%eax
}
801081e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801081e6:	c9                   	leave  
801081e7:	c3                   	ret    

801081e8 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801081e8:	55                   	push   %ebp
801081e9:	89 e5                	mov    %esp,%ebp
801081eb:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801081ee:	83 ec 04             	sub    $0x4,%esp
801081f1:	6a 00                	push   $0x0
801081f3:	ff 75 0c             	pushl  0xc(%ebp)
801081f6:	ff 75 08             	pushl  0x8(%ebp)
801081f9:	e8 9a f7 ff ff       	call   80107998 <walkpgdir>
801081fe:	83 c4 10             	add    $0x10,%esp
80108201:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108204:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108207:	8b 00                	mov    (%eax),%eax
80108209:	83 e0 01             	and    $0x1,%eax
8010820c:	85 c0                	test   %eax,%eax
8010820e:	75 07                	jne    80108217 <uva2ka+0x2f>
    return 0;
80108210:	b8 00 00 00 00       	mov    $0x0,%eax
80108215:	eb 29                	jmp    80108240 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80108217:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010821a:	8b 00                	mov    (%eax),%eax
8010821c:	83 e0 04             	and    $0x4,%eax
8010821f:	85 c0                	test   %eax,%eax
80108221:	75 07                	jne    8010822a <uva2ka+0x42>
    return 0;
80108223:	b8 00 00 00 00       	mov    $0x0,%eax
80108228:	eb 16                	jmp    80108240 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
8010822a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010822d:	8b 00                	mov    (%eax),%eax
8010822f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108234:	83 ec 0c             	sub    $0xc,%esp
80108237:	50                   	push   %eax
80108238:	e8 da f2 ff ff       	call   80107517 <p2v>
8010823d:	83 c4 10             	add    $0x10,%esp
}
80108240:	c9                   	leave  
80108241:	c3                   	ret    

80108242 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108242:	55                   	push   %ebp
80108243:	89 e5                	mov    %esp,%ebp
80108245:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108248:	8b 45 10             	mov    0x10(%ebp),%eax
8010824b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
8010824e:	eb 7f                	jmp    801082cf <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80108250:	8b 45 0c             	mov    0xc(%ebp),%eax
80108253:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108258:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
8010825b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010825e:	83 ec 08             	sub    $0x8,%esp
80108261:	50                   	push   %eax
80108262:	ff 75 08             	pushl  0x8(%ebp)
80108265:	e8 7e ff ff ff       	call   801081e8 <uva2ka>
8010826a:	83 c4 10             	add    $0x10,%esp
8010826d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108270:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108274:	75 07                	jne    8010827d <copyout+0x3b>
      return -1;
80108276:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010827b:	eb 61                	jmp    801082de <copyout+0x9c>
    n = PGSIZE - (va - va0);
8010827d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108280:	2b 45 0c             	sub    0xc(%ebp),%eax
80108283:	05 00 10 00 00       	add    $0x1000,%eax
80108288:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
8010828b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010828e:	3b 45 14             	cmp    0x14(%ebp),%eax
80108291:	76 06                	jbe    80108299 <copyout+0x57>
      n = len;
80108293:	8b 45 14             	mov    0x14(%ebp),%eax
80108296:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108299:	8b 45 0c             	mov    0xc(%ebp),%eax
8010829c:	2b 45 ec             	sub    -0x14(%ebp),%eax
8010829f:	89 c2                	mov    %eax,%edx
801082a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801082a4:	01 d0                	add    %edx,%eax
801082a6:	83 ec 04             	sub    $0x4,%esp
801082a9:	ff 75 f0             	pushl  -0x10(%ebp)
801082ac:	ff 75 f4             	pushl  -0xc(%ebp)
801082af:	50                   	push   %eax
801082b0:	e8 5c cb ff ff       	call   80104e11 <memmove>
801082b5:	83 c4 10             	add    $0x10,%esp
    len -= n;
801082b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082bb:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
801082be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082c1:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
801082c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082c7:	05 00 10 00 00       	add    $0x1000,%eax
801082cc:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801082cf:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801082d3:	0f 85 77 ff ff ff    	jne    80108250 <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801082d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801082de:	c9                   	leave  
801082df:	c3                   	ret    
