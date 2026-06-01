import SwiftUI

struct MatrixPartsView: View {
    @State private var showFirstParagraph = false
    @State private var showMatrix = false
    @State private var showRows = false
    @State private var showColumns = false
    @State private var showSize = false
    @State private var showButton = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Rows and columns")
                .font(.custom("PixelifySans-Regular", size: 28))
            
            if showFirstParagraph {
                Text("Matrices are described by their rows and columns.")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .transition(.opacity)
            }
            
            // Сначала показываю саму матрицу, чтобы потом объяснить ее части на конкретном примере
            if showMatrix {
                MatrixText(
                    rows: [
                        ["1", "2", "3"],
                        ["4", "5", "6"]
                    ]
                )
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .formulaBoxStyle()
                .transition(.scale.combined(with: .opacity))
            }
            
            if showRows {
                Text("Rows go sideways.")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .transition(.opacity)
            }
            
            if showColumns {
                Text("Columns go up and down.")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .transition(.opacity)
            }
            
            // После rows and columns объясняю, как записывается размер матрицы
            if showSize {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Matrix size is written as:")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                    
                    Text("rows × columns")
                        .formulaBoxStyle()
                    
                    Text("This matrix has 2 rows and 3 columns, so its size is 2 × 3.")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                }
                .transition(.opacity)
            }
            
            if showButton {
                NavigationButton(title: "All clear!", destination: MatrixExtraView())
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 26)
        .padding(.top, 8)
        .padding(.bottom, 24)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.5)) {
                // Каждый тап открывает следующий блок: объяснение, матрицу, rows, columns, size или кнопку перехода
                if !showFirstParagraph {
                    showFirstParagraph = true
                } else if !showMatrix {
                    showMatrix = true
                } else if !showRows {
                    showRows = true
                } else if !showColumns {
                    showColumns = true
                } else if !showSize {
                    showSize = true
                } else {
                    showButton = true
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MatrixPartsView()
    }
}
