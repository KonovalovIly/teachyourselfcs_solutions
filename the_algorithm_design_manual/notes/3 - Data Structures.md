Best to choose the right data structure from the beginning  
3.1 Contiguous vs Linked Data Structures
	Two main types of data structures  
	3.1.1 Arrays
		Structure with continuous data boxes with fast access by index  
	3.1.2 Pointers and Linked Structures
		Linked structures hold data and link to the next bucket with data
	3.1.3 Comparison
		Both of them have advantages and disadvantages
3.2 Containers: Stacks and Queues
	Fifo and lifo structures  
3.3 Dictionaries
	Structures with key and value storage are better in the way of tasks
3.4 Binary Search Trees
	Structure with both advantages fast search and flexible update
	3.4.1 Implementing Binary Search Trees
		How this structure will look and what functions have
	3.4.2 How Good are Binary Search Trees? 
		Our first realization has one defect if insert Operation will be performed in sorted order
	3.4.3 Balanced Search Trees
		Realization with always best depth but little worst insert and delete because of rebalance
3.5 Priority Queues
	Priority queue best for insertion and deletion with priority order
3.6 War Story: Stripping Triangulations
	Algorithm for lighter weight of 3d polygons
3.7 Hashing
	Special case for dictionary
	3.7.1 Collision Resolution
		We have two ways to solve the collision problem, and one of them open indexing. This system is used in golang  
	3.7.2 Duplicate Detection via Hashing
		Hashing is a very important algorithm and used a lot in different ways 
	3.7.3 Other Hashing Tricks
		Other hashing
	3.7.4 Canonicalization
		Sometimes collision may be helpful
	3.7.5 Compaction
		Hash may be just prefix from big string 
3.8 Specialized Data Structures
	A little bit of different structures in programming  
3.9 War Story: String’em Up
	Algorithms usage in biology 
Final: choosing the right structure is a half way of solution