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
    
    @IBOutlet weak var resultContainerView: UIView!
    
    @IBOutlet weak var resultImageView: UIImageView!
    
    @IBOutlet weak var resultImageViewAspectRatioConstraint: NSLayoutConstraint!
    private var previousAspectRatio: NSLayoutConstraint!
    
    @IBOutlet weak var collectionContainerView: UIView!
    
    private var collectionView: UICollectionView!
    
    var resultImage: UIImage! = UIImage(named: "Christmas_cartoon")
//    var resultImage: UIImage! = UIImage(named: "85. Oil Painting")
    var pickedImage: UIImage! = UIImage(named: "Golden Statue_cartoon")
    
    var maxScale = 4.0
    var minScale = 1.0
//    var minScale = 0.9
    
    var currentTransform: CGAffineTransform!
    var pinchStartImageCenter: CGPoint!
    var pichCenter: CGPoint!
    
    var frameActual: CGRect!
    
    
    var initialCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addGestures()
        loadCollectionView()
    }
    
    private func addGestures() {
        resultImageView.isUserInteractionEnabled = true
        
        // Before after image
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressImage(_:)))
        longPressGesture.delegate = self
        resultImageView.addGestureRecognizer(longPressGesture)
        
        // Rotation image
//        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(rotatedImage(_:)))
//        resultImageView.addGestureRecognizer(rotate)
        
        // Zoom image
