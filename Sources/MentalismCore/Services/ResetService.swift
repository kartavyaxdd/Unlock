import Foundation

public protocol ResetService {
    func reset()
}

public final class DefaultResetService: ResetService {
    private let store: TrickSessionStore

    public init(store: TrickSessionStore) {
        self.store = store
    }

    public func reset() {
        store.clear()
    }
}
