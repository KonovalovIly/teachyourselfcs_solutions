# Chapter 3.4
## Problem 1

| Operand        | Value |
| -------------- | ----- |
| %rax           | 0x100 |
| 0x104          | 0xAB  |
| $0x108         | 0x108 |
| (%rax)         | 0xFF  |
| 4(%rax)        | 0xAB  |
| 9(%rax,%rdx)   | 0x11  |
| 260(%rcx,%rdx) | 0x13  |
| 0xFC(,%rcx,4)  | 0xFF  |
| (%rax,%rdx,4)  | 0x11  |
## Problem 2
movl %eax, (%rsp) 
movw (%rax), %dx 
movb $0xFF, %bl 
movb (%rsp,%rdx,4), %dl 
movq (%rdx), %rax 
movw %dx, (%rax)

## Problem 3
movb $0xF, (%ebx) 
- **Error**: In x86-64, you cannot use a 32-bit register (`%ebx`) as a memory address. Memory addresses must be specified using 64-bit registers (like `%rbx`).
- **Fix**: Use `%rbx` instead of `%ebx`.

movl %rax, (%rsp)
- **Error**: The source operand `%rax` is a 64-bit register, but the instruction uses the `movl` (32-bit) suffix.
- **Fix**: Use `movq` to move 64 bits, or use `%eax` as the source if you want to move 32 bits.

movw (%rax),4(%rsp)
- **Error**: This instruction has two memory operands: `(%rax)` and `4(%rsp)`. x86 architecture does not allow moving data directly from memory to memory (except with special instructions like `movs`). There must be exactly one memory operand in a `mov` instruction.
- **Fix**: Use a register as an intermediate, e.g., `movw (%rax), %temp_reg; movw %temp_reg, 4(%rsp)`.

movb %al,%sl
- **Error**: `%sl` is not a valid register name.
- **Fix**: Probably a typo. Maybe intended to be `%sil` (the low byte of `%rsi`).

movq %rax,$0x123
- **Error**: The destination operand is an immediate value (`$0x123`), which is not allowed.
- **Fix**: Swap the operands if you meant to move the immediate into `%rax`: `movq $0x123, %rax`. Or if you meant to store `%rax` at address `0x123`, use `movq %rax, 0x123` (without the `$`).

movl %eax,%rdx
- **Error**: The source is a 32-bit register (`%eax`) and the destination is a 64-bit register (`%rdx`). 
- **Fix**: Use `movzbl %eax, %edx` (which zero-extends to `%rdx`)

movb %si, 8(%rbp)
- **Error**: The source operand `%si` is a 16-bit register, but the instruction uses the `movb` (8-bit) suffix. This is a size mismatch.
- **Fix**: Use `movw` to move 16 bits: `movw %si, 8(%rbp)`.

## Problem 4

| src_t                 | dest_t                | Instructions                           |
| --------------------- | --------------------- | -------------------------------------- |
| long                  | long                  | movq(%rdi), %rax; movq(%rdi), %rax     |
| char(1 byte)          | int(4 bytes)          | movsbq (%rdi), %rax; movl %eax, (%rsi) |
| char(1 byte)          | unsigned(4 bytes)     | movsbq (%rdi), %rax; movl %eax, (%rsi) |
| unsigned char(1 byte) | long(8 bytes)         | movzbq (%rdi), %rax; movq %rax, (%rsi) |
| int(4 bytes)          | char(1 byte)          | movl (%rdi), %eax; movb %al, (%rsi)    |
| unsigned(4 bytes)     | unsigned char(1 byte) | movl (%rdi), %eax; movb %al, (%rsi)    |
| char(1 byte)          | short(2 bytes)        | movsbq (%rdi), %rax; movw %ax, (%rsi)  |

## Problem 5
xp in %rdi, 
yp in %rsi, 
zp in %rdx
``` c
void decode1(long *xp, long *yp, long *zp) {
	long x = *xp//movq (%rdi), %r8 
	long y = *yp//movq (%rsi), %rcx 
	long z = *zp//movq (%rdx), %rax 
	*yp = x//movq %r8, (%rsi) 
	*zp = y//movq %rcx, (%rdx) 
	*xp = z//movq %rax, (%rdi)
}
```
# Chapter 3.5
## Problem 6
%rdx = q  
%rbx = p  
  
