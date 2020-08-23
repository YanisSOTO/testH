import UIKit
import RxSwift
import RxCocoa
import SnapKit


final class FindMyDriverViewController: UIViewController {

    private let disposeBag = DisposeBag()

    private let viewModel: FindMyDriverViewModel

    //UI Stuff
    private let driverPickerButton = ItemPickerButton()
    private let noDriverView = NoDriverViewController()
    private let driverDescription = DriverDescriptionView()
    
     lazy var foundDriverController: MapKitController = {
        let controller = MapKitController()
        self.addChild(controller)
        controller.view.frame = self.view.frame
        self.view.insertSubview(controller.view, at: 0)
        return controller
    }()

    
    private weak var listView: PickablesListView<DriverHeetch>?
    
    init(viewModel: FindMyDriverViewModel = FindMyDriverViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = .localized("find-my-driver")
        view.backgroundColor = .white
        
        //Target action
        self.driverPickerButton.addTarget(self, action: #selector(touchMenu), for: .touchDown)
        self.setUpLayout()
        self.setBindings()
    }
    
    // MARK: - SetUpLayout
    private func setUpLayout() {
        // No driver view byDefault.
        self.view.addSubview(noDriverView) { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        //Driver information View
        self.view.addSubview(self.driverDescription) { make in
            make.top.equalTo(self.view.snp.topMargin).inset(20)
            make.leading.equalTo(self.view.snp.leading).inset(20)
            make.trailing.equalTo(self.view.snp.trailing).inset(20)
        }
        
        //Button picker
        view.addSubview(driverPickerButton) { make in
            make.trailing.bottomMargin.equalToSuperview().inset(16)
        }
    }
    
    private func setBindings() {
        
        self.viewModel.fullName
            .drive(self.driverDescription.nameLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        self.viewModel.date
            .drive(self.driverDescription.dateLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        self.viewModel.streetAddress
            .drive(self.driverDescription.streetLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        self.viewModel.postalAddress
            .drive(self.driverDescription.postalLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        self.viewModel.country
            .drive(self.driverDescription.countryLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        self.viewModel.profilImage
            .drive(self.driverDescription.profileImageView.rx.image)
            .disposed(by: self.disposeBag)

        
        self.viewModel.loadingState
            .asObservable()
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                self.setViewState(state)
            }).disposed(by: disposeBag)
        
        
        self.viewModel.driverSelectedRelay
            .asObservable()
            .compactMap { $0 }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] driverSelected in
                guard let self = self else { return }
                self.driverDescription.isHidden = false
                self.foundDriverController.setPinOnMap(latitude: driverSelected.coordinates.latitude,
                                                        longitude: driverSelected.coordinates.longitude)
                
            }).disposed(by: self.disposeBag)
        
        self.viewModel.driverListRelay
            .asObservable()
            //Ignore init
            .skip(1)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] drivers in
                guard let self = self else { return }
                let pickables = drivers.map { Pickable(value: $0.self, title: $0.firstname, image: $0.image)}
                if let view = self.listView {
                    view.updateData(with: pickables)
                } else {
                    let listView = PickablesListView(with: pickables)
                    listView.parentView = self
                    listView.setSubviews()
                    self.listView = listView
                    self.view.addSubview(listView) { make in
                        make.trailing.equalToSuperview().inset(16)
                        make.bottom.equalTo(self.driverPickerButton.snp.top).inset(-16)
                    }
                }
        }).disposed(by: self.disposeBag)
    }
    
    private func setViewState(_ state: LoadingViewState) {
        switch state {
        case .finished:
            self.driverPickerButton.isLoading = false
        case .error:
            self.driverPickerButton.isLoading = false
        case .loading:
            self.driverPickerButton.isLoading = true
        }
    }
    
    private func showMapKit(driverHeetch: DriverHeetch) {
        self.foundDriverController.setPinOnMap(latitude: driverHeetch.coordinates.latitude,
                                               longitude: driverHeetch.coordinates.longitude)
    }

    // MARK: - Action
    @objc func touchMenu() {
        guard let listView = self.listView else {
            
            let alert = UIAlertController(title: "Ouupss",
                                          message: .localized("location-not-allowed"),
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
            self.present(alert, animated: true)

            return
        }
        listView.isHidden = !listView.isHidden
    }
    
}

extension FindMyDriverViewController: PickableViewDelegate {
    
    func showMapkitWithPosition(driver: Pickable<DriverHeetch>) {
        self.noDriverView.isHidden = true
        if let driverHeetch = self.viewModel.selectDriver(pickable: driver) {
            self.showMapKit(driverHeetch: driverHeetch)
        }
    }
}
