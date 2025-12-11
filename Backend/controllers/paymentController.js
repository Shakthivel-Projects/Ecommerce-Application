const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);
const Product = require('../models/productModel');

// POST /api/payments/create-payment-intent
// body: { items: [{ product, qty }], amountClient, currency }
const createPaymentIntent = async (req, res) => {
  try {
    const { items, amountClient, currency } = req.body;

    if (!items || !Array.isArray(items) || items.length === 0) {
      return res
        .status(400)
        .json({ message: 'Items array is required' });
    }

    // Fetch product prices from DB and compute server-side total
    const productIds = items.map((i) => i.product);
    const products = await Product.find({ _id: { $in: productIds } });

    let totalAmount = 0;
    items.forEach((item) => {
      const product = products.find(
        (p) => p._id.toString() === item.product,
      );
      if (!product) return;
      totalAmount += product.price * item.qty;
    });

    const amountPaise = Math.round(totalAmount * 100);

    // Optional: sanity check against client-provided amount
    if (
      amountClient &&
      Math.abs(amountClient - amountPaise) > 50 // 0.50 INR
    ) {
      return res.status(400).json({ message: 'Amount mismatch' });
    }

    const paymentIntent = await stripe.paymentIntents.create({
      amount: amountPaise,
      currency: currency || 'inr',
      automatic_payment_methods: { enabled: true },
      metadata: {
        userId: req.user ? req.user._id.toString() : 'guest',
      },
    });

    return res.json({
      clientSecret: paymentIntent.client_secret,
      amount: amountPaise,
    });
  } catch (error) {
    console.error('Stripe error:', error);
    return res
      .status(500)
      .json({ message: 'Payment initialization failed' });
  }
};

module.exports = { createPaymentIntent };
