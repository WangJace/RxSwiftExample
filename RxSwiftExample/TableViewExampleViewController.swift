//
//  TableViewExampleViewController.swift
//  RxSwiftExample
//
//  Created by 王傲云 on 2018/5/14.
//  Copyright © 2018年 WangJace. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

struct Model {
    var image: UIImage
    var name: String
    var age: String
    
    mutating func initWith(tempImage: UIImage, tempName: String, tempAge: String) {
        image = tempImage
        name = tempName
        age = tempAge
    }
}

class TableViewExampleViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Model>>(configureCell: { (_, tv, indexPath, element) in
        guard let cell = tv.dequeueReusableCell(withIdentifier: "Cell") else {
            let cell = UITableViewCell.init(style: .value1, reuseIdentifier: "Cell")
            cell.textLabel?.text = element.name
            cell.imageView?.image = element.image
            cell.detailTextLabel?.text = element.age
            return cell
        }
        cell.textLabel?.text = element.name
        cell.imageView?.image = element.image
        cell.detailTextLabel?.text = element.age
        return cell
    }, titleForHeaderInSection: { dataSource, sectionIndex in
        return dataSource[sectionIndex].model
        
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "TableView"
        let items = Observable.just([
            SectionModel(model: "First section", items: [
                Model.init(image: UIImage(named: "1")!, name: "Jack", age: "20"),
                Model.init(image: UIImage(named: "2")!, name: "Mike", age: "21"),
                Model.init(image: UIImage(named: "3")!, name: "Marry", age: "19"),
                ]),
            SectionModel(model: "Second section", items: [
                Model.init(image: UIImage(named: "4")!, name: "Jane", age: "25"),
                Model.init(image: UIImage(named: "5")!, name: "Jason", age: "16"),
                Model.init(image: UIImage(named: "6")!, name: "Siri", age: "23"),
                ]),
            SectionModel(model: "Third section", items: [
                Model.init(image: UIImage(named: "7")!, name: "Micle", age: "28"),
                Model.init(image: UIImage(named: "8")!, name: "Miri", age: "17"),
                Model.init(image: UIImage(named: "9")!, name: "Tenck", age: "22"),
                ])
            ])
        
        items
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx
            .itemSelected
            .subscribe(onNext: { [weak self] in
                self?.tableView.deselectRow(at: $0, animated: true)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension TableViewExampleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
}
