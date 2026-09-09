import Foundation

@MainActor
final class LiteLLMProcessService {
    private var process: Process?

    var isRunning: Bool {
        process?.isRunning == true
    }

    func start(configURL: URL, port: Int, environment: [String: String]) throws {
        stop()

        let repositoryRoot = try RepositoryRootResolver.resolve(from: URL(fileURLWithPath: #filePath))
        let proxyCLI = repositoryRoot.appending(path: "litellm/proxy/proxy_cli.py")
        let python = URL(fileURLWithPath: "/usr/bin/python3")

        let task = Process()
        task.executableURL = python
        task.currentDirectoryURL = repositoryRoot
        task.arguments = [
            proxyCLI.path,
            "--config", configURL.path,
            "--port", String(port),
            "--host", "127.0.0.1"
        ]
        task.environment = ProcessInfo.processInfo.environment.merging(environment) { _, new in new }

        let output = Pipe()
        task.standardOutput = output
        task.standardError = output
        try task.run()
        process = task
    }

    func stop() {
        guard let process else {
            return
        }
        if process.isRunning {
            process.terminate()
        }
        self.process = nil
    }
}
