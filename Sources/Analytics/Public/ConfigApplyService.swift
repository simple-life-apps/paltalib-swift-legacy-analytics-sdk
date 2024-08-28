//
//  ConfigApplyService.swift
//  PaltaLibAnalytics
//
//  Created by Vyacheslav Beltyukov on 18/05/2022.
//

import Foundation

final class ConfigApplyService {
    private let remoteConfig: RemoteConfig
    private let apiKey: String?
    private let host: URL?
    private let eventQueueAssemblyProvider: EventQueueAssemblyProvider
    
    init(
        remoteConfig: RemoteConfig,
        apiKey: String?,
        eventQueueAssemblyProvider: EventQueueAssemblyProvider,
        host: URL?
    ) {
        self.remoteConfig = remoteConfig
        self.apiKey = apiKey
        self.host = host
        self.eventQueueAssemblyProvider = eventQueueAssemblyProvider
    }
    
    func apply(
        defaultPaltaAssembly: inout EventQueueAssembly?,
        paltaAssemblies: inout [EventQueueAssembly]
    ) {
        remoteConfig.targets.forEach {
            apply(
                $0,
                defaultPaltaAssembly: &defaultPaltaAssembly,
                paltaAssemblies: &paltaAssemblies
            )
        }
        
        defaultPaltaAssembly = nil
    }
    
    private func apply(
        _ target: ConfigTarget,
        defaultPaltaAssembly: inout EventQueueAssembly?,
        paltaAssemblies: inout [EventQueueAssembly]
    ) {
        switch (target.name, target.settings.sendMechanism, apiKey) {

        case
            (.paltabrain, .paltaBrain, let apiKey?),
            (.paltabrain, nil, let apiKey?):
            addPaltaBrainTarget(
                target,
                apiKey: apiKey,
                defaultPaltaAssembly: &defaultPaltaAssembly,
                paltaAssemblies: &paltaAssemblies
            )
            
        case (.paltabrain, _, nil):
            print("PaltaAnalytics: error: API key for palta brain is not set")
            
        default:
            print("PaltaAnalytics: error: unconfigurable target")
        }
    }

    private func addPaltaBrainTarget(
        _ target: ConfigTarget,
        apiKey: String,
        defaultPaltaAssembly: inout EventQueueAssembly?,
        paltaAssemblies: inout [EventQueueAssembly]
    ) {
        let eventQueueAssembly: EventQueueAssembly
        
        if let defPaltaAssembly = defaultPaltaAssembly {
            eventQueueAssembly = defPaltaAssembly
            defaultPaltaAssembly = nil
        } else {
            do {
                eventQueueAssembly = try eventQueueAssemblyProvider.newEventQueueAssembly()
            } catch {
                print("PaltaLib: Analytics: failed to setup instance due to error: \(error)")
                return
            }
        }
        
        eventQueueAssembly.batchSender.apiToken = apiKey
        eventQueueAssembly.apply(target, host: host)
        eventQueueAssembly.batchSendController.configurationFinished()
        
        paltaAssemblies.append(eventQueueAssembly)
    }
}
