
Registers

| name          | 64 bit | 32 bit | 16 bit | 8 bit |
| ------------- | ------ | ------ | ------ | ----- |
| Return value  | %rax   | %eax   | %ax    | %al   |
| Callee saved  | %rbx   | %ebx   | %bx    | %bl   |
| 4th argument  | %rcx   | %ecx   | %cx    | %cl   |
| 3rd argument  | %rdx   | %edx   | %dx    | %dl   |
| 2st argument  | %rsi   | %esi   | %si    | %sil  |
| 1st argument  | %rdi   | %edi   | %di    | %dil  |
| Callee saved  | %rbp   | %ebp   | %bp    | %bpl  |
| Stack pointer | %rsp   | %esp   | %sp    | %spl  |
| 5th argument  | %r8    | %r8d   | %r8w   | %r8b  |
| 6th argument  | %r9    | %r9d   | %r9w   | %r9b  |
| Caller saved  | %r10   | %r10d  | %r10w  | %r10b |
| Caller saved  | %r11   | %r11d  | %r11w  | %r11b |
| Callee saved  | %r12   | %r12d  | %r12w  | %r12b |
| Callee saved  | %r13   | %r13d  | %r13w  | %r13b |
| Callee saved  | %r14   | %r14d  | %r14w  | %r14b |
| Callee saved  | %r15   | %r15d  | %r15w  | %r15b |
Memory operands
![[Pasted image 20250905185826.png]]

Move operands

| Instruction | Effect |                         |        |
| ----------- | ------ | ----------------------- | ------ |
| movb        | D ← S  | Move byte               | 8 bit  |
| movw        | D ← S  | Move word               | 16 bit |
| movl        | D ← S  | Move double word        | 32 bit |
| movq        | D ← S  | Move quad word          | 64 bit |
| movabsq     | R ← I  | Move absolute quad word | 64 bit |

| Instruction |                                             |
| ----------- | ------------------------------------------- |
| movzbw      | Move zero-extended byte to word             |
| movzbl      | Move zero-extended byte to double word      |
| movzwl      | Move zero-extended word to double word      |
| movzbq      | Move zero-extended byte to quad word        |
| movzwq      | Move zero-extended word to quad word        |
| movsbw      | Move sign-extended byte to word             |
| movsbl      | Move sign-extended byte to double word      |
| movswl      | Move sign-extended word to double word      |
| movsbq      | Move sign-extended byte to quad word        |
| movswq      | Move sign-extended word to quad word        |
| movslq      | Move sign-extended double word to quad word |
| cltq        | Sign-extend %eax to %rax                    |
Stack operators
![[Pasted image 20250907170146.png]]
Load Effective address
![[Pasted image 20250907170235.png]]
Special operators 
![[Pasted image 20250907170314.png]]
Controll codes

CF: Carry flag. The most recent operation generated a carry out of the most significant bit. Used to detect overflow for unsigned operations. 
ZF: Zero flag. The most recent operation yielded zero. 
SF: Sign flag. The most recent operation yielded a negative value. 
OF: Overflow flag. The most recent operation caused a two’s-complement overflow—either negative or positive.
![[Pasted image 20250907170416.png]]
Set  operations 
![[Pasted image 20250907170533.png]]
Jump Operations
![[Pasted image 20250907173356.png]]
Conditionals move
![[Pasted image 20250908102218.png]]

# Floating point operations
![[Pasted image 20250919180857.png]]

movement operations 
![[Pasted image 20250919181444.png]]
![[Pasted image 20250919181504.png]]

arithmetic 
![[Pasted image 20250919182317.png]]
![[Pasted image 20250919183216.png]]