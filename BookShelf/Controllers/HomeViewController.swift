//
//  SearchViewController.swift
//  BookShelf
//
//  Created by Daniel José Villamizar on 2/01/23.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    
    private var favoriteBooks: Results<BookObject>?
    
    private var notificationToken: NotificationToken?
    
    let realm = try! Realm()
    
    private let searchField: UITextField = {
        let textfield = UITextField()
        
        return textfield
    }()
    
    private let mainView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Your"
        label.font = UIFont.avenir(size: 28)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let title1Label: UILabel = {
        let label = UILabel()
        
        label.text = "Bookshelf"
        label.font = UIFont.avenir(size: 34, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let bannerImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "img1")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8.0
        
        return imageView
    }()
    
    private let headerTitle: UILabel = {
        let label = UILabel()
        
        label.text = "Selected books"
        label.font = label.font.withSize(20).withWeight(.medium)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: "FavoriteCell")
        
        return tableView
    }()
    
    private let searchController: UISearchController = {
        let searchVc = SearchViewController()
        
        let searchController = UISearchController(searchResultsController: searchVc)
        searchController.searchBar.searchTextField.font = UIFont.avenir(size: 20)
        searchController.searchResultsUpdater = searchVc
        
        return searchController
    }()
    
    private let noFavoriteLabel: UILabel = {
        let label = UILabel()
        
        label.text = "No favorite book added yet!"
        label.tag = 142
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var constraint1 = NSLayoutConstraint()
    
    private var constraint2 = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        for family in UIFont.familyNames.sorted() {
        //          let names = UIFont.fontNames(forFamilyName: family)
        //          print("Family: \(family) Font names: \(names)")
        //        }
        
        //        try! realm.write {
        //            let allBooks = realm.objects(BookObject.self)
        //            realm.delete(allBooks)
        //        }
        
        favoriteBooks = realm.objects(BookObject.self)
        
        notificationToken = favoriteBooks?.observe { (changes) in
            switch changes {
            case .initial:
                break
            case .update(_, let deletions, let insertions, let modifications):
                
                self.tableView.reloadData()
            case .error(let error):
                fatalError("\(error)")
            }
        }
        
        setupNavBar()
        setupViews()
        setupLayouts()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateHeaderViewHeight(for: tableView.tableHeaderView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        notificationToken?.invalidate()
    }
    
    
    func updateHeaderViewHeight(for header: UIView?) {
        guard let header = header else { return }
        header.frame.size.height = header.systemLayoutSizeFitting(CGSize(width: view.bounds.width - 32.0, height: 0)).height
    }
    
    private func setupNavBar(){
        
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search for your books!"
        navigationItem.searchController = searchController
        
    }
    
    private func setupViews(){
        view.backgroundColor = .white
        view.addSubview(mainView)
        
        mainView.addSubview(titleLabel)
        mainView.addSubview(title1Label)
        mainView.addSubview(bannerImage)
        mainView.addSubview(headerTitle)
        mainView.addSubview(tableView)
        
        let headerView = HeaderView(frame: .zero)
        headerView.configure(text: "Selected books")
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    private func setupLayouts(){
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: mainView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            title1Label.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            title1Label.leadingAnchor.constraint(equalTo: mainView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bannerImage.topAnchor.constraint(equalTo: title1Label.bottomAnchor, constant: 24),
            bannerImage.widthAnchor.constraint(equalTo: mainView.widthAnchor),
            
            bannerImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
        ])
        
        NSLayoutConstraint.activate([
            headerTitle.topAnchor.constraint(equalTo: bannerImage.bottomAnchor, constant: 16),
            headerTitle.leadingAnchor.constraint(equalTo: mainView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerTitle.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        ])
        
        constraint1 = noFavoriteLabel.topAnchor.constraint(equalTo: headerTitle.bottomAnchor, constant: 16)
        constraint2 = noFavoriteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        
        
        
    }
    
    
    @objc private func goToSearchView(){
        
        present(SearchViewController(), animated: true, completion: nil)
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Favorite count:: \(favoriteBooks?.count)")
        
        if let count = favoriteBooks?.count {
            if count > 0 {
                noFavoriteLabel.removeFromSuperview()
                return count
            }
        }
        
        view.addSubview(noFavoriteLabel)
        NSLayoutConstraint.activate([
            constraint1,
            constraint2
        ])
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        
        cell.selectionStyle = .none
        
        if let count = favoriteBooks?.count {
            if count > 0 {
                let favoriteBook = favoriteBooks![indexPath.row]
                cell.configureCell(with: favoriteBook)
                
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let count = favoriteBooks?.count {
            if count > 0 {
                let favoriteBook = favoriteBooks![indexPath.row]
                let vc = BookDetailsViewController(nibName: nil, bundle: nil, book: favoriteBook)
                
                navigationController?.pushViewController(vc, animated: true)
                
            }
        }
    }
    
}
