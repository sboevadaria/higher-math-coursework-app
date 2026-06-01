import SwiftUI

// Структура для пары в revision game
// В left храню функцию или понятие, а в right — правильную пару к нему
struct RevisionPair {
    let left: String
    let right: String
}

struct DerivativeRevisionView: View {
    // Здесь задаю пары формул для повторения производных
    let pairs = [
        RevisionPair(left: "sin(u)", right: "cos(u) · u'"),
        RevisionPair(left: "cos(u)", right: "-sin(u) · u'"),
        RevisionPair(left: "tan(u)", right: "sec²(u) · u'"),
        RevisionPair(left: "arctan(u)", right: "u' / (1 + u²)"),
        RevisionPair(left: "xⁿ", right: "n · xⁿ⁻¹"),
        RevisionPair(left: "ln(u)", right: "u' / u"),
        RevisionPair(left: "eᵘ", right: "eᵘ · u'")
    ]
    
    // Правые варианты вынесены отдельно, чтобы их можно было показывать в нужном порядке
    let rightOptions = [
        "cos(u) · u'",
        "u' / u",
        "u' / (1 + u²)",
        "sec²(u) · u'",
        "-sin(u) · u'",
        "eᵘ · u'",
        "n · xⁿ⁻¹"
    ]
    
    var body: some View {
        // Использую общий matching game component, чтобы такую же механику можно было применять в других темах
        FormulaMatchingGameView(
            title: "Let's revise!",
            instruction: "Tap a function, then tap its derivative.",
            pairs: pairs,
            rightOptions: rightOptions,
            buttonTitle: "More lessons!",
            destination: AnyView(CalculusView())
        )
    }
}

// Reusable game component для matching tasks
// Он принимает title, instruction, пары, варианты справа и экран, на который нужно перейти после завершения
struct FormulaMatchingGameView: View {
    let title: String
    let instruction: String
    let pairs: [RevisionPair]
    let rightOptions: [String]
    let buttonTitle: String
    let destination: AnyView
    
    // selectedLeft хранит выбранный элемент из левой колонки
    @State private var selectedLeft = ""
    
    // matchedLefts хранит элементы, которые пользователь уже сопоставил правильно
    @State private var matchedLefts: [String] = []
    
    // wrongRight нужен для короткого красного feedback, если пользователь выбрал неправильный вариант
    @State private var wrongRight = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text(title)
                    .font(.custom("PixelifySans-Regular", size: 32))
                
                Text(instruction)
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                
                // Две колонки: слева функции, справа их производные
                HStack(alignment: .top, spacing: 14) {
                    VStack(spacing: 12) {
                        ForEach(pairs, id: \.left) { pair in
                            Button {
                                selectedLeft = pair.left
                            } label: {
                                Text(pair.left)
                                    .revisionBox(
                                        backgroundColor: boxColorForLeft(pair.left)
                                    )
                            }
                            // Уже найденные пары больше нельзя выбрать повторно
                            .disabled(matchedLefts.contains(pair.left))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    Text("→")
                        .font(.custom("PixelifySans-Regular", size: 30))
                        .padding(.top, 16)
                    
                    VStack(spacing: 12) {
                        ForEach(rightOptions, id: \.self) { right in
                            Button {
                                checkAnswer(right)
                            } label: {
                                Text(right)
                                    .revisionBox(
                                        backgroundColor: boxColorForRight(right)
                                    )
                            }
                            // Правую колонку нельзя нажимать, пока пользователь не выбрал элемент слева
                            .disabled(selectedLeft.isEmpty || isRightMatched(right))
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // Когда все пары найдены, показываю финальное сообщение и кнопку перехода дальше
                if matchedLefts.count == pairs.count {
                    VStack(spacing: 12) {
                        Text("You matched all formulas correctly.")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        
                        NavigationLink {
                            destination
                        } label: {
                            Text(buttonTitle)
                                .font(.custom("PixelifySans-Regular", size: 28))
                                .foregroundStyle(.black)
                                .padding(.vertical, 24)
                                .frame(width: 260)
                                .background(
                                    RoundedRectangle(cornerRadius: 22)
                                        .fill(Color.blue.opacity(1.0))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 22)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                                .shadow(radius: 4, y: 3)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
                Spacer()
            }
            .padding(.horizontal, 26)
            .padding(.top, 8)
            .padding(.bottom, 24)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
    }
    
    // Проверяю, совпадает ли выбранная правая часть с выбранной левой частью
    func checkAnswer(_ right: String) {
        guard let pair = pairs.first(where: { $0.left == selectedLeft }) else {
            return
        }
        
        if pair.right == right {
            matchedLefts.append(pair.left)
            selectedLeft = ""
            wrongRight = ""
        } else {
            wrongRight = right
            
            // Красный feedback исчезает через короткое время
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                wrongRight = ""
            }
        }
    }
    
    // Проверяю, была ли правая часть уже правильно сопоставлена
    func isRightMatched(_ right: String) -> Bool {
        for left in matchedLefts {
            if let pair = pairs.first(where: { $0.left == left }) {
                if pair.right == right {
                    return true
                }
            }
        }
        
        return false
    }
    
    // Цвет левой карточки показывает ее состояние: обычная, выбранная или уже правильно сопоставленная
    func boxColorForLeft(_ left: String) -> Color {
        if matchedLefts.contains(left) {
            return Color.green.opacity(0.75)
        } else if selectedLeft == left {
            return Color.yellow.opacity(0.8)
        } else {
            return Color.white.opacity(0.85)
        }
    }
    
    // Цвет правой карточки показывает правильный match или ошибку
    func boxColorForRight(_ right: String) -> Color {
        if isRightMatched(right) {
            return Color.green.opacity(0.75)
        } else if wrongRight == right {
            return Color.red.opacity(0.75)
        } else {
            return Color.white.opacity(0.85)
        }
    }
}

// Reusable modifier для одинакового вида карточек в revision game
extension View {
    func revisionBox(backgroundColor: Color) -> some View {
        self
            .font(.system(size: 16, weight: .semibold, design: .rounded))
            .foregroundStyle(.black)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .minimumScaleFactor(0.75)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, minHeight: 58, maxHeight: 58)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.black.opacity(0.2), lineWidth: 1)
            )
    }
}

#Preview {
    NavigationStack {
        DerivativeRevisionView()
    }
}
