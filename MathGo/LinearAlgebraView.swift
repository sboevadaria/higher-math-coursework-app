import SwiftUI

struct LinearAlgebraView: View {
    @State private var showCards = false
    @State private var goToContentView = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 28) {
                Text("What's up?")
                    .font(.custom("PixelifySans-Regular", size: 34))
                    .padding(.bottom, 4)
                
                Text("Pick a linear algebra topic to learn!")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                
                // Карточки ведут к двум основным темам Linear Algebra
                if showCards {
                    TopicCard(
                        symbol: "1",
                        title: "Vectors",
                        subtitle: "Direction & length",
                        destination: VectorsView()
                    )
                    .transition(.move(edge: .leading).combined(with: .opacity))
                    
                    TopicCard(
                        symbol: "2",
                        title: "Matrices",
                        subtitle: "Grids & numbers",
                        destination: MatricesView()
                    )
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
            .padding(.horizontal, 26)
            .padding(.top, 80)
            .padding(.bottom, 12)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Кнопка возвращает пользователя на ContentView
            Button {
                goToContentView = true
            } label: {
                Text("Back")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(.black)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.white.opacity(0.9))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.black.opacity(0.25), lineWidth: 1)
                    )
            }
            .padding(.top, 8)
            .padding(.trailing, 26)
        }
        .navigationDestination(isPresented: $goToContentView) {
            ContentView()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6)) {
                showCards = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        LinearAlgebraView()
    }
}
