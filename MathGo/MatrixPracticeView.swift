import SwiftUI

// Структура для заданий, где пользователь должен найти пропущенное значение в результате операции с матрицами
struct MatrixFillTask {
    let firstMatrix: [[String]]
    let operation: String
    let secondMatrix: [[String]]
    let resultMatrix: [[String]]
    let answers: [String]
    let correctAnswer: String
    let correctText: String
    let wrongText: String
    let solutionSteps: String
}

struct MatrixPracticeView: View {
    @State private var selectedAnswer: String? = nil
    @State private var showResult = false
    @State private var currentTaskIndex = 0
    
    // Массив заданий на сложение, вычитание и умножение матрицы на число
    let tasks = [
        MatrixFillTask(
            firstMatrix: [
                ["1", "2"],
                ["3", "4"]
            ],
            operation: "+",
            secondMatrix: [
                ["5", "7"],
                ["7", "8"]
            ],
            resultMatrix: [
                ["6", "?"],
                ["10", "12"]
            ],
            answers: ["5", "9", "10"],
            correctAnswer: "9",
            correctText: "",
            wrongText: "",
            solutionSteps: ""
        ),
        
        MatrixFillTask(
            firstMatrix: [
                ["2", "4"],
                ["1", "3"]
            ],
            operation: "+",
            secondMatrix: [
                ["5", "1"],
                ["2", "2"]
            ],
            resultMatrix: [
                ["7", "5"],
                ["?", "5"]
            ],
            answers: ["6", "8", "3"],
            correctAnswer: "3",
            correctText: "",
            wrongText: "",
            solutionSteps: ""
        ),
        
        MatrixFillTask(
            firstMatrix: [
                ["3", "2"],
                ["4", "1"]
            ],
            operation: "-",
            secondMatrix: [
                ["1", "5"],
                ["4", "3"]
            ],
            resultMatrix: [
                ["2", "-3"],
                ["?", "-2"]
            ],
            answers: ["0", "4", "8"],
            correctAnswer: "0",
            correctText: "",
            wrongText: "",
            solutionSteps: ""
        ),
        
        MatrixFillTask(
            firstMatrix: [
                ["2", "0"],
                ["1", "3"]
            ],
            operation: "× 3",
            secondMatrix: [],
            resultMatrix: [
                ["6", "0"],
                ["?", "9"]
            ],
            answers: ["2", "3", "8"],
            correctAnswer: "3",
            correctText: "",
            wrongText: "",
            solutionSteps: ""
        )
    ]
    
    // Текущее задание берется из массива по currentTaskIndex
    var currentTask: MatrixFillTask {
        tasks[currentTaskIndex]
    }
    
    // Здесь выбранный ответ вставляется прямо в матрицу вместо знака вопроса
    var displayedResultMatrix: [[String]] {
        currentTask.resultMatrix.map { row in
            row.map { value in
                if value == "?" {
                    return selectedAnswer ?? "?"
                } else {
                    return value
                }
            }
        }
    }
    
    // Цвет вставленного значения показывает, правильный ответ или нет
    var selectedAnswerColor: Color {
        if selectedAnswer == currentTask.correctAnswer {
            return Color.green
        } else {
            return Color.red
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Matrix practice!")
                    .font(.custom("PixelifySans-Regular", size: 28))
                
                Text("Find the missing value.")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                
                // Показываю две матрицы, знак операции и результат с пропущенным значением
                VStack(spacing: 12) {
                    MatrixText(rows: currentTask.firstMatrix)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text(currentTask.operation)
                        .font(.system(size: 26, weight: .semibold, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    if !currentTask.secondMatrix.isEmpty {
                        MatrixText(rows: currentTask.secondMatrix)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    Text("=")
                        .font(.system(size: 26, weight: .semibold, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    MatrixText(
                        rows: displayedResultMatrix,
                        highlightedValue: selectedAnswer,
                        highlightColor: showResult ? selectedAnswerColor : .black
                    )
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
                // Варианты ответов исчезают после выбора, потому что ответ уже вставлен в матрицу
                if !showResult {
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
                    .padding(.top, 14)
                }
                
                if showResult {
                    if selectedAnswer == currentTask.correctAnswer {
                        Text(currentTask.correctText)
                            .font(.system(size: 18, weight: .regular, design: .rounded))
                            .transition(.opacity)
                        
                        // Если ответ правильный, пользователь переходит к следующему заданию
                        if currentTaskIndex < tasks.count - 1 {
                            SimpleButton(title: "Next!") {
                                currentTaskIndex += 1
                                selectedAnswer = nil
                                showResult = false
                            }
                        } else {
                            NavigationButton(
                                title: "Continue!",
                                destination: MatrixUsageView()
                            )
                        }
                    } else {
                        Text(currentTask.wrongText)
                            .font(.system(size: 18, weight: .regular, design: .rounded))
                            .transition(.opacity)
                        
                        // Если ответ неправильный, пользователь может попробовать еще раз
                        SimpleButton(title: "Try again!") {
                            selectedAnswer = nil
                            showResult = false
                        }
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
        MatrixPracticeView()
    }
}
