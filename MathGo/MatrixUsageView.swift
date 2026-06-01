import SwiftUI

struct MatrixUsageView: View {
    @State private var showFirstParagraph = false
    @State private var showUses = false
    @State private var showGameIntro = false
    @State private var showGame = false
    
    // Вопросы для theory game по применению матриц
    let matrixTheoryQuestions = [
        TheoryQuestion(
            question: "Why are matrices useful for data?",
            answers: [
                "They organize numbers into rows and columns",
                "They remove all numbers",
                "They only work with letters"
            ],
            correctAnswer: "They organize numbers into rows and columns",
            explanation: "Matrices are useful because they store information in a clear grid."
        ),
        
        TheoryQuestion(
            question: "What can matrices do in graphics?",
            answers: [
                "Move and transform objects",
                "Delete the screen",
                "Only change sound"
            ],
            correctAnswer: "Move and transform objects",
            explanation: "Matrices can help move, rotate, stretch, or scale objects."
        ),
        
        TheoryQuestion(
            question: "What does matrix size mean?",
            answers: [
                "Rows × columns",
                "Columns + rows",
                "Only the biggest number"
            ],
            correctAnswer: "Rows × columns",
            explanation: "Matrix size is written as rows × columns."
        )
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Where are matrices used?")
                    .font(.custom("PixelifySans-Regular", size: 28))
                
                if showFirstParagraph {
                    Text("Matrices are used whenever lots of numbers need to be organized or transformed.")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .transition(.opacity)
                }
                
                // Список применений исчезает после начала игры, чтобы оставить место для вопросов
                if showUses && !showGame {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Matrices are useful in:")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        
                        Text("1. computer graphics: moving objects")
                        Text("2. data tables: storing information")
                        Text("3. robotics: controlling movement")
                        Text("4. games: transformations")
                        Text("5. AI: working with large data")
                    }
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .vectorInfoBox()
                    .transition(.scale.combined(with: .opacity))
                }
                
                if showGameIntro {
                    Text("Let’s check the idea with one final theory game!")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .transition(.opacity)
                }
                
                // Использую тот же reusable quiz component, что и в теме с векторами
                if showGame {
                    TheoryQuizGameView(
                        questions: matrixTheoryQuestions,
                        finalButtonTitle: "Got it!",
                        destination: AnyView(MatrixRevisionView())
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
                // Каждый тап открывает следующий блок: объяснение, применения, intro или игру
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

#Preview {
    NavigationStack {
        MatrixUsageView()
    }
}
