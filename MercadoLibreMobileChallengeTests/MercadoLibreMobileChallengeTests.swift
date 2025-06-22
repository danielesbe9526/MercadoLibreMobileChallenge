//
//  MercadoLibreMobileChallengeTests.swift
//  MercadoLibreMobileChallengeTests
//
//  Created by Daniel Beltran on 21/06/25.
//

import XCTest
@testable import MercadoLibreMobileChallenge

@MainActor
class MercadoLibreMobileTests: XCTestCase {
    var session: SessionProtocol!
    var apiInteractor: APIInteractor!
    var viewModel: HomeViewModel!
    var viewModelDestination: DestinationViewModel!

    override func setUp() {
        super.setUp()
        viewModelDestination = DestinationViewModel()
        session = SessionMockedSucces()
        apiInteractor = APIInteractor(session: session)
        let api = MLRepositoryCore(apiInteractor: apiInteractor)
        viewModel = HomeViewModel(destination: viewModelDestination, apiInteractor: api)
    }
    
    override func tearDown() {
        viewModel = nil
        apiInteractor = nil
        session = nil
        viewModelDestination = nil
        super.tearDown()
    }
    
    func testCalculatePrice_ValidInstallments() {
        let result = viewModel.calculatePrice(installments: "12 de 100.0", price: 1200)
        XCTAssertEqual(result.message, "12 cuotas de $ 100")
        XCTAssertTrue(result.samePrice)
    }
    
    func testCalculatePrice_InvalidFormat() {
        let result = viewModel.calculatePrice(installments: "Invalid", price: 1200.0)
        XCTAssertEqual(result.message, "Formato inválido")
    }
    
    func testGetHomeProducts_Success() async {
        session = SessionMockedSucces()
        apiInteractor = APIInteractor(session: session)
        let api = MLRepositoryCore(apiInteractor: apiInteractor)
        viewModel = HomeViewModel(destination: DestinationViewModel(), apiInteractor: api)
        
        viewModel.getHomeProducts()
        XCTAssertFalse(viewModel.requestFails)
    }
    
    func testGetHomeProducts_Failure() async {
        let expectation = XCTestExpectation(description: "Fetch products")
        session = SessionMockedFailure()
        apiInteractor = APIInteractor(session: session)
        let api = MLRepositoryCore(apiInteractor: apiInteractor)
        viewModel = HomeViewModel(destination: DestinationViewModel(), apiInteractor: api)
        
        viewModel.getHomeProducts()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.viewModel.requestFails)
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 2)
    }
    
    func testGetDetailProduct_Success() async {
        session = SessionMockedSucces()
        apiInteractor = APIInteractor(session: session)
        let api = MLRepositoryCore(apiInteractor: apiInteractor)
        viewModel = HomeViewModel(destination: DestinationViewModel(), apiInteractor: api)
        
        viewModel.getDetailProduct()
        XCTAssertFalse(viewModel.requestFails)
    }
    
    func testGetDetailProduct_Failure() async {
        let expectation = XCTestExpectation(description: "Fetch product detail")
        
        session = SessionMockedFailure()
        apiInteractor = APIInteractor(session: session)
        let api = MLRepositoryCore(apiInteractor: apiInteractor)
        viewModel = HomeViewModel(destination: DestinationViewModel(), apiInteractor: api)
        
        viewModel.getDetailProduct()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.viewModel.requestFails)
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 2)
    }
    
    func testInitialNavigationIsEmpty() {
        XCTAssertTrue(viewModelDestination.isNavigationEmpty, "Navigation should be empty initially")
    }
    
    func testNavigateToAddsDestination() {
        let destination = ScreenDestination.homeView
        viewModelDestination.navigate(to: destination)
        
        XCTAssertFalse(viewModelDestination.isNavigationEmpty, "Navigation should not be empty after adding a destination")
        XCTAssertEqual(viewModelDestination.destination.last, destination, "Last destination should be the one added")
    }
    
    func testNavigateToRemovesDuplicates() {
        let destination = ScreenDestination.homeView
        viewModelDestination.navigate(to: destination)
        viewModelDestination.navigate(to: destination)
        
        XCTAssertEqual(viewModelDestination.destination.count, 1, "There should be no duplicate destinations")
    }
    
    func testNavigateBackRemovesLast() {
        viewModelDestination.navigate(to: .homeView)
        viewModelDestination.navigate(to: .productDetailView)
        viewModelDestination.navigateBack()
        
        XCTAssertEqual(viewModelDestination.destination.count, 1, "Should have one destination left after navigating back")
        XCTAssertEqual(viewModelDestination.destination.last, .homeView, "Last destination should be homeView")
    }
    
    func testPopToScreen() {
        viewModelDestination.navigate(to: .homeView)
        viewModelDestination.navigate(to: .productDetailView)
        viewModelDestination.navigate(to: .developerView)
        viewModelDestination.popToScreen(.homeView)
        
        XCTAssertEqual(viewModelDestination.destination.count, 1, "Should only contain the homeView after popping")
        XCTAssertEqual(viewModelDestination.destination.last, .homeView, "Last destination should be homeView")
    }
}

final public class SessionMockedSucces: SessionProtocol {
    public func request<T>(url: URL, for type: T.Type) async throws -> Result<T, any Error> where T : Decodable {
        
        let mockData = try JSONDecoder().decode(T.self, from: Data())
        return .success(mockData)
    }
}

final public class SessionMockedFailure: SessionProtocol {
    public func request<T>(url: URL, for type: T.Type) async throws -> Result<T, any Error> where T : Decodable {
        return .failure(ResponseError.badRequest)
    }
}
