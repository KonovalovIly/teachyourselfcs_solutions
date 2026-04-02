# Topics
- Introduction in Higher-Order Procedures
- Sigma notation
- Identity
- Procedures
- Damp
- Anonymous procedures
- Newton Method
- Derivatives
- Machine
- First class citizens

# Detail
### Introduction
Recursion example to sum integers b times from a
![](https://i.imgur.com/IbMWndD.png)

```lisp
(define (sum_int a b)
	(if (> a b)
		0
		(+ a (sum_int (+ 1 a) b))
	)
)
```

![](https://i.imgur.com/ytmCcYT.png)

```lisp
(define (sum_sq a b)
	(if (> a b)
		0
		(+ (square a)
			(sum_sq (+ 1 a) b)
		)
	)
)
```

The pattern of this solutions is
```lisp
(define (<name> a b)
	(if (> a b)
		0
		(+ (<term> a)
			(<name> (<next> a) b)
		)
	)
)
```

### Sigma notation

We can define one type of sum procedure. And change thouse param automaticly.
```lisp
(define (sum term a next b)
	(if (> a b)
		0
		(+ (term a)
			(sum (next a) b)
		)
	)
)
```

### Identity

This expression is the same sum in the start of the lections
```lisp
(define (sum_int a b)
	(define (identity a) a)
	(sum_int identity a inc b)
)
```

### Newtons method

To find a y such that.
f(y) = 0

Start with a quess, y0
y(n + 1) = y(n) - f(yn)/(df/dy * L(y = yn))

```lisp
(define (sqrt x)
	(newton (lambda (y)) ( - x (sqrt y) 1))
)

(define (newton f guess)
	(define df (deriv f))
	(fixed-point 
		(lambda (x) ( - x (/ (f x) (df x))))
		guess
	)
)

(define deriv
	(lambda (f)
		(lambda (x)
			(/ (- (f (+ x dx)) (f x))
		)
		dx
	)
)
```