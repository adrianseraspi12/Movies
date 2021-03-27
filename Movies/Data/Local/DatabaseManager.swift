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
    
    func saveAll(list: [MovieList.Result]) -> Future<Any, Error>
    func getAllMovies() -> Future<NSManagedObject, Error>
    
}

class DatabaseManager: Database {
    
    var managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func saveAll(list: [MovieList.Result]) -> Future<Any, Error> {
        
        return Future { promise in
            
        }
    }
    
    func getAllMovies() -> Future<NSManagedObject, Error> {
        
        return Future { promise in
            
        }
    }
    
}
