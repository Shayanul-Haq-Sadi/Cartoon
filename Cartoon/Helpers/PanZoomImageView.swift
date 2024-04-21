//
//  PanZoomImageView.swift
//  Cartoon
//
//  Created by BCL Device-18 on 17/4/24.
//

import UIKit

class PanZoomImageView: UIScrollView {
    
//    @IBInspectable
    public var image: UIImage! {
        didSet {
//            guard let image else { return }
            imageView.image = image
            imageView.contentMode = .center
            imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height)
            self.contentSize = image.size
            
            calculate()
            
        }
    }
      
    private let imageView = UIImageView()
    
//    private var image: UIImage!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    convenience init(image: UIImage) {
        self.init(frame: .zero)
        self.image = image
    }
    
    var minScale: CGFloat!
    
    private func calculate() {
        let scrollviewFrame = self.frame
        let scaleWidth = scrollviewFrame.size.width / self.contentSize.width
        let scaleHeight = scrollviewFrame.size.height / self.contentSize.height
        minScale = min(scaleHeight, scaleWidth)
        
        print("scaleWidth ", scaleWidth, " scaleHeight ", scaleHeight, " minScale ", minScale)
        
        minimumZoomScale = minScale
        maximumZoomScale = 3
        zoomScale = minScale
        bouncesZoom = true
                
    }
    
    
    func centerScrollViewContents() {
        let boundSize = self.bounds.size
        var contentsFrame = self.imageView.frame
        
        if contentsFrame.size.width < boundSize.width {
            contentsFrame.origin.x = (boundSize.width - contentsFrame.size.width) / 2
        } else {
            contentsFrame.origin.x = 0
        }
        
        if contentsFrame.size.height < boundSize.height {
            contentsFrame.origin.y = (boundSize.height - contentsFrame.size.height) / 2
        } else {
            contentsFrame.origin.y = 0
        }
        
        imageView.frame = contentsFrame
    }

    private func setupUI() {
        
        // Setup image view
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemPink
        self.clipsToBounds = true
        self.backgroundColor = .white
        addSubview(imageView)
        
        
        
//        let imageViewConstraints = [
////            imageView.widthAnchor.constraint(equalToConstant: image.size.width),
////            imageView.heightAnchor.constraint(equalToConstant: image.size.height),
//            imageView.widthAnchor.constraint(equalTo: widthAnchor),
//            imageView.heightAnchor.constraint(equalTo: heightAnchor),
////            imageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
////            imageView.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor),
////            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
////            imageView.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor),
//            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ]
//
//        NSLayoutConstraint.activate(imageViewConstraints)
        
        
        
        
//        let imageViewConstraints = [
//            imageView.widthAnchor.constraint(equalTo: widthAnchor),
//            imageView.heightAnchor.constraint(equalTo: heightAnchor),
////            imageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
////            imageView.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor),
////            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
////            imageView.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor),
//            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ]
//        
//        
//        NSLayoutConstraint.activate(imageViewConstraints)
        
//        NSLayoutConstraint.activate([
//            imageView.widthAnchor.constraint(equalToConstant: image.size.width),
//            imageView.heightAnchor.constraint(equalToConstant: image.size.height),
////            imageView.widthAnchor.constraint(equalTo: widthAnchor),
////            imageView.heightAnchor.constraint(equalTo: heightAnchor),
////            imageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 0),
////            imageView.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: 0),
////            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 0),
////            imageView.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: 0),
//            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ])

        // Setup scroll view
        minimumZoomScale = 1
        maximumZoomScale = 3
        bouncesZoom = true
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        delegate = self
        
        // Setup tap gesture
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTapRecognizer)
    }
    
    @objc private func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        if zoomScale == minScale {
            setZoomScale(2, animated: true)
        } else {
            setZoomScale(minScale, animated: true)
        }
    }
    

}

extension PanZoomImageView: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        centerScrollViewContents()
    }

}
