import Foundation
import Supabase
import Combine

// Структура, которую я использую при создании нового профиля в таблице profiles
// Она соответствует тем данным, которые я отправляю в Supabase после успешной регистрации пользователя
struct ProfileInsert: Encodable {
    let id: String
    let email: String
    let display_name: String
}

// Структура, которую я использую при получении данных профиля из Supabase
// Она нужна для того, чтобы Swift мог правильно прочитать ответ из базы данных
struct Profile: Decodable {
    let id: String
    let email: String
    let display_name: String
}

// AuthView отвечает за авторизацию в самом приложении
// Этот класс связывает SwiftUI screens и Supabase.
@MainActor
class AuthView: ObservableObject {
    // Показывает, авторизован (-> ContentView) пользователь или нет (-> LoginView)
    @Published var isLoggedIn = false
    
    // Сообщение об ошибке, которое показывается пользователю на экране авторизации
    @Published var errorMessage = ""
    
    // Сообщение об успехе
    @Published var successMessage = ""
    
    // Имя пользователя, которое я получаю из таблицы profiles и показываю на главном экране
    @Published var displayName = ""
    
    // При создании AuthView проверяю, есть ли уже активная сессия, чтобы он не входил в аккаунт каждый раз при открытии приложения
    init() {
        Task {
            await checkSession()
        }
    }
    
    // Функция проверяет, существует ли активная сессия пользователя
    // Если сессия существует и профиль найден, пользователь сразу попадает на главный экран
    // Если сессия устарела / пользователь удален / профиль не найден, приложение сбрасывает состояние авторизации
    func checkSession() async {
        do {
            _ = try await supabase.auth.session
            _ = try await supabase.auth.user()
            
            await fetchProfile()
            
            // Если имя пустое, значит профиль не был найден / не был успешно загружен
            // В таком случае я выхожу из аккаунта, чтобы не оставлять пользователя в некорректном состоянии
            if displayName.isEmpty {
                try await supabase.auth.signOut()
                isLoggedIn = false
                successMessage = ""
                errorMessage = ""
            } else {
                isLoggedIn = true
                successMessage = "You’re already logged in!"
                errorMessage = ""
            }
            
        } catch {
            // Если сессии нет или Supabase возвращает ошибку, пользователь остается неавторизованным
            isLoggedIn = false
            displayName = ""
            successMessage = ""
            errorMessage = ""
        }
    }
    
    // Функция получает профиль текущего пользователя из таблицы profiles
    // Она используется после входа в аккаунт и при проверке уже существующей сессии
    func fetchProfile() async {
        do {
            let user = try await supabase.auth.user()
            
            let profile: Profile = try await supabase
                .from("profiles")
                .select()
                .eq("id", value: user.id.uuidString)
                .single()
                .execute()
                .value
            
            print("FETCHED DISPLAY NAME:", profile.display_name)
            
            // Сохраняю имя пользователя, чтобы потом использовать его в ContentView
            displayName = profile.display_name
            
        } catch {
            // Если профиль не получилось получить, очищаю displayName
            // Это помогает избежать ситуации, когда приложение показывает старые или неверные данные
            print("FETCH PROFILE ERROR:", error)
            displayName = ""
        }
    }
    
    // Функция создает новый аккаунт через Supabase Authentication
    // После успешной регистрации я также создаю отдельный профиль пользователя в таблице profiles
    func signUp(email: String, password: String, displayName: String) async {
        print("SIGN UP STARTED")
        
        do {
            let response = try await supabase.auth.signUp(
                email: email,
                password: password
            )
            
            print("SIGN UP SUCCESS")
            
            let user = response.user
            
            // После создания аккаунта в Supabase Auth создаю строку в таблице profiles
            // Это нужно, потому что Auth хранит данные для входа, а profiles хранит данные приложения
            try await supabase
                .from("profiles")
                .insert(ProfileInsert(
                    id: user.id.uuidString,
                    email: email,
                    display_name: displayName
                ))
                .execute()
            
            print("PROFILE INSERT SUCCESS")
            
            // Сохраняю имя сразу после регистрации, потому что пользователь уже ввел его в форму sign-up
            self.displayName = displayName
            successMessage = "Account created!"
            errorMessage = ""
            isLoggedIn = true
            
        } catch {
            print("SIGN UP ERROR:", error)
            
            successMessage = ""
            
            // Отдельно обрабатываю ошибку потери соединения, потому что она часто возникает при тестировании
            if (error as NSError).code == -1005 {
                errorMessage = "The network connection was lost. Please check your internet and try again."
            } else {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    // Функция отвечает за вход уже существующего пользователя
    // После успешного входа приложение загружает профиль из таблицы profiles
    func signIn(email: String, password: String) async {
        print("SIGN IN STARTED")
        
        do {
            let response = try await supabase.auth.signIn(
                email: email,
                password: password
            )
            
            print("SIGN IN SUCCESS:", response.user.email ?? "")
            
            // После входа получаю профиль пользователя, чтобы загрузить displayName
            await fetchProfile()
            
            // Если аккаунт есть, но профиль не найден, пользователь не должен попадать в приложение
            // Такая ситуация может возникнуть, если пользователь был удален из profiles или создан до добавления таблицы
            if displayName.isEmpty {
                try await supabase.auth.signOut()
                successMessage = ""
                errorMessage = "Profile data was not found. Please create a new account."
                isLoggedIn = false
                return
            }
            
            successMessage = "Welcome back!"
            errorMessage = ""
            isLoggedIn = true
            
        } catch {
            print("SIGN IN ERROR:", error)
            
            successMessage = ""
            
            let errorText = error.localizedDescription.lowercased()
            
            // Network error обрабатывается отдельно, чтобы пользователь понимал, что проблема не в пароле
            if (error as NSError).code == -1005 {
                errorMessage = "The network connection was lost. Please check your internet and try again."
                
            // Здесь обрабатываю самые частые ошибки, связанные с неправильным email или password
            } else if errorText.contains("invalid login") ||
                        errorText.contains("invalid credentials") ||
                        errorText.contains("email") ||
                        errorText.contains("password") {
                errorMessage = "Incorrect email or password."
                
            // Общий текст ошибки нужен на случай, если Supabase вернет что-то странное
            } else {
                errorMessage = "Sign in failed. Please try again."
            }
        }
    }
    
    // Функция выходит из аккаунта и очищает все данные, связанные с текущим пользователем
    func signOut() async {
        do {
            try await supabase.auth.signOut()
            isLoggedIn = false
            successMessage = ""
            errorMessage = ""
            displayName = ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
