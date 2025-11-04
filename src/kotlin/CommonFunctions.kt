object CommonFunctions {
    // 经典斐波那契数列函数
    fun fibonacci(n: Int): Int {
        tailrec fun loop(n: Int, a: Int, b: Int): Int {
            return if (n <= 0) a else loop(n - 1, b, a + b)
        }
        return loop(n, 0, 1)
    }

    // 经典快速排序函数
    fun quickSort(list: List<Int>): List<Int> = when {
        list.isEmpty() -> emptyList()
        else -> {
            val pivot = list.first()
            val (less, greater) = list.drop(1).partition { it < pivot }
            quickSort(less) + pivot + quickSort(greater)
        }
    }

    // 经典map函数实现
    fun <T, R> map(list: List<T>, transform: (T) -> R): List<R> {
        return list.fold(mutableListOf()) { acc, item ->
            acc.apply { add(transform(item)) }
        }
    }
}