//        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchActionZoomImage))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchRecognized(pinch:)))
        pinchGesture.delegate = self
        resultImageView.addGestureRecognizer(pinchGesture)
        
        // Move image
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panActionmoveImage(gesture:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panRecognized(pan:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        resultImageView.addGestureRecognizer(panGesture)
        
        // Zoom image
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(tap:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        resultImageView.addGestureRecognizer(doubleTapRecognizer)
    
    }
    
    // Before after image
    @objc func longPressImage(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
            case .began:
                UIView.transition(with: self.resultImageView, duration: 0.5, options: .transitionCrossDissolve,  animations: {
                    self.resultImageView.image = self.pickedImage
                })
            
            case .ended:
                UIView.transition(with: self.resultImageView, duration: 0.5, options: .transitionCrossDissolve,  animations: {
                    self.resultImageView.image = self.resultImage
                })
            
            default: break
        }
    }
    
    // Rotation image
    @objc func rotatedImage(_ sender: UIRotationGestureRecognizer) {
        guard let view = sender.view else { return }
        switch sender.state {
            case .changed:
                view.transform = view.transform.rotated(by: sender.rotation)
                sender.rotation = 0
            default: break
        }
    }
    
    // Image zoom in and zoom out
    @objc func pinchActionZoomImage(gesture: UIPinchGestureRecognizer) {
        
        if gesture.state == UIGestureRecognizer.State.began { // Begin pinch
            // Store current transfrom of UIImageView
            self.currentTransform = resultImageView.transform
            
            // Store initial loaction of pinch action
            self.pinchStartImageCenter = resultImageView.center
            
            let touchPoint1 = gesture.location(ofTouch: 0, in: resultImageView)
            let touchPoint2 = gesture.location(ofTouch: 1, in: resultImageView)
            
            // Get mid point of two touch
            self.pichCenter = CGPoint(x: (touchPoint1.x + touchPoint2.x) / 2, y: (touchPoint1.y + touchPoint2.y) / 2)
//            lastScale = gesture.scale
            
        } else if gesture.state == UIGestureRecognizer.State.changed { // Pinching in operating
            // Store scale
            
            let pinchCenter = CGPoint(x: gesture.location(in: resultImageView).x - resultImageView.bounds.midX,
                                      y: gesture.location(in: resultImageView).y - resultImageView.bounds.midY)
            let transform = resultImageView.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                .scaledBy(x: gesture.scale, y: gesture.scale)
                .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
            resultImageView.transform = transform
            gesture.scale = 1
            
        }
        if gesture.state == UIGestureRecognizer.State.ended { // End pinch
            // Get current scale
            var tmpScale: CGFloat = 1.0
            var scaleUpdated = false
            
            let currentScale = sqrt(abs(resultImageView.transform.a * resultImageView.transform.d - resultImageView.transform.b * resultImageView.transform.c))
            if currentScale <= self.minScale { // Under lower scale limit
                tmpScale = self.minScale
                scaleUpdated = true
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {() -> Void in
                    
                    self.resultImageView.center = CGPoint(x: self.resultContainerView.frame.size.width / 2, y: self.resultContainerView.frame.size.height / 2)
                    self.resultImageView.transform = CGAffineTransform(scaleX: self.minScale, y: self.minScale)
                    self.resultImageView.frame = self.frameActual
                    
                    
                }, completion: {(finished: Bool) -> Void in
                })
            } else if self.maxScale <= currentScale { // Upper higher scale limit
                tmpScale = self.maxScale
                scaleUpdated = true
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {() -> Void in
                    
                    
                }, completion: {(finished: Bool) -> Void in
                })
            }
        }
    }
    
    @objc func panActionmoveImage(gesture: UIPanGestureRecognizer) {
        
        if resultContainerView.frame.width < resultImageView.frame.width || resultContainerView.frame.height < resultImageView.frame.height {
            
            // Store current transfrom of UIImageView
            let transform = resultImageView.transform
                        
            // Initialize resultImageView.transform
            resultImageView.transform = CGAffineTransform.identity
            
            // Move UIImageView
            let point: CGPoint = gesture.translation(in: resultImageView)
            
            let xPoint = resultImageView.center.x + point.x
            let yPoint = resultImageView.center.y + point.y
            
//            resultImageView.frame.origin.x + point.x
            
            let movedPoint = CGPoint(x: xPoint, y: yPoint)
            resultImageView.center = movedPoint
            
            // Revert resultImageView.transform
            resultImageView.transform = transform
            
            // Reset translation
            gesture.setTranslation(CGPoint.zero, in: resultImageView)

        }
    }
    
    
    
    
    @objc func panRecognized(pan: UIPanGestureRecognizer){
        
        // unwrap the view from the gesture
        // AND
        // unwrap that view's superView
        guard let piece = pan.view,
              let superV = piece.superview
        else { return }
        
        self.initialCenter = piece.center
        
        if resultContainerView.frame.width < resultImageView.frame.width || resultContainerView.frame.height < resultImageView.frame.height {
            
            
            let translation = pan.translation(in: superV)
            
            
            if pan.state == .began {
//                self.initialCenter = piece.center
                
            }
            
            //        if pan.state == .changed {
            if pan.state != .cancelled {
                
                // Store current transfrom of UIImageView
                let transform = piece.transform
                
                // what the new centerX and centerY will be
                var newX: CGFloat = piece.center.x + translation.x
                var newY: CGFloat = piece.center.y + translation.y
                
                // MAX centerX is 1/2 the width of the piece's frame
                let mxX = piece.frame.width * 0.5
                
                // MIN centerX is Width of superView minus 1/2 the width of the piece's frame
                let mnX = superV.bounds.width - piece.frame.width * 0.5
                
                // make sure new centerX is neither greater than MAX nor less than MIN
                newX = max(min(newX, mxX), mnX)
                
                // MAX centerY is 1/2 the height of the piece's frame
                let mxY = piece.frame.height * 0.5
                
                // MIN centerY is Height of superView minus 1/2 the height of the piece's frame
                let mnY = superV.bounds.height - piece.frame.height * 0.5
                
                // make sure new centerY is neither greater than MAX nor less than MIN
                newY = max(min(newY, mxY), mnY)
                
                // set the new center
                piece.center = CGPoint(x: newX, y: newY)
                
                // reset recognizer
                pan.setTranslation(.zero, in: superV)
                
                // Revert resultImageView.transform
                piece.transform = transform
                
//                enforceBounds()
            }
        }
        else {
            piece.center = initialCenter
//            enforceBounds()
        }
        
//        if pan.state == .ended {
//            piece.center = initialCenter
//        }
    }
    
    private func enforceBounds() {
        let imageViewFrame = resultImageView.frame
        let containerViewBounds = resultContainerView.bounds
        
        var newFrame = imageViewFrame
        
        if imageViewFrame.origin.x > containerViewBounds.maxX - imageViewFrame.width {
            newFrame.origin.x = containerViewBounds.maxX - imageViewFrame.width
        }
        if imageViewFrame.origin.x < containerViewBounds.minX {
            newFrame.origin.x = containerViewBounds.minX
        }
        if imageViewFrame.origin.y > containerViewBounds.maxY - imageViewFrame.height {
            newFrame.origin.y = containerViewBounds.maxY - imageViewFrame.height
        }
        if imageViewFrame.origin.y < containerViewBounds.minY {
            newFrame.origin.y = containerViewBounds.minY
        }
        
        resultImageView.frame = newFrame
    }
    
    
    @objc func pinchRecognized(pinch: UIPinchGestureRecognizer) {

        // unwrap the view from the gesture
        // AND
        // unwrap that view's superView
        guard let piece = pinch.view,
              let superV = piece.superview
        else { return }
        
        // check if zoomed alredy or not then move pinch accordingly
        
        if pinch.state == .began { // Begin pinch
            
            // Store current transfrom of UIImageView
//            self.currentTransform = piece.transform
            
//            lastScale = pinch.scale
            
            
            
            let touchPoint1 = pinch.location(ofTouch: 0, in: piece)
            let touchPoint2 = pinch.location(ofTouch: 1, in: piece)
            
            self.pichCenter = CGPoint(x: (touchPoint1.x + touchPoint2.x) / 2, y: (touchPoint1.y + touchPoint2.y) / 2)
            
        }
        if pinch.state == .changed { // Pinching in operating
            
//            let pinchCenter = CGPoint(x: pinch.location(in: piece).x - piece.bounds.midX, y: pinch.location(in: piece).y - piece.bounds.midY)
            
            let transform = piece.transform
//                .translatedBy(x: pichCenter.x, y: pichCenter.y)
                .scaledBy(x: pinch.scale, y: pinch.scale)
//                .translatedBy(x: -pichCenter.x, y: -pichCenter.y)
            piece.transform = transform
            
            pinch.scale = 1
            
        }
        if pinch.state == .ended { // End pinch
            
            let currentScale = sqrt(abs(piece.transform.a * piece.transform.d - piece.transform.b * piece.transform.c))
                        
            if currentScale <= self.minScale { // Under lower  scale limit
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {() -> Void in
                    
                    piece.center = CGPoint(x: superV.frame.size.width / 2, y: superV.frame.size.height / 2)
                    piece.transform = CGAffineTransform(scaleX: self.minScale, y: self.minScale)
                    
                    
                }, completion: {(finished: Bool) -> Void in
                })
            } else if self.maxScale <= currentScale { // Upper higher scale limit
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {() -> Void in
                    
                    piece.center = CGPoint(x: superV.frame.size.width / 2, y: superV.frame.size.height / 2)
                    piece.transform = CGAffineTransform(scaleX: self.maxScale, y: self.maxScale)
                    
                }, completion: {(finished: Bool) -> Void in
                })
            }
            
        }
        
        
        
        
        
        
        
        
        
