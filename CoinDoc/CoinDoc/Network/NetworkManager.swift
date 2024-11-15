//
//  NetworkManager.swift
//  CoinDoc
//
//  Created by Aswin S on 12/11/24.
//

import Foundation

import Foundation

/// Network manager class for the app
class NetworkManager {
    static let shared = NetworkManager()    // Singleton for global access
    
    private init() {}
    
    typealias RequestCompletion = (_ data: Data?, _ error: NetworkError?) -> Void
    
    /// To fetch data from server
    /// - Parameters:
    ///   - url: url for fetching data
    ///   - completion: Request completion provided
    func fetchData(from url: URL, completion: @escaping RequestCompletion) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {   // request failed
                    print("Failed request : \(error!.localizedDescription)")
                    completion(nil, .failedRequest)
                    return
                }
                guard let data = data else {    // no returned data
                    print("No data returned")
                    completion(nil, .noData)
                    return
                }
                guard let response = response as? HTTPURLResponse else {    // issue with response
                    print("Unable to process response")
                    completion(nil, .invalidResponse)
                    return
                }
                guard response.statusCode == 200 else {     // response other than 200
                    print("Failure response: \(response.statusCode)")
                    completion(nil, .failedRequest)
                    return
                }
                completion(data as Data?, nil)      // success response
            }
        }
        task.resume()
    }
}

/// Network error cases
enum NetworkError:String, Error {
    case invalidResponse = "Response Invalid"
    case noData = "No Data"
    case failedRequest = "Request failed"
    case invalidData = "Invalid Data"
}
