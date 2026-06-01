import SwiftUI

struct MatrixExtraView: View {
    @State private var showFirstParagraph = false
    @State private var showTranspose = false
    @State private var showInverseIntro = false
    @State private var showInverseFormula = false
    @State private var showFinalText = false
    @State private var showButton = false
    @State private var hideTransposeExample = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("A little more...")
                    .font(.custom("PixelifySans-Regular", size: 28))
                
                if showFirstParagraph {
                    Text("Matrices have a few special operations that are useful to know.")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .transition(.opacity)
                }
                
                // Сначала объясняю transpose и показываю, как строки становятся столбцами
                if showTranspose {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Transpose")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        
                        Text("The transpose of a matrix flips rows and columns.")
                            .font(.system(size: 18, weight: .regular, design: .rounded))
                        
                        if !hideTransposeExample {
                            VStack(spacing: 10) {
                                MatrixText(
                                    rows: [
                                        ["1", "2", "3"],
                                        ["4", "5", "6"]
                                    ]
                                )
                                .frame(maxWidth: .infinity, alignment: .center)
                                
                                Text("Aᵀ")
                                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                MatrixText(
                                    rows: [
                                        ["1", "4"],
                                        ["2", "5"],
                                        ["3", "6"]
                                    ]
                                )
                                .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .formulaBoxStyle()
                            .transition(.opacity)
                        }
                    }
                    .transition(.opacity)
                }
                
                // После transpose перехожу к идее inverse matrix
                if showInverseIntro {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Inverse")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        
                        Text("An inverse matrix is a matrix that undoes the effect of another matrix.")
                            .font(.system(size: 18, weight: .regular, design: .rounded))
                        
                        Text("It is a bit like division, but for matrices.")
                            .font(.system(size: 18, weight: .regular, design: .rounded))
                    }
                    .transition(.opacity)
                }
                
                // Формула показывает главную идею inverse без сложных вычислений
                if showInverseFormula {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Main idea:")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                        
                        Text("A · A⁻¹ = I")
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .formulaBoxStyle()
                        
                        Text("I is the identity matrix. It works like 1 for matrices.")
                            .font(.system(size: 18, weight: .regular, design: .rounded))
                    }
                    .transition(.opacity)
                }
                
                if showFinalText {
                    Text("We won’t calculate inverse matrices here, but now you know the idea: transpose flips a matrix, and inverse undoes a matrix.")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .transition(.opacity)
                }
                
                if showButton {
                    NavigationButton(title: "Practice!", destination: MatrixPracticeView())
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
                // Каждый тап открывает следующий блок, а перед inverse убираю пример transpose
                if !showFirstParagraph {
                    showFirstParagraph = true
                } else if !showTranspose {
                    showTranspose = true
                } else if !showInverseIntro {
                    hideTransposeExample = true
                    showInverseIntro = true
                } else if !showInverseFormula {
                    showInverseFormula = true
                } else if !showFinalText {
                    showFinalText = true
                } else {
                    showButton = true
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MatrixExtraView()
    }
}
