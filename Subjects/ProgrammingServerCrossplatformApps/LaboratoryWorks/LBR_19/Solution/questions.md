1. **Принципы разработки приложения в соответствии с паттерном MVC**

   **MVC** (Model-View-Controller) — это архитектурный паттерн, который разделяет приложение на три компонента:

   - **Model (Модель)**: Отвечает за данные и бизнес-логику приложения. Она представляет данные и операции, которые могут быть выполнены с ними. Модель не зависит от того, как данные отображаются или как пользователь взаимодействует с ними.

   - **View (Представление)**: Отвечает за отображение данных, представленных в модели. Оно отображает информацию в удобной для пользователя форме, но не содержит бизнес-логики.

   - **Controller (Контроллер)**: Контроллер выполняет роль посредника между моделью и представлением. Он получает запросы от пользователя, взаимодействует с моделью для получения данных, а затем передает их представлению для отображения.

   В контексте разработки приложения с использованием MVC:

   - **Модель** — управляет данными.
   - **Представление** — отображает данные.
   - **Контроллер** — управляет логикой приложения и взаимодействием с пользователем.

2. **Что описывает таблица маршрутизации?**

   Таблица маршрутизации (или routing table) описывает, какие маршруты (URL-пути) и HTTP-методы (например, GET, POST, PUT, DELETE) обрабатываются в приложении. В этой таблице указано, какие контроллеры и действия (методы) должны быть вызваны для обработки соответствующих запросов. По сути, таблица маршрутизации связывает URL с конкретными действиями в коде.

   Пример:

   - **GET /users** — вызывает метод `getAllUsers` в контроллере `userController`.
   - **POST /users** — вызывает метод `createUser` в том же контроллере.

3. **Что описывает таблица контроллеров?**

   Таблица контроллеров описывает, какие действия (или методы) будут выполняться при получении запроса на определенный маршрут. Контроллер обрабатывает логику для конкретных действий, таких как создание, обновление, удаление или получение данных, и передает результаты представлению или клиенту.

   Пример таблицы контроллеров:

   - **userController.getAllUsers()** — действие для получения всех пользователей.
   - **productController.createProduct()** — действие для создания нового продукта.

   Контроллеры отвечают за обработку запросов и реализацию бизнес-логики.

4. **Поясните назначение маршрутизатора.**

   **Маршрутизатор** (Router) в приложении отвечает за связывание HTTP-запросов с соответствующими обработчиками (методами контроллеров). Он принимает входящие запросы и направляет их к нужным контроллерам в зависимости от маршрута (URL) и HTTP-метода.

   В Express маршрутизатор используется для определения, какие функции должны быть выполнены для определенного пути, например:

   ```javascript
   app.get("/users", userController.getAllUsers);
   app.post("/users", userController.createUser);
   ```

   Таким образом, маршрутизатор помогает организовать взаимодействие между запросами и обработчиками, упрощая структуру приложения и обеспечивая его масштабируемость.
