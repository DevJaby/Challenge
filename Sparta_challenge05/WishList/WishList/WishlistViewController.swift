//
//  WishListViewController.swift
//  WishList
//
//  Created by Jeong-bok Lee on 4/16/24.
//

import UIKit
import CoreData

class WishListViewController: UITableViewController {
    
    // Core Data를 사용하기 위한 Persistent Container
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    // 위시 리스트에 담긴 상품 목록
    private var productList: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TableView에 Cell 등록
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        
        // 위시 리스트 불러오기
        setProductList()
        
        // 버튼을 포함할 뷰 생성
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        
        // 버튼 생성
        let clearWishlistButton = UIButton(type: .system)
        clearWishlistButton.setTitle("위시리스트 비우기", for: .normal)
        clearWishlistButton.addTarget(self, action: #selector(clearWishlist), for: .touchUpInside)
        
        // 버튼을 뷰에 추가
        headerView.addSubview(clearWishlistButton)
        
        // 버튼의 레이아웃 설정
        clearWishlistButton.translatesAutoresizingMaskIntoConstraints = false
        clearWishlistButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        clearWishlistButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
        // 테이블 뷰의 헤더 뷰로 설정
        tableView.tableHeaderView = headerView
    }
    
    // Core Data에서 위시 리스트 불러오기
    private func setProductList() {
        guard let context = self.persistentContainer?.viewContext else { return }
        
        let request = Product.fetchRequest()
        
        if let productList = try? context.fetch(request) {
            self.productList = productList
        }
    }
    
    // TableView 데이터 소스 - 행 수 반환
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productList.count
    }
    
    // TableView 데이터 소스 - 셀 설정
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let product = self.productList[indexPath.row]
        
        let id = product.id
        let title = product.title ?? ""
        let price = product.price
        
        cell.textLabel?.text = "[\(id)] \(title) - \(price.formatPrice()) $"
        return cell
    }
    
    // Swipe to delete 기능 구현
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            let productToRemove = self.productList.remove(at: indexPath.row)
            if let context = self.persistentContainer?.viewContext {
                context.delete(productToRemove)
                try? context.save()
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        deleteAction.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    // 위시리스트 비우기 액션
    @objc private func clearWishlist() {
        if let context = persistentContainer?.viewContext {
            for product in productList {
                context.delete(product)
            }
            productList.removeAll()
            try? context.save()
            tableView.reloadData()
        }
    }
}
