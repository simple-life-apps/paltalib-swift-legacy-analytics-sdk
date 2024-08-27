import Amplitude
import PaltaCore
import Foundation

public final class PaltaAnalytics {
    public static let instance = PaltaAnalytics()

    var paltaQueues: [EventQueueImpl] {
        paltaQueueAssemblies.map { $0.eventQueue }
    }

    let assembly = AnalyticsAssembly()
    
    var paltaQueueAssemblies: [EventQueueAssembly] {
        if let defaultPaltaInstance = defaultPaltaInstance {
            return [defaultPaltaInstance]
        } else {
            return _paltaQueueAssemblies
        }
    }
    
    var amplitudeInstances: [Amplitude] {
        if let defaultAmplitudeInstance = defaultAmplitudeInstance {
            return [defaultAmplitudeInstance]
        } else {
            return _amplitudeInstances
        }
    }
    
    private let lock = NSRecursiveLock()

    private var defaultAmplitudeInstance: Amplitude? = Amplitude
        .instance(withName: ConfigTarget.defaultAmplitude.name.rawValue)
        .do {
            $0.apply(.defaultAmplitude, host: nil)
            $0.setOffline(true)
        }
    
    private var defaultPaltaInstance: EventQueueAssembly?
    
    private var _paltaQueueAssemblies: [EventQueueAssembly] = []
    private var _amplitudeInstances: [Amplitude] = []

    private var isConfigured = false
    private var apiKey: String?
    private var amplitudeApiKey: String?
    private var host: URL?
    
    init() {
        do {
            defaultPaltaInstance = try assembly.newEventQueueAssembly()
        } catch {
            print("PaltaLib: Analytics: failed to setup instance due to error: \(error)")
            return
        }
    }

    public func configure(
        amplitudeAPIKey: String? = nil,
        paltaAPIKey: String? = nil,
        host: URL?
    ) {
        lock.lock()
        defer { lock.unlock() }
        
        guard !isConfigured else { return }
        
        self.isConfigured = true
        self.apiKey = paltaAPIKey
        self.amplitudeApiKey = amplitudeAPIKey
        self.host = host

        if let amplitudeAPIKey = amplitudeAPIKey {
            defaultAmplitudeInstance?.initializeApiKey(amplitudeAPIKey)
        }

        requestRemoteConfigs()
    }
    
    private func requestRemoteConfigs() {
        guard let apiKey = apiKey else {
            print("PaltaAnalytics: error: API key is not set")
            return
        }

        assembly.analyticsCoreAssembly.configurationService.requestConfigs(apiKey: apiKey, host: host) { [self] (result: Result<RemoteConfig, Error>) in
            switch result {
            case .failure(let error):
                print("PaltaAnalytics: configuration fetch failed: \(error.localizedDescription), used default config.")
                applyRemoteConfig(.default)
            case .success(let config):
                applyRemoteConfig(config)
            }
        }
    }
    
    private func applyRemoteConfig(_ remoteConfig: RemoteConfig) {
        lock.lock()

        let service = ConfigApplyService(
            remoteConfig: remoteConfig,
            apiKey: apiKey,
            amplitudeApiKey: amplitudeApiKey,
            eventQueueAssemblyProvider: assembly,
            host: host
        )
        
        service.apply(
            defaultPaltaAssembly: &defaultPaltaInstance,
            defaultAmplitude: &defaultAmplitudeInstance,
            paltaAssemblies: &_paltaQueueAssemblies,
            amplitudeInstances: &_amplitudeInstances
        )
        
        lock.unlock()
    }

    public func setTrackingOptions(_ options: AMPTrackingOptions) {
        amplitudeInstances.forEach {
            $0.setTrackingOptions(options)
        }

        assembly.analyticsCoreAssembly.trackingOptionsProvider.setTrackingOptions(options)
    }
}
