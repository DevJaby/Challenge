func calc(a: Int, b: Int, op: String) -> String {
  switch op {
    case "+":
      return "\(a) + \(b) = \(a + b)"
    case "-":
      return "\(a) - \(b) = \(a - b)"
    case "*":
      return "\(a) * \(b) = \(a * b)"
    case "/":
      if b == 0 {
        return "숫자 아님"
      } else {
        return "\(a) / \(b) = \(a / b)"
      }
    default:
      return "사용할 수 없는 연산자입니다."
  }
}

//출력 예시
let a = 10
let op = "/"
let b = 2

print(calc(a: a, b: b, op: op))
