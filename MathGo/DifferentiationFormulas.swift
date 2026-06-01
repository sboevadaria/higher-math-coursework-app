import SwiftUI

struct DifferentiationFormulas: View {
    @State private var showFirstParagraph = false
    @State private var showSecondParagraph = false
    @State private var showFirstFormula = false
    @State private var showSecondFormula = false
    @State private var showThirdFormula = false
    @State private var showFourthFormula = false
    @State private var showFifthFormula = false
    @State private var showSixthFormula = false
    @State private var showThirdParagraph = false
    
    // Отвечает за переход к следующему экрану после появления всех формул
    @State private var goToNextScreen = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("How do we find derivatives?")
                    .font(.custom("PixelifySans-Regular", size: 28))
                
                if showFirstParagraph {
                    Text("To find derivatives faster, we can use special formulas called differentiation rules.")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .transition(.opacity)
                }
                
                if showSecondParagraph {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notations used: d/dx (f(x)) = f'(x)")
                            .font(.system(size: 18, weight: .regular, design: .rounded))
                    }
                }
                
                // Формулы появляются по одной, чтобы пользователь не видел весь список сразу
                if showFirstFormula {
                    Text("Constant Rule:\nd/dx (c) = 0")
                        .smallFormulaBoxStyle()
                        .transition(.opacity)
                }

                if showSecondFormula {
                    Text("Constant Multiple Rule:\nd/dx (c · f(x)) = c · f'(x)")
                        .smallFormulaBoxStyle()
                        .transition(.opacity)
                }

                if showThirdFormula {
                    Text("Sum Rule:\nd/dx (f(x) ± g(x)) = f'(x) ± g'(x)")
                        .smallFormulaBoxStyle()
                        .transition(.opacity)
                }

                if showFourthFormula {
                    Text("Product Rule:\nd/dx (f(x)g(x)) = f'(x)g(x) + f(x)g'(x)")
                        .smallFormulaBoxStyle()
                        .transition(.opacity)
                }

                if showFifthFormula {
                    Text("Quotient Rule:\nd/dx (f(x) / g(x)) =\n[f'(x)g(x) - f(x)g'(x)] / [g(x)]²")
                        .smallFormulaBoxStyle()
                        .transition(.opacity)
                }

                if showSixthFormula {
                    Text("Chain Rule:\nd/dx (f(g(x))) = f'(g(x)) · g'(x)")
                        .smallFormulaBoxStyle()
                        .transition(.opacity)
                }
                
                if showThirdParagraph {
                    Text("Even though it may look confusing at first, you’ll soon see that it’s actually pretty easy!")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .transition(.opacity)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(.horizontal, 26)
            .padding(.bottom, 12)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.5)) {
                // Каждый тап открывает следующий блок: объяснение, формулу или переход дальше
                if !showFirstParagraph {
                    showFirstParagraph = true
                } else if !showSecondParagraph {
                    showSecondParagraph = true
                } else if !showFirstFormula {
                    showFirstFormula = true
                } else if !showSecondFormula {
                    showSecondFormula = true
                } else if !showThirdFormula {
                    showThirdFormula = true
                } else if !showFourthFormula {
                    showFourthFormula = true
                } else if !showFifthFormula {
                    showFifthFormula = true
                } else if !showSixthFormula {
                    showSixthFormula = true
                } else if !showThirdParagraph {
                    showThirdParagraph = true
                } else {
                    goToNextScreen = true
                }
            }
        }
        .navigationDestination(isPresented: $goToNextScreen) {
            GeneralFormulasView()
        }
    }
}

// Reusable modifier для небольших формульных блоков
// Я использую его, чтобы все формулы на экране выглядели одинаково
extension View {
    func smallFormulaBoxStyle() -> some View {
        self
            .font(.system(size: 14, weight: .semibold, design: .rounded))
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.85))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.black.opacity(0.15), lineWidth: 1)
            )
    }
}

#Preview {
    NavigationStack {
        DifferentiationFormulas()
    }
}
