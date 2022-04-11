import Reachability

enum GithubGraphQLFactory {
    static func make() -> GithubGraphQLViewController {
        let viewController = GithubGraphQLViewController()
        viewController.viewModel = GithubGraphQLViewModel(isConected: Reachability.isConnected)
        
        return viewController
    }
}
