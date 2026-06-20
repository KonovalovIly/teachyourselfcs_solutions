11.1 Problems and Reductions
	 reduce A→B, solve B → solved A.
	11.1.1 The Key Idea
		 unknown → known
	11.1.2 Decision Problems
		"yes/no" easier than optimization
11.2 Reductions for Algorithms
	Reduction speeds up
	11.2.1 Closest Pair
		Reduced to sorting
	11.2.2 Longest Increasing Subsequence
		Reduced to LCS
	11.2.3 Least Common Multiple
		Reduced to GCD
	11.2.4 Convex Hull
		Reduced to sorting
11.3 Elementary Hardness Reductions
	 First NP-hard problems
	11.3.1 Hamiltonian Cycle
		 Visit all vertices
	11.3.2 Independent Set and Vertex Cover
		Reducible to each other
	11.3.3 Clique
		Reduces to Independent Set
11.4 Satisfiability
	Ancestor of all NP-complete
	11.4.1 3-Satisfiability
		Special case, still NP-complete
11.5 Creative Reductions from SAT
	Proving NP-hardness
	11.5.1 Vertex Cover 
		 Reduce 3-SAT to cover
	11.5.2 Integer Programming
		 Integer programming is NP-hard
11.6 The Art of Proving Hardness
	Restriction, local replacement, components
11.7 War Story: Hard Against the Clock
	Real reduction under deadline
11.8 War Story: And Then I Failed
	Example of wrong reduction
11.9 P vs. NP
	Biggest CS question
	11.9.1 Verification vs. Discovery
		Verify easy, find hard
	11.9.2 The Classes P and NP
		 P = fast, NP = fast verification
	11.9.3 Why Satisfiability is Hard
		Combinatorial explosion
	11.9.4 NP-hard vs. NP-complete?
		NP-hard ≥ NP, NP-complete ∈ NP
Final:
	Reduction is key: algorithms use it for speed, hardness theory uses it for proving difficulty. P vs. NP asks: "easy to verify = easy to find?" Nobody knows yet.