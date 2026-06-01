import SwiftUI

struct IntegralFormulasView: View {
    @State private var showFirstParagraph = false
    @State private var showIndefinite = false
    @State private var showDefinite = false
    @State private var showRulesIntro = false
    @State private var showLeftParts = false
    @State private var showRightParts = false
    @State private var hideIntegralTypes = false
    @State private var goToNextScreen = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("A bit more theory...")
                    .font(.custom("PixelifySans-Regular", size: 28))
                
                if showFirstParagraph {
                    Text("There are two main types of integrals: indefinite integrals and definite integrals.")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .transition(.opacity)
                }
                
                // Сначала объясняю разницу между indefinite и definite integrals
                if showIndefinite && !hideIntegralTypes {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("An **indefinite** integral finds a general antiderivative. That is why we add + C.")
                            .font(.system(size: 18, weight: .regular, design: .rounded))
                        
                        Text("∫ f(x) dx = F(x) + C")
                            .formulaBoxStyle()
                    }
                    .transition(.opacity)
                }
                
                if showDefinite && !hideIntegralTypes {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("A **definite** integral finds the accumulated amount from one point to another.")
                            .font(.system(size: 18, weight: .regular, design: .rounded))
                        
                        Text("∫ from a to b f(x) dx = F(b) - F(a)")
                            .formulaBoxStyle()
                    }
                    .transition(.opacity)
                }
                
                if showRulesIntro {
                    Text("Now let’s get into the main rules and formulas of integration.")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .transition(.opacity)
                }
                
                // После объяснения типов интегралов показываю основные формулы
                if showLeftParts {
                    VStack(alignment: .leading, spacing: 12) {
                        IntegralFormulaRow(
                            left: "∫ c dx",
                            right: "= cx + C",
                            showRight: showRightParts
                        )
                        
                        IntegralFormulaRow(
                            left: "∫ xⁿ dx",
                            right: "= xⁿ⁺¹ / (n + 1) + C",
                            showRight: showRightParts
                        )
                        
                        IntegralFormulaRow(
                            left: "∫ c · f(x) dx",
                            right: "= c ∫ f(x) dx",
                            showRight: showRightParts
                        )
                        
                        IntegralFormulaRow(
                            left: "∫ [f(x) + g(x)] dx",
                            right: "= ∫ f(x) dx + ∫ g(x) dx",
                            showRight: showRightParts
                        )
                        
                        IntegralFormulaRow(
                            left: "∫ [f(x) - g(x)] dx",
                            right: "= ∫ f(x) dx - ∫ g(x) dx",
                            showRight: showRightParts
                        )
                        
                        IntegralFormulaRow(
                            left: "∫ 1/x dx",
                            right: "= ln|x| + C",
                            showRight: showRightParts
                        )
                        
                        IntegralFormulaRow(
                            left: "∫ eˣ dx",
                            right: "= eˣ + C",
                            showRight: showRightParts
                        )
                        
                        IntegralFormulaRow(
                            left: "∫ sin(x) dx",
                            right: "= -cos(x) + C",
                            showRight: showRightParts
                        )
                        
                        IntegralFormulaRow(
                            left: "∫ cos(x) dx",
                            right: "= sin(x) + C",
                            showRight: showRightParts
                        )
                    }
                    .transition(.move(edge: .leading).combined(with: .opacity))
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
                // Перед появлением списка формул убираю блоки про типы интегралов, чтобы экран не был перегружен
                if !showFirstParagraph {
                    showFirstParagraph = true
                } else if !showIndefinite {
                    showIndefinite = true
                } else if !showDefinite {
                    showDefinite = true
                } else if !showRulesIntro {
                    showRulesIntro = true
                } else if !showLeftParts {
                    hideIntegralTypes = true
                    showLeftParts = true
                } else if !showRightParts {
                    showRightParts = true
                } else {
                    goToNextScreen = true
                }
            }
        }
        .navigationDestination(isPresented: $goToNextScreen) {
            IntegralPracticeView()
        }
    }
}

// Reusable строка для формул интегрирования
// Я использую ее, чтобы сначала показать левую часть формулы, а затем открыть результат
struct IntegralFormulaRow: View {
    let left: String
    let right: String
    let showRight: Bool
    
    var body: some View {
        HStack(spacing: 6) {
            Text(left)
                .transition(.move(edge: .leading).combined(with: .opacity))
            
            if showRight {
                Text(right)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .font(.system(size: 16, weight: .semibold, design: .rounded))
        .lineLimit(nil)
        .fixedSize(horizontal: false, vertical: true)
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.85))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.black.opacity(0.15), lineWidth: 1)
        )
    }
}

#Preview {
    NavigationStack {
        IntegralFormulasView()
    }
}
