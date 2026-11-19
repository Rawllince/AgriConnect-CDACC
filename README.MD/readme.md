#  AgriConnect — Direct Farm-to-Market Produce Platform

**AgriConnect** is a full-stack web application designed to connect Kenyan farmers directly with fresh produce buyers (individuals, restaurants, and retailers) across every county—eliminating middlemen and enabling transparent pricing and M-Pesa checkout.

---

##  Table of Contents
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Prerequisites](#-prerequisites)
- [Installation & Setup](#-installation--setup)
- [Running the Application](#-running-the-application)
- [API Endpoints](#-api-endpoints)
- [Troubleshooting](#-troubleshooting)
- [Author](#-author)

---

##  Features
- **Role-Based Authentication:** Separate registration and login flows for **Farmers** (Produce Sellers) and **Buyers** (Individuals/Retailers), secured with `bcryptjs` password hashing and JSON Web Tokens (JWT).
- **Dynamic Session Management:** Automatic navbar updates displaying the logged-in user's name, role, and quick logout across all pages.
- **Produce Catalogue:** Browsable marketplace showcasing farm-fresh produce with county location, unit pricing (KES), and farmer details.
- **Farmer Dashboard:** Dedicated interface for farmers to manage crop listings, track pending orders, and monitor earnings.
- **Interactive Shopping Cart & Checkout:** Persistent `localStorage` cart with quantity controls, automatic subtotal/delivery calculation, M-Pesa Express (STK Push) / Cash on Delivery options, and downloadable PDF receipts (`jsPDF`).
- **Order Tracking:** Real-time order status tracking and official purchase receipts.

---

##  Tech Stack
- **Frontend:** HTML5, CSS3 (Custom Properties & Responsive Grid/Flexbox), Vanilla JavaScript (ES6+), Font Awesome, jsPDF
- **Backend:** Node.js, Express.js
- **Database:** MongoDB with Mongoose ODM
- **Authentication & Security:** JSON Web Tokens (`jsonwebtoken`), `bcryptjs`, `cors`, `dotenv`

---

##  Project Structure
```text
cdacc/
├── backend/
│   ├── middleware/
│   │   └── auth.js             # JWT verification middleware
│   ├── models/
│   │   ├── Order.js            # Mongoose schema for buyer orders
│   │   ├── Product.js          # Mongoose schema for farm produce
│   │   └── User.js             # Mongoose schema for farmers & buyers
│   ├── routes/
│   │   ├── auth.js             # /api/auth/register & /api/auth/login
│   │   ├── orders.js           # /api/orders endpoints
│   │   └── products.js         # /api/products endpoints
│   ├── .env                    # Environment variables (ignored in Git)
│   ├── package.json            # Backend dependencies
│   └── server.js               # Express entry point & MongoDB connection
│
├── frontend/
│   ├── about-us.html           # Platform mission & information
│   ├── auth.html               # Combined Login & Registration portal
│   ├── cart.html               # Shopping cart, M-Pesa checkout & PDF receipt
│   ├── catalogue.html          # Produce marketplace & M-Pesa modal
│   ├── contact-us.html         # Customer support & inquiries
│   ├── farmer-profile.html   # Farmer listings & earnings overview
│   ├── home.html               # Landing page
│   ├── script.js               # Shared API helpers, JWT auth & cart state
│   └── order-tracking.html        # Order status & receipt viewer
│
└── README.md
```

---

##  Prerequisites
Before running this project locally, ensure you have installed:
1. **[Node.js](https://nodejs.org)** (v18 or higher)
2. **[MongoDB Community Server](https://mongodb.com)** (running locally on `127.0.0.1:27017`)
3. **[VS Code](https://visualstudio.com)** with the **Live Server** extension

---

##  Installation & Setup

### 1. Clone the Repository
```bash
git clone https://github.com
cd cdacc
```

### 2. Install Backend Dependencies
```bash
cd backend
npm install
```

### 3. Configure Environment Variables
Create a `.env` file inside the `backend/` folder and add the following configuration:
```env
PORT=5000
MONGO_URI=mongodb://127.0.0.1:27017/farmers_buyers
JWT_SECRET=yourSuperSecretKey123
```

---

##  Running the Application
You need **two terminals/servers** running simultaneously during local development:

### 1. Start the Backend API (Port `5000`)
In your terminal inside `cdacc/backend`:
```bash
npx nodemon server.js
```
*(Or use `node server.js`)*  
You should see:
```text
Server running on port 5000
MongoDB connected
```

### 2. Start the Frontend (Port `5500`)
1. Open the `frontend/` folder in **VS Code**.
2. Right-click **`home.html`** (or **`auth.html`**) and select **Open with Live Server**.
3. Your browser will open `http://127.0.0`.

---

##  API Endpoints

### Authentication (`/api/auth`)

| Method | Endpoint | Access | Description |
| :--- | :--- | :--- | :--- |
| `POST` | `/api/auth/register` | Public | Register a new `farmer` or `buyer` and return JWT |
| `POST` | `/api/auth/login` | Public | Authenticate user with email & password and return JWT |

### Products (`/api/products`)

| Method | Endpoint | Access | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/api/products` | Public | Retrieve all available produce listings |
| `POST` | `/api/products` | Private (Farmer) | Create a new produce listing |

### Orders (`/api/orders`)

| Method | Endpoint | Access | Description |
| :--- | :--- | :--- | :--- |
| `GET` | `/api/orders` | Private | Get orders for the authenticated user |
| `POST` | `/api/orders` | Private | Create a new produce order |

---

##  Troubleshooting
- **`MongooseServerSelectionError`:** Ensure the MongoDB Windows/Linux service is running before starting `server.js`.
- **Login returns `Invalid credentials`:** Ensure you are logging in with your registered **email address** (case-sensitive unless normalized).
- **Session not showing across pages:** Make sure all pages are opened under the exact same host (`http://127.0.0...`) rather than mixing `localhost` and `127.0.0.1`, and that `<script src="script.js"></script>` is included before `</body>`.

---

##  Author
**Rawllince Okello**  
- GitHub: [@Rawllince](https://github.com)  
- Location: Kenya
##  Deployment & Hosting Guide

To deploy AgriConnect online, host the database, backend API, and frontend separately (or serve the frontend directly from Express):

### 1. Database (MongoDB Atlas)
1. Create a free cluster on **[MongoDB Atlas](https://mongodb.com)**.
2. Under **Network Access**, allow access from anywhere (`0.0.0.0/0`) so your cloud backend can connect.
3. Under **Database Access**, create a database user and copy your connection string (`mongodb+srv://...`).

### 2. Backend API (Render / Railway)
1. Push your code to GitHub (ensure `.env` and `node_modules/` are excluded via `.gitignore`).
2. Create a new **Web Service** on **[Render](https://render.com) pointing to your repository.
3. Set the **Root Directory** to `backend`, **Build Command** to `npm install`, and **Start Command** to `node server.js`.
4. Add the following **Environment Variables** in your hosting dashboard:
   - `MONGO_URI`: Your MongoDB Atlas connection string
   - `JWT_SECRET`: A strong, random production secret key
   - `PORT`: `5000` *(or leave unset if your host assigns `process.env.PORT` automatically)*
5. Copy your deployed backend URL (e.g., `https://onrender.com`).

### 3. Frontend (Vercel / Netlify / GitHub Pages)
1. Open `frontend/script.js` and update `API_URL` from localhost to your live backend URL:
   ```javascript
   const API_URL = 'https://onrender.com/api';
   ```
2. Deploy the `frontend/` folder to .
3. *(Optional)* In `backend/server.js`, restrict CORS to your live frontend domain for tighter security:
   ```javascript
   

###  Live Demo Links
- **Frontend Application: `Static url	https://agriconnect-cdacc.onrender.com	
- **Backend API Base URL:Server url	https://agriconnect-cdacc-web.onrender.com
