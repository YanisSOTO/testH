import UIKit
import MapKit
import RxSwift

final class FoundDriverMapViewController: UIViewController {

    private lazy var mapView = MKMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView) { make in
            make.edges.equalToSuperview()
        }
    }

}