//        // get the new scale
//        let sc = pinch.scale
//        
//        // get current frame of "piece" view
//        let currentPieceRect = piece.frame
//        
//        // apply scaling transform to the rect
//        let futureRect = currentPieceRect.applying(CGAffineTransform(scaleX: sc, y: sc))
//        
//        
//        // if the resulting rect's width will be
//        //  greater-than-or-equal to superView's width
//        if futureRect.width >= superV.bounds.width || futureRect.height >= superV.bounds.height {
//            // go ahead and scale the piece view
//            piece.transform = piece.transform.scaledBy(x: sc, y: sc)
//        }
//        
//        
    }
    
    @objc private func handleDoubleTap(tap: UITapGestureRecognizer) {
        // unwrap the view from the gesture
        // AND
        // unwrap that view's superView
        guard let piece = tap.view,
              let superV = piece.superview
        else { return }
        
        let currentScale = sqrt(abs(piece.transform.a * piece.transform.d - piece.transform.b * piece.transform.c))

        if currentScale == self.maxScale / 2 {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {() -> Void in
                
                piece.center = CGPoint(x: superV.frame.size.width / 2, y: superV.frame.size.height / 2)
                piece.transform = CGAffineTransform(scaleX: self.minScale, y: self.minScale)
                
                
            }, completion: {(finished: Bool) -> Void in
            })        }
        else {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {() -> Void in
                
                piece.center = CGPoint(x: superV.frame.size.width / 2, y: superV.frame.size.height / 2)
                piece.transform = CGAffineTransform(scaleX: self.maxScale / 2, y: self.maxScale / 2)
                
            }, completion: {(finished: Bool) -> Void in
            })
        }
        
