/*
 * mm-naive.c - The fastest, least memory-efficient malloc package.
 * 
 * In this naive approach, a block is allocated by simply incrementing
 * the brk pointer.  A block is pure payload. There are no headers or
 * footers.  Blocks are never coalesced or reused. Realloc is
 * implemented directly using mm_malloc and mm_free.
 *
 * NOTE TO STUDENTS: Replace this header comment with your own header
 * comment that gives a high level description of your solution.
 */
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <unistd.h>
#include <string.h>

#include "mm.h"
#include "memlib.h"

/*********************************************************
 * NOTE TO STUDENTS: Before you do anything else, please
 * provide your team information in the following struct.
 ********************************************************/
team_t team = {
    /* Team name */
    "ateam",
    /* First member's full name */
    "Ilya Konovalov",
    /* First member's email address */
    "bovik@cs.cmu.edu",
    /* Second member's full name (leave blank if none) */
    "",
    /* Second member's email address (leave blank if none) */
    ""
};

/* single word (4) or double word (8) alignment */
#define ALIGNMENT 8

/* rounds up to the nearest multiple of ALIGNMENT */
#define ALIGN(size) (((size) + (ALIGNMENT-1)) & ~0x7)


#define SIZE_T_SIZE (ALIGN(sizeof(size_t)))

/* Basic constants and macros */
#define WSIZE       4           /* word size (bytes) */
#define DSIZE       8           /* double word size (bytes) */
#define CHUNKSIZE   (1 << 12)   /* initial heap size (4 KB) – adjust as needed */

/* Pack a size and allocated bit into a word */
#define PACK(size, alloc)  ((size) | (alloc))

/* Read/write a word at address p */
#define GET(p)       (*(unsigned int *)(p))
#define PUT(p, val)  (*(unsigned int *)(p) = (val))

/* Get the size and allocated fields from a header/footer */
#define GET_SIZE(p)  (GET(p) & ~0x7)
#define GET_ALLOC(p) (GET(p) & 0x1)

/* Given a block pointer bp (to payload), compute addresses of header, footer, and next/prev blocks */
#define HDRP(bp)       ((char *)(bp) - WSIZE)
#define FTRP(bp)       ((char *)(bp) + GET_SIZE(HDRP(bp)) - DSIZE)
#define NEXT_BLKP(bp)  ((char *)(bp) + GET_SIZE(HDRP(bp)))
#define PREV_BLKP(bp)  ((char *)(bp) - GET_SIZE((char *)(bp) - DSIZE))

static char *heap_listp = NULL;   /* points to the first byte of the heap (the prologue block) */

static void *extend_heap(size_t words);
static void *coalesce(void *bp);
static void *find_fit(size_t asize);
static void place(void *bp, size_t asize);



/* 
 * mm_init - initialize the malloc package.
 */
int mm_init(void) {
    /* Create the initial heap: 4 words (16 bytes) for prologue and epilogue */
    if ((heap_listp = mem_sbrk(4 * WSIZE)) == (void *)-1)
        return -1;

    /* Set up the prologue block (size = DSIZE, allocated) and epilogue header */
    PUT(heap_listp, 0);                          /* alignment padding */
    PUT(heap_listp + (1 * WSIZE), PACK(DSIZE, 1)); /* prologue header */
    PUT(heap_listp + (2 * WSIZE), PACK(DSIZE, 1)); /* prologue footer */
    PUT(heap_listp + (3 * WSIZE), PACK(0, 1));     /* epilogue header */

    /* heap_listp now points to the prologue footer (the start of the first free block) */
    heap_listp += (2 * WSIZE);

    /* Extend the heap with an initial free block */
    if (extend_heap(CHUNKSIZE / WSIZE) == NULL)
        return -1;

    return 0;
}

/* 
 * mm_malloc - Allocate a block by incrementing the brk pointer.
 *     Always allocate a block whose size is a multiple of the alignment.
 */
void *mm_malloc(size_t size) {
    size_t asize;      /* adjusted block size (includes header/footer) */
    size_t extendsize; /* amount to extend heap if no fit */
    char *bp;

    /* Ignore spurious requests */
    if (size == 0)
        return NULL;

    /* Adjust block size to include header/footer and alignment */
    asize = ALIGN(size + DSIZE);
    /* Minimum block size is DSIZE (8 bytes) – already satisfied by ALIGN */

    /* Search the free list for a fit */
    if ((bp = find_fit(asize)) != NULL) {
        place(bp, asize);
        return bp;
    }

    /* No fit found. Get more memory and place the block */
    extendsize = (asize > CHUNKSIZE) ? asize : CHUNKSIZE;
    if ((bp = extend_heap(extendsize / WSIZE)) == NULL)
        return NULL;
    place(bp, asize);
    return bp;
}

/*
 * mm_free - Freeing a block does nothing.
 */
void mm_free(void *ptr) {
    if (ptr == NULL)
        return;

    size_t size = GET_SIZE(HDRP(ptr));
    /* Mark the block as free */
    PUT(HDRP(ptr), PACK(size, 0));
    PUT(FTRP(ptr), PACK(size, 0));
    /* Merge with adjacent free blocks */
    coalesce(ptr);
}
/*
 * mm_realloc - Implemented simply in terms of mm_malloc and mm_free
 */
