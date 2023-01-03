//
//  FavoriteCell.swift
//  BookShelf
//
//  Created by Daniel José Villamizar on 3/01/23.
//

import UIKit

class FavoriteCell: UITableViewCell {
    
    private let poster: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 8
        img.clipsToBounds = true
        return img
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        
        label.font = UIFont.avenir(size: 14)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let authorLabel : UILabel = {
        let label = UILabel()
        
        label.font = UIFont.avenir(size: 12)
        label.textColor = .gray
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let customView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        
        contentView.addSubview(poster)
        
        let heightConstraint = poster.heightAnchor.constraint(equalToConstant: 100)
        heightConstraint.priority = UILayoutPriority(750)
        
        NSLayoutConstraint.activate([
            poster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            poster.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            heightConstraint,
            poster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            poster.widthAnchor.constraint(equalToConstant: 90)
            
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -20),
            titleLabel.leadingAnchor.constraint(equalTo: poster.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            authorLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 20),
            authorLabel.leadingAnchor.constraint(equalTo: poster.trailingAnchor, constant: 16),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureCell(with model: BookObject) {
        
        print("Configure cell::")
        
        titleLabel.text = model.volumeInfo?.title ?? "No title"
        
        if let authors = model.volumeInfo?.authors {
            if authors.isEmpty {
                authorLabel.text = "No author"
            }
            else{
                let trimmed = authors.map { $0.trimmingCharacters(in: .whitespaces) }
                let authorsString = trimmed.joined(separator: ", ")
                authorLabel.text = authorsString
            }
        }
        else {
            authorLabel.text = "No author"
        }
        
        if let mediumString = model.volumeInfo?.imageLinks?.medium {
            poster.sd_setImage(with: URL(string: mediumString))
        }
        else if let thumbnailString = model.volumeInfo?.imageLinks?.thumbnail {
            poster.sd_setImage(with: URL(string: thumbnailString))
        }
        else{
            poster.image = UIImage(named: "no_image")
        }
    }
}
