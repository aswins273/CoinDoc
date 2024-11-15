//
//  CoinHomeViewModel.swift
//  CoinDoc
//
//  Created by Aswin S on 12/11/24.
//

import Foundation

/// View model for coin home view
class CoinHomeViewModel: NSObject {
    
    private(set) var coins: [CryptoCoin]
    private(set) var filteredCoins: [CryptoCoin]
    var isLoadingList : Bool? = false
    var tableReloadsHandler: (() -> Void)?
    var selectedOptions: Set<FilterOption> = []
    var errorHandler: ((_ errorMessage: String) -> Void)?
    private var searchUrl: String
    
    /// Initialisation
    /// - Parameters:
    ///   - searchUrl: search url for coin data
    ///   - coins: coins data mainly for testing
    init(searchUrl: String, coins: [CryptoCoin] = []) {
        self.searchUrl = searchUrl
        self.coins = coins
        self.filteredCoins = coins
    }
    
    /// Fetch coins from server
    func fetchCoins() {
        // API call fetching coins
        CoinDetailsService.fetchCoinDetails(searchUrl) { [weak self] coinsData, error in
            guard let self else { return }
            if let coinsData {
                self.coins = coinsData
                self.filteredCoins = coinsData
                self.isLoadingList = false
                self.tableReloadsHandler?()
            }
            if let error = error {
                self.errorHandler?(error.rawValue)
            }
        }
    }
    
    /// To apply search text and filter option selected
    /// - Parameters:
    ///   - searchText: search text
    ///   - option: filter option selection
    func searchAndFilter(withText searchText: String, withOption option: FilterOption?) {
        // Toggle filter option in selectedOptions
        if let option = option {
            if selectedOptions.contains(option) {
                selectedOptions.remove(option)
            } else {
                selectedOptions.insert(option)
            }
        }
        
        // Apply search and filter criteria
        applyFilters(searchText: searchText)
    }
    
    /// To apply search text and filter option selected
    /// - Parameter searchText: search text
    private func applyFilters(searchText: String = "") {
        var results = coins
        
        // Filter by search text if provided
        let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedText.isEmpty {
            results = results.filter { coin in
                coin.name.lowercased().contains(trimmedText.lowercased()) ||
                coin.symbol.lowercased().contains(trimmedText.lowercased())
            }
        }
        
        // Apply each selected filter option
        for option in selectedOptions {
            switch option {
            case .activeCoins:
                results = results.filter { $0.isActive }
            case .inactiveCoins:
                results = results.filter { !$0.isActive }
            case .newCoins:
                results = results.filter { $0.isNew }
            case .onlyCoins:
                results = results.filter { $0.type == "coin" }
            case .onlyTokens:
                results = results.filter { $0.type == "token" }
            }
        }
        
        // Update filtered coins and notify the view controller
        self.filteredCoins = results
        self.tableReloadsHandler?()
    }
    
    /// Refresh coins
    func refreshCoinsData() {
        fetchCoins() // Re-fetches the coins
        selectedOptions.removeAll() // Clear any selected filters
    }
}
