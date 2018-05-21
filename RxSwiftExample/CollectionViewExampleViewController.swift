//
//  CollectionViewExampleViewController.swift
//  RxSwiftExample
//
//  Created by 王傲云 on 2018/5/14.
//  Copyright © 2018年 WangJace. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

struct AnimatedSectionModel {
    let title: String
    var data: [String]
}

extension AnimatedSectionModel: AnimatableSectionModelType {
    typealias Item = String
    typealias Identity = String
    
    var identity: Identity { return title }
    var items: [Item] { return data }
    
    init(original: AnimatedSectionModel, items: [String]) {
        self = original
        data = items
    }
}

class CollectionViewExampleViewController: UIViewController {

    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet var longPress: UILongPressGestureRecognizer!
    
    let disposeBag = DisposeBag()
    let dataSource = RxCollectionViewSectionedAnimatedDataSource<AnimatedSectionModel>(configureCell: { _, collectionView, indexPath, text in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomCollectionViewCell
        cell.label.text = text
        return cell
    }, configureSupplementaryView: { data, collectionView, kind, indexPath in
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! HeaderCollectionReusableView
        header.label.text = data.sectionModels[indexPath.section].title
        return header
    })
    let arr = Variable([
            AnimatedSectionModel(title: "Section - 0", data: ["0 - 0", "0 - 1"]),
            AnimatedSectionModel(title: "Section - 1", data: ["1 - 0", "1 - 1", "1 - 2", "1 - 3"]),
            AnimatedSectionModel(title: "Section - 2", data: ["2 - 0", "2 - 1", "2 - 2"]),
            AnimatedSectionModel(title: "Section - 3", data: ["3 - 0", "3 - 1", "3 - 2", "3 - 3", "3 - 4", "3 - 5"])
        ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "CollectionView"
        let addItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: nil, action: nil)
        navigationItem.rightBarButtonItem = addItem
        myCollectionView.register(UINib(nibName:"CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        myCollectionView.register(UINib(nibName: "HeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        
        arr.asDriver().drive(myCollectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        addItem.rx.tap
            .bind { [unowned self] in
                let section = self.arr.value.count
                let items: [String] = {
                    var items = [String]()
                    let random = Int(arc4random_uniform(9)) + 1
                    (0...random).forEach({
                        items.append("\(section) - \($0)")
                    })
                    return items
                }()
                self.arr.value += [AnimatedSectionModel(title: "Section - \(section)", data: items)]
         }.disposed(by: disposeBag)
        
        longPress.rx.event.bind(onNext: { [unowned self] in
            switch $0.state {
            case .began:
                guard let selectIndexPath = self.myCollectionView.indexPathForItem(at: $0.location(in: self.myCollectionView)) else { break }
                print("began \(selectIndexPath)")
                self.myCollectionView.beginInteractiveMovementForItem(at: selectIndexPath)
            case .changed:
                print("changed \($0.location(in: self.myCollectionView))")
                self.myCollectionView.updateInteractiveMovementTargetPosition($0.location(in: $0.view))
            case .ended:
                print("ended")
                self.myCollectionView.endInteractiveMovement()
            default:
                print("default")
                self.myCollectionView.cancelInteractiveMovement()
            }
        }).disposed(by: disposeBag)
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
