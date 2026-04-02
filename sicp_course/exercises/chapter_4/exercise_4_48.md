## 🧠 Understanding the Original Grammar

From *SICP*, the basic grammar rules are:

```scheme
(sentence → (simple-sentence))
(simple-sentence → (noun-phrase verb-phrase))
(noun-phrase → (article noun)
              (noun-phrase prepositional-phrase))
(verb-phrase → (verb)
             (verb-phrase prepositional-phrase))
(prepositional-phrase → (preposition noun-phrase))
```

This allows parsing of simple English sentences, like:

```
The professor lectures in class.
```

But it doesn't handle:
- Adjectives: “the tall student”
- Adverbs: “quickly runs”
- Compound sentences: “The professor lectures and the student sleeps.”

Let’s extend this step by step.

---

## ✅ Part 1: Adding **Adjectives**

We can allow noun phrases to include optional adjectives before the noun.

### 🔁 Updated Grammar Rule

```scheme
(noun-phrase → (article adjective* noun)
              (article noun)
              (noun-phrase prepositional-phrase))
```

### 🛠️ Implementing It in Scheme

First, define some sample adjectives:

```scheme
(define *adjectives*
  '((adjective fast)
    (adjective slow)
    (adjective tall)
    (adjective lazy)))
```

Then update `parse-simple-noun-phrase`:

```scheme
(define (parse-simple-noun-phrase)
  (list 'simple-noun-phrase
        (parse-word articles)
        (maybe-adjective)
        (parse-word nouns)))

(define (maybe-adjective)
  (amb #f (parse-word adjectives)))
```

Now we can parse:

```
"The tall student"
→ (simple-noun-phrase (article the) (adjective tall) (noun student))
```

Or just:

```
"The student"
→ (simple-noun-phrase (article the) (noun student))
```

---

## ✅ Part 2: Adding **Adverbs**

Adverbs modify verbs, so they should appear in verb phrases.

### 🔁 Grammar Update

```scheme
(verb-phrase → (verb)
              (adverb verb)
              (verb-phrase prepositional-phrase))
```

### 🛠️ Implementation

Define some adverbs:

```scheme
(define *adverbs*
  '((adverb quickly)
    (adverb slowly)
    (adverb lazily)))
```

Update `parse-verb-phrase`:

```scheme
(define (parse-verb-phrase)
  (amb
   (parse-word verbs)
   (let ((adv (parse-word adverbs))
         (v (parse-word verbs)))
     (list 'adverbial-verb adv v))
   (make-verb-phrase
    (parse-verb-phrase)
    (parse-prepositional-phrase))))
```

Now you can parse:

```
"Quickly runs" → (adverbial-verb (adverb quickly) (verb runs))
```

And compound verb phrases:

```
"Runs quickly to the store" → (verb-phrase (adverbial-verb ...) (prep-phrase ...))
```

---

## ✅ Part 3: Supporting **Compound Sentences**

To handle sentences like:

```
"The professor lectures and the student studies."
```

You need a way to combine two or more sentences.

### 🔁 Grammar Update

```scheme
(sentence → (simple-sentence)
            (compound-sentence))
(compound-sentence → (simple-sentence conjunction simple-sentence))
```

### 🛠️ Implementation

Add conjunctions:

```scheme
(define *conjunctions*
  '((conjunction and)
    (conjunction but)
    (conjunction or)))
```

Then define `parse-compound-sentence`:

```scheme
(define (parse-compound-sentence)
  (let ((first (parse-simple-sentence)))
    (let ((conj (parse-word conjunctions)))
      (let ((second (parse-simple-sentence)))
        (list 'compound-sentence first conj second)))))
```

Now your parser can understand:

```
"The professor lectures and the student studies."
→ (compound-sentence
   (simple-sentence ...)
   (conjunction and)
   (simple-sentence ...))
```

---

## 📌 Summary of Extensions

| Feature | Description |
|--------|-------------|
| Goal | Extend the parser to handle richer grammar |
| Adjectives | Optional modifiers in noun phrases |
| Adverbs | Modify verbs directly |
| Compound Sentences | Combine two or more with conjunctions |
| Core Idea | Use `amb` to explore multiple grammatical interpretations |
| Key Challenge | Ensure recursive calls don’t cause infinite loops |

---

## 💡 Final Thought

This exercise shows how to build up a full **natural language parser** using only basic tools:
- `amb` for exploring possibilities
- Recursive structure matching the grammar
- `require` to filter out invalid parses

It's a great example of how logic programming and constraint-based systems can be used to model **linguistic ambiguity** and **structure**.
