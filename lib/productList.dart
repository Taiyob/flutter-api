import 'dart:convert';

import 'package:api_crud/addNewProductScreen.dart';
import 'package:api_crud/editProductScreen.dart';
import 'package:api_crud/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

enum popupMenuType { edit, delete }

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> productList = [];
  bool _inProgress = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductListFromApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: RefreshIndicator(
        onRefresh: () async{
          getProductListFromApi();
        },
        child: Visibility(
          visible: _inProgress == false,
          replacement: const Center(child: CircularProgressIndicator()),
          child: ListView.builder(
              itemCount: productList.length,
              itemBuilder: (context, index) {
                return _getProductListTile(productList[index]);
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddNewProductScreen()));
        },
        label: const Row(
          children: [
            Icon(Icons.add),
            SizedBox(
              width: 8,
            ),
            Text('add'),
          ],
        ),
      ),
    );
  }

  // Method Extraction:
  Widget _getProductListTile(Product product){
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.image ?? ''),
      ),
      title: Text(product.productName ?? ''),
      subtitle: Wrap(
        spacing: 16,
        children: [
          Text('Product Code: ${product.productCode ?? ''}'),
          Text('Total Price: ${product.unitPrice ?? ''}'),
          Text('Unit Price: ${product.totalPrice ?? ''}'),
          Text('Quantity: ${product.quantity ?? ''}'),
        ],
      ),
      trailing: PopupMenuButton<popupMenuType>(
        onSelected: (selectedOption) {
          onTapPopupMenuButton(selectedOption, product);
        },
        itemBuilder: (BuildContext context) {
          return [
            const PopupMenuItem(
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(
                    width: 8,
                  ),
                  Text('Edit'),
                ],
              ),
              value: popupMenuType.edit,
            ),
            const PopupMenuItem(
              child: Row(
                children: [
                  Icon(Icons.delete),
                  SizedBox(
                    width: 8,
                  ),
                  Text('Delete'),
                ],
              ),
              value: popupMenuType.delete,
            ),
          ];
        },
      ),
    );
  }

  void onTapPopupMenuButton(popupMenuType type, Product product) async{
    switch (type) {
      case popupMenuType.edit:
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditProductScreen(product: product),
          ),
        );
        if(result != null && result == true){
          getProductListFromApi();
        }
        break;
      case popupMenuType.delete:
        _showDeleteDialog(product.id!);
        break;
    }
  }

  void _showDeleteDialog(String productId) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete Area'),
            content: const Text('Are you sure you want to delete product?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _deleteProductListFromApi(productId);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Yes, Delete',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future<void> getProductListFromApi() async {
    _inProgress = true;
    setState(() {});
    Uri uri = Uri.parse('https://crud.teamrabbil.com/api/v1/ReadProduct');
    Response response = await get(uri);
    if (response.statusCode == 200) {
      productList.clear();
      var decodedResponse = jsonDecode(response.body);
      var list = decodedResponse['data'];
      for (var item in list) {
        // Product product = Product(
        //   id: item['_id'],
        //   productName: item['ProductName'],
        //   productCode: item['ProductCode'],
        //   unitPrice: item['UnitPrice'],
        //   image: item['Img'],
        //   quantity: item['Qty'],
        //   totalPrice: item['TotalPrice'],
        //   createdDate: item['CreatedDate'],
        // );
        Product product = Product.fromJson(item);
        productList.add(product);
      }
    }
    _inProgress = false;
    setState(() {});
    print(response);
    print(response.body);
    print(response.statusCode);
  }

  Future<void> _deleteProductListFromApi(String productId) async {
    _inProgress = true;
    setState(() {});
    Uri uri = Uri.parse('https://crud.teamrabbil.com/api/v1/DeleteProduct/$productId');
    Response response = await get(uri);
    if (response.statusCode == 200) {
      //getProductListFromApi();
      productList.removeWhere((element) => element.id == productId);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deletion Failed')));
    }
    _inProgress = false;
    setState(() {});
  }
}
