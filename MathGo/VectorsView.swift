import SwiftUI

struct VectorsView: View {
    @State private var showFirstParagraph = false
    @State private var showSecondParagraph = false
    @State private var showThirdParagraph = false
    @State private var showFourthParagraph = false
    @State private var showGraph = false
    
    // Эту переменную я использую, чтобы убрать первые объяснения перед появлением графика
    @State private var hideFirstParagraphs = false
    
    // Отвечает за переход к следующему экрану после завершения вводной части
    @State private var goToNextScreen = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("What is a vector?")
                .font(.custom("PixelifySans-Regular", size: 28))
            
            if showFirstParagraph && !hideFirstParagraphs {
                Text("In linear algebra, a vector is essentially a mathematical object that has both a magnitude (size) and direction.")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .transition(.opacity)
            }
            
            if showSecondParagraph && !hideFirstParagraphs {
                Text("In plain words, a vector helps describe movement from one point to another.")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .transition(.opacity)
            }
            
            if showThirdParagraph && !hideFirstParagraphs {
                Text("Geometrically, a vector can be seen as an arrow in a space, such as a 2-dimensional plane or a 3-dimensional space.")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .transition(.opacity)
            }
            
            if showFourthParagraph {
                Text("Algebraically, it is represented as an ordered list of numbers, written in a column or row.")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .transition(.opacity)
            }

            // После основных объяснений показываю визуализацию вектора
            if showGraph {
                VectorVisuallyView()
                    .transition(.opacity)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 26)
        .padding(.bottom, 12)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.5)) {
                // Каждый тап открывает следующий смысловой блок урока
                if !showFirstParagraph {
                    showFirstParagraph = true
                } else if !showSecondParagraph {
                    showSecondParagraph = true
                } else if !showThirdParagraph {
                    showThirdParagraph = true
                } else if !showFourthParagraph {
                    showFourthParagraph = true
                } else if !showGraph {
                    // Перед появлением графика убираю первые абзацы, чтобы экран не был перегружен
                    hideFirstParagraphs = true
                    showGraph = true
                } else {
                    goToNextScreen = true
                }
            }
        }
        .navigationDestination(isPresented: $goToNextScreen) {
            VectorLengthView()
        }
    }
}

#Preview {
    NavigationStack {
        VectorsView()
    }
}
