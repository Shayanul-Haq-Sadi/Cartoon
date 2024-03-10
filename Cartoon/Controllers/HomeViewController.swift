//
//  ViewController.swift
//  Cartoon
//
//  Created by Tawsif - BCL Device 3 on 4/3/24.
//

import UIKit

let headerKind = "headerKind"
let footerWithPagerKind = "footerWithPagerKind"

class HomeViewController: UIViewController {

    static let identifier = "HomeViewController"
    
    private var cellHorizontalScrolled: ((_: Int) -> Void)? = nil
    private var datasource: Dictionary = Dictionary<String, Any>()
    private var collectionView: UICollectionView!
    
    private func createLargeBannersSection() -> NSCollectionLayoutSection {
        print("Large Banners")
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
//                item.contentInsets.leading = 16
        item.contentInsets.trailing = 10
//                item.contentInsets.bottom = 8
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.94), heightDimension: .absolute(326)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets.leading = 16
        
        let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),heightDimension: .absolute(20))
        let footerWithPager = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize, elementKind: footerWithPagerKind, alignment: .bottomLeading)
        section.boundarySupplementaryItems = [footerWithPager]
        
        section.visibleItemsInvalidationHandler = { items, contentOffset, environment in
            let currentPage = Int(max(0, round(contentOffset.x / environment.container.contentSize.width)))
            self.cellHorizontalScrolled?(currentPage)
        }
        
        return section
    }
    
    private func createFaceIllusionSection() -> NSCollectionLayoutSection {
        print("Face Illusion")
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets.trailing = 10
//        item.contentInsets.bottom = 8
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(124), heightDimension: .absolute(156)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets.leading = 16
//        section.contentInsets.bottom = 8
        
        let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .absolute(40))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize, elementKind: headerKind, alignment: .topLeading)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createRealisticThumbsSection() -> NSCollectionLayoutSection {
        print("Realistic Thumbs")

        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
        item.contentInsets.trailing = 16
//        item.contentInsets.bottom = 8

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(230)), subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading = 16
        section.interGroupSpacing = 14
