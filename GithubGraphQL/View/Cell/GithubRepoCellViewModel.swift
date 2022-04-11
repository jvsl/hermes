import Foundation

struct GithubRepoCellViewModel: Hashable
{
    let id = UUID()
    var name: String
    var url: String
    var owner: Owner
    var stargazers: Stargazers
    
    var avatarURL: URL? {
        return URL(string: owner.avatar)
    }
    
    var stars: Double {
        let totalAcount = Double(stargazers.totalCount)
        switch totalAcount {
        case let stars where stars < 500:
            return 2
        case let stars where stars > 500 && stars < 1000:
            return 3
        case let stars where stars >= 1000:
            return 5
        default:
            return 1
        }
    }
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
