//
//  PreviewSliderViewController.swift
//  Cartoon
//
//  Created by BCL Device-18 on 10/3/24.
//

import UIKit
import APNGKit

class PreviewSliderViewController: UIViewController, UINavigationControllerDelegate {
    
    static let identifier = "PreviewSliderViewController"
        
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var labelStackView: UIStackView!
    
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageContainerViewHeightConstraint: NSLayoutConstraint! //
    @IBOutlet weak var imageContainerAspectRatioConstraint: NSLayoutConstraint! //
    @IBOutlet weak var imageContainerViewTopConstraint: NSLayoutConstraint! //
    @IBOutlet weak var imageContainerViewLeadingConstraint: NSLayoutConstraint! //
    @IBOutlet weak var imageContainerViewTrailingConstraint: NSLayoutConstraint! //
    
    @IBOutlet weak var afterContainerView: UIView!
    @IBOutlet weak var afterImageView: UIImageView!
    @IBOutlet weak var afterLabelView: UIView!
        
    @IBOutlet weak var beforeContainerView: UIView!
    @IBOutlet weak var beforeContainerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var beforeImageView: UIImageView!
    @IBOutlet weak var beforeLabelView: UIView!
   
    @IBOutlet weak var sliderImageView: UIImageView!
    
    @IBOutlet weak var pickedImageView: UIImageView!
    @IBOutlet weak var pickedImageViewAspectRatioConstraint: NSLayoutConstraint!
    @IBOutlet weak var pickedImageViewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var pickedImageViewWidthConstraint: NSLayoutConstraint!
    private var previousAspectRatio: NSLayoutConstraint!
    private var previousCenterY: NSLayoutConstraint!
    private var previousWidth: NSLayoutConstraint!
    //    private var previousHeightConstant: CGFloat! //
    
    
    @IBOutlet weak var targetContainerView: UIView!
    @IBOutlet weak var targetView: UIImageView!
    @IBOutlet weak var targetViewAspectRatioConstraint: NSLayoutConstraint!
    private var previousTargetViewAspectRatio: NSLayoutConstraint!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var loaderContainerView: UIView!
    @IBOutlet weak var activityIndicatorView: APNGImageView!
    private var activityIndicatorImage: APNGImage!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    private let panGestureRecognizer = UIPanGestureRecognizer()
    private var initialImageCenter: CGPoint!
    
    private let timerManager = TimerManager()

    var data: Item!
        
    private var mainImageKey = String()
    private var UID: String? = nil

    private var pickedPixelHeight = CGFloat()
    private var pickedPixelWidth = CGFloat()
    private var pickedImage: UIImage!

    private var eta = Double()
    private var result = String()
    private var status = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addPanGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        labelStackView.alpha = 0
        afterLabelView.alpha = 0
        beforeContainerView.alpha = 0
        beforeLabelView.alpha = 0
        nextButton.alpha = 0
        
