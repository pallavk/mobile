import SwiftUI

private struct CaptureMethod: Identifiable {
    let title: LocalizedStringKey
    let detail: LocalizedStringKey
    let systemImage: String

    var id: String { systemImage }
}

struct EmptyTrayGuide: View {
    private let captureMethods = [
        CaptureMethod(title: "Add directly", detail: "Tap Add for new text, a photo, or the camera.", systemImage: "plus.circle"),
        CaptureMethod(title: "Save your clipboard", detail: "Copy text, a link, an image, or a PDF. Pocket Tray will offer Save Clipboard.", systemImage: "clipboard"),
        CaptureMethod(title: "Share from another app", detail: "Choose Share, then Pocket Tray. You can also add Save Clipboard to Control Center or Shortcuts.", systemImage: "square.and.arrow.up"),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 10) {
                    Image(systemName: "tray")
                        .font(.system(size: 42, weight: .medium))
                        .foregroundStyle(.tint)
                        .accessibilityHidden(true)
                    Text("Your tray is ready")
                        .font(.title2.bold())
                    Text("Save something once, then reuse it whenever you need it.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                VStack(spacing: 18) {
                    ForEach(captureMethods) { method in
                        HStack(alignment: .top, spacing: 14) {
                            Image(systemName: method.systemImage)
                                .font(.title3.weight(.semibold))
                                .foregroundStyle(.tint)
                                .frame(width: 28)
                                .accessibilityHidden(true)
                            VStack(alignment: .leading, spacing: 3) {
                                Text(method.title).font(.headline)
                                Text(method.detail)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            Spacer(minLength: 0)
                        }
                    }
                }
                .frame(maxWidth: 480)
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 32)
            .frame(maxWidth: .infinity)
        }
        .accessibilityIdentifier("empty-tray-guide")
    }
}

struct FirstSavedObjectHint: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "doc.on.doc")
                .foregroundStyle(.tint)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text("Reuse your saved object")
                    .font(.subheadline.weight(.semibold))
                Text("Tap it to copy, open, or share it, then paste it wherever you need it.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
        }
        .padding(14)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("first-saved-object-hint")
    }
}
