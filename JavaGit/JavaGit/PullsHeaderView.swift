import UIKit

final class PullsHeaderView: UIView {

    @IBOutlet private var contentView: UIView?
    @IBOutlet weak var headerLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if self.subviews.isEmpty {
            self.commonInit()
        }
    }

    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
    }

}
