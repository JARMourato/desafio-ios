import Foundation
import ObjectMapper

enum GithubRepositoryKeys: String {
    case id, name, description, forks, stargazers_count, owner
}

public struct GithubRepository: Mappable {

    var id: Int?
    var name: String?
    var owner: GithubUser?
    var description: String?
    var forks: Int?
    var stars: Int?

    public init?(map: Map) { }

    mutating public func mapping(map: Map) {
        id <- map[GithubRepositoryKeys.id.rawValue]
        name <- map[GithubRepositoryKeys.name.rawValue]
        description <- map[GithubRepositoryKeys.description.rawValue]
        owner <- map[GithubRepositoryKeys.owner.rawValue]
        forks <- map[GithubRepositoryKeys.forks.rawValue]
        stars <- map[GithubRepositoryKeys.stargazers_count.rawValue]
    }
}
