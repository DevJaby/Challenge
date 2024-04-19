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
        
        // TableView의 Header View 설정
        configureHeaderView()
        
        // TableView의 Footer View 설정
        updateFooterView()
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
        
        // ID 텍스트 설정 (회색으로)
        let attributedID = NSAttributedString(string: "[\(id)]", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        // 제목과 ID를 하나의 문자열로 결합
        let titleWithID = NSMutableAttributedString(attributedString: attributedID)
        titleWithID.append(NSAttributedString(string: " \(title)")) // ID와 제목 사이에 공백 추가
        
        // 셀 텍스트 설정
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        cell.textLabel?.numberOfLines = 2 // 두 줄로 설정
        cell.textLabel?.attributedText = titleWithID // 수정된 문자열 설정
        
        // 가격 레이블 설정
        let priceLabel = UILabel()
        priceLabel.font = UIFont.boldSystemFont(ofSize: 20) // 더 굵은 폰트로 설정
        priceLabel.text = "\(price.formatPrice()) $" // 가격 텍스트 설정
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 셀에 가격 레이블 추가
        cell.contentView.addSubview(priceLabel)
        
        // Autolayout을 사용하여 가격 레이블 위치 설정
        NSLayoutConstraint.activate([
            priceLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16), // 오른쪽 여백 설정
            priceLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8) // 아래 여백 설정
        ])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 셀의 높이 설정
        return 80 // 원하는 높이로 설정
    }
    
    // MARK: - TableView Header
    
    // TableView Header에 총 가격을 표시
    private func configureHeaderView() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        
        let totalLabel = UILabel()
        totalLabel.font = UIFont.boldSystemFont(ofSize: 17)
        totalLabel.text = "Total: \(calculateTotalPrice().formatPrice())"
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(totalLabel)
        
        // Autolayout 설정
        NSLayoutConstraint.activate([
            totalLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            totalLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        tableView.tableHeaderView = headerView
    }
    
    // 전체 상품의 총 가격을 계산
    private func calculateTotalPrice() -> Double {
        var totalPrice: Double = 0
        
        for product in productList {
            totalPrice += product.price
        }
        
        return totalPrice
    }
    
    // MARK: - TableView Footer
    
    // 위시 리스트 비우기 버튼 액션
    @objc private func clearWishlist() {
        let alert = UIAlertController(title: "전체 비우기", message: "위시 리스트를 비울까요?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "아니요, 안비울래요.", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "네, 비워주세요.", style: .destructive, handler: { [weak self] _ in
            if let context = self?.persistentContainer?.viewContext {
                for product in self?.productList ?? [] {
                    context.delete(product)
                }
                self?.productList.removeAll()
                try? context.save()
                // 헤더 뷰의 총 가격 업데이트
                self?.configureHeaderView()
                self?.tableView.reloadData()
                // Footer View 업데이트
                self?.updateFooterView()
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    // Footer View 업데이트
    private func updateFooterView() {
        if productList.isEmpty {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
//            footerView.backgroundColor = .lightGray
            
            let emptyLabel = UILabel(frame: footerView.bounds)
            emptyLabel.text = "위시 리스트가 비었습니다."
            emptyLabel.textAlignment = .center
            emptyLabel.textColor = .lightGray
            footerView.addSubview(emptyLabel)
            
            tableView.tableFooterView = footerView
        } else {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
            
            let clearWishlistButton = UIButton(type: .system)
            clearWishlistButton.setTitle("위시 리스트 비우기", for: .normal)
            clearWishlistButton.addTarget(self, action: #selector(clearWishlist), for: .touchUpInside)
            clearWishlistButton.setTitleColor(.systemRed, for: .normal)
            footerView.addSubview(clearWishlistButton)
            
            clearWishlistButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                clearWishlistButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
                clearWishlistButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
            ])
            
            tableView.tableFooterView = footerView
        }
    }
}
