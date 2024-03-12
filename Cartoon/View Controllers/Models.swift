//
//  Models.swift
//  Cartoon
//
//  Created by BCL Device-18 on 7/3/24.
//

import Foundation

struct SectionData {
    let sectionType: SectionType
    let numberOfItems: NumberOfItems
    let headerTitle: String
    let shouldShowMore: Bool
    let items: [Item]
}

struct Item {
    let text: String
    let image: String
    let description: String
    let isPro: Bool
}

