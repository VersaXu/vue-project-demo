object CommonFunctions {
  // 经典斐波那契数列函数
  def fibonacci(n: Int): Int = {
    @annotation.tailrec
    def loop(n: Int, a: Int, b: Int): Int = {
      if (n <= 0) a
      else loop(n - 1, b, a + b)
    }
    loop(n, 0, 1)
  }

  // 经典快速排序函数
  def quickSort(list: List[Int]): List[Int] = list match {
    case Nil => Nil
    case pivot :: tail =>
      val (less, greater) = tail.partition(_ < pivot)
      quickSort(less) ::: pivot :: quickSort(greater)
  }

  // 经典map函数实现
  def map[A, B](list: List[A])(f: A => B): List[B] = list match {
    case Nil => Nil
    case x :: xs => f(x) :: map(xs)(f)
  }
}