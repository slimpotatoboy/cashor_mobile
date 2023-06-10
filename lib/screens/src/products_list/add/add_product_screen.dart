import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:cashor_app/components/bgbutton.dart';
import 'package:cashor_app/components/custom_dropdown.dart';
import 'package:cashor_app/components/single_scaffold.dart';
import 'package:cashor_app/components/textfields.dart';
import 'package:cashor_app/config/colors.dart';
import 'package:cashor_app/config/styles.dart';
import 'package:cashor_app/models/products_model.dart';
import 'package:cashor_app/services/appwrite.dart';
import 'package:cashor_app/services/categories_service.dart';
import 'package:cashor_app/services/people_services.dart';
import 'package:cashor_app/services/products_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cashor_app/config/constants.dart' as constants;

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key, this.id});
  final String? id;

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  // services
  final categoryService = CategoriesService();
  final peopleService = PeopleServices();
  final productsService = ProductsService();
  final appwriteStorage = Storage(Appwrite.instance.client);
  final storage = GetStorage();

  // formkey and textEditingControllers
  final _formKey = GlobalKey<FormState>();
  final TextEditingController productController = TextEditingController();
  final TextEditingController costPriceController = TextEditingController();
  final TextEditingController sellingPriceController = TextEditingController();
  final TextEditingController initialStockController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  // loading state
  bool isLoading = false;
  bool isLoadingSubmit = false;
  // current product status
  bool status = false;

  // category variables
  String selectedCategory = "";
  String selectedCategoryName = "";
  List categoryList = [];

  // supplier variables
  String selectedSupplier = "";
  String selectedSupplierName = "";
  List supplierList = [];

  ImagePicker picker = ImagePicker();
  File? _productThumbnail;

  late Products product;

  @override
  void initState() {
    super.initState();
    onRefresh();
  }

  // when user refresh
  Future<void> onRefresh() async {
    if (widget.id != null) {
      onGetProductDetails();
    } else {
      getCategories();
      getSuppliers();
    }
  }

  void onGetProductDetails() async {
    setState(() {
      isLoading = true;
    });
    final response = await productsService.get(widget.id!);
    setState(() {
      product = response;
      productController.text = product.name;
      costPriceController.text = product.costPrice.toString();
      sellingPriceController.text = product.sellingPrice.toString();
      initialStockController.text = product.initialStock.toString();
      descController.text = product.description ?? "";
      status = product.status;
      isLoading = false;
    });
  }

  // remove image from the state
  _removeThumbnail() {
    setState(() {
      _productThumbnail = null;
    });
  }

  // upload image using gallery
  _uploadThumbnail([context]) async {
    FocusManager.instance.primaryFocus?.unfocus();
    XFile? img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      _productThumbnail = File(img.path);
    }
    if (context != null) {
      Navigator.pop(context);
    }
    setState(() {});
  }

  // upload image using camera
  _uploadCameraThumbnail([context]) async {
    FocusManager.instance.primaryFocus?.unfocus();
    XFile? img = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 480,
      maxWidth: 640,
    );
    if (img != null) {
      _productThumbnail = File(img.path);
    }
    if (context != null) {
      Navigator.pop(context);
    }
    setState(() {});
  }

  // get list of all categories
  void getCategories() async {
    setState(() {
      isLoading = true;
    });
    final result = await categoryService.fetch();
    setState(() {
      isLoading = false;
      categoryList = result;
      selectedCategory = categoryList[0].id;
      selectedCategoryName = categoryList[0].name;
    });
  }

  /// get suppliers list
  void getSuppliers() async {
    setState(() {
      isLoading = true;
    });
    final result = await peopleService.fetch(type: "Supplier");
    if (result.isNotEmpty) {
      setState(() {
        isLoading = false;
        supplierList = result;
        selectedSupplier = supplierList[0].id;
        selectedSupplierName = supplierList[0].name;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  // when one category is tapped
  void onTapCategory(data) {
    setState(() {
      selectedCategoryName = data.name;
    });
  }

  // when one category is tapped
  void onTapSupplier(data) {
    setState(() {
      selectedSupplierName = data.name;
    });
  }

  // when user submits add product
  void onSubmitProduct(context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_productThumbnail != null) {
      if (int.parse(costPriceController.text) >
          int.parse(sellingPriceController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.orange,
            content: Text("Selling Price should be greater than Cost Price"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        if (widget.id != null) {
          // will delete the image at first then the image will be uploaded
          await productsService.deleteImage(product.thumbnail);
        }
        setState(() {
          isLoadingSubmit = true;
        });
        // storing new image to the database
        final imageName =
            await productsService.storeImage(_productThumbnail!.path, status);
        // if user adds products
        if (widget.id == null) {
          if (imageName != null) {
            await productsService.create(
              name: productController.text,
              thumbnail: imageName,
              description: descController.text,
              status: status,
              supplierId: selectedSupplier,
              supplierName: selectedSupplierName,
              categoryId: selectedCategory,
              categoryName: selectedCategoryName,
              costPrice: costPriceController.text,
              sellingPrice: sellingPriceController.text,
              initialStock: initialStockController.text,
              currentStock: initialStockController.text,
            );
          }
        } else {
          await productsService.udpate(
            id: widget.id!,
            name: productController.text,
            thumbnail: imageName,
            description: descController.text,
            status: status,
            costPrice: costPriceController.text,
            sellingPrice: sellingPriceController.text,
            initialStock: initialStockController.text,
            currentStock: initialStockController.text,
          );
        }
        Get.back(result: "Return");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: greenColor,
            content: Text(
                "Product ${widget.id != null ? 'Updated' : 'Created'} Successfully"),
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() {
          isLoadingSubmit = false;
        });
      }
    } else if (widget.id != null) {
      setState(() {
        isLoadingSubmit = true;
      });
      await productsService.udpate(
        id: widget.id!,
        name: productController.text,
        thumbnail: product.thumbnail,
        description: descController.text,
        status: status,
        costPrice: costPriceController.text,
        sellingPrice: sellingPriceController.text,
        initialStock: initialStockController.text,
        currentStock: initialStockController.text,
      );
      setState(() {
        isLoadingSubmit = false;
      });
      Get.back(result: "Return");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: greenColor,
          content: Text("Product Updated Successfully"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orange,
          content: Text("Please choose thumbnail to add order"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void onSelectCategory(value) {
    setState(() {
      selectedCategory = value;
    });
  }

  void onSelectSupplier(value) {
    setState(() {
      selectedSupplier = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleScaffold(
      title: widget.id != null ? "Edit Product" : "Add Product",
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.id == null)
                      if (categoryList.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: CustomDropdown(
                            label: "Select Category",
                            valueText: selectedCategory,
                            allList: categoryList.map<DropdownMenuItem>(
                              (item) {
                                return DropdownMenuItem(
                                  value: item.id,
                                  child: Text(item.name),
                                  onTap: () {
                                    onTapCategory(item);
                                  },
                                );
                              },
                            ).toList(),
                            onChange: onSelectCategory,
                          ),
                        ),
                    if (widget.id == null)
                      if (supplierList.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: CustomDropdown(
                            label: "Select Supplier",
                            valueText: selectedSupplier,
                            allList: supplierList.map<DropdownMenuItem>(
                              (item) {
                                return DropdownMenuItem(
                                  value: item.id,
                                  child: Text(item.name),
                                  onTap: () {
                                    onTapSupplier(item);
                                  },
                                );
                              },
                            ).toList(),
                            onChange: onSelectSupplier,
                          ),
                        ),
                    EntryFieldWidget(
                      label: "Product Name",
                      controller: productController,
                      errorText: "Product Name is required",
                      focusColor: Colors.black54,
                      defaultColour: const Color(0xFFEBF0FF),
                      hintText: "",
                    ),
                    const SizedBox(height: 20),
                    PhoneNumberFieldWidget(
                      label: "Product Cost Price",
                      controller: costPriceController,
                      errorText: "Cost Price is required",
                      focusColor: Colors.black54,
                      defaultColour: const Color(0xFFEBF0FF),
                      hintText: "",
                    ),
                    const SizedBox(height: 20),
                    PhoneNumberFieldWidget(
                      label: "Selling Price",
                      controller: sellingPriceController,
                      errorText: "Selling Price is required",
                      focusColor: Colors.black54,
                      defaultColour: const Color(0xFFEBF0FF),
                      hintText: "",
                    ),
                    const SizedBox(height: 20),
                    PhoneNumberFieldWidget(
                      label: "Total Stock",
                      controller: initialStockController,
                      errorText: "Stock is required",
                      focusColor: Colors.black54,
                      defaultColour: const Color(0xFFEBF0FF),
                      hintText: "",
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Text("Thumbnail", style: lightStyle),
                    ),
                    const SizedBox(height: 8),
                    thumbnailWidget(),
                    const SizedBox(height: 20),
                    MultiLineTextField(
                      label: "Description",
                      hintText: "",
                      controller: descController,
                      isValidation: true,
                      validation: "Description is required field!",
                      maxLines: 5,
                    ),
                    if (storage.read("visibility"))
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 5.0,
                                ),
                                child: Text("Visibility: ", style: lightStyle),
                              ),
                              Tooltip(
                                preferBelow: false,
                                triggerMode: TooltipTriggerMode.tap,
                                message:
                                    "Set your product visibility to Public",
                                child: Icon(Icons.info),
                              ),
                            ],
                          ),
                          Switch(
                            value: status,
                            activeColor: whiteColor,
                            activeTrackColor: greenColor,
                            inactiveThumbColor: primaryColor,
                            inactiveTrackColor: greyColor,
                            onChanged: (bool value) {
                              setState(() {
                                status = value;
                              });
                            },
                          ),
                        ],
                      ),
                    const SizedBox(height: 50),
                    if (!isLoadingSubmit)
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: PrimaryButton(
                          label: "Submit",
                          onPress: () {
                            if (_formKey.currentState!.validate()) {
                              onSubmitProduct(context);
                            }
                          },
                        ),
                      ),
                    if (isLoadingSubmit)
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: GreyIconButton(
                          label: "Loading...",
                          onPressed: () {},
                        ),
                      ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }

  Widget thumbnailWidget() {
    if (widget.id != null) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: _productThumbnail != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.file(
                      _productThumbnail!,
                      width: double.infinity,
                    ),
                  )
                : Center(
                    child: FutureBuilder(
                      future: appwriteStorage.getFileView(
                        bucketId: constants.productBucketId,
                        fileId: product.thumbnail,
                      ),
                      builder: (context, snapshot) {
                        return snapshot.hasData && snapshot.data != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.memory(
                                  snapshot.data!,
                                ),
                              )
                            : const CircularProgressIndicator();
                      },
                    ),
                  ),
          ),
          SizedBox(
            height: 60,
            child: GreyIconButton(
              label: "Change Photo",
              icon: "photo",
              onPressed: () {
                bottomSheet();
              },
            ),
          ),
        ],
      );
    } else if (_productThumbnail != null) {
      return Column(
        children: [
          Stack(
            children: [
              Image.file(
                _productThumbnail!,
                width: double.infinity,
              ),
              Positioned(
                top: 10,
                right: 10,
                child: InkWell(
                  onTap: () {
                    _removeThumbnail();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: whiteColor,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 60,
            child: GreyIconButton(
              label: "Change Photo",
              icon: "photo",
              onPressed: () {
                bottomSheet();
              },
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          SizedBox(
            height: 60,
            child: GreyIconButton(
              label: "Choose product thumbnail",
              icon: "photo",
              onPressed: () {
                _uploadThumbnail();
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              "OR",
              style: boldStyle,
            ),
          ),
          SizedBox(
            height: 60,
            child: GreyIconButton(
              label: "Capture Photo",
              icon: "camera",
              onPressed: () {
                _uploadCameraThumbnail();
              },
            ),
          ),
        ],
      );
    }
  }

  void bottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            decoration: BoxDecoration(
                color: whiteColor, borderRadius: BorderRadius.circular(20.0)),
            child: Wrap(
              children: [
                const Text(
                  "Select any to change photo",
                  style: lightStyle,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    children: [
                      imageBottomSheetContainer(
                        "Camera",
                        Icons.camera_alt,
                        () {
                          _uploadCameraThumbnail(context);
                        },
                      ),
                      const SizedBox(width: 30),
                      imageBottomSheetContainer(
                        "Gallery",
                        Icons.photo,
                        () {
                          _uploadThumbnail(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  InkWell imageBottomSheetContainer(
      String label, IconData icon, Function function) {
    return InkWell(
      onTap: () {
        function();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: primaryColor,
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(
              icon,
              color: primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: lightStyle,
          ),
        ],
      ),
    );
  }
}