        if labelStackView.isHidden == true || nextButton.isHidden == true {
            closeButton.isHidden = false
            labelStackView.isHidden = false
//            beforeContainerView.isHidden = false
//            afterLabelView.isHidden = false
            imageContainerView.isHidden = false
            pickedImageView.isHidden = true
            sliderImageView.isHidden = false
            nextButton.isHidden = false
            afterImageView.image = UIImage(named: data.image)
            
//            imageContainerViewTopConstraint.constant = 28
//            imageContainerViewLeadingConstraint.constant = 30
//            imageContainerViewTrailingConstraint.constant = 30
            
//            afterImageView.contentMode = .scaleAspectFill
            
//            NSLayoutConstraint.deactivate([self.newHeight, self.newWidth])
//            imageContainerAspectRatioConstraint = previousAspectRatio
//            imageContainerAspectRatioConstraint.isActive = true
            
//            self.imageContainerAspectRatioConstraint.isActive = false
//            self.view.layoutIfNeeded()
//            self.imageContainerAspectRatioConstraint = self.previousAspectRatio.changeMultiplier(multiplier: 59.0 / 81.0)
//            self.imageContainerViewHeightConstraint.constant = self.previousHeightConstant
//            self.imageContainerAspectRatioConstraint.isActive = true
//            self.view.layoutIfNeeded()
            
            
            
            
            self.pickedImageViewAspectRatioConstraint.isActive = false
            self.view.layoutIfNeeded()
            self.pickedImageViewAspectRatioConstraint = self.previousAspectRatio.changeMultiplier(multiplier: (self.imageContainerView.frame.size.width/self.imageContainerView.frame.size.height))
            self.pickedImageViewAspectRatioConstraint.isActive = true
            self.view.layoutIfNeeded()
            
            
            self.pickedImageViewCenterYConstraint.isActive = false
            self.view.layoutIfNeeded()
            self.pickedImageViewCenterYConstraint = self.previousCenterY.changeSecondItem(secondItem: self.imageContainerView)
            self.pickedImageViewCenterYConstraint.isActive = true
            self.view.layoutIfNeeded()
            
            
            self.pickedImageViewWidthConstraint.isActive = false
            self.view.layoutIfNeeded()
            self.pickedImageViewWidthConstraint = self.previousWidth.changeSecondItem(secondItem: self.imageContainerView)
            self.pickedImageViewWidthConstraint.isActive = true
            self.view.layoutIfNeeded()
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.labelStackView.alpha = 1
            self.afterLabelView.alpha = 1
            self.beforeContainerView.alpha = 1
            self.beforeLabelView.alpha = 1
            self.nextButton.alpha = 1
        }
        
