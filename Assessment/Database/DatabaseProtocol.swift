//
//  DatabaseProtocol.swift
//  week4\
//
//  Created by Jinyao Wang on 23/3/2022.
//

import Foundation

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case userdata
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onUserDataChange(change: DatabaseChange, userdata: [UserData])
}

protocol DatabaseProtocol: AnyObject {
    func cleanup()
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    
    func loginUser(username: String, password: String) -> String
    func addUserNameAndPassword(username: String, password: String) -> String
    func signinUser(prefer: [Int]) -> UserData
    
    func addMovieModel(movieData: MovieData) -> MovieModel
    func returnCurrentMovie() -> MovieData
}

