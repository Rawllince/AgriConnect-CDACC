const API_URL = 'http://localhost:5000/api';

function getToken() {
  return localStorage.getItem('token');
}

function getHeaders() {
  const token = getToken();
  return {
    'Content-Type': 'application/json',
    ...(token && { 'Authorization': `Bearer ${token}` }) // Only adds header if token exists
  };
}

async function login(email, password) {
  try {
    const res = await fetch(`${API_URL}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password })
    });

    const data = await res.json();

    if (!res.ok) {
      throw new Error(data.message || 'Login failed');
    }

    localStorage.setItem('token', data.token);
    localStorage.setItem('user', JSON.stringify(data.user));
    return { success: true, user: data.user };
    
  } catch (error) {
    console.error('Login error:', error);
    return { success: false, message: error.message };
  }
}

async function register(userData) {
  try {
    const res = await fetch(`${API_URL}/auth/register`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(userData)
    });

    const data = await res.json();

    if (!res.ok) {
      throw new Error(data.message || 'Registration failed');
    }

    localStorage.setItem('token', data.token);
    localStorage.setItem('user', JSON.stringify(data.user));
    return { success: true, user: data.user };
  } catch (error) {
    console.error('Register error:', error);
    return { success: false, message: error.message };
  }
}
async function register(userData) {
  try {
    const res = await fetch(`${API_URL}/auth/register`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(userData)
    });

    const data = await res.json();

    if (!res.ok) {
      throw new Error(data.message || 'Registration failed');
    }

    localStorage.setItem('token', data.token);
    localStorage.setItem('user', JSON.stringify(data.user));
    return { success: true, user: data.user };
  } catch (error) {
    console.error('Register error:', error);
    return { success: false, message: error.message };
  }
}
function getUser() {
  const user = localStorage.getItem('user');
  return user ? JSON.parse(user) : null;
}

function logout() {
  localStorage.removeItem('token');
  localStorage.removeItem('user');
  window.location.href = 'auth.html';
}

function updateNavbarAuth() {
  const navBtns = document.querySelector('.nav-btns');
  if (!navBtns) return;

  const user = getUser();

  if (user && getToken()) {
    // Choose dashboard link based on user role
    const accountLink = user.role === 'farmer' ? 'farmer-dashboard.html' : 'catalogue.html';
    const firstName = user.name ? user.name.split(' ')[0] : 'Account';

    navBtns.innerHTML = `
      <a href="${accountLink}" class="btn btn-outline-light" style="display:flex; align-items:center; gap:6px;">
        👤 ${firstName} (${user.role})
      </a>
      <button onclick="logout()" class="btn btn-gold-sm" style="border:none; cursor:pointer;">
        Logout
      </button>
    `;
  }
}

// Automatically update the navbar whenever any page loads
document.addEventListener('DOMContentLoaded', updateNavbarAuth);

function renderReceipt(order) {
  const receiptSection = document.getElementById('receipt');
  if (!order || !receiptSection) return;

  // Show the receipt card
  receiptSection.style.display = 'block';

  // Format short Order ID from MongoDB _id (e.g., AC-8F3A)
  const shortId = order._id ? `AC-${order._id.slice(-4).toUpperCase()}` : 'AC-NEW';
  document.getElementById('receipt-order-id').textContent = shortId;

  // List product names and total quantity from order.products array
  const produceNames = order.products.map(p => p.product?.name || p.name || 'Produce').join(', ');
  const totalQty = order.products.reduce((sum, p) => sum + (p.quantity || 1), 0);

  const transportFee = order.transportFee || 0;
  const produceCost = (order.totalAmount || 0) - transportFee;

  document.getElementById('receipt-produce').textContent = produceNames;
  document.getElementById('receipt-quantity').textContent = `${totalQty} unit(s)`;
  document.getElementById('receipt-subtotal').textContent = `KES ${produceCost.toLocaleString()}`;
  document.getElementById('receipt-transport').textContent = `KES ${transportFee.toLocaleString()}`;
  document.getElementById('receipt-total').textContent = `KES ${(order.totalAmount || 0).toLocaleString()}`;
  document.getElementById('receipt-mpesa-ref').textContent = order.mpesaReceiptNumber || 'Awaiting Confirmation';
}
