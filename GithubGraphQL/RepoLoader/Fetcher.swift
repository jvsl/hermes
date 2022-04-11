import Apollo

typealias FetcherCompletion = (Result<RepositorySearchResult, Error>) -> Void

protocol Fetching {
    func search(
        phrase: String,
        filter: SearchRepositoriesQuery.Filter?,
        cachPolicy: CachePolicy,
        completion: @escaping FetcherCompletion)
}

struct Fetcher: Fetching {
    private let client: GraphQLClient = ApolloClient.shared
    
    func search(
        phrase: String,
        filter: SearchRepositoriesQuery.Filter? = nil,
        cachPolicy: CachePolicy,
        completion: @escaping FetcherCompletion) {
            
        self.client.searchRepositories(
            mentioning: phrase,
            filter: filter,
            cachePolicy: cachPolicy, resultHandler: completion)
    }
}