leaq 9(%rdx), %rax = 9p  
leaq (%rdx, %rbx), %rax = p + q  
leaq (%rdx, %rbx, 3), %rax = p + 3q  
leaq 2(%rbx, %rbx, 7), %rax = 8q + 2  
leaq 0xE(,%rdx, 3), %rax = 3q + 14
## Problem 7
x = %rdi  
y = %rsi  
z = %rdx  
  
t = 10y + z + x\*y

## Problem 8

| Instruction             | Destination           | Value              |
| ----------------------- | --------------------- | ------------------ |
| addq %rcx,(%rax)        | 0x100                 | 0x100              |
| subq %rdx,8(%rax)       | 0x100 + 0x8           | 0x100              |
| imulq $16,(%rax,%rdx,8) | 0x100 + 3 * 8 = 0x118 | 0x110              |
| incq 16(%rax)           | 0x110                 | 0x14               |
| decq %rcx               | %rcx                  | 0x0                |
| subq %rdx,%rax          | %rax                  | 0x100 - 0x3 = 0xFD |

## Problem 9
long shift_left4_rightn(long x, long n)
x in %rdi, n in %rsi 
shift_left4_rightn: 
movq %rdi, %rax    //Get x 
shlq $4, %rax           //x <<= 4 
movl %esi, %ecx    //Get n 
sarq %cl, %rax     //(4 bytes) x >>= n

## Problem 10
``` c
short arith3(short x, short y, short z) { 
	short p1 = z | y; 
	short p2 = p1 >> 9; 
	short p3 = ~p2; 
	short p4 = p3 - y; 
	return p4; 
}
```
## Problem 11
A. The instruction `xorq %rcx, %rcx` sets the register `%rcx` to zero. 
B. movq $0, %rcx
C.
- `xorq %rcx, %rcx` encodes in 3 bytes.
- `movq $0, %rcx` encodes in 7 bytes.
- The XOR method is shorter by 4 bytes.
## Problem 12
``` asm
uremdiv:
    movq    %rdx, %r8       # Save qp (because %rdx will be used by divq)
    movq    %rdi, %rax      # Move x to %rax (dividend low)
    movl    $0, %edx        # Zero extend %rax to 128 bits (set high bits to 0)
    divq    %rsi            # Divide (%rdx:%rax) by y (in %rsi)
                            # Quotient in %rax, remainder in %rdx
    movq    %rax, (%r8)     # Store quotient at *qp
    movq    %rdx, (%rcx)    # Store remainder at *rp
    ret
```
# Chapter 3.6
## Problem 13
**A.**
- `data_t`: `int` (signed 32-bit integer)
- `COMP`: `<`

**B.**
- `data_t`: `short` (signed 16-bit integer)
- `COMP`: `>=`
**C.**
- `data_t`: `unsigned char` (or `char` with unsigned semantics)
- `COMP`: `<=`
**D.**
- `data_t`: `long`, `unsigned long`, `long long`, `unsigned long long`, or any pointer type (64-bit)
- `COMP`: `!=`
## Problem 14
**A.**
- `data_t`: `long` (signed) or `long long` (signed)
- `TEST`: >=

**B.**
- `data_t`: `short` or `unsigned short`
- `TEST`: ==
    

**C.**
- `data_t`: `unsigned char`
- `TEST`: >

