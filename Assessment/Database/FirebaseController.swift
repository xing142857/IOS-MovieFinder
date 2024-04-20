//
//  FirebaseController.swift
//  Assessment
//
//  Created by Jinyao Wang on 4/5/2022.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import UIKit
import CoreData
import CryptoKit

class FirebaseController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate {
    
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer: NSPersistentContainer
    var database: Firestore
    var authController: Auth
    var currentUser: Firebase.User?
    var usersRef: CollectionReference?
    
    var FirebaseUserdata: [UserData]
    var theLoginUser = UserData()
    var newUser = UserData()
    
    var currentMovie = MovieData()
    
    func cleanup() {}
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        if listener.listenerType == .userdata || listener.listenerType == .all {
            listener.onUserDataChange(change: .update, userdata: FirebaseUserdata)
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    // MARK: - UserData
    
    func addUserNameAndPassword(username: String, password: String) -> String{
        newUser.username = String(CryptoKit.SHA256.hash(data: username.data(using: .utf8)!).description.suffix(64))
        newUser.password = String(CryptoKit.SHA256.hash(data: password.data(using: .utf8)!).description.suffix(64))
        for i in FirebaseUserdata {
            if i.username == newUser.username {
                return "Username is duplicate, please try another one!"
            }
        }
        return ""
    }

    func signinUser(prefer perfer: [Int]) -> UserData{
        newUser.perfer = perfer
        do {
            if let usersRef = try usersRef?.addDocument(from: newUser) {
                newUser.id = usersRef.documentID
                theLoginUser = newUser
            }
        } catch {
            print("Failed to serialize user")
        }
        return newUser
    }
    
    func loginUser(username: String, password: String) -> String {
        // If data is huge, a more efficient search way should be used.
        for i in FirebaseUserdata {
            if i.username == String(CryptoKit.SHA256.hash(data: username.data(using: .utf8)!).description.suffix(64)) && i.password! == String(CryptoKit.SHA256.hash(data: password.data(using: .utf8)!).description.suffix(64)) {
                theLoginUser = i
                return ""
            }
        }
        return "User name or password is incorrect!"
    }
    
    func setupUserListener() {
        usersRef = database.collection("UserData")
        usersRef?.addSnapshotListener() {
            (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Failed to fetch documents with error: \(String(describing: error))")
                return
            }
            self.parseUserSnapshot(snapshot: querySnapshot)
        }
    }
    
    func modifyUserListener() {
        usersRef = database.collection("UserData")
        usersRef?.addSnapshotListener() {
            (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Failed to fetch documents with error: \(String(describing: error))")
                return
            }
            self.parseUserSnapshot(snapshot: querySnapshot)
        }
    }
    
    func parseUserSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach {(change) in
            var parsedUser: UserData?
            do {
                parsedUser = try change.document.data(as: UserData.self)
            } catch {
                print("Unable to decode user. Is the user malformed?")
                return
            }
            guard let user = parsedUser else {
                print("Document doesn't exist")
                return;
            }
            if change.type == .added {
                FirebaseUserdata.insert(user, at: Int(change.newIndex))
            }
            else if change.type == .modified {
                FirebaseUserdata[Int(change.oldIndex)] = user
            }
            else if change.type == .removed {
                FirebaseUserdata.remove(at: Int(change.oldIndex))
            }
            listeners.invoke { (listener) in
                if listener.listenerType == ListenerType.userdata || listener.listenerType == ListenerType.all {
                    listener.onUserDataChange(change: .update, userdata: FirebaseUserdata)
                }
            }
        }
    }
    
    // MARK: - CoreData
    
    func addMovieModel(movieData: MovieData) -> MovieModel {
        let movie = NSEntityDescription.insertNewObject(forEntityName: "MovieModel", into: persistentContainer.viewContext) as! MovieModel
        movie.title = movieData.title
        movie.year = movieData.year
        movie.imdbID = movieData.imdbID
        movie.type = movieData.type
        movie.poster = movieData.poster
        currentMovie = movieData
        return movie
    }
    
    func returnCurrentMovie() -> MovieData {
        return currentMovie
    }
    
    // MARK: - init()
    
    override init() {
        FirebaseApp.configure()
        FirebaseUserdata = [UserData]()
        authController = Auth.auth()
        database = Firestore.firestore()
        
        persistentContainer = NSPersistentContainer(name: "MovieModel")
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack with error: \(error)")
            }
        }
        
        super.init()
        Task {
            do {
                let authDataResult = try await authController.signInAnonymously()
                currentUser = authDataResult.user }
            catch {
                fatalError("Firebase Authentication Failed with Error \(String(describing: error))")
            }
            self.setupUserListener()
        }
    }
}
