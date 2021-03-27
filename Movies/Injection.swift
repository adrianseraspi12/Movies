//
//  Injection.swift
//  Movies
//
//  Created by Adrian Jun Seraspi on 3/27/21.
//

import Foundation
import Alamofire
import CoreData

/**
    A class that handles the initialization of ApiClient
    and DatabaseManager
 */
class Injection {
    
    static func provideApiClient() -> APIClient {
        var session: Session
        
        #if DEBUG
        session = Session(eventMonitors: [APILogger()])
        #else
            session = Session()
        #endif
        
        return APIClient(sessionManager: session)
    }
    
    static func provideDatabaseManager(appDelegate: AppDelegate) -> DatabaseManager {
        let managedContext = appDelegate.persistentContainer.viewContext
        return DatabaseManager(managedObjectContext: managedContext)
    }
    
}
