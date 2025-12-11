const Product = require('../models/productModel');

const getProducts = async (req, res) => {
  const products = await Product.find({});
  return res.json(products);
};

const getProductById = async (req, res) => {
  const product = await Product.findById(req.params.id);
  if (!product) {
    res.status(404);
    return res.json({ message: 'Product not found' });
  }
  return res.json(product);
};

const createProduct = async (req, res) => {
  const { title, description, price, image, category, brand, stock } = req.body;

  const product = new Product({
    title,
    description,
    price,
    image,
    category,
    brand,
    stock,
  });

  const created = await product.save();
  return res.status(201).json(created);
};

const updateProduct = async (req, res) => {
  const { title, description, price, image, category, brand, stock } = req.body;

  const product = await Product.findById(req.params.id);
  if (!product) {
    res.status(404);
    return res.json({ message: 'Product not found' });
  }

  product.title = title ?? product.title;
  product.description = description ?? product.description;
  product.price = price ?? product.price;
  product.image = image ?? product.image;
  product.category = category ?? product.category;
  product.brand = brand ?? product.brand;
  product.stock = stock ?? product.stock;

  const updated = await product.save();
  return res.json(updated);
};

const deleteProduct = async (req, res) => {
  const product = await Product.findById(req.params.id);
  if (!product) {
    res.status(404);
    return res.json({ message: 'Product not found' });
  }
  await product.deleteOne();
  return res.json({ message: 'Product removed' });
};

module.exports = {
  getProducts,
  getProductById,
  createProduct,
  updateProduct,
  deleteProduct,
};
