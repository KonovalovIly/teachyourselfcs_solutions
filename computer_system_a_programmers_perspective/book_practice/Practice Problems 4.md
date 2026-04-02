## Problem 1
``` asm
.pos
	0x100: 0x30 f3 0F00000000000000
	0x10A: 0x20 31
loop:
	0x10C: 0x40 13 FDFFFFFFFFFFFF
	0x116: 0x60 31
	0x118: 0x70 0C01000000000000
```
## Problem 2
A.
0x100: 
30 f3 fcffffffffffffff                   - irmovq $-4, %rbx
40 63 00080000000000        - rmmovq %rsi, 0x800(%rbx)
00                                              - halt
B.
a0 6f                                         - pushq %rsi
80 0c02000000000000         - call 0x20c
00                                             - halt
30 f3 0a000000000000        - irmovq $10 , %rbx
90                                             - ret
C.
50 54 0700000000000000     - mrmovq 7(%rbp),  %rsp
10                                               - nop
f0                                               - invalid
b0 1f                                           - popq %rcx
D.
61 13                                          - subq %rcx, %rbx
73 0004000000000000          - je 0x400
00                                              - halt
E.
63 62                                         - xorq %rsi, %rdx
a0 f0                                          - invalid
## Problem 3
```
sum: 
	xorq %rax,%rax               sum = 0 
	andq %rsi,%rsi               Set CC 
	jmp test                     Goto test 
loop: 
	mrmovq (%rdi),%r10           Get *start 
	addq %r10,%rax               Add to sum 
	iaddq $8,%rdi                start++ 
	iaddq $-1,%rsi               count--. Set CC 
test: 
	jne loop                     Stop when 0 
	ret Return
```
## Problem 4
``` asm
rproduct:
	irmovq $1, %r8           # Constant 1 for comparisons
	subq %r8, %rsi           # count - 1 for comparison
	jg recursive_case        # if count > 1, go to recursive case
	
	# Base case: count <= 1
    irmovq $1, %rax          # return 1
    ret

recursive_case:
    addq %r8, %rsi           # restore original count value
    pushq %rbx               # save callee-saved register
    pushq %r12               # save callee-saved register
    
    # Save arguments
    rrmovq %rdi, %rbx        # save start pointer in %rbx
    rrmovq %rsi, %r12        # save count in %r12
    
    # Get current value *start
    mrmovq (%rdi), %rax      # %rax = *start
    
    # Prepare arguments for recursive call
    irmovq $8, %r8
    addq %r8, %rdi           # start = start + 1 (8 bytes for long)
    subq %r8, %rsi           # count = count - 1
    
    # Recursive call
    call rproduct
    
    # Multiply result by *start
    # %rax now contains rproduct(start+1, count-1)
    # We need to multiply by *start (which we saved)
    mrmovq (%rbx), %r8       # %r8 = *start
    mulq %r8, %rax           # %rax = *start * recursive_result
    
    # Restore registers and return
    popq %r12
    popq %rbx
    ret
```
## Problem 5
``` asm
# absSum: sum of absolute values of an array
# Arguments: %rdi = long *data, %rsi = long count
# Returns: %rax = sum of absolute values

absSum:
    irmovq $8, %r8        # Constant 8 (size of long)
    irmovq $0, %rax       # sum = 0
    andq %rsi, %rsi       # Set condition codes for count
    jle Done              # If count <= 0, return 0
    
    irmovq $0, %rdx       # i = 0

Loop:
    mrmovq (%rdi,%rdx,8), %r9  # %r9 = data[i]
    
    # Check if value is negative
    andq %r9, %r9         # Set condition codes for data[i]
    jge Positive          # Jump if value >= 0 (non-negative)
    
    # Negative value: take absolute value
    irmovq $0, %r10
    subq %r9, %r10        # %r10 = 0 - data[i] (absolute value)
    rrmovq %r10, %r9      # %r9 = absolute value
    
Positive:
    addq %r9, %rax        # sum += absolute value
    
    addq %r8, %rdx        # i++
    subq %r8, %rsi        # count--
    jg Loop               # Continue if count > 0

Done:
    ret
```
## Problem 6
``` 
# absSum: sum of absolute values of an array using conditional moves
# Arguments: %rdi = long *data, %rsi = long count
# Returns: %rax = sum of absolute values

absSum:
    irmovq $0, %rax       # sum = 0
    andq %rsi, %rsi       # Set condition codes for count
    jle Done              # If count <= 0, return 0

Loop:
    mrmovq (%rdi), %r9    # %r9 = *data (current value)
    
    # Calculate absolute value using conditional moves
    rrmovq %r9, %r10      # %r10 = original value (potential abs value)
    irmovq $0, %r11
    subq %r9, %r11        # %r11 = -value (other potential abs value)
    
    # Use conditional move to select the correct absolute value
    andq %r9, %r9         # Set condition codes for the value
    cmovge %r9, %r10      # If value >= 0, abs = value (no change)
    cmovl %r11, %r10      # If value < 0, abs = -value
    
    addq %r10, %rax       # sum += absolute value
    
    irmovq $8, %r8
    addq %r8, %rdi        # data++ (move to next element)
    irmovq $1, %r8
    subq %r8, %rsi        # count--
    jg Loop               # Continue if count > 0

Done:
    ret
```
## Problem 7
If `pushq %rsp` pushed the **old RSP** (value before push), then `RDX` after pop would equal `RAX` initially, so `RAX - RDX = 0`.

