import SwiftUI

// Главный экран приложения, который пользователь видит после успешной авторизации
struct ContentView: View {
    // Получаю доступ к AuthView, чтобы использовать имя пользователя и функцию выхода из аккаунта
    @EnvironmentObject var authView: AuthView
    
    // State management
    @State private var showMenu = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                
                HStack {
                    Spacer()
                    
                    // Кнопка выхода из аккаунта вызывает signOut() из AuthView
                    Button {
                        Task {
                            await authView.signOut()
                        }
                    } label: {
                        Text("Log out")
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
                }
                
                Spacer()

                // Если имя пользователя было получено из Supabase, показываю персональное приветствие
                if !authView.displayName.isEmpty {
                    Text("Welcome, \(authView.displayName)!")
                        .font(.custom("PixelifySans-Regular", size: 30))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .transition(.opacity)
                }

                Text("Go!")
                    .font(.custom("PixelifySans-Regular", size: 112))
                
                // Меню с основными разделами появляется только после нажатия на экран
                if showMenu {
                    Text("What do you want to explore today?")
                        .font(.custom("PixelifySans-Regular", size: 32))
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .transition(.opacity)
                    
                    NavigationButton(title: "Calculus", destination: CalculusView())
                        .transition(.opacity)
                    
                    NavigationButton(title: "Linear algebra", destination: LinearAlgebraView())
                        .transition(.opacity)
                }
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showMenu = true
                }
            }
        }
    }
}

// Reusable кнопка для действий внутри одного экрана
// Я использую ее там, где нужно выполнить действие, но не обязательно перейти на новый экран
struct SimpleButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.custom("PixelifySans-Regular", size: 28))
                .foregroundStyle(.black)
                .padding(.vertical, 24)
                .frame(width: 260)
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color.blue.opacity(1.0))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.black, lineWidth: 2)
                )
                .shadow(radius: 4, y: 3)
        }
        .buttonStyle(ScaleButtonStyle())
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 8)
        .transition(.scale.combined(with: .opacity))
    }
}

// Стиль кнопок, который добавляет увеличение при нажатии
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.2 : 1.0)
            .animation(.easeInOut(duration: 0.3), value: configuration.isPressed)
    }
}

// Reusable кнопка с переходом на другой экран
struct NavigationButton<Destination: View>: View {
    let title: String
    let destination: Destination
    
    var body: some View {
        NavigationLink {
            destination
        } label: {
            Text(title)
                .font(.custom("PixelifySans-Regular", size: 28))
                .foregroundStyle(.black)
                .padding(.vertical, 24)
                .frame(maxWidth: 260)
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color.blue.opacity(1.5))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.black, lineWidth: 2)
                )
                .shadow(radius: 4, y: 3)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 8)
        .transition(.scale.combined(with: .opacity))
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthView())
}

