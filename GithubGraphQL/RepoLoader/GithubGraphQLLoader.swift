import Foundation
import Reachability

protocol DataLoading {
    func load(isConnected: Bool,
              phrase: String,
              filter: SearchRepositoriesQuery.Filter?,
              completion: @escaping FetcherCompletion)
}

struct GithubGraphQLLoader: DataLoading {
    
    private let localLoader: RepoLoading = LocalRepoLoader()
    private let remoteLoader: RepoLoading = RemoteRepoLoader()
    
    func load(
        isConnected: Bool,
        phrase: String,
        filter: SearchRepositoriesQuery.Filter? = nil,
        completion: @escaping FetcherCompletion) {
        
        if isConnected {
            remoteLoader.fetch(phrase: phrase, filter: filter, completion: completion)
        } else {
            localLoader.fetch(phrase: phrase, filter: filter, completion: completion)
        }
    }
}

extension Reachability {
    public static var isConnected: Bool {
        guard let reachability = try? Reachability() else { return false }
 
        return reachability.connection != .unavailable
    }
}
