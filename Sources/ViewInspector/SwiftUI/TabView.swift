import SwiftUI

#if !os(watchOS)

public extension ViewType {
    
    struct TabView: KnownViewType {
        public static var typePrefix: String = "TabView"
    }
}

public extension TabView {
    
    func inspect() throws -> InspectableView<ViewType.TabView> {
        return try .init(ViewInspector.Content(self))
    }
}

// MARK: - Content Extraction

extension ViewType.TabView: MultipleViewContent {
    
    public static func children(_ content: Content, injection: Any) throws -> LazyGroup<Content> {
        let content = try Inspector.attribute(label: "content", value: content.view)
        return try Inspector.viewsInContainer(view: content)
    }
}

// MARK: - Extraction from SingleViewContent parent

public extension InspectableView where View: SingleViewContent {
    
    func tabView() throws -> InspectableView<ViewType.TabView> {
        return try .init(try child())
    }
}

// MARK: - Extraction from MultipleViewContent parent

public extension InspectableView where View: MultipleViewContent {
    
    func tabView(_ index: Int) throws -> InspectableView<ViewType.TabView> {
        return try .init(try child(at: index))
    }
}

#endif

// MARK: - Global View Modifiers

public extension InspectableView {
    
    func tag() throws -> AnyHashable {
        return try modifierAttribute(
            modifierName: "TagValueTraitKey",
            path: "modifier|value|tagged", type: AnyHashable.self, call: "tag")
    }
    
    #if !os(watchOS)
    func tabItem() throws -> InspectableView<ViewType.ClassifiedView> {
        let rootView = try modifierAttribute(
            modifierName: "TabItemTraitKey", path: "modifier|value|some|storage|view|content",
            type: Any.self, call: "tabItem")
        return try .init(Content(rootView))
    }
    #endif
}
