import SwiftUI

// Структура для более сложных заданий на производные
// Здесь я дополнительно храню пошаговое решение, потому что задания уже требуют chain rule
struct DetailedDerivativeTask {
    let question: String
    let answers: [String]
    let correctAnswer: String
    let correctText: String
    let wrongText: String
    let solutionSteps: String
}

struct DerSecondPracticeView: View {
    // State для выбранного ответа, показа результата и текущего номера задания
    @State private var selectedAnswer: String? = nil
    @State private var showResult = false
    @State private var currentTaskIndex = 0
    
    // Массив заданий на более сложные производные
    // В каждом задании есть варианты ответов, feedback и подробное объяснение решения
    let tasks = [
        DetailedDerivativeTask(
            question: "sin(4x⁵)",
            answers: [
                "cos(4x⁵)",
                "cos(20x⁴)",
                "20x⁴ · cos(4x⁵)"
            ],
            correctAnswer: "20x⁴ · cos(4x⁵)",
            correctText: "You're doing amazing!",
            wrongText: "Remember: use the chain rule for sin(4x⁵).",
            solutionSteps: """
            1. Let u = 4x⁵. Then u' = 20x⁴.
            2. Recall: d/dx sin(u) = cos(u) · u'.
            3. d/dx sin(4x⁵) = cos(4x⁵) · 20x⁴ =
            = 20x⁴ · cos(4x⁵)
            """
        ),
        
        DetailedDerivativeTask(
            question: "-5cos(-2x³)",
            answers: [
                "-10x² · cos(-2x³)",
                "10x² · sin(-2x³)",
                "-30x² · sin(-2x³)"
            ],
            correctAnswer: "-30x² · sin(-2x³)",
            correctText: "Correct!",
            wrongText: "Hey! Derivative of cos(u) is -sin(u) · u'.",
            solutionSteps: """
            1. Let u = -2x³. Then u' = -6x².
            2. Remember: d/dx cos(u) = -sin(u) · u'.
            3. d/dx [-5cos(-2x³)] =
            = -5 · [-sin(-2x³) · (-6x²)] = 
            = -30x² · sin(-2x³)
            """
        ),
        
        DetailedDerivativeTask(
            question: "sin(3x⁴) + cos(7x²)",
            answers: [
                "cos(3x⁴) - sin(7x²)",
                "12x³ · sin(3x⁴) + 14x · cos(7x²)",
                "12x³ · cos(3x⁴) - 14x · sin(7x²)"
            ],
            correctAnswer: "12x³ · cos(3x⁴) - 14x · sin(7x²)",
            correctText: "You're a fast learner!",
            wrongText: "Differentiate each part separately and use the chain rule.",
            solutionSteps: """
            1. d/dx sin(3x⁴) = cos(3x⁴) · 12x³
            2. d/dx cos(7x²) = -sin(7x²) · 14x
            3. d/dx [sin(3x⁴) + cos(7x²)] = 
            = 12x³ · cos(3x⁴) - 14x · sin(7x²)
            """
        ),
        
        DetailedDerivativeTask(
            question: "1/3 · arctan(2x³)",
            answers: [
                "2x² / (1 + 4x⁶)",
                "1 / (3(1 + 2x³))",
                "2x² / (1 + 2x³)"
            ],
            correctAnswer: "2x² / (1 + 4x⁶)",
            correctText: "Well done!",
            wrongText: "Keep trying! d/dx arctan(u) = u' / (1 + u²).",
            solutionSteps: """
            1. Let u = 2x³. Then u' = 6x².
            2. Recall: d/dx arctan(u) = u' / (1 + u²).
            3. d/dx [1/3 · arctan(2x³)] = 
            = 1/3 · 6x² / (1 + (2x³)²) =
            = 2x² / (1 + 4x⁶)
            """
        )
    ]
    
    // Текущее задание берется из массива по currentTaskIndex
    var currentTask: DetailedDerivativeTask {
        tasks[currentTaskIndex]
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("More practice!")
                    .font(.custom("PixelifySans-Regular", size: 28))
                
                Text("Find the derivative of the function:")
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
                
                // После выбора ответа показываю feedback и подробное решение
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
                    
                    // После каждого задания очищаю выбранный ответ и перехожу к следующему примеру
                    if currentTaskIndex < tasks.count - 1 {
                        SimpleButton(title: "Next!") {
                            currentTaskIndex += 1
                            selectedAnswer = nil
                            showResult = false
                        }
                    } else {
                        // После последнего задания пользователь переходит к revision game
                        NavigationButton(
                            title: "What's next?",
                            destination: DerivativeRevisionView()
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

#Preview {
    NavigationStack {
        DerSecondPracticeView()
    }
}
