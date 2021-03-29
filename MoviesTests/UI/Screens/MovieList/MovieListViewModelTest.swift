//
//  MovieListViewModelTest.swift
//  MoviesTests
//
//  Created by Adrian Jun Seraspi on 3/28/21.
//

import XCTest

@testable import Movies

class MovieListViewModelTest: XCTestCase {

    var viewmodel: MovieListViewModel!
    var userDefaults: UserDefaults!
    var api = MockClient()
    var mockLocalDb = MockDatabase()
    var mockView = MockView()
    
    override func setUpWithError() throws {
        userDefaults = UserDefaults(suiteName: "mockUserDefaults")
        viewmodel = MovieListViewModel(vc: mockView,
                                       userDefaults: userDefaults,
                                       api: api,
                                       localDb: mockLocalDb)
    }
    
    override func tearDownWithError() throws {
        userDefaults.removePersistentDomain(forName: "mockUserDefaults")
    }
    
    //  MARK: ViewModel Search() Unit test
    func test_When_SearchQueryIsEmpty_Should_ReturnEmptyList() {
        viewmodel.search(query: "")
        let expected: [MainMovies] = []
        XCTAssertEqual(mockView.data, expected)
    }
    
    //  MARK: ViewModel Search() Unit test
    func test_When_SearchQueryIsSuccessful_ShouldReturnListWithData() {
        viewmodel.search(query: "Justice League")
        let expected = MockValues.movieResultList.map { $0.convertToMainMovies() }
        let currentData = mockView.data
        
        XCTAssertEqual(currentData, expected)
        XCTAssertTrue(mockLocalDb.isDeleteAllMoviesCalled)
        XCTAssertTrue(mockLocalDb.isSaveAllMoviesCalled)
    }
    
    //  MARK: ViewModel setPersistedData() Unit test
    func test_When_SearchQueryIsEmpty_GetAllMovies_Should_NotBeCalled() {
        userDefaults.setValue("", forKey: "search_query")
        viewmodel.setupPersistedData()
        XCTAssertFalse(mockLocalDb.isGetAllMoviesCalled)
    }
    
    //  MARK: ViewModel change() Unit test
    func test_When_ChangeAppStateIsList_UserDefaultsAppState_Should_BeEqualToListState() {
        viewmodel.change(state: .list, movieId: nil)
        let expected = AppState(rawValue: AppState.list.rawValue)
        let value = userDefaults.string(forKey: "app_state")!
        let currentState = AppState(rawValue: value)!
        
        XCTAssertEqual(currentState, expected)
    }
    
    //  MARK: ViewModel change() Unit test
    func test_When_ChangeAppStateIsDetails_UserDefaultsAppState_Should_BeEqualToDetailsState() {
        let expectedId = 1
        viewmodel.change(state: .details, movieId: expectedId)
        
        //  Test the AppState
        let expectedState = AppState(rawValue: AppState.details.rawValue)
        let valueState = userDefaults.string(forKey: "app_state")!
        let currentState = AppState(rawValue: valueState)!
        XCTAssertEqual(currentState, expectedState)
        
        //  Test the MovieId
        let currentMovieId = userDefaults.integer(forKey: "movie_id")
        XCTAssertEqual(currentMovieId, 1)
    }
    
}
