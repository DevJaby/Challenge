class Calculator {

    // MARK: - 변수 선언

    var firstNumber: Double = 0 // 첫 번째 숫자
    var secondNumber: Double = 0 // 두 번째 숫자
    var operation: String = "" // 연산자
//    var typingFirstNumber: Bool = true // 첫 번째 숫자 입력 여부

//    // MARK: - 초기화
//
//    init() {
//        print("계산기 인스턴스 생성")
//    }

    // MARK: - 덧셈 함수

    func add(a: Double, b: Double) -> Double {
        return a + b
    }

    // MARK: - 뺄셈 함수

    func subtract(a: Double, b: Double) -> Double {
        return a - b
    }

    // MARK: - 곱셈 함수

    func multiply(a: Double, b: Double) -> Double {
        return a * b
    }

    // MARK: - 나눗셈 함수

    func divide(a: Double, b: Double) -> Double {
        if b != 0 {
            return a / b
        } else {
            print("Error: Division by zero")
            
            return 0
        }
    }

    // MARK: - 계산 결과 함수

    func calculate() -> Double {
        var result: Double = 0
        switch operation {
        case "+":
            result = add(a: firstNumber, b: secondNumber)
        case "-":
            result = subtract(a: firstNumber, b: secondNumber)
        case "*":
            result = multiply(a: firstNumber, b: secondNumber)
        case "/":
            result = divide(a: firstNumber, b: secondNumber)
        default:
            break
        }
        return result
    }
}

// MARK: - 계산기 인스턴스 생성 및 변수 할당

let calculator = Calculator()

// MARK: - 사칙연산 진행

// 숫자 입력 및 연산
calculator.firstNumber = 10
calculator.operation = "/"
calculator.secondNumber = 0

// 계산 결과 출력
let result = calculator.calculate()
print("계산 결과: \(result)")
