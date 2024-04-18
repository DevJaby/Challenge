//
//  ViewController.swift
//  WishList
//
//  Created by Jeong-bok Lee on 4/16/24.
//

import UIKit
import CoreData

class ViewController: UIViewController, UIScrollViewDelegate {
    
    private let refreshControl = UIRefreshControl()
    // Core Data를 사용하기 위한 Persistent Container
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    // 현재 상품 정보
    private var currentProduct: RemoteProduct? = nil {
        didSet {
            DispatchQueue.main.async {
                self.imageView.image = nil
                self.titleLabel.text = self.currentProduct?.title
                self.descriptionLabel.text = self.currentProduct?.description
                if let price = self.currentProduct?.price {
                    // 가격을 1000단위로 콤마(,) 처리하여 표시
                    let formattedPrice = self.formatPrice(Int(price))
                    self.priceLabel.text = "\(formattedPrice) $"
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
    @IBOutlet weak var scrollView: UIScrollView! // 스크롤 뷰 추가
//    @IBOutlet weak var contentView: UIView! // 기존의 레이아웃을 포함하는 컨텐트 뷰
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // 상품 저장 버튼 액션
    @IBAction func tappedSaveProductButton(_ sender: UIButton) {
        self.saveWishProduct()
    }
    // 다음 상품 보기 버튼 액션
    @IBAction func tappedSkipButton(_ sender: UIButton) {
        self.fetchRemoteProduct()
    }
    // 위시 리스트 보기 버튼 액션
    @IBAction func tappedPresentWishList(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "WishListViewController") as? WishListViewController else { return }
        self.present(nextVC, animated: true)
    }
    // 상품 정보 가져오기 메서드
    private func fetchRemoteProduct() {
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
            }
            
            task.resume()
        }
    }
    
    // 위시 리스트에 상품 저장 메서드
    private func saveWishProduct() {
        guard let context = persistentContainer?.viewContext,
              let currentProduct = self.currentProduct else { return }
        
        let wishProduct = Product(context: context)
        wishProduct.id = Int64(currentProduct.id)
        wishProduct.title = currentProduct.title
        wishProduct.price = Double(currentProduct.price)
        
        try? context.save()
    }
    
    // 가격을 1000단위로 콤마(,) 처리하는 함수
    private func formatPrice(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: price)) ?? ""
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
         self.fetchRemoteProduct()
         // 스크롤 뷰에 refreshControl 추가
         scrollView.delegate = self
         scrollView.refreshControl = self.refreshControl
         self.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
         // 당겨서 새로고침 문구 설정
         refreshControl.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
     }
      
     @objc private func refreshData() {
         // 새로고침이 시작되었을 때 실행되는 코드
         fetchRemoteProduct()
         // 새로고침을 완료했을 때 refreshControl을 중지시킴
         refreshControl.endRefreshing()
     }
     
     func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
         // 스크롤이 멈추고 사용자가 당긴 정도를 확인
         let offsetY = scrollView.contentOffset.y
         let contentHeight = scrollView.contentSize.height
         if offsetY > contentHeight - scrollView.frame.size.height {
             // 스크롤이 내려진 정도가 컨텐츠의 끝에 도달했을 때 새로고침 실행
             refreshData()
         }
     }
 }
