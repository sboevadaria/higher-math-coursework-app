import SwiftUI

struct IntegralsUsageView: View {
    @State private var showFirstParagraph = false
    @State private var showSecondParagraph = false
    @State private var showExample = false
    @State private var showConnection = false
    @State private var showButton = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Why do we need integrals?")
                    .font(.custom("PixelifySans-Regular", size: 28))
                
                if showFirstParagraph {
                    Text("An integral helps us find a total amount by adding up many tiny parts.")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .transition(.opacity)
                }
                
                if showSecondParagraph {
                    Text("Integrals are useful in real life when we know a rate of change and want to find the total result.")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .transition(.opacity)
                }
                
                // Здесь показываю связь между derivative and integral
                if showConnection {
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text("A derivative shows how fast something changes.")
                            .font(.system(size: 18, weight: .regular, design: .rounded))
                        
                        Text("An integral works in the opposite direction: it adds up changes to recover the total.")
                            .font(.system(size: 18, weight: .regular, design: .rounded))
                        
                        Text("Integration is like differentiation in reverse.")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .formulaBoxStyle()
                    }
                    .transition(.opacity)
                }
                
                // Пример со скоростью помогает показать, зачем интегралы нужны на практике
                if showExample {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Example:")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        
                        Text("Speed tells us how fast a car is moving.")
                            .font(.system(size: 18, weight: .regular, design: .rounded))
                        
                        Text("The integral of speed tells us the total distance traveled.")
                            .font(.system(size: 18, weight: .regular, design: .rounded))
                        
                        Text("speed → integral → distance")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .formulaBoxStyle()
                    }
                    .transition(.opacity)
                }
                
                if showButton {
                    NavigationButton(
                        title: "Continue!",
                        destination: IntegralFormulasView()
                    )
                    .transition(.scale.combined(with: .opacity))
                }
                
                Spacer()
            }
            .padding(.horizontal, 26)
            .padding(.bottom, 12)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.5)) {
                // Каждый тап открывает следующий блок: объяснение, связь с производной, пример или кнопку перехода
                if !showFirstParagraph {
                    showFirstParagraph = true
                } else if !showSecondParagraph {
                    showSecondParagraph = true
                } else if !showConnection {
                    showConnection = true
                } else if !showExample {
                    showExample = true
                } else if !showButton {
                    showButton = true
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        IntegralsUsageView()
    }
}
