/*:
# 계산기 만들기 [Lv.1] */

class Calculator {
    var a:Int = 0
    var b:Int = 0
    var operation: String = ""

    func calculate(a: Int, b: Int, op: String) -> String {
        switch operation {
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
}

// 인스턴스 생성 및 변수 할당
let calculator = Calculator()

//숫자와 연산자 입력
calculator.a = 10
calculator.b = 2
calculator.operation = "/"


let result = calculator.calculate(a: 10, b: 2, op: "/")
print(result)

