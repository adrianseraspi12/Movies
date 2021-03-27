//
//  DatabaseManager.swift
//  Movies
//
//  Created by Adrian Jun Seraspi on 3/27/21.
//

import UIKit
import Combine
import CoreData

protocol Database {
    
    //  A request to save all movie in database
    func saveAllMovies(list: [MovieList.Result])
    
    //  A request to get all movies from the database
    func getAllMovies() -> Future<[Movie], Error>
    
    //  A request to delete all items in the database
    func deleteAllMovies()
    
}

class DatabaseManager: Database {
    
    var managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func getAllMovies() -> Future<[Movie], Error> {
        return Future { promise in
            // Perform database operation in background thread
            self.managedObjectContext.perform {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
                do {
                    //  Request for list of movie entity and convert it to Movie object
                    let movieEntityList = try self.managedObjectContext.fetch(fetchRequest)
                    let listOfMovie = movieEntityList.map { $0 as! Movie }
                    promise(.success(listOfMovie))
                } catch let error {
                    promise(.failure(error))
                }
                //  Reset the context to clear up cache
                self.managedObjectContext.reset()
            }
        }
    }
    
    func saveAllMovies(list: [MovieList.Result]) {
        // Perform database operation in background thread
        self.managedObjectContext.perform {
            for item in list {
                // Get Movie Entity
                let movieEntityObj = NSEntityDescription.insertNewObject(
                    forEntityName: "Movie",
                    into: self.managedObjectContext)
                
                // Cast Movie Entity to Movie Object return if null
                guard let movie = movieEntityObj as? Movie else {
                    return
                }
                    
                //  Set values for movie
                movie.set(id: item.id,
                            imageUrl: item.imageUrl,
                            previewUrl: item.previewUrl,
                            trackName: item.trackName,
                            currency: item.currency,
                            genre: item.genre,
                            longDescription: item.longDescription)
            }
                
            //  Save the object if there's a change in the database
            //  Call promise to return the state of the operation
            if self.managedObjectContext.hasChanges {
                do {
                    try self.managedObjectContext.save()
                } catch let error as NSError {
                    print(error)
                }
            }
                
            //  Reset the context to clear up cache
            self.managedObjectContext.reset()
        }
    }
    
    func deleteAllMovies() {
        // Perform database operation in background thread
        self.managedObjectContext.perform {
        //  Retrieve fetch request of movie entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
            do {
                //  Request for list of movie entity and cast to NSManagedObject
                let movieEntityList = try self.managedObjectContext.fetch(fetchRequest).map { $0 as? NSManagedObject }
                for item in movieEntityList {
                    if let item = item {
                        //  Delete the item
                        self.managedObjectContext.delete(item)
                    }
                }
            } catch let error {
                print(error)
            }
            //  Reset the context to clear up cache
            self.managedObjectContext.reset()
        }
    }
    
}
