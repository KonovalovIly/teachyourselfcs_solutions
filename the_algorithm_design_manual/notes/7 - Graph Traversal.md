7.1 Flavors of Graphs
	What Graphs is
	7.1.1 The Friendship Graph
		Example: graph of friendships (vertices = people, edges = friendships)
7.2 Data Structures for Graphs
	Adjacency matrix (O(n²)) vs adjacency list (O(n + m))
7.3 War Story: I was a Victim of Moore’s Law
	Story about how Moore's Law hurt the author
7.4 War Story: Getting the Graph
	Story about extracting a graph from real-world data
7.5 Traversing a Graph
	How to visit every vertex and every edge
7.6 Breadth-First Search
	Visit neighbors first, then neighbors of neighbors
	7.6.1 Exploiting Traversal
		Using the fact of traversal itself
	7.6.2 Finding Paths
		Finding shortest paths in unweighted graphs
7.7 Applications of Breadth-First Search
	What is Breadth-First Search
	7.7.1 Connected Components
		Finds all connected components
	7.7.2 Two-Coloring Graphs
		Checks if a graph is bipartite
7.8 Depth-First Search
	Go as far as possible, then backtrack
7.9 Applications of Depth-First Search
	What is Depth-First Search
	7.9.1 Finding Cycles
		Detecting cycles in a graph
	7.9.2 Articulation Vertices
		Finding cut vertices
7.10 Depth-First Search on Directed Graphs
	How Depth-First Search work on Directed Graphs
	7.10.1 Topological Sorting
		Ordering for DAGs
	7.10.2 Strongly Connected Components
		Finding SCCs
Final:
	Graphs are everywhere. BFS and DFS are the two basic building blocks. Almost any graph problem reduces to one of these traversals (or a combination of them).