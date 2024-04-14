//
//  TrailData.swift
//  Assessment
//
//  Created by Jinyao Wang on 1/6/2022.
//

import Foundation

class TrailerData: NSObject, Decodable {
    
    var linkEmbed: String?
    
    required init(from decoder: Decoder) throws {
        // Get the root container first
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        
        // Get the Movie info
        linkEmbed = try rootContainer.decode(String.self, forKey: .linkEmbed)
    }
    
    override init() {}
}

private enum RootKeys: String, CodingKey {
    case linkEmbed
}