If `pushq %rsp` pushed the **new RSP** (value after decrement), then `RDX` would be `old_RSP - 8`, so `RAX - RDX = 8`.
## Problem 8
The behavior of `popq %rsp` is equivalent to:  
*_RSP = _RSP__ (load RSP with the quad word from memory pointed to by RSP).

The Y86-64 instruction with the same behavior is:  
**`mrmovq (%rsp), %rsp`**.
## Problem 9
XOR

| a   | b   | out |
| --- | --- | --- |
| 0   | 0   | 0   |
| 1   | 0   | 1   |
| 0   | 1   | 1   |
| 1   | 1   | 0   |

out = (a || b) && !(a && b)

## Problem 10
a[63:0]   b[63:0]
   |         |
   |         |
[64 XOR gates]
   |
   v
d[63:0] (64 bits, 1 if that bit position differs)
   |
   | (all 64 wires as input)
   v
[64-input OR gate]
   |
   v
[NOT gate]
   |
   v
Eq (1 if words equal)

## Problem 11
word Min3 = [
			A <= B && A <= C : A;
							  B <= C : B;
										1 : C;
];
## Problem 12
word Mid3 = [
			A <= B && A >= C : A;
			A >= B && A <= C : A;
			B <= A && B >= C : B;
			B >= A && B <= C : B;
										1 : C;
];
## Problem 13

