import SwiftUI

/// The default inline image provider, which loads images from the network.
public struct DefaultInlineImageProvider: InlineImageProvider {
  public func image(with url: URL, label: String) async throws -> Image {
    let (data, _) = try await URLSession.shared.data(from: url)
    #if canImport(UIKit)
    guard let uiImage = UIImage(data: data) else {
      throw URLError(.cannotDecodeContentData)
    }
    return Image(uiImage: uiImage)
    #elseif canImport(AppKit)
    guard let nsImage = NSImage(data: data) else {
      throw URLError(.cannotDecodeContentData)
    }
    return Image(nsImage: nsImage)
    #endif
  }
}

extension InlineImageProvider where Self == DefaultInlineImageProvider {
  /// The default inline image provider, which loads images from the network.
  ///
  /// Use the `markdownInlineImageProvider(_:)` modifier to configure
  /// this image provider for a view hierarchy.
  public static var `default`: Self {
    .init()
  }
}
