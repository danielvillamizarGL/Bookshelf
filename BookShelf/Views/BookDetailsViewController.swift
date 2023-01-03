//
//  BookDetailsViewController.swift
//  BookShelf
//
//  Created by Daniel José Villamizar on 2/01/23.
//

import UIKit
import RealmSwift

class BookDetailsViewController: UIViewController {
    
    public var book: BookObject
    
    private let realm = try! Realm()
    
    private var isFavorite: Bool = false
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Test"
        label.numberOfLines = 2
        label.font = UIFont.avenir(size: 24, weight: .bold)
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Test"
        label.numberOfLines = 2
        label.font = UIFont.avenir(size: 18)
        label.textColor = .gray
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let previewButton: UIButton = {
        
        print("Button built")
        
        var container = AttributeContainer()
        container.font = UIFont.avenir(size: 24)
        
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Preview book"
        configuration.image = UIImage(systemName: "rectangle.portrait.and.arrow.forward")
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                              leading: 20, bottom: 10, trailing: 20)
        configuration.cornerStyle = .capsule
        configuration.imagePlacement = .trailing
        configuration.background.backgroundColor = UIColor(hexString: "#2ac6bb")
        configuration.imagePadding = 8.0
        
        let button = UIButton(configuration: configuration)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, book: BookObject) {
        self.book = book
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let favoriteBooks = realm.objects(BookObject.self)
        isFavorite = favoriteBooks.contains { bookObject in
            return bookObject.id == book.id
        }
        
        var imageName = "heart"
        
        if isFavorite {
           imageName = "heart.fill"
        }
        
        favoriteButton.setImage(UIImage(systemName: imageName, withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        
        print(favoriteBooks.count)
        
        previewButton.addTarget(self, action: #selector(self.goToPreview), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(self.setFavorite), for: .touchUpInside)
        
        setupViews()
        setupLayouts()
        setupData()
    }
    
    private func setupData() {
        titleLabel.text = book.volumeInfo?.title ?? "No title"
        
        if let authors = book.volumeInfo?.authors {
            let trimmed = authors.map { $0.trimmingCharacters(in: .whitespaces) }
            let authorsString = trimmed.joined(separator: ", ")
            authorLabel.text = authorsString
        }
        else {
            authorLabel.text = "No author"
        }
        
        if let mediumString = book.volumeInfo?.imageLinks?.medium {
            poster.sd_setImage(with: URL(string: mediumString))
        }
        else if let thumbnailString = book.volumeInfo?.imageLinks?.thumbnail {
            poster.sd_setImage(with: URL(string: thumbnailString))
        }
        else{
            poster.image = UIImage(named: "no_image")
        }
    }
    
    private func setupViews() {
        
        view.backgroundColor = .white
        
        outerView.addSubview(poster)
        
        mainView.addSubview(outerView)
        mainView.addSubview(titleLabel)
        mainView.addSubview(favoriteButton)
        mainView.addSubview(authorLabel)
        mainView.addSubview(previewButton)
        
        scrollView.addSubview(mainView)
        
        view.addSubview(scrollView)
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            poster.topAnchor.constraint(equalTo: outerView.topAnchor),
            poster.leadingAnchor.constraint(equalTo: outerView.leadingAnchor),
            poster.bottomAnchor.constraint(equalTo: outerView.bottomAnchor),
            poster.trailingAnchor.constraint(equalTo: outerView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: favoriteButton.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            outerView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            outerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            outerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.7),
            outerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.5),
        ])
        
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: outerView.bottomAnchor, constant: 24),
            favoriteButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            authorLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            previewButton.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 24),
            previewButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            mainView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            mainView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            mainView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1.01),
            mainView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
    }
    
    @objc private func goToPreview() {
        if let previewLink = book.volumeInfo?.previewLink {
            if let url = URL(string: previewLink) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    @objc private func setFavorite() {
        print("Set favorite")
        if isFavorite {
            do{
                try realm.write {
                    realm.delete(book)
                }
                isFavorite = false
                favoriteButton.setImage(UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            }
            catch {
                print(error)
            }            
        }
        else{
            do{
                try realm.write {
                    realm.add(book)
                }
                isFavorite = true
                favoriteButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            }
            catch {
                print(error)
            }
        }
        
        
        
    }
    
}
