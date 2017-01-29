import Foundation
import ObjectMapper

enum GithubUserKeys: String {
    case id, login, avatar_url
}

struct GithubUser: Mappable {

    var id: Int!
    var login: String?
    var avatarURLString: String?

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        id <- map[GithubUserKeys.id.rawValue]
        login <- map[GithubUserKeys.login.rawValue]
        avatarURLString <- map[GithubUserKeys.avatar_url.rawValue]
    }
}
