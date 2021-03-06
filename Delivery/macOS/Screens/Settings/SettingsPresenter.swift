//
//  SettingsPresenter.swift
//  Jirassic
//
//  Created by Cristian Baluta on 02/05/16.
//  Copyright © 2016 Cristian Baluta. All rights reserved.
//

import Foundation

protocol SettingsPresenterInput {
    
    func login (_ credentials: UserCredentials)
    func testJit()
    func installJit()
    func uninstallJit()
    func showSettings()
    func saveAppSettings (_ settings: Settings)
    var jitInstalled: Bool {get}
}

protocol SettingsPresenterOutput {
    
    func showLoadingIndicator (_ show: Bool)
    func setJitIsInstalled (_ installed: Bool)
    func setJiraSettings (_ settings: JiraSettings)
    func showAppSettings (_ settings: Settings)
}

class SettingsPresenter {
    
    fileprivate var jitInteractor = JitInteractor()
    var jitInstalled: Bool {
        get {
            return self.jitInteractor.isInstalled
        }
    }
    var userInterface: SettingsPresenterOutput?
    var settingsInteractor: SettingsInteractorInput?
}

extension SettingsPresenter: SettingsPresenterInput {
    
    func login (_ credentials: UserCredentials) {
        
        let interactor = UserInteractor(data: localRepository)
        interactor.onLoginSuccess = {
            self.userInterface?.showLoadingIndicator(false)
        }
        let user = interactor.currentUser()
        user.isLoggedIn ? interactor.logout() : interactor.loginWithCredentials(credentials)
    }
    
    func testJit() {
        
        userInterface!.setJitIsInstalled( jitInteractor.isInstalled )
        
        guard let jiraSettings = settingsInteractor!.getJiraSettings() else {
            return
        }
        RCLog(jiraSettings)
        settingsInteractor!.getJiraPasswordForUser(jiraSettings.user!)
        userInterface!.setJiraSettings(jiraSettings)
    }
    
    func installJit() {
        
        jitInteractor.installJit { [weak self] (success) in
            if success {
                self?.testJit()
            }
        }
    }
    
    func uninstallJit() {
        
        jitInteractor.uninstallJit { [weak self] (success) in
            if success {
                self?.testJit()
            }
        }
    }
    
    func showSettings() {
        let settings = settingsInteractor!.getAppSettings()
        userInterface!.showAppSettings(settings)
    }
    
    func saveAppSettings (_ settings: Settings) {
        settingsInteractor!.saveAppSettings(settings)
    }
}

extension SettingsPresenter: SettingsInteractorOutput {
    
}
