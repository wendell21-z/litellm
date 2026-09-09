import Foundation

enum AppSection: String, CaseIterable, Identifiable {
    case dashboard
    case models

    var id: String { rawValue }

    var title: String {
        switch self {
        case .dashboard: "Dashboard"
        case .models: "Models"
        }
    }

    var systemImage: String {
        switch self {
        case .dashboard: "gauge.with.dots.needle.33percent"
        case .models: "square.stack.3d.up"
        }
    }
}
