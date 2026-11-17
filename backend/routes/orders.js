const express = require('express');
const Order = require('../models/Order');
const Product = require('../models/Product');
const auth = require('../middleware/auth');

const router = express.Router();

// Place order
router.post('/', auth, async (req, res) => {
  try {
    const { products } = req.body; // [{ productId, quantity }]

    let totalAmount = 0;
    const orderProducts = [];

    for (const item of products) {
      const product = await Product.findById(item.productId);
      if (!product) return res.status(404).json({ message: 'Product not found' });

      if (product.quantity < item.quantity) {
        return res.status(400).json({ message: `Not enough stock for ${product.name}` });
      }

      orderProducts.push({
        product: product._id,
        quantity: item.quantity,
        price: product.price
      });

      totalAmount += product.price * item.quantity;

      // Reduce stock
      product.quantity -= item.quantity;
      await product.save();
    }

    const order = new Order({
      buyer: req.user.id,
      products: orderProducts,
      totalAmount
    });

    await order.save();
    res.status(201).json(order);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Get my orders
router.get('/my-orders', auth, async (req, res) => {
  try {
    const orders = await Order.find({ buyer: req.user.id })
      .populate('products.product')
      .populate('buyer', 'name email');
    res.json(orders);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;