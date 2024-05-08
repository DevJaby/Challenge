//
//  TabBarController.swift
//  SearchBook
//
//  Created by Jeong-bok Lee on 5/9/24.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bookSearchVC = BookSearchViewController()
        let savedBooksVC = SavedBooksViewController()
        
        bookSearchVC.tabBarItem = UITabBarItem(title: "책 검색", image: nil, tag: 0)
        savedBooksVC.tabBarItem = UITabBarItem(title: "담은 책 목록", image: nil, tag: 1)
        
        let navigationController1 = UINavigationController(rootViewController: bookSearchVC)
        let navigationController2 = UINavigationController(rootViewController: savedBooksVC)
        
        viewControllers = [navigationController1, navigationController2]
        tabBar.tintColor = .systemBlue // 탭바의 텍스트 및 이미지 색상을 설정합니다.
    }
}

