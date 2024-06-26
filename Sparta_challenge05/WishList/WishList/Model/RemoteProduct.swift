//
//  RemoteProduct.swift
//  WishList
//
//  Created by Jeong-bok Lee on 4/16/24.
//

import Foundation

struct RemoteProduct: Decodable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let thumbnail: URL
}

