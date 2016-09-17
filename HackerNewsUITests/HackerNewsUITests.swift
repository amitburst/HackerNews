//
//  HackerNewsUITests.swift
//  HackerNewsUITests
//
//  Copyright (c) 2015 Amit Burstein. All rights reserved.
//  See LICENSE for licensing information.
//

import XCTest
@testable import HackerNews

class HackerNewsUITests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    continueAfterFailure = false
    XCUIApplication().launch()
  }
  
  func testUIElementsVisible() {
    let app = XCUIApplication()
    XCTAssertEqual(app.label, "Hacker News")
    XCTAssertEqual(app.navigationBars.element.identifier, "Hacker News")
    XCTAssertEqual(app.segmentedControls.buttons.element(boundBy: 0).label, "Top")
    XCTAssertEqual(app.segmentedControls.buttons.element(boundBy: 1).label, "Newest")
    XCTAssertEqual(app.segmentedControls.buttons.element(boundBy: 2).label, "Show HN")
  }
}