**D.**
- `data_t`: `int`
- `TEST`: <=
## Problem 15
A. 4003fe
B. 400431 - 12 = 400425
C.
400543: 77 02
400545: 5d
D. 0x4005ed - 0x8d = 0x400560
## Problem 16
A.
``` c
void cond(short a, short *p) {
    if (a == 0)
        goto L1;
    if (*p >= a)
        goto L1;
    *p = a;
L1:
    return;
}
```
B.
Two because of firstly we need check is a not 0. And after it we compare a with value in p pointer
## Problem 17
A.
``` asm 
absdiff_se: 
	cmpq %rsi, %rdi //Compare x:y 
	jge .L2 //If >= goto x_ge_y 
	addq $1, lt_cnt(%rip) //lt_cnt++ 
	movq %rsi, %rax 
	subq %rdi, %rax //result=y-x 
.L2: x_ge_y: 
	addq $1, ge_cnt(%rip) ge_cnt++ 
	movq %rdi, %rax 
	subq %rsi, %rax result=x-y
.DONE:
	ret //Return 
```
B.
Advantages of this rule that we can reuse done code for two branches. And we don't need to duplicate them
## Problem 18
``` c
short test(short x, short y, short z) { 
	short val = (z + y) - x; 
	if (z > 5) { 
		if (y > 2) val = x / z; 
		else val = x / y; 
	} else if (z < 3)
		 val = z / y; 
	 return val; 
 }
```
## Problem 19
A.
(45 - 25) * 2 = 20 \*2  = 40
B.
When the branch is mispredicted, the total cycles required would be the correct prediction time plus the miss penalty: 25 + 40 = 65
## Problem 20
A. OP = /
B.
``` asm
arith: 
	leaq 15(%rdi), %rbx  // rbx = x + 15
	testq %rdi, %rdi     // flag = rdi&rdi
	cmovns %rdi, %rbx    // if (x >= 0) rbx = rdi
	sarq $4, %rbx        // rbx >> 4 (ar) (rbx / 16)
	ret
```
## Problem 21
``` c
short test(short x, short y) { 
	short val = 12 + y; 
	if (x < 0) { 
		if (x >= y) val = x | y; 
		else val = x * y; 
	} else if (y >= 10) 
		val = x / y; 
	return val; 
}
```
## Problem 22
A.
- 1!=1
- 2!=2
- 3!=6
- 4!=24
- 5!=120
- 6!=720
- 7!=5040
- 8!=40320
- 9!=362880
- 10!=3628800
- 11!=39916800
- 12!=479001600
- 13!=6227020800

Now, 13!=6227020800, which is greater than 2147483647 (the maximum value for a 32-bit `int`). Therefore, **computing 14! with a 32-bit `int` will overflow**.
Indeed, 14!=87178291200, which is far beyond the 32-bit range.
B.
- 14!=87178291200
- 15!=1307674368000
- 16!=20922789888000
- 17!=355687428096000
- 18!=6402373705728000
- 19!=121645100408832000
- 20!=2432902008176640000
- 
Now, 20!=2432902008176640000, which is still less than 9223372036854775807 (the maximum 64-bit `long int`).
## Problem 23
A.
- **x**: Initially in `%rdi`, but then stored in `%rbx` (line 2). Throughout the loop, `x` is held in `%rbx`.
- **y**: Computed by `idivq $9, %rcx` (line 4), so `y` is in `%rcx`.
- **n**: Computed as `4*x` (line 5: `leaq (,%rdi,4), %rdx`), so `n` is in `%rdx`.
B.
The compiler eliminated the pointer `p` by combining the operations `x += y` and `(*p) += 5` into a single operation `x = x + y + 5`. This is done in the instruction `leaq 5(%rbx,%rcx), %rcx`.
C.
``` asm
dw_loop:
	movq %rdi, %rbx       # %rbx = x
	movq %rdi, %rcx       # %rcx = x (temporary)
	idivq $9, %rcx        # %rcx = x / 9 (y)
	leaq (,%rdi,4), %rdx  # %rdx = 4 * x (n)
.L2:
	leaq 5(%rbx,%rcx), %rcx   # %rcx = %rbx + %rcx + 5 = x + y + 5
                              # This updates y to the new value of x (x + y + 5)
	subq $1, %rdx         # n = n - 1   [Note: actually n -= 2? But here it subtracts 1 each time]
	testq %rdx, %rdx      # test n
	jg .L2                # if n > 0, goto loop
	rep; ret              # return (with result in %rcx, which is the final x)
```
## Problem 24
``` c
short loop_while(short a, short b) { 
	short result = 0; 
	while (a > b) { 
		result = result + a + b; 
		a = a - 1; 
	} 
	return result; 
}
```
## Problem 25
``` c
short loop_while2(short a, short b) { 
	short result = b; 
	while (b > 0) { 
		result = result * a; 
		b = b - a; 
	} 
	return result; 
}
```
## Problem 26
``` c
short test_one(unsigned short x) { 
	short val = 1; 
	while (x != 0) {
		val = val ^ x
		x = x >> 1
	} 
	return val & 0; 
}
```
## Problem 27
``` c
int fibonacci(int n) {
    long i = 2; 
    long next, first = 0, second = 1; 
    if (n <= 1) goto done; 
loop: 
	next = first + second; 
	first = second; 
	second = next; 
	i++; 
	if (i <= n) goto loop; 
done: 
	return n;
}
```
## Problem 28
``` c
short test_two(unsigned short x) { 
	short val = 0; 
	short i; 
	for (i = 64; i != 0; i --) { 
			val = (val << 1) | (x & 0x1); x >>= 1;
	} 
	return val; 
}
```
## Problem 29
**A.** The naive while loop translation:

