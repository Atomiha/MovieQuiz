//
//  ArrayTests.swift
//  MovieQuiz
//
//  Created by Михаил Атоян on 14.10.2024.
//

import Foundation
import XCTest

@testable import MovieQuiz

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        let array = [1, 2, 4, 3, 5]
        
        let value = array[safe: 2]
        
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 4)
    }
    func testGetValueOutOfRange() throws {
        let array = [1, 2, 3, 4, 5]
        
        let value = array[safe: 20]
        
        XCTAssertNil(value)
    }
}
