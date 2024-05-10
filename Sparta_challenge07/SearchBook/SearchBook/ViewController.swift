//
//  ViewController.swift
//  SearchBook
//
//  Created by Jeong-bok Lee on 5/9/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        // 검색 컨트롤러를 생성합니다.
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = nil // 더미 값으로 설정
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "검색어를 입력하세요"
        
        // 네비게이션 아이템에 검색 컨트롤러를 설정합니다.
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false // 스크롤 시 검색 바 숨기지 않도록 설정

        // 탭바 컨트롤러를 생성합니다.
        let tabBarController = TabBarController()
        addChild(tabBarController)
        view.addSubview(tabBarController.view)
        tabBarController.didMove(toParent: self)
        
        // 탭바 컨트롤러의 뷰에 제약 조건을 설정합니다.
        tabBarController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabBarController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tabBarController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
