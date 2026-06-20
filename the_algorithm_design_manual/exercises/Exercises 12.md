1. https://leetcode.com/problems/split-array-with-same-average/
```cpp
class Solution {
public:
    bool splitArraySameAverage(vector<int>& nums) {
        int n = nums.size();
        if (n == 1) return false;
        
        int totalSum = accumulate(nums.begin(), nums.end(), 0);
    
        for (int k = 1; k <= n / 2; k++) {
            if ((totalSum * k) % n != 0) continue;
            
            int targetSum = totalSum * k / n;
            int leftSize = n / 2;
            int rightSize = n - leftSize;
            
            vector<vector<int>> leftSums(leftSize + 1);
            vector<vector<int>> rightSums(rightSize + 1);
            
            for (int mask = 0; mask < (1 << leftSize); mask++) {
                int sum = 0;
                int cnt = 0;
                for (int i = 0; i < leftSize; i++) {
                    if (mask & (1 << i)) {
                        sum += nums[i];
                        cnt++;
                    }
                }
                leftSums[cnt].push_back(sum);
            }
            
            for (int mask = 0; mask < (1 << rightSize); mask++) {
                int sum = 0;
                int cnt = 0;
                for (int i = 0; i < rightSize; i++) {
                    if (mask & (1 << i)) {
                        sum += nums[leftSize + i];
                        cnt++;
                    }
                }
                rightSums[cnt].push_back(sum);
            }
            
            for (int cnt = 0; cnt <= rightSize; cnt++) {
                sort(rightSums[cnt].begin(), rightSums[cnt].end());
            }
            
            for (int leftCnt = 0; leftCnt <= leftSize; leftCnt++) {
                int rightCnt = k - leftCnt;
                if (rightCnt < 0 || rightCnt > rightSize) continue;
                
                for (int leftSum : leftSums[leftCnt]) {
                    int needed = targetSum - leftSum;
                    auto& vec = rightSums[rightCnt];
                    if (binary_search(vec.begin(), vec.end(), needed)) {
                        return true;
                    }
                }
            }
        }
        
        return false;
    }
};
```
2. https://leetcode.com/problems/smallest-sufficient-team/
```cpp
class Solution {
public:
    vector<int> smallestSufficientTeam(vector<string>& req_skills, 
                                        vector<vector<string>>& people) {
        int n = req_skills.size();
        int m = people.size();
        
        unordered_map<string, int> skillToBit;
        for (int i = 0; i < n; i++) {
            skillToBit[req_skills[i]] = i;
        }
        
        vector<int> personMask(m, 0);
        for (int i = 0; i < m; i++) {
            int mask = 0;
            for (const string& skill : people[i]) {
                mask |= (1 << skillToBit[skill]);
            }
            personMask[i] = mask;
        }
        
        vector<vector<int>> dp(1 << n);
        
        for (int i = 0; i < (1 << n); i++) {
            dp[i] = vector<int>(m + 1, -1);
        }
        
        vector<vector<int>> best(1 << n);
        vector<int> teamSize(1 << n, INT_MAX);
        teamSize[0] = 0;
        best[0] = {};
        
        for (int mask = 0; mask < (1 << n); mask++) {
            if (teamSize[mask] == INT_MAX) continue;
            
            for (int i = 0; i < m; i++) {
                int newMask = mask | personMask[i];
                
                if (teamSize[newMask] > teamSize[mask] + 1) {
                    teamSize[newMask] = teamSize[mask] + 1;
                    best[newMask] = best[mask];
                    best[newMask].push_back(i);
                }
            }
        }
        
        return best[(1 << n) - 1];
    }
};
```
3. https://leetcode.com/problems/longest-palindromic-substring/
```cpp
class Solution {
public:
    string longestPalindrome(string s) {
        if (s.empty()) return "";
        
        int start = 0, maxLen = 1;
        
        auto expand = [&](int left, int right) {
            while (left >= 0 && right < s.length() && s[left] == s[right]) {
                left--;
                right++;
            }
            int len = right - left - 1;
            if (len > maxLen) {
                maxLen = len;
                start = left + 1;
            }
        };
        
        for (int i = 0; i < s.length(); i++) {
            expand(i, i);
            expand(i, i + 1);
        }
        
        return s.substr(start, maxLen);
    }
};
```