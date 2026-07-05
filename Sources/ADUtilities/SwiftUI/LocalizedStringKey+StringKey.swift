import SwiftUI

public extension LocalizedStringKey {
    var stringKey: String {
        let description = "\(self)"

        guard let keyStart = description.range(of: "key: \"")?.upperBound,
              let keyEnd = description[keyStart...].range(of: "\",")?.lowerBound else {
            return description
        }

        return String(description[keyStart..<keyEnd])
    }

    var localizedString: String {
        let language = Locale.current.language.languageCode?.identifier
        let path = Bundle.main.path(forResource: language, ofType: "lproj") ?? ""
        if let bundle = Bundle(path: path) {
            return NSLocalizedString(self.stringKey, bundle: bundle, comment: "\(self.stringKey)") as String
        } else {
            return self.stringKey
        }
    }

}
