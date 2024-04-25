//
//  RateData.swift
//  Assessment
//
//  Created by Jinyao Wang on 24/5/2022.
//

import Foundation

class RateData: Decodable {
    let success: Bool
    let result: MovieDetail
}

struct MovieDetail: Decodable {
    let title: String
    let year: String
    let genre: String
    let plot: String
    let poster: String
    let ratings: [Ratings]
    
    struct Ratings: Decodable {
        let source: String
        let value: String
        
        private enum CodingKeys: String, CodingKey {
            case source = "Source"
            case value = "Value"
        }
        
        init() {
            self.source = ""
            self.value = ""
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            source = try container.decode(String.self, forKey: .source)
            value = try container.decode(String.self, forKey: .value)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case genre = "Genre"
        case plot = "Plot"
        case poster = "Poster"
        case ratings = "Ratings"
    }
    
    init() {
        self.title = ""
        self.year = ""
        self.genre = ""
        self.plot = ""
        self.poster = ""
        self.ratings = []
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        year = try container.decode(String.self, forKey: .year)
        genre = try container.decode(String.self, forKey: .genre)
        plot = try container.decode(String.self, forKey: .plot)
        poster = try container.decode(String.self, forKey: .poster)
        ratings = try container.decode([Ratings].self, forKey: .ratings)
    }
}
