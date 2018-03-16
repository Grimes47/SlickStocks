//
//  SlickStocksUITests.swift
//  SlickStocksUITests
//
//  Created by Adam Hogan on 3/2/18.
//  Copyright © 2018 Adam Hogan. All rights reserved.
//

import XCTest

class SlickStocksUITests: XCTestCase {
    
    private var app: XCUIApplication!
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func isPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
    
    func testNavBar() {
        let navBar = app.navigationBars["Current Market"]
        let cellNike = app.tables/*@START_MENU_TOKEN@*/.cells.staticTexts["NKE"]/*[[".cells.staticTexts[\"NKE\"]",".staticTexts[\"NKE\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        cellNike.tap()
        if isPad() {
            XCTAssert(navBar.exists, "Did not load navigation bar title")
        } else {
            XCTAssertFalse(navBar.exists, "Did not segue properly")
            let navBar2 = app.navigationBars["Stock"]
            XCTAssert(navBar2.exists)
            let button = navBar2.buttons["Current Market"]
            button.tap()
            XCTAssert(navBar.exists, "Did not segue properly")
        }
    }
    
    func testTickerDisplay() {
        let display = app.staticTexts.matching(identifier: "ticker").firstMatch
        app.tables/*@START_MENU_TOKEN@*/.cells.staticTexts["NKE"]/*[[".cells.staticTexts[\"NKE\"]",".staticTexts[\"NKE\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
        XCTAssert(display.label == "NKE", "The label did not display the proper ticker symbol")
    }
}
