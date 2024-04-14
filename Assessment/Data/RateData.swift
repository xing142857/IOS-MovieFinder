//
//  RateData.swift
//  Assessment
//
//  Created by Jinyao Wang on 24/5/2022.
//

import Foundation

class RateData: NSObject, Decodable {
    
    var imDb: String?
    var metacritic: String?
    var theMovieDb: String?
    var rottenTomatoes: String?
    var filmAffinity: String?
    
    required init(from decoder: Decoder) throws {
        // Get the root container first
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        
        // Get the Movie info
        imDb = try rootContainer.decode(String.self, forKey: .imDb)
        metacritic = try rootContainer.decode(String.self, forKey: .metacritic)
        theMovieDb = try rootContainer.decode(String.self, forKey: .theMovieDb)
        rottenTomatoes = try rootContainer.decode(String.self, forKey: .rottenTomatoes)
        filmAffinity = try rootContainer.decode(String.self, forKey: .filmAffinity)
    }
    
    override init() {}
}

private enum RootKeys: String, CodingKey {
    case imDb
    case metacritic
    case theMovieDb
    case rottenTomatoes
    case filmAffinity
}
