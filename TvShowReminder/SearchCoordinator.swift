//
//  SearchCoordinator.swift
//  TvShowReminder
//
//  Created by Pedro Crohare on 13/09/2022.
//

import UIKit

class SearchCoordinator: NSObject, Coordinator {
    
    
    weak var parentCoordinator: AppCoordinator?
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    var networkManager: NetworkManager?
    
    func start() {
        navigationController.delegate = self
        let vc = SearchViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }

    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.networkManager = NetworkManager()
    }
    
    func showDetails(showModel: ShowModel) {
        parentCoordinator?.showDetails(showModel: showModel)
    }
    
    func loadImage(in imageView: UIImageView?, withPath path: String?, tableView: UITableView) {
        if let imageView = imageView, let path = path {
            networkManager?.loadImage(in: imageView, withPath: path)
        }
    }
    
    func loadShows(delegate: NetworkManagerDelegate) {
        
        networkManager?.delegate = delegate
        networkManager?.loadShows()
    }
    
}

extension SearchCoordinator: UINavigationControllerDelegate {
    
}
