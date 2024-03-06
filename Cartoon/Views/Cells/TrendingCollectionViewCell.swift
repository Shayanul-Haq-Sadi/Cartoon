//
//  TrendingCollectionViewCell.swift
//  Cartoon
//
//  Created by Tawsif - BCL Device 3 on 5/3/24.
//

import UIKit

class TrendingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var trendingImageView: UIImageView!
   
    @IBOutlet weak var bottomGradientImageView: UIImageView!
    
    @IBOutlet weak var premiumImageView: UIImageView!
    
    static let identifier = "TrendingCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        premiumImageView.layer.cornerRadius = premiumImageView.frame.width/2
    }
    
    func setup(image: String, indexPath: IndexPath, dataSize: Int) {
        trendingImageView.image = UIImage(named: image)
    }

}
