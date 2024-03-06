//
//  FooterWithPagerCollectionReusableView.swift
//  Cartoon
//
//  Created by Tawsif - BCL Device 3 on 4/3/24.
//

import UIKit

class FooterWithPagerCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var pageControl: UIPageControl!
    static let footerIdentifier = "footerWithPager"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupView()
    }

    private func setupView() {
        pageControl.currentPage = 0
    }
    
    func setup(indexPath: IndexPath, dataSize: Int) {
        pageControl.currentPage = indexPath.item
        pageControl.numberOfPages = dataSize
    }
    
}
