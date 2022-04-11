struct RemoteRepoLoader: RepoLoading {
    let fetcher: Fetching = Fetcher()
    
    func fetch(
        phrase: String,
        filter: SearchRepositoriesQuery.Filter? = nil,
        completion: @escaping FetcherCompletion) {
            
        fetcher.search(
            phrase: phrase,
            filter: filter,
            cachPolicy: .fetchIgnoringCacheData,
            completion: completion)
    }
}