//        section.contentInsets.trailing = 16

        let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .absolute(40))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize, elementKind: headerKind, alignment: .topLeading)
        section.boundarySupplementaryItems = [header]

        return section
    }
    
    private func createSmallBannersSection() -> NSCollectionLayoutSection {
        print("Small Banners")
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(180)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.top = 8
        section.contentInsets.bottom = 8
        section.contentInsets.leading = 16
        section.contentInsets.trailing = 16
        section.interGroupSpacing = 14
        
        return section
    }
    
    func parseDictionaryToSectionData(dictionary: [String: Any]) -> SectionData? {
        guard let sectionTypeString = dictionary["sectionType"] as? String,
              let sectionType = SectionType(rawValue: sectionTypeString),
              let headerTitle = dictionary["headerTitle"] as? String,
              let shouldShowMore = dictionary["shouldShowMore"] as? Bool,
              let itemsArray = dictionary["items"] as? [[String: Any]] 
        else { return nil }

        // Parse items
        var items: [Item] = []
        for itemDict in itemsArray {
            guard let text = itemDict["text"] as? String,
                  let image = itemDict["image"] as? String,
                  let description = itemDict["description"] as? String,
                  let isPro = itemDict["isPro"] as? Bool 
            else { return nil }

            let item = Item(text: text, image: image, description: description, isPro: isPro)
            items.append(item)
        }

        let sectionData = SectionData(sectionType: sectionType, headerTitle: headerTitle, shouldShowMore: shouldShowMore, items: items)
        return sectionData
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            
            guard let rootValue = self.datasource["Home Category"] as? [[String: Any]],
               let section = self.parseDictionaryToSectionData(dictionary: rootValue[sectionIndex])
            else { return self.createLargeBannersSection() }
            let sectionType = section.sectionType 
            
            switch sectionType {
            case .largeBanners:
                return self.createLargeBannersSection()
                
            case .faceIllusion:
                return self.createFaceIllusionSection()
          
            case .realisticThumbs:
                return self.createRealisticThumbsSection()
                
            case .smallBanners:
                return self.createSmallBannersSection()
            }
        }
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()

        prepareData()
                        
        loadCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.frame = view.bounds
    }
    
    private func setupView() {
        
    }
    
    private func loadCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        
        collectionView.register(UINib(nibName: "MainBannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: MainBannerCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: "SmallBannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: SmallBannerCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: "TrendingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: TrendingCollectionViewCell.identifier)

        collectionView.register(UINib(nibName: "HeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: headerKind, withReuseIdentifier: HeaderCollectionReusableView.headerIdentifier)
        collectionView.register(UINib(nibName: "FooterWithPagerCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: footerWithPagerKind, withReuseIdentifier: FooterWithPagerCollectionReusableView.footerIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
//        collectionView.backgroundColor = .clear
 
        view.addSubview(collectionView)
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(pullDownToRefresh), for: .valueChanged)
    }
    
    private func prepareData() {
        if let plistPath = Bundle.main.path(forResource: "Datasource", ofType: "plist") {
            // Read datasource data
            if let plistData = FileManager.default.contents(atPath: plistPath) {
                do {
                    // Deserialize datasource data
                    if let datasource = try PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: Any] {
                        self.datasource = datasource
                    } else {
                        print("Failed to deserialize datasource data.")
                    }
                } catch {
                    print("Error reading datasource data: \(error)")
                }
            } else {
                print("Failed to load datasource data.")
            }
        } else {
            print("datasource file not found.")
        }
    }

    @objc private func pullDownToRefresh() {
        print("Refresh")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.collectionView.reloadData()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
}


extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let rootValue = self.datasource["Home Category"] as? [[String: Any]] 
        else { return 0 }
        
        return rootValue.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let rootValue = self.datasource["Home Category"] as? [[String: Any]],
              let section = self.parseDictionaryToSectionData(dictionary: rootValue[section])
        else { return 0 }
        
        return section.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        print("supp indexPath row, section, item", indexPath.row, indexPath.section, indexPath.item)
        guard let rootValue = self.datasource["Home Category"] as? [[String: Any]],
              let section = self.parseDictionaryToSectionData(dictionary: rootValue[indexPath.section])
        else { return UICollectionViewCell() }
            
        switch kind {
        case headerKind:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.headerIdentifier, for: indexPath) as! HeaderCollectionReusableView
            header.setup(head: section.headerTitle, showSeeAll: section.shouldShowMore)
            return header
            
        case footerWithPagerKind:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterWithPagerCollectionReusableView.footerIdentifier, for: indexPath) as! FooterWithPagerCollectionReusableView
            footer.setup(indexPath: indexPath, dataSize: section.items.count)
            
            cellHorizontalScrolled = { index in
                footer.pageControl.currentPage = index
            }
            return footer
            
        default :
            return UICollectionReusableView()
        }
    }
        
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        print("Cell indexPath row, section, item", indexPath.row, indexPath.section, indexPath.item)
        guard let rootValue = self.datasource["Home Category"] as? [[String: Any]],
              let section = self.parseDictionaryToSectionData(dictionary: rootValue[indexPath.section])
        else { return UICollectionViewCell() }
        let sectionType = section.sectionType
        
        switch sectionType {
        case .largeBanners:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainBannerCollectionViewCell.identifier, for: indexPath) as? MainBannerCollectionViewCell else { return UICollectionViewCell() }
            cell.setup(image: section.items[indexPath.item].image, title: section.items[indexPath.item].text, description: section.items[indexPath.item].description)
            return cell
            
        case .faceIllusion:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingCollectionViewCell.identifier, for: indexPath) as? TrendingCollectionViewCell else { return UICollectionViewCell() }
            cell.setup(image: section.items[indexPath.item].image, title: section.items[indexPath.item].text, isPro: section.items[indexPath.item].isPro)
            return cell

        case .realisticThumbs:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingCollectionViewCell.identifier, for: indexPath) as? TrendingCollectionViewCell else { return UICollectionViewCell() }
            cell.setup(image: section.items[indexPath.item].image, title: section.items[indexPath.item].text, isPro: section.items[indexPath.item].isPro)
            return cell
            
        case .smallBanners:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallBannerCollectionViewCell.identifier, for: indexPath) as? SmallBannerCollectionViewCell else { return UICollectionViewCell() }
            cell.setup(image: section.items[indexPath.item].image, title: section.items[indexPath.item].text, description: section.items[indexPath.item].description)
            return cell
        }
    }
}


extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vc = UIViewController()
//        
//        vc.view.backgroundColor = indexPath.section == 0 ? .yellow : indexPath.section == 1 ? .blue : .orange
//        
//        self.navigationController?.pushViewController(vc, animated: true)
        
        print("Tapped: Section \(indexPath.section) item \(indexPath.item)")
    }

}
