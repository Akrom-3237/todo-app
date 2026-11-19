<div align="center">

<img width="800" alt="Todo App Screenshot 1" src="https://github.com/user-attachments/assets/30da6919-9075-48b2-b98f-f8e3d9d3b5e1" />
<img width="800" alt="Todo App Screenshot 2" src="https://github.com/user-attachments/assets/27984c21-7182-4fc8-b8df-e7646606ff86" />
<img width="800" alt="Todo App Screenshot 3" src="https://github.com/user-attachments/assets/8f13a92d-930f-4c19-939e-b43622aa8a26" />

![Header](https://capsule-render.vercel.app/api?type=waving&color=0:0d1117,100:1a6b37&height=180&section=header&text=Todo%20App&fontSize=45&fontColor=ffffff&animation=fadeIn&fontAlignY=35&desc=Task%20Management%20Web%20Application&descSize=18&descAlignY=55)

</div>

## 📋 About

A full-featured **task management web application** built entirely with **Jakarta EE** — no frameworks, pure Servlet/JSP architecture. Users can register, log in, and manage their personal task list with full CRUD operations.

This project demonstrates core Java backend skills: **Servlet lifecycle**, **JSP rendering**, **JPA/Hibernate ORM**, **session management**, and **MVC architecture**.

---

## 🛠️ Tech Stack

| Category | Technologies |
|:---------|:------------|
| **Language** | Java 21 |
| **Platform** | Jakarta EE (Servlet, JSP) |
| **ORM** | JPA + Hibernate |
| **Database** | PostgreSQL |
| **Build Tool** | Maven |
| **Server** | Apache Tomcat 10 |

---

## ✨ Features

- ✅ User **registration** with form validation
- ✅ User **login/logout** with session management
- ✅ **AuthFilter** — protects routes from unauthorized access
- ✅ **Create** new tasks
- ✅ **Read** — view all tasks for logged-in user
- ✅ **Update** — edit existing tasks
- ✅ **Delete** — remove tasks
- ✅ Database-driven with **JPA/Hibernate** ORM
- ✅ Clean **MVC architecture**

---

## 🏗️ Project Structure

```
src/main/
├── java/dasturlash/uz/
│   ├── config/
│   │   └── DbConfig.java          # Database configuration
│   ├── dao/
│   │   ├── TodoDao.java            # Todo CRUD operations
│   │   └── UserDao.java            # User CRUD operations
│   ├── filter/
│   │   └── AuthFilter.java         # Authentication filter
│   ├── model/
│   │   ├── Todo.java               # Todo entity
│   │   └── User.java               # User entity
│   └── servlet/
│       ├── LoginServlet.java       # Login handler
│       ├── LogoutServlet.java      # Logout handler
│       ├── RegisterServlet.java    # Registration handler
│       └── TodoServlet.java        # Todo CRUD handler
├── resources/
│   └── META-INF/
│       └── persistence.xml         # JPA configuration
└── webapp/
    ├── WEB-INF/
    │   └── web.xml                 # Deployment descriptor
    ├── index.jsp                   # Home page
    ├── login.jsp                   # Login page
    ├── register.jsp                # Registration page
    └── todos.jsp                   # Task management page
```

---

## 🏛️ Architecture

```
Client (Browser)
       ↓
   JSP Pages (View)
       ↓
   Servlets (Controller)
       ↓
   DAO Layer (Data Access)
       ↓
   JPA / Hibernate (ORM)
       ↓
   PostgreSQL (Database)
```

---

## 🚀 How to Run

**Prerequisites:**
- Java 21+
- Apache Tomcat 10+
- PostgreSQL
- Maven

**Steps:**

1. **Clone the repository**
   ```bash
   git clone https://github.com/Akrom-3237/todo-app.git
   cd todo-app
   ```

2. **Set up PostgreSQL database**
   ```sql
   CREATE DATABASE todo_db;
   ```

3. **Configure database connection**

   Edit `src/main/resources/META-INF/persistence.xml` with your database credentials.

4. **Build the project**
   ```bash
   mvn clean package
   ```

5. **Deploy to Tomcat**

   Copy the generated `.war` file from `target/` to Tomcat's `webapps/` directory.

6. **Open in browser**
   ```
   http://localhost:8080/todo-app
   ```

---

## 📝 What I Learned

- Servlet **lifecycle** and **request/response** handling
- **JSP** for server-side rendering
- **JPA/Hibernate** for object-relational mapping
- **Session management** and authentication filters
- **MVC pattern** without any framework
- **Maven** project structure and dependency management

---

## 👤 Author

**Akrom Shomurodov**

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=flat-square&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/akrom-shomurodov/)
[![Telegram](https://img.shields.io/badge/Telegram-26A5E4?style=flat-square&logo=telegram&logoColor=white)](https://t.me/Akrom_4444)
[![Gmail](https://img.shields.io/badge/Gmail-D14836?style=flat-square&logo=gmail&logoColor=white)](mailto:akromshomurodov71@gmail.com)

---

<div align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&color=0:0d1117,100:1a6b37&height=100&section=footer"/>
</div>
