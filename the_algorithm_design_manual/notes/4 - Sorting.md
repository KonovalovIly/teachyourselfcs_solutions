Sorting algorithms is not allways about sorting
4.1 Applications of Sorting
	For most of problems we can apply sort like first step to prepeare data. But this is not golden key
4.2 Pragmatics of Sorting
	Ideas in practical evaluation of sorting algorithms. And rule for them
4.3 Heapsort: Fast Sorting via Data Structures
	Sometimes we just need choose right data structure and sort algorithm will get massive improve
	4.3.1 Heaps
		Heap isbest by memory hierarhy structure without pointers, but with some tree advantages
	4.3.2 Constructing Heaps
		Whet we want insert number in heap we add them to the end and bubble up to right place
	4.3.3 Extracting the Minimum
		Algoritms for extracting minimum value from heap. And how can we use heap in sort
	4.3.4 Faster Heap Construction
		Creating heap from array in place
	4.3.5 Sorting by Incremental Insertion
		This algorithm may be a faster becouse we insert just uncorrect numbers
4.4 War Story: Give me a Ticket on an Airplane
	Applying sort rule for chipest ticket
4.5 Mergesort: Sorting by Divide and Conquer
	We split our array on half and sort half until get final array
4.6 Quicksort: Sorting by Randomization
	How quicksort work
	4.6.1 Intuition: The Expected Case for Quicksort
		Is random pick point worth it?
	4.6.2 Randomized Algorithms
		Some random algorithms with may be helpful
	4.6.3 Is Quicksort Really Quick?
		You just pick quick sort because of the fact
4.7 Distribution Sort: Sorting via Bucketing
	Bucket sort for cases there we have strong feeling what data has good distribution
	4.7.1 Lower Bounds for Sorting
		Proof that sort algorithms can't be less n logn
4.8 War Story: Skiena for the Defense
	You should keep attention on hardware limitation. And dont go to the court
Final: Sorting algorithms is key for some types of problem