| Stage      | Generic<br>irmovq V, rB | Specific<br>irmovq $128, %rsp |
| ---------- | ----------------------- | ----------------------------- |
| Fetch      | icode : ifun ← M1[PC]   | M\[0x016\] = 3:0              |
|            | rA : rB ← M1[PC + 1]    | M\[0x017\] = F:4              |
|            | valC ← M8[PC + 2]       | valC = M\[0x018\] = 80        |
|            | valP ← PC + 10          | valP = 0x02                   |
| Decode     |                         |                               |
| Execute    | valE ← 0 + valC         | valE = 0+128 = 128            |
| Memory     |                         |                               |
| Write back | R[rB] ← valE            | R\[%rsp\] = 128               |
| PC update  | PC ← valP               | PC = 0x020                    |
## Problem 14
| Stage      | Generic<br>irmovq V, rB | Specific<br>irmovq $128, %rsp |
| ---------- | ----------------------- | ----------------------------- |
| Fetch      | icode : ifun ← M1[PC]   | M\[0x02c\]=b:0                |
|            | rA : rB ← M1[PC + 1]    | M\[0x02d\]=0:f                |
|            | valP ← PC + 2           | valP=0x02e                    |
| Decode     | valA ← R[%rsp]          | valA=120                      |
|            | valB ← R[%rsp]          | valB=120                      |
| Execute    | valE ← valB + 8         | valE=128                      |
| Memory     | valM ← M8[valA]         | valM=M[120]=9                 |
| Write back | R[rB] ← valE            | R[%rsp]=128                   |
|            | R[rA] ← valM            | R[%rax]=9                     |
| PC update  | PC ← valP               | PC=0x02e                      |
## Problem 15
Tracing the steps listed in Figure 4.20 with rA equal to %rsp, we can see that in
the memory stage the instruction will store valA, the original value of the stack
pointer, to memory, just as we found for x86-64.
## Problem 16
Tracing the steps listed in Figure 4.20 with rA equal to %rsp, we can see that both
of the write-back operations will update %rsp. Since the one writing valM would
occur last, the net effect of the instruction will be to write the value read from
memory to %rsp, just as we saw for x86-64.
## Problem 17
| Stage      | cmovXX rA, rB         |
| ---------- | --------------------- |
| Fetch      | icode : ifun ← M1[PC] |
|            | rA : rB ← M1[PC + 1]  |
|            | valP ← PC + 2         |
| Decode     | valA ← R[rA]          |
| Execute    | valE ← 0 + valA       |
|            | Cnd ← Cond(CC, ifun)  |
| Memory     |                       |
| Write back | if (Cnd) R[rB] ← valE |
| PC update  | PC ← valP             |
## Problem 18
| Stage      | Generic<br>call Dest  | Specific<br>call 0x041 |
| ---------- | --------------------- | ---------------------- |
| Fetch      | icode : ifun ← M1[PC] | M\[0x037\]=8:0         |
|            | valC ← M8[PC + 1]     | M\[0x038\]=0x041       |
|            | valP ← PC + 9         | valP=0x04              |
| Decode     | valB ← R[%rsp]        | valB=128               |
| Execute    | valE ← valB + (−8)    | valE=120               |
| Memory     | M8[valE] ← valP       | M[120]=0x04            |
| Write back | R[%rsp] ← valE        | R[%rsp]=120            |
| PC update  | PC ← valC             | PC=0x041               |
## Problem 19
bool need_valC = icode in { IIRMOVQ, IRMMOVQ, IMRMOVQ, IJXX, ICALL};
## Problem 20
word srcB = [
	icode in { IOPQ, IRMMOVQ, IMRMOVQ } : rB;
	icode in { IPUSHQ, IPOPQ, ICALL, IRET } : RRSP;
	1 : RNONE; # Don’t need register
];
## Problem 21
word dstM = [
	icode in { IMRMOVQ, IPOPQ } : rA;
	1 : RNONE; # Don’t write any register
];
## Problem 22
For M we should give priority 
## Problem 23
word aluB = [
	icode in { IRMMOVQ, IMRMOVQ, IOPQ, ICALL, IPUSHQ, IRET, IPOPQ } : valB;
	icode in { IRRMOVQ, IIRMOVQ } : 0;
];
## Problem 24
word dstE = [
	icode in { IRRMOVQ } && Cond : rB;
	icode in { IIRMOVQ, IOPQ} : rB;
	icode in { IPUSHQ, IPOPQ, ICALL, IRET } : RRSP;
	1 : RNONE; # Don’t write any register
];
## Problem 25
word mem_addr = [
	icode in { IRMMOVQ, IPUSHQ} : valA;
	icode == ICALL : valP;
];
## Problem 26
bool mem_write = icode in { IRMMOVQ, IPUSHQ, ICALL };
## Problem 27
word Stat = [
	imem_error || dmem_error : SADR;
	!instr_valid: SINS;
	icode == IHALT : SHLT;
	1 : SAOK;
];
## Problem 28
![[Pasted image 20260119103228.png]]
A. we put register after 60 ps. 
80+30+60 = 170
50+70+10 = 130
1/190 = 5.2
B. we put after 30 and 50 ps
80+30 = 110
60+50 = 110
70 +10 = 80
1/130 = 7.6
C. we put after A, C, D
80
30+60 = 90
50
70+10 = 80
1/110 = 9.1

