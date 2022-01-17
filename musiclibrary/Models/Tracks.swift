//
//  Tracks.swift
//  musiclibrary
//
//  Created by Benjamin Bartolabac on 16/1/22.
//

import Foundation

struct Response: Decodable {
    let resultCount: Int
    let results: [Track]
}

struct Track: Decodable {
    let trackId: Int?
    let trackName: String?
    let artistName: String
    let trackPrice: Double?
    let artworkUrl60: String?
    let artworkUrl100: String?
    let genre: String
    let longDescription: String?
    let description: String?
    
    private enum CodingKeys : String, CodingKey {
        case trackId = "trackId"
        case trackName = "trackName"
        case artistName = "artistName"
        case trackPrice = "trackPrice"
        case artworkUrl60 = "artworkUrl60"
        case artworkUrl100 = "artworkUrl100"
        case longDescription = "longDescription"
        case description = "description"
        case genre  = "primaryGenreName"
    }
}
