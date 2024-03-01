import 'dart:convert';

import 'package:api_crud/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key, required this.product});

  final Product product;

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _codeTEController = TextEditingController();
  final TextEditingController _unitPriceTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();
  final TextEditingController _quantityTEController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _updateProductInprogress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameTEController.text = widget.product.productName ?? "";
    _codeTEController.text = widget.product.productCode ?? "";
    _unitPriceTEController.text = widget.product.unitPrice ?? "";
    _totalPriceTEController.text = widget.product.totalPrice ?? "";
    _imageTEController.text = widget.product.image ?? "";
    _quantityTEController.text = widget.product.quantity ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameTEController,
                  decoration: const InputDecoration(
                    hintText: 'Product Name',
                    labelText: 'Product Name',
                  ),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Enter your Product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _codeTEController,
                  decoration: const InputDecoration(
                    hintText: 'Product Code',
                    labelText: 'Product Code',
                  ),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Enter your Product Code';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _unitPriceTEController,
                  decoration: const InputDecoration(
                    hintText: 'Unit Price',
                    labelText: 'Unit Price',
                  ),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Enter your Product Price';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _totalPriceTEController,
                  decoration: const InputDecoration(
                    hintText: 'Total Price',
                    labelText: 'Total Price',
                  ),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Enter your Full Price';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _imageTEController,
                  decoration: const InputDecoration(
                    hintText: 'Image',
                    labelText: 'Image',
                  ),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Enter your Product Image';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _quantityTEController,
                  decoration: const InputDecoration(
                    hintText: 'Quantity',
                    labelText: 'Quantity',
                  ),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'Enter your Product Quantity';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                    width: double.infinity,
                    child: Visibility(
                      visible: _updateProductInprogress == false,
                      replacement: const Center(child: CircularProgressIndicator()),
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              _updateProduct();
                            }
                          },
                          child: const Text('update')),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateProduct() async {
    _updateProductInprogress = true;
    setState(() {});
    Uri uri = Uri.parse(
        'https://crud.teamrabbil.com/api/v1/UpdateProduct/${widget.product.id}');
    // Map<String, dynamic> params = {
    //   "Img": _imageTEController.text.trim(),
    //   "ProductCode": _codeTEController.text.trim(),
    //   "ProductName": _nameTEController.text.trim(),
    //   "Qty": _quantityTEController.text.trim(),
    //   "TotalPrice": _totalPriceTEController.text.trim(),
    //   "UnitPrice": _unitPriceTEController.text.trim(),
    // };
    // final Response response = await post(uri, body: jsonEncode(params));
    Product product = Product(
      image: _imageTEController.text.trim(),
      productCode: _codeTEController.text.trim(),
      productName: _nameTEController.text.trim(),
      quantity: _quantityTEController.text.trim(),
      unitPrice: _unitPriceTEController.text.trim(),
      totalPrice: _totalPriceTEController.text.trim(),
    );
    final Response response = await post(uri,
        body: jsonEncode(product.toJson()),
        headers: {'Content-type': 'application/json'});
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      if (decodedData['status'] == 'success') {
        Navigator.pop(context, true);
      } else {
        _updateProductInprogress = true;
        setState(() {});
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Update failed')));
      }
    } else {
      _updateProductInprogress = true;
      setState(() {});
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Update failed')));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _imageTEController.dispose();
    _codeTEController.dispose();
    _nameTEController.dispose();
    _quantityTEController.dispose();
    _totalPriceTEController.dispose();
    _unitPriceTEController.dispose();
  }
}
