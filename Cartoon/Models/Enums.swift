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

enum elementKind: String {
    case headerKind = "headerKind"
    case footerWithPagerKind = "footerWithPagerKind"
}

enum PresentationType {
    case present
    case dismiss

    var isPresenting: Bool {
        return self == .present
    }
}

enum Constants {
    static let gruopSpacing: CGFloat = 14
    static let sectionSpacing: CGFloat = 28
    
    static let sectionTopContentInsets: CGFloat = 16
    static let sectionLeadingContentInsets: CGFloat = 16
    static let sectionTrailingContentInsets: CGFloat = 16
    
    static let footerHeaderHeight: CGFloat = 20
    
    static let largeBannersHeight: CGFloat = 326
    static let smallBannersHeight: CGFloat = 180
    static let realisticThumbsHeight: CGFloat = 230
    static let faceIllusionHeight: CGFloat = 156
    static let faceIllusionWidth: CGFloat = 124
}
