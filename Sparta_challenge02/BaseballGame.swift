//
//  BaseballGame.swift
//  challenge_baseball
//
//  Created by Jeong-bok Lee on 3/14/24.
//
// MARK: Lv.2
// - 1에서 9까지의 서로 다른 임의의 수 3개를 정하고 맞추는 게임입니다
// - 정답은 랜덤으로 만듭니다.(1에서 9까지의 서로 다른 임의의 수 3자리)
// - 정답을 맞추기 위해 3자리수를 입력하고 힌트를 받습니다
// - 힌트는 야구용어인 볼과 스트라이크입니다.
// - 같은 자리에 같은 숫자가 있는 경우 스트라이크, 다른 자리에 숫자가 있는 경우 볼입니다
// - 만약 올바르지 않은 입력값에 대해서는 오류 문구를 보여주세요
// - 3자리 숫자가 정답과 같은 경우 게임이 종료됩니다

struct BaseballGame {
    
    // 시작하기 함수
    func start() {
        let answer = makeAnswer()
        
        while true {
            let inputNumbers = getInputNumbers()
            let (strike, ball) = compare(answer: answer, inputNumbers: inputNumbers)
            
            if strike == 0 && ball == 0 {
                 print("Nothing")
               } else {
                 print("\(strike)스트라이크 \(ball)볼")
               }
               
            if strike == 3 {
                print("정답입니다!")
                break
            }
        }
    }
    
    // 정답 만들기 함수
    func makeAnswer() -> [Int] {
        var numbers = Array(1...9)
        numbers.shuffle()
        return Array(numbers[0..<3])
    }
    
    // 입력값 함수
    func getInputNumbers() -> [Int] {
        var inputNumbers: [Int] = []
        while inputNumbers.count != 3 {
            print("숫자를 입력하세요")
            let input = readLine()!
            
            // 입력 값을 정수 배열로 변환
            for char in input {
                if let number = Int(String(char)) {
                    inputNumbers.append(number)
                } else {
                    inputNumbers = []
                    break
                }
            }
            // 유효성 검사하기
            if !isValidInput(inputNumbers) {
                print("올바르지 않은 입력값입니다")
                inputNumbers = []
            }
        }
        return inputNumbers
    }
    
    // 유효성 검사 함수
    func isValidInput(_ numbers: [Int]) -> Bool {
        return numbers.count == 3 && !numbers.contains(0) && Set(numbers).count == 3
    }
    
    // 정답 비교 함수
    func compare(answer: [Int], inputNumbers: [Int]) -> (strike: Int, ball: Int) {
        var strike = 0
        var ball = 0
        
        for i in 0..<3 {
            if answer[i] == inputNumbers[i] {
                strike += 1
            } else if answer.contains(inputNumbers[i]) {
                ball += 1
            }
        }
        return (strike, ball)
    }
}
