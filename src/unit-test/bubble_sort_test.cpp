#include <gtest/gtest.h>

#include <algorithm>
#include <vector>

#include "your_header_file.h"  // Replace with the actual header file containing bubbleSort

int main(int argc, char* argv[]) {
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}

TEST(BubbleSortTest, AlreadySorted) {
    int arr[] = {1, 2, 3, 4, 5};
    int expected[] = {1, 2, 3, 4, 5};
    int n = sizeof(arr) / sizeof(arr[0]);

    bubbleSort(arr, n);

    EXPECT_TRUE(arraysEqual(arr, expected, n));
}

TEST(BubbleSortTest, ReverseSorted) {
    int arr[] = {5, 4, 3, 2, 1};
    int expected[] = {1, 2, 3, 4, 5};
    int n = sizeof(arr) / sizeof(arr[0]);

    bubbleSort(arr, n);

    EXPECT_TRUE(arraysEqual(arr, expected, n));
}

TEST(BubbleSortTest, DuplicateElements) {
    int arr[] = {4, 2, 3, 2, 5};
    int expected[] = {2, 2, 3, 4, 5};
    int n = sizeof(arr) / sizeof(arr[0]);

    bubbleSort(arr, n);

    EXPECT_TRUE(arraysEqual(arr, expected, n));
}

TEST(BubbleSortTest, NegativeNumbers) {
    int arr[] = {-3, -1, -2, -4, -5};
    int expected[] = {-5, -4, -3, -2, -1};
    int n = sizeof(arr) / sizeof(arr[0]);

    bubbleSort(arr, n);

    EXPECT_TRUE(arraysEqual(arr, expected, n));
}

TEST(BubbleSortTest, SingleElement) {
    int arr[] = {1};
    int expected[] = {1};
    int n = sizeof(arr) / sizeof(arr[0]);

    bubbleSort(arr, n);

    EXPECT_TRUE(arraysEqual(arr, expected, n));
}

TEST(BubbleSortTest, EmptyArray) {
    int arr[] = {};
    int expected[] = {};
    int n = sizeof(arr) / sizeof(arr[0]);

    bubbleSort(arr, n);

    EXPECT_TRUE(arraysEqual(arr, expected, n));
}

TEST(BubbleSortTest, LargeArray) {
    int arr[] = {10, 7, 8, 9, 1, 5, 3, 6, 2, 4};
    int expected[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    int n = sizeof(arr) / sizeof(arr[0]);

    bubbleSort(arr, n);

    EXPECT_TRUE(arraysEqual(arr, expected, n));
}

TEST(BubbleSortTest, SortsEmptyVector) {
    std::vector<int> arr = {};
    bubbleSort(arr);
    EXPECT_TRUE(arr.empty());
}

TEST(BubbleSortTest, SortsSingleElementVector) {
    std::vector<int> arr = {42};
    bubbleSort(arr);
    ASSERT_EQ(arr.size(), 1);
    EXPECT_EQ(arr[0], 42);
}

TEST(BubbleSortTest, SortsAlreadySortedVector) {
    std::vector<int> arr = {1, 2, 3, 4, 5};
    bubbleSort(arr);
    std::vector<int> expected = {1, 2, 3, 4, 5};
    EXPECT_EQ(arr, expected);
}

TEST(BubbleSortTest, SortsReverseSortedVector) {
    std::vector<int> arr = {5, 4, 3, 2, 1};
    bubbleSort(arr);
    std::vector<int> expected = {1, 2, 3, 4, 5};
    EXPECT_EQ(arr, expected);
}

TEST(BubbleSortTest, SortsRandomOrderVector) {
    std::vector<int> arr = {3, 6, 1, 8, 4};
    bubbleSort(arr);
    std::vector<int> expected = {1, 3, 4, 6, 8};
    EXPECT_EQ(arr, expected);
}

TEST(BubbleSortTest, SortsVectorWithDuplicates) {
    std::vector<int> arr = {4, 2, 4, 1, 2};
    bubbleSort(arr);
    std::vector<int> expected = {1, 2, 2, 4, 4};
    EXPECT_EQ(arr, expected);
}

TEST(BubbleSortTest, SortsLargeVector) {
    std::vector<int> arr = {10, 9, 8, 7, 6, 5, 4, 3, 2, 1};
    bubbleSort(arr);
    std::vector<int> expected = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    EXPECT_EQ(arr, expected);
}