```c
i = 0;
while (i < 10) {
    if (i & 1)
        continue;
    sum += i;
    i++;
}
```

**is incorrect** because when `continue` is executed (for odd `i`), the `i++` is skipped, causing `i` to never increment and leading to an infinite loop.
B.
``` c
i = 0;
while (i < 10) {
    if (i & 1)
        goto update;
    sum += i;
update:
    i++;
}
```

## Problem 30
**A.** The values of the case labels in the switch statement are: -2, -1, 0, 1, 3, 4, 6.
**B.** The cases with multiple labels are:
- The case for .L5 (which handles x = -1 and x = 6).
- The case for .L7 (which handles x = 1 and x = 3).
## Problem 31
``` c
void switcher(long a, long b, long c, long *dest) {
    long val;
    switch(a) {
        case 5:         /* Case A */
            c = b ^ 15;
            /* Fall through */
        case 0:         /* Case B */
            val = c + 112;
            break;
        case 2:         /* Case C */
        case 7:         /* Case D */
            val = (c + b) * 4;
            break;
        case 4:         /* Case E */
            val = a;
            break;
        default:
            val = b;
    }
    *dest = val;
}
```
# Chapter 3.7
## Problem 32

| Label | PC       | Inst  | %rdi | %rsi | %rax | %rsp           | *%rsp    | Description      |
| ----- | -------- | ----- | ---- | ---- | ---- | -------------- | -------- | ---------------- |
| M1    | 0x400560 | callq | 10   | -    | -    | 0x7fffffffe820 | -        | Call first(10)   |
| F1    | 0x400548 | lea   | 10   | -    | -    | 0x7fffffffe818 | 0x400565 | Entry on last    |
| F2    | 0x40054c | sub   | 10   | 11   | -    | 0x7fffffffe818 | 0x400565 | sub in last      |
| F3    | 0x400550 | callq | 9    | 11   | -    | 0x7fffffffe818 | 0x400565 | Call last(9, 11) |
| L1    | 0x400540 | mov   | 9    | 11   | -    | 0x7fffffffe810 | 0x400555 | Entry on last1   |
| L2    | 0x400543 | imul  | 9    | 11   | 9    | 0x7fffffffe810 | 0x400555 | imul in last     |
| L3    | 0x400547 | retq  | 9    | 11   | 99   | 0x7fffffffe810 | 0x400555 | return           |
| F4    | 0x400555 | repz  | 9    | 11   | 99   | 0x7fffffffe818 | 0x400565 | return           |
| M2    | 0x400565 | mov   | 9    | 11   | 99   | 0x7fffffffe820 | -        | move             |

## Problem 33
There are two valid orderings and types for the parameters u, a, v, b:

1. u: pointer to long long (64-bit integer)  
    a: int (32-bit integer)  
    v: pointer to char (8-bit integer)  
    b: char (8-bit integer)
    
2. u: pointer to char (8-bit integer)  
    a: char (8-bit integer)  
    v: pointer to long long (64-bit integer)  
    b: int (32-bit integer)
## Problem 34
A.
Local values from a0-a5 stored in rbx, r15, r14, r13, r12, rbp
B.
On stack stored a6, a7 
C.
x86 architecture have only 6 callee saved registers.
## Problem 35
``` c
long rfun(unsigned long x) { 
	if (x == 0) 
		return 0;
	unsigned long nx = x >> 2; 
	long rv = rfun(nx); 
	return x + rv; 
}
```
# Chapter 3.8
## Problem 36

| Array | Element Size | Total size | Start Address | Element i |
| ----- | ------------ | ---------- | ------------- | --------- |
| P     | 4            | 20         | xp            | xp + 4i   |
| Q     | 2            | 4          | xq            | xq + 2i   |
| R     | 8            | 72         | xr            | xr + 8i   |
| S     | 8            | 80         | xs            | xs + 8i   |
| T     | 8            | 16         | xt            | xt + 8i   |

## Problem 37

