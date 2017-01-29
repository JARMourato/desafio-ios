import UIKit
import RxSwift
import RxCocoa

class GenericTableVM<T, R: UITableViewCell>: TableViewModel {

    fileprivate let disposeBag = DisposeBag()
    fileprivate var items: Variable<[T]> = Variable<[T]>([])
    fileprivate let fetcher: Fetcher<[T]>
    fileprivate let cellNibName: String
    fileprivate let cellConfiguration: (_ cell: R, _ item: T) -> Void

    fileprivate var batchNumber: Int = 1

    var title: String = ""
    var headerViewFromItems: ([T]) -> UIView? = { _ in return nil }
    var onSelectedItem: (T) -> Void = { _ in }

    init(dataFetcher: Fetcher<[T]>, configureCell: @escaping (_ cell: R, _ item: T) -> Void) {
        cellNibName = String(describing: R.self)
        fetcher = dataFetcher
        cellConfiguration = configureCell
    }
}

extension GenericTableVM {

    func setup(table: UITableView) {
        let cellIdentifier: String = "\(String(describing: type(of: R.self)))Cell"
        let nib = UINib(nibName: cellNibName, bundle: Bundle.main)
        table.register(nib, forCellReuseIdentifier: cellIdentifier)

        table.tableFooterView = UIView()
        items
            .asObservable()
            .bindTo(table.rx.items(cellIdentifier: cellIdentifier, cellType: R.self)) { _, item, cell in
                self.cellConfiguration(cell, item)
            }
            .addDisposableTo(disposeBag)

        items
            .asObservable()
            .subscribe(onNext: { (items) in
                table.tableHeaderView = self.headerViewFromItems(items)
            })
            .addDisposableTo(disposeBag)

        batchNumber = 1
        fetch(batch: batchNumber) { newItems in
            self.items.value = newItems
        }
    }

    func setup(refreshControl: UIRefreshControl) {
        refreshControl.rx.controlEvent(.valueChanged)
            .flatMap { return self.fetcher.fetch() }
            .subscribe(onNext: { items in
                refreshControl.endRefreshing()
                self.items.value = items

                self.batchNumber = 1
            })
            .addDisposableTo(disposeBag)
    }

    func loadMoreData() {
        batchNumber += 1
        fetch(batch: batchNumber) { newItems in
            self.items.value += newItems
        }
    }

    func didSelect(atIndex: IndexPath) {
        onSelectedItem(self.items.value[atIndex.row])
    }
}

extension GenericTableVM {

    fileprivate func fetch(batch: Int, onCompletion: @escaping ([T]) -> Void) {
        fetcher
            .fetch(batch)
            .subscribe(onNext: onCompletion)
            .addDisposableTo(disposeBag)
    }
}
