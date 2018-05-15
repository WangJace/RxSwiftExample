//
//  ViewController.swift
//  RxSwiftExample
//
//  Created by 王傲云 on 2018/5/13.
//  Copyright © 2018年 WangJace. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    let data = Observable.of(["TableView", "CollectionView", "NetWorkRequest"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        data.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: "Cell")) { (_, model, cell) in
                cell.accessoryType = .disclosureIndicator
                cell.textLabel?.text = model
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] in
            self?.tableView.deselectRow(at: $0, animated: true)
            switch($0.row) {
            case 0:
                let tableViewExample = TableViewExampleViewController(nibName: "TableViewExampleViewController", bundle: nil)
                self?.navigationController?.pushViewController(tableViewExample, animated: true)
            case 1:
                let collectionViewExample = CollectionViewExampleViewController(nibName: "CollectionViewExampleViewController", bundle: nil)
                self?.navigationController?.pushViewController(collectionViewExample, animated: true)
            case 2:
                let networkRequestExample = NetWorkRequestExampleViewController(nibName: "NetWorkRequestExampleViewController", bundle: nil)
                self?.navigationController?.pushViewController(networkRequestExample, animated: true)
            default:
                break
            }
        }).disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

