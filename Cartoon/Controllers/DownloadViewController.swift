//
//  DownloadViewController.swift
//  Cartoon
//
//  Created by BCL Device-18 on 18/3/24.
//

import UIKit

class DownloadViewController: UIViewController {
    
    static let identifier = "DownloadViewController"

    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var resultImageView: UIImageView!
    
    @IBOutlet weak var collectionContainerView: UIView!
    
    private var collectionView: UICollectionView!
    
    var resultImage: UIImage!
    var pickedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionContainerView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.collectionContainerView.alpha = 1
        }
    }
    
    private func setupView() {
        resultImageView.layer.cornerRadius = 12
        resultImageView.image = pickedImage
        
        UIView.animate(withDuration: 10.5, delay: 5.0, options: [.curveEaseInOut], animations: {
            self.resultImageView.image = self.resultImage
        }, completion: nil)
        
        collectionContainerView.clipsToBounds = true
    }
    
    private func loadCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: CustomCompositionalLayout.downloadLayout)
        
        collectionView.register(UINib(nibName: "ResultCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ResultCollectionViewCell.identifier)
    
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.frame = collectionContainerView.bounds
        
        collectionView.isSpringLoaded = false
        collectionView.isScrollEnabled = false
        
        collectionContainerView.addSubview(collectionView)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
}


extension DownloadViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let numberOfSections = DataManager.shared.getDownloadRootDataCount() else { return 0 }
        return numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionData = DataManager.shared.getDownloadSectionData(of: section) else { return 0 }
        return sectionData.items.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionData = DataManager.shared.getDownloadSectionData(of: indexPath.section) else { return UICollectionViewCell() }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier, for: indexPath) as? ResultCollectionViewCell else { return UICollectionViewCell() }
        cell.setup(image: sectionData.items[indexPath.item].image, title: sectionData.items[indexPath.item].text, isPro: sectionData.items[indexPath.item].isPro)
        return cell
    }
}

extension DownloadViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("Tapped: Section \(indexPath.section) item \(indexPath.item)")
//    }
    
}
