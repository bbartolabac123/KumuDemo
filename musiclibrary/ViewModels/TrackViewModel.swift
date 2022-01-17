//
//  UserListViewModel.swift
//  musiclibrary
//
//  Created by Benjamin Bartolabac on 16/1/22.
//

import Foundation

class TrackViewModel {
    
    private var trackService: TrackService

    init(trackService: TrackService = TrackService()) {
            self.trackService = trackService
    }
    
    var tracks: [Track] = [Track]()
    var trackEntities: [TrackEntity] = [TrackEntity]()
    var reloadTableView: (()->())?
    var callFetchTracks: (()->())?
    
    private var dataSource: [Section] = []
    
    var numOfSections: Int {
        return dataSource.count
    }
    
    // MARK: fetchTracks
    // Fetch all track from api
    func fetchTracks() {
        trackService.fetchItunesData() {  (result: Result<[Track], Error>) in
            switch result {
                case .success(let tracks):
                    self.tracks = tracks
                    self.createCells(tracks: tracks)
                case .failure(_):
                   print("error")
            }
        }
    }
    
    // MARK: loadTrackEntities
    // Fetch all track from entitiy
    func fetchFavoriteTracks() {
        dataSource.removeAll()
        CoreDataManager.shared.loadTracks() { result in
            switch result {
                case .success(let entities):
                    trackEntities = entities
                    self.createCreateFavoriteCells(tracks: trackEntities)
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func searchTracks(with str: String) {
        dataSource.removeAll()
        trackService.searchItunesData(with: str) {  (result: Result<[Track], Error>) in
            switch result {
                case .success(let tracks):
                    self.tracks = tracks
                    self.createCells(tracks: tracks)
                case .failure(_):
                   print("error")
            }
        }
    }
    
    // return number of track
    func getNumberOfTracks(for sectionIndex: Int) -> Int {
        var count = 0
        if dataSource.count != 0 {
            let section = dataSource[sectionIndex]
            count = section.data.count
        }
        return count
    }
    
    // Returns the title for the given sectionIndex
    func title(for sectionIndex: Int) -> String? {
        let section = dataSource[sectionIndex]
        return section.name
    }
    
    // return TrackCellViewModel
    func getTrackCellViewModel( at indexPath: IndexPath ) -> TrackCellViewModel {
        let section = dataSource[indexPath.section]
        return section.data[indexPath.row]
    }
    
    func sectionType(for sectionIndex: Int) -> SectionType {
        let section = dataSource[sectionIndex]
        return section.type
    }
    
    private func createCells(tracks:[Track]) {
        let tracks = tracks
        var trackCellViewModel = [TrackCellViewModel]()
    
        for track in tracks {
            trackCellViewModel.append(
                TrackCellViewModel(
                    trackName: track.trackName ?? "No Track Name",
                    thumbnail60: track.artworkUrl60 ?? "",
                    thumbnail100: track.artworkUrl100 ?? "",
                    price: track.trackPrice ?? 0.00,
                    genre: track.genre
                )
            )
        }
        
        let section2 = Section(name: "Tracks", type: .list, data: trackCellViewModel)
        dataSource.append(section2)
        reloadTableView?()
    }
    
    private func createCreateFavoriteCells(tracks:[TrackEntity]){
        var trackCellViewModel = [TrackCellViewModel]()
    
        for track in tracks {
            trackCellViewModel.append(
                TrackCellViewModel(
                    trackName: track.trackName ?? "No Track Name",
                    thumbnail60: track.artworkUrl60 ?? "",
                    thumbnail100: track.artworkUrl100 ?? "",
                    price: track.trackPrice ,
                    genre: track.genre ?? "No Genre"
                )
            )
        }
        

        if trackCellViewModel.count > 0 {
            let section = Section(name: "Favorites", type: .bookmarked, data: trackCellViewModel)
            dataSource.append(section)
        }
        self.fetchTracks()
    }
        
    func lastVisit() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let todaysDate = formatter.string(from: Date())
        let defaults = UserDefaults.standard
        defaults.setValue(todaysDate, forKey: "lastVisit")
    }
    
    func  getLastVisitDate()-> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "lastVisit")
    }
}

struct TrackCellViewModel {
    let trackName: String
    let thumbnail60: String
    let thumbnail100: String
    let price: Double
    let genre: String
}
