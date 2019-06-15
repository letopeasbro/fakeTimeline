//
//  MomentsTweetProvider.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/13.
//  Copyright © 2019 Eason. All rights reserved.
//

import Foundation

class MomentsTweetProvider: BaseViewModel {
    
    // MARK: Override
    
    override func loadScripts() {
        super.loadScripts()
    }
}

// MARK: - Private
extension MomentsTweetProvider {
    
    private typealias TextModel = MomentsTweetTextCell.Model
    private typealias PhotoModel = MomentsTweetPhotoCell.Model
    private typealias MultipictureModel = MomentsTweetMultipictureCell.Model
    
    private func mapTextModel() -> TextModel {
        return TextModel(avatarURL: URL(string: "http://b.hiphotos.baidu.com/image/h%3D300/sign=ad628627aacc7cd9e52d32d909032104/32fa828ba61ea8d3fcd2e9ce9e0a304e241f5803.jpg")!, nickname: "刘奕成", content: "奥斯卡的骄傲了撒建档立卡时间点绿卡撒建档立卡时间点", comments: [])
    }
    
    private func mapPhotoModel() -> PhotoModel {
        let content = MomentsTweetPhotoCell.Content(text: "奥斯卡的骄傲落实到穷我们去围殴IQ无金额iOS阿栋我安德玛克拉霉素带搜到几千万", photoURL: URL(string: "http://b.hiphotos.baidu.com/image/h%3D300/sign=ad628627aacc7cd9e52d32d909032104/32fa828ba61ea8d3fcd2e9ce9e0a304e241f5803.jpg")!)
        return PhotoModel(avatarURL: URL(string: "http://b.hiphotos.baidu.com/image/h%3D300/sign=ad628627aacc7cd9e52d32d909032104/32fa828ba61ea8d3fcd2e9ce9e0a304e241f5803.jpg")!, nickname: "刘奕成", content: content, comments: [
            Moments.Comment(content: "Good.", sender: User.Card(username: "Swin", nickname: "刘斩仙", avatarPath: nil)),
            Moments.Comment(content: "ad628627aacc7cd9e52d32d909032104", sender: User.Card(username: "Swin", nickname: "刘斩仙", avatarPath: nil)),
            Moments.Comment(content: "我们去围殴IQ无金额iOS阿栋我安德玛克拉霉素带.", sender: User.Card(username: "Swin", nickname: "刘斩仙", avatarPath: nil)),
            Moments.Comment(content: "Good.", sender: User.Card(username: "Swin", nickname: "刘斩仙", avatarPath: nil))])
    }
    
    private func mapMultipictureModel() -> MultipictureModel {
        let content = MomentsTweetMultipictureCell.Content(text: nil, pictureURLs: [URL(string: "http://b.hiphotos.baidu.com/image/h%3D300/sign=ad628627aacc7cd9e52d32d909032104/32fa828ba61ea8d3fcd2e9ce9e0a304e241f5803.jpg")!, URL(string: "http://b.hiphotos.baidu.com/image/h%3D300/sign=ad628627aacc7cd9e52d32d909032104/32fa828ba61ea8d3fcd2e9ce9e0a304e241f5803.jpg")!, URL(string: "http://b.hiphotos.baidu.com/image/h%3D300/sign=ad628627aacc7cd9e52d32d909032104/32fa828ba61ea8d3fcd2e9ce9e0a304e241f5803.jpg")!, URL(string: "http://b.hiphotos.baidu.com/image/h%3D300/sign=ad628627aacc7cd9e52d32d909032104/32fa828ba61ea8d3fcd2e9ce9e0a304e241f5803.jpg")!, URL(string: "http://b.hiphotos.baidu.com/image/h%3D300/sign=ad628627aacc7cd9e52d32d909032104/32fa828ba61ea8d3fcd2e9ce9e0a304e241f5803.jpg")!, URL(string: "http://b.hiphotos.baidu.com/image/h%3D300/sign=ad628627aacc7cd9e52d32d909032104/32fa828ba61ea8d3fcd2e9ce9e0a304e241f5803.jpg")!])
        return MultipictureModel(avatarURL: nil, nickname: "刘奕成", content: content, comments: [])
    }
}

// MARK: - UITableViewDataSource
extension MomentsTweetProvider: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 1 {
            let cell: MomentsTweetTextCell = tableView.dequeueReusableCell()
            cell.model.accept(mapTextModel())
            return cell
        } else if indexPath.row < 4 {
            let cell: MomentsTweetPhotoCell = tableView.dequeueReusableCell()
            cell.model.accept(mapPhotoModel())
            return cell
        } else {
            let cell: MomentsTweetMultipictureCell = tableView.dequeueReusableCell()
            cell.model.accept(mapMultipictureModel())
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension MomentsTweetProvider: UITableViewDelegate {
    
}
