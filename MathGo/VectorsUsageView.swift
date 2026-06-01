import SwiftUI

struct TheoryQuestion {
    let question: String
    let answers: [String]
    let correctAnswer: String
    let explanation: String
}

struct VectorsUsageView: View {
    @State private var showFirstParagraph = false
    @State private var showUses = false
    @State private var showGameIntro = false
    @State private var showGame = false
    
    // Вопросы для theory game по применению векторов
    let vectorTheoryQuestions = [
        TheoryQuestion(
            question: "Why are vectors useful in physics?",
            answers: [
                "They can describe forces and motion",
                "They only store random numbers",
                "They replace all equations"
            ],
            correctAnswer: "They can describe forces and motion",
            explanation: "Forces, velocity, and acceleration all have direction and size, so vectors are perfect for them."
        ),
        
        TheoryQuestion(
            question: "What can a vector represent in a game?",
            answers: [
                "Character movement",
                "Only the character's name",
                "Only the background color"
            ],
            correctAnswer: "Character movement",
            explanation: "In games, vectors can describe where an object moves and how fast it moves."
        ),
        
        TheoryQuestion(
            question: "Why are vectors useful in computer graphics?",
            answers: [
                "They help position and move objects",
                "They delete images",
                "They make code disappear"
            ],
            correctAnswer: "They help position and move objects",
            explanation: "Graphics use vectors to move, rotate, and place objects on the screen."
        ),
        
        TheoryQuestion(
            question: "What does a navigation app use vectors for?",
            answers: [
                "Direction and movement",
                "Cooking recipes",
                "Changing phone brightness"
            ],
            correctAnswer: "Direction and movement",
            explanation: "Navigation uses direction and distance, which are vector ideas."
        )
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Where are vectors used?")
                    .font(.custom("PixelifySans-Regular", size: 28))
                
                if showFirstParagraph {
                    Text("Vectors are not just abstract arrows. They are used whenever direction and size matter together.")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .transition(.opacity)
                }
                
                // Этот блок показываю только до начала игры, чтобы экран не был перегружен
                if showUses && !showGame {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Vectors are useful in:")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        
                        Text("1. games: movement, speed, direction")
                        Text("2. navigation: routes and direction")
                        Text("3. physics: forces and velocity")
                        Text("4. graphics: moving and rotating objects")
                        Text("5. robotics: controlling movement")
                    }
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .vectorInfoBox()
                    .transition(.scale.combined(with: .opacity))
                }
                
                if showGameIntro {
                    Text("Now let’s check the idea with a quick theory game!")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .transition(.opacity)
                }
                
                if showGame {
                    TheoryQuizGameView(
                        questions: vectorTheoryQuestions,
                        finalButtonTitle: "Back to linear algebra!",
                        destination: AnyView(LinearAlgebraView())
                    )
                    .transition(.opacity)
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
                // Каждый тап открывает следующий блок экрана
                if !showFirstParagraph {
                    showFirstParagraph = true
                } else if !showUses {
                    showUses = true
                } else if !showGameIntro {
                    showGameIntro = true
                } else if !showGame {
                    showGame = true
                }
            }
        }
    }
}

// Reusable theory game для проверки теоретических знаний
// Я использую ее для вопросов, где важно проверить не вычисления, а понимание идеи
struct TheoryQuizGameView: View {
    let questions: [TheoryQuestion]
    let finalButtonTitle: String
    let destination: AnyView
    
    // Храню выбранный ответ, результат и номер текущего вопроса
    @State private var selectedAnswer: String? = nil
    @State private var showResult = false
    @State private var currentQuestionIndex = 0
    
    var currentQuestion: TheoryQuestion {
        questions[currentQuestionIndex]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(currentQuestion.question)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .vectorInfoBox()
            
            VStack(spacing: 12) {
                ForEach(currentQuestion.answers, id: \.self) { answer in
                    Button {
                        selectedAnswer = answer
                        showResult = true
                    } label: {
                        Text(answer)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundStyle(.black)
                            .multilineTextAlignment(.center)
                            .padding(14)
                            .frame(maxWidth: .infinity)
                            .background(answerColor(answer))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color.black.opacity(0.25), lineWidth: 1.5)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .shadow(radius: 3, y: 2)
                    }
                    .disabled(showResult)
                }
            }
            
            if showResult {
                Text(currentQuestion.explanation)
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .vectorInfoBox()
                    .transition(.opacity)
                
                // После ответа пользователь либо переходит к следующему вопросу, либо завершает игру
                if currentQuestionIndex < questions.count - 1 {
                    SimpleButton(title: "Next!") {
                        currentQuestionIndex += 1
                        selectedAnswer = nil
                        showResult = false
                    }
                } else {
                    NavigationButton(title: "Got it!", destination: destination)
                }
            }
        }
    }
    
    // Цвет ответа показывает, правильный он или нет
    func answerColor(_ answer: String) -> Color {
        if showResult {
            if answer == currentQuestion.correctAnswer {
                return Color.green.opacity(0.75)
            } else if answer == selectedAnswer {
                return Color.red.opacity(0.75)
            }
        }
        
        return Color.white.opacity(0.85)
    }
}

// Reusable modifier для информационных блоков в vector screens
extension View {
    func vectorInfoBox() -> some View {
        self
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white.opacity(0.9))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.black.opacity(0.18), lineWidth: 1.5)
            )
            .shadow(radius: 3, y: 2)
    }
}

#Preview {
    NavigationStack {
        VectorsUsageView()
    }
}
