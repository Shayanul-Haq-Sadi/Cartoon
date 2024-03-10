//
//  MainBannerCollectionViewCell.swift
//  Cartoon
//
//  Created by Tawsif - BCL Device 3 on 4/3/24.
//

import UIKit

class MainBannerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var bannerImageView: UIImageView!
    
    @IBOutlet weak var bottomGradientImageView: UIImageView!
    
    @IBOutlet weak var bannerTitleLabel: UILabel!
    
    @IBOutlet weak var bannerDescriptionLabel: UILabel!
    
    @IBOutlet weak var tryNowButton: UIButton!
            
    static let identifier = "CarosselCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
//        bannerImageView.image = nil
    }
    
    func setup(image: String, title: String, description: String) {
        bannerImageView.image = UIImage(named: image)
        bannerTitleLabel.text = title
        bannerDescriptionLabel.text = description
    }

}
