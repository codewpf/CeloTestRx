//
//  CTMainViewModel.swift
//  CeloTestRx
//
//  Created by Alex on 12/03/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CTPersonListViewModel: NSObject {
    /// search controller is searching
    fileprivate var isSearching: Bool = false
    
    /// person list vc table view page index
    var pageIdx: Int = 0
    /// table view page size
    var pageSize: Int = 10
    ///
    var models = BehaviorRelay<[CTPersonModel]>(value: [])
    
    var input: CTPersonInput!
    var output: CTPersonOutput!
    
}

extension CTPersonListViewModel: CTViewModelType {
    
    typealias Input = CTPersonInput
    typealias Output = CTPersonOutput
    
    func transform() -> CTPersonOutput {
        
        guard let input = self.input else {
            fatalError("\(Self.self) didn't init input")
        }

        let sections = models.asObservable().map{ (models) -> [CTPersonListModel] in
            return [CTPersonListModel(items: models)]
        }.asDriver(onErrorJustReturn: [])
        
        let output = CTPersonOutput(sections: sections)
        output.requetCommond.subscribe(onNext: { [unowned self] isReloadData in
            self.pageIdx = isReloadData ? 1 : self.pageIdx+1
            CTNetworkManager.rx.request(.getPerson(path: input.path, pageSize: self.pageSize, pageIdx: self.pageIdx))
                .retry(2)
                .asObservable().mapArray(CTPersonModel.self)
                .subscribe({ [weak self] event in
                    switch event {
                    case let .next(models):
                        self?.models.accept(isReloadData ? models : (self?.models.value ?? []) + models)
                        /// insert data into DB
                        _ = models.map{ m in
                            m.insertPerson().subscribe().disposed(by: self?.rx.disposeBag ?? DisposeBag())
                        }
                    case let .error(err):
                        CTPersonModel.queryPerson(with: self?.pageIdx ?? 0, pageSize: self?.pageSize ?? 10)
                            .subscribe(onNext: { (models) in
                                self?.models.accept(isReloadData ? models : (self?.models.value ?? []) + models)
                                output.refreshStatus.accept(isReloadData ? .endHeaderRefresh : ((self?.models.value.count ?? 0) % (self?.pageSize ?? 10)) > 0 ? .noMoreData : .endFooterRefresh)

                            }, onError: { (error) in
                                print("db err = " + error.localizedDescription)
                            }).disposed(by: self?.rx.disposeBag ?? DisposeBag())
                        print("network err = " + err.localizedDescription)
                    case .completed:
                        output.refreshStatus.accept(isReloadData ? .endHeaderRefresh : ((self?.models.value.count ?? 0) % (self?.pageSize ?? 10)) > 0 ? .noMoreData : .endFooterRefresh)
                    }
                }).disposed(by: self.rx.disposeBag)
        }).disposed(by: self.rx.disposeBag)
        return output
    }
}

struct CTPersonInput {
    let path: CTNetworkPath
    init(path: CTNetworkPath) {
        self.path = path
    }
}

struct CTPersonOutput {
    
    let sections: Driver<[CTPersonListModel]>
    let requetCommond = PublishSubject<Bool>()
    let refreshStatus = BehaviorRelay<CTRefreshStatus>(value: .none)
    let searchStatus = BehaviorRelay<Bool>(value: false)
    
    init(sections: Driver<[CTPersonListModel]>) {
        self.sections = sections
    }
}
