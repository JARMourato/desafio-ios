import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

extension Result {

    var value: T? {
        guard case .success(let v) = self else { return nil }
        return v
    }

    var error: Error? {
        guard case .failure(let e) = self else { return nil }
        return e
    }
}
