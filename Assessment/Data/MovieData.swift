//
//  MovieData.swift
//  Assessment
//
//  Created by Jinyao Wang on 16/5/2022.
//

import UIKit
import CoreData
import SwiftUI

class MovieData: NSObject, Decodable {
    
    var id: String?
    var resultType: String?
    var image: String?
    var title: String?
    var year: String?

    required init(from decoder: Decoder) throws {
        // Get the root container first
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        
        // Get the Movie info
        id = try rootContainer.decode(String.self, forKey: .id)
        resultType = try rootContainer.decode(String.self, forKey: .resultType)
        image = try rootContainer.decode(String.self, forKey: .image)
        title = try rootContainer.decode(String.self, forKey: .title)
        let Description = try rootContainer.decode(String.self, forKey: .description)
        year = String(Description.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
    
    override init() {}
}

private enum RootKeys: String, CodingKey {
    case id
    case resultType
    case image
    case title
    case description
}
