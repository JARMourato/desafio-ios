import Foundation
import ObjectMapper

enum GithubSearchResponseKeys: String {
    case items, total_count
}

public final class GithubSearchResponse: Mappable {

    var totalCount: Int?
    var repositories: [GithubRepository]?
    var page: Int?
    var nextPage: Int?

    required public init?(map: Map) {}

    public func mapping(map: Map) {
        totalCount <- map[GithubSearchResponseKeys.total_count.rawValue]
        repositories <- map[GithubSearchResponseKeys.items.rawValue]
    }
}
