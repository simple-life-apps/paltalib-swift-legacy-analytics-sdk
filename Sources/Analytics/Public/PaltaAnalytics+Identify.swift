import Amplitude

extension PaltaAnalytics {
    public func setUserId(_ userId: String?) {
        amplitudeInstances.forEach {
            $0.setUserId(userId)
        }

        assembly.analyticsCoreAssembly.userPropertiesKeeper.userId = userId
    }

    public func setUserProperties(_ userProperties: Dictionary<String, Any>) {
        amplitudeInstances.forEach {
            $0.setUserProperties(userProperties)
        }

        paltaQueueAssemblies.forEach {
            $0.identityLogger.setUserProperties(userProperties)
        }
    }
}
