//
//  ViewController.swift
//  Cartoon
//
//  Created by Tawsif - BCL Device 3 on 4/3/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    enum DictionaryKeys: String {
        case outerKey1
        case outerKey2
        case innerKey1
        case innerKey2
    }
    
    enum Sctions: Int {
        case largeBanners = 0
        case faceIllusion = 1
        case disneyThumbs = 2
        case qrIllusion = 3
        case realisticThumbs = 4
        case smallBanners = 5
    }
    
//    enum
    
    // Accessing a value in the three-level dictionary
    let level1 = "level1"
    let level2 = "level2"
    let level3 = "level3"
    
    // Sample three-level dictionary
    var threeLevelDict: [String: [String: [String: Any]]] = [
        "level1": [
            "level2": [
                "level3": "finalValue"
            ]
        ]
    ]

    static let identifier = "HomeViewController"
    static let headerKind = "headerKind"
    static let footerKind = "footerKind"
    static let footerWithPagerKind = "footerWithPagerKind"
    
    private var cellHorizontalScrolled: ((_: IndexPath) -> Void)? = nil
//    private var cellWillDisplay: ((_: IndexPath) -> Void)? = nil
//    private var cellDidEndDisplaying: ((_: IndexPath) -> Void)? = nil
    
    private var cellScrollingRight: Bool = true
    private var cellScrollingLeft: Bool = true
    
    private var datasource: Dictionary = Dictionary<String, Any>()
    
    private var pageControls = UIPageControl()


    private let collectionView: UICollectionView = {

        let layout = UICollectionViewCompositionalLayout { sectionNumber, env in
            
            if sectionNumber == 0 {
                print("first carossel")
                
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
                
                return section
            }
            
            else if sectionNumber == 1 {
                
                print("second")
                
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets.trailing = 16
                item.contentInsets.bottom = 8
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(124), heightDimension: .absolute(156)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets.leading = 16
                
                let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .absolute(40))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize, elementKind: headerKind, alignment: .topLeading)
//                let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize, elementKind: footerKind, alignment: .bottomLeading)
                section.boundarySupplementaryItems = [header] //, footer
                
                return section
            }
                
            else if sectionNumber == 2 {
                
                print("third")
                
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
                item.contentInsets.trailing = 16
//                item.contentInsets.bottom = 8
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(230)), subitems: [item])
                
//                group.interItemSpacing = 16
                
                let section = NSCollectionLayoutSection(group: group)
//                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets.leading = 16
//                section.contentInsets.trailing = 16
                section.interGroupSpacing = 14
                
                let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .absolute(30))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize, elementKind: headerKind, alignment: .topLeading)
                let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize, elementKind: footerKind, alignment: .bottomLeading)
                section.boundarySupplementaryItems = [header] //, footer
                
                return section
            }
                
            else if sectionNumber == 3 {
                
                print("forth")
                
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets.trailing = 16
//                item.contentInsets.bottom = 8
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.25)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets.leading = 16
                section.interGroupSpacing = 16
                
