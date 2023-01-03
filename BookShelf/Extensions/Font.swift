//
//  Font.swift
//  BookShelf
//
//  Created by Daniel José Villamizar on 2/01/23.
//

import UIKit


extension UIFont {
  func withWeight(_ weight: UIFont.Weight) -> UIFont {
    let newDescriptor = fontDescriptor.addingAttributes([.traits: [
      UIFontDescriptor.TraitKey.weight: weight]
    ])
    return UIFont(descriptor: newDescriptor, size: pointSize)
  }
}

extension UIFont {
    enum FontWeight: String {
        case regular = "Book"
        case medium = "Medium"
        case semiBold = "Heavy"
        case bold = "Black"
//        case extraBold = "ExtraBold"
         
    }
    
    static func avenir(size: CGFloat, weight: FontWeight = .regular) -> UIFont {
        
        guard let customFont = UIFont(name: "Avenir-\(weight.rawValue)", size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return customFont
    }
}
