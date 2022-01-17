//
//  ImageViewExtension.swift
//  musiclibrary
//
//  Created by Benjamin Bartolabac on 16/1/22.
//

import UIKit

extension UIImageView {
    
    func loadImage(url: String) {
        NetworkManager().downloadImage(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
                   case .success(let data):
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data)
                    }
                   case .failure(_):
                       self.image = UIImage(named: "image")
            }
        }
    }
    
    func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat){
         containerView.clipsToBounds = false
         containerView.layer.shadowColor = UIColor.black.cgColor
         containerView.layer.shadowOpacity = 1
         containerView.layer.shadowOffset = CGSize.zero
         containerView.layer.shadowRadius = 10
         containerView.layer.cornerRadius = cornerRadious
         containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadious).cgPath
         self.clipsToBounds = true
         self.layer.cornerRadius = cornerRadious
     }
    
}