//        if zoomScale == minScale {
//            setZoomScale(2, animated: true)
//        } else {
//            setZoomScale(minScale, animated: true)
//        }
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.collectionContainerView.alpha = 0
        print("resultImage Width: \(resultImage.size.width), resultImage Height: \(resultImage.size.height)")
        
        previousAspectRatio = self.resultImageViewAspectRatioConstraint
        
        self.resultImageViewAspectRatioConstraint.isActive = false
        self.view.layoutIfNeeded()
        self.resultImageViewAspectRatioConstraint = self.previousAspectRatio.changeMultiplier(multiplier: (resultImage.size.width/resultImage.size.height) )
        self.resultImageViewAspectRatioConstraint.isActive = true
        self.view.layoutIfNeeded()
        
        
        print("AspectRatio ", resultImage.size.width/resultImage.size.height)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.transition(with: resultImageView, duration: 2.0, options: .transitionCrossDissolve, animations: {
            self.resultImageView.image = self.resultImage
        }, completion: nil)
        
//        UIView.animate(withDuration: 1.5, delay: 0.0, options: [.curveEaseOut], animations: {
//            self.resultImageView.image = self.resultImage
//        }, completion: nil)
        
//        UIView.animate(withDuration: 0.3) {
//            self.collectionContainerView.alpha = 1
//        }
        
        self.frameActual = self.resultImageView.frame
    }
    
    private func setupView() {
        resultContainerView.clipsToBounds = true
        resultContainerView.layer.cornerRadius = 12
        
        resultImageView.layer.cornerRadius = 12
        resultImageView.backgroundColor = .clear
        resultImageView.image = pickedImage
        
        collectionContainerView.clipsToBounds = true
    }
    
        
    private func loadCollectionView() {
        collectionView = UICollectionView(frame: collectionContainerView.bounds, collectionViewLayout: CustomCompositionalLayout.downloadLayout)
        
        collectionView.register(UINib(nibName: "ResultCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ResultCollectionViewCell.identifier)
    
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isSpringLoaded = false
        collectionView.isScrollEnabled = false
        
        collectionContainerView.addSubview(collectionView)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
}


extension DownloadViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let numberOfSections = DataManager.shared.getDownloadRootDataCount() else { return 0 }
        return numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionData = DataManager.shared.getDownloadSectionData(of: section) else { return 0 }
        return sectionData.items.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionData = DataManager.shared.getDownloadSectionData(of: indexPath.section) else { return UICollectionViewCell() }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier, for: indexPath) as? ResultCollectionViewCell else { return UICollectionViewCell() }
        cell.setup(image: sectionData.items[indexPath.item].image, title: sectionData.items[indexPath.item].text, isPro: sectionData.items[indexPath.item].isPro)
        return cell
    }
}

extension DownloadViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("Tapped: Section \(indexPath.section) item \(indexPath.item)")
//    }
    
}


extension DownloadViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
