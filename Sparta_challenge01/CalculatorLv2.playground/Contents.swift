
/*:# 풀이 강의 Lv.2*/
class Calculator {
    
    func add(_ num1: Int, _ num2: Int) -> Int {
        num1 + num2
    }
    
    /**
     - num1: 빼기 연산자 왼쪽에 오는 수
     - num2: 빼기 연산자 오른쪽에 오는 수
     */
    func minus(_ num1: Int, _ num2: Int) -> Int {
        num1 - num2
    }
    
    func multiply(_ num1: Int, _ num2: Int) -> Int {
        num1 * num2
    }
    /**
     - num1: 피제수
     - num2: 제수
     */
    func divide(_ num1: Int, _ num2: Int) -> Double {
        guard num2 != 0 else {
            return 0.0
        }
        return Double(num1) / Double(num2) // 한줄인 클로저는 축약할 수 있다.
    }
    
    func mod(_ num1: Int, _ num2: Int) -> Int {
        num1 % num2
    }
}

let calculator = Calculator() // 인스턴스 생성하여 변수에 할당

print(calculator.add(1, 2))

print(calculator.minus(3, 2))

print(calculator.multiply(3, 5))

print(calculator.divide(1, 3))

print(calculator.mod(6, 3))

