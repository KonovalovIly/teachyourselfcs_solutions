1. https://leetcode.com/problems/binary-tree-cameras/
```cpp
class Solution {
public:
    int cameras = 0;
    int dfs(TreeNode* node) {
        if (!node) return 1;

        int left = dfs(node->left);
        int right = dfs(node->right);

        if (left == 0 || right == 0) {
            cameras++;
            return 2;
        }

        if (left == 2 || right == 2) {
            return 1;
        }
        return 0;
    }

    int minCameraCover(TreeNode* root) {
        int rootState = dfs(root);
        if (rootState == 0) {
            cameras++;
        }
        return cameras;
    }
};
```
2. https://leetcode.com/problems/edit-distance/
```cpp
class Solution {
public:
    int minDistance(string word1, string word2) {
        int m = word1.length();
        int n = word2.length();
        
        vector<int> prev(n + 1, 0);
        vector<int> curr(n + 1, 0);
        
        for (int j = 0; j <= n; j++) {
            prev[j] = j;
        }
        
        for (int i = 1; i <= m; i++) {
            curr[0] = i;
            
            for (int j = 1; j <= n; j++) {
                if (word1[i-1] == word2[j-1]) {
                    curr[j] = prev[j-1];
                } else {
                    curr[j] = 1 + min({prev[j],
                                      curr[j-1],
                                      prev[j-1]});
                }
            }
            swap(prev, curr);
        }
        
        return prev[n];
    }
};
```
3. https://leetcode.com/problems/maximum-product-of-splitted-binary-tree/ 
```cpp
class Solution {
private:
    const int MOD = 1e9 + 7;
    vector<long long> subtreeSums;
    
    long long calculateSums(TreeNode* root) {
        if (!root) return 0;
        long long sum = root->val + calculateSums(root->left) + calculateSums(root->right);
        subtreeSums.push_back(sum);
        return sum;
    }
    
public:
    int maxProduct(TreeNode* root) {
        long long totalSum = calculateSums(root);
        long long maxProduct = 0;
        
        for (long long sum : subtreeSums) {
            if (sum != totalSum) {
                long long product = sum * (totalSum - sum);
                if (product > maxProduct) {
                    maxProduct = product;
                }
            }
        }
        
        return maxProduct % MOD;
    }
};
```