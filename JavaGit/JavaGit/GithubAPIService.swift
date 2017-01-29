import Foundation
import Moya

enum GithubRepositorySort {
    static var stars = "stars"
    static var forks = "forks"
}

enum GithubAPIService {
    case repositories(query: String, sort: String, page: Int)
    case pullRequests(repositoryName: String, repositoryOwner: String)
}

extension GithubAPIService {

    private static var manager: Manager {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 15 // low timeout

        let manager = Manager(configuration: configuration)
        manager.startRequestsImmediately = false
        return manager
    }

    static var provider: RxMoyaProvider<GithubAPIService> {
        return RxMoyaProvider<GithubAPIService>(manager: manager)
    }
}

extension GithubAPIService: TargetType {

    var baseURL: URL { return URL(string: "https://api.github.com")! }

    var path: String {
        switch self {
        case .repositories:
            return "/search/repositories"
        case .pullRequests(let name, let owner):
            return "/repos/\(owner)/\(name)/pulls"
        }
    }

    var method: Moya.Method {
        switch self {
        default: return .get
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .repositories(let query, let sort, let page): return ["q": query, "sort": sort, "page": page]
        case .pullRequests: return ["state": "all"]
        }
    }

    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        default: return .request
        }
    }

}
