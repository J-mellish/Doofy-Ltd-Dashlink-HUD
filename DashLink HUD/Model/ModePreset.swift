import Foundation

struct ModePreset: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let tileIDs: [String]  // 6 items, left->right, top->bottom
    let skinID: String
}
