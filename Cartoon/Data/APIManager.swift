//
//  APIManager.swift
//  Cartoon
//
//  Created by BCL Device-18 on 14/3/24.
//

import Foundation
import Alamofire

class APIManager {
    
    static let shared = APIManager()
    
    var request: Request?
    
    private var requestQueue = DispatchQueue(label: "apiQueue")
    
    private var ongoingRequests = [Request]()

    func uploadImage(imageData: Data, completion: @escaping (Result<Any, Error>) -> Void) {
        let url = "http://142.93.246.68:5000/file-upload"
        let bearerToken = "c8aca83933b1773122ba65ed6429f6f13c61yu8aacecdfff0bfa9bb714f01de6"
        let s3BucketName = "bcl-shared-bucket"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "multipart/form-data"
        ]
        
        request = AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
            
            if let s3BucketData = s3BucketName.data(using: .utf8) {
                multipartFormData.append(s3BucketData, withName: "s3_bucket_name")
            }
        }, to: url, method: .post, headers: headers)
        .validate()
        .responseDecodable(of: UploadResponseModel.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        ongoingRequests.append(request!)
    }
    
    
    func getImageIllusionRealisticUID(mainImageKey: String, pixelHeight: CGFloat, pixelWidth: CGFloat, completion: @escaping (Result<Any, Error>) -> Void) {
        let url = "http://illusion-realistic.braincraftapps.com/image-illusion"
        let bearerToken = "esdfds3eder45tfdvfsgsfh454rfgrw4fggfdg4tgfgdffgfklg"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bearerToken)"
        ]
        
        let parameters: [String: Any] = [
            "text": "Art of Charles Angrand,digital art,cinematic lighting,highly detailed,HD.",
//            "text": "Cartoon",
//            "text": "4k, neon,cyberpunk,light rays,cinematic lighting,colorful,volumetric light.",
//            "text": "Caricature,digital art,burlesque,drawing,highly detailed,HD, Male",
            "main_image_key": mainImageKey,
            "negative_prompt": "ugly, low resolution, disfigured, low quality, blurry, blur, nsfw, text, watermark, extra eye brew, poorly drawn face, bad face, fused face, loned face, worst face, extra face, multiple faces, displaces face, poorly drawn dress.",
            "guidance_scale": 7.5,
            "controlnet_conditioning_scale": 4,
            "control_guidance_start": 0,
            "control_guidance_end": 0.9,
            "upscaler_strength": 0.9,
            "seed": "-1",
            "sampler": "DPM++ Karras SDE",
            "height": pixelHeight,
            "width": pixelWidth,
            "steps": 35
        ]

        request = AF.request(url, method: .post, parameters: parameters, headers: headers)
        .validate()
        .responseDecodable(of: imageIllusionRealisticResponseModel.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        ongoingRequests.append(request!)
    }

    
    func getInfo(UID: String, completion: @escaping (Result<Any, Error>) -> Void) {
        let url = "http://illusion-realistic.braincraftapps.com/info?uid=\(UID)"
        let bearerToken = "esdfds3eder45tfdvfsgsfh454rfgrw4fggfdg4tgfgdffgfklg"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bearerToken)"
        ]
        
        request = AF.request(url, method: .get, headers: headers)
        .validate()
        .responseDecodable(of: getInfoResponseModel.self) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        ongoingRequests.append(request!)
    }
    
    
    func cancelProcess(UID: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "http://illusion-realistic.braincraftapps.com/cancel?uid=\(UID)"
        let bearerToken = "esdfds3eder45tfdvfsgsfh454rfgrw4fggfdg4tgfgdffgfklg"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(bearerToken)"
        ]
        
        AF.request(url, method: .get, headers: headers)
        .validate()
        .responseData { response in
            switch response.result {
            case .success(_):
                completion(.success(response.description))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func downloadImage(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        request = AF.download(url).responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        ongoingRequests.append(request!)
    }
    
    
    func cancelOngoingRequests() {
        for request in ongoingRequests {
            request.cancel()
        }
        ongoingRequests.removeAll()
        print("all ongoingRequests request cancel")
    }
    
}

