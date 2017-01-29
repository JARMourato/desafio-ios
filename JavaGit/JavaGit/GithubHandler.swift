import Foundation
import RxSwift

public final class GithubHandler {

    fileprivate let client: GitAPI

    public init(apiClient: GitAPI) {
        client = apiClient
    }
}

extension GithubHandler {

    public func popularJavaRepositories(page: Int) -> Observable<GithubSearchResponse> {
        return client.search(query: "language:Java", sort: GithubRepositorySort.stars, page: page)
    }

    public func pullRequests(inRepo name: String, ofOwner owner: String) -> Observable<[GithubPullRequest]> {
        return client.pullRequests(of: name, ownedBy: owner)
    }

}
