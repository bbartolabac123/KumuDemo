//
//  DetailViewModel.swift
//  musiclibrary
//
//  Created by Benjamin Bartolabac on 16/1/22.
//

import Foundation

class DetailViewModel: NSObject {
    
    /// Save favorite to CoreData
    func saveFavorite(track: Track) {
        do {
            try CoreDataManager.shared.saveTrack(track: track)
        }catch {
            print("Error on saving core entity data")
        }
    }
    
    func removeFavorite(track: TrackEntity) {
        do {
            try CoreDataManager.shared.deleteTrack(trackEntity: track)
        }catch {
            print("Error on saving core entity data")
        }
    }
    // MARK: findTrackEntityById
    // fetch specific track in core data by using trackId
    func getFavoriteTrackEntity(id: Int) -> TrackEntity? {
        let trackEntity = CoreDataManager.shared.findTrack(by: id)
        return trackEntity
    }
}
