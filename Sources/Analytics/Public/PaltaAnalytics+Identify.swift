import Foundation

extension PaltaAnalytics {
    public func setUserId(_ userId: String?) {
        assembly.analyticsCoreAssembly.userPropertiesKeeper.userId = userId
    }

    public func setUserProperties(_ userProperties: Dictionary<String, Any>) {
        paltaQueueAssemblies.forEach {
            $0.identityLogger.setUserProperties(userProperties)
        }
    }
}
