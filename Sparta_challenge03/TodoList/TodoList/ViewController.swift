//
//  ViewController.swift
//  TodoList
//
//  Created by Jeong-bok Lee on 3/25/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    struct TodoItem {
        var title: String
        var completed: Bool
    }
    
    var todos = [TodoItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TodoCell")
        tableView.isEditing = false
        tableView.delegate = self
        tableView.dataSource = self
        
        // 이전에 저장된 데이터 불러오기
        loadTodos()
    }
    
    // 이전에 저장된 할 일 목록 불러오기
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
    
    // 할 일 목록 저장하기
    func saveTodos() {
        let todoDicts = todos.map { ["title": $0.title, "completed": $0.completed] }
        UserDefaults.standard.set(todoDicts, forKey: "todos")
    }
    
    @IBAction func addTodo(_ sender: Any) {
        let alert = UIAlertController(title: "새로운 할 일", message: "할 일 내용을 입력하세요.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "할 일 내용"
        }
        
        let addAction = UIAlertAction(title: "추가", style: .default) { [weak self] _ in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else { return }
            
            let newTodo = TodoItem(title: text, completed: false)
            self?.todos.append(newTodo)
            self?.saveTodos() // 새로운 할 일 추가 후 저장
            self?.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

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

extension ViewController: UITableViewDelegate {
    
    // 스와이프 삭제 기능
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, completionHandler in
            self?.todos.remove(at: indexPath.row)
            self?.saveTodos() // 삭제 후 저장
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
