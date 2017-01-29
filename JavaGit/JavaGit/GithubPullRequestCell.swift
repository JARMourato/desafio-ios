import UIKit
import Kingfisher

final class GithubPullRequestCell: UITableViewCell {

    @IBOutlet weak var pullName: UILabel!
    @IBOutlet weak var pullDescription: UILabel!

    @IBOutlet weak var pullImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userFirstAndLastNameLabel: UILabel!

}

extension GithubPullRequestCell {

    func setup(with pull: GithubPullRequest) {
        pullName.text = pull.title
        pullDescription.text = pull.body

        usernameLabel.text = pull.owner?.login
        userFirstAndLastNameLabel.text = ""

        guard
            let urlString = pull.owner?.avatarURLString,
            let url = URL(string: urlString)
            else {
                pullImage.image = nil
                return
        }

        pullImage.kf.setImage(with: url)
    }
}
