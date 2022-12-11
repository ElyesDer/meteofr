//
//  NetworkTests.swift
//  meteoFrTests
//
//  Created by Elyes Derouich on 11/12/2022.
//

import XCTest
import Combine
@testable import meteoFr

final class NetworkTests: XCTestCase {
    
    var zut: DataServiceProviderProtocol!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        zut = Requester()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_request_get_weather() async throws {
        
        // given
        let endPoint: APIEndpoint = .init(
            method: .get,
            endURL: .latlong(lat: 0.0, lon: 0.0))
        
        // do
        _ = try await zut.request(from: endPoint, of: WeatherInfo.self)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
