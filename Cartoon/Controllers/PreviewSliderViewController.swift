//
//  PreviewSliderViewController.swift
//  Cartoon
//
//  Created by BCL Device-18 on 10/3/24.
//

import UIKit

class PreviewSliderViewController: UIViewController {
    
    static let identifier = "PreviewSliderViewController"
    
//    private let transitionManager = TransitionManager(duration: 3.8)
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet var labelStackView: UIStackView!
    
    @IBOutlet weak var imageContainerView: UIView!
    
    @IBOutlet var imageView: UIImageView!
    
//    public var headerView: AlbumDetailHeaderView?
    
    var data: Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        
        closeButton.tintColor = .label
        
        imageContainerView.layer.cornerRadius = 12
        imageContainerView.clipsToBounds = true
        imageView.image = UIImage(named: data.image)
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        UIView.animate(withDuration: 0.6) {
//            self.imageView.alpha = 1
//        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        imageView.alpha = 0
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
//        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true)
    }

}
