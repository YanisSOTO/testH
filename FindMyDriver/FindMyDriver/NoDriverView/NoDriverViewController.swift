import UIKit

final class NoDriverViewController : UIView {

    private let label = UILabel()..{
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.textColor = .gray
        $0.text = .localized("found-drivers.none.label")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setSubview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setSubview() {
        self.addSubview(self.label) { make in
            make.center.equalToSuperview()
            make.leading.greaterThanOrEqualTo(32)
            make.trailing.lessThanOrEqualTo(32)
        }
    }
}
