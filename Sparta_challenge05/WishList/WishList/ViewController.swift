//
//  ViewController.swift
//  WishList
//
//  Created by Jeong-bok Lee on 4/16/24.
//

import UIKit
import CoreData

class ViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: -Properties
    
    // 새로고침을 위한 UIRefreshControl
    private let refreshControl = UIRefreshControl()
    private var isLoading = false
    
    // Core Data를 사용하기 위한 Persistent Container
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    // 현재 상품 정보를 저장하는 변수
    private var currentProduct: RemoteProduct? = nil {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = nil
                self?.titleLabel.text = self?.currentProduct?.title
                self?.descriptionLabel.text = self?.currentProduct?.description
                if let price = self?.currentProduct?.price {
                    self?.priceLabel.text = price.formatPrice() + " $"
                }
            }
            
            DispatchQueue.global().async { [weak self] in
                guard let currentProduct = self?.currentProduct,
                      let data = try? Data(contentsOf: currentProduct.thumbnail),
                      let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }
        }
    }
    
    // MARK: -IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    // MARK: -UI Actions

    // 상품 저장 버튼
    @IBAction func tappedSaveProductButton(_ sender: UIButton) {
        self.saveWishProduct()
    }
    
    // 다음 상품 보기 버튼
    @IBAction func tappedSkipButton(_ sender: UIButton) {
        self.fetchRemoteProduct()
    }
    
    // 위시 리스트 보기 버튼
    @IBAction func tappedPresentWishList(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "WishListViewController") as? WishListViewController else { return }
        self.present(nextVC, animated: true)
    }
    
    // MARK: -Networking
    
    // 랜덤 상품 정보 가져오기
    private func fetchRemoteProduct() {
        isLoading = true
        
        let productID = Int.random(in: 1...100)
        
        if let url = URL(string: "https://dummyjson.com/products/\(productID)") {
            let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    do {
                        let product = try JSONDecoder().decode(RemoteProduct.self, from: data)
                        self?.currentProduct = product
                    } catch {
                        print("Decode Error: \(error)")
                    }
                }
                
                self?.isLoading = false
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                }
            }
            
            task.resume()
        }
    }
    
    // MARK: -Core Data
    
    // 현재 상품을 위시 리스트에 저장
    private func saveWishProduct() {
        guard let context = persistentContainer?.viewContext,
              let currentProduct = self.currentProduct else { return }
        
        let wishProduct = Product(context: context)
        wishProduct.id = Int64(currentProduct.id)
        wishProduct.title = currentProduct.title
        wishProduct.price = currentProduct.price
        
        try? context.save()
    }
    
    // MARK: -View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 초기 상품 정보 가져오기
        self.fetchRemoteProduct()
        
        // 스크롤 뷰에 refreshControl 추가
        scrollView.delegate = self
        scrollView.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "계속 당겨서 다른 상품 보기")
    }
    
    // MARK: -Helper Methods
    
    // 새로고침
    @objc private func refreshData() {
        if !isLoading {
            fetchRemoteProduct()
        } else {
            refreshControl.endRefreshing()
        }
    }
    
    // 스크롤 종료 시 새로고침 여부 확인
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate && !refreshControl.isRefreshing {
            refreshData()
        }
    }
}
