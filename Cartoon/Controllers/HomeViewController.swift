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
    
//    private let transitionManager = TransitionManager(duration: 3.8)
    var animator: Animator?
//    var animator: Animator? = Animator(duration: 3)
    
    var selectedCell: TrendingCollectionViewCell?
    var selectedCellImageViewSnapshot: UIView?
    
    private var cellHorizontalScrolled: ((_: Int) -> Void)? = nil
    private var datasource: Dictionary = Dictionary<String, Any>()
    private var collectionView: UICollectionView!
    
    private func createLargeBannersSection() -> NSCollectionLayoutSection {
        print("Large Banners")
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets.trailing = 10
        
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
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(124), heightDimension: .absolute(156)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets.leading = 16
        section.contentInsets.top = 16
        
        let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .absolute(20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize, elementKind: headerKind, alignment: .topLeading)
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
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize, elementKind: headerKind, alignment: .topLeading)
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
    
    private func getRootDataCount() -> Int? {
        guard let rootValue = self.datasource["Home Category"] as? [[String: Any]] else { return nil }
        return rootValue.count
    }
    
    private func getSectionData(of section: Int) -> SectionData? {
        guard let rootValue = self.datasource["Home Category"] as? [[String: Any]],
              let sectionData = self.parseDictionaryToSectionData(dictionary: rootValue[section])
        else { return nil }
        return sectionData
    }
    
    private func parseDictionaryToSectionData(dictionary: [String: Any]) -> SectionData? {
        guard let sectionTypeString = dictionary["sectionType"] as? String,
              let sectionType = SectionType(rawValue: sectionTypeString),
              let numberOfItemsInt = dictionary["numberOfItems"] as? Int,
              let numberOfItems = NumberOfItems(rawValue: numberOfItemsInt),
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

        let sectionData = SectionData(sectionType: sectionType, numberOfItems: numberOfItems, headerTitle: headerTitle, shouldShowMore: shouldShowMore, items: items)
        return sectionData
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = Constants.cellSpacing //28
        
//        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, environment) -> NSCollectionLayoutSection?  in
            
//            guard let rootValue = self.datasource["Home Category"] as? [[String: Any]],
//               let section = self.parseDictionaryToSectionData(dictionary: rootValue[sectionIndex])
//            else { return self.createLargeBannersSection() }
//            let sectionType = sectionData.sectionType
            
            guard let sectionData = self.getSectionData(of: sectionIndex) else { return self.createLargeBannersSection() }
            
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
//        guard let rootValue = self.datasource["Home Category"] as? [[String: Any]] 
//        else { return 0 }
//        return rootValue.count
        
        guard let numberOfSections = getRootDataCount() else { return 0 }
        
        return numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        guard let rootValue = self.datasource["Home Category"] as? [[String: Any]],
//              let section = self.parseDictionaryToSectionData(dictionary: rootValue[section])
//        else { return 0 }
//        let sectionType = section.sectionType
//        let numberOfItems = sectionData.numberOfItems
        
        guard let sectionData = getSectionData(of: section) else { return 0 }
        
        switch sectionData.numberOfItems {
        case .all:
            return sectionData.items.count
        case .one:
            return (sectionData.items.count >= 1) ? 1 : sectionData.items.count
        case .two:
            return (sectionData.items.count >= 2) ? 2 : sectionData.items.count
        case .four:
            return (sectionData.items.count >= 4) ? 4 : sectionData.items.count
        }
    
//        if sectionType == .realisticThumbs {
//            return (section.items.count > 4) ? 4 : section.items.count
//        } else {
//            return section.items.count
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        print("supp indexPath row, section, item", indexPath.row, indexPath.section, indexPath.item)
//        guard let rootValue = self.datasource["Home Category"] as? [[String: Any]],
//              let section = self.parseDictionaryToSectionData(dictionary: rootValue[indexPath.section])
//        else { return UICollectionViewCell() }
        
        guard let sectionData = getSectionData(of: indexPath.section) else { return UICollectionReusableView() }
        
        switch kind {
        case headerKind:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.headerIdentifier, for: indexPath) as! HeaderCollectionReusableView
            header.setup(head: sectionData.headerTitle, showSeeAll: sectionData.shouldShowMore)
            return header
            
        case footerWithPagerKind:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterWithPagerCollectionReusableView.footerIdentifier, for: indexPath) as! FooterWithPagerCollectionReusableView
            footer.setup(indexPath: indexPath, dataSize: sectionData.items.count)
            
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
//        guard let rootValue = self.datasource["Home Category"] as? [[String: Any]],
//              let section = self.parseDictionaryToSectionData(dictionary: rootValue[indexPath.section])
//        else { return UICollectionViewCell() }
        
        guard let sectionData = getSectionData(of: indexPath.section) else { return UICollectionViewCell() }
        
        let sectionType = sectionData.sectionType
        
        switch sectionType {
        case .largeBanners:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainBannerCollectionViewCell.identifier, for: indexPath) as? MainBannerCollectionViewCell else { return UICollectionViewCell() }
            cell.setup(image: sectionData.items[indexPath.item].image, title: sectionData.items[indexPath.item].text, description: sectionData.items[indexPath.item].description)
            return cell
            
        case .faceIllusion:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingCollectionViewCell.identifier, for: indexPath) as? TrendingCollectionViewCell else { return UICollectionViewCell() }
            cell.setup(image: sectionData.items[indexPath.item].image, title: sectionData.items[indexPath.item].text, isPro: sectionData.items[indexPath.item].isPro)
            return cell

        case .realisticThumbs:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingCollectionViewCell.identifier, for: indexPath) as? TrendingCollectionViewCell else { return UICollectionViewCell() }
            cell.setup(image: sectionData.items[indexPath.item].image, title: sectionData.items[indexPath.item].text, isPro: sectionData.items[indexPath.item].isPro)
            return cell
            
        case .smallBanners:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallBannerCollectionViewCell.identifier, for: indexPath) as? SmallBannerCollectionViewCell else { return UICollectionViewCell() }
            cell.setup(image: sectionData.items[indexPath.item].image, title: sectionData.items[indexPath.item].text, description: sectionData.items[indexPath.item].description)
            return cell
        }
    }
}


extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Tapped: Section \(indexPath.section) item \(indexPath.item)")
//        guard let rootValue = self.datasource["Home Category"] as? [[String: Any]],
//              let section = self.parseDictionaryToSectionData(dictionary: rootValue[indexPath.section])
//        else { return }
//        let sectionType = sectionData.sectionType
        
        guard let sectionData = getSectionData(of: indexPath.section) else { return }
        
        switch sectionData.sectionType {
        case .largeBanners:
            return
            
        case .faceIllusion:
            return
            
        case .realisticThumbs:
            let cell = collectionView.cellForItem(at: indexPath) as? TrendingCollectionViewCell
            selectedCell = cell
            selectedCellImageViewSnapshot = selectedCell?.trendingImageView.snapshotView(afterScreenUpdates: true)

            
//            guard let vc = storyboard?.instantiateViewController(withIdentifier: PreviewSliderViewController.identifier) as? PreviewSliderViewController else { return }
////            navigationController?.delegate = transitionManager
//            self.navigationController?.pushViewController(vc, animated: true)
            
            let item = sectionData.items[indexPath.item]
            presentSecondViewController(with: item)
            
        case .smallBanners:
            return
        }
    }
    
    func presentSecondViewController(with data: Item) {
        let secondViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: PreviewSliderViewController.identifier) as! PreviewSliderViewController

        // 4
        secondViewController.transitioningDelegate = self
        
//        navigationController?.delegate = animator
        
        

        secondViewController.modalPresentationStyle = .fullScreen
        secondViewController.data = data
        present(secondViewController, animated: true)
//        self.navigationController?.pushViewController(secondViewController, animated: true)
    }

}



extension HomeViewController: UIViewControllerTransitioningDelegate {

    // 2
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // 16
        guard let firstViewController = presenting as? HomeViewController,
            let secondViewController = presented as? PreviewSliderViewController,
            let selectedCellImageViewSnapshot = selectedCellImageViewSnapshot
            else { return nil }

        animator = Animator(type: .present, firstViewController: firstViewController, secondViewController: secondViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
        return animator
    }

    // 3
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // 17
        guard let secondViewController = dismissed as? PreviewSliderViewController,
            let selectedCellImageViewSnapshot = selectedCellImageViewSnapshot
            else { return nil }

        animator = Animator(type: .dismiss, firstViewController: self, secondViewController: secondViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
        return animator
    }
}










