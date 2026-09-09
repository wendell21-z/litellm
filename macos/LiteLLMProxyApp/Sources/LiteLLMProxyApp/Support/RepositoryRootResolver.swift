import Foundation

enum RepositoryRootResolver {
    static func resolve(from sourceFile: URL) throws -> URL {
        let components = sourceFile.pathComponents
        guard let index = components.lastIndex(of: "macos") else {
            throw RepositoryRootError.notFound
        }
        let rootComponents = components.prefix(index)
        return URL(fileURLWithPath: rootComponents.joined(separator: "/"), isDirectory: true)
    }
}

enum RepositoryRootError: LocalizedError {
    case notFound

    var errorDescription: String? {
        "Could not resolve LiteLLM repository root"
    }
}
