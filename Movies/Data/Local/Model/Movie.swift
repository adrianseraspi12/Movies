//
//  Movie.swift
//  Movies
//
//  Created by Adrian Jun Seraspi on 3/27/21.
//

import CoreData

class Movie: NSManagedObject {
    
    @NSManaged var id: Int
    @NSManaged var imageUrl: String
    @NSManaged var previewUrl: String
    @NSManaged var trackName: String
    @NSManaged var trackPrice: Double
    @NSManaged var currency: String
    @NSManaged var genre: String
    @NSManaged var longDescription: String
 
    func set(id: Int, imageUrl: String, previewUrl: String, trackName: String, currency: String, genre: String, longDescription: String) {
        self.id = id
        self.imageUrl = imageUrl
        self.previewUrl = previewUrl
        self.trackName = trackName
        self.currency = currency
        self.genre = genre
        self.longDescription = longDescription
    }
    
}
