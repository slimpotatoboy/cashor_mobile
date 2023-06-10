import 'package:appwrite/appwrite.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:cashor_app/components/bgbutton.dart';
import 'package:cashor_app/components/invalid_widget.dart';
import 'package:cashor_app/components/single_scaffold.dart';
import 'package:cashor_app/config/colors.dart';
import 'package:cashor_app/config/styles.dart';
import 'package:cashor_app/models/products_model.dart';
import 'package:cashor_app/services/appwrite.dart';
import 'package:cashor_app/services/cart_service.dart';
import 'package:cashor_app/services/products_service.dart';
import 'package:flutter/material.dart';
import 'package:cashor_app/config/constants.dart' as constants;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SingleProductScreen extends StatefulWidget {
  const SingleProductScreen({super.key, this.id, this.result});
  final String? id;
  final dynamic result;

  @override
  State<SingleProductScreen> createState() => _SingleProductScreenState();
}

class _SingleProductScreenState extends State<SingleProductScreen> {
  final productService = ProductsService();
  final cartService = CartService();
  final storage = GetStorage();
  bool isLoading = false;
  late Products products;
  final appwriteStorage = Storage(Appwrite.instance.client);
  bool isScanned = false;
  late String productId;
  String status = "Cancelled";

  @override
  void initState() {
    super.initState();
    onRefresh();
  }

  Future<void> onRefresh() async {
    onGetValue();
  }

  void onGetValue() {
    if (widget.result != null) {
      status = widget.result.type != null ? widget.result.type.toString() : "";
      productId = widget.result.rawContent;
    } else {
      productId = widget.id!;
    }
    getSingleProduct();
    setState(() {});
  }

  void getSingleProduct() async {
    setState(() {
      isLoading = true;
    });
    final result = await productService.get(productId);
    setState(() {
      isLoading = false;
      products = result;
    });
  }

  void onAddToCart(context) async {
    await cartService.create(
      productId: productId,
      productName: products.name,
      quantity: 1,
      price: products.sellingPrice,
      totalPrice: products.sellingPrice,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: greenColor,
        content: Text("Added to Cart"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SingleScaffold(
        title: "Loading",
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return products.businessId != storage.read('businessId')
          ? InvalidWidget(
              label: "Invalid QR - Scan Again",
              onScan: () async {
                var result = await BarcodeScanner.scan();
                if (result.type.toString() != "Cancelled") {
                  Get.to(() => SingleProductScreen(result: result));
                }
              })
          : RefreshIndicator(
              onRefresh: onRefresh,
              child: SingleScaffold(
                title: !isLoading ? products.name : "",
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: FutureBuilder(
                                future: appwriteStorage.getFileView(
                                  bucketId: constants.productBucketId,
                                  fileId: products.thumbnail,
                                ),
                                builder: (context, snapshot) {
                                  return snapshot.hasData &&
                                          snapshot.data != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Image.memory(
                                            snapshot.data!,
                                          ),
                                        )
                                      : const CircularProgressIndicator();
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Rs. ${products.sellingPrice} /-",
                              style: allRedTextStyle,
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: SelectableText(
                                "Cagtegory:  ${products.categoryName ?? 'N/A'}",
                                style: lightStyle,
                              ),
                            ),
                            const Divider(),
                            const SizedBox(height: 10),
                            const Text(
                              "Description: ",
                              style: boldStyle,
                            ),
                            const SizedBox(height: 5),
                            SelectableText(
                              products.description ?? "N/A",
                              style: normalStyle,
                            ),
                            const SizedBox(height: 15),
                            PrimaryButton(
                                label: "Add to Cart",
                                onPress: () {
                                  onAddToCart(context);
                                }),
                            const SizedBox(height: 25),
                            if (products.businessId ==
                                storage.read('businessId'))
                              Container(
                                padding: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                    color: greyColor,
                                    border: Border.all(
                                      width: 1,
                                      color: darkGreyColor,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Only Visible To You",
                                      style: allRedSmallTextStyle,
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        Text("Status: "),
                                        Chip(
                                          label: Text(
                                            products.status
                                                ? "Public"
                                                : "Private",
                                          ),
                                          side: BorderSide.none,
                                          labelStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                          backgroundColor: products.status
                                              ? greenColor
                                              : primaryColor,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Supplier: ${products.supplierName ?? "N/A"}",
                                      style: normalStyle,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Cost Price: Rs. ${products.costPrice} /-",
                                      style: normalStyle,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Current Stock:  ${products.currentStock}",
                                      style: normalStyle,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Initial Stock: ${products.initialStock}",
                                      style: normalStyle,
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 25),
                          ],
                        ),
                      ),
              ),
            );
    }
  }
}
