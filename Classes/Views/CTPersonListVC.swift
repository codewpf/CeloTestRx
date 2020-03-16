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
    /// view controller view model
    fileprivate var viewModel: CTPersonListViewModel = CTPersonListViewModel()
    /// view model out put
    fileprivate var output: CTPersonOutput?
    
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
        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)

        
//        self.searchController = UISearchController(searchResultsController: nil)
//        self.searchController?.searchResultsUpdater = self
//        self.searchController?.obscuresBackgroundDuringPresentation = false
//        self.searchController?.delegate = self
//        self.navigationItem.searchController = self.searchController
        
    }
    
    func rxBindView() {
        let input = CTPersonInput(path: .getPerson)
        output = viewModel.transform(input: input)
        output!.sections.asDriver().drive(tableView.rx.items(dataSource: dataSource)).disposed(by: self.rx.disposeBag)
        
        output!.refreshStatus.asObservable()
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
            self.output?.requetCommond.onNext(true)
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.output?.requetCommond.onNext(false)
        })
    }

}

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



final class CTPersonListCell: UITableViewCell, CTCellReuseIdentifier, CTCellConstant {
    static var height: CGFloat = 90
    
    private let icon: UIImageView = UIImageView().then {
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
    }
    private let name: UILabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 20)
    }
    private let gender: UILabel = UILabel().then {
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 16)
    }
    private let birthday: UILabel = UILabel().then {
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 16)
    }
    
    private var _model: CTPersonModel?
    var model: CTPersonModel? {
        willSet(newValue) {
            guard let value = newValue else {
                return
            }
            self._model = value
            self.icon.kf.setImage(with: URL(string: value.thumbnail))
            self.name.text = value.first + " " + value.last
            self.gender.text = value.gender
            self.birthday.text = value.birthday.toString(format: "yyyy-MM-dd")
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        

        self.contentView.addSubview(self.icon)
        self.icon.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.width.height.equalTo(70)
            make.centerY.equalToSuperview()
        }
        

        self.contentView.addSubview(self.name)
        self.name.snp.makeConstraints { (make) in
            make.top.equalTo(self.icon)
            make.left.equalTo(self.icon.snp.right).offset(10)
//            make.right.equalToSuperview().offset(-15-80)
            make.height.equalTo(40)
        }
        
        
        self.contentView.addSubview(self.gender)
        self.gender.snp.makeConstraints { (make) in
            make.top.height.equalTo(self.name)
            make.left.equalTo(self.name.snp.right).offset(5)
            make.right.equalToSuperview().offset(-15)
        }
        
        self.contentView.addSubview(self.birthday)
        self.birthday.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.icon)
            make.left.right.equalTo(self.name)
            make.height.equalTo(30)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
