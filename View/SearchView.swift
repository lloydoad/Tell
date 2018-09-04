//
//  SearchView.swift
//  Tell
//
//  Created by Lloyd Dapaah on 7/11/18.
//  Copyright © 2018 Lloyd Dapaah. All rights reserved.
//

import UIKit

class SearchView: UIViewController {
    lazy var rootPageView = self.parent as! RootPageView
    var searchBar: UISearchBar!
    var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        
        setupView()
        
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        rootPageView.navigationItem.title = "Search"
    }
    
    func setupView() {
        searchBar = UISearchBar()
        searchBar.barStyle = .default
        searchBar.searchBarStyle = .minimal
        searchBar.isTranslucent = true
        searchBar.barTintColor = .white
        view.addSubview(searchBar)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        searchBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        searchTableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .plain)
        view.addSubview(searchTableView)
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        searchTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        searchTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        searchTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

}
