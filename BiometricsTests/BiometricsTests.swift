//
//  BiometricsTests.swift
//  BiometricsTests
//
//  Created by Arkadiusz Pituła on 16.05.2018.
//  Copyright © 2018 Arkadiusz Pituła. All rights reserved.
//

import XCTest
@testable import Biometrics

class BiometricsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testConfiguration() {
        let configuration = TestConfiguration()
        XCTAssertNotNil(configuration.reason)
        XCTAssertNotNil(configuration.appServiceName)
    }

    func testSystemAuth() {
        let configuration = TestConfiguration()
        let systemAuth = SystemAuthentication(configuration: configuration)

        XCTAssertNotNil(systemAuth)

        do {
            try systemAuth.save(name: "Test", password: "Test")
        } catch {
            print(error)
        }
    }
}

class TestConfiguration: Configuration {
    var reason: String {
        return "Reason"
    }

    var appServiceName: String {
        return "test.test.demo"
    }
}
