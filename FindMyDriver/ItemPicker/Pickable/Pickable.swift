import UIKit

public struct Pickable<T> {
    public let value: T
    public let title: String
    public let image: String

    public init(value: T, title: String, image: String) {
        self.value = value
        self.title = title
        self.image = image
    }
}
