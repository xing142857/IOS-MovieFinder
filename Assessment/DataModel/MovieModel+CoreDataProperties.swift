//
//  MovieModel+CoreDataProperties.swift
//  Assessment
//
//  Created by Jinyao Wang on 20/5/2022.
//
//

import Foundation
import CoreData


extension MovieModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieModel> {
        return NSFetchRequest<MovieModel>(entityName: "MovieModel")
    }

    @NSManaged public var title: String?
    @NSManaged public var year: String?
    @NSManaged public var imdbID: String?
    @NSManaged public var type: String?
    @NSManaged public var poster: String?

}

extension MovieModel : Identifiable {

}
