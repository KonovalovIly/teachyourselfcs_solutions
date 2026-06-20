# LeetCode 
1. https://leetcode.com/problems/validate-binary-search-tree/ 
``` c
bool validate(struct TreeNode* node, long min_val, long max_val) {
    if (node == NULL) {
        return true;
    }
    if (node->val <= min_val || node->val >= max_val) {
        return false;
    }
    return validate(node->left, min_val, node->val) && validate(node->right, node->val, max_val);
}

bool isValidBST(struct TreeNode* root) {
    return validate(root, -2147483649L, 2147483648L);
}
```
2. https://leetcode.com/problems/count-of-smaller-numbers-after-self/ 
``` c
#include <stdlib.h>
#include <string.h>

static int cmp_int(const void* a, const void* b) {
    return *(int*)a - *(int*)b;
}

static int lower_bound(int* arr, int size, int value) {
    int lo = 0, hi = size;
    while (lo < hi) {
        int mid = lo + (hi - lo) / 2;
        if (arr[mid] < value)
            lo = mid + 1;
        else
            hi = mid;
    }
    return lo;
}

typedef struct {
    int* tree;
    int size;
} Fenwick;

Fenwick* fenwick_create(int size) {
    Fenwick* ft = (Fenwick*)malloc(sizeof(Fenwick));
    ft->tree = (int*)calloc(size + 1, sizeof(int));
    ft->size = size;
    return ft;
}

void fenwick_update(Fenwick* ft, int idx, int delta) {
    while (idx <= ft->size) {
        ft->tree[idx] += delta;
        idx += idx & -idx;
    }
}

int fenwick_query(Fenwick* ft, int idx) {
    int sum = 0;
    while (idx > 0) {
        sum += ft->tree[idx];
        idx -= idx & -idx;
    }
    return sum;
}

void fenwick_free(Fenwick* ft) {
    free(ft->tree);
    free(ft);
}

int* countSmaller(int* nums, int numsSize, int* returnSize) {
    *returnSize = numsSize;
    if (numsSize == 0) {
        return NULL;
    }

    int* sorted = (int*)malloc(numsSize * sizeof(int));
    memcpy(sorted, nums, numsSize * sizeof(int));
    qsort(sorted, numsSize, sizeof(int), cmp_int);

    int uniqueSize = 1;
    for (int i = 1; i < numsSize; ++i) {
        if (sorted[i] != sorted[uniqueSize - 1]) {
            sorted[uniqueSize++] = sorted[i];
        }
    }

    Fenwick* ft = fenwick_create(uniqueSize);

    int* counts = (int*)malloc(numsSize * sizeof(int));
    for (int i = numsSize - 1; i >= 0; --i) {
        int rank = lower_bound(sorted, uniqueSize, nums[i]) + 1;
        counts[i] = fenwick_query(ft, rank - 1);
        fenwick_update(ft, rank, 1);
    }

    free(sorted);
    fenwick_free(ft);
    return counts;
}
```
3. https://leetcode.com/problems/construct-binary-tree-from-preorder-and-inorder-traversal/
```c
struct TreeNode* buildTreeHelper(int* preorder, int preStart, int preEnd,
                                 int* inorder, int inStart, int inEnd) {
    if (preStart > preEnd || inStart > inEnd) {
        return NULL;
    }

    int rootVal = preorder[preStart];
    struct TreeNode* root = (struct TreeNode*)malloc(sizeof(struct TreeNode));
    root->val = rootVal;
    root->left = NULL;
    root->right = NULL;

    int rootIndex;
    for (rootIndex = inStart; rootIndex <= inEnd; ++rootIndex) {
        if (inorder[rootIndex] == rootVal) {
            break;
        }
    }

    int leftSize = rootIndex - inStart;

    root->left = buildTreeHelper(preorder, preStart + 1, preStart + leftSize,
                                 inorder, inStart, rootIndex - 1);
    root->right = buildTreeHelper(preorder, preStart + leftSize + 1, preEnd,
                                  inorder, rootIndex + 1, inEnd);

    return root;
}

struct TreeNode* buildTree(int* preorder, int preorderSize, int* inorder, int inorderSize) {
    if (preorderSize == 0 || inorderSize == 0) {
        return NULL;
    }
    return buildTreeHelper(preorder, 0, preorderSize - 1, inorder, 0, inorderSize - 1);
}
```