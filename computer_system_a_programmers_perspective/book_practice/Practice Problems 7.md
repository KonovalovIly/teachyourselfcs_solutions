## Problem 1
| Symbol | .symtabentry? |  Symboltype | Modulewheredefined | Section |
| ------ | ------------- | ----------- | ------------------ | ------- |
| buf    | Yes           | extern      | m.o                | .data   |
| bufp0  | Yes           | global      | swap.o             | .data   |
| bufp1  | Yes           | global      | swap.o             | COMMON  |
| swap   | No            | global      | swap.o             | .text   |
| temp   | No            | -           | -                  | -       |

## Problem 2
A. The linker chooses the strong symbol defined in module 1 over the weak
symbol defined in module 2 (rule 2):
    (a) REF(main.1) →DEF(main.1)
    (b) REF(main.2) →DEF(main.1)
B. This is an error,because each module defines a strong symbol main(rule1).
C. The linker chooses the strong symbol defined in module 2 over the weak
symbol defined in module 1 (rule 2):
    (a) REF(x.1) →DEF(x.2)
    (b) REF(x.2) →DEF(x.2)
## Problem 3
A. linux> gcc p.o libx.a
B. linux> gcc p.o libx.a liby.a
C. linux> gcc p.o libx.a liby.a libx.a
## Problem 4
A. The hex address of the relocated reference in line 5 is 0x4004df.
B. The hex value of the relocated reference in line 5 is 0x5. Remember that
the disassembly listing shows the value of the reference in little-endian byte
order.
## Problem 5
ADDR(s) = ADDR(.text) = 0x4004d0
and
ADDR(r.symbol) = ADDR(swap) = 0x4004e8
Using the algorithm in Figure 7.10, the linker first computes the run-time
address of the reference:
refaddr = ADDR(s) + r.offset
    = 0x4004d0 + 0xa
    = 0x4004da
It then updates the reference:
*refptr = (unsigned) (ADDR(r.symbol) + r.addend - refaddr)
    = (unsigned) (0x4004e8 + (-4) - 0x4004da)
    = (unsigned) (0xa)
Thus, in the resulting executable object file, the PC-relative reference to swap has
a value of 0xa:
4004d9: e8 0a 00 00 00 callq 4004e8 <swap>
