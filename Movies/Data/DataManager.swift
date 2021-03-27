//
//  DataManager.swift
//  Movies
//
//  Created by Adrian Jun Seraspi on 3/27/21.
//

import Foundation

class DataManager {
    
    var apiClient: Client
    var databaseManager: Database
    
    init(apiClient: Client, databaseManager: Database) {
        self.apiClient = apiClient
        self.databaseManager = databaseManager
    }
    
}
