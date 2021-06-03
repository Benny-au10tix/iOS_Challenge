//
//  Candidate_AppTests.swift
//  Candidate AppTests
//
//  Created by Assaf Halfon on 30/05/2021.
//

import XCTest
@testable import Candidate_App

class Candidate_AppTests: XCTestCase {
    
    // MARK: - Properties
    
    var sut: FetchViewController!
    
    
    // MARK: - Test Case Life Cycle

    override func setUpWithError() throws {
        do {
            try super.setUpWithError()
        } catch let error {
            throw error
        }
        self.sut = FetchViewController()
    }

    override func tearDownWithError() throws {
        self.sut = nil
        do {
            try super.tearDownWithError()
        } catch let error {
            throw error
        }
    }
    
    func testFetchButtonPosition() {
        self.sut.setupButton()
        XCTAssertEqual(self.sut.fetchButton?.title(for: .normal),
                       "Show Dogecoin Rate")
    }

}
