//
//  SearchViewController.swift
//  TvShowReminder
//
//  Created by Pedro Crohare on 13/09/2022.
//

import UIKit

class SearchViewController: UITableViewController, UISearchBarDelegate {
    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        self.coordinator?.cancelTapped()
//    }
//
    var shows: [ShowModel]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var coordinator: SearchCoordinator?
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        
        
        navigationItem.searchController = UISearchController()
        self.navigationItem.searchController?.searchBar.delegate = self
        
        DispatchQueue.main.async { [unowned self] in
            
            UIView.animate(withDuration: .zero) {
                self.navigationItem.searchController?.searchBar.becomeFirstResponder()

            }
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(ShowTableViewCell.self, forCellReuseIdentifier: "showCellID")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let show = shows?[indexPath.row]
        coordinator?.showDetails(showModel: show!)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let shows = self.shows {
            return shows.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let showCell = tableView.dequeueReusableCell(withIdentifier: "showCellID", for: indexPath) as! ShowTableViewCell
        

        
        showCell.genreLabel.text = shows?[indexPath.row].genre
        showCell.titleLabel.text = shows?[indexPath.row].title
                
        self.coordinator?.loadImage(in: showCell.imageContainer, withPath: self.shows?[indexPath.row].posterPath, tableView: tableView)
        
        return showCell
    }
}
