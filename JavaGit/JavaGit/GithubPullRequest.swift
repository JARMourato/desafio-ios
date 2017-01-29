import Foundation
import ObjectMapper

enum GithubPullRequestKeys: String {
    case id, title, body, html_url, user, state
}

enum State: String {
    case open, closed
}

public struct GithubPullRequest: Mappable {
    var id: Int?
    var url: String?
    var body: String?
    var title: String?
    var owner: GithubUser?
    var state: State?

    public init?(map: Map) { }

    mutating public func mapping(map: Map) {
        id <- map[GithubPullRequestKeys.id.rawValue]
        url <- map[GithubPullRequestKeys.html_url.rawValue]
        body <- map[GithubPullRequestKeys.body.rawValue]
        title <- map[GithubPullRequestKeys.title.rawValue]
        owner <- map[GithubPullRequestKeys.user.rawValue]
        var stateString: String? = nil
        stateString <- map[GithubPullRequestKeys.state.rawValue]
        state = State(rawValue: stateString ?? "")
    }
}
