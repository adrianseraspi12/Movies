//
//  APILogger.swift
//  Movies
//
//  Created by Adrian Jun Seraspi on 3/27/21.
//

import Foundation
import Alamofire
/**
    Logging class from Alamofire
 */
class APILogger: EventMonitor {
    
    /// Event called when request is resume
    func requestDidResume(_ request: Request) {
        print("Resuming: \(request)")
    }
    
    /// Event called when DataRequest has parsed the response
    func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        print("Finished: \(response)")
    }
    
}
