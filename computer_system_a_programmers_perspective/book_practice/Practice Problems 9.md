## Problem 1

| Number of<br>address bits (n) | Number of  virtual addresses (N) | Largest possible virtual address |
| ----------------------------- | -------------------------------- | -------------------------------- |
| 4                             | 16                               | 15                               |
| 14                            | 16K                              | 16K - 1                          |
| 24                            | 16M                              | 16M - 1                          |
| 46                            | 64T                              | 64T - 1                          |
| 54                            | 16P                              | 16P - 1                          |

## Problem 2

| n   | P = 2^p | Number of PTEs |
| --- | ------- | -------------- |
| 12  | 1K      | 4              |
| 16  | 16K     | 4              |
| 24  | 2M      | 8              |
| 36  | 1G      | 64             |

## Problem 3

| p     | VPN bits | VPO bits | PPN bits | PPO bits |
| ----- | -------- | -------- | -------- | -------- |
| 1 KB  | 54       | 10       | 22       | 10       |
| 2 KB  | 53       | 11       | 21       | 11       |
| 4 KB  | 52       | 12       | 20       | 12       |
| 16 KB | 50       | 14       | 18       | 14       |

## Problem 4
A. 00 0011 1101 0111
B. 

| Parameter         | Value |
| ----------------- | ----- |
| VPN               | 0xf   |
| TLB index         | 0x3   |
| TLB tag           | 0x3   |
| TLB hit? (Y/N)    | Y     |
| Page fault? (Y/N) | N     |
| PPN               | 0xd   |

C. 0011 0101 0111
D. 

| Parameter           | Value |
| ------------------- | ----- |
| Byte offset         | 0x3   |
| Cache index         | 0x5   |
| Cache tag           | 0xd   |
| Cache hit? (Y/N)    | Y     |
| Cache byte returned |  0x1d |

## Problem 5
``` c
#include "csapp.h"

/*
 * mmapcopy - uses mmap to copy file fd to stdout
 */
void mmapcopy(int fd, int size) {
	char *bufp;
	bufp = Mmap(NULL, size, PROT_READ, MAP_PRIVATE, fd,0);
	Write(1, bifp, size);
	return;
}

/* mmapcopy driver */
int main(int argc, char **argv) {
	struct stat stat;
	int fd;
	if (args != 2) {
		printf("usage: %s <filename>\n", argv[0])
		exit(0);
	}
	fd = Open(argv[1], O_RDONLY, 0);
	fstat(fd, &stat);
	mmapcopy(fd, stat_st_size);
	exit(0);
}
```
## Problem 6

| Request    | Block Size | Block Header |
| ---------- | ---------- | ------------ |
| malloc(2)  | 8          | 0x9          |
| malloc(9)  | 16         | 0x11         |
| malloc(15) | 24         | 0x19         |
| malloc(20) | 24         | 0x19         |

## Problem 7

| Aligment    | Allocated block      | Free block        | Min size |
| ----------- | -------------------- | ----------------- | -------- |
| Single word | Header and footer    | Header and footer | 12       |
| Single word | Header but no footer | Header and footer | 8        |
| Double word | Header and footer    | Header and footer | 16       |
| Double word | Header but no footer | Header and footer | 8        |

## Problem 8
``` c
static void *find_fit(size_t asize) {
	void *bp;
	for (bp = heap_listp; GET_SIZE(HDRP(bp)) > 0: bp = NEXT_BLKP(bp)) {
		if (!GET_ALLOC(HDRP(bp)) && (asize <= GET_SIZE(HDRP(bp)))) {
			return bp;
		}
	}
	return NULL;
}
```
## Problem 9
```c 
static void place(void *bp, size_t asize) {
	size_t csize  = GET_SIZE(HDRP(bp));
	
	if ((csize - asize) >= (2*DSIZE)) {
		PUT(HDRP(bp), PACK(asize, 1))
		PUT(FTRP(bp), PACK(asize, 1))
		bp = NEXT_BLKP(bp);
		PUT(HDRP(bp), PACK(csize - asize, 0))
		PUT(FTRP(bp), PACK(csize - asize, 0))
	} else {
		PUT(HDRP(bp), PACK(csize, 1))
		PUT(FTRP(bp), PACK(csize, 1))
	}
}
```
## Problem 10
Here is one pattern that will cause external fragmentation: The application makes
numerous allocation and free requests to the first size class, followed by numer-
ous allocation and free requests to the second size class, followed by numerous
allocation and free requests to the third size class, and so on. For each size class,
the allocator creates a lot of memory that is never reclaimed because the allocator
doesn’t coalesce, and because the application never requests blocks from that size
class again.
