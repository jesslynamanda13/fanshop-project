import 'package:fanshop/pages/product_detail_page.dart';
import 'package:fanshop/pages/product_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:fanshop/models/product_model.dart';

class ProductEditCard extends StatefulWidget {
  final String uid;
  final String username;
  final String name;
  final ProductModel product;
  ProductEditCard(
      {required this.product,
      required this.uid,
      required this.username,
      required this.name});

  @override
  _ProductEditCardState createState() => _ProductEditCardState();
}

class _ProductEditCardState extends State<ProductEditCard> {
  String _formatProductName(String name) {
    return name.length > 35 ? '${name.substring(0, 35)}...' : name;
  }

  String _formatArtistName(String name) {
    return name.length > 5 ? '${name.substring(0, 5)}...' : name;
  }

  String _formatPrice(int? price) {
    String priceString = price.toString();
    String formattedPrice = '';
    int counter = 0;

    for (int i = priceString.length - 1; i >= 0; i--) {
      counter++;
      formattedPrice = priceString[i] + formattedPrice;
      if (counter == 3 && i != 0) {
        formattedPrice = '.' + formattedPrice;
        counter = 0;
      }
    }
    return formattedPrice;
  }

  void _navigateToDetailPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductEditPage(
            uid: widget.uid,
            username: widget.username,
            name: widget.name,
            product: widget.product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 180.0,
        child: GestureDetector(
            onTap: () => _navigateToDetailPage(context),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(8.0)),
                    child: Image.network(
                      widget.product.imageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 100.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatProductName(widget.product.productName!),
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                    color: widget.product.type ==
                                            'Official Merchandise'
                                        ? Colors.green
                                        : Color.fromARGB(255, 235, 129, 0)),
                              ),
                              child: Text(
                                widget.product.type!,
                                style: TextStyle(
                                  color: widget.product.type ==
                                          'Official Merchandise'
                                      ? Colors.green
                                      : Color.fromARGB(255, 235, 129, 0),
                                  fontSize: 7.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: 4.0),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(color: Colors.purple),
                              ),
                              child: Text(
                                _formatArtistName(widget.product.artist!),
                                style: TextStyle(
                                  fontSize: 7.0,
                                  color: Colors.purple,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Rp. ${_formatPrice(widget.product.price)}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 136, 81, 0),
                          ),
                        ),
                        SizedBox(height: 2.0),
                        Text(
                          '${widget.product.favoritesCount} Favorit',
                          style: TextStyle(color: Colors.grey, fontSize: 10.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}
