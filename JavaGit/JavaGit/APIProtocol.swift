import Foundation
import RxSwift

public protocol GitAPI {
    func search(query: String, sort: String, page: Int) -> Observable<GithubSearchResponse>
    func pullRequests(of repository: String, ownedBy user: String) -> Observable<[GithubPullRequest]>
}
