//
//  SearchViewController.swift
//  TvShowReminder
//
//  Created by Pedro Crohare on 13/09/2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    var backgroundImageView = UIImageView()
    var subscribeButton = UIButton()
    var show: ShowModel?
    var coordinator: AppCoordinator?
    
    
    
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.contentMode = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureBackgroundImage()
        configureScroll()
        configureImage()
        configureSubscribeButton()
        configureDescription()
    }
    
    func configureScroll() {
        
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        scrollView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor).isActive = true
        
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.heightAnchor).isActive = true
        
    }
    
    func configureSubscribeButton() {
        let button = UIButton()
        stackView.addArrangedSubview(button)
        button.setTitle("SUSCRIBIRSE", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.tintColor = .white
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(subscribeTapped(_:)), for: .touchUpInside)
    }
    
    @objc func subscribeTapped(_ sender: Any) {
        if let sender = sender as? UIButton, let show = show {
            
            if let text = sender.titleLabel?.text, text == "SUSCRIPTO" {
                
                sender.backgroundColor = .clear
                sender.layer.borderColor = UIColor.white.cgColor
                sender.tintColor = .white
                sender.setTitle("SUSCRIBIRME", for: .normal)
                coordinator?.unsubscribeShow(show)
                
                
            } else {
                sender.backgroundColor = .clear
                sender.layer.borderColor = UIColor.black.cgColor
                sender.tintColor = .black
                sender.setTitle("SUSCRIPTO", for: .normal)
                coordinator?.subscribeShow(show)
            }
            
        }
    }
    
    
    func configureDescription() {
        let overviewlabel = UILabel()
        let overviewDescription = UILabel()
        
        overviewDescription.numberOfLines = 0
        overviewDescription.text = show!.description + show!.description
        overviewDescription.textColor = .white
        
        
        overviewlabel.text = "OVERVIEW"
        overviewlabel.textColor = UIColor(hex: "#383838ff")
        
        stackView.addArrangedSubview(overviewlabel)
        stackView.addArrangedSubview(overviewDescription)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stackView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        stackView.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stackView.isHidden = true
    }
    
    func configureBackgroundImage() {
        
        self.view.addSubview(backgroundImageView)
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false

        backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = false
        backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = false

        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundImageView.layer.opacity = 0.8
                
        coordinator?.loadImage(in: backgroundImageView, withPath: show?.posterPath)
        
        
        

    }
    
    
    
    func configureImage() {
        
        let imageView = UIImageView()
        self.stackView.addArrangedSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true

        coordinator?.loadImage(in: imageView, withPath: show?.backdropPath)

    }
    
    init?(coordinator: AppCoordinator?, showModel: ShowModel) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
        self.show = showModel
        
        if let coordinator = coordinator {
            
            coordinator.subscribedShows.forEach { showModel in
                if showModel.id == show?.id {
                    subscribeButton.backgroundColor = .clear
                    subscribeButton.layer.borderColor = UIColor.black.cgColor
                    subscribeButton.tintColor = .black
                    subscribeButton.setTitle("SUSCRIPTO", for: .normal)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(hex: "#000000e6")
        navigationController?.navigationBar.tintColor = .white
    }
}
