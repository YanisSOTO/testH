import UIKit
import MapKit
import RxSwift

final class MapKitController: UIViewController {

    private lazy var mapView = MKMapView()
    private let disposeBag = DisposeBag()
        
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Map"
        view.addSubview(mapView) { make in
            make.edges.equalToSuperview()
        }
        self.setBindings()
    }
    
    
    func setBindings() {
    }
    

    func setPinOnMap(latitude: Double, longitude: Double) {
        self.mapView.annotations.forEach {
            self.mapView.removeAnnotation($0)
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}