//
//final class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning {
//    
//    private let duration: TimeInterval
//    private var operation = UINavigationController.Operation.push
//    
//    init(duration: TimeInterval) {
//        self.duration = duration
//    }
//    
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return duration
//    }
//    
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        guard
//            let fromViewController = transitionContext.viewController(forKey: .from),
//            let toViewController = transitionContext.viewController(forKey: .to)
//        else {
//            transitionContext.completeTransition(false)
//            return
//        }
//        
//        animateTransition(from: fromViewController, to: toViewController, with: transitionContext)
//    }
//}
//
//// MARK: - UINavigationControllerDelegate
//
//extension TransitionManager: UINavigationControllerDelegate {
//    func navigationController(
//        _ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation,
//        from fromVC: UIViewController,
//        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        
//        self.operation = operation
//        
//        if operation == .push {
//            return self
//        }
//        
//        return nil
//    }
//}
//
//
//// MARK: - Animations
//
//private extension TransitionManager {
//    func animateTransition(from fromViewController: UIViewController, to toViewController: UIViewController, with context: UIViewControllerContextTransitioning) {
//        switch operation {
//        case .push:
////            guard
////                let albumsViewController = fromViewController as? AlbumsViewController,
////                let detailsViewController = toViewController as? AlbumDetailViewController
////            else { return }
//            
////            presentViewController(detailsViewController, from: albumsViewController, with: context)
//            presentViewController(toViewController as! PreviewSliderViewController, from: fromViewController as! HomeViewController, with: context)
//            
//        case .pop:
////            guard
////                let detailsViewController = fromViewController as? AlbumDetailViewController,
////                let albumsViewController = toViewController as? AlbumsViewController
////            else { return }
//            
////            dismissViewController(detailsViewController, to: albumsViewController)
//            dismissViewController(fromViewController, to: toViewController)
//            
//        default:
//            break
//        }
//    }
//    
////    func presentViewController(_ toViewController: AlbumDetailViewController, from fromViewController: AlbumsViewController, with context: UIViewControllerContextTransitioning) {
////    func presentViewController(_ toViewController: UIViewController, from fromViewController: UIViewController, with context: UIViewControllerContextTransitioning) {
//    func presentViewController(_ toViewController: PreviewSliderViewController, from fromViewController: HomeViewController, with context: UIViewControllerContextTransitioning) {
//        
//        guard
//            let albumCell = fromViewController.currentCell,
//            let albumCoverImageView = fromViewController.currentCell?.trendingImageView,
//            let albumDetailHeaderView = toViewController.imageView
//        else { return}
//        
//        toViewController.view.layoutIfNeeded()
//                
//        let containerView = context.containerView
//        
//        let snapshotContentView = UIView()
//////        snapshotContentView.backgroundColor = .albumBackgroundColor
//        snapshotContentView.backgroundColor = .systemBackground
//        snapshotContentView.frame = containerView.convert(albumCell.contentView.frame, from: albumCell)
//        snapshotContentView.layer.cornerRadius = albumCell.contentView.layer.cornerRadius
//        
//        let snapshotAlbumCoverImageView = UIImageView()
//        snapshotAlbumCoverImageView.clipsToBounds = true
//        snapshotAlbumCoverImageView.contentMode = albumCoverImageView.contentMode
//        snapshotAlbumCoverImageView.image = albumCoverImageView.image
//        snapshotAlbumCoverImageView.layer.cornerRadius = albumCoverImageView.layer.cornerRadius
//        snapshotAlbumCoverImageView.frame = containerView.convert(albumCoverImageView.frame, from: albumCell)
//        
//        containerView.addSubview(toViewController.view)
//        containerView.addSubview(snapshotContentView)
//        containerView.addSubview(snapshotAlbumCoverImageView)
//        
//        
//        toViewController.view.isHidden = true
//        
//        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
////        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut) {
//            snapshotContentView.frame = containerView.convert(toViewController.view.frame, from: toViewController.view)
////            snapshotAlbumCoverImageView.frame = containerView.convert(albumDetailHeaderView.albumCoverImageView.frame, from: albumDetailHeaderView)
//            snapshotAlbumCoverImageView.frame = containerView.convert( toViewController.imageView.frame, from: albumDetailHeaderView)
////            snapshotAlbumCoverImageView.layer.cornerRadius = 0
//        }
//
//        animator.addCompletion { position in
//            toViewController.view.isHidden = false
//            snapshotAlbumCoverImageView.removeFromSuperview()
//            snapshotContentView.removeFromSuperview()
//            context.completeTransition(position == .end)
//        }
//
//        animator.startAnimation()
//    }
//    
////    func dismissViewController(_ fromViewController: AlbumDetailViewController, to toViewController: AlbumsViewController) {
//    func dismissViewController(_ fromViewController: UIViewController, to toViewController: UIViewController) {
//        
//    }
//}