## Problem 29
A. 300 + 20k
B. 1000/20k
## Problem 30
word f_stat = [
			imem_error : SADR;
			!instr_valid : SINS;
			f_icode == IHALT : SHLT;
			1 : SAOK;
];
## Problem 31
word d_dstE = [
			D_icode in { IRRMOVQ, IIRMOVQ, IOPQ} : D_rB;
			D_icode in { IPUSHQ, IPOPQ, ICALL, IRET } : RRSP;
			1 : RNONE; # Don’t write any register
];
## Problem 32
The rrmovq instruction (line 5) would stall for one cycle due to a load/use hazard
caused by the popq instruction (line 4). As it enters the decode stage, the popq
instruction would be in the memory stage, giving both M_dstE and M_dstM equal
to %rsp. If the two cases were reversed, then the write back from M_valE would
take priority, causing the incremented stack pointer to be passed as the argumentto the rrmovq instruction. This would not be consistent with the convention for
handling popq %rsp determined in Practice Problem 4.8.
## Problem 33
``` asm
irmovq $5, %rdx
irmovq $0x100,%rsp
rmmovq %rdx,0(%rsp)
popq %rsp
nop
nop
rrmovq %rsp,%rax
```
## Problem 34
``` hdl
word d_valB = [
			d_srcB == e_dstE : e_valE; # Forward valE from execute
			d_srcB == M_dstM : m_valM; # Forward valM from memory
			d_srcB == M_dstE : M_valE; # Forward valE from memory
			d_srcB == W_dstM : W_valM; # Forward valM from write back
			d_srcB == W_dstE : W_valE; # Forward valE from write back
			1 : d_rvalB; # Use value read from register file
];
```
## Problem 35
``` asm
irmovq $0x123,%rax
irmovq $0x321,%rdx
xorq %rcx,%rcx
cmovne %rax,%rdx
addq %rdx,%rdx
halt
```
## Problem 36
``` hdl
word m_stat = [
			dmem_error : SADR;
			1 : M_stat;
];
```
## Problem 37
``` asm
# Code to generate a combination of not-taken branch and ret
	irmovq Stack, %rsp
	irmovq rtnp,%rax
	pushq %rax # Set up return pointer
	xorq %rax,%rax # Set Z condition code
	jne target # Not taken (First part of combination)
	irmovq $1,%rax # Should execute this
	halt
target: ret # Second part of combination
	irmovq $2,%rbx # Should not execute this
	halt
rtnp:
	irmovq $3,%rdx # Should not execute this
	halt
.pos 0x40
Stack:
```
## Problem 38
``` asm
# Test instruction that modifies %esp followed by ret
	irmovq mem,%rbx
	mrmovq 0(%rbx),%rsp # Sets %rsp to point to return point
	ret # Returns to return point
	halt #
rtnpt: irmovq $5,%rsi # Return point
	halt
.pos 0x40
mem:
.quad stack # Holds desired stack pointer
.pos 0x50
stack: .quad rtnpt # Top of stack: Holds return point
```
## Problem 39
``` hdl
bool D_stall =
			# Conditions for a load/use hazard
			E_icode in { IMRMOVQ, IPOPQ } &&
			E_dstM in { d_srcA, d_srcB };
```
## Problem 40
``` hdl
bool E_bubble =
			# Mispredicted branch
			(E_icode == IJXX && !e_Cnd) ||
			# Conditions for a load/use hazard
			E_icode in { IMRMOVQ, IPOPQ } &&
			E_dstM in { d_srcA, d_srcB};
```
## Problem 41
``` hdl
## Should the condition codes be updated?
bool set_cc = E_icode == IOPQ &&
			# State changes only during normal operation
			!m_stat in { SADR, SINS, SHLT } && !W_stat in { SADR, SINS, SHLT };
```
## Problem 42
``` hdl
bool M_bubble = m_stat in { SADR, SINS, SHLT } || W_stat in { SADR, SINS, SHLT };
bool W_stall = W_stat in { SADR, SINS, SHLT };
```
## Problem 43
giving mp = 0.20 × 0.35 ×
2 = 0.14, giving an overall CPI of 1.25
## Problem 44
A. The inner loop of the code using the conditional jump has 11 instructions, all
of which are executed when the array element is zero or negative, and 10 of
which are executed when the array element is positive. The average is 10.5.
The inner loop of the code using the conditional move has 10 instructions,
all of which are executed every time.
B. The loop-closing jump will be predicted correctly, except when the loop
terminates. For a very long array, this one misprediction will have a negligible
effect on the performance. The only other source of bubbles for the jump-
based code is the conditional jump, depending on whether or not the array
element is positive. This will cause two bubbles, but it only occurs 50% of
the time, so the average is 1.0. There are no bubbles in the conditional move
code.
C. Our conditional jump code requires an average of 10.5 + 1.0 = 11.5 cycles
per array element (11 cycles in the best case and 12 cycles in the worst),
while our conditional move code requires 10.0 cycles in all cases.