//func makeAnswer() -> Int {
//    let nums = [1...9]
//    let answer = nums.randomElement()
//}
//
////let names = ["Zoey", "Chloe", "Amani", "Amaia"]
////let randomName = names.randomElement()!
//
//let numbers = 0...9
//let shuffledNumbers = numbers.shuffled()
//// shuffledNumbers == [1, 7, 6, 2, 8, 9, 4, 3, 5, 0]

func generateRandomNumbers() -> [Int] {
  """
  1~9 숫자 중 세 개를 뽑는 함수
  """
  var numbers = Array(1...9)
  numbers.shuffle()
  return Array(numbers[0..<3])
}
print(generateRandomNumbers())
