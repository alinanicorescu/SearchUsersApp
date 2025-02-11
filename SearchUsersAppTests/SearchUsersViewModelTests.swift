//
//  SearchUsersViewModelTests.swift
//  SearchUsersAppTests
//
//  Created by Alina Nicorescu on 11.02.2025.
//

import XCTest
import Combine
@testable import SearchUsersApp


struct TestError: Error {
}

final class UsersServiceMock: UsersServiceProtocol {
    
    var urlString: String = ""
    var expectedResults: UsersResult?
    var expectedError: Error?
    
    init(expectedResults: UsersResult?) {
        self.expectedResults = expectedResults
    }
    
    init (expectedError: Error?) {
        self.expectedError = expectedError
    }
    
    func searchUsers(seed: String, page: Int, resultsPerPage: Int) -> AnyPublisher<UsersResult, any Error> {
        if let expectedResults = expectedResults {
            return Just(expectedResults).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else {
            return Fail(error: expectedError ?? TestError()).eraseToAnyPublisher()
        }
    }
}

final class UsersViewModelDelegateMock: UsersViewModelDelegateProtocol {
    
    var expectedResults: UsersResult?
    var fetchedExpectation: XCTestExpectation?
    var receivedExpectation: XCTestExpectation?
    var errorExpectation: XCTestExpectation?
    
    var fetchCallCount: Int = 0
    var receiveResultsCallCount: Int = 0
    var receiveErrorCallCount: Int = 0
    
    init(expectedResults: UsersResult?, fetchedExpectation: XCTestExpectation, receivedExpectation: XCTestExpectation) {
        self.expectedResults = expectedResults
        self.fetchedExpectation = fetchedExpectation
        self.receivedExpectation = receivedExpectation
        
    }
    
    init(fetchedExpectation: XCTestExpectation, errorExpectaion: XCTestExpectation) {
        self.fetchedExpectation = fetchedExpectation
        self.errorExpectation = errorExpectaion
    }
    
    func onReceivedResults(results: UsersResult) {
        receiveResultsCallCount += 1
        if receivedExpectation == nil {
            XCTFail("Test is not expected to receive results")
        } else {
            receivedExpectation?.fulfill()
            if let expectedResults = expectedResults {
                XCTAssertEqual(results.results.count, expectedResults.results.count)
                XCTAssertEqual(results.info.page, expectedResults.info.page)
            }
        }
    }
    
    func onReceivedResultsError(error: Error) {
        receiveErrorCallCount += 1
        if receivedExpectation != nil {
            XCTFail("An error occurred while receiving results \(error)")
        } else {
            errorExpectation?.fulfill()
        }
    }
    
    func onFetchedResults() {
        fetchCallCount += 1
        fetchedExpectation?.fulfill()
    }
    
    func onReceivedSeed(seed: String) {
        
    }
}

final class SearchUsersViewModelTests: XCTestCase {
    
    let seed = "Abc"
    let resultsPerPage = 20
    let page = 1
    
    var expectedResults: UsersResult?
    let expectedError = TestError()
    let fetchExpectation = XCTestExpectation(description: "This is fetchExpectation.")
    let receivedExpectation = XCTestExpectation(description: "This is receivedExpectation.")
    let errorExpectation = XCTestExpectation(description: "This is errorExpectation.")
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let fetchInfo = UsersFetchInfo(seed: seed, results: resultsPerPage, page: 1, version: "")
        expectedResults = UsersResult(results: [], info: fetchInfo)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func testFetchResults() throws {
        let  usersService = UsersServiceMock(expectedResults: expectedResults)
        let viewModelDelegateMock = UsersViewModelDelegateMock(expectedResults: expectedResults, fetchedExpectation: fetchExpectation, receivedExpectation: receivedExpectation)
        
        let viewModel = UsersViewModel(
            seed,
            resultsPerPage: resultsPerPage,
            usersService: usersService,
            delegate: viewModelDelegateMock
        )
        
        viewModel.tryFetchNextPage()
        wait(for: [fetchExpectation, receivedExpectation], timeout: 10.0)
        XCTAssertEqual(viewModelDelegateMock.fetchCallCount, 1)
        XCTAssertEqual(viewModelDelegateMock.receiveResultsCallCount, 1)
        XCTAssertEqual(viewModelDelegateMock.receiveErrorCallCount, 0)
    }
    
    func testFetchError() throws {
        let  usersService = UsersServiceMock(expectedError: TestError())
        let viewModelDelegateMock = UsersViewModelDelegateMock(fetchedExpectation: fetchExpectation, errorExpectaion: errorExpectation)
        
        let viewModel = UsersViewModel(
            seed,
            resultsPerPage: resultsPerPage,
            usersService: usersService,
            delegate: viewModelDelegateMock
        )
        
        viewModel.tryFetchNextPage()
        wait(for: [fetchExpectation, errorExpectation], timeout: 10.0)
        XCTAssertEqual(viewModelDelegateMock.fetchCallCount, 1)
        XCTAssertEqual(viewModelDelegateMock.receiveResultsCallCount, 0)
        XCTAssertEqual(viewModelDelegateMock.receiveErrorCallCount, 1)
    }
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
