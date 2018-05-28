//
//  NetWorkRequestExampleViewController.swift
//  RxSwiftExample
//
//  Created by 王傲云 on 2018/5/14.
//  Copyright © 2018年 WangJace. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NetWorkRequestExampleViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchBar: UISearchBar {
        return searchController.searchBar
    }
    var viewModel = ViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "NetworkRequest"
        
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        configureSearchController()
        viewModel.data
            .drive(myTableView.rx.items(cellIdentifier: "Cell")) { _, repository, cell in
                cell.textLabel?.text = repository.name
                cell.detailTextLabel?.text = repository.url
            }.disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        viewModel.data.asDriver()
            .map {
                "\($0.count) Repositories"
            }
            .drive(navigationItem.rx.title)
        .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchBar.showsCancelButton = true
        searchBar.text = "scotteg"
        searchBar.placeholder = "Enter Github ID, e.g., \"scotteg\""
        myTableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
