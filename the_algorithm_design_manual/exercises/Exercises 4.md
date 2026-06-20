1. https://leetcode.com/problems/sort-list/ 
```c 
struct ListNode* sortList(struct ListNode* head) {
    if (head == NULL || head->next == NULL) {
        return head;
    }
    struct ListNode* slow = head;
    struct ListNode* fast = head->next;

    // find half
    while (fast && fast->next) {
        slow = slow->next;
        fast = fast->next->next;
    }
    
    // split 
    struct ListNode* first = head;
    struct ListNode* second = slow->next;
    slow->next = NULL;

    first = sortList(first);
    second = sortList(second);
    // create dummy and add to next
    struct ListNode dummy;
    struct ListNode* tail = &dummy;
    dummy.next = NULL;

    while (first && second) {
        if (first->val < second->val) {
            tail->next = first;
            first = first->next;
        } else {
            tail->next = second;
            second = second->next;
        }
        tail = tail->next;
    }

    if (first) tail->next = first;
    if (second) tail->next = second;

    return dummy.next;
}
```
2. https://leetcode.com/problems/queue-reconstruction-by-height/ 
```c 
static int cmp_int(const void* a, const void* b) {
    int* firstPerson = *(int**)a;
    int* secondPerson = *(int**)b;
    
    if (firstPerson[0] == secondPerson[0]) {
        return firstPerson[1] - secondPerson[1];
    }
    return secondPerson[0] - firstPerson[0];
}

int** reconstructQueue(int** people, int peopleSize, int* peopleColSize, int* returnSize, int** returnColumnSizes){
    
	qsort(people, peopleSize, sizeof(int*), cmp_int);
    
    *returnSize = peopleSize;
    *returnColumnSizes = (int*)malloc(peopleSize*sizeof(int));
    
    int ** ans = (int**)malloc(peopleSize * sizeof(int*));
    
    for (int i = 0; i < peopleSize; i++) {
        (*returnColumnSizes)[i] = 2;
        ans[i] = (int*)malloc(2 * sizeof(int));
        
        for (int j = i; j > people[i][1]; j--) {
            ans[j][0] = ans[j-1][0];
            ans[j][1] = ans[j-1][1];
        }
        ans[people[i][1]][0] = people[i][0];
        ans[people[i][1]][1] = people[i][1];
    }
    
    
    return ans;
}
```
3. https://leetcode.com/problems/merge-k-sorted-lists/ 
```c
struct ListNode* mergeTwoLists(struct ListNode* l1, struct ListNode* l2) {
    if (!l1) return l2;
    if (!l2) return l1;
    
    struct ListNode dummy;
    struct ListNode* tail = &dummy;
    dummy.next = NULL;
    
    while (l1 && l2) {
        if (l1->val < l2->val) {
            tail->next = l1;
            l1 = l1->next;
        } else {
            tail->next = l2;
            l2 = l2->next;
        }
        tail = tail->next;
    }
    
    tail->next = l1 ? l1 : l2;
    return dummy.next;
}


struct ListNode* mergeLists(struct ListNode** lists, int start, int end) {
    if (start >= end) {
        return NULL;
    }
    
    if (start + 1 == end) {
        return lists[start];
    }
    
    int mid = start + (end - start) / 2;
    
    struct ListNode* leftSorted = mergeLists(lists, start, mid);
    struct ListNode* rightSorted = mergeLists(lists, mid, end);
    return mergeTwoLists(leftSorted, rightSorted);
}

struct ListNode* mergeKLists(struct ListNode** lists, int listsSize) {
    if (listsSize == 0) {
        return NULL;
    }
    return mergeLists(lists, 0, listsSize);
}
```
4. https://leetcode.com/problems/find-k-pairs-with-smallest-sums/
```c 
typedef struct {
    int i;
    int j;
    int sum;
} HeapNode;

void swap(HeapNode* a, HeapNode* b) {
    HeapNode temp = *a;
    *a = *b;
    *b = temp;
}

void heapifyUp(HeapNode* heap, int idx) {
    while (idx > 0) {
        int parent = (idx - 1) / 2;
        if (heap[idx].sum < heap[parent].sum) {
            swap(&heap[idx], &heap[parent]);
            idx = parent;
        } else break;
    }
}

void heapifyDown(HeapNode* heap, int size, int idx) {
    while (1) {
        int left = 2 * idx + 1;
        int right = 2 * idx + 2;
        int smallest = idx;
        
        if (left < size && heap[left].sum < heap[smallest].sum)
            smallest = left;
        if (right < size && heap[right].sum < heap[smallest].sum)
            smallest = right;
        
        if (smallest == idx) break;
        
        swap(&heap[idx], &heap[smallest]);
        idx = smallest;
    }
}

void push(HeapNode* heap, int* size, int i, int j, int sum) {
    heap[*size].i = i;
    heap[*size].j = j;
    heap[*size].sum = sum;
    heapifyUp(heap, *size);
    (*size)++;
}

HeapNode pop(HeapNode* heap, int* size) {
    HeapNode top = heap[0];
    (*size)--;
    heap[0] = heap[*size];
    heapifyDown(heap, *size, 0);
    return top;
}

int** kSmallestPairs(int* nums1, int nums1Size, int* nums2, int nums2Size, int k, int* returnSize, int** returnColumnSizes) {
    if (nums1Size == 0 || nums2Size == 0 || k == 0) {
        *returnSize = 0;
        *returnColumnSizes = NULL;
        return NULL;
    }
    
    long long maxPairs = (long long)nums1Size * nums2Size;
    if (k > maxPairs) k = (int)maxPairs;
    
    *returnSize = k;
    *returnColumnSizes = (int*)malloc(k * sizeof(int));
    int** result = (int**)malloc(k * sizeof(int*));
    
    HeapNode* heap = (HeapNode*)malloc(k * sizeof(HeapNode));
    int heapSize = 0;
    
    int initSize = (k < nums1Size) ? k : nums1Size;
    for (int i = 0; i < initSize; i++) {
        push(heap, &heapSize, i, 0, nums1[i] + nums2[0]);
    }
    
    for (int idx = 0; idx < k; idx++) {
        HeapNode current = pop(heap, &heapSize);
        
        result[idx] = (int*)malloc(2 * sizeof(int));
        result[idx][0] = nums1[current.i];
        result[idx][1] = nums2[current.j];
        (*returnColumnSizes)[idx] = 2;
        
        if (current.j + 1 < nums2Size) {
            push(heap, &heapSize, current.i, current.j + 1, 
                 nums1[current.i] + nums2[current.j + 1]);
        }
    }
    
    free(heap);
    return result;
}
```