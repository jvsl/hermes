import Foundation

struct GithubRepoCellViewModel: Hashable
{
    let id = UUID()
    var name: String
    var url: String
    var owner: Owner
    var stargazers: Stargazers
}

extension GithubRepoCellViewModel {
    static func ==(lhs: GithubRepoCellViewModel, rhs: GithubRepoCellViewModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Owner {
    let login: String
    let avatar: String
}

struct Stargazers {
    let totalCount: Int
}
