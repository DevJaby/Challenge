
/*:# 풀이 강의 Lv.3*/
class AddOperation {
    func add(_ num1: Double, _ num2: Double) -> Double {
        num1 + num2
    }
}

class SubstractOperation {
    /**
     - num1: 빼기 연산자 왼쪽에 오는 수
     - num2: 빼기 연산자 오른쪽에 오는 수
     */
    func minus(_ num1: Double, _ num2: Double) -> Double {
        num1 - num2
    }
}

class MultiplyOperation {
    func multiply(_ num1: Double, _ num2: Double) -> Double {
        num1 * num2
    }
}

class DivideOperation {
    /**
     - num1: 피제수
     - num2: 제수
     */
    func divide(_ num1: Double, _ num2: Double) -> Double {
        guard num2 != 0 else {
            return 0.0
        }
        return Double(num1) / Double(num2) // 한줄인 클로저는 축약할 수 있다.
    }
}


class Calculator {
    let addOperation = AddOperation()
    let substractOperation = SubstractOperation()
    let multiplyOperation = MultiplyOperation()
    let divideOperation = DivideOperation()
    
    func calculate(_ op: OperatorType, _ num1: Double, _ num2: Double) -> Double {
        switch op {
        case .add:
            return addOperation.add(num1, num2)
        case .substract:
            return substractOperation.minus(num1, num2)
        case .multiply:
            return multiplyOperation.multiply(num1, num2)
        case .divide:
            return divideOperation.divide(num1, num2)
        }
    }
}

enum OperatorType {
    case add
    case substract
    case multiply
    case divide
}

let calculator = Calculator() // 인스턴스 생성하여 변수에 할당

calculator.calculate(.add, 1, 2)
calculator.calculate(.substract, 1, 2)
calculator.calculate(.multiply, 3, 4)
calculator.calculate(.divide, 2, 3) 
