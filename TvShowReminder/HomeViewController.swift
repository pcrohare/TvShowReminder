//
//  TVSRHomeViewController.swift
//  TvShowReminder
//
//  Created by Pedro Crohare on 13/09/2022.
//

import UIKit

struct ShowModel {
    let title: String
    let description: String
    let posterPath: String
    let genre: String
}


class HomeViewController: UIViewController, NetworkManagerDelegate {
    func didLoadShows(shows: [ShowModel]) {
        self.shows = shows
    }
    
    func didFail(_ error: Error?) {
        print(error)
    }
    
    var shows: [ShowModel]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var tableView: UITableView!
    var allShowsStackView: UIStackView!
    var showsLabel: UILabel!
    
    var coordinator: AppCoordinator?
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.searchController?.searchBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let navigationController = self.navigationController {
            coordinator = AppCoordinator(navigationController: navigationController)
            coordinator?.networkManager.delegate = self
            coordinator?.loadShows()
            
        }
        
        
       
        layoutNavigationBar()
        layoutAllShowsStack()
        
        
        
    }
    
    private func layoutNavigationBar() {
        self.title = "TvShowReminder"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        self.navigationItem.leftBarButtonItem?.tintColor = .white
        self.view.backgroundColor = UIColor(hex: "#1b1b1bff")
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: "#000000e6")
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        
    }
    
    private func layoutAllShowsStack() {
        allShowsStackView = UIStackView()
        allShowsStackView.axis = .vertical
        allShowsStackView.spacing = 15

        self.view.addSubview(allShowsStackView)
        allShowsStackView.translatesAutoresizingMaskIntoConstraints = false
        allShowsStackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
        allShowsStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        allShowsStackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
        allShowsStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        configureLabel()
        configureTableView()
    }
        
    private func configureLabel() {
        showsLabel = UILabel()
        showsLabel.text = "TODAS"
        showsLabel.textColor = UIColor(hex: "#ffffff88")
        allShowsStackView.addArrangedSubview(showsLabel)
    }
    
    private func configureTableView() {
        tableView = UITableView()
        allShowsStackView.addArrangedSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ShowTableViewCell.self, forCellReuseIdentifier: "showCellID")

    }
    
    @objc private func searchTapped() {
        coordinator?.showSearch()
    }
 
}


extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 156
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let show = shows?[indexPath.row]
        coordinator?.showDetails(showModel: show!)
        
    }
    
}

extension HomeViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let shows = self.shows {
            return shows.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let showCell = tableView.dequeueReusableCell(withIdentifier: "showCellID", for: indexPath) as! ShowTableViewCell
        

        
        showCell.genreLabel.text = shows?[indexPath.row].genre
        showCell.titleLabel.text = shows?[indexPath.row].title
                
        self.coordinator?.loadImage(in: showCell.imageContainer, withPath: self.shows?[indexPath.row].posterPath, tableView: tableView)
        
        return showCell
    }
    
}
