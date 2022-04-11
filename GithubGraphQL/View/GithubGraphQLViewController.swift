import UIKit

final class GithubGraphQLViewController: UIViewController {
    
    var viewModel: GithubGraphQLViewModel?
    
    private let tableView = UITableView()
    private lazy var dataSource = makeDataSource()
    private let query = "graphql"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupView()

        viewModel?.delegate = self
        viewModel?.search(phrase: query)
    }
    
    private func setupView() {
        title = viewModel?.titleMessage()
        navigationController?.navigationBar.barTintColor = UIColor.init(
            displayP3Red: 4/255, green: 174/255, blue: 185/255, alpha: 0.6)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.prefetchDataSource = self
        tableView.delegate = self
        tableView.dataSource = self.dataSource
        tableView.register(
            GithubGraphQLCell.self,
            forCellReuseIdentifier: GithubGraphQLCell.reuseIdentifier)
    
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        tableView.backgroundColor = UIColor.init(
            displayP3Red: 244/255, green: 243/255, blue: 240/255, alpha: 1)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 91
    
    }
}

extension GithubGraphQLViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.openRepo(at: indexPath.row)
    }
}

extension GithubGraphQLViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
      viewModel?.prefechImages(indexPaths: indexPaths)
      viewModel?.callNextPageIfNeeded(indexPaths: indexPaths)
  }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        viewModel?.cancelPrefetchingImages(indexPaths: indexPaths)
    }
}

extension GithubGraphQLViewController {
    func updateDataSource() {
        guard let viewModel = self.viewModel else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Int, GithubRepoCellViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.githubRepositories, toSection: 0)
      
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension GithubGraphQLViewController: GithubGraphQLViewModelDelegate {
    func offlineMode(title: String) {
        self.title = title
    }

    func startLoading() {
        LLSpinner.spin(style: .large, backgroundColor: UIColor(white: 0, alpha: 0.6))
    }
    
    func stopLoading() {
        LLSpinner.stop()
    }
    
    func openUrlInBrowser(_ url: URL) {
        UIApplication.shared.open(url)
    }
    
    func didFetchData() {
        updateDataSource()
    }
    
    func didFetchFail(action: @escaping () -> Void) {

    }
}

private extension GithubGraphQLViewController {
    func makeDataSource() -> UITableViewDiffableDataSource<Int, GithubRepoCellViewModel> {

        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, repository in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: GithubGraphQLCell.reuseIdentifier,
                    for: indexPath
                ) as? GithubGraphQLCell
                
                cell?.setup(viewModel: repository)

                return cell
            }
        )
    }
}
