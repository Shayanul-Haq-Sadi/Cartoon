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
    }
    
    func setup(head: String, font: UIFont = .systemFont(ofSize: 14, weight: .bold), showSeeAll: Bool = false) {
        header.text = head
        header.font = font
//        showSeeAll ? (seeAllButton.isHidden = false) : (seeAllButton.isHidden = true)
        
        seeAllButton.isHidden = !showSeeAll
    }
    
}
