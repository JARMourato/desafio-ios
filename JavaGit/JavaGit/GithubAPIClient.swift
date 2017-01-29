import Foundation
import RxSwift
import Moya_ObjectMapper
import Moya

public final class GithubClient {}

extension GithubClient: GitAPI {

    public func search(query: String, sort: String, page: Int) -> Observable<GithubSearchResponse> {
         return GithubAPIService
            .provider
            .request(.repositories(query: query, sort: sort, page: page))
            .mapObject(GithubSearchResponse.self)
    }

    public func pullRequests(of repository: String, ownedBy user: String) -> Observable<[GithubPullRequest]> {
       return
        GithubAPIService
            .provider
            .request(.pullRequests(repositoryName: repository, repositoryOwner: user))
            .mapArray(GithubPullRequest.self)
    }
}
