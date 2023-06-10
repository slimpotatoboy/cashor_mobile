import 'package:appwrite/appwrite.dart';
import 'package:cashor_app/components/list_button.dart';
import 'package:cashor_app/components/single_scaffold.dart';
import 'package:cashor_app/config/colors.dart';
import 'package:cashor_app/config/styles.dart';
import 'package:cashor_app/screens/src/more/business_settings/business_profile/business_profile_screen.dart';
import 'package:cashor_app/services/appwrite.dart';
import 'package:cashor_app/services/business_service.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cashor_app/config/constants.dart' as constants;

class BusinessSettingsScreen extends StatefulWidget {
  const BusinessSettingsScreen({super.key});

  @override
  State<BusinessSettingsScreen> createState() => _BusinessSettingsScreenState();
}

class _BusinessSettingsScreenState extends State<BusinessSettingsScreen> {
  final businessService = BusinessService();
  bool _businessStatus = false;
  final storage = GetStorage();
  final functions = Functions(Appwrite.instance.client);

  @override
  void initState() {
    super.initState();
    getBusinessStatus();
  }

  void getBusinessStatus() async {
    final result = await businessService.get();
    if (result != null) {
      if (result.permissions.contains('read("any")')) {
        setState(() {
          _businessStatus = true;
        });
      } else {
        setState(() {
          _businessStatus = false;
        });
      }
    }
  }

  void updatePermissions(value) async {
    await businessService.updatePermission(status: value);
  }

  @override
  Widget build(BuildContext context) {
    return SingleScaffold(
      title: "Business Settings",
      child: Column(
        children: [
          ListButton(
            imageUrl: "user.svg",
            label: "Business Profile",
            desc: "Edit your business details",
            onPressed: () {
              Get.to(() => const BusinessProfileScreen());
            },
          ),
          ListButton(
            imageUrl: "user.svg",
            label: "Orders to Books",
            desc:
                "Automatically generate cash for book sales from delivered and offline orders",
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Wrap(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                              child: Text(
                                "Orders to Book",
                                style: boldStyle,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(bottom: 25.0),
                              child: const Text(
                                "Automatically generate cash for book sales from delivered and offline orders",
                                style: lightStyle,
                              ),
                            ),
                            SwitchListTile(
                              activeColor: whiteColor,
                              activeTrackColor: greenColor,
                              inactiveThumbColor: primaryColor,
                              inactiveTrackColor: greyColor,
                              title:
                                  Text(!_businessStatus ? "Private" : "Public"),
                              value: _businessStatus,
                              onChanged: (bool value) async {
                                final exe = await functions.createExecution(
                                  functionId: constants.functionId,
                                  data:
                                      "{'databaseId': ${constants.appwriteDatabaseId}, 'collectionId': ${constants.ordersCollectionId}, 'businessId': '' }",
                                );
                                print(exe.response);
                                // setState(() {
                                //   _businessStatus = value;
                                // });
                                // storage.write("visibility", value);
                                // updatePermissions(value);
                              },
                              secondary: const Icon(Icons.privacy_tip),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
          ListButton(
            imageUrl: "key.svg",
            label: "Change Business Visibility",
            desc:
                "Set your status public or private in order to share your products to public",
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Wrap(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                              child: Text(
                                "Change Business Visibility",
                                style: boldStyle,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(bottom: 25.0),
                              child: const Text(
                                "Once you change it to public, you can showcase your inidividual products to public by changing product status in product settings",
                                style: lightStyle,
                              ),
                            ),
                            SwitchListTile(
                              activeColor: whiteColor,
                              activeTrackColor: greenColor,
                              inactiveThumbColor: primaryColor,
                              inactiveTrackColor: greyColor,
                              title:
                                  Text(!_businessStatus ? "Private" : "Public"),
                              value: _businessStatus,
                              onChanged: (bool value) {
                                setState(() {
                                  _businessStatus = value;
                                });
                                storage.write("visibility", value);
                                updatePermissions(value);
                              },
                              secondary: const Icon(Icons.privacy_tip),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
          ListButton(
            imageUrl: "cloud-download.svg",
            label: "Download Your Data",
            desc: "Coming Soon in v2....",
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
