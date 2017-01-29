import UIKit
import Kingfisher

final class GithubRepositoryCell: UITableViewCell {

    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoDescription: UILabel!

    @IBOutlet weak var forkNumberLabel: UILabel!
    @IBOutlet weak var startNumberLabel: UILabel!

    @IBOutlet weak var repoImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userFirstAndLastNameLabel: UILabel!

}

extension GithubRepositoryCell {

    func setup(with repo: GithubRepository) {
        repoName.text = repo.name
        repoDescription.text = repo.description
        forkNumberLabel.text = "\(repo.forks ?? 0)"
        startNumberLabel.text = "\(repo.stars ?? 0)"

        usernameLabel.text = repo.owner?.login
        userFirstAndLastNameLabel.text = ""

        guard
            let urlString = repo.owner?.avatarURLString,
            let url = URL(string: urlString)
        else {
            repoImage.image = nil
            return
        }

        repoImage.kf.setImage(with: url)
    }
}
