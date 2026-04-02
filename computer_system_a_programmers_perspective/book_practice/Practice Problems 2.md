# Chapter 2.1
## Problem 1 +
A.
0x25b9d2 -> 0010 0101 1011 1001 1101 0010
B.
1010 1110 0100 1001 -> 0xAE49
C.
0xA8B3D -> 1010 1000 1011 0011 1101
D.
0011 0010 0010 1101 1001 0110 -> 0x322D96

## Problem 2 +

| n   | decimal   | hexadecimal |
| --- | --------- | ----------- |
| 5   | 32        | 0x20        |
| 23  | 8,388,608 | 0x800000    |
| 15  | 32,768    | 0x8000      |
| 13  | 8,192     | 0x2000      |
| 12  | 4,096     | 0x1000      |
| 6   | 64        | 0x40        |
| 8   | 256       | 0x100       |

## Problem 3 +

| Decimal | Binary    | Hex  |
| ------- | --------- | ---- |
| 0       | 0000 0000 | 0x00 |
| 158     | 1001 1110 | 0x9E |
| 76      | 0100 1100 | 0x4C |
| 145     | 1001 0001 | 0x91 |
| 174     | 1010 1110 | 0xAE |
| 60      | 0011 1100 | 0x3C |
| 241     | 1111 0001 | 0xF1 |
| 117     | 0111 0101 | 0x75 |
| 189     | 1011 1101 | 0xBD |
| 245     | 1111 0101 | 0xF5 |

## Problem 4 +
A.
$$ 0x605C + 0x5 = 0x6061$$
B.
$$ 0x605c - 0x20 = 0x603c$$
C.
$$ 0x605c + 32 = 0x607c $$
D.
$$ 0x60fa - 0x605c = 0x9e$$

## Problem 5 +

| little   | big      |
| -------- | -------- |
| 78       | 12       |
| 78 56    | 12 34    |
| 78 56 34 | 12 34 56 |
## Problem 6
A.
0x0027C8F8 -> 0000 0000 0010 0111 1100 1000 1111 1000
0x4A1F23E0 -> 0100 1010 0001 1111 0010 0011 1110 0000
B.
0000 0000 0010 0111 1100 1000 1111 1000
----0100 101000 0111 1100 1000 1111 1000 00
21
C.
We find all bits of the integer embedded in the floating-point number, except for the most significant bit having value 0. Such is the case for the example in the text as well. In addition, the floating-point number has some nonzero high-order bits that do not match those of the integer.

## Problem 7
6d 6e 6f 70 71 72

## Problem 8 +

| Operation | Result   |
| --------- | -------- |
| a         | 01001110 |
| b         | 11100001 |
| ~a        | 10110001 |
| ~b        | 00011110 |
| a & b     | 0100000  |
| a \| b    | 11101111 |
| a ^ b     | 10101111 |
## Problem 9 +
A.
Black -> White
Blue -> Yellow
Green -> Magenta
Cyan -> Red
B.
Blue | Green -> Cyan
Yellow & Cyan -> Green
Ren ^ Magenta -> Blue
## Problem 10 +

| Step     | \*x           | \*y           |
| -------- | ------------- | ------------- |
| Initialy | a             | b             |
| Step 1   | a             | a ^ b         |
| Step 2   | a ^ b ^ a = b | a ^ b         |
| Step 3   | b             | a ^ b ^ b = a |

## Problem 11 +
A.
first = 2
end = 2
B.
Because of a\[2\] ^ a\[2\] operation
C.
``` c
void reverse_array(int a[], int cnt) { 
	int first, last; 
	for (first = 0, last = cnt-1; 
		first < last; 
		first++,last--) 
		inplace_swap(&a[first], &a[last]); 
}
```
## Problem 12 +
A.
res = x & 0xFF
B.
without_last = x ^ (x & 0xFF)
mask = ~ without_last
res = mask | (x & 0xFF)
C.
without_last = x ^ (x & 0xFF)
res = without_last | 0xFF
## Problem 13 + 
``` c
int bool_or(int x, int y) { 
	int result = bis(x,y); 
	return result; 
}
int bool_xor(int x, int y) { 
	int result = bis(bic(x,y), bic(y,x)); 
	return result; 
}
```
## Problem 14 +
0x55 -> 0101 0101
0x46 -> 0100 0110

