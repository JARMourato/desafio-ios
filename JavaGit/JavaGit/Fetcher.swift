import Foundation
import RxSwift

final class Fetcher<T> {

    typealias Transform = (Int?) -> Observable<T>
    private let handler: Transform

    init(fetch: @escaping Transform) {
        handler = fetch
    }

    func fetch(_ page: Int? = nil) -> Observable<T> {
        return handler(page)
    }
}
