import UIKit
import RxSwift
import RxCocoa
import SnapKit

class FindMyDriverViewController: UIViewController {

    private let driverPickerButton = ItemPickerButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Find my Driver"
        view.backgroundColor = .white

        setUpLayout()
    }

    private func setUpLayout() {
        view.addSubview(driverPickerButton) { make in
            make.trailing.bottomMargin.equalToSuperview().inset(16)
        }
    }
}
