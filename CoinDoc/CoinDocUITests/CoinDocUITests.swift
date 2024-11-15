//
//  CoinDocUITests.swift
//  CoinDocUITests
//
//  Created by Aswin S on 11/11/24.
//

import XCTest

/// UI test for the app
class CoinDocUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        
        // Launch the app
        app = XCUIApplication()
        app.launchArguments.append("--uitests")
        app.launch()
        
        // Continue after failure (optional)
        continueAfterFailure = false
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    /// Test the coin table has content
    func testCoinListDisplay() {
        let tableView = app.tables["coinTableView"]
        XCTAssertTrue(tableView.exists)
        let loadingIndicator = app.activityIndicators["loadingIndicator"]
                
        let existsPredicate = NSPredicate(format: "exists == false")
        expectation(for: existsPredicate, evaluatedWith: loadingIndicator, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
                
        let firstCell = tableView.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.exists)
    }

    /// Test applying filter options
    func testFilterByActiveCoins() {
        let filterButton = app.buttons["filterButton"]
        XCTAssertTrue(filterButton.exists)
        filterButton.tap()

        let activeCoinsOption = app.tables.cells.staticTexts["Active Coins"]
        XCTAssertTrue(activeCoinsOption.exists)
        activeCoinsOption.tap()

        let tableView = app.tables["coinTableView"]
        XCTAssertTrue(tableView.exists)
        
        let firstCell = tableView.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.exists)
    }

    /// Test search functionality
    func testSearchFunctionality() {
        // Tap on the search bar
        let searchButton = app.buttons["searchButton"]
        XCTAssertTrue(searchButton.exists)
        searchButton.tap()
        
        let searchBar = app.otherElements["searchBar"]
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: searchBar, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)

        XCTAssertTrue(searchBar.exists)
        searchBar.tap()
        searchBar.typeText("Bitcoin")
        
        let tableView = app.tables["coinTableView"]
        let firstCell = tableView.cells.element(boundBy: 0)
        let firstCellLabel = firstCell.staticTexts["Bitcoin"]
        XCTAssertTrue(firstCellLabel.exists)
        XCTAssertTrue(firstCellLabel.label.contains("Bitcoin"))
    }

    /// Test that no coins are listed when searching for a non-existent coin
    func testSearchNoResults() {
        // Tap on the search bar
        let searchButton = app.buttons["searchButton"]
        XCTAssertTrue(searchButton.exists)
        searchButton.tap()
        
        let searchBar = app.otherElements["searchBar"]
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: searchBar, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)

        XCTAssertTrue(searchBar.exists)
        searchBar.tap()
        searchBar.typeText("NonExistentCoin")
        
        let tableView = app.tables["coinTableView"]
        let cells = tableView.cells
        XCTAssertEqual(cells.count, 0)
    }

    /// Test refreshing the coins table
    func testRefreshCoinsData() {
        let tableView = app.tables["coinTableView"]
        XCTAssertTrue(tableView.exists)
        
        let startCoordinate = tableView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0))
        let endCoordinate = tableView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 3.0))
        startCoordinate.press(forDuration: 1, thenDragTo: endCoordinate)
        
        let firstCell = tableView.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.exists)
    }
}
