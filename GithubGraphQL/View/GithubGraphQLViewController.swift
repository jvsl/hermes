import UIKit
import SnapKit

final class GithubGraphQLViewController: UIViewController {
    private let tableView = UITableView()
    private lazy var dataSource = makeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
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
    }
}

extension GithubGraphQLViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
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


                return cell
            }
        )
    }
}
