enum Location: Codable, Equatable, Hashable {
  enum Stripped: CaseIterable, Codable, Identifiable {
    var id: String {
      name
    }

    case aisle
    case dairy
    case produce
    case unknown

    var name: String {
      switch self {
      case .aisle:
        return "Aisle"
      case .dairy:
        return "Dairy"
      case .produce:
        return "Produce"
      case .unknown:
        return "Unknown"
      }
    }
  }

  case aisle(String)
  case dairy
  case produce
  case unknown

  init(stripped: Stripped) {
    switch stripped {
    case .aisle:
      self = .aisle("")
    case .dairy:
      self = .dairy
    case .produce:
      self = .produce
    default:
      self = .unknown
    }
  }

  var stripped: Stripped {
    switch self {
    case .aisle:
      return .aisle
    case .dairy:
      return .dairy
    case .produce:
      return .produce
    case .unknown:
      return .unknown
    }
  }

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