        animateWidthConstraint(to: imageContainerView.bounds.width - 60) {
            self.animateWidthConstraint(to: 60) {
                self.animateWidthConstraint(to: self.imageContainerView.bounds.width/2, completion: nil)
            }
        }
    }
    
    private func setupView() {
        imageContainerView.layer.cornerRadius = 12
        imageContainerView.clipsToBounds = true
        
        afterContainerView.layer.cornerRadius = 12
        afterContainerView.clipsToBounds = true
        afterImageView.image = UIImage(named: data.image)
        afterLabelView.layer.cornerRadius = 14
        
//        pickedImageView.backgroundColor = .cyan
        pickedImageView.layer.cornerRadius = 12
                
        previousAspectRatio = self.pickedImageViewAspectRatioConstraint
        previousCenterY = self.pickedImageViewCenterYConstraint
        previousWidth = self.pickedImageViewWidthConstraint
        
//        previousAspectRatio = self.imageContainerAspectRatioConstraint
//        previousHeightConstant = self.imageContainerViewHeightConstraint.constant
      
        beforeContainerView.clipsToBounds = true
        beforeImageView.image = UIImage(named: data.originalImage)
        beforeLabelView.layer.cornerRadius = 14
        
        
        loaderContainerView.isHidden = true
        addActivityIndicatorView()
        cancelButton.layer.cornerRadius = 20
    }
    
    private func addActivityIndicatorView() {
        do {
            if let url = Bundle.main.url(forResource: "infinteLoader", withExtension: "png") {
                activityIndicatorImage = try APNGImage(fileURL: url, decodingOptions: .fullFirstPass)
                activityIndicatorView.autoStartAnimationWhenSetImage = false
                activityIndicatorView.image = activityIndicatorImage
            }
        } catch {
            if let normalImage = error.apngError?.normalImage {
                activityIndicatorView.staticImage = normalImage
            } else {
                print("Error: \(error)")
            }
        }

//        activityIndicatorView.onOnePlayDone.delegate(on: self) { (self, count) in
//            print("Played: \(count)")
//        }
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
//            let clampedX = max(sliderImageView.bounds.width/2, min(imageContainerView.bounds.width - sliderImageView.bounds.width/2, newCenterX))
            let clampedX = max(0, min(imageContainerView.bounds.width, newCenterX))
            sliderImageView.center = CGPoint(x: clampedX, y: initialImageCenter.y)
            beforeContainerViewWidthConstraint.constant = clampedX
        } else if gesture.state == .ended {
            // Perform any additional actions when the pan gesture ends
        }
    }
    
    private func animateWidthConstraint(to constant: CGFloat, completion: (() -> Void)?) {
        let animator = UIViewPropertyAnimator(duration: 1.0, curve: .easeInOut) {
            self.beforeContainerViewWidthConstraint.constant = constant
            self.view.layoutIfNeeded()
        }

        if let completion = completion {
            animator.addCompletion { _ in
                completion()
            }
        }
        animator.startAnimation()
    }

    @IBAction func closeButtonPressed(_ sender: Any) {
//        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {

        if let UID = self.UID {
            cancelProcess(UID: UID)
        } else {
            loaderContainerView.isHidden = true
            activityIndicatorView.stopAnimating()
            APIManager.shared.cancelOngoingRequests()
        }
        
        if labelStackView.isHidden == true || nextButton.isHidden == true {
            closeButton.isHidden = false
            labelStackView.isHidden = false
//            beforeContainerView.isHidden = false
//            afterLabelView.isHidden = false
            imageContainerView.isHidden = false
            pickedImageView.isHidden = true
            sliderImageView.isHidden = false
            nextButton.isHidden = false
            afterImageView.image = UIImage(named: data.image)
            
//            imageContainerViewTopConstraint.constant = 28
//            imageContainerViewLeadingConstraint.constant = 30
//            imageContainerViewTrailingConstraint.constant = 30
            
//            afterImageView.contentMode = .scaleAspectFill

            
//            NSLayoutConstraint.deactivate([self.newHeight, self.newWidth])
//            imageContainerAspectRatioConstraint = previousAspectRatio
//            imageContainerAspectRatioConstraint.isActive = true
            
//            self.imageContainerAspectRatioConstraint.isActive = false
//            self.view.layoutIfNeeded()
//            self.imageContainerAspectRatioConstraint = self.previousAspectRatio.changeMultiplier(multiplier: 59.0 / 81.0)
//            self.imageContainerViewHeightConstraint.constant = self.previousHeightConstant
//            self.imageContainerAspectRatioConstraint.isActive = true
//            self.view.layoutIfNeeded()
            
            
            

            
            self.pickedImageViewAspectRatioConstraint.isActive = false
            self.view.layoutIfNeeded()
            self.pickedImageViewAspectRatioConstraint = self.previousAspectRatio.changeMultiplier(multiplier: (self.imageContainerView.frame.size.width/self.imageContainerView.frame.size.height))
            self.pickedImageViewAspectRatioConstraint.isActive = true
            self.view.layoutIfNeeded()
            
            
            self.pickedImageViewCenterYConstraint.isActive = false
            self.view.layoutIfNeeded()
            self.pickedImageViewCenterYConstraint = self.previousCenterY.changeSecondItem(secondItem: self.imageContainerView)
            self.pickedImageViewCenterYConstraint.isActive = true
            self.view.layoutIfNeeded()
            
            
            self.pickedImageViewWidthConstraint.isActive = false
            self.view.layoutIfNeeded()
            self.pickedImageViewWidthConstraint = self.previousWidth.changeSecondItem(secondItem: self.imageContainerView)
            self.pickedImageViewWidthConstraint.isActive = true
            self.view.layoutIfNeeded()
            
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
//        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func uploadImage(imageData: Data) {
        print("uploadImage API CALLED")
        loaderContainerView.isHidden = false
        activityIndicatorView.startAnimating()
        
        APIManager.shared.uploadImage(imageData: imageData) { resonse in
            switch resonse {
            case .success(let result):
                if let uploadResponse = result as? UploadResponseModel {
                    print("Authentication successful.")
                    self.mainImageKey = uploadResponse.mainImageKey
                    
                    self.getUID(mainImageKey: self.mainImageKey)

                } else {
                    print("Authentication failed. Invalid response data.")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    private func getUID(mainImageKey: String) {
        print("getUID API CALLED")
        APIManager.shared.getImageIllusionRealisticUID(mainImageKey: mainImageKey, pixelHeight: pickedPixelHeight, pixelWidth: pickedPixelWidth) { resonse in
            switch resonse {
            case .success(let result):
                if let realisticResponse = result as? imageIllusionRealisticResponseModel {
                    print("Authentication successful.")
                    self.UID = realisticResponse.uid
                    
                    self.getInfo(UID: realisticResponse.uid)
                    
                } else {
                    print("Authentication failed. Invalid response data.")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    private func getInfo(UID: String) {
        print("getInfo API CALLED")
        APIManager.shared.getInfo(UID: UID) { resonse in
            switch resonse {
            case .success(let result):
                if let getInfoResponse = result as? getInfoResponseModel {
                    print("Authentication successful.")
                    self.status = getInfoResponse.status
                    
                    if self.status == "PENDING" || self.status == "IN_PROGRESS" {
                        print("Status \(self.status).")
                        self.eta = getInfoResponse.eta ?? -1

                        self.timerManager.startTimer(duration: self.eta) { secondsRemaining in
                            print("Seconds remaining: \(secondsRemaining)")
                            
                            if secondsRemaining <= 0, let UID = self.UID {
                                self.getInfo(UID: UID)
                            }
                        }
                    } else if self.status == "COMPLETED" {
                        print("Status COMPLETED.")
                        self.result = getInfoResponse.result ?? ""
                        self.downloadImage(url: self.result)
                    } else if self.status == "CANCELED" {
                        print("Status CANCELED.")
                    }
                } else {
                    print("Authentication failed. Invalid response data.")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    private func cancelProcess(UID: String) {
        print("cancelProcess API CALLED")
        
        APIManager.shared.cancelProcess(UID: UID) { resonse in
            switch resonse {
            case .success(let result):
                print("Cancel successful.", result)
                self.loaderContainerView.isHidden = true
                self.activityIndicatorView.stopAnimating()
                self.timerManager.endTimer()
                APIManager.shared.cancelOngoingRequests()
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    private func downloadImage(url: String) {
        print("downloadImage API CALLED")
        APIManager.shared.downloadImage(urlString: url) { response in
            switch response {
            case .success(let data):
                print("download successful.")

                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.loaderContainerView.isHidden = true
                        self.activityIndicatorView.stopAnimating()
                    }
                    self.saveImageToPhotoLibrary(image)
                    self.presentDownloadViewController(pickedImage: self.pickedImage, resultImage: image)
                } else {
                    print("Failed to convert data to image")
                }
            case .failure(let error):
                print("Error downloading image: \(error.localizedDescription)")
            }
        }
    }
    
    private func saveImageToPhotoLibrary(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        print("Image saved to photo library")
    }
    
    private func animateImageViewToTargetView() {
        pickedImageView.translatesAutoresizingMaskIntoConstraints = false
//        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
//        afterContainerView.translatesAutoresizingMaskIntoConstraints = false
                
        UIView.animate(withDuration: 1.0, delay: 1.0, options: [.curveEaseInOut], animations: {
            
//            self.imageContainerViewLeadingConstraint.constant = 0
//            self.imageContainerViewTrailingConstraint.constant = 0
//            
////            if self.pickedImage.size.width > self.pickedImage.size.height {
////                self.imageContainerViewTopConstraint.constant -= 55
////            } else {
////                self.imageContainerViewTopConstraint.constant -= 85
////            }
//            
//            self.pickedImageView.center = self.targetContainerView.center
//
//            
////            self.imageContainerViewTopConstraint.constant -= 85
////            self.imageContainerViewTopConstraint.constant -= 55
////            self.imageContainerViewTopConstraint.constant += self.targetView.bounds.size.height/2
//            
//            self.imageContainerViewHeightConstraint.constant = self.targetContainerView.frame.height
////            self.afterImageView.contentMode = .scaleAspectFit
////            self.imageContainerView.center = self.targetContainerView.center
//            
//            
//            self.imageContainerAspectRatioConstraint.isActive = false
//            self.view.layoutIfNeeded()
//                        
////            self.imageContainerAspectRatioConstraint = self.previousAspectRatio.changeMultiplier(multiplier: 4.0 / 5.0)
//            self.imageContainerAspectRatioConstraint = self.previousAspectRatio.changeMultiplier(multiplier: (self.pickedImage.size.width/self.pickedImage.size.height))
//            self.imageContainerAspectRatioConstraint.isActive = true
//            self.view.layoutIfNeeded()
//            
////            self.imageContainerView.frame = self.targetView.bounds
//            self.imageContainerView.frame = self.targetContainerView.bounds
            
            

            
            
            
            
            self.pickedImageViewAspectRatioConstraint.isActive = false
            self.view.layoutIfNeeded()
//            self.imageContainerAspectRatioConstraint = self.previousAspectRatio.changeMultiplier(multiplier: 4.0 / 5.0)
            self.pickedImageViewAspectRatioConstraint = self.previousAspectRatio.changeMultiplier(multiplier: (self.pickedImage.size.width/self.pickedImage.size.height))
            self.pickedImageViewAspectRatioConstraint.isActive = true
            self.view.layoutIfNeeded()
            
            
            self.pickedImageViewCenterYConstraint.isActive = false
            self.view.layoutIfNeeded()
            self.pickedImageViewCenterYConstraint = self.previousCenterY.changeSecondItem(secondItem: self.targetView)
            self.pickedImageViewCenterYConstraint.isActive = true
            self.view.layoutIfNeeded()
            
            
            self.pickedImageViewWidthConstraint.isActive = false
            self.view.layoutIfNeeded()
            self.pickedImageViewWidthConstraint = self.previousWidth.changeSecondItem(secondItem: self.targetView)
            self.pickedImageViewWidthConstraint.isActive = true
            self.view.layoutIfNeeded()

        }, completion: nil)
    }
    
    private func presentDownloadViewController(pickedImage: UIImage, resultImage: UIImage) {
        guard let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: DownloadViewController.identifier) as? DownloadViewController else { return }

        VC.modalPresentationStyle = .fullScreen
        VC.modalTransitionStyle = .crossDissolve
        VC.pickedImage = pickedImage
        VC.resultImage = resultImage
        present(VC, animated: true)
//        self.navigationController?.pushViewController(VC, animated: true)
    }
}


extension PreviewSliderViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.pickedImage = pickedImage
            self.pickedPixelWidth = self.pickedImage.size.width
            self.pickedPixelHeight = self.pickedImage.size.height
            print("pickedImage Width: \(self.pickedImage.size.width), pickedImage Height: \(self.pickedImage.size.height)")
            
            guard let fixedOrientationImage = pickedImage.fixedOrientation(), let imageData = fixedOrientationImage.jpegData(compressionQuality: 1.0) else {
                print("Failed to convert image to data")
                return
            }
            
            // move imageView
            closeButton.isHidden = true
            labelStackView.isHidden = true
//            beforeContainerView.isHidden = true
//            afterLabelView.isHidden = true
            imageContainerView.isHidden = true
            pickedImageView.isHidden = false
            sliderImageView.isHidden = true
            nextButton.isHidden = true
            
            DispatchQueue.main.async {
//                self.afterImageView.image = pickedImage
                self.pickedImageView.image = pickedImage
            }

            self.targetView.image = pickedImage
                
            self.previousTargetViewAspectRatio = self.targetViewAspectRatioConstraint
            
            self.targetViewAspectRatioConstraint.isActive = false
            self.view.layoutIfNeeded()
            self.targetViewAspectRatioConstraint = self.previousTargetViewAspectRatio.changeMultiplier(multiplier: (pickedImage.size.width/pickedImage.size.height) )
            self.targetViewAspectRatioConstraint.isActive = true
            self.view.layoutIfNeeded()
            
            print("AspectRatio ", pickedImage.size.width/pickedImage.size.height)
            
            animateImageViewToTargetView()
            
            uploadImage(imageData: imageData)
            
        }
        dismiss(animated: true, completion: nil)
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

