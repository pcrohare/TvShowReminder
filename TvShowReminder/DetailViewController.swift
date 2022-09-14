//
//  SearchViewController.swift
//  TvShowReminder
//
//  Created by Pedro Crohare on 13/09/2022.
//

import UIKit

class DetailViewController: UIViewController {
    var coordinator: AppCoordinator?
    var show: ShowModel?
    
    
    let imageContainer = UIImageView()
    let descriptionLabel = UILabel()
    let titleLabel = UILabel()
    
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .cyan
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
