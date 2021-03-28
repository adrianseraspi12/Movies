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
    func getAllMovies() -> AnyPublisher<[Movie], Error>
    
    //  A request to delete all items in the database
    func deleteAllMovies()
    
}

class DatabaseManager: Database {
    
    private var managedObjectContext: NSManagedObjectContext
    private var persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        self.managedObjectContext = persistentContainer.viewContext
    }
    
    func getAllMovies() -> AnyPublisher<[Movie], Error> {
        //  Convert the Future to AnyPublisher
        return getAllMoviesFromLocal().eraseToAnyPublisher()
    }
    
    func getAllMoviesFromLocal() -> Future<[Movie], Error> {
        return Future { promise in
            self.managedObjectContext.perform {
                do {
                    //  Sort the movie entity by id in ascending order
                    let request: NSFetchRequest<Movie> = Movie.fetchRequest()
                    request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
                    
                    //  Request for list of movie entity and convert it to Movie object
                    let movieEntityList = try self.managedObjectContext.fetch(request) as [Movie]
                    promise(.success(movieEntityList))
                } catch let error {
                    promise(.failure(error))
                }
                //  Reset the context to clear up cache
                self.managedObjectContext.reset()
            }
        }
    }
    
    func saveAllMovies(list: [MovieList.Result]) {
        persistentContainer.performBackgroundTask { (context) in
            //  This will be the id of the movie entity
            var index = 0
            
            for item in list {
                // Get Movie Entity
                let movie = NSEntityDescription.insertNewObject(
                    forEntityName: "Movie",
                    into: context) as! Movie
            
                //  Set values for movie
                movie.id = Int32(index)
                movie.currency = item.currency
                movie.genre = item.genre
                movie.imageUrl = item.imageUrl
                movie.longDescription = item.longDescription
                movie.name = item.trackName
                movie.previewUrl = item.previewUrl
                movie.trackPrice = item.trackPrice
                
                //  Increment the id by 1
                index+=1
            }
            
            //  Save the object if there's a change in the database
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    func deleteAllMovies() {
        self.managedObjectContext.performAndWait {
            //  Retrieve fetch request of movie entity
            do {
                //  Request for list of movie entity and cast to NSManagedObject
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Movie.fetchRequest())
                try self.managedObjectContext.execute(batchDeleteRequest)
            } catch let error {
                print(error)
            }
            //  Reset the context to clear up cache
            self.managedObjectContext.reset()
        }
    }

}
