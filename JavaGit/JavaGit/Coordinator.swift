import UIKit
import RxSwift
import SafariServices

final class Coordinator {

    fileprivate var window: UIWindow
    fileprivate let handler = GithubHandler(apiClient: GithubClient())

    var uiTesting: Bool = false

    init(window: UIWindow) {
        self.window = window
    }
}

extension Coordinator {

    var navVC: NavVC {
        return UIStoryboard(storyboard: .main).instantiateVC(of: NavVC.self)
    }

    var searchVC: TableVC {
        let tableVC = UIStoryboard(storyboard: .main).instantiateVC(of: TableVC.self)
        tableVC.loadMoreCapable = true
        tableVC.loadMoreOffset = 15

        let fetcher = Fetcher<[GithubRepository]> { (page) -> Observable<[GithubRepository]> in
            return self.handler.popularJavaRepositories(page: page ?? 1).map { $0.repositories ?? [] }
        }

        let searchVM = GenericTableVM<GithubRepository, GithubRepositoryCell>(dataFetcher: fetcher) { (cell, item) in
            cell.setup(with: item)
        }
        searchVM.onSelectedItem = selected

        searchVM.title = "Github JavaPop"
        tableVC.inject(dependency: searchVM)

        return tableVC
    }

    func pullsVC(for item: GithubRepository) -> TableVC? {
        guard let name = item.name, let owner = item.owner?.login else { return nil }
        let tableVC = UIStoryboard(storyboard: .main).instantiateVC(of: TableVC.self)

        let fetcher = Fetcher<[GithubPullRequest]> { (_) -> Observable<[GithubPullRequest]> in
            return self.handler.pullRequests(inRepo: name, ofOwner: owner)
        }

        let pullsVM = GenericTableVM<GithubPullRequest, GithubPullRequestCell>(dataFetcher: fetcher) { (cell, item) in
            cell.setup(with: item)
        }
        pullsVM.onSelectedItem = pullSelected
        pullsVM.title = item.name ?? ""
        pullsVM.headerViewFromItems = pullsHeaderView

        tableVC.inject(dependency: pullsVM)

        return tableVC
    }
}

extension Coordinator {

    func pullsHeaderView(items: [GithubPullRequest]) -> UIView? {
        guard !items.isEmpty else { return nil }
        let header = PullsHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        let openPulls = items.filter { $0.state == State.open }.count
        let closedPulls = items.count - openPulls
        let openString = "\(openPulls) open"
        let closedString = "\(closedPulls) closed"

        let attributedString = NSMutableAttributedString(string: "\(openString) / \(closedString)", attributes: nil)
        let range = (attributedString.string as NSString).range(of: openString)

        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(hexString: "dd910c"), range: range)
        header.headerLabel.attributedText = attributedString

        return header
    }

    func selected(repo: GithubRepository) {
        guard let pulls = pullsVC(for: repo) else { return }
        pushViewController(pulls)
    }

    func pullSelected(pull: GithubPullRequest) {
        guard !uiTesting else { return }
        guard let urlString = pull.url, let url = URL(string: urlString) else { return }
        if #available(iOS 9.0, *) {
            let svc = SFSafariViewController(url: url)
            window.rootViewController?.present(svc, animated: true, completion: nil)
        } else {
            guard UIApplication.shared.canOpenURL(url) else { return }
            UIApplication.shared.openURL(url)
        }
    }
}

extension Coordinator {

    func appStart() {
        let rootVC = navVC
        rootVC.viewControllers = [searchVC]
        window.rootViewController = rootVC
    }

    func pushViewController(_ viewController: UIViewController) {
        guard let rootVC = window.rootViewController as? UINavigationController else { return }
        rootVC.pushViewController(viewController, animated: true)
    }
}
