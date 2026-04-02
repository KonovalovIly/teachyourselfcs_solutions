# Chapter 2 Representing and Manipulating Information
[[Practice Problems 2]]
We will learn how information stored in computers and how we can manipulate them
	2.1 Information Storage
		Information stored in computer only in bits.
		2.1.1 Hexadecimal Notation
			The simplest way to represent bits is represent them in hex because we zip 4 01 digits to 2 hex digits
		2.1.2 Data Sizes
			Nowadays we have 2 main data sizes 32 and 64 bits in virtual memory.
		2.1.3 Addressing and Byte Ordering
			In most popular computers used little-ending bytes representation. And in IBM machines has big-endian.
		2.1.4 Representing Strings
			Representing string in C
		2.1.5 Representing Code
			How Code represented in machine instruction
		2.1.6 Introduction to Boolean Algebra
			Role of boolean algebra
		2.1.7 Bit-Level Operations in C
			Bit level operations
		2.1.8 Logical Operations in C
			Logical operations
		2.1.9 Shift Operations in C
			Right and left shift operations
	2.2 Integer Representations
		About two ways to represent integer values
		2.2.1 Integral Data Types
			How much different integers takes up memory
		2.2.2 Unsigned Encodings
			Binary to unsigned
		2.2.3 Two’s-Complement Encodings
			Binary to two compliment number
		2.2.4 Conversions between Signed and Unsigned
			How integer signed and unsigned values converting to each other
		2.2.5 Signed versus Unsigned in C
			How signed and unsigned values invisibly casts to each other
		2.2.6 Expanding the Bit Representation of a Number
			Converting values from different data types, while not enough space left
		2.2.7 Truncating Numbers
			How we use truncate when converting to less bit patterns
		2.2.8 Advice on Signed versus Unsigned
			Summary by the chapter
	2.3 Integer Arithmetic
		About arithmetic on integers
		2.3.1 Unsigned Addition
			How unsigned addition work with overfloating
		2.3.2 Two’s-Complement Addition
			How Two-Complement addition work with overfloating
		2.3.3 Two’s-Complement Negation
			Two-Complement negation arithmetic
		2.3.4 Unsigned Multiplication
			How unsigned multiplication work
		2.3.5 Two’s-Complement Multiplication
			How two-complement multiplication
		2.3.6 Multiplying by Constants
			How Multiplying optimized by compiler
		2.3.7 Dividing by Powers of 2
			How division by power of 2 optimizing in compilers
		2.3.8 Final Thoughts on Integer Arithmetic
			Summary of arithmetic chapter
	2.4 Floating Point
		About Floating values. Initially floating point values haven\`t standard
		2.4.1 Fractional Binary Numbers
			Positional notation of Floating point values
		2.4.2 IEEE Floating-Point Representation
			IEEE standard of Floating Point
		2.4.3 Example Numbers
			How float values work inside
		2.4.4 Rounding
			How number with decimal rounding
		2.4.5 Floating-Point Operations
			Floating point operations with boundary case
		2.4.6 Floating Point in C
			How floating point values represented in C
	2.5 Summary
		Summary about manipulation and representation of simplest form of information numbers and words