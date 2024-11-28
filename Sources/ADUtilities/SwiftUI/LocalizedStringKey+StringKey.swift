import SwiftUI

public extension LocalizedStringKey {
    var stringKey: String {
        let description = "\(self)"

        let components = description.components(separatedBy: "key: \"")
            .map { $0.components(separatedBy: "\",")}
        return components[1][0]
    }

    var localizedString: String {
        let language = Locale.current.languageCode
        let path = Bundle.main.path(forResource: language, ofType: "lproj") ?? ""
        if let bundle = Bundle(path: path) {
            return NSLocalizedString(self.stringKey, bundle: bundle, comment: "\(self.stringKey)") as String
        } else {
            return self.stringKey
        }
    }

}
