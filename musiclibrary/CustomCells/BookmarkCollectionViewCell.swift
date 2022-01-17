//
//  BookmarkCollectionViewCell.swift
//  musiclibrary
//
//  Created by Benjamin Bartolabac on 16/1/22.
//

import UIKit

class BookmarkCollectionViewCell: UICollectionViewCell, Configurable {
  
    public var identifier: String = "BookmarkCell"
    let thumbnailView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "image"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let label: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .systemGray2
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
  override init(frame: CGRect) {
       super.init(frame: frame)
       self.contentView.backgroundColor = .clear
       self.contentView.addSubview(thumbnailView)
       self.contentView.addSubview(label)
   }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let constraints = [
            self.thumbnailView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.thumbnailView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.thumbnailView.widthAnchor.constraint(equalToConstant: 64),
            self.thumbnailView.heightAnchor.constraint(equalToConstant: 64),
            self.label.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.label.topAnchor.constraint(equalTo: self.thumbnailView.bottomAnchor),
            self.label.heightAnchor.constraint(equalToConstant: 30),
            self.label.widthAnchor.constraint(equalToConstant: self.contentView.frame.width),
        ]
        
        NSLayoutConstraint.activate(constraints)
        self.thumbnailView.layer.masksToBounds = true
        self.thumbnailView.layer.cornerRadius = 32
       
    }
    
    func configureCell(with trackCellViewModel: TrackCellViewModel) {
        thumbnailView.loadImage(url: trackCellViewModel.thumbnail100)
        label.text = trackCellViewModel.trackName
    }
    
   // we have to implement this initializer, but will only ever use this class programmatically
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
    
}
