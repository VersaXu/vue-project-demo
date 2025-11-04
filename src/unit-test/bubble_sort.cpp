#include <iostream>
#include <vector>

void bubbleSort(std::vector<int>& arr) {
    int n = arr.size();
    
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                // Swap elements
                std::swap(arr[j], arr[j + 1]);
            }
        }
    }
}

void printArray(const std::vector<int>& arr) {
    for (int value : arr) {
        std::cout << value << " ";
    }
    std::cout << std::endl;
}

int main() {
    std::vector<int> arr = {64, 34, 25, 12, 22, 11, 90};
    
    // 输出原始数组
    std::cout << "Original array: " << std::endl;
    printArray(arr);
    
    // 创建原始数组的副本，用于排序
    std::vector<int> sortedArr = arr;
    bubbleSort(sortedArr);
    
    // 输出排序后的数组
    std::cout << "Sorted array: " << std::endl;
    printArray(sortedArr);
    
    return 0;
}