| Expression    | Type     | Value             | Assembly code              |
| ------------- | -------- | ----------------- | -------------------------- |
| P\[1]         | short    | M\[xp + 2]        | movw 2(%rdx),%ax           |
| P + 3 + i     | short \* | xp + 6 + 2i       | leaq 6(%rdx,%rcx,2),%rax   |
| P\[i * 6 - 5] | short    | M\[xp + 12i - 10] | movw -10(%rdx,%rcx,12),%ax |
| P\[2]         | short    | M\[xp + 4]        | movw 4(%rdx),%ax           |
| &P\[i + 2]    | short \* | xp + 2i + 4       | leaq 4(%rdx,%rcx,2),%rax   |

## Problem 38
%rdx = 8i -  i + j
%rax = 5j
%rdi = 5j+i
M\[xQ + 8 (5j + i)]
\+ M\[xP + 8 (7i + j)]
M = 5
N = 7
## Problem 39
For L = 4, C = 16, and j = 0, pointer Aptr is computed as xA + 4 . (16i + 0) = xA + 64i.
For L = 4, C = 16, i = 0, and j = k, Bptr is computed as xB + 4 . (16 . 0 + k) = xB + 4k. 
For L = 4, C = 16, i = 16, and j = k, Bend is computed as xB + 4 . (16 . 16 + k) = xB + 1,024 + 4k.
## Problem 40
``` c
void fix_set_diag_opt(fix_matrix A, int val) {
	int *Abase = &A[0][0];
	long i = 0;
	long iend = N*(N+1);
	do {
		Abase[i] = val;
		i += (N+1);
	} while(i != iend)
}
```
# Chapter 3.9
## Problem 41
A.
p -> 0
s.x -> 8
s.y -> 10
s.next -> 12
B. 20
C. 
``` c
void st_init(struct test *st) { 
	st->s.y = st->s.x; 
	st->p = &(st->s.y); 
	st->next = st; 
}
```
## Problem 42
A.
``` c
short test(struct ACE *ptr) {
	short val = 1
	while (ptr) {
		 val *= ptr->v;
		 ptr = ptr->p;
	}
	return val;
}
```
## Problem 43

| Expr                | Type    | Code                                                           |
| ------------------- | ------- | -------------------------------------------------------------- |
| up->t1.u            | long    | movq (%rdi), %rax; movq %rax, (%rsi)                           |
| up->t1.v            | short   | movw 8(%rdi), %ax; movw %ax, (%rsi)                            |
| &up->t1.w           | char \* | movq 10(%rdi), %rax; movq %rax, (%rsi)                         |
| up->t2.a            | int \*  | movq %rdi, (%rsi)                                              |
| up->t2.a\[up->t1.u] | int     | movq (%rdi), %rax; movl (%rdi,%rax,4), %eax; movl %eax, (%rsi) |
| \*up->t2.p          | char    | movq 8(%rdi), %rax; movb (%rax), %al; movb %al, (%rsi)         |

## Problem 44
A.
0 -> i -> 2 -> gap -> 4 -> c -> 8 -> \*j -> 12 -> short \* -> 16
B.
0 -> i1 -> 4 -> i2 -> 8 -> c -> 16 -> s -> 24 ->j -> 32
C.
0 -> w -> 16 -> c -> 32
D.
0 -> w -> 16 -> c -> 32
E.
0 -> a -> 24 -> t -> 40
## Problem 45
A.
0 -> a -> 8 -> b -> 12 -> c -> 16 -> d -> 24 -> gap -> 32 -> e -> 32 -> f -> 40 -> g -> 48 -> h -> 56
B. 56
C. 
``` c
struct { 
	int *a; 
	char *h; 
	double f; 
	long e; 
	float b; 
	int g; 
	short d; 
	char c; 
} rec;
```
# Chapter 3.10
## Problem 46
A.
```
%rsp+24:  00 00 00 00 00 40 00 76   Return address
%rsp+16:  01 23 45 67 89 AB CD EF   Saved %rbx
%rsp+8:   ?? ?? ?? ?? ?? ?? ?? ??   (uninitialized)
%rsp:     ?? ?? ?? ?? ?? ?? ?? ??   (uninitialized, buf)
```
B. 
```
%rsp+24:  34 00 40 00 00 00 00 00   Corrupted return address
%rsp+16:  36 37 38 39 30 31 32 33   Corrupted saved %rbx
%rsp+8:   38 39 30 31 32 33 34 35   Overwritten
%rsp:     30 31 32 33 34 35 36 37   buf contains string
```
C.
0x400034
D.
%rbx is corrupted (and the return address corrupts the instruction pointer).
E.
1. The malloc size should be `strlen(buf)+1` to include the null terminator.
2. There is no check for whether malloc returns NULL.
## Problem 47
A. The approximate range of addresses is **8,192 bytes**.
B. It would take about **64 attempts** to test all starting addresses with a 128-byte NOP sled.
## Problem 48
A.

