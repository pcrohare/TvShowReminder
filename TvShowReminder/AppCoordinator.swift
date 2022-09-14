//
//  TVSRAppCoordinator.swift
//  TvShowReminder
//
//  Created by Pedro Crohare on 10/09/2022.
//

import Foundation
import UIKit

class AppCoordinator: NSObject, Coordinator {
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    var networkManager: NetworkManager
    
    func start() {
        self.navigationController.delegate = self
        let vc = HomeViewController()
        self.networkManager.delegate = vc
        navigationController.pushViewController(vc, animated: false)
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.networkManager = NetworkManager()
        
    }
    
    func showSearch() {
        let childCoordinator = SearchCoordinator(navigationController: navigationController)
        childCoordinator.parentCoordinator = self
        childCoordinators.append(childCoordinator)
        childCoordinator.start()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func showDetails(showModel: ShowModel) {
        let detailViewController = DetailViewController(collectionViewLayout: HeaderLayout())
        detailViewController.show = showModel
        detailViewController.coordinator = self
        navigationController.pushViewController(detailViewController, animated: false)
    }
    
    func loadImage(in imageView: UIImageView?, withPath path: String?) {
        if let imageView = imageView, let path = path {
            networkManager.loadImage(in: imageView, withPath: path)
        }
    }
    
    func loadShows() {
        networkManager.loadShows()
    }
    
}

extension AppCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        if let searchViewController = fromViewController as? SearchViewController {
            self.childDidFinish(searchViewController.coordinator)
        }
        
    }
    
    
}
