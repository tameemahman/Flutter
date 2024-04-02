import 'dart:convert';

import 'package:e_commerce/models/catalog.dart';
import 'package:e_commerce/widget/drawer.dart';
import 'package:e_commerce/widget/item_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String iurl = "https://images.unsplash.com/photo-1606041011872-596597976b25?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8YXBwbGUlMjBpcGhvbmV8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  void loadData() async{
    var catalogJson = await rootBundle.loadString('assets/files/catalog.json');
    var decodeData = jsonDecode(catalogJson);
    // print(decodeData);
    var productData = decodeData['products'];
    // print(productData);
    CatalogModel.item = List.from(productData).map<Item>((e) => Item.fromMap(e)).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: CatalogModel.item.length,
            itemBuilder: (context, index){
            return ItemWidget(
              item: CatalogModel.item[index],
            );
            }
        ),
      ),


      drawer: MyDrawer(),
    );
  }


}
