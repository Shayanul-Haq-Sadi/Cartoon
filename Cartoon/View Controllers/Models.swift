//
//  Models.swift
//  Cartoon
//
//  Created by BCL Device-18 on 7/3/24.
//

import Foundation

enum SectionType: String {
    case largeBanners = "largeBanners"
    case faceIllusion = "faceIllusion"
    case disneyThumbs = "disneyThumbs"
    case qrIllusion = "qrIllusion"
    case realisticThumbs = "realisticThumbs"
    case smallBanners = "smallBanners"
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

