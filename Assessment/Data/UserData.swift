//
//  UserData.swift
//  Assessment
//
//  Created by Jinyao Wang on 7/5/2022.
//

import Foundation
import FirebaseFirestoreSwift

class UserData: NSObject, Codable {
    
    @DocumentID var id: String?
    var username: String?
    var password: String?
    var perfer: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case password
        case perfer
    }
}
