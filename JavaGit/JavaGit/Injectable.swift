import Foundation

protocol Injectable {
    associatedtype T
    func inject(dependency: T)
    func assertDependencies()
}
