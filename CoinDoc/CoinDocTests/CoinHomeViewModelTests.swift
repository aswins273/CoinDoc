//
//  CoinHomeViewModelTests.swift
//  CoinDocTests
//
//  Created by Aswin S on 14/11/24.
//

import XCTest
@testable import CoinDoc

/// Unit test case for Coin Home ViewModel
class CoinHomeViewModelTests: XCTestCase {
    
    var viewModel: CoinHomeViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = CoinHomeViewModel(searchUrl: APIConstants.searchUrl, coins: mockCoins())
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    /// For mocking crypto coins
    /// - Returns: array of crypto coins
    private func mockCoins() -> [CryptoCoin] {
        let coin1 = CryptoCoin(name: "Bitcoin", symbol: "BTC", isNew: true, isActive: false, type: "coin")
        let coin2 = CryptoCoin(name: "Ethereum", symbol: "ETH", isNew: false, isActive: true, type: "token")
        let coin3 = CryptoCoin(name: "Ripple", symbol: "XRP", isNew: false, isActive: false, type: "coin")
        let coin4 = CryptoCoin(name: "Cardano", symbol: "ADA", isNew: true, isActive: true, type: "coin")
        return [coin1, coin2, coin3, coin4]
    }
    
    /// Test fetch coin api call
    func testFetchCoins() {
        let expectation = self.expectation(description: "fetchCoins")
        
        viewModel.fetchCoins()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.filteredCoins.count, self.viewModel.coins.count)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchCoinsSuccess() {
        viewModel.fetchCoins()

        XCTAssertEqual(viewModel.filteredCoins.count, viewModel.coins.count)
    }

    /// Test for search bar functionality
    func testSearchWithText() {
        viewModel.searchAndFilter(withText: "Bitcoin", withOption: nil)
        
        XCTAssertEqual(viewModel.filteredCoins.count, 1)
        XCTAssertEqual(viewModel.filteredCoins.first?.name, "Bitcoin")
    }
    
    /// Test for non existent coin
    func testSearchWithNoResults() {
        viewModel.searchAndFilter(withText: "NonExistentCoin", withOption: nil)
        
        XCTAssertEqual(viewModel.filteredCoins.count, 0)
    }
    
    /// Test for filter option selection
    func testApplyFilter1Options() {
        viewModel.searchAndFilter(withText: "", withOption: .activeCoins)
        XCTAssertEqual(viewModel.filteredCoins.count, 2)
        XCTAssertEqual(viewModel.filteredCoins.first?.name, "Ethereum")
                
        viewModel.searchAndFilter(withText: "", withOption: .onlyCoins)
        XCTAssertEqual(viewModel.filteredCoins.count, 1)
        XCTAssertEqual(viewModel.filteredCoins.first?.name, "Cardano")
        
        viewModel.searchAndFilter(withText: "", withOption: .inactiveCoins)
        XCTAssertEqual(viewModel.filteredCoins.count, 0)
        XCTAssertNil(viewModel.filteredCoins.first?.name)
    }
    
    /// Test for filter option selection
    func testApplyFilter2Options() {
        viewModel.searchAndFilter(withText: "", withOption: .newCoins)
        XCTAssertEqual(viewModel.filteredCoins.count, 2)
        XCTAssertEqual(viewModel.filteredCoins.first?.name, "Bitcoin")
                
        viewModel.searchAndFilter(withText: "", withOption: .onlyTokens)
        XCTAssertEqual(viewModel.filteredCoins.count, 0)
        XCTAssertNil(viewModel.filteredCoins.first?.name)
        
        viewModel.searchAndFilter(withText: "", withOption: .onlyTokens)
        XCTAssertEqual(viewModel.selectedOptions.contains(.onlyTokens), false)
    }
    
    /// API test with invalid url
    func testApiError() {
        viewModel = CoinHomeViewModel(searchUrl: "invalid-url")
        viewModel.fetchCoins()
        
        let expectation = XCTestExpectation(description: "Trigger API error")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.coins.count, 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
