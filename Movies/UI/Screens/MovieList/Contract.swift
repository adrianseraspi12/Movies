//
//  Contract.swift
//  Movies
//
//  Created by Adrian Jun Seraspi on 3/27/21.
//

import Foundation

enum ScreenState: Equatable {
    case loading(Bool)
    case displayList([MainMovies])
    case error(String)
}

protocol ViewModel {
    
    //  Setting up the view state. Check persist data
    func setup()
    
    //  Handles the search operation
    func search(query: String)
    
    var searchQuery: String { get set }
}

protocol View {
    
    func set(state: ScreenState)
    
}
