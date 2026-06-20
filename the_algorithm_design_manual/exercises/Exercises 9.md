1. https://leetcode.com/problems/subsets/ 
```cpp
class Solution {
public:
    vector<vector<int>> subsets(vector<int>& nums) {
        vector<vector<int>> result;
        vector<int> current;
        backtrack(nums, 0, current, result);
        return result;
    }
    
private:
    void backtrack(vector<int>& nums, int start, vector<int>& current, vector<vector<int>>& result) {
        result.push_back(current);
        
        for (int i = start; i < nums.size(); i++) {
            current.push_back(nums[i]);
            backtrack(nums, i + 1, current, result);
            current.pop_back();
        }
    }
};
```
2. https://leetcode.com/problems/remove-invalid-parentheses/ 
```cpp
class Solution {
public:
    vector<string> removeInvalidParentheses(string s) {
        unordered_set<string> result;
        
        int leftRemove = 0, rightRemove = 0;
        for (char c : s) {
            if (c == '(') {
                leftRemove++;
            } else if (c == ')') {
                if (leftRemove > 0) {
                    leftRemove--;
                } else {
                    rightRemove++;
                }
            }
        }
        
        dfs(s, 0, 0, 0, leftRemove, rightRemove, "", result);
        
        return vector<string>(result.begin(), result.end());
    }
    
private:
    void dfs(const string& s, int index, int leftCount, int rightCount,
             int leftRemove, int rightRemove, string path,
             unordered_set<string>& result) {
        
        if (index == s.length()) {
            if (leftRemove == 0 && rightRemove == 0 && leftCount == rightCount) {
                result.insert(path);
            }
            return;
        }
        
        char c = s[index];
        
        if (c != '(' && c != ')') {
            dfs(s, index + 1, leftCount, rightCount,
                leftRemove, rightRemove, path + c, result);
        } 
        else if (c == '(') {
            dfs(s, index + 1, leftCount + 1, rightCount,
                leftRemove, rightRemove, path + '(', result);
            
            if (leftRemove > 0) {
                dfs(s, index + 1, leftCount, rightCount,
                    leftRemove - 1, rightRemove, path, result);
            }
        } 
        else if (c == ')') {
            if (leftCount > rightCount) {
                dfs(s, index + 1, leftCount, rightCount + 1,
                    leftRemove, rightRemove, path + ')', result);
            }
            
            if (rightRemove > 0) {
                dfs(s, index + 1, leftCount, rightCount,
                    leftRemove, rightRemove - 1, path, result);
            }
        }
    }
};
```
3. https://leetcode.com/problems/word-search/
```cpp
class Solution {
public:
    bool exist(vector<vector<char>>& board, string word) {
        int m = board.size();
        int n = board[0].size();
        
        if (word.length() > m * n) return false;
        
        unordered_map<char, int> boardCount, wordCount;
        for (const auto& row : board) {
            for (char c : row) {
                boardCount[c]++;
            }
        }
        for (char c : word) {
            wordCount[c]++;
            if (wordCount[c] > boardCount[c]) return false;
        }
        
        if (wordCount[word[0]] > wordCount[word.back()]) {
            reverse(word.begin(), word.end());
        }
        
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (board[i][j] == word[0] && dfs(board, word, i, j, 0)) {
                    return true;
                }
            }
        }
        return false;
    }
    
private:
    bool dfs(vector<vector<char>>& board, string& word, 
             int i, int j, int index) {
        if (index == word.length()) return true;
        
        if (i < 0 || i >= board.size() || j < 0 || j >= board[0].size() ||
            board[i][j] != word[index]) {
            return false;
        }
        
        char temp = board[i][j];
        board[i][j] = '#';
        
        bool found = dfs(board, word, i + 1, j, index + 1) ||
                     dfs(board, word, i - 1, j, index + 1) ||
                     dfs(board, word, i, j + 1, index + 1) ||
                     dfs(board, word, i, j - 1, index + 1);
        
        board[i][j] = temp;
        return found;
    }
};
```