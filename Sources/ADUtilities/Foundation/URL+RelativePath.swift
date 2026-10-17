import Foundation

extension URL {
    /// This file URL's path relative to `root`, such as `"src/a.txt"` for `/x/src/a.txt` under
    /// `/x`. `""` when the URL is `root` itself; `nil` when it isn't inside `root`.
    ///
    /// Both URLs are standardized first, so `.` and `..` segments don't affect the result.
    public func relativePath(from root: URL) -> String? {
        let path = standardizedFileURL.path
        var rootPath = root.standardizedFileURL.path
        if path == rootPath { return "" }
        if !rootPath.hasSuffix("/") { rootPath += "/" }
        guard path.hasPrefix(rootPath) else { return nil }
        return String(path.dropFirst(rootPath.count))
    }
}
