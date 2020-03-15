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
import Moya
import Kingfisher
import MJRefresh
import SVProgressHUD

class CTPersonListVC: UIViewController {

    /// list table view
    @IBOutlet weak var tableView: UITableView!
    /// table view data sources
    let dataSource = RxTableViewSectionedReloadDataSource<CTPersonListModel>(configureCell: { ds, tv, idx, item in
        let cell = tv.dequeueReusableCell(withIdentifier: CTPersonListCell.identifier, for: idx) as! CTPersonListCell
        cell.icon.kf.setImage(with: URL(string: item.thumbnail))
        cell.name.text = item.first + " " + item.last
        cell.gender.text = item.gender
        return cell
    })
    
    /// search view controller
    fileprivate var searchController: UISearchController? = nil
    /// view controller view model
    fileprivate var viewModel: CTPersonListViewModel = CTPersonListViewModel()
    
    /// view model out put
    fileprivate var output: CTPersonOutput?
    
    
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        self.rxBindView()
        
        /// begin getting data
        self.tableView.mj_header?.beginRefreshing()
    }
    
    func setupViews() {
        self.tableView.tableFooterView = UIView()
        self.tableView.register(CTPersonListCell.self, forCellReuseIdentifier: CTPersonListCell.identifier)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        
//        self.searchController = UISearchController(searchResultsController: nil)
//        self.searchController?.searchResultsUpdater = self
//        self.searchController?.obscuresBackgroundDuringPresentation = false
//        self.searchController?.delegate = self
//        self.navigationItem.searchController = self.searchController
        
    }
    
    func rxBindView() {
        let input = CTPersonInput(path: .getPerson)
        let output = viewModel.transform(input: input)
        output.sections.asDriver().drive(tableView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
        
        output.refreshStatus.asObservable()
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
    
        //TODO: search status
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            output.requetCommond.onNext(true)
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            output.requetCommond.onNext(true)
        })
    }

}

extension CTPersonListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension CTPersonListVC: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
//        self.setupRefresh(with: false)
//        self.viewModel.startSearching()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
//        self.setupRefresh(with: true)
//        self.isSearching = false
//        self.tableView.reloadData()
    }
}

extension CTPersonListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
//        guard let keyword = searchController.searchBar.text, keyword.count > 0 else { return }
//        self.viewModel.search(keyword)
//        self.isSearching = true
    }
}



final class CTPersonListCell: UITableViewCell, CTCellReuseIdentifier {
    
    let icon: UIImageView = UIImageView()
    let name: UILabel = UILabel()
    let gender: UILabel = UILabel()
    
    
}
