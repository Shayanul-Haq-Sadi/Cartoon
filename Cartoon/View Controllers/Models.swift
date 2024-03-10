//
//  Models.swift
//  Cartoon
//
//  Created by BCL Device-18 on 7/3/24.
//

import Foundation

enum SectionType: String {
    case largeBanners = "largeBanners" // main banner with pager
    case faceIllusion = "faceIllusion" // horizontal scroll
    case realisticThumbs = "realisticThumbs" //static scroll, max 4 items visible
    case smallBanners = "smallBanners" // small banner with individual cell in section
}

struct SectionData {
    let sectionType: SectionType
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

