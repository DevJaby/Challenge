/*:# Calculator Recap*/

/*
 - 문제를 접근할때 요구 사항 지키기
 - class 사용은 필수적이다.
 - swift 는 객체 지향 언어이다.
 */

import UIKit

// 연산을 수행할 수 있는 클래스 만들기

class Calculator {
    // 1. 상태 (프로퍼티)
    // 2. 동작 (메서드)
    
    func add(a: Double, b: Double) {
        a + b
    }
    func minus() {
        
    }
    func multiply() {
        
    }
    func divide() {
        
    }
    
}
// 클래스 생성자 호출의 결과물 = 인스턴스
class AddOperation {
    // 클래스 내부에서 정의한 상수는 프로퍼티라고 한다.
}
class SubstractOperation {
    
}
class MultiplyOperation {
    
}
class DivideOperation {
    
}

let calculator = Calculator.init() // 인스턴스를 cal이라는 상수에 저장
calculator.add(a: 1, b: 2)

// 클래스 > 메서드 > 인스턴스 ?
// 클래스를 구분해야 추후 유지보수에 좋다
//공부할때  한줄로 요약해서 시작해야됨 (양에 압도됨)

// 추상화 : 보여줄것만 보여주고 나머지는 숨긴다.
// 코드의 구조, 용어 개념 


