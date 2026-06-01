import SwiftUI

struct MatrixOperationsView: View {
    @State private var showFirstParagraph = false
    @State private var showSecondParagraph = false
    @State private var showAddition = false
    @State private var showScalar = false
    @State private var showFinalParagraph = false
    @State private var goToNextScreen = false
    @State private var showExample = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Matrix operations")
                    .font(.custom("PixelifySans-Regular", size: 28))
                
                if showFirstParagraph {
                    Text("Now let’s learn two basic matrix operations: addition and multiplication by a number.")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .transition(.opacity)
                }
                
                if showSecondParagraph {
                    Text("The main idea is simple: work with matching positions.")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .transition(.opacity)
                }
                
                // Сначала показываю общее правило сложения матриц через буквенные значения
                if showAddition && !showExample {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Matrix addition:")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        
                        HStack(spacing: 8) {
                            MatrixText(rows: [["a", "b"], ["c", "d"]])
                            Text("+")
                            MatrixText(rows: [["e", "f"], ["g", "h"]])
                            Text("=")
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .formulaBoxStyle()
                        
                        HStack(spacing: 8) {
                            Text("=")
                            MatrixText(rows: [["a + e", "b + f"], ["c + g", "d + h"]])
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .formulaBoxStyle()
                    }
                    .transition(.opacity)
                }
                
                // Затем показываю умножение матрицы на число
                if showScalar && !showExample {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Multiplying by a number:")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        
                        HStack(spacing: 8) {
                            Text("m ·")
                                .font(.system(size: 22, weight: .semibold, design: .rounded))
                            
                            MatrixText(rows: [["a", "b"], ["c", "d"]])
                            Text("=")
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .formulaBoxStyle()
                        
                        HStack(spacing: 8) {
                            Text("=")
                            MatrixText(rows: [["m · a", "m · b"], ["m · c", "m · d"]])
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .formulaBoxStyle()
                    }
                    .transition(.opacity)
                }
                
                // После общих правил показываю числовые примеры
                if showExample {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Example:")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        
                        HStack(spacing: 8) {
                            MatrixText(rows: [["1", "2"], ["3", "4"]])
                            Text("+")
                            MatrixText(rows: [["5", "6"], ["7", "8"]])
                            Text("=")
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .formulaBoxStyle()
                        
                        HStack(spacing: 8) {
                            Text("=")
                            MatrixText(rows: [["6", "8"], ["10", "12"]])
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .formulaBoxStyle()
                        
                        HStack(spacing: 8) {
                            Text("2 ·")
                                .font(.system(size: 22, weight: .semibold, design: .rounded))
                            
                            MatrixText(rows: [["1", "2"], ["3", "4"]])
                            Text("=")
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .formulaBoxStyle()
                        
                        HStack(spacing: 8) {
                            Text("=")
                            MatrixText(rows: [["2", "4"], ["6", "8"]])
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .formulaBoxStyle()
                    }
                    .transition(.opacity)
                }
                
                if showFinalParagraph {
                    Text("For both operations, every number keeps its position. You just change the value in that position.")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
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
                // Каждый тап открывает следующий блок: объяснение, правила, пример или переход дальше
                if !showFirstParagraph {
                    showFirstParagraph = true
                } else if !showSecondParagraph {
                    showSecondParagraph = true
                } else if !showAddition {
                    showAddition = true
                } else if !showScalar {
                    showScalar = true
                } else if !showExample {
                    showExample = true
                } else if !showFinalParagraph {
                    showFinalParagraph = true
                } else {
                    goToNextScreen = true
                }
            }
        }
        .navigationDestination(isPresented: $goToNextScreen) {
            MatrixExtraView()
        }
    }
}

#Preview {
    NavigationStack {
        MatrixOperationsView()
    }
}
