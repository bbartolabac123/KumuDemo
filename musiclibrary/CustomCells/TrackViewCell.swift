//
//  TrackTableViewCell.swift
//  musiclibrary
//
//  Created by Benjamin Bartolabac on 16/1/22.
//

import UIKit

class TrackViewCell: UICollectionViewCell, Configurable {
 
    public var identifier: String = "TrackViewCell"
    let trackNameLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font =  UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    let priceLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font =  UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    let thumbnailView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "image"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let arrowView: UIImageView = {
        let largeFont = UIFont.systemFont(ofSize: 20)
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(font: largeFont)))
        imageView.tintColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let genrePillView: UIButton = {
        let button = UIButton(type: .custom)
        button.isEnabled = false
        button.backgroundColor = .systemGray
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(trackNameLbl)
        self.contentView.addSubview(priceLbl)
        self.contentView.addSubview(thumbnailView)
        self.contentView.addSubview(arrowView)
        self.contentView.addSubview(genrePillView)
        self.contentView.backgroundColor = .white
        self.contentView.clipsToBounds = true
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        let thumbnailViewConstraints = [
            self.thumbnailView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.thumbnailView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.thumbnailView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.thumbnailView.widthAnchor.constraint(equalToConstant: 80),
        ]
        
        NSLayoutConstraint.activate(thumbnailViewConstraints)
        let arrowViewConstraints = [
            self.arrowView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.arrowView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10),
            self.arrowView.heightAnchor.constraint(equalToConstant: 20),
            self.arrowView.widthAnchor.constraint(equalToConstant: 10),
        ]
        
        NSLayoutConstraint.activate(arrowViewConstraints)
        let trackLblConstraints = [
            trackNameLbl.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            trackNameLbl.leftAnchor.constraint(equalTo: self.thumbnailView.rightAnchor, constant: 10),
            trackNameLbl.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -25)
        ]
        NSLayoutConstraint.activate(trackLblConstraints)
        
        let priceLblConstraints = [
            self.priceLbl.topAnchor.constraint(equalTo: self.trackNameLbl.bottomAnchor),
            self.priceLbl.leftAnchor.constraint(equalTo: self.thumbnailView.rightAnchor, constant: 10),
        ]
        NSLayoutConstraint.activate(priceLblConstraints)
        
        let pillConstraints = [
            self.genrePillView.leftAnchor.constraint(equalTo: self.thumbnailView.rightAnchor, constant: 5),
            self.genrePillView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            self.genrePillView.heightAnchor.constraint(equalToConstant: 25),
        ]
        
        NSLayoutConstraint.activate(pillConstraints)
        
        self.genrePillView.contentEdgeInsets = UIEdgeInsets(top: 2, left: 1, bottom: 2, right: 1)
        self.genrePillView.layer.cornerRadius = 4
        
        self.contentView.layer.borderWidth = 0.5
        self.contentView.layer.borderColor = UIColor.systemGray.cgColor
     
    }
    
    func configureCell(with trackCellViewModel: TrackCellViewModel) {
        trackNameLbl.text = trackCellViewModel.trackName
        priceLbl.text = String(format: "$%.02f", trackCellViewModel.price)
        thumbnailView.loadImage(url: trackCellViewModel.thumbnail100)
        genrePillView.setTitle(trackCellViewModel.genre, for: .normal)
    }
}
