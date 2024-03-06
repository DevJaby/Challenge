class Calculator {
    var num1: Double = 0
    var num2: Double = 0
    var operation: String = ""
    
    func add(num1: Double, num2: Double) -> Double {
        return num1 + num2
    }
    func subtract(num1: Double, num2: Double) -> Double {
        return num1 - num2
    }
    func multiply(num1: Double, num2: Double) -> Double {
        return num1 * num2
    }
    func divide(num1: Double, num2: Double) -> Double? {
        return num2 != 0 ? num1 / num2 : nil
    }
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

calculator.num1 = 110
calculator.operation = "/"
calculator.num2 = 0

let result = calculator.calculate()
print(result)

// 계산기 만들기
// 사칙연산 + - * /
// 입력값 -> add: (num1 + num2), subtract: (num1 - num2), multiply: (num1 * num2), divide: (num1 / num2)
// 출력값 ->
