AgriConnect

🌱 Overview

AgriConnect is a web-based agricultural marketplace that connects farmers directly with buyers. The platform enables farmers to showcase their produce, manage orders, and expand their market reach, while buyers can browse available products, place orders, and communicate with farmers efficiently.

The goal of AgriConnect is to bridge the gap between producers and consumers by providing a simple, reliable, and user-friendly digital platform.

🚀 Features
For Farmers

Create and manage accounts

Add, edit, and delete produce listings

Upload product images

Manage inventory and pricing

View and process customer orders

For Buyers

Register and log in securely

Browse available agricultural products

Search and filter products by category

Place orders online

Track order status

General Features

User authentication and authorisation

Secure database storage

Responsive design for mobile and desktop devices

Order management system

Product categorisation

🛠️ Technologies Used

Frontend

HTML5

CSS3

JavaScript

Bootstrap (if used)

Backend

Node.js

Express.js

Database

MySQL

Version Control

Git

GitHub

Deployment

Render / Vercel / Netlify

📂 Project Structure

AgriConnect/

│

├── frontend/

│   ├── index.html

│   ├── css/

│   ├── js/

│   └── assets/

│

├── backend/

│   ├── config/

│   ├── controllers/

│   ├── models/

│   ├── routes/

│   ├── middleware/


│   ├── server.js

│   └── package.json

│

├── database schema/

│   └── AgriConnect_ERD_Diagram.pdf

│

├── README.md

└── .gitignore



⚙️ Installation

1. Clone the Repository

git clone https://github.com/Rawllince/AgriConnect-CDACC.git

cd AgriConnect-CDACC



2. Install Backend Dependencies


cd backend

npm install


3. Configure Environment Variables

Create a .env file in the backend folder:

PORT=5000


DB_HOST=localhost


DB_USER=root

DB_PASSWORD=your_password

DB_NAME=agriconnect


4. Start the Server
npm start


Or for development:

npm run dev

5. Open the Frontend

Open index.html in your browser or run it through a local development server.

🗄️ Database Design

The system includes the following main entities:

Users

Categories

Produce

Orders

Order_Items

Relationships

One User can create many Produce records.

One Category can contain many Produce items.

One User can place many Orders.

One Order can contain many Order Items.


One Produce item can appear in many Order Items.

🔒 Security Features

Password hashing

Input validation

Secure authentication

Environment variable protection

SQL injection prevention

📸 Screenshots


Add screenshots of:

Home page

Product listing page

User dashboard

Order management page

Database ERD diagram

👨‍💻 Author

Rawllince

Diploma in Software Development

AgriConnect Project Developer

GitHub: https://github.com/Rawllince

Static url	https://agriconnect-cdacc.onrender.com	

Server url	https://agriconnect-cdacc-web.onrender.com

📜 Licence

This project is developed for educational and academic purposes under the CDACC Software Development programme.


Future Improvements

Online payment integration (M-Pesa)

Real-time order notifications

Farmer-buyer messaging system

Product reviews and ratings

Admin dashboard and analytics

Mobile application version

AgriConnect – Connecting Farmers to Markets, One Click at a Time. 🌾
