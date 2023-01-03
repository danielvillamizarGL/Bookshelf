//
//  BookManager.swift
//  BookShelf
//
//  Created by Daniel José Villamizar on 29/12/22.
//

import Foundation


class BookViewModel {
       
    private var book: BookObject?
    private var apiService = APIService()
    
    let baseURl = "https://www.googleapis.com/"
    
    
    func searchBooks(query: String) async -> Result<BooksObject, RequestError> {
        let urlString = "\(baseURl)/books/v1/volumes?q=\(query.urlEncoded()!)"
        print(urlString)
        return await apiService.performRequest(with: urlString)
    }
    
}
