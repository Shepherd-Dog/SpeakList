enum Location: Codable, Equatable, Hashable {
  case aisle(String)
  case dairy
  case produce
  case unknown

  // TODO: Find a better way to do everything that uses this `types`
  static var types: [String] = [
    "Aisle",
    "Dairy",
    "Produce",
    "Unknown",
  ]

  var name: String {
    switch self {
    case let .aisle(aisle):
      return "Aisle \(aisle)"
    case .dairy:
      return "Dairy"
    case .produce:
      return "Produce"
    case .unknown:
      return "Unknown"
    }
  }
}
