//
//  ShowCell.swift
//  TvShowReminder
//
//  Created by Pedro Crohare on 13/09/2022.
//

import UIKit

class ShowTableViewCell: UITableViewCell {
    let imageContainer = UIImageView()
    let genreLabel = UILabel()
    let titleLabel = UILabel()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    private func configureView() {
        layoutImageView()
        layoutLabels()
        
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0))
    }
    
    private func layoutLabels() {
        
        titleLabel.textColor = UIColor(hex: "#e1f5ffff")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        
        genreLabel.textColor = UIColor(hex: "#ffffff88")
        genreLabel.font = UIFont.systemFont(ofSize: 24)
        genreLabel.backgroundColor = UIColor(hex: "#1e2b3188")
        
        
        self.contentView.addSubview(genreLabel)
        self.contentView.addSubview(titleLabel)
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        genreLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -15).isActive = true
        genreLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant:  15).isActive = true
        
        titleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 15).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0).isActive = true
        titleLabel.lineBreakMode = .byTruncatingTail
    }
    
    private func layoutImageView() {
        self.contentView.addSubview(imageContainer)
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        imageContainer.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        imageContainer.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        imageContainer.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        imageContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageContainer.contentMode = .scaleAspectFill
        imageContainer.clipsToBounds = true
        imageContainer.layer.opacity = 0.7
    }
}
