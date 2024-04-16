//
//  CustomCompositionalLayout.swift
//  Cartoon
//
//  Created by BCL Device-18 on 12/3/24.
//

import UIKit

class CustomCompositionalLayout: UICollectionViewLayout {
    
    static let homeLayout = CustomCompositionalLayout().createHomeLayout()
    
    static let downloadLayout = CustomCompositionalLayout().createDownloadLayout()

    private func createHomeLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = Constants.sectionSpacing //28
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, environment) -> NSCollectionLayoutSection?  in
            guard let sectionData = DataManager.shared.getHomeSectionData(of: sectionIndex) else { return self.createLargeBannersSection() }
            
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
    
    private func createDownloadLayout() -> UICollectionViewCompositionalLayout {        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, environment) -> NSCollectionLayoutSection?  in
            return self.createResultSection()
        })
        
        return layout
    }
    
    private func createLargeBannersSection() -> NSCollectionLayoutSection {
        print("Large Banners")
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets.trailing = 10
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.94), heightDimension: .absolute(Constants.largeBannersHeight)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets.leading = Constants.sectionLeadingContentInsets
        
        let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),heightDimension: .absolute(Constants.footerHeaderHeight))
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
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(Constants.faceIllusionWidth), heightDimension: .absolute(Constants.faceIllusionHeight)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets.leading = Constants.sectionLeadingContentInsets
        section.contentInsets.top = Constants.sectionTopContentInsets
        
        let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .absolute(Constants.footerHeaderHeight))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize, elementKind: elementKind.headerKind.rawValue, alignment: .topLeading)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createRealisticThumbsSection() -> NSCollectionLayoutSection {
        print("Realistic Thumbs")

        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
        item.contentInsets.trailing = 16

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(Constants.realisticThumbsHeight)), subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading = Constants.sectionLeadingContentInsets
        section.contentInsets.top = Constants.sectionTopContentInsets
        section.interGroupSpacing = Constants.gruopSpacing

        let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .absolute(Constants.footerHeaderHeight))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize, elementKind: elementKind.headerKind.rawValue, alignment: .topLeading)
        section.boundarySupplementaryItems = [header]

        return section
    }
    
    private func createSmallBannersSection() -> NSCollectionLayoutSection {
        print("Small Banners")
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(Constants.smallBannersHeight)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading = Constants.sectionLeadingContentInsets
        section.contentInsets.trailing = Constants.sectionTrailingContentInsets
//        section.interGroupSpacing = Constants.gruopSpacing
        
        return section
    }
    
    private func createResultSection() -> NSCollectionLayoutSection {
        print("Result")
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(72), heightDimension: .absolute(141)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = Constants.gruopSpacing
        section.contentInsets.leading = Constants.sectionLeadingContentInsets
        section.contentInsets.top = Constants.sectionTopContentInsets
        
        return section
    }

}
