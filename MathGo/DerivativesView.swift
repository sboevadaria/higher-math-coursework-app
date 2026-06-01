import SwiftUI

struct DerivativesView: View {
    // State management, который я использую для постепенного появления объяснений и графика
    @State private var showFirstParagraph = false
    @State private var showSecondParagraph = false
    @State private var showThirdParagraph = false
    @State private var showGraph = false
    
    // Отвечает за переход к следующему экрану после завершения вводной части
    @State private var goToNextScreen = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("What is a derivative?")
                .font(.custom("PixelifySans-Regular", size: 28))
            
            if showFirstParagraph {
                Text("A derivative simply shows us how fast something is changing at the moment!")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .transition(.opacity)
            }
            
            if showSecondParagraph {
                Text("Formally, the derivative tells us the rate of change of a function at a given moment.")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .transition(.opacity)
            }
            
            if showThirdParagraph {
                Text("Geometrically, it is the slope of the tangent line to the graph of f(x) at a specific point.")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .transition(.opacity)
            }

            // После текстового объяснения показываю интерактивный график,
            // чтобы пользователь мог увидеть производную как наклон касательной
            if showGraph {
                DerivativeGraphView()
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
                } else if !showGraph {
                    showGraph = true
                } else {
                    goToNextScreen = true
                }
            }
        }
        .navigationDestination(isPresented: $goToNextScreen) {
            DifferentiationFormulas()
        }
    }
}

#Preview {
    NavigationStack {
        DerivativesView()
    }
}
