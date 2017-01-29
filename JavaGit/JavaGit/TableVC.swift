import UIKit

final class TableVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    fileprivate let refreshControl = UIRefreshControl()
    fileprivate var viewModel: TableViewModel!

    var loadMoreCapable: Bool = false
    var loadMoreOffset: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        assertDependencies()

        viewModel.setup(table: tableView)
        viewModel.setup(refreshControl: refreshControl)

        tableView.addSubview(refreshControl)

        tableView.delegate = self
        navigationController?.navigationBar.topItem?.title = ""
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = viewModel.title
    }
}

extension TableVC: Injectable {

    func inject(dependency: TableViewModel) {
        viewModel = dependency
    }

    func assertDependencies() {
        assert(viewModel != nil, "The \(String(describing: type(of: self))) type needs a viewModel")
    }
}

extension TableVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none

        guard loadMoreCapable else { return }

        let rowToAskForMore = tableView.numberOfRows(inSection: indexPath.section) - 1 - loadMoreOffset
        if indexPath.row == rowToAskForMore {
            viewModel.loadMoreData()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelect(atIndex: indexPath)
    }
}