| Expression | Value            |
| ---------- | ---------------- |
| a & b      | 0100 0100 = 0x44 |
| a \| b     | 0101 0111 = 0x57 |
| ~a \| ~b   | 1011 1011 = 0xBB |
| a & !b     | 0x00             |
| a  && b    | 0x01             |
| a \|\| b   | 0x01             |
| !a \|\| !b | 0x00             |
| a && ~b    | 0x01             |

## Problem 15 +
! x ^ y
## Problem 16 +

| Hex  | Binary    | Binary <<2 | Hex <<2 | Binary >>3L | Hex >>3L | Binary >>3A | Hex >>3A |
| ---- | --------- | ---------- | ------- | ----------- | -------- | ----------- | -------- |
| 0xD4 | 1101 0100 | 0101 0000  | 0x50    | 0001 1010   | 0x1A     | 1111 1010   | 0xFA     |
| 0x64 | 0110 0100 | 1001 0000  | 0x90    | 0000 1100   | 0x0C     | 0000 1100   | 0x0C     |
| 0x72 | 0111 0010 | 1100 1000  | 0xC8    | 0000 1110   | 0x0E     | 0000 1110   | 0x0E     |
| 0x44 | 0100 0100 | 0001 0000  | 0x10    | 0000 1000   | 0x08     | 0000 1000   | 0x08     |
# Chapter 2.2
## Problem 17 +

| Hexadecimal | Binary | B2U | B2T |
| ----------- | ------ | --- | --- |
| 0xA         | 1010   | 10  | -6  |
| 0x1         | 0001   | 1   | 1   |
| 0xB         | 1011   | 11  | -5  |
| 0x2         | 0010   | 2   | 2   |
| 0x7         | 0111   | 7   | 7   |
| 0xC         | 1100   | 12  | -4  |

## Problem 18 +
0x02e0 -> 0000 0010 1110 0000 -> 736
0xa8 -> 1010 1000 -> -88
0x28 -> 0010 1000 -> 40
-0x30 -> -48
0x78 -> 0111 1000 -> 120
0x88 -> 1000 1000 -> 136
0x01f8 -> 0000 0001 1111 1000 -> 504
0x08 -> 0000 1000 -> 8
0xc0 -> 1100 0000 -> 192
0xb8 -> 1011 1000 -> -72
## Problem 19 +

| x   | T2U |
| --- | --- |
| -1  | 15  |
| -5  | 11  |
| -6  | 10  |
| -4  | 12  |
| 1   | 1   |
| 8   | 8   |

## Problem 20 +
-1 + 16 = 15
-5 + 16 = 11
-6 + 16 = 10
-4 + 16 = 12
1 = 1
8 = 8
## Problem 21 +

| Expression                   | Type | Evaluation |
| ---------------------------- | ---- | ---------- |
| -2147483647-1 == 2147483648U | U    | 1          |
| -2147483647-1 < 2147483647   | S    | 1          |
| -2147483647-1U < 2147483647  | U    | 0          |
| -2147483647-1 < -2147483647  | S    | 1          |
| -2147483647-1U < -2147483647 | U    | 1          |
## Problem 22 +
1100 -> -8 + 4 = -4
11100 -> -16 + 8 + 4 = -4
111100 -> - 32 + 16  + 8 + 4 = -4
## Problem 23 +
A.

