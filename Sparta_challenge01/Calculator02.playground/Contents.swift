class Calculator {
    var num1: Double = 0 // 첫번째 숫자 선언
    var num2: Double = 0 // 두번째 숫자 선언
    var operation: String = "" // 연산자
    
    // 덧셈 연산 함수
    func add(num1: Double, num2: Double) -> Double {
        return num1 + num2
    }
    // 빼기 연산 함수
    func subtract(num1: Double, num2: Double) -> Double {
        return num1 - num2
    }
    // 곱하기 연산 함수
    func multiply(num1: Double, num2: Double) -> Double {
        return num1 * num2
    }
    // 나누기 연산 함수
    func divide(num1: Double, num2: Double) -> Double? {
        return num2 != 0 ? num1 / num2 : nil
    }
    // 계산 실행 함수
    func calculate() -> Double {
        var result: Double = 0
        switch operation {
        case "+":
            result = add(num1: num1, num2: num2)
        case "-":
            result = subtract(num1: num1, num2: num2)
        case "*":
            result = multiply(num1: num1, num2: num2)
        case "/":
            result = divide(num1: num1, num2: num2)!
        default:
            break
        }
        return result
    }
}

let calculator = Calculator()

calculator.num1 = 110 // 첫번째 수
calculator.operation = "/" // 연산자
calculator.num2 = 2 // 두번째 수

let result = calculator
print(result)

// 계산기 만들기
// 사칙연산 + - * /
// 입력값 -> add: (num1 + num2), subtract: (num1 - num2), multiply: (num1 * num2), divide: (num1 / num2)
// 출력값 ->
