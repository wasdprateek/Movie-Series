//
//  MovieSeriesTests.swift
//  MovieSeriesTests
//
//  Created by Prateek Kumar Rai on 20/02/25.
//

import XCTest
@testable import MovieSeries
final class MovieSeriesTests:XCTestCase{
    var viewModel: ViewModel!

        override func setUp() {
            super.setUp()
            viewModel = ViewModel()
        }

        override func tearDown() {
            viewModel = nil
            super.tearDown()
        }

        func testFetchMoviesAndTvSeries() {
            let expectation = self.expectation(description: "Fetching data")
            
            viewModel.fetchMoviesAndTvSeries()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                XCTAssertFalse(self.viewModel.movies.isEmpty, "Movies should not be empty")
                XCTAssertFalse(self.viewModel.tvSeries.isEmpty, "TV Series should not be empty")
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 5, handler: nil)
        }
}
