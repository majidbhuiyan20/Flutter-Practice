import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:practice/hisabi/features/add_product/view_model/product.dart';

// ===================================
// BARCODE SCANNER DIALOG
// ===================================
class BarcodeScannerDialog extends StatefulWidget {
  final Function(String) onBarcodeDetected;

  const BarcodeScannerDialog({
    super.key,
    required this.onBarcodeDetected,
  });

  @override
  State<BarcodeScannerDialog> createState() => _BarcodeScannerDialogState();
}

class _BarcodeScannerDialogState extends State<BarcodeScannerDialog> {
  late MobileScannerController controller;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Column(
        children: [
          AppBar(
            title: const Text('Scan Product Barcode'),
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: Colors.blue.shade900,
            elevation: 0,
          ),
          Expanded(
            child: MobileScanner(
              controller: controller,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  if (barcode.rawValue != null) {
                    widget.onBarcodeDetected(barcode.rawValue!);
                    Navigator.pop(context);
                    break;
                  }
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[900],
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Point your camera at a barcode to scan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===================================
// ADD PRODUCT SCREEN
// ===================================
class AddProductScreen extends StatefulWidget {
  final Product? productToEdit;

  const AddProductScreen({super.key, this.productToEdit});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  // Controllers
  final TextEditingController _searchIdController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _buyPriceController = TextEditingController();
  final TextEditingController _sellPriceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Form State
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isEditMode = false;
  int? _currentProductId;
  List<String> _categories = [];

  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _checkForEditing();
  }

  @override
  void dispose() {
    _searchIdController.dispose();
    _barcodeController.dispose();
    _productNameController.dispose();
    _buyPriceController.dispose();
    _sellPriceController.dispose();
    _categoryController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// Check if we're editing an existing product
  void _checkForEditing() {
    if (widget.productToEdit != null) {
      final product = widget.productToEdit!;
      setState(() {
        _isEditMode = true;
        _currentProductId = product.id;
        _barcodeController.text = product.barcode;
        _productNameController.text = product.productName;
        _buyPriceController.text = product.buyPrice.toString();
        _sellPriceController.text = product.sellPrice.toString();
        _categoryController.text = product.category;
        _quantityController.text = product.quantity.toString();
        _descriptionController.text = product.description;
      });
    }
  }

  /// Load all categories from database
  Future<void> _loadCategories() async {
    try {
      final categories = await _dbHelper.getAllCategories();
      if (mounted) {
        setState(() {
          _categories = categories;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading categories: $e')),
        );
      }
    }
  }

  /// Scan barcode
  Future<void> _scanBarcode() async {
    showDialog(
      context: context,
      builder: (context) => BarcodeScannerDialog(
        onBarcodeDetected: (barcode) {
          setState(() {
            _barcodeController.text = barcode;
          });
          _checkBarcodeExists(barcode);
        },
      ),
    );
  }

  /// Check if barcode exists (skip if editing same product)
  Future<void> _checkBarcodeExists(String barcode) async {
    try {
      final product = await _dbHelper.getProductByBarcode(barcode);

      if (product != null && product.id != _currentProductId) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Product with this barcode already exists!'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  /// Search product by ID
  Future<void> _searchProductById(String idStr) async {
    try {
      setState(() => _isLoading = true);

      final id = int.tryParse(idStr);
      if (id == null) {
        throw Exception('Invalid product ID');
      }

      final product = await _dbHelper.getProductById(id);

      if (product != null) {
        setState(() {
          _isEditMode = true;
          _currentProductId = product.id;
          _barcodeController.text = product.barcode;
          _productNameController.text = product.productName;
          _buyPriceController.text = product.buyPrice.toString();
          _sellPriceController.text = product.sellPrice.toString();
          _categoryController.text = product.category;
          _quantityController.text = product.quantity.toString();
          _descriptionController.text = product.description;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✓ Product loaded! You can now edit it.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('❌ Product not found'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Submit form (Add or Update)
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() => _isLoading = true);

        final product = Product(
          id: _isEditMode ? _currentProductId : null,
          barcode: _barcodeController.text.trim(),
          productName: _productNameController.text.trim(),
          buyPrice: double.parse(_buyPriceController.text),
          sellPrice: double.parse(_sellPriceController.text),
          category: _categoryController.text.trim(),
          quantity: int.parse(_quantityController.text),
          description: _descriptionController.text.trim(),
          createdAt: _isEditMode ? widget.productToEdit?.createdAt ?? DateTime.now() : DateTime.now(),
          updatedAt: DateTime.now(),
        );

        if (_isEditMode && _currentProductId != null) {
          await _dbHelper.updateProduct(product);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✓ Product updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          final id = await _dbHelper.insertProduct(product);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('✓ Product added! ID: $id'),
                backgroundColor: Colors.green,
              ),
            );
          }
        }

        Navigator.pop(context, true);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  /// Clear form
  void _clearForm() {
    _searchIdController.clear();
    _barcodeController.clear();
    _productNameController.clear();
    _buyPriceController.clear();
    _sellPriceController.clear();
    _categoryController.clear();
    _quantityController.clear();
    _descriptionController.clear();
    setState(() {
      _isEditMode = false;
      _currentProductId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditMode ? '✏️ Edit Product' : '➕ Add Product',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!_isEditMode) ...[
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade400, Colors.blue.shade600],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Card(
                        color: Colors.transparent,
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.search, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'Search Product by ID',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _searchIdController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter Product ID',
                                        hintStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(0.2),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide.none,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.tag,
                                          color: Colors.white.withOpacity(0.7),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    onPressed: _isLoading
                                        ? null
                                        : () {
                                      if (_searchIdController.text.isNotEmpty) {
                                        _searchProductById(
                                          _searchIdController.text.trim(),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.find_in_page),
                                    label: const Text('Search'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.blue.shade900,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple.shade400,
                          Colors.purple.shade600
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Card(
                      color: Colors.transparent,
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.barcode_reader, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Product Barcode',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _barcodeController,
                                    decoration: InputDecoration(
                                      hintText: 'Scan or enter barcode manually',
                                      hintStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.2),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.local_offer,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  onPressed: _isLoading ? null : _scanBarcode,
                                  icon: const Icon(Icons.camera_alt),
                                  label: const Text('Scan'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.purple.shade900,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '📋 Product Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _productNameController,
                    label: 'Product Name',
                    icon: Icons.label,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter product name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _buyPriceController,
                          label: 'Buy Price (\$)',
                          icon: Icons.shop,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Buy price required';
                            }
                            if (double.tryParse(value!) == null) {
                              return 'Invalid price';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _sellPriceController,
                          label: 'Sell Price (\$)',
                          icon: Icons.sell,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Sell price required';
                            }
                            if (double.tryParse(value!) == null) {
                              return 'Invalid price';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _quantityController,
                          label: 'Quantity',
                          icon: Icons.inventory,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Quantity required';
                            }
                            if (int.tryParse(value!) == null) {
                              return 'Invalid qty';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _quantityController,
                          label: 'Quantity',
                          icon: Icons.inventory,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Quantity required';
                            }
                            if (int.tryParse(value!) == null) {
                              return 'Invalid qty';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildCategoryDropdown(),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Description',
                    icon: Icons.description,
                    maxLines: 3,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.shade400,
                                Colors.green.shade600
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            icon: Icon(
                              _isEditMode ? Icons.update : Icons.add_circle,
                            ),
                            label: Text(
                              _isEditMode ? 'UPDATE' : 'ADD PRODUCT',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (_isEditMode) ...[
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: _isLoading ? null : _clearForm,
                          icon: const Icon(Icons.clear),
                          label: const Text('Cancel'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade400,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 16,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (_isEditMode)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info, color: Colors.blue),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Editing: Product ID $_currentProductId',
                                style: const TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      validator: validator,
    );
  }

  Widget _buildCategoryDropdown() {
    // Add default categories if list is empty
    if (_categories.isEmpty) {
      _categories = ['Electronics', 'Clothing', 'Food', 'Books', 'Toys', 'Other'];
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _categories.contains(_categoryController.text) ? _categoryController.text : null,
          items: [
            ..._categories.map((category) => DropdownMenuItem(
              value: category,
              child: Text(category),
            )),
            const DropdownMenuItem(
              value: '__add_new__',
              child: Row(
                children: [
                  Icon(Icons.add, size: 20),
                  SizedBox(width: 8),
                  Text('Add New Category...', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
          onChanged: (value) {
            if (value == '__add_new__') {
              _showAddCategoryDialog();
            } else if (value != null) {
              setState(() {
                _categoryController.text = value;
              });
            }
          },
          decoration: InputDecoration(
            labelText: 'Category',
            prefixIcon: const Icon(Icons.category),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (value) {
            if (_categoryController.text.isEmpty) {
              return 'Please select or enter category';
            }
            return null;
          },
        ),
        if (_categoryController.text.isNotEmpty && !_categories.contains(_categoryController.text))
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'New category: ${_categoryController.text}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _showAddCategoryDialog() async {
    final TextEditingController newCategoryController = TextEditingController();
    
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Category'),
          content: TextField(
            controller: newCategoryController,
            decoration: const InputDecoration(
              hintText: 'Enter category name',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newCategoryController.text.isNotEmpty) {
                  setState(() {
                    final newCategory = newCategoryController.text.trim();
                    if (!_categories.contains(newCategory)) {
                      _categories.add(newCategory);
                    }
                    _categoryController.text = newCategory;
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}