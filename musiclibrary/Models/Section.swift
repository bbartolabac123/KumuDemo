//
//  Section.swift
//  musiclibrary
//
//  Created by Benjamin Bartolabac on 16/1/22.
//

import Foundation

/*
The Section type will decide what layout the UICollectionView will use for that section
 */
enum SectionType: Int, CaseIterable {
    case bookmarked
    case list
}

struct Section {
    let name: String
    let type: SectionType
    let data: [TrackCellViewModel]
}
