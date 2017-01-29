import UIKit

public protocol TableViewModel {
    var title: String { get }

    func setup(table: UITableView)
    func setup(refreshControl: UIRefreshControl)
    func loadMoreData()
    func didSelect(atIndex: IndexPath)
}
