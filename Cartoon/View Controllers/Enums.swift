//
//  Enums.swift
//  Cartoon
//
//  Created by BCL Device-18 on 11/3/24.
//

import Foundation

enum SectionType: String {
    case largeBanners = "largeBanners"              // main banner with pager
    case faceIllusion = "faceIllusion"              // horizontal scroll
    case realisticThumbs = "realisticThumbs"        // static scroll, max 4 items visible
    case smallBanners = "smallBanners"              // small banner with individual cell in section
}

enum NumberOfItems: Int {
    case all = 0                 // show all items
    case one = 1                 // show 1 items
    case two = 2                 // show 2 items
    case four = 4                // show 4 items
}

enum Constants {
    static let cellSpacing: CGFloat = 28
    static let gruopSpacing: CGFloat = 16
    static let sectionSpacing: CGFloat = 16
}
