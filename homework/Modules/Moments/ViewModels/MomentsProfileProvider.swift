//
//  MomentsProfileProvider.swift
//  homework
//
//  Created by 刘奕成 on 2019/6/16.
//  Copyright © 2019 Eason. All rights reserved.
//

import Foundation

class MomentsProfileProvider: BaseViewModel {
    
    typealias ProfileModel = MomentsTopView.Model
    
    let profileModel = PublishRelay<ProfileModel>()
    
    private typealias Profile = User.Profile
    
    private let profile = BehaviorRelay<Profile?>(value: nil)
    
    private var profileRequestBag = DisposeBag()
    
    // MARK: Override
    
    override func loadScripts() {
        super.loadScripts()
        
        profile.filter({ $0 != nil }).map({ [unowned self] (profile) -> ProfileModel in
            return self.mapProfileModel(profile!)
        }).bind(to: profileModel).disposed(by: rx.dsbag)
    }
}

// MARK: - Private
extension MomentsProfileProvider {
    
    private func mapProfileModel(_ profile: Profile) -> ProfileModel {
        return ProfileModel(profileURL: URL(string: profile.profilePath ?? ""),
                            avatarURL: URL(string: profile.avatarPath ?? ""),
                            name: profile.username)
    }
}

// MARK: - Public
extension MomentsProfileProvider {
    
    func updateProfile() {
        profileRequestBag = DisposeBag()
        User.provider.rx.request(.profile)
            .map(Profile.self)
            .retryWhen({ _ in Network.reachable })
            .subscribe(onSuccess: { [unowned self] (profile) in
                self.profile.accept(profile)
            })
            .disposed(by: profileRequestBag)
    }
}
