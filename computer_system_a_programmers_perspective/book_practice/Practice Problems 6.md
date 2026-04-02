## Problem 1
|Organization | r  | c  | br | bc | max(br,bc) |
| ----------- | -- | -- | -- | -- | ---------- |
|16×1         | 4  | 4  | 2  | 2  | 2          | 
|16×4         | 4  | 4  | 2  | 2  | 2          | 
|128×8        | 16 | 8  | 4  | 3  | 4          | 
|512×4        | 32 | 16 | 5  | 4  | 5          | 
|1,024×4      | 32 | 32 | 5  | 5  | 5          | 

## Problem 2
46.08 Gb
## Problem 3
7.516 ms
## Problem 4
A. Best case: In the optimal case, the blocks are mapped to contiguous sectors,
on the same cylinder, that can be read one after the other without moving
the head. Once the head is positioned over the first sector it takes two full
rotations (5,000 sectors per rotation) of the disk to read all 10,000 blocks.
So the total time to read the file is Tavgseek + Tavgrotation + 2 × Tmaxrotation =
6 +2.30+9.22=17.52ms.
B. Random case: In this case, where blocks are mapped randomly to sectors,
reading each of the 10,000 blocks requires Tavgseek + Tavgrotation ms, so the
total time to read the file is (Tavgseek + Tavgrotation) × 10,000 = 83,000 ms
(83 seconds!).
## Problem 5
A.Worst-case sequential writes(520MB/s):
(109×128)×(1/520)×(1/(86,400×365))≈7years
B. Worst-case random writes(205MB/s):
(109×128)×(1/205)×(1/(86,400×365))≈19years
C. Average case(50GB/day):
(109×128)×(1/50,000)×(1/365)≈6,912years
## Problem 6
$200 to 2027
## Problem 7
intproductarray3d(inta[N][N][N])
{
    inti,j,k,product=1;
    for(j=N-1;j>=0;j--){
        for(k=N-1;k>=0;k--){
            for(i=N-1;i>=0;i--){
                product*=a[j][k][i];
            }
        }
    }
    returnproduct;
}
## Problem 8
So clear3 exhibits worse spatial locality than clear2 and clear1.
## Problem 9
![alt text](image.png)
## Problem 10
The padding eliminates the conflict misses. Thus, three-fourths of the references
are hits.
## Problem 11
A. With high-order bit indexing, each contiguous array chunk consists of 2t
blocks, where t is the number of tag bits. Thus, the first 2t contiguous blocks
of the array would map to set 0, the next 2t blocks would map to set 1, and
so on.
B. For a direct-mapped cache where (S,E,B,m)=(512,1,32,32), the cache
capacity is 51232-byteblockswitht = 18tagbitsineachcacheline.Thus,the
f
irst 218 blocks in the array would map to set 0, the next 218 blocks to set 1.
Since ourarrayconsists ofonly(4,096 × 4)/32 =512blocks,alloftheblocks
in the array map to set 0. Thus, the cache will hold at most 1 array block at
any point in time, even though the array is small enough to fit entirely in the
cache. Clearly, using high-order bit indexing makes poor use of the cache.
## Problem 12
![alt text](image-1.png)
## Problem 13
![alt text](image-2.png)
## Problem 14
![alt text](image-3.png)
## Problem 15
![alt text](image-4.png)
## Problem 16
0x064C,0x064D,0x064E, and0x064F
## Problem 17
![alt text](image-5.png)
## Problem 18
A. What is the total number of read accesses? 2,048 reads.
B. What is the total number of read accesses that miss in the cache ?1,024misses.
C. What is the miss rate? 1024/2048=50%
## Problem 19
A. What is the total number of read accesses? 2,048 reads.
B. What is the total number of read accesses that miss in the cache ?1,024misses.
C. What is the miss rate? 1024/2048=50%
D. What would the hit rate be if the cache were twice as big? If the cache were
twice as big, it could hold the entire grid array. The only misses would be
the initial cold misses, and the hit rate would be 3/4 = 75%.
## Problem 20
Whatis the total number of read accesses? 2,048 reads.
B. What is the total number of read accesses that hit in the cache? 1,536misses.
C. What is the hit rate? 1536/2048 =75%.
D. What would the hit rate be if the cache were twice as big? Increasing the
cache size by any amount would not change the miss rate, since cold misses
are unavoidable
## Problem 21
The sustained throughput using large strides from L1 is about 12,000 MB/s, the
clock frequency is 2,100 MHz, and the individual read accesses are in units
of 16-byte longs. Thus, from this graph we can estimate that it takes roughly
2,100/12,000 × 16 = 2.8 ≈ 3.0 cycles to access a word from L1 on this machine,
which is roughly 1.25 times faster than the nominal 4-cycle latency from L1. This
is due to the parallelism of the 4 × 4 unrolled loop, which allows multiple loads to
be in flight at the same time.
