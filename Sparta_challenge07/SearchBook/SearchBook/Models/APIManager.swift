//
//  APIManager.swift
//  SearchBook
//
//  Created by Jeong-bok Lee on 5/9/24.
//

import UIKit

class APIManager {
    static let shared = APIManager()
    
    private let baseURL = "https://dapi.kakao.com/v3/search/book"
    private let apiKey = "71ac4aca6c6604671b745c63985a3835"
    
    func searchBooks(query: String, completion: @escaping ([Book]?, Error?) -> Void) {
        let urlString = "\(baseURL)?query=\(query)"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["Authorization": "KakaoAK \(apiKey)"]
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(SearchResponse.self, from: data)
                let books = result.documents.map { $0.toBook() }
                completion(books, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}
