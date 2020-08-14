import UIKit

final class NoDriverViewController : UIViewController {

    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .gray
        label.text = .localized("found-drivers.none.label")

        view.addSubview(label) { make in
            make.center.equalToSuperview()
            make.leading.greaterThanOrEqualTo(32)
            make.trailing.lessThanOrEqualTo(32)
        }
    }
}
