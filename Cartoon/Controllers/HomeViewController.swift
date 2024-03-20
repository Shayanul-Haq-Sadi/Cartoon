//
//  ViewController.swift
//  Cartoon
//
//  Created by Tawsif - BCL Device 3 on 4/3/24.
//

import UIKit

class HomeViewController: UIViewController {

    static let identifier = "HomeViewController"
    
//    private let transitionManager = TransitionManager(duration: 3.8)
//    var animator: Animator? = Animator(duration: 3)
    private var animator: Animator?
    
    var selectedCell: TrendingCollectionViewCell?
    var selectedCellImageViewSnapshot: UIView?
    
    static var cellHorizontalScrolled: ((_: Int) -> Void)? = nil
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()

        bindData()
                        
        loadCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.frame = view.bounds
    }
    
    private func setupView() {
        
    }
    
    private func loadCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: CustomCompositionalLayout.layout)
        
        collectionView.register(UINib(nibName: "MainBannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: MainBannerCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: "SmallBannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: SmallBannerCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: "TrendingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: TrendingCollectionViewCell.identifier)

        collectionView.register(UINib(nibName: "HeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: elementKind.headerKind.rawValue, withReuseIdentifier: HeaderCollectionReusableView.headerIdentifier)
        collectionView.register(UINib(nibName: "FooterWithPagerCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: elementKind.footerWithPagerKind.rawValue, withReuseIdentifier: FooterWithPagerCollectionReusableView.footerIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(pullDownToRefresh), for: .valueChanged)
    }
    
    private func bindData() {
        DataManager.shared.prepareDatasource()
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
        guard let numberOfSections = DataManager.shared.getRootDataCount() else { return 0 }
        return numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionData = DataManager.shared.getSectionData(of: section) else { return 0 }
        
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
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionData = DataManager.shared.getSectionData(of: indexPath.section) else { return UICollectionReusableView() }
        
        switch kind {
        case elementKind.headerKind.rawValue:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.headerIdentifier, for: indexPath) as! HeaderCollectionReusableView
            header.setup(head: sectionData.headerTitle, showSeeAll: sectionData.shouldShowMore)
            header.seeAlltapped = {
                print("seeAllButtonPressed")
            }
            return header
            
        case elementKind.footerWithPagerKind.rawValue:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterWithPagerCollectionReusableView.footerIdentifier, for: indexPath) as! FooterWithPagerCollectionReusableView
            footer.setup(indexPath: indexPath, dataSize: sectionData.items.count)
            
            HomeViewController.cellHorizontalScrolled = { index in
                footer.pageControl.currentPage = index
            }
            return footer
            
        default :
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionData = DataManager.shared.getSectionData(of: indexPath.section) else { return UICollectionViewCell() }
        
        switch sectionData.sectionType {
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
        guard let sectionData = DataManager.shared.getSectionData(of: indexPath.section) else { return }
        
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
        guard let secondViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: PreviewSliderViewController.identifier) as? PreviewSliderViewController else { return }

        secondViewController.transitioningDelegate = self
//        navigationController?.delegate = animator

        secondViewController.modalPresentationStyle = .fullScreen
        secondViewController.data = data
        present(secondViewController, animated: true)
//        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
}


extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let firstViewController = presenting as? HomeViewController,
            let secondViewController = presented as? PreviewSliderViewController,
            let selectedCellImageViewSnapshot = selectedCellImageViewSnapshot
            else { return nil }

        animator = Animator(type: .present, firstViewController: firstViewController, secondViewController: secondViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
        return animator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let secondViewController = dismissed as? PreviewSliderViewController,
            let selectedCellImageViewSnapshot = selectedCellImageViewSnapshot
            else { return nil }

        animator = Animator(type: .dismiss, firstViewController: self, secondViewController: secondViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
        return animator
    }
}
