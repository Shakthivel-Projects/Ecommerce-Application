const Order = require('../models/orderModel');

const createOrder = async (req, res) => {
  try {
    const {
      orderItems,
      shippingAddress,
      itemsPrice,
      taxPrice,
      shippingPrice,
      totalPrice,
      paymentIntentId,
    } = req.body;

    if (!orderItems || orderItems.length === 0) {
      return res.status(400).json({ message: 'No order items' });
    }

    const order = new Order({
      user: req.user._id,
      orderItems,
      shippingAddress,
      itemsPrice,
      taxPrice,
      shippingPrice,
      totalPrice,
      paymentIntentId,
      isPaid: true,
      paymentStatus: 'paid',
      paidAt: new Date(),
    });

    const createdOrder = await order.save();
    return res.status(201).json(createdOrder);
  } catch (error) {
    console.error('Create order error:', error);
    return res.status(500).json({ message: 'Server error' });
  }
};

const getMyOrders = async (req, res) => {
  const orders = await Order.find({ user: req.user._id }).sort('-createdAt');
  return res.json(orders);
};

const getAllOrders = async (req, res) => {
  const orders = await Order.find({})
    .populate('user', 'name email')
    .sort('-createdAt');
  return res.json(orders);
};

module.exports = { createOrder, getMyOrders, getAllOrders };
