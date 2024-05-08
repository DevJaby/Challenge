//
//  SearchResponse.swift
//  BookSearch
//
//  Created by Jeong-bok Lee on 5/7/24.
//

import UIKit

struct SearchResponse: Codable {
    let documents: [Document]
}

struct Document: Codable {
    let title: String
    let authors: [String]
    let contents: String
    let thumbnail: String?
    
    func toBook() -> Book {
        return Book(title: title, authors: authors, contents: contents, thumbnailURL: URL(string: thumbnail ?? ""))
    }
}
