public enum Location: Codable, Equatable, Hashable {
	public enum Stripped: CaseIterable, Codable, Identifiable {
		public var id: String {
			name
		}

		case aisle
		case dairy
		case produce
		case unknown

		public var name: String {
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

		public init?(rawValue: String) {
			if rawValue.lowercased().contains("aisle") {
				self = .aisle
			} else {
				switch rawValue {
				case "Dairy":
					self = .dairy
				case "Produce":
					self = .produce
				case "Unknown":
					self = .unknown
				default:
					return nil
				}
			}
		}
	}

	case aisle(String)
	case dairy
	case produce
	case unknown

	public init(stripped: Stripped) {
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

	public var stripped: Stripped {
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

	public var name: String {
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

	public var aisleName: String {
		switch self {
		case let .aisle(name):
			return name
		default:
			return ""
		}
	}
}