| w          | bit                                  | fuc1       | func2      |
| ---------- | ------------------------------------ | ---------- | ---------- |
| 0x00000076 | 00000000 00000000 00000000 0111 0110 | 0x00000076 | 0x00000076 |
| 0x87654321 | 10000111 01100101 00100011 0010 0001 | 0x00000021 | 0x00000021 |
| 0x000000C9 | 00000000 00000000 00000000 1100 1001 | 0x000000C9 | 0xFFFFFFC9 |
| 0xEDCBA987 | 11101101 11001011 10101001 1000 0111 | 0x00000087 | 0xFFFFFF87 |
B.
Because in func 2 we convert to int right shift and 1, not 0
## Problem 24 +

| Uns | Uns Tr | Two | Two Tr |
| --- | ------ | --- | ------ |
| 1   | 1      | 1   | 1      |
| 3   | 3      | 3   | 3      |
| 5   | 5      | 5   | 5      |
| 12  | 4      | -4  | 4      |
| 14  | 6      | -2  | 6      |
## Problem 25 +
``` c
float sum_elements(float a[], unsigned length) {
    int i;
    float result = 0;
    for (i = 0; i < length; i++)
        result += a[i];
    return result;
}
```
## Problem 26 +
A.
Then s < t , result will be UNS_MAX - (len(t) - len(s))
B.
When subtracting a larger unsigned number from a smaller one, the result underflows and wraps around to a very large positive value
C.
``` c
int strlonger(char *s, char *t) {
    return strlen(s) > strlen(t);
}
```
# Chapter 2.3
## Problem 27 +
``` c
func int uadd_ok(unsigned x, unsigned y) {
	unsigned result = x + y;
	return result <= x || resilt <= y;
}
```
## Problem 28 +

| Hex | Dec | Dec | Hex |
| --- | --- | --- | --- |
| 1   | 1   | 15  | F   |
| 4   | 4   | 12  | C   |
| 7   | 7   | 9   | 9   |
| A   | 10  | 6   | 6   |
| E   | 14  | 2   | 2   |
## Problem 29 +

