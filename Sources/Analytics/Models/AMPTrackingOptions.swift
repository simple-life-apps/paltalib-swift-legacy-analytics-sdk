import Foundation

public class AMPTrackingOptions: NSObject {
    private var disabledFields: Set<String> = []

    public override init() {}

    public func disableCarrier() -> AMPTrackingOptions {
        disableTrackingField(AMP_TRACKING_OPTION_CARRIER)
        return self
    }

    func shouldTrackCarrier() -> Bool {
        return shouldTrackField(AMP_TRACKING_OPTION_CARRIER)
    }

    func disableCountry() -> AMPTrackingOptions {
        disableTrackingField(AMP_TRACKING_OPTION_COUNTRY)
        return self
    }

    func shouldTrackCountry() -> Bool {
        return shouldTrackField(AMP_TRACKING_OPTION_COUNTRY)
    }

    func disableDeviceManufacturer() -> AMPTrackingOptions {
        disableTrackingField(AMP_TRACKING_OPTION_DEVICE_MANUFACTURER)
        return self
    }

    func shouldTrackDeviceManufacturer() -> Bool {
        return shouldTrackField(AMP_TRACKING_OPTION_DEVICE_MANUFACTURER)
    }

    func disableDeviceModel() -> AMPTrackingOptions {
        disableTrackingField(AMP_TRACKING_OPTION_DEVICE_MODEL)
        return self
    }

    func shouldTrackDeviceModel() -> Bool {
        return shouldTrackField(AMP_TRACKING_OPTION_DEVICE_MODEL)
    }

    func disableIDFA() -> AMPTrackingOptions {
        disableTrackingField(AMP_TRACKING_OPTION_IDFA)
        return self
    }

    func shouldTrackIDFA() -> Bool {
        return shouldTrackField(AMP_TRACKING_OPTION_IDFA)
    }

    func disableIDFV() -> AMPTrackingOptions {
        disableTrackingField(AMP_TRACKING_OPTION_IDFV)
        return self
    }

    func shouldTrackIDFV() -> Bool {
        return shouldTrackField(AMP_TRACKING_OPTION_IDFV)
    }

    func disableLanguage() -> AMPTrackingOptions {
        disableTrackingField(AMP_TRACKING_OPTION_LANGUAGE)
        return self
    }

    func shouldTrackLanguage() -> Bool {
        return shouldTrackField(AMP_TRACKING_OPTION_LANGUAGE)
    }

    func disableOSName() -> AMPTrackingOptions {
        disableTrackingField(AMP_TRACKING_OPTION_OS_NAME)
        return self
    }

    func shouldTrackOSName() -> Bool {
        return shouldTrackField(AMP_TRACKING_OPTION_OS_NAME)
    }

    func disableOSVersion() -> AMPTrackingOptions {
        disableTrackingField(AMP_TRACKING_OPTION_OS_VERSION)
        return self
    }

    func shouldTrackOSVersion() -> Bool {
        return shouldTrackField(AMP_TRACKING_OPTION_OS_VERSION)
    }

    func disablePlatform() -> AMPTrackingOptions {
        disableTrackingField(AMP_TRACKING_OPTION_PLATFORM)
        return self
    }

    func shouldTrackPlatform() -> Bool {
        return shouldTrackField(AMP_TRACKING_OPTION_PLATFORM)
    }

    func disableVersionName() -> AMPTrackingOptions {
        disableTrackingField(AMP_TRACKING_OPTION_VERSION_NAME)
        return self
    }

    func shouldTrackVersionName() -> Bool {
        return shouldTrackField(AMP_TRACKING_OPTION_VERSION_NAME)
    }

    private func disableTrackingField(_ field: String) {
        disabledFields.insert(field)
    }

    private func shouldTrackField(_ field: String) -> Bool {
        return !disabledFields.contains(field)
    }

    func getApiPropertiesTrackingOption() -> [String: Bool] {
        var apiPropertiesTrackingOptions: [String: Bool] = [:]
        if disabledFields.isEmpty {
            return apiPropertiesTrackingOptions
        }

        let serverSideOptions = [
            AMP_TRACKING_OPTION_COUNTRY
        ]

        for option in serverSideOptions {
            if disabledFields.contains(option) {
                apiPropertiesTrackingOptions[option] = false
            }
        }

        return apiPropertiesTrackingOptions
    }
}
