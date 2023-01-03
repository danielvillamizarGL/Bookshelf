//
//  HeaderView.swift
//  BookShelf
//
//  Created by Daniel José Villamizar on 2/01/23.
//

import UIKit

class HeaderView: UIView {
    
    let label = UILabel(frame: .zero)

       override init(frame: CGRect) {
           super.init(frame: frame)
           addSubview(label)
           label.translatesAutoresizingMaskIntoConstraints = false
           label.numberOfLines = 0
           NSLayoutConstraint.activate([
               label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
               label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
               label.topAnchor.constraint(equalTo: topAnchor),
               label.bottomAnchor.constraint(equalTo: bottomAnchor),
               ])
       }

       func configure(text: String) {
           label.text = text
       }

       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
}
