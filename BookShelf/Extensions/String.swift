//
//  String.swift
//  BookShelf
//
//  Created by Daniel José Villamizar on 2/01/23.
//

import Foundation

extension String {
    
    func urlEncoded() -> String? {
        addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)?
            .replacingOccurrences(of: "&", with: "%26")
    }
}
