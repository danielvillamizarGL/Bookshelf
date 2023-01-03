//
//  SearchViewController.swift
//  BookShelf
//
//  Created by Daniel José Villamizar on 2/01/23.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var books: BooksObject?
    
    private var bookManager = BookManager()
    
    private var query: String = ""
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Nothing to show here!"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.register(BookCell.self, forCellWithReuseIdentifier: "Cell")
        
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View did load")
        
        view.addSubview(collectionView)
        view.backgroundColor = .white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        
        setupLayouts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
    private func setupLayouts() {
        //        NSLayoutConstraint.activate([
        //            noResultsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        //            noResultsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        //        ])
    }
    
    private func searchBooks(searchText: String, completion: @escaping (Result<BooksObject, RequestError>) -> Void) {
        
        Task(priority: .background) {
            let result = await bookManager.searchBooks(query: searchText)
            completion(result)
        }
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        
        print("Query:: \(searchText)")
        if searchText != query {
            if !searchText.isEmpty {
                searchBooks(searchText: searchText) { result in
                    switch result {
                    case .success(let books):
                        self.books = books
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
        
        print("Var query updated")
        query = searchText
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return books?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! BookCell
        
        guard let book = books?.items[indexPath.row] else {
            return cell
        }
        
        cell.configureCell(with: book)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 3
        let spacing: CGFloat = flowLayout.minimumInteritemSpacing
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        
        return CGSize(width: itemDimension, height: 200)
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected cell")
        guard let book = books?.items[indexPath.row] else {
            return
        }
        let vc = BookDetailsViewController(nibName: nil, bundle: nil, book: book)
        print("About to push route")
        self.presentingViewController?.navigationController?.pushViewController(vc, animated:true)
    }
}
