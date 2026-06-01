import SwiftUI

// Структура, в которой я храню данные для каждого задания на definite integrals
struct DefIntegralTask {
    let top: String
    let bottom: String
    let function: String
    let answers: [String]
    let correctAnswer: String
    let correctText: String
    let wrongText: String
    let solutionSteps: String
}

// Экран объясняет definite integrals и затем переводит пользователя к практике
struct DefIntegralView: View {
    // State management
    @State private var showFirstParagraph = false
    @State private var showRule = false
    @State private var showExample = false
    @State private var showPractice = false
    
    // State для практической части: выбранный ответ, показ результата и номер текущего задания
    @State private var selectedAnswer: String? = nil
    @State private var showResult = false
    @State private var currentTaskIndex = 0
    
    // Массив заданий для практики
    // Каждое задание содержит пределы интегрирования, функцию, варианты ответов и пошаговое решение
    let tasks = [
        DefIntegralTask(
            top: "2",
            bottom: "0",
            function: "3x² dx",
            answers: ["8", "6", "12"],
            correctAnswer: "8",
            correctText: "Correct!",
            wrongText: "Remember: first find F(x), then calculate F(b) - F(a).",
            solutionSteps: """
            1. ∫ 3x² dx = x³
            2. F(2) - F(0) = 2³ - 0³
            3. 8 - 0 = 8
            """
        ),
        DefIntegralTask(
            top: "3",
            bottom: "1",
            function: "2x dx",
            answers: ["8", "6", "10"],
            correctAnswer: "8",
            correctText: "Nice work!",
            wrongText: "Find the antiderivative first, then substitute the limits.",
            solutionSteps: """
            1. ∫ 2x dx = x²
            2. F(3) - F(1) = 3² - 1²
            3. 9 - 1 = 8
            """
        ),
        DefIntegralTask(
            top: "1",
            bottom: "0",
            function: "4 dx",
            answers: ["4", "1", "0"],
            correctAnswer: "4",
            correctText: "Correct!",
            wrongText: "For a constant, ∫ c dx = cx.",
            solutionSteps: """
            1. ∫ 4 dx = 4x
            2. F(1) - F(0) = 4(1) - 4(0)
            3. 4 - 0 = 4
            """
        ),
        DefIntegralTask(
            top: "π",
            bottom: "0",
            function: "cos(x) dx",
            answers: ["0", "1", "-1"],
            correctAnswer: "0",
            correctText: "Well done!",
            wrongText: "Remember: ∫ cos(x) dx = sin(x).",
            solutionSteps: """
            1. ∫ cos(x) dx = sin(x)
            2. F(π) - F(0) = sin(π) - sin(0)
            3. 0 - 0 = 0
            """
        ),
        DefIntegralTask(
            top: "1",
            bottom: "0",
            function: "eˣ dx",
            answers: ["e - 1", "e", "1 - e"],
            correctAnswer: "e - 1",
            correctText: "Great job!",
            wrongText: "Remember: ∫ eˣ dx = eˣ, then use the limits.",
            solutionSteps: """
            1. ∫ eˣ dx = eˣ
            2. F(1) - F(0) = e¹ - e⁰
            3. e - 1
            """
        )
    ]
    
    // Текущее задание берется из массива по индексу currentTaskIndex
    var currentTask: DefIntegralTask {
        tasks[currentTaskIndex]
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Definite integrals")
                    .font(.custom("PixelifySans-Regular", size: 28))
                
                // Пока практика не началась, пользователь видит теоретическую часть
                if !showPractice {
                    if showFirstParagraph {
                        Text("A definite integral finds the accumulated amount between two points.")
                            .font(.system(size: 18, weight: .regular, design: .rounded))
                            .transition(.opacity)
                    }
                    
                    if showRule {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 6) {
                                DefiniteIntegralText(
                                    top: "b",
                                    bottom: "a",
                                    function: "f(x) dx"
                                )
                                
                                Text("= F(b) - F(a)")
                            }
                            .formulaBoxStyle()
                            
                            Text("First find the antiderivative F(x), then plug in the upper limit and subtract the lower limit.")
                                .font(.system(size: 18, weight: .regular, design: .rounded))
                        }
                        .transition(.opacity)
                    }
                    
                    if showExample {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Example:")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                            
                            DefiniteIntegralText(
                                top: "2",
                                bottom: "0",
                                function: "2x dx = 4"
                            )
                            .formulaBoxStyle()
                            
                            Text("""
                            1. ∫ 2x dx = x²
                            2. F(2) - F(0) = 2² - 0²
                            3. 4 - 0 = 4
                            """)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .formulaBoxStyle()
                            
                            // После примера пользователь сам запускает практическую часть
                            SimpleButton(title: "Start practice!") {
                                showPractice = true
                            }
                        }
                        .transition(.opacity)
                    }
                }
                
                // Практическая часть появляется после нажатия на Start practice
                if showPractice {
                    Text("Find the value of the definite integral:")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    
                    DefiniteIntegralText(
                        top: currentTask.top,
                        bottom: currentTask.bottom,
                        function: currentTask.function
                    )
                    .formulaBoxStyle()
                    
                    // Варианты ответов создаются автоматически из массива answers текущего задания
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
                    
                    // После выбора ответа показывается результат и пошаговое решение
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
                        
                        // Если задания еще не закончились, пользователь переходит к следующему
                        if currentTaskIndex < tasks.count - 1 {
                            SimpleButton(title: "Next!") {
                                currentTaskIndex += 1
                                selectedAnswer = nil
                                showResult = false
                            }
                        } else {
                            // После последнего задания пользователь переходит к финальному экрану темы
                            NavigationButton(
                                title: "Done!",
                                destination: IntegralConclusionView()
                            )
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
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.5)) {
                // Тапы по экрану управляют постепенным появлением теоретической части
                if !showPractice {
                    if !showFirstParagraph {
                        showFirstParagraph = true
                    } else if !showRule {
                        showRule = true
                    } else if !showExample {
                        showExample = true
                    }
                }
            }
        }
    }
}

// Reusable структура для отображения definite integral с верхним и нижним пределом
// Я использую ее, чтобы интегралы выглядели ближе к обычной математической записи
struct DefiniteIntegralText: View {
    let top: String
    let bottom: String
    let function: String
    
    var body: some View {
        HStack(spacing: 6) {
            VStack(spacing: -5) {
                Text(top)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                
                Text("∫")
                    .font(.system(size: 36, weight: .semibold, design: .rounded))
                
                Text(bottom)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
            }
            
            Text(function)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
        }
    }
}

#Preview {
    NavigationStack {
        DefIntegralView()
    }
}
