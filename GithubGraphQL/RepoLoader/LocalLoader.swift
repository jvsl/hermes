protocol RepoLoading {
    func fetch(
        phrase: String,
        filter: SearchRepositoriesQuery.Filter?,
        completion: @escaping FetcherCompletion)
}

struct LocalRepoLoader: RepoLoading {
    let fetcher: Fetching = Fetcher()
    
    func fetch(
        phrase: String,
        filter: SearchRepositoriesQuery.Filter? = nil,
        completion: @escaping FetcherCompletion) {
        
        fetcher.search(
            phrase: phrase,
            filter: filter,
            cachPolicy: .returnCacheDataDontFetch,
            completion: completion)
    }
}
