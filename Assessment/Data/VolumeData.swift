//
//  VolumeData.swift
//  week5
//
//  Created by Jinyao Wang on 30/3/2022.
//

import UIKit

class VolumeData: NSObject, Decodable {
    
    var movies: [MovieData]?
    
    private enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}
