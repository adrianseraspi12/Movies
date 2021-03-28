//
//  Movie+CoreDataProperties.swift
//  
//
//  Created by Adrian Jun Seraspi on 3/28/21.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var currency: String?
    @NSManaged public var genre: String?
    @NSManaged public var id: Int32
    @NSManaged public var imageUrl: String?
    @NSManaged public var longDescription: String?
    @NSManaged public var name: String?
    @NSManaged public var previewUrl: String?
    @NSManaged public var trackPrice: Double

    func set(id: Int, imageUrl: String, previewUrl: String, trackName: String, price: Double, currency: String, genre: String, longDescription: String) {
        self.id = Int32(id)
        self.imageUrl = imageUrl
        self.previewUrl = previewUrl
        self.name = trackName
        self.currency = currency
        self.trackPrice = price
        self.genre = genre
        self.longDescription = longDescription
    }
    
    func convertToMainMovies() -> MainMovies {
        return MainMovies(id: Int(self.id),
                          imageUrl: self.imageUrl ?? "",
                          previewUrl: self.previewUrl ?? "",
                          trackName: self.name ?? "",
                          trackPrice: Double(self.trackPrice),
                          currency: self.currency ?? "",
                          genre: self.genre ?? "",
                          longDescription: self.longDescription ?? "")
    }
}
