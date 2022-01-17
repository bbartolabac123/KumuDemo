//
//  DetailViewController.swift
//  musiclibrary
//
//  Created by Benjamin Bartolabac on 16/1/22.
//

import UIKit

protocol DetailViewDelegate {
    func didDismissView()
}

class DetailViewController: UIViewController {

    var delegate: DetailViewDelegate?
    var track: Track?
    
    lazy var detailViewModel = {
        DetailViewModel()
    }()
    
    let imageView: UIImageView = {
       let imageView = UIImageView(image: UIImage(named: "image"))
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .custom)
        let largeFont = UIFont.systemFont(ofSize: 20)
        let img =  UIImage(
            systemName: "chevron.backward")?.applyingSymbolConfiguration(
            UIImage.SymbolConfiguration(font: largeFont))
        button.setImage(img, for: .normal)
        button.backgroundColor = .gray
        button.imageView?.tintColor = .white
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        let largeFont = UIFont.systemFont(ofSize: 20)
        let img =  UIImage(
            systemName: "heart")?.applyingSymbolConfiguration(
            UIImage.SymbolConfiguration(font: largeFont))
        button.setImage(img, for: .normal)
        button.backgroundColor = .clear
        button.imageView?.tintColor = .white
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let trackNameLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.textColor = .white
        label.lineBreakMode = .byCharWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let artistNameLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 12)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SF Pro", size: 16)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let genreLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lastVisitedLbl:UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let detailViewLbl: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let detailTextView: UILabel = {
        let textView = UILabel()
        textView.numberOfLines = 0
        textView.backgroundColor = .clear
        textView.textColor = .black
        textView.textAlignment = .left
        textView.font = UIFont(name: "SF Pro", size: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let headerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemIndigo
        return view
    }()
    
    let stackViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 2.0
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.systemFill.cgColor
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Price:"
        label.textColor = .lightGray
        label.textAlignment = .center
        
        let label2 = UILabel()
        label2.font = UIFont.systemFont(ofSize: 16)
        label2.text = "Genre:"
        label2.textColor = .lightGray
        label2.textAlignment = .center
        
        [label,priceLbl,label2,genreLbl].forEach { stackView.addArrangedSubview($0) }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        
        initializeViews()
        loadDataInformation()
    }
    
    // MARK: Initializer
    
    //Initialize Views
    private func initializeViews() {

        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        self.contentView.addSubview(headerContainerView)
        self.headerContainerView.addSubview(imageView)
        self.contentView.addSubview(trackNameLbl)
        self.scrollView.addSubview(backButton)
        self.scrollView.addSubview(favoriteButton)
        self.contentView.addSubview(artistNameLbl)
        self.contentView.addSubview(lastVisitedLbl)
        self.contentView.addSubview(detailViewLbl)
        self.contentView.addSubview(detailTextView)
        self.contentView.addSubview(stackViewContainer)
        self.stackViewContainer.addSubview(stackView)
        self.scrollView.bringSubviewToFront(backButton)
        self.scrollView.bringSubviewToFront(favoriteButton)

        
        let constraints = [
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.scrollView.widthAnchor.constraint(equalToConstant: self.view.frame.width),
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            self.headerContainerView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.headerContainerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.headerContainerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.headerContainerView.heightAnchor.constraint(equalToConstant: self.view.frame.height * 0.40),
            self.imageView.topAnchor.constraint(equalTo: self.headerContainerView.topAnchor, constant: 40),
            self.imageView.centerXAnchor.constraint(equalTo: self.headerContainerView.centerXAnchor),
            self.imageView.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.40),
            self.imageView.heightAnchor.constraint(equalToConstant: self.view.frame.height * 0.25),
            self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant:  10),
            self.backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant:  10),
            self.backButton.heightAnchor.constraint(equalToConstant: 30),
            self.backButton.widthAnchor.constraint(equalToConstant: 30),
            self.favoriteButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant:  10),
            self.favoriteButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant:  -10),
            self.favoriteButton.heightAnchor.constraint(equalToConstant: 30),
            self.favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            self.trackNameLbl.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 10),
            self.trackNameLbl.centerXAnchor.constraint(equalTo: self.imageView.centerXAnchor),
            self.artistNameLbl.topAnchor.constraint(equalTo: self.trackNameLbl.bottomAnchor, constant:3),
            self.artistNameLbl.centerXAnchor.constraint(equalTo: self.imageView.centerXAnchor),
            self.stackViewContainer.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.stackViewContainer.topAnchor.constraint(equalTo: self.headerContainerView.bottomAnchor),
            self.stackViewContainer.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.stackViewContainer.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.stackViewContainer.heightAnchor.constraint(equalToConstant: 40),
            self.detailViewLbl.topAnchor.constraint(equalTo: self.stackViewContainer.bottomAnchor, constant:20),
            self.stackView.topAnchor.constraint(equalTo: self.stackViewContainer.topAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.stackViewContainer.bottomAnchor),
            self.stackView.leftAnchor.constraint(equalTo: self.stackViewContainer.leftAnchor),
            self.stackView.rightAnchor.constraint(equalTo: self.stackViewContainer.rightAnchor),
            self.detailViewLbl.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant:10),
            self.detailTextView.topAnchor.constraint(equalTo: self.detailViewLbl.bottomAnchor, constant: 15),
            self.detailTextView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 5),
            self.detailTextView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -5),
            self.detailTextView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
        let contentWidth = scrollView.bounds.width
        let contentHeight = scrollView.bounds.height * 3
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 15
        self.favoriteButton.addTarget(self, action: #selector(saveTrackToFavorite), for: .touchDown)
        self.restorationIdentifier = "detailView"
        setFavoriteButtonStyle()
    
    }
    
    private func setFavoriteButtonStyle() {
        let largeFont = UIFont.systemFont(ofSize: 20)
        var img: UIImage?
        
        if detailViewModel.getFavoriteTrackEntity(id: (track?.trackId) ?? 0) != nil {
             img =  UIImage(
                systemName: "heart.fill")?.applyingSymbolConfiguration(
                UIImage.SymbolConfiguration(font: largeFont))
            favoriteButton.imageView?.tintColor = .systemRed
        }else{
            img =  UIImage(
               systemName: "heart")?.applyingSymbolConfiguration(
               UIImage.SymbolConfiguration(font: largeFont))
        }
        favoriteButton.setImage(img, for: .normal)
    
    }
    
    /// Load data to views
    private func loadDataInformation() {
        self.backButton.layer.cornerRadius = 15
        self.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        self.imageView.loadImage(url: self.track?.artworkUrl100 ?? self.track?.artworkUrl60 ?? "")
        self.trackNameLbl.text = self.track?.trackName ?? "No Track Name Available"
        self.artistNameLbl.text = "by \(self.track?.artistName ?? "Unknown")"
        self.priceLbl.text = String(format: "$%.02f", self.track?.trackPrice ?? 0.00)
        self.genreLbl.text = self.track?.genre ?? "No Genre Available"
        self.detailTextView.text = self.track?.longDescription ?? "No Description Available"
    }
    
    @objc func backAction(_ sender:UIButton!){
        delegate?.didDismissView()
        self.navigationController?.popViewController(animated: true)
    }

    @objc func saveTrackToFavorite(){
        
        let trackEntity = detailViewModel.getFavoriteTrackEntity(id: (track?.trackId)!)
        
        if trackEntity != nil {
            self.detailViewModel.removeFavorite(track: trackEntity!)
            let largeFont = UIFont.systemFont(ofSize: 20)
            let img =  UIImage(
                systemName: "heart")?.applyingSymbolConfiguration(
                UIImage.SymbolConfiguration(font: largeFont))
            favoriteButton.setImage(img, for: .normal)
            favoriteButton.imageView?.tintColor = .systemGray
        }else{
            self.detailViewModel.saveFavorite(track: track!)
            let largeFont = UIFont.systemFont(ofSize: 20)
            let img =  UIImage(
                systemName: "heart.fill")?.applyingSymbolConfiguration(
                UIImage.SymbolConfiguration(font: largeFont))
            favoriteButton.setImage(img, for: .normal)
            favoriteButton.imageView?.tintColor = .systemRed
        }
    }
}

extension DetailViewController {
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        coder.encode(track, forKey: "detailView")
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        if let returnData = coder.decodeObject(forKey: "detailView") as? Track {
            track = returnData
        }
    }
}
