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
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        imageView.layer.cornerRadius = 12
        imageView.image = image
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
