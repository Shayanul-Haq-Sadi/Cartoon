//
//  CustomCompositionalLayout.swift
//  Cartoon
//
//  Created by BCL Device-18 on 12/3/24.
//

import UIKit

class CustomCompositionalLayout: NSObject {
    
    static let layout = CustomCompositionalLayout().createLayout()

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = Constants.cellSpacing //28
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, environment) -> NSCollectionLayoutSection?  in
            guard let sectionData = DataManager.shared.getSectionData(of: sectionIndex) else { return self.createLargeBannersSection() }
            
            switch sectionData.sectionType {
            case .largeBanners:
                return self.createLargeBannersSection()
                
            case .faceIllusion:
                return self.createFaceIllusionSection()
          
            case .realisticThumbs:
                return self.createRealisticThumbsSection()
                
            case .smallBanners:
                return self.createSmallBannersSection()
            }
        }, configuration: configuration)
        
        return layout
    }
    
    private func createLargeBannersSection() -> NSCollectionLayoutSection {
        print("Large Banners")
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets.trailing = 10
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.94), heightDimension: .absolute(326)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets.leading = 16
        
        let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),heightDimension: .absolute(20))
        let footerWithPager = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize, elementKind: elementKind.footerWithPagerKind.rawValue, alignment: .bottomLeading)
        section.boundarySupplementaryItems = [footerWithPager]
        
        section.visibleItemsInvalidationHandler = { items, contentOffset, environment in
            let currentPage = Int(max(0, round(contentOffset.x / environment.container.contentSize.width)))
            HomeViewController.cellHorizontalScrolled?(currentPage)
        }
        
        return section
    }
    
    private func createFaceIllusionSection() -> NSCollectionLayoutSection {
        print("Face Illusion")
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets.trailing = 10
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(124), heightDimension: .absolute(156)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets.leading = 16
        section.contentInsets.top = 16
        
        let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .absolute(20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize, elementKind: elementKind.headerKind.rawValue, alignment: .topLeading)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createRealisticThumbsSection() -> NSCollectionLayoutSection {
        print("Realistic Thumbs")

        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
        item.contentInsets.trailing = 16

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(230)), subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading = 16
        section.interGroupSpacing = 14
        section.contentInsets.top = 16

        let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .absolute(20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize, elementKind: elementKind.headerKind.rawValue, alignment: .topLeading)
        section.boundarySupplementaryItems = [header]

        return section
    }
    
    private func createSmallBannersSection() -> NSCollectionLayoutSection {
        print("Small Banners")
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(180)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading = 16
        section.contentInsets.trailing = 16
//        section.interGroupSpacing = 14
        
        return section
    }

}
