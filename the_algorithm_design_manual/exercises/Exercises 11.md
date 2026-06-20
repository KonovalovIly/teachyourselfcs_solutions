1. https://leetcode.com/problems/target-sum/
```cpp
class Solution {
private:
    unordered_map<string, int> memo;
    
    int dfs(vector<int>& nums, int target, int index, int currentSum) {
        if (index == nums.size()) {
            return currentSum == target ? 1 : 0;
        }
        
        string key = to_string(index) + "," + to_string(currentSum);
        if (memo.count(key)) {
            return memo[key];
        }
        
        // Добавляем знак +
        int plus = dfs(nums, target, index + 1, currentSum + nums[index]);
        // Добавляем знак -
        int minus = dfs(nums, target, index + 1, currentSum - nums[index]);
        
        memo[key] = plus + minus;
        return memo[key];
    }
    
public:
    int findTargetSumWays(vector<int>& nums, int target) {
        return dfs(nums, target, 0, 0);
    }
};
```
2. https://leetcode.com/problems/word-break-ii/
```cpp
class Solution {
private:
    unordered_set<string> wordSet;
    vector<string> result;
    
    void backtrack(string& s, int start, vector<string>& current, 
                   vector<bool>& dp, vector<vector<int>>& nextWords) {
        if (start == s.length()) {
            string sentence = current[0];
            for (int i = 1; i < current.size(); i++) {
                sentence += " " + current[i];
            }
            result.push_back(sentence);
            return;
        }
        
        for (int end : nextWords[start]) {
            string word = s.substr(start, end - start + 1);
            current.push_back(word);
            backtrack(s, end + 1, current, dp, nextWords);
            current.pop_back();
        }
    }
    
public:
    vector<string> wordBreak(string s, vector<string>& wordDict) {
        wordSet = unordered_set<string>(wordDict.begin(), wordDict.end());
        int n = s.length();
        
        vector<bool> dp(n + 1, false);
        dp[n] = true;
        
        vector<vector<int>> nextWords(n);
        
        for (int i = n - 1; i >= 0; i--) {
            for (int j = i; j < n; j++) {
                string word = s.substr(i, j - i + 1);
                if (wordSet.count(word) && dp[j + 1]) {
                    dp[i] = true;
                    nextWords[i].push_back(j);
                }
            }
        }
        
        if (!dp[0]) return {};
        
        vector<string> current;
        backtrack(s, 0, current, dp, nextWords);
        
        return result;
    }
};
```
3. https://leetcode.com/problems/number-of-squareful-arrays/
```cpp
class Solution {
private:
    unordered_map<int, int> freq;
    unordered_map<int, vector<int>> validNext;
    int n;
    int result;
    
    bool isPerfectSquare(int num) {
        int root = sqrt(num);
        return root * root == num;
    }
    
    void buildGraph(vector<int>& nums) {
        // Убираем дубликаты для построения графа
        unordered_set<int> uniqueNums(nums.begin(), nums.end());
        
        // Для каждого уникального числа находим все возможные следующие числа
        for (int a : uniqueNums) {
            for (int b : uniqueNums) {
                if (isPerfectSquare(a + b)) {
                    // Если это одно и то же число, проверяем частоту
                    if (a == b && freq[a] < 2) continue;
                    validNext[a].push_back(b);
                }
            }
        }
    }
    
    void backtrack(int last, int remaining) {
        if (remaining == 0) {
            result++;
            return;
        }
        
        // Пробуем все возможные следующие числа
        for (int next : validNext[last]) {
            if (freq[next] > 0) {
                freq[next]--;
                backtrack(next, remaining - 1);
                freq[next]++;
            }
        }
    }
    
public:
    int numSquarefulPerms(vector<int>& nums) {
        n = nums.size();
        result = 0;
        
        // Подсчитываем частоту каждого числа
        for (int num : nums) {
            freq[num]++;
        }
        
        // Строим граф возможных переходов
        buildGraph(nums);
        
        // Начинаем с каждого уникального числа
        for (auto& [num, count] : freq) {
            if (count > 0) {
                freq[num]--;
                backtrack(num, n - 1);
                freq[num]++;
            }
        }
        
        return result;
    }
};
```