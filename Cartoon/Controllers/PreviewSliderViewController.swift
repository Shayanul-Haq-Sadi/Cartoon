//
//  PreviewSliderViewController.swift
//  Cartoon
//
//  Created by BCL Device-18 on 10/3/24.
//

import UIKit

class PreviewSliderViewController: UIViewController {
    
    static let identifier = "PreviewSliderViewController"
        
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var labelStackView: UIStackView!
    
    @IBOutlet weak var imageContainerView: UIView!
    
    @IBOutlet weak var afterImageView: UIImageView!
    
    @IBOutlet weak var afterLabelView: UIView!
    
    @IBOutlet weak var sliderImageView: UIImageView!
    
    @IBOutlet weak var beforeContainerView: UIView!
    
    @IBOutlet weak var beforeImageView: UIImageView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var beforeContainerViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var beforeLabelView: UIView!
    
    var data: Item!
    
    private let panGestureRecognizer = UIPanGestureRecognizer()
    
    private var initialImageCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addPanGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        labelStackView.alpha = 0
        afterLabelView.alpha = 0
        beforeLabelView.alpha = 0
        nextButton.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.labelStackView.alpha = 1
            self.afterLabelView.alpha = 1
            self.beforeLabelView.alpha = 1
            self.nextButton.alpha = 1
        }
    }
    
    private func setupView() {
        imageContainerView.layer.cornerRadius = 12
        imageContainerView.clipsToBounds = true
        afterImageView.image = UIImage(named: data.image)
        beforeContainerView.clipsToBounds = true
        beforeImageView.image = UIImage(named: data.image)
//        beforeImageView.image = UIImage(named: "Modern Art_real")
        
        afterLabelView.layer.cornerRadius = 14
        beforeLabelView.layer.cornerRadius = 14
    }
    
    private func addPanGesture() {
        panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
        sliderImageView.addGestureRecognizer(panGestureRecognizer)
        sliderImageView.isUserInteractionEnabled = true
        initialImageCenter = sliderImageView.center
    }
    
        
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: imageContainerView)
        
        if gesture.state == .began {
            // Save the initial position of the image view
            initialImageCenter = sliderImageView.center
        } else if gesture.state == .changed {
            // Move the image view based on the pan gesture
            let newCenterX = initialImageCenter.x + translation.x
            let clampedX = max(sliderImageView.bounds.width/2, min(imageContainerView.bounds.width - sliderImageView.bounds.width/2, newCenterX))
            sliderImageView.center = CGPoint(x: clampedX, y: initialImageCenter.y)
            beforeContainerViewWidthConstraint.constant = clampedX
        } else if gesture.state == .ended {
            // Perform any additional actions when the pan gesture ends
        }
    }

    @IBAction func closeButtonPressed(_ sender: Any) {
//        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true)
    }
}
