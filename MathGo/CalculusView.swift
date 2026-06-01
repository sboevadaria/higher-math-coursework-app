import SwiftUI

// Этот экран показывает две темы предмета, которые доступны для изучения в приложении
struct CalculusView: View {
    // State management, который я использую для постепенного появления карточек на экране
    @State private var showCards = false
    
    // Эта переменная отвечает за переход обратно на главный экран приложения
    @State private var goToContentView = false
    
    var body: some View {
        // Использую ZStack, чтобы кнопка Back была в правом верхнем углу и не влияла на расположение основного контента
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 28) {
                Text("Choose your path")
                    .font(.custom("PixelifySans-Regular", size: 34))
                    .padding(.bottom, 4)
                
                Text("Pick a calculus topic to explore!")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                
                // Карточки появляются только после открытия экрана, чтобы интерфейс выглядел более динамично
                if showCards {
                    TopicCard(
                        symbol: "1",
                        title: "Derivatives",
                        subtitle: "Change & slope",
                        destination: DerivativesView()
                    )
                    .transition(.move(edge: .leading).combined(with: .opacity))
                    
                    TopicCard(
                        symbol: "2",
                        title: "Integrals",
                        subtitle: "Area & totals",
                        destination: IntegralsView()
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
        // При открытии экрана запускаю анимацию появления карточек
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6)) {
                showCards = true
            }
        }
    }
}

// Reusable структура, которая показывает карточку с темой
// Я использую ее при работе с обоими предметами
struct TopicCard<Destination: View>: View {
    let symbol: String
    let title: String
    let subtitle: String
    let destination: Destination
    
    var body: some View {
        // Карточка работает как NavigationLink и переносит пользователя на экран выбранной темы
        NavigationLink {
            destination
        } label: {
            HStack(spacing: 18) {
                Text(symbol)
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundStyle(.black)
                    .frame(width: 78, height: 78)
                    .background(
                        RoundedRectangle(cornerRadius: 22)
                            .fill(Color.white.opacity(0.9))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(Color.black, lineWidth: 2)
                    )
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.custom("PixelifySans-Regular", size: 24))
                        .foregroundStyle(.black)
                    
                    Text(subtitle)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundStyle(.black.opacity(0.75))
                }
                
                Spacer()
                
                Text("›")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundStyle(.black)
            }
            .padding(18)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 26)
                    .fill(Color.blue.opacity(1.0))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 26)
                    .stroke(Color.black, lineWidth: 2)
            )
            .shadow(radius: 4, y: 3)
        }
        // Использую общий стиль кнопок, чтобы карточка увеличивалась при нажатии
        .buttonStyle(ScaleButtonStyle())
    }
}

#Preview {
    NavigationStack {
        CalculusView()
    }
}
