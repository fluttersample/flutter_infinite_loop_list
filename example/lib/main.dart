import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:infinite_loop_list/infinite_loop_list.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infinite Loop List Demo',
      theme: ThemeData(primarySwatch: Colors.green),
      scrollBehavior: MyCustomScrollBehavior(),
      home: const DemoScreen(),
    );
  }
}

class DemoScreen extends StatelessWidget {
  const DemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Infinite Auto Scroll List")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white
              ),
                onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return VerticalListScreen();
              },));
            }, child: Text('Vertical List')),
          ),
          SizedBox(height: 30,),

          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white
              ),
                onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return HorizontalListScreen();
              },));
            }, child: Text('Horizontal List')),
          ),
        ],
      ),
    );
  }
}
class VerticalListScreen extends StatefulWidget {
  const VerticalListScreen({super.key});

  @override
  State<VerticalListScreen> createState() => _VerticalListScreenState();
}

class _VerticalListScreenState extends State<VerticalListScreen> {

  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Product.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Infinite Loop List Vertical'),
      ),
      body: FutureBuilder(
        future: futureProducts,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            List<Product> products = snapshot.data!;
            return InfiniteLoopList(
            scrollDirection: Axis.vertical,
            scrollSpeed: 3.0,
            pauseDuration: const Duration(seconds: 3),
            padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  Product product = products[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product.image,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error, color: Colors.red);
                          },
                        ),
                      ),
                      title: Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            '\$${product.price}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            product.category,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // می‌تونی صفحه جزئیات محصول رو اینجا باز کنی
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('انتخاب شد: ${product.title}')),
                        );
                      },
                    ),
                  );
                }, itemCount: products.length,
          );
          }else if (snapshot.hasError) {
            return Center(child: Text('خطا: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        }
      ),
    );
  }
}



class HorizontalListScreen extends StatefulWidget {
  const HorizontalListScreen({super.key});

  @override
  State<HorizontalListScreen> createState() => _HorizontalListScreenState();
}

class _HorizontalListScreenState extends State<HorizontalListScreen> {

  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Product.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Infinite Loop List Horizontal'),
      ),
      body: Column(
        children: [

          FutureBuilder(
              future: futureProducts,
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  List<Product> products = snapshot.data!;
                  return SizedBox(
                    height: 250,
                    child: InfiniteLoopList(
                      itemCount: products.length,
                      scrollDirection: Axis.horizontal,
                      scrollSpeed: 3.0,
                      pauseDuration: const Duration(seconds: 1),
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        Product product = products[index];
                        return Container(
                          width: 160, // عرض هر آیتم
                          margin: const EdgeInsets.only(right: 12),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('انتخاب شد: ${product.title}')),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // تصویر محصول
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                    child: Image.network(
                                      product.image,
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          height: 100,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.error, color: Colors.red),
                                        );
                                      },
                                    ),
                                  ),
                                  // اطلاعات محصول
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '\$${product.price}',
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          product.category,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[600],
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }else if (snapshot.hasError) {
                  return Center(child: Text('خطا: ${snapshot.error}'));
                }
                return const Center(child: CircularProgressIndicator());
              }
          ),
        ],
      ),
    );
  }
}


class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
    );
  }
}
