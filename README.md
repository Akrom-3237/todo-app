<div align="center">

<img width="1820" height="807" alt="image" src="https://github.com/user-attachments/assets/30da6919-9075-48b2-b98f-f8e3d9d3b5e1" />
<img width="1810" height="812" alt="image" src="https://github.com/user-attachments/assets/27984c21-7182-4fc8-b8df-e7646606ff86" />
<img width="1470" height="827" alt="image" src="https://github.com/user-attachments/assets/8f13a92d-930f-4c19-939e-b43622aa8a26" />



</div>
📋 About

A full-featured task management web application built entirely with Jakarta EE — no frameworks, pure Servlet/JSP architecture. Users can register, log in, and manage their personal task list with full CRUD operations.

This project demonstrates core Java backend skills: Servlet lifecycle, JSP rendering, JPA/Hibernate ORM, session management, and MVC architecture.

🛠️ Tech Stack
Category	Technologies
Language	Java 17
Platform	Jakarta EE (Servlet, JSP)
ORM	JPA + Hibernate
Database	PostgreSQL
Build Tool	Maven
Server	Apache Tomcat 10
✨ Features
✅ User registration with form validation
✅ User login/logout with session management
✅ AuthFilter — protects routes from unauthorized access
✅ Create new tasks
✅ Read — view all tasks for logged-in user
✅ Update — edit existing tasks
✅ Delete — remove tasks
✅ Database-driven with JPA/Hibernate ORM
✅ Clean MVC architecture
🏗️ Project Structure
src/main/java/dasturlash/uz/
├── config/
│   └── DbConfig.java          # Database configuration
├── dao/
│   ├── TodoDao.java            # Todo CRUD operations
│   └── UserDao.java            # User CRUD operations
├── filter/
│   └── AuthFilter.java         # Authentication filter
├── model/
│   ├── Todo.java               # Todo entity
│   └── User.java               # User entity
├── servlet/
│   ├── LoginServlet.java       # Login handler
│   ├── LogoutServlet.java      # Logout handler
│   ├── RegisterServlet.java    # Registration handler
│   └── TodoServlet.java        # Todo CRUD handler

src/main/webapp/
├── WEB-INF/
│   └── web.xml                 # Deployment descriptor
├── index.jsp                   # Home page
├── login.jsp                   # Login page
├── register.jsp                # Registration page
└── todos.jsp                   # Task management page
🏛️ Architecture
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
🚀 How to Run

Prerequisites:

Java 17+
Apache Tomcat 10+
PostgreSQL
Maven

Steps:

Clone the repository
bash
git clone https://github.com/Akrom-3237/todo-app.git
cd todo-app
Set up PostgreSQL database
sql
CREATE DATABASE todo_db;
Configure database connection Edit src/main/resources/META-INF/persistence.xml with your database credentials.
Build the project
bash
mvn clean package
Deploy to Tomcat Copy the generated .war file from target/ to Tomcat's webapps/ directory.
Open in browser
http://localhost:8080/todo-app
📝 What I Learned
Servlet lifecycle and request/response handling
JSP for server-side rendering
JPA/Hibernate for object-relational mapping
Session management and authentication filters
MVC pattern without any framework
Maven project structure and dependency management
👤 Author

Akrom Shomurodov

LinkedIn Telegram Gmail

<div align="center"> <img src="https://capsule-render.vercel.app/api?type=waving&color=0:0d1117,100:1a6b37&height=100&section=footer"/> </div>
