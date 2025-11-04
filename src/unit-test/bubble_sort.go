package main

import "fmt"

func bubbleSort(arr []int) []int {
	n := len(arr)
	
	for i := 0; i < n-1; i++ {
		for j := 0; j < n-i-1; j++ {
			if arr[j] > arr[j+1] {
				// Swap elements
				arr[j], arr[j+1] = arr[j+1], arr[j]
			}
		}
	}
	
	return arr
}

func main() {
	array := []int{64, 34, 25, 12, 22, 11, 90}
	
	fmt.Println("Original array:", array)
	
	sortedArray := make([]int, len(array))
	copy(sortedArray, array)
	sortedArray = bubbleSort(sortedArray)
	
	fmt.Println("Sorted array:", sortedArray)
}