void *mm_realloc(void *ptr, size_t size) {
    void *newptr;
    size_t oldsize;
    size_t asize;

    /* If ptr is NULL, behave like malloc */
    if (ptr == NULL)
        return mm_malloc(size);

    /* If size == 0, behave like free and return NULL */
    if (size == 0) {
        mm_free(ptr);
        return NULL;
    }

    /* Compute the adjusted size (includes header/footer) */
    asize = ALIGN(size + DSIZE);
    oldsize = GET_SIZE(HDRP(ptr));

    /* If the current block already fits, nothing to do */
    if (oldsize >= asize) {
        /* Optional: could shrink the block, but we leave it as is */
        return ptr;
    }

    /* Try to expand the block in place (check next block) */
    if (!GET_ALLOC(HDRP(NEXT_BLKP(ptr))) &&
        (oldsize + GET_SIZE(HDRP(NEXT_BLKP(ptr))) >= asize)) {
        /* Merge with the next free block */
        size_t newsize = oldsize + GET_SIZE(HDRP(NEXT_BLKP(ptr)));
        PUT(HDRP(ptr), PACK(newsize, 1));
        PUT(FTRP(ptr), PACK(newsize, 1));
        return ptr;
    }

    /* Otherwise allocate a new block and copy the data */
    newptr = mm_malloc(size);
    if (newptr == NULL)
        return NULL;

    /* Copy the old data (min of old and new sizes) */
    memcpy(newptr, ptr, (oldsize - DSIZE) < size ? (oldsize - DSIZE) : size);
    mm_free(ptr);
    return newptr;
}


/*
 * extend_heap - Extend the heap by `words` words (rounded up to an even number)
 *               and return a pointer to the payload of the new free block.
 */
static void *extend_heap(size_t words) {
    char *bp;
    size_t size;

    /* Allocate an even number of words to maintain alignment */
    size = (words % 2) ? (words + 1) * WSIZE : words * WSIZE;
    if ((bp = mem_sbrk(size)) == (void *)-1)
        return NULL;

    /* Initialize the new free block */
    PUT(HDRP(bp), PACK(size, 0));   /* header */
    PUT(FTRP(bp), PACK(size, 0));   /* footer */
    /* Set the epilogue header (the block after the new free block) */
    PUT(HDRP(NEXT_BLKP(bp)), PACK(0, 1));

    /* Coalesce with previous free block if possible */
    return coalesce(bp);
}


/*
 * coalesce - Merge adjacent free blocks (previous and/or next) and return a
 *            pointer to the payload of the merged block.
 */
static void *coalesce(void *bp) {
    size_t prev_alloc = GET_ALLOC(FTRP(PREV_BLKP(bp)));
    size_t next_alloc = GET_ALLOC(HDRP(NEXT_BLKP(bp)));
    size_t size = GET_SIZE(HDRP(bp));

    if (prev_alloc && next_alloc) {
        /* No merge – nothing to do */
        return bp;
    }
    else if (prev_alloc && !next_alloc) {
        /* Merge with next */
        size += GET_SIZE(HDRP(NEXT_BLKP(bp)));
        PUT(HDRP(bp), PACK(size, 0));
        PUT(FTRP(bp), PACK(size, 0));
    }
    else if (!prev_alloc && next_alloc) {
        /* Merge with previous */
        size += GET_SIZE(HDRP(PREV_BLKP(bp)));
        PUT(FTRP(bp), PACK(size, 0));
        PUT(HDRP(PREV_BLKP(bp)), PACK(size, 0));
        bp = PREV_BLKP(bp);
    }
    else {
        /* Merge with both previous and next */
        size += GET_SIZE(HDRP(PREV_BLKP(bp))) + GET_SIZE(HDRP(NEXT_BLKP(bp)));
        PUT(HDRP(PREV_BLKP(bp)), PACK(size, 0));
        PUT(FTRP(NEXT_BLKP(bp)), PACK(size, 0));
        bp = PREV_BLKP(bp);
    }

    return bp;
}

/*
 * find_fit - Simple first‑fit search. Return a pointer to the payload of a
 *            free block that can hold at least `asize` bytes, or NULL if none.
 */
static void *find_fit(size_t asize) {
    void *bp;

    for (bp = heap_listp + DSIZE; GET_SIZE(HDRP(bp)) > 0; bp = NEXT_BLKP(bp)) {
        if (!GET_ALLOC(HDRP(bp)) && (GET_SIZE(HDRP(bp)) >= asize))
            return bp;
    }
    return NULL;
}

/*
 * place - Place a block of size `asize` at `bp`. If the remaining free space
 *         is at least the minimum block size (DSIZE), split the block.
 */
static void place(void *bp, size_t asize) {
    size_t csize = GET_SIZE(HDRP(bp));

    if ((csize - asize) >= DSIZE) {
        /* Split the block */
        PUT(HDRP(bp), PACK(asize, 1));
        PUT(FTRP(bp), PACK(asize, 1));
        bp = NEXT_BLKP(bp);
        PUT(HDRP(bp), PACK(csize - asize, 0));
        PUT(FTRP(bp), PACK(csize - asize, 0));
    } else {
        /* Use the whole block */
        PUT(HDRP(bp), PACK(csize, 1));
        PUT(FTRP(bp), PACK(csize, 1));
    }
}