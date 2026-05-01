# Smart Complaint & Service Management System (SCMS)
**By:** Areeba Imran (24K-0005) & Shahzaib Zaheer (24K-0040)

## Setup — Oracle SQL

### 1. Run SQL files in SQL Developer (in order):
```
database/schema_oracle.sql   ← creates all tables, sequences, triggers
database/seed_oracle.sql     ← inserts demo data
```

### 2. Backend
```bash
cd backend
npm install
# Edit .env — set DB_USER, DB_PASSWORD, DB_CONNECT
npm run dev       # starts on http://localhost:5000
```

### 3. Frontend
Open frontend/index.html with VS Code Live Server (port 3000)

---

## .env Settings (backend/.env)
```
DB_USER=your_oracle_username
DB_PASSWORD=your_oracle_password
DB_CONNECT=localhost/XEPDB1        # Oracle XE
# OR: localhost:1521/ORCL          # Full Oracle
JWT_SECRET=change_this_secret
PORT=5000
CLIENT_URL=http://localhost:3000
```

---

## Demo Login Credentials (password: Password123)
| Role       | Email                |
|------------|----------------------|
| Admin      | admin@scms.edu       |
| User       | areeba@scms.edu      |
| Technician | ali@scms.edu         |
| Super Admin| superadmin@scms.edu  |

---

## Project Structure
```
scms/
├── backend/
│   ├── server.js
│   ├── .env
│   ├── middleware/auth.js
│   ├── models/db.js          ← Oracle connection
│   └── routes/
│       ├── auth.js
│       ├── complaints.js
│       ├── admin.js
│       ├── technician.js
│       └── notifications.js
├── frontend/
│   ├── index.html            ← Landing page
│   └── pages/
│       ├── login.html
│       ├── register.html
│       ├── user-dashboard.html
│       ├── admin-dashboard.html
│       └── technician-dashboard.html
└── database/
    ├── schema_oracle.sql     ← Oracle schema
    └── seed_oracle.sql       ← Demo data
```
