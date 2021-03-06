import SwiftUI

internal extension ViewType {
    struct IDView { }
}

// MARK: - Content Extraction

extension ViewType.IDView: SingleViewContent {
    
    static func child(_ content: Content, injection: Any) throws -> Content {
        let view = try Inspector.attribute(label: "content", value: content.view)
        return try Inspector.unwrap(view: view, modifiers: content.modifiers +
            [IDViewModifier(view: content.view)])
    }
}

// MARK: - Private

private struct IDViewModifier: ModifierNameProvider {
    static var modifierName: String { "IDView" }
    var modifierType: String { IDViewModifier.modifierName }
    let view: Any
}

// MARK: - Global View Modifiers

public extension InspectableView {
    
    func id() throws -> AnyHashable {
        return try modifierAttribute(
            modifierName: IDViewModifier.modifierName,
            path: "view|id", type: AnyHashable.self, call: "id")
    }
}
