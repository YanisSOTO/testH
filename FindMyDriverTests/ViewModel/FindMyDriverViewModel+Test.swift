//
//  FindMyDriverViewModel+Test.swift
//  FindMyDriverTests
//
//  Created by Yanis Soto on 23/08/2020.
//  Copyright © 2020 Heetch. All rights reserved.
//

import XCTest
import RxTest
import RxSwift

@testable import FindMyDriver
class FindMyDriverViewModel_Test: XCTestCase {
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var apiFetcher: ApiMock!
    var viewModel: FindMyDriverViewModel!

    override func setUp() {
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        self.apiFetcher = ApiMock()
        self.viewModel = FindMyDriverViewModel()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFullName() {
        guard let sut = self.viewModel else { return }
        let testString = scheduler.createObserver(String.self)
        sut.fullName.asDriver(onErrorJustReturn: "error").drive(testString).disposed(by: self.disposeBag)
    }
    
    
    func testDate() {
        guard let sut = self.viewModel else { return }

        let dateObs = scheduler.createObserver(String.self)
        sut.date.drive(dateObs).disposed(by: self.disposeBag)

        scheduler.start()
    }
    
    func streetAddress() {
        guard let sut = self.viewModel else { return }
        let dateObs = scheduler.createObserver(String.self)
        sut.streetAddress.drive(dateObs).disposed(by: self.disposeBag)
        scheduler.start()
    }

    func testDriverHeetchRelay() {
        guard let sut = self.viewModel else { return }
        let driver = scheduler.createObserver(DriverHeetch?.self)
        
        sut.driverSelectedRelay.bind(to: driver).disposed(by: self.disposeBag)
        scheduler.start()
        XCTAssertRecordedElements(driver.events, [nil])
    }
        
    func createDriver() -> DriverHeetch {
        DriverHeetch(id: 1, firstname: "Pierre", lastname: "Lamage", image: "/image", coordinates: DriverHeetch.Coordinates(latitude: 42.0923, longitude: -2.2323))
    }

}
