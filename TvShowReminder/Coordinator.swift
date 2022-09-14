//
//  TVSRCoordinator.swift
//  TvShowReminder
//
//  Created by Pedro Crohare on 10/09/2022.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
