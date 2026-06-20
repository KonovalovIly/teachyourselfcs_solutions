1. https://leetcode.com/problems/cheapest-flights-within-k-stops/ 
```cpp
class Solution {
public:
    int findCheapestPrice(int n, vector<vector<int>>& flights, int src, int dst, int k) {
        vector<int> dist(n, INT_MAX);
        dist[src] = 0;
        
        for (int i = 0; i <= k; i++) {
            vector<int> temp = dist;
            
            for (const auto& flight : flights) {
                int from = flight[0];
                int to = flight[1];
                int price = flight[2];
                
                if (dist[from] != INT_MAX) {
                    if (temp[to] > dist[from] + price) {
                        temp[to] = dist[from] + price;
                    }
                }
            }
            
            dist = temp;
        }
        
        return dist[dst] == INT_MAX ? -1 : dist[dst];
    }
};
```
2. https://leetcode.com/problems/network-delay-time/
```cpp
class Solution {
public:
    int networkDelayTime(vector<vector<int>>& times, int n, int k) {
        vector<vector<pair<int, int>>> adj(n + 1);
        for (const auto& time : times) {
            int u = time[0], v = time[1], w = time[2];
            adj[u].push_back({v, w});
        }
        
        priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> pq;
        vector<int> dist(n + 1, INT_MAX);
        
        dist[k] = 0;
        pq.push({0, k});
        
        while (!pq.empty()) {
            auto [currTime, node] = pq.top();
            pq.pop();
            
            if (currTime > dist[node]) {
                continue;
            }
            
            for (const auto& [neighbor, weight] : adj[node]) {
                int newTime = currTime + weight;
                if (newTime < dist[neighbor]) {
                    dist[neighbor] = newTime;
                    pq.push({newTime, neighbor});
                }
            }
        }
        
        int maxTime = 0;
        for (int i = 1; i <= n; i++) {
            if (dist[i] == INT_MAX) {
                return -1;
            }
            maxTime = max(maxTime, dist[i]);
        }
        
        return maxTime;
    }
};
```
3. https://leetcode.com/problems/find-the-city-with-the-smallest-number-of-neighbors-at-a-threshold-distance/
```cpp
class Solution {
public:
    int findTheCity(int n, vector<vector<int>>& edges, int distanceThreshold) {
        vector<vector<pair<int, int>>> adj(n);
        for (const auto& edge : edges) {
            int u = edge[0], v = edge[1], w = edge[2];
            adj[u].push_back({v, w});
            adj[v].push_back({u, w});
        }
        
        int bestCity = -1;
        int minReachable = n;
        
        for (int src = 0; src < n; src++) {
            vector<int> dist(n, INT_MAX);
            dist[src] = 0;
            priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> pq;
            pq.push({0, src});
            
            while (!pq.empty()) {
                auto [currDist, node] = pq.top();
                pq.pop();
                
                if (currDist > dist[node]) continue;
                
                for (const auto& [neighbor, weight] : adj[node]) {
                    int newDist = currDist + weight;
                    if (newDist < dist[neighbor]) {
                        dist[neighbor] = newDist;
                        pq.push({newDist, neighbor});
                    }
                }
            }
            
            int reachable = 0;
            for (int i = 0; i < n; i++) {
                if (i != src && dist[i] <= distanceThreshold) {
                    reachable++;
                }
            }
            
            if (reachable < minReachable) {
                minReachable = reachable;
                bestCity = src;
            } else if (reachable == minReachable) {
                bestCity = max(bestCity, src);
            }
        }
        
        return bestCity;
    }
};
```