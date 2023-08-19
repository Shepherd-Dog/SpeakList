import SwiftUI

public struct TextField: View {
  var label: LocalizedStringKey
  @Binding var text: String

  public init(_ label: LocalizedStringKey, text: Binding<String>) {
    self.label = label
    self._text = text
  }

  public var body: some View {
    VStack(alignment: .leading) {
      Text(label)
        .padding(.leading, 8)
      SwiftUI.TextField(
        text: $text) {
          Text("")
        }
        .background(Color.textFieldBackground)
        .textFieldStyle(RoundedTextFieldStyle())
        .clipShape(
          RoundedRectangle(
            cornerRadius: 8,
            style: .continuous
          )
        )
    }
  }
}

struct RoundedTextFieldStyle: TextFieldStyle {
  func _body(configuration: SwiftUI.TextField<Self._Label>) -> some View {
    configuration
      .padding()
      .overlay {
        RoundedRectangle(
          cornerRadius: 8,
          style: .continuous
        )
        .stroke(
          Color(
            UIColor.systemGray4
          ),
          lineWidth: 2
        )
      }
  }
}

struct Preview: View {
  @State var text: String = ""

  var body: some View {
    TextField("Text", text: $text)
      .background(Color(uiColor: .systemTeal))
  }
}

#Preview {

  Preview()
}