|x|y|x+y|(x+y)5|Case|
|---|---|---|---|---|
|-16+4=-12|-16+1=-15|-32+4+1=-27|5|1|
|10100|10001|100101|00101||
|-16+8=-8|-16+8=-8|-32+16=-16|-16|2|
|11000|11000|110000|10000||
|-16+4+2+1=-9|8|-32+16+8+4+2+1=-1|-1|2|
|10111|01000|011111|11111||
|2|1+4=5|4+2+1=7|7|3|
|00010|00101|000111|00111||
|4+8=12|4|16|-16|4|
|01100|00100|010000|10000||
## Problem 30 +
``` c
// my
func int tadd_ok(int x,int y){
	val sum = x + y
	if(x < 0 && y < 0 && sum >= 0) {
		return 0;
	}
	if(x > 0 && y > 0 && sum <= 0) {
		return 0;
	}
	return 1
}
```
## Problem 31 +
Because i\`m dumb. Solution: (x+y)-y always x
## Problem 32 +
``` c
int tsub_ok(int x, int y) {
	if (y == Tmin) return x < 0;
	return tadd_ok(x, -y);
}
```
## Problem 33 +

| Hex | Dec | Hex | Dec |
| --- | --- | --- | --- |
| 2   | 2   | -2  | E   |
| 3   | 3   | -3  | D   |
| 9   | -7  | -9  | 7   |
| B   | -5  | 5   | 5   |
| C   | -4  | 4   | 4   |
## Problem 34 +

| mode | x   | xb  | y   | yb  | x*y | x*y b  | trunc | truncb |
| ---- | --- | --- | --- | --- | --- | ------ | ----- | ------ |
| Uns  | 4   | 100 | 5   | 101 | 20  | 010100 | 4     | 100    |
| Two  | -4  | 100 | -3  | 101 | 12  | 001100 | -4    | 100    |
| Uns  | 2   | 010 | 7   | 111 | 14  | 001110 | 6     | 110    |
| Two  | 2   | 010 | -1  | 111 | -2  | 111110 | -2    | 110    |
| Uns  | 6   | 110 | 6   | 110 | 36  | 100100 | 4     | 100    |
| Two  | -2  | 110 | -2  | 110 | 4   | 000100 | -4    | 100    |
## Problem 35 +
### 1. Handling the case x = 0:

If `x = 0`, then `x * y = 0`. There is no possibility of overflow in multiplication by zero. The function returns `!0 || ...` which is `true || ...`, so it correctly returns `1` (true) without even checking the division. So this case is handled correctly.

Now, assume `x != 0`. We are working with w-bit two's complement integers. Let the true mathematical product be x⋅yx⋅y (which may be larger than the representable range). The computed product `p = x * y` in two's complement is equivalent to:

p=(x⋅y)mod  2wp=(x⋅y)mod2w

This can be written as:

x⋅y=p+t⋅2wx⋅y=p+t⋅2w

where tt is an integer. Overflow occurs if x⋅yx⋅y is outside the range [−2w−1,2w−1−1][−2w−1,2w−1−1], which for multiplication is equivalent to t≠0t=0 (except for the case where x⋅y=−2w−1x⋅y=−2w−1, but we'll see that this is handled correctly by the division). Actually, in two's complement, the multiplication overflow happens when the true product cannot be represented exactly in w bits, which is when t≠0t=0, except that if x⋅y=−2w−1x⋅y=−2w−1 (the most negative number), it is representable and t=0t=0. However, we will see that the division test works.

### 2. Expressing p when divided by x:

We have `q = p / x` and `r = p % x` in C. For integer division in C, it truncates towards zero. So we have:

p=x⋅q+r,with∣r∣<∣x∣p=x⋅q+r,with∣r∣<∣x∣

This holds by the definition of integer division.

### 3. When is q = y?

We want to show that `q == y` if and only if there was no overflow (t=0t=0) and r=0r=0.

Substitute the expression for pp from the multiplication:

x⋅y=p+t⋅2w=(x⋅q+r)+t⋅2wx⋅y=p+t⋅2w=(x⋅q+r)+t⋅2w

So,

x⋅y=x⋅q+r+t⋅2wx⋅y=x⋅q+r+t⋅2w

Rearranging:

x⋅(y−q)=r+t⋅2wx⋅(y−q)=r+t⋅2w

Now, consider the magnitude of both sides. Note that ∣r∣<∣x∣∣r∣<∣x∣, and ∣t⋅2w∣∣t⋅2w∣ is a multiple of 2w2w, which is very large unless t=0t=0.

- If t=0t=0 and r=0r=0, then the right-hand side is 0, so y=qy=q.
    
- Conversely, if q=yq=y, then:
    
    0=r+t⋅2w0=r+t⋅2w
    
    So r=−t⋅2wr=−t⋅2w. But ∣r∣<∣x∣≤2w−1∣r∣<∣x∣≤2w−1 (since |x| is at most 2w−1−12w−1−1 or 2w−12w−1 for the most negative number), and ∣t⋅2w∣≥2w∣t⋅2w∣≥2w if t≠0t=0. The only possibility is t=0t=0 and then r=0r=0.
    

Therefore, q=yq=y if and only if t=0t=0 and r=0r=0, which means no overflow and exact division.
## Problem 36 +
``` c
int tmult_ok(int x, int y) { 
	int64_t p64 = (int64_t) x * y;
	/* Either x is zero, or dividing p by x gives y */ 
	return p64 == (int) p; 
}
```
## Problem 37 +
#### A. Does your code provide any improvement over the original?

Yes, but only in a limited way. It prevents overflow in the multiplication itself (so the value computed in `asize` is correct). However, it does not prevent the truncation when passing to `malloc`, which can still lead to an undersized allocation. So it is an improvement in that the multiplication is accurate, but the vulnerability (allocating too little memory) remains because of the truncation.

#### B. How would you change the code to eliminate the vulnerability?

To fully eliminate the vulnerability, we must ensure that the requested allocation size does not exceed `SIZE_MAX` (the maximum value for `size_t`). Also, we should check for overflow in the multiplication and for the truncation.

Here is a safe version:

```c
#include <stdint.h>  // for SIZE_MAX

