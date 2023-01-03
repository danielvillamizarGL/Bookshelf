//
//  BookManager.swift
//  BookShelf
//
//  Created by Daniel José Villamizar on 29/12/22.
//

import Foundation


class BookViewModel: NSObject {
       
       
    let baseURl = "https://www.googleapis.com/"
    
    
    func fetchBooks(categoryId: Int) async -> Result<BooksObject, RequestError> {
        let urlString = "\(baseURl)?category_id=\(categoryId)"
        print(urlString)
        return await performRequest(with: urlString)
    }
    
    func searchBooks(query: String) async -> Result<BooksObject, RequestError> {
        
        let urlString = "\(baseURl)/books/v1/volumes?q=\(query.urlEncoded()!)"
        print(urlString)
        return await performRequest(with: urlString)
    }
    
    
    private func performRequest(with urlString: String) async -> Result<BooksObject, RequestError> {
        guard let url = URL(string: urlString) else {
            return .failure(.invalidURL)
        }
        
        do {
            let (data, response) = try await URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil).data(for: URLRequest(url: url))
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            print("Status code \(response.statusCode)")
            switch response.statusCode {
            case 200...299:
                
                do{
                    let decodedResponse = try JSONDecoder().decode(BooksObject.self, from: data)
                    return .success(decodedResponse)
                }
                catch{
                    print(error)
                    return .failure(.decode)
                }
                             
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }
        
    }
    
}

extension BookViewModel: URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
       //Trust the certificate even if not valid
       let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)

       completionHandler(.useCredential, urlCredential)
    }
}


enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
    
    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .unauthorized:
            return "Session expired"
        default:
            return "Unknown error"
        }
    }
}
