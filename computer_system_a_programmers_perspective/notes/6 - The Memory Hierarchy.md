# Chapter 6  The Memory Hierarchy
[[Practice Problems 6]]
Chapter about memory work 
6.1 Storage Technologies
	Types of memory
	6.1.1 Random Access Memory
		RAM memory is our DDR fast and expensive
	6.1.2 Disk Storage
		HDD storage with ancient technology 
	6.1.3 Solid State Disks
		SSD mach faster
	6.1.4 Storage Technology Trends
		Trends of storage evolution 
6.2 Locality
	What locality is and why it is important
	6.2.1 Locality of References to Program Data
		What is good locality in code
	6.2.2 Locality of Instruction Fetches
		Locality when instruction reading
	6.2.3 Summary of Locality
		Importance of Locality
6.3 The Memory Hierarchy
	Pyramid of memory
	6.3.1 Caching in the Memory Hierarchy
		How cache work
	6.3.2 Summary of Memory Hierarchy Concepts
		Summary in caching
6.4 Cache Memories
	How it look
	6.4.1 Generic Cache Memory Organization
		Tags, sets, blocks
	6.4.2 Direct-Mapped Caches
		Direct mapping cache 
	6.4.3 Set Associative Caches
		Associative cache 
	6.4.4 Fully Associative Caches
		Fully Associative Caches
	6.4.5 Issues with Writes
		What raise when we write to memory
	6.4.6 Anatomy of a Real Cache Hierarchy
		 How it look in intel i7
	6.4.7 Performance Impact of Cache Parameters
		How caching impact on perfomance
6.5 Writing Cache-Friendly Code
	What part of code should attract our attention for better cache perfomance 
6.6 Putting It Together: The Impact of Caches on Program Performance
	Impact of caching
	6.6.1 The Memory Mountain
		Graph of throughput by cache memory 
	6.6.2 Rearranging Loops to Increase Spatial Locality
		Rearranging two dimentional array for best caching
	6.6.3 Exploiting Locality in Your Programs
		Anouther one remainder about importance of cache
6.7 Summary
	Memory cache is one of important part of programming