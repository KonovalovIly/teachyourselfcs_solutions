# Topics
- idea of data
- Compound data
- List Structures
- Pairs
- Name shadowing


# Detail
## Compound data

How we can solve 1/2 + 1/4 = 3/4

We have abstraction
n1/d2 + n2/d2 = (n1d2 + n2d1)/d2d1

```lisp
(define (add_rat x y)
	(make_rat 
		(+  (x (numer x) (denom y))
			(x (numer y) (denom x))
		)
		(x (denom x) (denom y))
	)
)
```

### List strictions

(cons x y)
construct a pair whose first part is x and whose second part is y

(car p)
selects the first part of the pair p

(cdr p)
selects the second part of the pair p

### Pairs in inside

```lisp
(define (cons x y)
	(lambda (pick) 
		(cond ((= pick 1) x)
			  ((= pick 2) y)
		)
	)
)

(define (car x) (x 1))
(define (cdr x) (x 2))
```

### Tuple from this

```lisp
(define (tuple x y z)
	(lambda (pick) 
		(cond ((= pick 1) x)
			  ((= pick 2) y)
			  ((= pick 3) z)
		)
	)
)

(define (first x) (x 1))
(define (second x) (x 2))
(define (third x) (x 3))
```