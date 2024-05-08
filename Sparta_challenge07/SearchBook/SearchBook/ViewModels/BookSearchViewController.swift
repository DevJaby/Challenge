//
//  BookSearchViewController.swift
//  SearchBook
//
//  Created by Jeong-bok Lee on 5/9/24.
//

import UIKit

class BookSearchViewController: UIViewController {
    // 검색 결과를 저장할 배열
    var searchResults: [Book] = []
    
    // 검색 바
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "검색어를 입력하세요" // 검색 힌트 텍스트 설정
        searchController.searchBar.delegate = self // 검색 바의 delegate 설정
        
        // 검색 텍스트 필드의 스타일을 .minimal로 설정
        searchController.searchBar.searchTextField.backgroundColor = .white // 검색 텍스트 필드 배경색 설정
        searchController.searchBar.searchTextField.textColor = .black // 검색 텍스트 필드 텍스트 색상 설정
        
        return searchController
    }()
    
    // 컬렉션 뷰
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white // 배경색을 화이트로 설정
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: "BookCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        // 시스템 배경색 설정
        view.backgroundColor = UIColor.systemBackground

        // 콜렉션 뷰를 루트 뷰에 추가
        view.addSubview(collectionView)
        
        // 검색 바를 루트 뷰의 navigationItem에 추가
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false // 스크롤 시 검색 바 숨기지 않도록 설정
        
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            // 콜렉션 뷰의 제약 조건 설정
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor), // 탭바와 상관없이 뷰의 전체 영역을 채웁니다.
        ])
    }

    // 검색 버튼이 눌렸을 때 호출되는 메서드
    func searchBooks(query: String) {
        // Kakao API를 사용하여 책 검색 실행
        APIManager.shared.searchBooks(query: query) { [weak self] books, error in
            guard let self = self else { return }
            if let error = error {
                // 검색 중 오류가 발생한 경우
                print("Error searching books: \(error.localizedDescription)")
                // 오류 처리를 원하는 대로 구현하세요.
            } else if let books = books {
                // 검색 성공한 경우
                self.searchResults = books
                // 검색 결과를 처리하고 UI를 업데이트하는 코드를 작성하세요.
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

extension BookSearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCollectionViewCell
        let book = searchResults[indexPath.item]
        cell.titleLabel.text = book.title
        // 이미지 처리 등의 추가 구현 필요
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 셀 크기 조절
        let width = (collectionView.bounds.width - 40) / 4 // 셀 간 여백 10을 고려하여 계산
        let height = width * 1.5 // 책 표지의 일반적인 비율로 높이 설정
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBook = searchResults[indexPath.item]
        let detailVC = BookDetailViewController()
        detailVC.book = selectedBook
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension BookSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text, !query.isEmpty {
            searchBooks(query: query)
        }
    }
}

extension BookSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let query = searchController.searchBar.text, !query.isEmpty {
            searchBooks(query: query)
        }
    }
}
