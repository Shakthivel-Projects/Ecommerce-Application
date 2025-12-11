import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../services/product_api.dart';

class AdminProductFormScreen extends StatefulWidget {
  final Product? product;

  const AdminProductFormScreen({super.key, this.product});

  @override
  State<AdminProductFormScreen> createState() => _AdminProductFormScreenState();
}

class _AdminProductFormScreenState extends State<AdminProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  final _categoryController = TextEditingController();
  final _brandController = TextEditingController();
  final _stockController = TextEditingController();

  bool _isSaving = false;
  late final bool _isEdit;
  final ProductApi _productApi = ProductApi();

  @override
  void initState() {
    super.initState();
    _isEdit = widget.product != null;
    if (_isEdit) {
      final p = widget.product!;
      _titleController.text = p.title;
      _descriptionController.text = p.description;
      _priceController.text = p.price.toString();
      _imageController.text = p.image;
      _categoryController.text = p.category;
      _brandController.text = p.brand ?? '';
      _stockController.text = p.stock.toString();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    _categoryController.dispose();
    _brandController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final price = double.tryParse(_priceController.text.trim());
    final stock = int.tryParse(_stockController.text.trim().isEmpty
        ? '0'
        : _stockController.text.trim());

    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid price')),
      );
      return;
    }

    if (stock == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid stock value')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      if (_isEdit) {
        await _productApi.updateProduct(
          id: widget.product!.id,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          price: price,
          image: _imageController.text.trim(),
          category: _categoryController.text.trim(),
          brand: _brandController.text.trim().isEmpty
              ? null
              : _brandController.text.trim(),
          stock: stock,
        );
      } else {
        await _productApi.createProduct(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          price: price,
          image: _imageController.text.trim(),
          category: _categoryController.text.trim(),
          brand: _brandController.text.trim().isEmpty
              ? null
              : _brandController.text.trim(),
          stock: stock,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEdit ? 'Product updated' : 'Product created'),
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleText = _isEdit ? 'Edit product' : 'Add product';

    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price (₹)'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imageController,
                decoration:
                    const InputDecoration(labelText: 'Image URL'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(labelText: 'Brand'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _submit,
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_isEdit ? 'Save changes' : 'Create product'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
