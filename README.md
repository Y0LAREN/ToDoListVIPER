# ToDo List VIPER

![Swift](https://img.shields.io/badge/Swift-5.9-orange)  
![Xcode](https://img.shields.io/badge/Xcode-15-blue)  
![VIPER](https://img.shields.io/badge/Architecture-VIPER-green)  

## 📌 Описание проекта
**ToDo List VIPER** — это приложение для ведения списка дел с возможностью добавления, редактирования, удаления и поиска задач. Данные загружаются с `dummyjson API` при первом запуске и сохраняются в `Core Data` для дальнейшего использования.

---

## 🚀 Функционал
### 🔹 **Список задач**
✅ Отображение списка задач на главном экране.  
✅ Каждая задача содержит: **название**, **описание**, **дату создания** и **статус** (выполнена/не выполнена).  
✅ Возможность **добавлять**, **редактировать**, **удалять** задачи.  
✅ Реализован **поиск** по задачам.  

### 🔹 **Загрузка данных**
✅ При первом запуске приложение загружает задачи из [dummyjson API](https://dummyjson.com/todos).  
✅ Данные сохраняются в `Core Data`, чтобы были доступны при повторном запуске.

### 🔹 **Многопоточность**
✅ Все операции (создание, загрузка, редактирование, удаление, поиск) выполняются в **фоновом потоке** с использованием `GCD` или `NSOperation`.  
✅ **Интерфейс не блокируется** во время выполнения операций.

### 🔹 **Core Data**
✅ Хранение задач в `Core Data`.  
✅ Корректное восстановление данных после перезапуска приложения.  

### 🔹 **Тестирование**
✅ Написаны **юнит-тесты** для основных компонентов приложения.

---

## 📐 Архитектура
Приложение построено на **VIPER**:
- **View** – отвечает за отображение данных и обработку пользовательского ввода.
- **Interactor** – содержит бизнес-логику приложения.
- **Presenter** – управляет связью между View и Interactor.
- **Entity** – описывает модели данных.
- **Router** – отвечает за навигацию между экранами.

---

## 📦 Технологии
- `Swift 5.9`
- `Xcode 15`
- `UIKit`
- `Core Data`
- `GCD / NSOperation`
- `VIPER`
- `Unit Tests`
- `Git`

---

## 📸 Скриншоты

### 📌 Главный экран
![Главный экран](Screenshots/ToDoListScreen.png)

### 📌 Окно редактирования
![Редактирование задачи](Screenshots/ToDoScreen.png)


---

## 🔧 Установка и запуск
1. Клонируй репозиторий:
   ```bash
   git clone https://github.com/Y0LAREN/ToDoListVIPER.git
   ```
2. Открой `.xcodeproj` в Xcode 15.
3. Запусти приложение на симуляторе или устройстве.

---

## 👨‍💻 Автор
**Y0LAREN**  
[GitHub](https://github.com/Y0LAREN)

---

## 📜 Лицензия
Этот проект распространяется под лицензией **MIT**. См. файл `LICENSE` для деталей.

