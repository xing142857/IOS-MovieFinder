//
//  VolumeData.swift
//  week5
//
//  Created by Jinyao Wang on 30/3/2022.
//

import UIKit

struct VolumeData: Codable {
    let success: Bool
    let result: [Movie]

    struct Movie: Codable {
        let title: String
        let year: String
        let imdbID: String
        let type: String
        let poster: String

        enum CodingKeys: String, CodingKey {
            case title = "Title"
            case year = "Year"
            case imdbID = "imdbID"
            case type = "Type"
            case poster = "Poster"
        }
    }
}
