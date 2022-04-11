@testable import GithubGraphQL
import XCTest

class GithubGraphQLTests: XCTestCase {

    // Private vars are reseted by XCTestCase every test performed
    private var loader = LoaderStub()
    private var viewModelSpy = ViewModelSpy()
    private var sut: GithubGraphQLViewModel {
        let viewModel = GithubGraphQLViewModel(isConected: false, loader: loader)
        viewModel.delegate = viewModelSpy
        
        return viewModel
    }
    
    func testSearch_succesCase_shouldCallFechDataStartAndStopLoading() {
        let expectation = self.expectation(description: "loading")

        sut.search(phrase: "teste", filter: nil) {
            expectation.fulfill()
            XCTAssertEqual(self.viewModelSpy.didCallFechData, 1)
            XCTAssertEqual(self.viewModelSpy.didStartLoading, 1)
            XCTAssertEqual(self.viewModelSpy.didStopLoading, 1)
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testSearch_failureCase_shouldCallFechFailStartAndStopLoading() {
        loader.result = .failure(NSError())

        let expectation = self.expectation(description: "loading")
        
        sut.search(phrase: "teste", filter: nil) {
            expectation.fulfill()
            XCTAssertEqual(self.viewModelSpy.didFechFaild, 1)
            XCTAssertEqual(self.viewModelSpy.didStartLoading, 1)
            XCTAssertEqual(self.viewModelSpy.didStopLoading, 1)
        }


        waitForExpectations(timeout: 1, handler: nil)
    }

    func testNextPage_successCaseWith3Calls_shouldCallFechData3Times() {
        let sut = sut
        let amountOfCallsExpected = 3
        let expectation = self.expectation(description: "loading")

        sut.search(phrase: "teste", filter: nil) {
            sut.nextPage {
                sut.nextPage {
                    expectation.fulfill()
                    XCTAssertEqual(self.viewModelSpy.didCallFechData, amountOfCallsExpected)
                }
            }
        }

        waitForExpectations(timeout: 2, handler: nil)
    }
}

final class LoaderStub: DataLoading {
    
    var result: Result<RepositorySearchResult, Error> =  .success(.init(
        pageInfo: .init(
            startCursor: "startCursor",
            endCursor: "endCursos",
            hasNextPage: true,
            hasPreviousPage: false),
        repos: RepositoryDetails.fixtures(amount: 3)))
    
    func load(isConnected: Bool, phrase: String, filter: SearchRepositoriesQuery.Filter?, completion: @escaping FetcherCompletion) {
        completion(result)
    }
}

extension RepositoryDetails {
    static func fixtures(amount: Int) -> [RepositoryDetails] {
        
        let repository = RepositoryDetails(
            name: "",
            url: "",
            owner: Owner.makeUser(login: "", avatarUrl: ""),
            stargazers: Stargazer(totalCount: 1))
        
        return (0...amount).map{ _ in  repository }
        
    }
}

final class ViewModelSpy: GithubGraphQLViewModelDelegate {
    var didCallFechData = 0
    var didFechFaild = 0
    var didOpenURL = 0
    var didStartLoading = 0
    var didStopLoading = 0
    
    func didFetchData() {
        didCallFechData += 1
    }
    
    func didFetchFail(action: @escaping () -> Void) {
        didFechFaild += 1
    }
    
    func openUrlInBrowser(_ url: URL) {
        didOpenURL += 1
    }
    
    func startLoading() {
        didStartLoading += 1
    }
    
    func stopLoading() {
        didStopLoading += 1
    }
}
