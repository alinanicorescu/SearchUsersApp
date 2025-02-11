//
//  SearchUsersServiceTests.swift
//  SearchUsersAppTests
//
//  Created by Alina Nicorescu on 11.02.2025.
//

import XCTest
import Combine
@testable import SearchUsersApp

final class SearchUsersServiceTests: XCTestCase {
    
    let seed = "Abc"
    let resultsPerPage = 20
    let page = 1
    var usersService: UsersServiceProtocol?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        usersService = UsersService()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func testUsersFetchCall() throws {
        XCTAssertNotNil(usersService)
        let data = usersService?.searchUsers(seed: seed,
                                             page: page,
                                             resultsPerPage: resultsPerPage)
        XCTAssertNotNil(data)
        
        guard let data = data else {
            XCTFail()
            return
        }
        _ = data.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                XCTFail("An error occurred \(error.localizedDescription)")
            }
        }
                      ,receiveValue: {value in
            XCTAssertEqual(value.results.count, 20)
        }
        )
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
