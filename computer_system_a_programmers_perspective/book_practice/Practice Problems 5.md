## Problem 1
``` c
/* Swap value x at xp with value y at yp */
void swap(long *xp, long *yp)
{
	*xp = *xp + *yp; /* 2x
	*/
	*yp = *xp - *yp; /* 2x - 2x= 0 */
	*xp = *xp - *yp; /* 0 - 0 = 0 */
}
```

## Problem 2
Version 3 will be way more faster when version 1 after n > 3 and faster version 2 when n > 9 
## Problem 3

| Code | min | max | incr | square |
| ---- | --- | --- | ---- | ------ |
| A    | 1   | 91  | 90   | 90     |
| B    | 91  | 1   | 90   | 90     |
| C    | 1   | 1   | 90   | 90     |

## Problem 4
A. We store product in there 
B. The two versions of combine3 will have identical functionality, even with
memory aliasing.
C. This transformation can be made without changing the program behavior,
because, with the exception of the first iteration, the value read from dest at
the beginning of each iteration will be the same value written to this registerat the end of the previous iteration. Therefore, the combining instruction
can simply use the value already in %xmm0 at the beginning of the loop.
## Problem 5
A. n addition and 2n multiplication
B. We can see that the performance-limiting computation here is the repeated
computation of the expression xpwr = x * xpwr. This requires a floating-
point multiplication (5 clock cycles), and the computation for one iteration
cannot begin until the one for the previous iteration has completed. The
updating of result only requires a floating-point addition (3 clock cycles)
between successive iterations.
## Problem 6
A. n addition and n multiplication
B. We can see that the performance-limiting computation here is the repeated
computation of the expression result = a[i] + x\*result. Starting from the
value of result from the previous iteration, we must first multiply it by x (5
clock cycles) and then add it to a[i] (3 cycles) before we have the value for
this iteration. Thus, each iteration imposes a minimum latency of 8 cycles,
exactly our measured CPE.
C. Although each iteration in function poly requires two multiplications rather
than one, only a single multiplication occurs along the critical path per
iteration.
## Problem 7
``` c
/* 2 x 1 loop unrolling */
void combine5(vec_ptr v, data_t *dest)
{
	long i;
	long length = vec_length(v);
	long limit = length-1;
	data_t *data = get_vec_start(v);
	data_t acc = IDENT;
	
	/* Combine 5 elements at a time */
	for (i = 0; i < limit; i+=5) {
		acc = (acc OP data[i]) OP data[i+1] OP data[i+2] OP data[i+3] OP data[i+4];
	}
	/* Finish any remaining elements */
	for (; i < length; i++) {
		acc = acc OP data[i];
	}
	*dest = acc;
}
```
## Problem 8
Figure 5.39 diagrams the three multiplication operations for a single iteration
of the function. In this figure, the operations shown as blue boxes are along the
critical path—they need to be computed in sequence to compute a new value for
loop variable r. The operations shown as light boxes can be computed in parallel
with the critical path operations. For a loop with P operations along the critical
path, each iteration will require a minimum of 5P clock cycles and will compute
the product for three elements, giving a lower bound on the CPE of 5P /3. This
implies lower bounds of 5.00 for A1, 3.33 for A2 and A5, and 1.67 for A3 and A4.
We ran these functions on an Intel Core i7 Haswell processor and found that it
could achieve these CPE values.

## Problem 9
``` c
while (i1 < n && i2 < n) {
	long v1 = src1[i1];
	long v2 = src2[i2];
	long take1 = v1 < v2;
	dest[id++] = take1 ? v1 : v2;
	i1 += take1;
	i2 += (1-take1);
}
```
## Problem 10
A. It will set each element a[i] to i + 1, for 0 ≤ i ≤ 998.
B. It will set each element a[i] to 0, for 1 ≤ i ≤ 999.
C. In the second case, the load of one iteration depends on the result of the store
from the previous iteration. Thus, there is a write/read dependency between
successive iterations.
D. It will give a CPE of 1.2, the same as for Example A, since there are no
dependencies between stores and subsequent loads.
## Problem 11
We can see that this function has a write/read dependency between successive
iterations—the destination value p[i] on one iteration matches the source value
p[i-1] on the next. A critical path is therefore formed for each iteration consisting
of a store (from the previous iteration), a load, and a floating-point addition.
The CPE measurement of 9.0 is consistent with our measurement of 7.3 for the
CPE of write_read when there is a data dependency, since write_read involves
an integer addition (1 clock-cycle latency), while psum1 involves a floating-point
addition (3 clock-cycle latency).
## Problem 12
``` c
void psum1a(float a[], float p[], long n)
{
	long i;
	/* last_val holds p[i-1]; val holds p[i] */
	float last_val, val;
	last_val = p[0] = a[0];
	for (i = 1; i < n; i++) {
		val = last_val + a[i];
		p[i] = val;
		last_val = val;
	}
}
```