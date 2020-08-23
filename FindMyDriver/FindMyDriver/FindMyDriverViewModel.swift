//
//  FindMyDriverViewModel.swift
//  FindMyDriver
//
//  Created by Yanis Soto on 21/08/2020.
//  Copyright © 2020 Heetch. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Contacts
import CoreLocation
import RxCoreLocation

protocol FindMyDriverViewModelProtocol {
    var loadingState: Driver<LoadingViewState> { get }
    var fullName: Driver<String> { get }
    var streetAddress: Driver<String> { get }
    var postalAddress: Driver<String> { get }
    var date: Driver<String> { get }
    var profilImage: Driver<UIImage?> { get }
    var driverListRelay: BehaviorRelay<[DriverHeetch]> { get }
    var driverSelectedRelay: BehaviorRelay<DriverHeetch?> { get }
    
    func requestDrivers()
    func selectDriver(pickable: Pickable<DriverHeetch>) -> DriverHeetch?
}


final class FindMyDriverViewModel: FindMyDriverViewModelProtocol {
        
    var loadingState: Driver<LoadingViewState> = .empty()
    var fullName: Driver<String> = .empty()
    var streetAddress: Driver<String> = .empty()
    var postalAddress: Driver<String> = .empty()
    var country: Driver<String> = .empty()
    var date: Driver<String> = .empty()
    var profilImage: Driver<UIImage?> = .empty()
    
    var driverListRelay = BehaviorRelay<[DriverHeetch]>(value: [])
    var driverSelectedRelay = BehaviorRelay<DriverHeetch?>(value: nil)
    
    private let disposeBag = DisposeBag()
    private let loadingRelay = BehaviorRelay<Bool>(value: false)
    private let locationVerbose = BehaviorRelay<[String: String]?>(value: nil)
    private let timer = Observable<NSInteger>.interval(5, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
    private let dateRefreshRelay = BehaviorRelay<Date>(value: Date())
    private let manager = CLLocationManager()
    private let myLocationRelay = BehaviorRelay<CLLocation?>(value: nil)
    internal let api = API(scheme: "http", host: "hiring.heetch.com")

    init() {
        self.setUpMyLocation()
        self.setBindinds()
    }
    
    private func setBindinds() {
        // MARK: - Timer , every 5 sec drivers request will be refresed.
        self.timer.subscribe(onNext: {[weak self] timer in
            guard let self = self else { return }
            self.dateRefreshRelay.accept(Date())
            self.requestDrivers()
        }).disposed(by: self.disposeBag)
         
        // MARK: - UI Drivers - Display on the description View
        self.fullName = self.driverSelectedRelay
                            .compactMap { $0 }
                            .map { $0.firstname + " " + $0.lastname}
                            .asDriver(onErrorJustReturn: "")
        
        self.streetAddress = self.locationVerbose
                            .compactMap { $0 }
                            .map { $0["street"]! }
                            .asDriver(onErrorJustReturn: "")
        
        self.postalAddress = self.locationVerbose
                            .compactMap { $0 }
                            .map { $0["postalCode"]! + " " + $0["city"]! }
                            .asDriver(onErrorJustReturn: "")
        
        self.country = self.locationVerbose
                        .compactMap { $0 }
                        .map { $0["country"]! }
                        .asDriver(onErrorJustReturn: "")
        
        self.date = self.dateRefreshRelay
                        .map({
                            $0.formatString(format: "dd mm yyy") +
                                .localized("at_word") +
                                $0.formatString(format: "HH:mm:ss")
                        })
                        .asDriver(onErrorJustReturn: "")
        
        self.profilImage = self.driverSelectedRelay.compactMap { $0 }
            .map {
            if let url = URL(string:"http://hiring.heetch.com\($0.image)") {
                return UIImage.loadImageFromURL(url: url)
            }
            return nil
        }.asDriver(onErrorJustReturn: nil)
        
        // MARK: - Relay
        self.driverListRelay.asObservable()
            .subscribe(onNext: { [weak self] list in
                guard let self = self else { return }
                guard let driver = self.driverSelectedRelay.value else { return }
                
                if let updatedDriver = list.first(where: {
                    $0.id == driver.id && $0.coordinates != driver.coordinates
                }) {
                    self.driverSelectedRelay.accept(updatedDriver)
                }
            }).disposed(by: self.disposeBag)
        
        ///Retrieve the verbose location of the selected driver
        self.driverSelectedRelay.asObservable()
            .compactMap { $0 }
            .subscribe(onNext: { [weak self ]driver in
                guard let self = self else { return }
                self.foundAdressFromLocation(latitude: driver.coordinates.latitude, longitude: driver.coordinates.longitude)
            }).disposed(by: self.disposeBag)
        
        ///State loading during the request.
        self.loadingState = Observable.combineLatest(loadingRelay, driverListRelay).map { (loading, driverList) -> LoadingViewState in
            if loading {
                return .loading
            } else if driverList.isEmpty {
                return .error
            } else {
                return .finished
            }
        }.distinctUntilChanged().asDriver(onErrorJustReturn: .error)
    }
     
    private func foundAdressFromLocation(latitude: Double, longitude: Double) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            if let placemark =  placemarks?.first {
                let locationVerbose = ["street": placemark.postalAddress?.street,
                                       "postalCode": placemark.postalAddress?.postalCode,
                                       "city": placemark.postalAddress?.city,
                                       "country": placemark.postalAddress?.country
                ]
                self.locationVerbose.accept((locationVerbose as! [String : String]))
            }
        })
    }
    
    func selectDriver(pickable: Pickable<DriverHeetch>) -> DriverHeetch? {
        let drivers = self.driverListRelay.value
        let driver = drivers.first { $0.firstname == pickable.title
                                    && $0.image == pickable.image}
        self.driverSelectedRelay.accept(driver)
        return driver
    }
}

// MARK: - CoreLocation
extension FindMyDriverViewModel:  LocationProtocol {
    internal func setUpMyLocation() {
        manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        manager.rx.didUpdateLocations
            .map { $0.locations.first }
            .bind(to: self.myLocationRelay).disposed(by: self.disposeBag)
    }

}

// MARK: - Api stuff
extension FindMyDriverViewModel: ApiProtocol {
    func requestDrivers() {
        guard let coordinates = self.myLocationRelay.value else {
            return
        }
        
        let coordinateToSend = DriverHeetch.Coordinates(latitude: coordinates.coordinate.latitude,
                                               longitude: coordinates.coordinate.longitude)
        self.loadingRelay.accept(true)
        
        do {
            let request = try Request<[DriverHeetch]>.put(at: "/mobile/coordinates",
                                                         input: .json(coordinateToSend),
                                                         output: .json)

            api.result(for: request)
                .subscribe({ [weak self ] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let response):
                        self.driverListRelay.accept(response)
                        self.loadingRelay.accept(false)
                    case .error(let error):
                        print(error)
                        self.loadingRelay.accept(false)
                    }
            }).disposed(by: self.disposeBag)
        } catch (let error) {
            print(error)
        }
    }
}
