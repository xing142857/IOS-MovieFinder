//
//  VolumeData.swift
//  week5
//
//  Created by Jinyao Wang on 30/3/2022.
//

import UIKit

struct VolumeData: Decodable {
    let success: Bool
    let result: [MovieData]
}

struct MovieData: Decodable {
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String

    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }
    
    init() {
        self.title = ""
        self.year = ""
        self.imdbID = ""
        self.type = ""
        self.poster = ""
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        year = try container.decode(String.self, forKey: .year)
        imdbID = try container.decode(String.self, forKey: .imdbID)
        type = try container.decode(String.self, forKey: .type)
        poster = try container.decode(String.self, forKey: .poster)
    }
}
