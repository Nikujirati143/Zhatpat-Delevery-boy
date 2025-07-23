import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatelessWidget {
  final products = FirebaseFirestore.instance.collection('products');
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Dashboard")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                TextField(controller: nameController, decoration: InputDecoration(labelText: "Product Name")),
                TextField(controller: priceController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Price")),
                ElevatedButton(
                  child: Text("Add Product"),
                  onPressed: () {
                    products.add({
                      'name': nameController.text,
                      'price': int.parse(priceController.text)
                    });
                    nameController.clear();
                    priceController.clear();
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: products.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                var docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var data = docs[index];
                    return ListTile(
                      title: Text(data['name']),
                      subtitle: Text("₹${data['price']}"),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          products.doc(docs[index].id).delete();
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
