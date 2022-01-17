//
//  CoreData.swift
//  musiclibrary
//
//  Created by Benjamin Bartolabac on 16/1/22.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "musiclibrary")
        container.loadPersistentStores(completionHandler: { _, error in
            _ = error.map { fatalError("Unresolved error \($0)") }
        })
        return container
    }()
        
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
        
    func backgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    func findTrack(by trackId:Int) -> TrackEntity? {
        let mainContext = CoreDataManager.shared.mainContext
        let fetchRequest: NSFetchRequest<TrackEntity> = TrackEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "trackId = %i", trackId
        )
        do {
            let results = try mainContext.fetch(fetchRequest)
            return results.first ?? nil
        }
        catch {
            return nil
        }
    }
    
    func loadTracks(completion: (Result<[TrackEntity], Error>) -> Void) {
        let mainContext = CoreDataManager.shared.mainContext
        let fetchRequest: NSFetchRequest<TrackEntity> = TrackEntity.fetchRequest()
        do {
            let results = try mainContext.fetch(fetchRequest)
            completion(.success(results))
        }
        catch {
            completion(.failure(error))
        }
    }
    
    func saveTrack(track: Track) throws {
        do {
            let context = CoreDataManager.shared.mainContext
            context.performAndWait{
                let entity = TrackEntity.entity()
                let trackEntity = TrackEntity(entity: entity, insertInto: context)
                trackEntity.trackId = Int32(track.trackId ?? 0)
                trackEntity.trackName = track.trackName ?? "No Track Name"
                trackEntity.artistName = track.artistName
                trackEntity.artworkUrl100 = track.artworkUrl100 ?? ""
                trackEntity.artworkUrl60 = track.artworkUrl60 ?? ""
                trackEntity.genre = track.genre
                trackEntity.trackPrice = track.trackPrice ?? 0.00
                trackEntity.longDescription = track.longDescription ?? track.description ?? ""
            }
            try context.save()
        }catch (let error) {
            print("error \(error)")
        }
    }
    
    func updateTrack(trackEntity: TrackEntity) throws {
        let context = CoreDataManager.shared.backgroundContext()
        context.perform {
            let currentDateTime = Date()
            trackEntity.lastVisited = currentDateTime
        }
        try context.save()
    }
    
    func deleteTrack(trackEntity: TrackEntity) throws {
        guard let context = trackEntity.managedObjectContext else { return }
        context.delete(trackEntity)
        try context.save()
    }
}
