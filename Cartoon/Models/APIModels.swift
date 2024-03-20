//
//  APIModels.swift
//  Cartoon
//
//  Created by BCL Device-18 on 20/3/24.
//

import Foundation

struct UploadResponseModel: Codable {
    let mainImageKey: String

    enum CodingKeys: String, CodingKey {
        case mainImageKey = "main_image_key"
    }
}

struct imageIllusionRealisticResponseModel: Codable {
    let uid: String
}

struct getInfoResponseModel: Codable {
    let eta: Double?
    let result: String?
    let status: String
}
