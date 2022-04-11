import Foundation
import Kingfisher
import Reachability

protocol GithubGraphQLViewModelDelegate: AnyObject {
    func didFetchData()
    func didFetchFail(action: @escaping () -> Void)
    func openUrlInBrowser(_ url: URL)
    
    func startLoading()
    func stopLoading()
}

final class GithubGraphQLViewModel {
    
    var githubRepositories: [GithubRepoCellViewModel] = []
    weak var delegate: GithubGraphQLViewModelDelegate?
    
    private var currentPageInfo: SearchRepositoriesQuery.Data.Search.PageInfo?
    private var isFetchInProgress = false
    private let loader: DataLoading
    private let phrase = "graphql"
    private let isConnected: Bool
    
    private var currentCount: Int {
        return githubRepositories.count
    }
    
    init(isConected: Bool, loader: DataLoading = GithubGraphQLLoader()) {
        self.loader = loader
        self.isConnected = isConected
    }

    func callNextPageIfNeeded(indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            nextPage()
        }
    }
    
    func prefechImages(indexPaths: [IndexPath]) {
        let urls = indexPaths.compactMap { githubRepositories[$0.row].avatarURL }
        ImagePrefetcher(urls: urls).start()
        
    }
    
    func cancelPrefetchingImages(indexPaths: [IndexPath]) {
        let urls = indexPaths.compactMap { githubRepositories[$0.row].avatarURL }
        ImagePrefetcher(urls: urls).stop()
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= currentCount - 6
    }
    
    func openRepo(at index: Int) {
        if let url = URL(string: githubRepositories[index].url) {
            delegate?.openUrlInBrowser(url)
        }
    }
    
    func search(
        phrase: String,
        filter: SearchRepositoriesQuery.Filter? = nil,
        isNextPage: Bool = false,
        completion: (() -> Void)? = nil) {
            
        DispatchQueue.main.async {
            self.startLoading(isNextPage)
        }
        
        self.loader.load(
            isConnected: self.isConnected,
            phrase: phrase,
            filter: filter) { [weak self] response in
            
            guard let self = self else { return }
           
            switch response {
            case .failure:
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.didFetchFail(
                        action: { self.search(phrase: self.phrase) }
                    )
                }
            case let .success(results):
                DispatchQueue.main.async {
                    self.currentPageInfo = results.pageInfo
                    self.isFetchInProgress = false
                    self.parse(with: results.repos)
                    self.log(self.githubRepositories, pageInfo: results.pageInfo)
                    self.delegate?.didFetchData()
                }
            }
           
            DispatchQueue.main.async {
                self.stopLoading(isNextPage)
                completion?()
            }
        }
    }
    
    func nextPage(completion: (() -> Void)? = nil) {
    
        guard !self.isFetchInProgress else {
            return
        }

        if let
            pageInfo = self.currentPageInfo,
            pageInfo.hasNextPage,
            let cursor = try? Cursor(jsonValue: pageInfo.endCursor.jsonValue) {
            
            self.isFetchInProgress = true
            
            DispatchQueue.global(qos: .userInitiated).async {
                self.search(
                    phrase: self.phrase,
                    filter: SearchRepositoriesQuery.Filter.after(cursor),
                    isNextPage: true,
                    completion: completion)
            }
        }
    }
    
    func titleMessage() -> String {
        if isConnected {
            return "GraphQL Github Repositories"
        }
        
        return "GraphQL Github Repositories(offline)"
    }
    
    private func startLoading(_ isNextPage: Bool) {
        guard !isNextPage else { return }
        self.delegate?.startLoading()
    }
    
    private func stopLoading(_ isNextPage: Bool) {
        guard !isNextPage else { return }
        self.delegate?.stopLoading()
    }
    
    private func parse(with repositoryDetails: [RepositoryDetails]) {
        self.githubRepositories.append(contentsOf: repositoryDetails.map {
            GithubRepoCellViewModel(
                name: $0.name,
                url: $0.url,
                owner: Owner(login: $0.owner.login, avatar: $0.owner.avatarUrl),
                stargazers: Stargazers(totalCount: $0.stargazers.totalCount)
            )
        })
    }
    
    private func log(
        _ data: [GithubRepoCellViewModel], pageInfo: SearchRepositoriesQuery.Data.Search.PageInfo) {
        
        #if DEBUG
        print("pageInfo: \n")
        print("hasNextPage: \(pageInfo.hasNextPage)")
        print("hasPreviousPage: \(pageInfo.hasPreviousPage)")
        print("startCursor: \(String(describing: pageInfo.startCursor))")
        print("endCursor: \(String(describing: pageInfo.endCursor))")
        print("\n")
        data.forEach { repository in
            print("Name: \(repository.name)")
            print("Path: \(repository.url)")
            print("Owner: \(repository.owner.login)")
            print("avatar: \(repository.owner.avatar)")
            print("Stars: \(repository.stargazers.totalCount)")
            print("\n")
        }
        #endif
    }
}
