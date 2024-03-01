import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddNewProductScreen extends StatefulWidget {
  const AddNewProductScreen({super.key});

  @override
  State<AddNewProductScreen> createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _codeTEController = TextEditingController();
  final TextEditingController _unitPriceTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();
  final TextEditingController _quantityTEController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _addNewProductInprogress = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Product'),
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
                      visible: _addNewProductInprogress == false,
                      replacement: const Center(child: CircularProgressIndicator()),
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              createNewProduct();
                            }
                          },
                          child: const Text('add')),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createNewProduct() async {
    _addNewProductInprogress = true;
    setState(() {});
    Uri uri = Uri.parse('https://crud.teamrabbil.com/api/v1/CreateProduct');
    Map<String, dynamic> params = {
      "Img": _imageTEController.text.trim(),
      "ProductCode": _codeTEController.text.trim(),
      "ProductName": _nameTEController.text.trim(),
      "Qty": _quantityTEController.text.trim(),
      "TotalPrice": _totalPriceTEController.text.trim(),
      "UnitPrice": _unitPriceTEController.text.trim(),
    };
    Response response = await post(uri,
        body: jsonEncode(params),
        headers: {'Content-type': 'application/json'});
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      print('Product added');
      _imageTEController.clear();
      _codeTEController.clear();
      _nameTEController.clear();
      _quantityTEController.clear();
      _totalPriceTEController.clear();
      _unitPriceTEController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Successfully created')));
    }
    _addNewProductInprogress = false;
    setState(() {});
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
