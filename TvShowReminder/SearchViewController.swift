//
//  SearchViewController.swift
//  TvShowReminder
//
//  Created by Pedro Crohare on 13/09/2022.
//

import UIKit

class SearchViewController: UIViewController, NetworkManagerDelegate {
    func didLoadShows(shows: [ShowModel]) {
        self.shows = shows
        
    }
    
    func didFail(_ error: Error?) {
        print("search failed")
    }
    


    
    var shows: [ShowModel]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var filteredShows: [ShowModel]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var coordinator: SearchCoordinator?
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView()
        self.view.backgroundColor = .blue
        navigationController?.navigationBar.backItem?.title = ""
        navigationItem.searchController = UISearchController()
        navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        self.view.backgroundColor = UIColor(hex: "#1b1b1bff")

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
        self.view.addSubview(tableView)
        
        coordinator?.loadShows(delegate: self)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let show = filteredShows?[indexPath.row]
        coordinator?.showDetails(showModel: show!)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let shows = self.filteredShows {
            return shows.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let showCell = tableView.dequeueReusableCell(withIdentifier: "showCellID", for: indexPath) as! ShowTableViewCell
        

        
        showCell.genreLabel.text = filteredShows?[indexPath.row].genre
        showCell.titleLabel.text = filteredShows?[indexPath.row].title
                
        self.coordinator?.loadImage(in: showCell.imageContainer, withPath: self.filteredShows?[indexPath.row].posterPath, tableView: tableView)
        
        return showCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 156
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        true
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredShows = [ShowModel]()
        
        if let shows = shows {
            if searchText == "" {
                filteredShows = shows
            }
            
            for show in shows {
                if show.title.uppercased().contains(searchText.uppercased()) {
                    filteredShows?.append(show)
                }
            }
        }
       
        self.tableView.reloadData()
        
    }
}