//                let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .absolute(30))
//                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize, elementKind: headerKind, alignment: .topLeading)
//                let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize, elementKind: footerKind, alignment: .bottomLeading)
//                section.boundarySupplementaryItems = [header] //, footer
                
                return section
            }
                
            else if sectionNumber == 4 {
                
                print("fifth")
                
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets.trailing = 16
                item.contentInsets.bottom = 8
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.66), heightDimension: .absolute(140)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets.leading = 16
                
                let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .absolute(30))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize, elementKind: headerKind, alignment: .topLeading)
                let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize, elementKind: footerKind, alignment: .bottomLeading)
                section.boundarySupplementaryItems = [header] //, footer
                
                return section
            }
                
            else {
                print("sixth...")
                
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets.trailing = 16
                item.contentInsets.bottom = 8
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(120), heightDimension: .absolute(120)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets.leading = 16
                
                let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .absolute(30))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize, elementKind: headerKind, alignment: .topLeading)
                let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize, elementKind: footerKind, alignment: .bottomLeading)
                section.boundarySupplementaryItems = [header] //, footer
                
                return section
            }
        }
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(UINib(nibName: "MainBannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: MainBannerCollectionViewCell.identifier)
        collection.register(UINib(nibName: "TrendingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: TrendingCollectionViewCell.identifier)
        
        collection.register(UINib(nibName: "HeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: HomeViewController.headerKind, withReuseIdentifier: HeaderCollectionReusableView.headerIdentifier)
//        collection.register(UINib(nibName: "FooterCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: HomeViewController.footerKind, withReuseIdentifier: FooterCollectionReusableView.footerIdentifier)
        collection.register(UINib(nibName: "FooterWithPagerCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: HomeViewController.footerWithPagerKind, withReuseIdentifier: FooterWithPagerCollectionReusableView.footerIdentifier)
                                                                                       
        return collection
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()

        loadCollectionView()
        
        prepareData()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        collectionView.frame = view.bounds
    }
    
    
    private func setupView() {
        pageControls.currentPage = 0
        pageControls.backgroundColor = .systemPink
        pageControls.tintColor = .red
        
//        pageControls.currentPage = indexPath.item
        pageControls.numberOfPages = 10
        
        pageControls.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
    }
    
    
    private func loadCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .clear
 
        view.addSubview(collectionView)
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(pullDownToRefresh), for: .valueChanged)
    }
    
    private func prepareData() {
        if let path = Bundle.main.path(forResource: "Datasource", ofType: "plist"),
           let xml = FileManager.default.contents(atPath: path),
           let datasource = try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainers, format: nil) as? [String: Any] {
            print("datasource", datasource)
            self.datasource = datasource
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
//        return homeSectionsData.sections.count
//        return 4
        
        var cc = datasource["Category"]
        return cc.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return homeSectionsData.sections[section].cells.count
        var sectionData = datasource["section \(section)"]
        
        print(sectionData, "sectionData  \(section)")
        
        return 6
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        print("supp indexPath row, section, item", indexPath.row, indexPath.section, indexPath.item)
        switch kind {
            case HomeViewController.headerKind:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.headerIdentifier, for: indexPath) as! HeaderCollectionReusableView
//                header.setup(head: homeSectionsData.sections[indexPath.section].headerFooter.header, imageFlag: false)
                return header
                
//            case HomeViewController.footerKind:
//                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterCollectionReusableView.footerIdentifier, for: indexPath) as! FooterCollectionReusableView
//                footer.setup(foot: homeSectionsData.sections[indexPath.section].headerFooter.footer, indicatorFlag: false)
//                return footer
            
            case HomeViewController.footerWithPagerKind:
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterWithPagerCollectionReusableView.footerIdentifier, for: indexPath) as! FooterWithPagerCollectionReusableView
//                footer.setup(indexPath: indexPath, dataSize: homeSectionsData.sections[indexPath.section].cells.count)
                footer.setup(indexPath: indexPath, dataSize: 7)
            
                cellHorizontalScrolled = { index in
//                    print(index)
                    footer.pageControl.currentPage = index.item
                }
                return footer
                
            default :
                return UICollectionReusableView()
        }
    }
        
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        print("Cell indexPath row, section, item", indexPath.row, indexPath.section, indexPath.item)
                
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainBannerCollectionViewCell.identifier, for: indexPath) as! MainBannerCollectionViewCell
//            cell.setup(image: homeSectionsData.sections[indexPath.section].cells[indexPath.item].image ?? "image", indexPath: indexPath, dataSize: homeSectionsData.sections[indexPath.section].cells.count)
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingCollectionViewCell.identifier, for: indexPath) as! TrendingCollectionViewCell
            
            return cell
        }
        
//        else {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TVCollectionViewCell.identifier, for: indexPath) as! TVCollectionViewCell
//            cell.setup(image: homeSectionsData.sections[indexPath.section].cells[indexPath.item].image ?? "image")
//            return cell
//        }
    }
    
}


extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vc = UIViewController()
//        
//        vc.view.backgroundColor = indexPath.section == 0 ? .yellow : indexPath.section == 1 ? .blue : .orange
//        
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cellHorizontalScrolled?(indexPath)
//        cellWillDisplay?(indexPath)

        
//        collectionView.cellForItem(at: <#T##IndexPath#>)
//        let ite = collectionView.indexPathsForVisibleItems
//        print("indexPathsForVisibleItems  ", ite)
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
////        cellDidEndDisplaying?(indexPath)
//
//    }

}
