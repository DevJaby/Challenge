//
//  WishListViewController.swift
//  WishList
//
//  Created by Jeong-bok Lee on 4/16/24.
//

import UIKit
import CoreData

class WishListViewController: UITableViewController {
    
    // MARK: - Properties
    
    // Core Data를 사용하기 위한 Persistent Container
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    // 현재 위시 리스트에 있는 상품 목록을 저장하는 배열
    private var productList: [Product] = []
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TableView에 셀 등록
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        
        // 위시 리스트 상품 목록 설정
        setProductList()
        
        // TableView의 Footer View 설정
        configureFooterView()
    }
    
    // MARK: - Data Methods
    
    // Core Data에서 위시 리스트 상품 목록을 가져와 배열에 저장
    private func setProductList() {
        guard let context = self.persistentContainer?.viewContext else { return }
        
        let request = Product.fetchRequest()
        
        if let productList = try? context.fetch(request) {
            self.productList = productList
        }
    }
    
    // MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let product = self.productList[indexPath.row]
        
        let id = product.id
        let title = product.title ?? ""
        let price = product.price
        
        // 셀 텍스트 설정
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        cell.textLabel?.text = "[\(id)] \(title) - \(price.formatPrice()) $"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 셀의 높이 설정
        return 60 // 원하는 높이로 설정
    }
    
    // MARK: - TableView Actions
    
    // 셀의 스와이프 액션
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            self.deleteProduct(at: indexPath)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        deleteAction.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    // 위시 리스트 비우기 버튼을 눌렀을 때의 동작
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
    
    // TableView의 푸터 뷰 설정: 위시 리스트 비우기
    private func configureFooterView() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        
        let clearWishlistButton = UIButton(type: .system)
        clearWishlistButton.setTitle("위시 리스트 비우기", for: .normal)
        clearWishlistButton.addTarget(self, action: #selector(clearWishlist), for: .touchUpInside)
        clearWishlistButton.setTitleColor(.systemRed, for: .normal)
        
        footerView.addSubview(clearWishlistButton)
        
        clearWishlistButton.translatesAutoresizingMaskIntoConstraints = false
        clearWishlistButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        clearWishlistButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        
        tableView.tableFooterView = footerView
    }
    
    // 상품 삭제 메서드
    private func deleteProduct(at indexPath: IndexPath) {
        guard let context = persistentContainer?.viewContext else { return }
        let productToRemove = self.productList.remove(at: indexPath.row)
        context.delete(productToRemove)
        try? context.save()
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}
