import SwiftUI

// Reusable структура для однотипных заданий на выбор правильного варианта
// В ней я храню сам пример, варианты ответов, правильный ответ и фидбэк
struct DerivativeTask {
    let question: String
    let answers: [String]
    let correctAnswer: String
    let correctText: String
    let wrongText: String
}

struct DerFirstPracticeView: View {
    // State для практической части
    @State private var selectedAnswer: String? = nil
    @State private var showResult = false
    @State private var currentTaskIndex = 0
    
    // Массив заданий на базовые правила
    // Такой подход позволяет переключаться между заданиями через индекс, не создавая отдельный экран для каждого примера
    let tasks = [
        DerivativeTask(
            question: "(x³ · 4)",
            answers: ["3x²", "12x²", "4x³"],
            correctAnswer: "12x²",
            correctText: "Good job! Since d/dx (x³) = 3x², then 4 · 3x² = 12x².",
            wrongText: "Remember: d/dx (x³) = 3x², then multiply by 4."
        ),
        DerivativeTask(
            question: "(137)",
            answers: ["0", "137x", "1"],
            correctAnswer: "0",
            correctText: "Correct! The derivative of any constant is always 0.",
            wrongText: "It's a tricky one! Constants do not change, so their derivative is 0."
        ),
        DerivativeTask(
            question: "(eˣ)",
            answers: ["xeˣ⁻¹", "eˣ", "1/eˣ"],
            correctAnswer: "eˣ",
            correctText: "Well done! The derivative of eˣ is still eˣ.",
            wrongText: "Revision time: d/dx (eˣ) = eˣ."
        ),
        DerivativeTask(
            question: "(x · ln(x))",
            answers: ["ln(x) + 1", "x · ln(x)", "1/x"],
            correctAnswer: "ln(x) + 1",
            correctText: "You're killing it! Use the product rule: x' · ln(x) + x · (ln(x))' = ln(x) + 1.",
            wrongText: "Not quite. This is a product. Use the product rule."
        ),
        DerivativeTask(
            question: "(x² + x³)",
            answers: ["5x⁴", "2x + 3x²", "x + x²"],
            correctAnswer: "2x + 3x²",
            correctText: "That is correct! Differentiate each part: d/dx (x²) = 2x and d/dx (x³) = 3x².",
            wrongText: "Practice makes perfect! For sums, you need to differentiate each part separately."
        )
    ]
    
    // Текущее задание берется из массива по индексу currentTaskIndex
    var currentTask: DerivativeTask {
        tasks[currentTaskIndex]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Practice time!")
                .font(.custom("PixelifySans-Regular", size: 28))
            
            Text("Find the derivative:")
                .font(.system(size: 18, weight: .regular, design: .rounded))
            
            HStack(spacing: 6) {
                FractionText(
                    top: "d",
                    bottom: "dx",
                    lineWidth: 24
                )
                
                Text(currentTask.question)
            }
            .formulaBoxStyle()
            
            // Варианты ответов создаются из массива answers текущего задания
            VStack(spacing: 14) {
                ForEach(currentTask.answers, id: \.self) { answer in
                    AnswerButton(
                        title: answer,
                        selectedAnswer: selectedAnswer,
                        correctAnswer: currentTask.correctAnswer,
                        showResult: showResult
                    ) {
                        selectedAnswer = answer
                        showResult = true
                    }
                }
            }
            
            // После выбора ответа показывается фидбэк
            if showResult {
                if selectedAnswer == currentTask.correctAnswer {
                    Text(currentTask.correctText)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .transition(.opacity)
                } else {
                    Text(currentTask.wrongText)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .transition(.opacity)
                }
                
                // Если задания еще остались, кнопка переключает пользователя на следующий пример
                if currentTaskIndex < tasks.count - 1 {
                    SimpleButton(title: "Next!") {
                        currentTaskIndex += 1
                        selectedAnswer = nil
                        showResult = false
                    }
                } else {
                    // После последнего задания пользователь переходит к следующей теоретической части
                    VStack(spacing: 14) {
                        NavigationButton(
                            title: "Keep learning!",
                            destination: ComplexFormulasView()
                        )
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .transition(.scale.combined(with: .opacity))
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 26)
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

// Reusable структура для кнопки ответа
// Я использую ее в practice screens, чтобы одинаково показывать правильные и неправильные ответы
struct AnswerButton: View {
    let title: String
    let selectedAnswer: String?
    let correctAnswer: String
    let showResult: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .foregroundStyle(.black)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 2)
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 3, y: 2)
        }
        // После выбора ответа кнопки блокируются, чтобы пользователь не мог менять ответ после фидбэка
        .disabled(showResult)
    }
    
    // Цвет кнопки зависит от результата:
    // правильный ответ становится зеленым, а выбранный неправильный меняется на красный
    private var backgroundColor: Color {
        if showResult {
            if title == correctAnswer {
                return Color.green.opacity(0.85)
            } else if title == selectedAnswer {
                return Color.red.opacity(0.85)
            }
        }
        
        return Color.white.opacity(0.85)
    }
}

#Preview {
    NavigationStack {
        DerFirstPracticeView()
    }
}
