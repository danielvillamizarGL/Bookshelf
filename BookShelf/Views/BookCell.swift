//
//  BookCell.swift
//  BookShelf
//
//  Created by Daniel José Villamizar on 29/12/22.
//

import UIKit
import SDWebImage

class BookCell: UICollectionViewCell {
    
    private let mainView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let outerView: UIView = {
        let view = UIView()
        
        view.clipsToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let poster: UIImageView = {
        let iv = UIImageView()
        
        iv.layer.cornerRadius = 8
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        
        label.text = "Test"
        label.numberOfLines = 2
        label.font = UIFont.avenir(size: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
            
        setupViews()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        outerView.addSubview(poster)
        
        mainView.addSubview(outerView)
        mainView.addSubview(title)
        
        contentView.addSubview(mainView)
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            poster.topAnchor.constraint(equalTo: outerView.topAnchor),
            poster.leadingAnchor.constraint(equalTo: outerView.leadingAnchor),
            poster.bottomAnchor.constraint(equalTo: outerView.bottomAnchor),
            poster.trailingAnchor.constraint(equalTo: outerView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: outerView.bottomAnchor, constant: 4),
            title.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            title.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            title.trailingAnchor.constraint(equalTo: mainView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            outerView.topAnchor.constraint(equalTo: mainView.topAnchor),
            outerView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
//            outerView.bottomAnchor.constraint(equalTo: title.topAnchor, constant: 8),
            outerView.heightAnchor.constraint(equalTo: mainView.heightAnchor, multiplier: 0.8),
            outerView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor)
        ])
        
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func configureCell(with model: BookObject) {
        title.text = model.volumeInfo?.title ?? "No title"
        if let urlString = model.volumeInfo?.imageLinks?.thumbnail {
            poster.sd_setImage(with: URL(string: urlString))
        }
        else {
            poster.image = UIImage(named: "no_image")
        }
        
    }
}
