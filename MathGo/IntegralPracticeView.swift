import SwiftUI

// Структура для заданий на интегралы
// В ней я храню пример, варианты ответов, правильный ответ, feedback и решение
struct IntegralTask {
    let question: String
    let answers: [String]
    let correctAnswer: String
    let correctText: String
    let wrongText: String
    let solutionSteps: String
}

struct IntegralPracticeView: View {
    @State private var selectedAnswer: String? = nil
    @State private var showResult = false
    @State private var currentTaskIndex = 0
    
    // Массив заданий на основные формулы интегрирования
    let tasks = [
        IntegralTask(
            question: "∫ 7 dx",
            answers: [
                "7x + C",
                "7 + C",
                "x⁷ + C"
            ],
            correctAnswer: "7x + C",
            correctText: "Correct!",
            wrongText: "Remember: ∫ c dx = cx + C.",
            solutionSteps: """
            1. ∫ c dx = cx + C
            2. ∫ 7 dx = 7x + C
            """
        ),
        
        IntegralTask(
            question: "∫ x³ dx",
            answers: [
                "3x² + C",
                "x⁴ / 4 + C",
                "x⁴ + C"
            ],
            correctAnswer: "x⁴ / 4 + C",
            correctText: "Well done!",
            wrongText: "Use the power rule and increase the power by 1, then divide by the new power.",
            solutionSteps: """
            1. ∫ xⁿ dx = xⁿ⁺¹ / (n + 1) + C
            2. ∫ x³ dx = x⁴ / 4 + C
            """
        ),
        
        IntegralTask(
            question: "∫ 6x² dx",
            answers: [
                "2x³ + C",
                "6x³ + C",
                "12x + C"
            ],
            correctAnswer: "2x³ + C",
            correctText: "Great job!",
            wrongText: "Increase the power by 1, then divide by the new power.",
            solutionSteps: """
            1. ∫ 6x² dx = 6 ∫ x² dx
            2. ∫ x² dx = x³ / 3
            3. 6 · x³ / 3 = 2x³
            4. ∫ 6x² dx = 2x³ + C
            """
        ),
        
        IntegralTask(
            question: "∫ eˣ dx",
            answers: [
                "eˣ + C",
                "xeˣ + C",
                "1/eˣ + C"
            ],
            correctAnswer: "eˣ + C",
            correctText: "Wow!",
            wrongText: "Recall: eˣ stays eˣ when integrating.",
            solutionSteps: """
            Main formula: ∫ eˣ dx = eˣ + C
            """
        ),
        
        IntegralTask(
            question: "∫ cos(x) dx",
            answers: [
                "sin(x) + C",
                "-sin(x) + C",
                "-cos(x) + C"
            ],
            correctAnswer: "sin(x) + C",
            correctText: "Nice work!",
            wrongText: "Keep trying! The integral of cos(x) is sin(x) + C.",
            solutionSteps: """
            Main formula: ∫ cos(x) dx = sin(x) + C
            Check: d/dx sin(x) = cos(x)
            """
        )
    ]
    
    // Текущее задание берется из массива по currentTaskIndex
    var currentTask: IntegralTask {
        tasks[currentTaskIndex]
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Integral practice!")
                    .font(.custom("PixelifySans-Regular", size: 28))
                
                Text("Find the integral:")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                
                Text(currentTask.question)
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
                
                // После выбора ответа показываю feedback и решение
                if showResult {
                    VStack(alignment: .leading, spacing: 10) {
                        if selectedAnswer == currentTask.correctAnswer {
                            Text(currentTask.correctText)
                                .font(.system(size: 18, weight: .regular, design: .rounded))
                        } else {
                            Text(currentTask.wrongText)
                                .font(.system(size: 18, weight: .regular, design: .rounded))
                        }
                        
                        Text(currentTask.solutionSteps)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .formulaBoxStyle()
                    }
                    .transition(.opacity)
                    
                    // После каждого задания очищаю выбранный ответ и показываю следующий пример
                    if currentTaskIndex < tasks.count - 1 {
                        SimpleButton(title: "Next!") {
                            currentTaskIndex += 1
                            selectedAnswer = nil
                            showResult = false
                        }
                    } else {
                        // После последнего задания пользователь переходит к definite integrals
                        NavigationButton(
                            title: "Got it!",
                            destination: DefIntegralView()
                        )
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 26)
            .padding(.top, 8)
            .padding(.bottom, 24)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
    }
}

// Отдельный revision screen для основных формул интегрирования
// Он использует тот же reusable matching game component, что и revision по производным
struct IntegralRevisionView: View {
    // Пары для matching game
    let pairs = [
        RevisionPair(left: "∫ c dx", right: "cx + C"),
        RevisionPair(left: "∫ xⁿ dx", right: "xⁿ⁺¹ / (n + 1) + C"),
        RevisionPair(left: "∫ eˣ dx", right: "eˣ + C"),
        RevisionPair(left: "∫ 1/x dx", right: "ln|x| + C"),
        RevisionPair(left: "∫ sin(x) dx", right: "-cos(x) + C"),
        RevisionPair(left: "∫ cos(x) dx", right: "sin(x) + C")
    ]
    
    // Варианты справа вынесены отдельно, чтобы порядок ответов отличался от порядка правильных пар
    let rightOptions = [
        "cx + C",
        "ln|x| + C",
        "sin(x) + C",
        "eˣ + C",
        "-cos(x) + C",
        "xⁿ⁺¹ / (n + 1) + C"
    ]
    
    var body: some View {
        // Использую общий matching game component для повторения формул
        FormulaMatchingGameView(
            title: "Integral revision!",
            instruction: "Tap an integral, then tap its result.",
            pairs: pairs,
            rightOptions: rightOptions,
            buttonTitle: "Next!",
            destination: AnyView(CalculusView())
        )
    }
}

#Preview {
    NavigationStack {
        IntegralPracticeView()
    }
}