Without protector:
- `buf`: at %rsp
- `v`: at %rsp + 24
- Canary: not present

With protector:
- `v`: at %rsp + 8
- `buf`: at %rsp + 16
- Canary: at %rsp + 40
B.
The rearranged order places `buf` between `v` and the canary. This ensures that any buffer overflow from `buf` will corrupt the canary (located at a higher address) before it can reach the return address. The stack protector then detects the corrupted canary and aborts the program, preventing exploitation. This is more secure than having `buf` at the top, where a small overflow might only corrupt local variables and not trigger the canary check.
## Problem 49
**A.** The computation: `rounded_size = (n*8 + 15) & ~15`, then `s2 = s1 - rounded_size`.
**B.** `p = s2` (since the allocation is aligned, so s2 is aligned).
**C.** 
For n=5, s1=2065:
- rounded_size = (40+15)=55, and 55 & ~15 = 48
- s2 = 2065 - 48 = 2017
- p = 2017
- e1 = p - s2 = 0
- e2 = s1 - p = 48

For n=6, s1=2064:
- rounded_size = (48+15)=63, and 63 & ~15 = 48
- s2 = 2064 - 48 = 2016
- p = 2016
- e1 = 0
- e2 = 48

**D.** The code guarantees that both `s2` and `p` are aligned to 16 bytes.
# Chapter 3.11
## Problem 50
``` c
double fcvt2(int *ip, float *fp, double *dp, long l) {
    int i = *ip;
    float f = *fp;
    double d = *dp;
    *ip = (int) d;          // val1 = d
    *fp = (float) i;        // val2 = i
    *dp = (double) l;       // val3 = l
    return (double) f;      // val4 = f
}
```
## Problem 51
|Tx|Ty|Instruction(s)|
|---|---|---|
|long|double|`vcvtsi2sdq %rdi, %xmm0`|
|double|int|`vcvttsd2si %xmm0, %eax`|
|double|float|`vcvtsd2ss %xmm0, %xmm0, %xmm0`|
|long|float|`vcvtsi2ssq %rdi, %xmm0, %xmm0`|
|float|long|`vcvttss2siq %xmm0, %rax`|
## Problem 52
| Function | Argument 1        | Argument 2        | Argument 3       | Argument 4        |
| -------- | ----------------- | ----------------- | ---------------- | ----------------- |
| g1       | a: %xmm0 (double) | b: %rdi (long)    | c: %xmm1 (float) | d: %esi (int)     |
| g2       | a: %edi (int)     | b: %rsi (double*) | c: %rdx (float*) | d: %rcx (long)    |
| g3       | a: %rdi (double*) | b: %xmm0 (double) | c: %esi (int)    | d: %xmm1 (float)  |
| g4       | a: %xmm0 (float)  | b: %rdi (int*)    | c: %xmm1 (float) | d: %xmm2 (double) |
## Problem 53
The possible combination of types is:
- `arg1_t` = `int`
- `arg2_t` = `long` (or `long long`)
- `arg3_t` = `float`
- `arg4_t` = `double`
There is only one combination because the register usage (`%edi` for 32-bit integer, `%rsi` for 64-bit integer, `%xmm0` for float, `%xmm1` for double) is fixed.
## Problem 54
``` c
double funct2(double w, int x, float y, long z) {
	float temp = b * (float)a;
	return (double)temp - (c / (double)d);
}
```
## Problem 55
`1077936128`  ->  `0x40400000` ->  0x404 -> 1028−1023=5, so 25=3225=32
## Problem 56
- **A**. Absolute value (`fabs(x)`)
- **B:** Returns zero (`0.0`)
- **C:** Negation (`-x`)
## Problem 57
``` c
double funct3(int *ap, double b, long c, float *dp) {
    float f = *dp;
    int a_val = *ap;

    if (b > a_val) {
        return (double)( (float)c * f );
    } else {
        return (double)( (float)c + 2.0f * f );
    }
}
```
