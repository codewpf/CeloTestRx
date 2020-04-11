//
//  CTMainVC.swift
//  CeloTestRx
//
//  Created by Alex on 12/03/20.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import NSObject_Rx
import SnapKit
import Kingfisher
import MJRefresh
import SVProgressHUD
import Then

class CTPersonListVC: UIViewController {

    /// view controller view model
    fileprivate var viewModel: CTPersonListViewModel = CTPersonListViewModel()
    
    /// list table view
    @IBOutlet weak var tableView: UITableView!
    /// table view data sources
    let dataSource = RxTableViewSectionedReloadDataSource<CTPersonListModel>(configureCell: { ds, tv, idx, item in
        let cell = tv.dequeueReusableCell(withIdentifier: CTPersonListCell.identifier, for: idx) as! CTPersonListCell
        cell.model = item
        return cell
    })
    
    /// search view controller
    fileprivate var searchController: UISearchController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        self.setupBinding()
        self.setupRefresh()
        
        /// begin getting data
        self.tableView.mj_header?.beginRefreshing()
    }
    
    func setupViews() {
        self.tableView.tableFooterView = UIView()
        self.tableView.register(CTPersonListCell.self, forCellReuseIdentifier: CTPersonListCell.identifier)
        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)

        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController?.obscuresBackgroundDuringPresentation = false
        self.searchController?.delegate = self
        self.navigationItem.searchController = self.searchController
    }
    
    func setupBinding() {
        viewModel.input = CTPersonInput(path: .getPerson)
        viewModel.output = viewModel.transform()
        viewModel.output.sections
            .flatMap(filterResult)
            .asDriver().drive(tableView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
        
        viewModel.output.refreshStatus.asObservable()
            .subscribe(onNext: { [weak self] status in
                switch(status) {
                case .none: break
                case .beginHeaderRefresh:
                    self?.tableView.mj_header?.beginRefreshing()
                case .endHeaderRefresh:
                    self?.tableView.mj_header?.endRefreshing()
                case .beginFooterRefresh:
                    self?.tableView.mj_footer?.beginRefreshing()
                case .endFooterRefresh:
                    self?.tableView.mj_footer?.endRefreshing()
                case .noMoreData:
                    self?.tableView.mj_footer?.endRefreshingWithNoMoreData()
                }
            }).disposed(by: self.rx.disposeBag)

    }
    
    func setupRefresh(_ fresh: Bool = true) {
        if fresh == false {
            self.tableView.mj_header = nil
            self.tableView.mj_footer = nil
        } else {
            tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                self?.viewModel.output.requestCommond.onNext(true)
            })
            tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
                self?.viewModel.output.requestCommond.onNext(false)
            })
        }
    }
    
    func filterResult(data: [CTPersonListModel]) -> Driver<[CTPersonListModel]> {
        guard let searchBar = self.searchController?.searchBar else {
            return Driver.just(data)
        }
        return searchBar.rx.text.orEmpty
            .flatMap {  query -> Driver<[CTPersonListModel]> in
                if query.isEmpty {
                    return Driver.just(data)
                } else {
                    var newData: [CTPersonListModel] = []
                    for section in data {
                        var sectionItems: [CTPersonModel] = []
                        for item in section.items {
                            if item.allInformation().contains(query) {
                                sectionItems.append(item)
                            }
                        }
                        newData.append(CTPersonListModel(items: sectionItems))
                    }
                    return Driver.just(newData)
                }
        }.asDriver(onErrorJustReturn: [])
    }

}

//MARK: - View Controller delegates
extension CTPersonListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let person = self.dataSource.sectionModels[indexPath.section].items[indexPath.row]
        let detail = CTDetailModel.personToDetail(person: person)
        let detailVC = CTPersonDetailVC(detail: detail)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CTPersonListCell.height
    }
}

extension CTPersonListVC: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        self.setupRefresh(false)
    }

    func didDismissSearchController(_ searchController: UISearchController) {
        self.setupRefresh()
    }
}




