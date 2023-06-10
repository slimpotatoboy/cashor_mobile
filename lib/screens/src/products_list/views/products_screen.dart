import 'package:cashor_app/components/bgbutton.dart';
import 'package:cashor_app/components/empty_widget.dart';
import 'package:cashor_app/config/colors.dart';
import 'package:cashor_app/config/config.dart';
import 'package:cashor_app/config/styles.dart';
import 'package:cashor_app/screens/src/products_list/add/add_product_screen.dart';
import 'package:cashor_app/screens/src/products_list/custom_qr/custom_qr_screen.dart';
import 'package:cashor_app/screens/src/products_list/single/single_product_screen.dart';
import 'package:cashor_app/services/cart_service.dart';
import 'package:cashor_app/services/products_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cashor_app/config/constants.dart' as constants;
import 'package:cached_network_image/cached_network_image.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final storage = GetStorage();
  bool isLoading = false;
  List products = [];
  final productService = ProductsService();
  final cartService = CartService();

  @override
  void initState() {
    super.initState();
    onRefresh();
    storage.listenKey('businessId', (value) {
      onRefresh();
    });
  }

  Future<void> onRefresh() async {
    getAllProducts();
  }

  void getAllProducts() async {
    setState(() {
      isLoading = true;
    });
    final result = await productService.fetch();

    products = result;
    isLoading = false;
    setState(() {});
  }

  void onAddToCart(item, context) async {
    await cartService.create(
      productId: item.id,
      productName: item.name,
      quantity: 1,
      price: item.sellingPrice,
      totalPrice: item.sellingPrice,
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
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: isLoading
            ? const SizedBox(
                height: 400, child: Center(child: CircularProgressIndicator()))
            : Column(
                children: [
                  booksAppBar(),
                  if (products.isEmpty)
                    EmptyWidget(
                        label: "No Products Found", onRefresh: onRefresh),
                  if (products.isNotEmpty)
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        var item = products[index];
                        return Container(
                          margin: const EdgeInsets.only(top: 20.0),
                          padding: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            color: greyColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "${Config.baseImageUrl}${constants.productBucketId}/files/${item.thumbnail}/preview?project=${constants.appwriteProjectId}",
                                  width: 100,
                                  height: 140,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    "assets/images/logo11.png",
                                    width: 100,
                                    height: 140,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Get.to(() =>
                                                      SingleProductScreen(
                                                          id: item.id));
                                                },
                                                child: Text(
                                                  item.name,
                                                  style: boldStyle,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: SelectableText(
                                                  item.categoryName ?? 'N/A',
                                                  style: smallStyle,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: SelectableText(
                                                  "Rs. ${item.sellingPrice} /-",
                                                  style: allRedSmallTextStyle,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        PopupMenuButton(
                                          onSelected: (value) {
                                            if (value == 0) {
                                              Get.to(() => SingleProductScreen(
                                                  id: item.id));
                                            }
                                            if (value == 1) {
                                              if (item.status) {
                                                Get.to(() => CustomLinkScreen(
                                                    id: item.id,
                                                    name: item.name));
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content: Text(
                                                      "Please set your product status to public"),
                                                ));
                                              }
                                            }
                                            if (value == 2) {
                                              Get.to(() => AddProductScreen(
                                                  id: item.id));
                                            }
                                          },
                                          surfaceTintColor: whiteColor,
                                          icon: const Icon(Icons.more_vert),
                                          itemBuilder: (context) => [
                                            const PopupMenuItem(
                                              value: 0,
                                              child: Text("View Product"),
                                            ),
                                            if (item.status &&
                                                storage.read("visibility"))
                                              const PopupMenuItem(
                                                value: 1,
                                                child:
                                                    Text("Product QR and Link"),
                                              ),
                                            const PopupMenuItem(
                                              value: 2,
                                              child: Text("Edit Product"),
                                            ),
                                            // const PopupMenuItem(
                                            //   value: 3,
                                            //   child: Text("Set as Archived"),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "Updated ${timeago.format(item.createdAt)}",
                                      style: smallBoldStyle,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: SizedBox(
                                        height: 40,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: primaryColor,
                                            foregroundColor: whiteColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          onPressed: () {
                                            onAddToCart(item, context);
                                          },
                                          child: const Text(
                                            "Add To Cart",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
      ),
    );
  }

  Row booksAppBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Your products",
          style: boldStyle,
        ),
        Row(
          children: [
            // TODO: add search feature
            // IconButton(
            //   onPressed: () {},
            //   icon: SvgPicture.asset("assets/icons/search.svg"),
            // ),
            SmallIconButton(
              label: "Add",
              onPressed: () async {
                final result = await Get.to(() => const AddProductScreen());
                if (result != null) {
                  onRefresh();
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
