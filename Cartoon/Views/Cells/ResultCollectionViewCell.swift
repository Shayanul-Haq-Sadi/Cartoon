//
//  ResultCollectionViewCell.swift
//  Cartoon
//
//  Created by BCL Device-18 on 24/3/24.
//

import UIKit

class ResultCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var resultImageView: UIImageView!
    
    @IBOutlet weak var premiumImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var retryContainerView: UIView!
    
    static let identifier = "ResultCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        premiumImageView.layer.cornerRadius = premiumImageView.frame.width/2
        premiumImageView.isHidden = true
        resultImageView.layer.cornerRadius = 12
        resultImageView.image = nil
        
        retryContainerView.layer.borderWidth = 2
        retryContainerView.layer.cornerRadius = 12
        retryContainerView.layer.borderColor = UIColor.white.cgColor
    }
    
    func setup(image: String, title: String, isPro: Bool = false, Selected: Bool = false) {
        resultImageView.image = UIImage(named: image)
        titleLabel.text = title
        premiumImageView.isHidden = !isPro
        retryContainerView.isHidden = Selected ? false : true
    }

}
