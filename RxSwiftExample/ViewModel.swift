//
//  ViewModel.swift
//  RxSwiftExample
//
//  Created by 王傲云 on 2018/5/28.
//  Copyright © 2018年 WangJace. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ViewModel: NSObject {
    let searchText = Variable("")
    
    lazy var data: Driver<[Repository]> = {
        return self.searchText.asObservable()
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest(ViewModel.repositoriesFor)
            .asDriver(onErrorJustReturn: [])
    }()
    
    static func repositoriesFor(_ githubId: String) -> Observable<[Repository]> {
        guard !githubId.isEmpty else {
            return Observable.just([])
        }
        let url = URL(string: "https://api.github.com/users/\(githubId)/repos")
        return URLSession.shared
            .rx.json(url: url!)
            .retry(3)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))//使用GCD执行给定队列的任务
            .map(parse)
    }
    
    static func parse(json: Any) -> [Repository] {
        guard let items = json as? [[String: Any]] else {
            return []
        }
        
        var repositories = [Repository]()
        items.forEach {
            guard let name = $0["name"] as? String, let url = $0["html_url"] as? String else {
                return
            }
            repositories.append(Repository(name: name, url: url))
        }
        return repositories
    }
}
