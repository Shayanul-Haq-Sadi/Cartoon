//
//  HeaderCollectionReusableView.swift
//  Cartoon
//
//  Created by Tawsif - BCL Device 3 on 4/3/24.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var header: UILabel!
    
    @IBOutlet weak var seeAllButton: UIButton!
    
    @IBOutlet weak var headerBackgroundView: UIView!
    
    static let headerIdentifier = "HeaderCollectionReusableView"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    private func setupView() {
        seeAllButton.isHidden = true
    }
    
    func setup(head: String, showSeeAll: Bool = false) {
        header.text = head        
        seeAllButton.isHidden = !showSeeAll
    }
    
}
