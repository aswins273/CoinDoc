//
//  CoinDetailsService.swift
//  CoinDoc
//
//  Created by Aswin S on 12/11/24.
//

import Foundation

/// Service to fetch coin details
class CoinDetailsService {
    
    typealias CoinsDataCompletion = ([CryptoCoin]?, NetworkError?) -> ()    // Service completion
    
    /// To fetch coin details from url and provide completion back
    /// - Parameters:
    ///   - urlString: url for coins data
    ///   - completion: CoinsDataCompletion  description
    static func fetchCoinDetails(_ urlString: String, completion: @escaping CoinsDataCompletion) {
        guard let url = URL(string: urlString) else {
            let error = NetworkError.invalidResponse
            let data: [CryptoCoin]? = nil
            completion(data, error)
            return
        }
        NetworkManager.shared.fetchData(from: url) { data, error in
            if let respData = data {
                do{
                    let coinsData = try JSONDecoder().decode([CryptoCoin].self, from: respData)
                    completion(coinsData, nil)
                }
                catch{
                    completion(nil, .invalidData)
                }
            }
            completion(nil, error)
        }
    }
}
