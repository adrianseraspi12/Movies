//
//  APIClient.swift
//  Movies
//
//  Created by Adrian Jun Seraspi on 3/27/21.
//

import Foundation
import Combine
import Alamofire

protocol Client {
    
    func requestSearchMovies(query: String,
                             country: String,
                             media: String) -> Future<[MovieList.Result], AFError>
    
}

class APIClient: Client {

    let baseUrlString = "https://itunes.apple.com/"
    
    var sessionManager: Session
    
    init(sessionManager: Session) {
        self.sessionManager = sessionManager
    }
    
    func requestSearchMovies(query: String, country: String, media: String) -> Future<[MovieList.Result], AFError> {
        
        //  Create a parameters for api client
        var params = Parameters()
        params["term"] = query
        params["country"] = country
        params["media"] = media
        
        //  Create request from Session
        let request = sessionManager.request(createUrl(withPath: "search"),
                                             parameters: params)
        
        ///  Using combine framework
        ///  Use future to produce a value for success or fail
        ///  and execute the request in background thread (global())
        return Future { promise in
            request.responseDecodable(
                of: MovieList.self,
                queue: .global(),
                completionHandler: { (response: DataResponse<MovieList, AFError>) in
                    switch (response.result) {
                    case .success(let data):
                        promise(.success(data.result))
                        break
                    case .failure(let error):
                        promise(.failure(error))
                        break
                }
            })
        
        }
    }
    
}

extension APIClient {
    
    func createUrl(withPath: String = "") -> URL {
        return URL(string: baseUrlString + withPath)!
    }
    
}