void* copy_elements(void *ele_src[], int ele_cnt, size_t ele_size) {
    // Check if ele_cnt is non-negative (since it's signed)
    if (ele_cnt < 0) {
        return NULL;
    }

    // Check for multiplication overflow: ele_cnt * ele_size <= SIZE_MAX
    if (ele_size != 0 && (size_t)ele_cnt > SIZE_MAX / ele_size) {
        // Multiplication would overflow or exceed SIZE_MAX
        return NULL;
    }

    size_t asize = (size_t)ele_cnt * ele_size;
    void *result = malloc(asize);
    if (result == NULL) {
        return NULL;
    }

    void *next = result;
    for (int i = 0; i < ele_cnt; i++) {
        memcpy(next, ele_src[i], ele_size);
        next += ele_size;
    }
    return result;
}
```
## Problem 38 +
1. **Case: `b = 0`**
	- `k=0`: `(a << 0) + 0 = a * 1`
    - `k=1`: `(a << 1) + 0 = a * 2`
    - `k=2`: `(a << 2) + 0 = a * 4`
    - `k=3`: `(a << 3) + 0 = a * 8`
        
2. **Case: `b = a`**
    - `k=0`: `(a << 0) + a = a * 1 + a = a * 2`
    - `k=1`: `(a << 1) + a = a * 2 + a = a * 3`
    - `k=2`: `(a << 2) + a = a * 4 + a = a * 5`
    - `k=3`: `(a << 3) + a = a * 8 + a = a * 9`
## Problem 39 +
For the most significant bit at position n, the expression for form B can be modified to:

(x_n≪n)−(x_n≪(n+1))

This computes the value −xn⋅2n−xn​⋅2n, which is the correct weight for the MSB in two's complement representation.

## Problem 40 +

|K|Shift|add/sub|Expr|
|---|---|---|---|
|7|1|1|(x << 3) - x|
|30|4|3|(x << 4) + (x << 3) + (x << 2) + (x << 1)|
|28|2|1|(x << 5) - (x << 2)|
|55|2|2|(x << 6) - (x << 3) - x|
## Problem 41 +
The compiler should use **Form A (direct mov with immediate)** whenever the constant can be encoded in a single move instruction on the target architecture. If the constant is too large to be represented as an immediate (e.g., in RISC architectures), it should use **Form B (shift and subtract sequence)** to generate the constant in multiple instructions.
In practice, modern compilers (like GCC, Clang) have sophisticated constant generation strategies and will choose the most efficient method based on the target instruction set.

## Problem 42 +
``` c
int div16(int x) {
	/* Compute bias to be either 0 (x >= 0) or 15 (x < 0) */
	int bias = (x >> 31) & 0xF;
	return (x + bias) >> 4;
}
```
## Problem 43 +
m=31 n=8
## Problem 44
A. False for `x = INT_MIN` (e.g., `x = -2147483648`)  
B. False for `x = 7`  
C. True for all  
D. True for all  
E. False for `x = INT_MIN`  
F. True for all  
G. True for all
# Chapter 2.4
## Problem 45 +

| Fractional | Binary  | Decimal            |
| ---------- | ------- | ------------------ |
| 1/8        | 0.001   | 0.125              |
| 3/4        | 0.110   | 0.75               |
| 25/16      | 0.1001  | 0.25+0.0625=0.3125 |
| 2 11/16    | 10.1011 | 2.6875             |
| 1 1/8      | 1.001   | 1.125              |
| 5 7/8      | 101.111 | 5.875              |
| 3 3/16     | 11.0011 | 3.1875             |
## Problem 46 +
**A.** The binary representation of 0.1−x0.1−x is 35×2−2453​×2−24, which in binary is 0.000000000000000000000001100110011001100...20.000000000000000000000001100110011001100...2​ (with "1001" repeating from bit 24).

**B.** The approximate decimal value is d 9.54 × 10−8.

**C.** 9.54 × 10−8 × 100 × 60 × 60 × 10 ≈ 0.343 seconds.

**D.** 0.343 × 2,000 ≈ 687
## Problem 47 +

| Bits    | e   | E   | 2^E | f   | M   | 2^ExM   | V    | Decimal |
| ------- | --- | --- | --- | --- | --- | ------- | ---- | ------- |
| 0 00 00 | 0   | 0   | 1/2 | 0/4 | 0/4 | 0       | 0    | 0       |
| 0 00 01 | 0   | 0   | 1/2 | 1/4 | 1/4 | 1/4     | 1/4  | 0.25    |
| 0 00 10 | 0   | 0   | 1/2 | 2/4 | 2/4 | 2/4     | 2/4  | 0.5     |
| 0 00 11 | 0   | 0   | 1/2 | 3/4 | 3/4 | 3/4     | 3/4  | 0.75    |
| 0 01 00 | 1   | 0   | 1   | 0/4 | 4/4 | 4/4     | 4/4  | 1       |
| 0 01 01 | 1   | 0   | 1   | 1/4 | 5/4 | 5/4     | 5/4  | 1.25    |
| 0 01 10 | 1   | 0   | 1   | 2/4 | 6/4 | 6/4     | 6/4  | 1.5     |
| 0 01 11 | 1   | 0   | 1   | 3/4 | 7/4 | 7/4     | 7/4  | 1.75    |
| 0 10 00 | 2   | 1   | 2   | 0/4 | 4/4 | 4 * 2/4 | 8/4  | 2       |
| 0 10 01 | 2   | 1   | 2   | 1/4 | 5/4 | 5 * 2/4 | 10/4 | 2.5     |
| 0 10 10 | 2   | 1   | 2   | 2/4 | 6/4 | 6 * 2/4 | 12/4 | 3       |
| 0 10 11 | 2   | 1   | 2   | 3/4 | 7/4 | 7 * 2/4 | 14/4 | 3.5     |
| 0 11 00 | 3   | 2   | 4   | 0/4 | 4/4 | ∞       | ∞    | ∞       |
| 0 11 01 | 3   | 2   | 4   | 1/4 | 5/4 | NaN     | NaN  | NaN     |
| 0 11 10 | 3   | 2   | 4   | 2/4 | 6/4 | NaN     | NaN  | NaN     |
| 0 11 11 | 3   | 2   | 4   | 3/4 | 7/4 | NaN     | NaN  | NaN     |
## Problem 48 +
00000000001101011001000101000001
---01001010010101100100010100000100
## Problem 49 +
**A.** The smallest positive integer that cannot be represented exactly is 2n+1+1​
**B.** For single-precision (n=23 ), this value is 16,777,217
## Problem 50 +
A. 10.111 -> 11.0 
B. 11.010 -> 11.0 
C. 11.000 -> 11.0 
D. 10.110 -> 11.0
## Problem 51 +
**A.** Binary representation of x′ : 0.000110011001100110011012​​
**B.** x′−0.1≈2.384×10−8​
**C.** Clock error after 100 hours: 0.0858 seconds​
**D.** Position prediction error: 171 meters​
## Problem 52 +

| format A   | value    | format B   | value    |
| ---------- | -------- | ---------- | -------- |
| `011 0000` | 1        | `0111 000` | 1        |
| `101 1110` | 7.5      | `1001 111` | 7.5      |
| `010 1001` | 0.78125  | `0110 100` | 0.75     |
| `110 1111` | 15.5     | `1011 000` | 16       |
| `000 0001` | 0.015625 | `0001 000` | 0.015625 |
## Problem 53 +
#define POS_INFINITY 1e400
#define NEG_INFINITY (-POS_INFINITY)
#define NEG_ZERO (-1.0/POS_INFINITY)
## Problem 54 +
A. true 
B. false
C. false 
D. true 
E. true
F. true 
G. true 
H. false



