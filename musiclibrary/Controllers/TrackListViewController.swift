//
//  TrackListViewController.swift
//  musiclibrary
//
//  Created by Benjamin Bartolabac on 16/1/22.
//

import UIKit

class TrackListViewController: UIViewController, DetailViewDelegate {

    private var collectionView: UICollectionView!
    lazy var trackViewModel = {
        TrackViewModel()
    }()
    
    private let lastVisitLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.italicSystemFont(ofSize: 12)
        lbl.textColor = .systemRed
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.placeholder = "Search Track Name or Artist"
        textField.isEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeViews()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Setup methods -
    /// Initialize all views
    private func initializeViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(lastVisitLbl)
        self.view.addSubview(containerView)
        self.view.addSubview(searchTextField)
       
        let constraints = [
            lastVisitLbl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            lastVisitLbl.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 5),
            lastVisitLbl.heightAnchor.constraint(equalToConstant: 10),
            lastVisitLbl.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.90),
            searchTextField.topAnchor.constraint(equalTo: self.lastVisitLbl.bottomAnchor, constant: 5),
            searchTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
            searchTextField.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.90),
            containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            containerView.topAnchor.constraint(equalTo: self.searchTextField.bottomAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ]
        containerView.backgroundColor = .systemFill
        NSLayoutConstraint.activate(constraints)
        searchTextField.addTarget(self, action: #selector(searchAction), for: .editingChanged)
        self.restorationIdentifier = "trackList"
        setupCollectionView()
        initializeViewModel()
    }
    
    @objc private func searchAction() {
        guard let search = self.searchTextField.text else {
            trackViewModel.fetchTracks()
            return
        }
        trackViewModel.searchTracks(with: search)
    }
    /// Constructs the UICollectionView and adds it to the view.
    /// Registers all the Cells
    private func setupCollectionView() {
        
        collectionView = UICollectionView.init(frame: .zero,
                                               collectionViewLayout: makeLayout())
        // Assigning data source and background color
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        containerView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraining the collection view to the 4 edges of the view
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: containerView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        collectionView.register(SectionHeader.self,
                                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                      withReuseIdentifier: SectionHeader().identifier)
        collectionView.register(BookmarkCollectionViewCell.self, forCellWithReuseIdentifier: BookmarkCollectionViewCell().identifier)
        collectionView.register(TrackViewCell.self, forCellWithReuseIdentifier: TrackViewCell().identifier)
    }
    
    private func initializeViewModel() {
        self.lastVisitLbl.text = trackViewModel.getLastVisitDate() != nil ?  "Last Visited: \(String(describing: trackViewModel.getLastVisitDate()!))" : ""
        trackViewModel.fetchFavoriteTracks()
        trackViewModel.reloadTableView = {
            DispatchQueue.main.async { [weak self] in
                self?.trackViewModel.lastVisit()
                self?.collectionView.reloadData()
            }
        }
    }
    
    func didDismissView() {
        trackViewModel.fetchFavoriteTracks()
    }
    
    /// Creates the appropriate UICollectionViewLayout for each section type
    private func makeLayout() -> UICollectionViewLayout {
        // Constructs the UICollectionViewCompositionalLayout
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            switch self.trackViewModel.sectionType(for: sectionIndex) {
                case .bookmarked:   return self.createBookmarklist()
                case .list: return self.createList(for:self.trackViewModel.getNumberOfTracks(for: sectionIndex))
            }
        }
        
        // Configure the Layout with interSectionSpacing
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
    
    //Creates the layout for the Bookmarked sections
    private func createBookmarklist() -> NSCollectionLayoutSection {
        // Defining the size of a single item in this layout
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.20),
                                              heightDimension: .absolute(70))
        // Construct the Layout Item
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Configuring the Layout Item
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 5)
        
        // Defining the size of a group in this layout
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                     heightDimension: .estimated(250))
        // Constructing the Layout Group
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize,
                                                             subitems: [layoutItem])
        
        // Constructing the Layout Section
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        // Configuring the Layout Section
        //
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        // Constructing the Section header
        let layoutSectionHeader = createSectionHeader()
        
        // Adding the Section Header to the Layout Section
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
    }
    
    //Creates the layout for the track list sections
    private func createList(for amount: Int) -> NSCollectionLayoutSection {
         // Defining the size of a single item in this layout
         let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(0.5))
         // Constructing the Layout Item
         let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
         
         // Configuring the Layout Item
         layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 5)
         
         // Defining the size of a group in this layout
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(self.containerView.frame.width),
                                                      heightDimension: .estimated(CGFloat(90 * amount)))
         // Constructing the Layout Group
         let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize,
                                                            subitem: layoutItem,
                                                            count: amount)
         // Configuring the Layout Group
         layoutGroup.interItemSpacing = .fixed(4)
         
         // Constructing the Layout Section
         let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
         
         // Constructing the Section header
         let layoutSectionHeader = createSectionHeader()
         
         // Adding the Section Header to the Layout Section
         layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
         
         return layoutSection
     }
    
    //Creates a Layout for the SectionHeader
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        // Define size of Section Header
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95),
                                                             heightDimension: .estimated(80))
        
        // Construct Section Header Layout
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize,
                                                                              elementKind: UICollectionView.elementKindSectionHeader,
                                                                              alignment: .top)
        return layoutSectionHeader
    }
}

//MARK: UICollectionView Delegate and Datasource
extension TrackListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return trackViewModel.numOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackViewModel.getNumberOfTracks(for: section)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch trackViewModel.sectionType(for: indexPath.section) {
            case .bookmarked:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkCollectionViewCell().identifier, for: indexPath) as? BookmarkCollectionViewCell else { fatalError("Could not dequeue Bookmark cell") }
                           
                cell.configureCell(with: trackViewModel.getTrackCellViewModel(at: indexPath))
                           
                return cell
            case .list:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackViewCell().identifier, for: indexPath) as? TrackViewCell else { fatalError("Could not dequeue tracklist cell") }
                           
                cell.configureCell(with: trackViewModel.getTrackCellViewModel(at: indexPath))
                           
                return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var track: Track?
        
        switch trackViewModel.sectionType(for: indexPath.section) {
            case .bookmarked:
                let trackEntity = trackViewModel.trackEntities[indexPath.row]
                track = Track(trackId: Int(trackEntity.trackId) , trackName: trackEntity.trackName, artistName: trackEntity.artistName ?? "Artist Unknown", trackPrice: trackEntity.trackPrice, artworkUrl60: trackEntity.artworkUrl60, artworkUrl100: trackEntity.artworkUrl100, genre: trackEntity.genre ?? "No Genre", longDescription: trackEntity.longDescription, description: trackEntity.description)
            case .list:
                track = trackViewModel.tracks[indexPath.row]
        }
        
        let detailViewController = DetailViewController()
        detailViewController.delegate = self
        detailViewController.track = track
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader().identifier, for: indexPath) as? SectionHeader else {
            fatalError("Could not dequeue SectionHeader")
        }
        
        // If the section has a title show it in the Section header, otherwise hide the titleLabel
        if let title = trackViewModel.title(for: indexPath.section) {
            headerView.titleLabel.text = title
        }
        return headerView
    }
    
}


