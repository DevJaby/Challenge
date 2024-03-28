//
//  ViewController.swift
//  TodoList
//
//  Created by Jeong-bok Lee on 3/25/24.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - 데이터 관련
    
    // 할 일 정보를 담는 구조체 (제목, 완료 여부)
    struct TodoItem {
        var title: String
        var completed: Bool
    }
    // 할 일을 저장하는 배열
    var todos = [TodoItem]()
    
    // 데이터 불러오기
    func loadTodos() {
        if let savedTodos = UserDefaults.standard.array(forKey: "todos") as? [[String: Any]] {
            todos = savedTodos.compactMap { dict in
                guard let title = dict["title"] as? String, let completed = dict["completed"] as? Bool else {
                    return nil
                }
                return TodoItem(title: title, completed: completed)
            }
            tableView.reloadData()
        }
    }
    
    // 데이터 저장하기
    func saveTodos() {
        let todoDicts = todos.map { ["title": $0.title, "completed": $0.completed] }
        UserDefaults.standard.set(todoDicts, forKey: "todos")
    }
    
    // 처음 실행될 때 호출되는 메서드, 테이블 뷰 초기화 (셀 등록, 편집 활성화, 델리게이트 설정)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TodoCell")
        tableView.delegate = self
        tableView.dataSource = self
        // 드래그 앤 드롭 기능 활성화
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        // 저장된 데이터 불러오기 메서드 호출
        loadTodos()

    }
    
    // MARK: - UI 관련
   
    // 할일 리스트
    @IBOutlet weak var tableView: UITableView!
    
    // 다크모드 토글 추가
    @IBOutlet weak var darkModeSwitchButton: UIButton!
    @IBAction func toggleDarkMode(_ sender: Any) {
       
        if #available(iOS 13.0, *) {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    if let window = windowScene.windows.first {
                        // 현재 다크 모드 상태 확인
                        let isDarkMode = window.overrideUserInterfaceStyle == .dark
                        
                        // Dark Mode 상태에 따라 이미지 업데이트
                        darkModeSwitchButton.setImage(isDarkMode ? UIImage(named: "LightModeOn") : UIImage(named: "DarkModeOn"), for: .normal)
                        
                        // Dark Mode 상태 토글
                        window.overrideUserInterfaceStyle = isDarkMode ? .light : .dark
                    }
                }
            }
        }
    
    // 할일 추가
    @IBAction func addTodo(_ sender: Any) {
        let alert = UIAlertController(title: "새로운 할 일", message: "내용을 입력하세요.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "알고리즘 문제 풀기"
        }
        // 추가 버튼
        let addAction = UIAlertAction(title: "추가", style: .default) { [weak self] _ in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else { return }
            
            let newTodo = TodoItem(title: text, completed: false)
            self?.todos.append(newTodo)
            self?.saveTodos() // 새로운 할 일 추가 후 저장
            self?.tableView.reloadData()
        }
        
        // 취소 버튼
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

// MARK: - 테이블 뷰 데이터 소스 프로토콜

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) 
        let todo = todos[indexPath.row]
        cell.textLabel?.text = todo.title
        
        // 토글 버튼 설정
        let toggleButton = UISwitch()
        toggleButton.isOn = todo.completed
        toggleButton.addTarget(self, action: #selector(toggleButtonChanged(_:)), for: .valueChanged)
        cell.accessoryView = toggleButton
        
        // 토글 버튼의 색상 설정
        toggleButton.onTintColor =  UIColor(red: 0.98, green: 0.325, blue: 0.09, alpha: 1) // 켜진 상태일 때의 색상
        toggleButton.tintColor = .gray // 꺼진 상태일 때의 색상

        return cell
    }

    @objc func toggleButtonChanged(_ sender: UISwitch) {
        guard let cell = sender.superview as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        todos[indexPath.row].completed = sender.isOn
        saveTodos() // 토글 상태 변경 후 저장
    }
}

// MARK: - 테이블 뷰 델리게이트 프로토콜

extension ViewController: UITableViewDelegate {
    
    //스와이프 삭제 기능
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, completionHandler in
            self?.todos.remove(at: indexPath.row)
            self?.saveTodos() // 삭제 후 저장
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    // 드래그 앤 드롭 기능 활성화
        func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            return true
        }

        // 셀 이동 시작
        func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            let movedTodo = todos.remove(at: sourceIndexPath.row)
            todos.insert(movedTodo, at: destinationIndexPath.row)
            saveTodos() // 이동 후 저장
        }
    
}

// MARK: - 테이블 뷰 드래그 앤 드롭 프로토콜

extension ViewController: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let todoItem = todos[indexPath.row]
        let itemProvider = NSItemProvider(object: todoItem.title as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = todoItem
        return [dragItem]
    }
}

extension ViewController: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        coordinator.session.loadObjects(ofClass: NSString.self) { [weak self] items in
            guard let titles = items as? [String], let self = self else { return }
            
            for title in titles {
                let newTodo = TodoItem(title: title, completed: false)
                self.todos.insert(newTodo, at: destinationIndexPath.row)
                self.saveTodos() // 변경 사항 저장
                self.tableView.insertRows(at: [destinationIndexPath], with: .automatic)
            }
        }
    }
}
