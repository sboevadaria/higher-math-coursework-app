import SwiftUI

// Структура для заданий на векторы
// В ней я храню условие, варианты ответов, правильный ответ и пошаговое решение
struct VectorTask {
    let question: String
    let answers: [String]
    let correctAnswer: String
    let correctText: String
    let wrongText: String
    let solutionSteps: String
}

struct VectorPracticeView: View {
    @State private var selectedAnswer: String? = nil
    @State private var showResult = false
    @State private var currentTaskIndex = 0
    
    // Массив заданий на длину вектора и базовые операции с векторами
    let tasks = [
        VectorTask(
            question: "v = (3, 4)",
            answers: [
                "5",
                "7",
                "25"
            ],
            correctAnswer: "5",
            correctText: "You're doing amazing!",
            wrongText: "Remember: length of (x, y) is √(x² + y²).",
            solutionSteps: """
            1. Use the formula: |v| = √(x² + y²)
            2. |v| = √(3² + 4²)
            3. |v| = √(9 + 16) = √25 = 5
            """
        ),
        
        VectorTask(
            question: "v = (2, 3) + (1, 4)",
            answers: [
                "√58",
                "10",
                "√10"
            ],
            correctAnswer: "√58",
            correctText: "Correct!",
            wrongText: "Add matching coordinates: first with first, second with second.",
            solutionSteps: """
            1. Use the rule: (a, b) + (c, d) = (a + c, b + d)
            2. (2, 3) + (1, 4) = (2 + 1, 3 + 4) = (3, 7)
            3. |v| = √(3² + 7²) = √58
            """
        ),
        
        VectorTask(
            question: "v = (2, 4) - (5, 1)",
            answers: [
                "√9",
                "0",
                "√18"
            ],
            correctAnswer: "√18",
            correctText: "Yeah!",
            wrongText: "Subtract matching coordinates.",
            solutionSteps: """
            1. Use the rule: (a, b) - (c, d) = (a - c, b - d)
            2. (2, 4) - (5, 1) = (2 - 5, 4 - 1) = (-3, 3)
            3. |v| = √((-3)² + 3²) = √18
            """
        ),
        
        VectorTask(
            question: "v = 2 · (3, -1)",
            answers: [
                "6",
                "√40",
                "4"
            ],
            correctAnswer: "√40",
            correctText: "Well done!",
            wrongText: "Multiply both coordinates by the number.",
            solutionSteps: """
            1. Use the rule: k · (a, b) = (ka, kb)
            2. 2 · (3, -1) = (2 · 3, 2 · -1) = (6, -2)
            3. |v| = √(6² + (-2)²) = √40
            """
        )
    ]
    
    // Текущее задание берется из массива по currentTaskIndex
    var currentTask: VectorTask {
        tasks[currentTaskIndex]
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Let's test your skills!")
                    .font(.custom("PixelifySans-Regular", size: 28))
                
                Text("Find the length of the vector:")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                
                HStack(spacing: 6) {
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
                        // После последнего задания пользователь переходит к экрану с применением векторов
                        NavigationButton(
                            title: "Killed it!",
                            destination: VectorsUsageView()
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
        VectorPracticeView()
    }
}

