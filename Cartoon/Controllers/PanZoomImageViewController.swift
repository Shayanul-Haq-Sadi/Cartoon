//
//  PanZoomImageViewController.swift
//  Cartoon
//
//  Created by BCL Device-18 on 17/4/24.
//

import UIKit

class PanZoomImageViewController: UIViewController {
    
    @IBOutlet weak var panImageView: PanZoomImageView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        panImageView.center = view.center
        panImageView.image = UIImage(named: "Golden Statue_cartoon")
        

        
        imageView.getImageScale()
    }

}



//extension UIImage {
//    func scale(newWidth: CGFloat) -> UIImage
//    {
//        guard self.size.width != newWidth else{return self}
//        
//        let scaleFactor = newWidth / self.size.width
//        
//        let newHeight = self.size.height * scaleFactor
//        let newSize = CGSize(width: newWidth, height: newHeight)
//        
//        UIGraphicsBeginImageContextWithOptions(newSize, true, 0.0)
//        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
//        
//        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//        return newImage ?? self
//    }
//}

extension UIImageView {
    
    func getImageScale() {
        
        let scale: CGFloat
        
        switch self.contentMode {
        case .scaleAspectFit:
            // The scale is the minimum of the width and height ratios between the image and the view
            scale = min(self.bounds.width / self.image!.size.width,
                        self.bounds.height / self.image!.size.height)
        case .scaleAspectFill:
            // The scale is the maximum of the width and height ratios between the image and the view
            scale = max(self.bounds.width / self.image!.size.width,
                        self.bounds.height / self.image!.size.height)
        case .scaleToFill:
            // Scale is not a meaningful concept in this case, so you can define it as 1.0 or anything else you find appropriate
            scale = 1.0
            // Add more cases as needed for other content modes
        default:
            // For other content modes, you might need different calculations or default values
            scale = 1.0
        }
        
        // Now you have the scale
        print("Scale: \(scale)")
        
    }
}
