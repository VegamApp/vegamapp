import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/services/api_services/api_services.dart';
import 'package:m2/services/api_services/customer_apis.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/services/models/user.dart';
import 'package:m2/services/state_management/user/user_data.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/account_sidebar.dart';
import 'package:m2/utilities/widgets/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

class AddressView extends StatefulWidget {
  const AddressView({super.key});
  static String route = 'address';
  @override
  State<AddressView> createState() => AddressViewState();
}

class AddressViewState extends State<AddressView> {
  final ScrollController scrollController = ScrollController();
  bool regAsUser = false;
  late UserData userData;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    userData = Provider.of<UserData>(context);

    return BuildScaffold(
      child: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.isMobile(context)
                ? 20
                : constraints.maxWidth > 1400
                    ? (constraints.maxWidth - 1400) / 2
                    : 20,
            vertical: 20,
          ),
          child: AppResponsive(
            desktop: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 3,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: AccountSideBar(currentPage: AddressView.route),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                      margin: const EdgeInsets.only(top: 40),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldColor,
                        boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 50, offset: const Offset(0, 10))],
                      ),
                      child: getBody(context, size)),
                ),
              ],
            ),
            mobile: getBody(context, size),
          ),
        );
      }),
    );
  }

  Padding getBody(BuildContext context, Size size) {
    return Padding(
      padding: AppResponsive.isDesktop(context) ? const EdgeInsets.symmetric(horizontal: 60, vertical: 50) : EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text('Manage Addresses', style: AppStyles.getMediumTextStyle(fontSize: 18, color: AppColors.primaryColor)),
          ),
          const SizedBox(height: 30),
          Query(
              options: QueryOptions(document: CustomerApis.requestUserData),
              builder: (result, {fetchMore, refetch}) {
                if (result.isLoading) {
                  return Center(child: BuildLoadingWidget(color: AppColors.primaryColor));
                }
                if (result.hasException) {
                  return Center(
                    child: BuildErrorWidget(onRefresh: refetch),
                  );
                }
                // log(jsonEncode(result.data!['customer']));
                userData.putData(User.fromJson(result.data!['customer']));
                userData.addressesList.clear();
                userData.addressesList.addAll(ObservableList<Addresses>.of(userData.data.addresses ?? <Addresses>[]));

                return Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    InkWell(
                      onTap: () => showAddAddressDialog(context, size, userData).then((value) => refetch!()),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 400, minHeight: 255),
                        decoration: BoxDecoration(
                          color: const Color(0xffffffff),
                          borderRadius: BorderRadius.circular(size.width * .025 > 20 ? 20 : size.width * 0.025),
                          border: Border.all(width: 1.0, color: const Color(0xffa0dcd6)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0a000000),
                              offset: Offset(0, 10),
                              blurRadius: 40,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                color: AppColors.primaryColor,
                                size: 50,
                              ),
                              Text("Add New Address", style: AppStyles.getMediumTextStyle(fontSize: 20, color: AppColors.fadedText)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ...userData.addressesList.map(
                      (e) => BuildAddressContainer(
                        addressModel: e,
                        size: size,
                        onRemove: () => refetch!(),
                        onEdit: () => showAddAddressDialog(context, size, userData, addressModel: e).then((value) => refetch!()),
                      ),
                    ),
                  ],
                );
              })
        ],
      ),
    );
  }

  static Future<void> showAddAddressDialog(BuildContext context, Size size, UserData userData, {Addresses? addressModel}) {
    final formKey = GlobalKey<FormState>();
    Map<String, dynamic> countries = {};
    Map<String, dynamic> regions = {};
    // For new addresses
    TextEditingController fName = TextEditingController(text: addressModel?.firstname);
    TextEditingController lName = TextEditingController(text: addressModel?.lastname);
    TextEditingController appartNo = TextEditingController(text: addressModel?.street != null && addressModel!.street!.length > 1 ? addressModel.street?.first : null);
    TextEditingController street = TextEditingController(text: addressModel?.street?.last);
    TextEditingController city = TextEditingController(text: addressModel?.city);
    TextEditingController contact = TextEditingController(text: addressModel?.telephone);
    TextEditingController pin = TextEditingController(text: addressModel?.postcode);

    bool isDefaultShipping = addressModel?.defaultShipping ?? false;
    bool isDefaultBilling = addressModel?.defaultBilling ?? false;

    // TextEditingController state = TextEditingController();
    Map selectedCountry = {'id': "IN", 'full_name_english': 'India'};
    Map<String, dynamic> selectedRegion = {
      "name": addressModel?.region?.region ?? "Kerala",
      "region_code": addressModel?.region?.regionCode ?? "KL",
      "id": addressModel?.region?.regionId ?? 502,
      "__typename": "CustomerAddressRegion"
    };

    return showDialog(
      context: context,
      builder: (context) {
        TextEditingController countrySearch = TextEditingController();

        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              constraints: BoxConstraints(maxWidth: 500, maxHeight: size.height * 0.8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColors.scaffoldColor),
              child: Form(
                key: formKey,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Center(
                        child: Text(addressModel != null ? "Edit address" : 'Add a New Address', style: AppStyles.getMediumTextStyle(fontSize: 20, color: AppColors.primaryColor))),
                    const SizedBox(height: 20),
                    BuildTextField(
                      controller: fName,
                      hint: 'First name',
                      textCapitalization: TextCapitalization.words,
                      validator: (value) => value != null && value != '' ? null : 'Enter a valid name',
                    ),
                    const SizedBox(height: 20),
                    BuildTextField(
                      controller: lName,
                      hint: 'Last name',
                      textCapitalization: TextCapitalization.words,
                      validator: (value) => value != null && value != '' ? null : 'Enter a valid name',
                    ),
                    const SizedBox(height: 20),
                    BuildTextField(
                      controller: appartNo,
                      textCapitalization: TextCapitalization.words,
                      hint: 'Appartment Number',
                      validator: (value) => value != null && value != '' ? null : 'Enter a valid appartment number',
                    ),
                    const SizedBox(height: 20),
                    BuildTextField(
                      controller: street,
                      textCapitalization: TextCapitalization.words,
                      hint: 'Street',
                      validator: (value) => value != null && value != '' ? null : 'Enter a valid street name',
                    ),
                    const SizedBox(height: 20),
                    BuildTextField(
                      controller: city,
                      hint: 'City',
                      textCapitalization: TextCapitalization.words,
                      validator: (value) => value != null && value != '' ? null : 'Enter a valid city',
                    ),
                    const SizedBox(height: 20),
                    BuildTextField(
                      controller: contact,
                      hint: 'Contact Number',
                      maxLength: 14,
                      showLength: false,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      validator: (value) => value != null && value.length > 5 ? null : 'Enter a valid contact number',
                    ),
                    const SizedBox(height: 20),
                    BuildTextField(
                      controller: pin,
                      hint: 'PIN Code',
                      maxLength: 6,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      showLength: false,
                      keyboardType: TextInputType.number,
                      validator: (value) => value != null && value != '' ? null : 'Enter a valid PIN code',
                    ),
                    const SizedBox(height: 20),
                    Query(
                      options: QueryOptions(document: gql(ApiServices.getCountries)),
                      builder: (result, {fetchMore, refetch}) {
                        // if (result.isLoading) {
                        //   return Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.primaryColor)));
                        // }
                        if (result.isLoading) return const SizedBox();
                        if (selectedRegion.isEmpty && addressModel != null) {
                          selectedRegion = result.data!['countries'][0]['available_regions'].firstWhere((element) => element['code'] == addressModel.region?.regionCode);
                          // //print(selectedRegion);
                        }
                        countries = result.data!;
                        return InkWell(
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                backgroundColor: Colors.transparent,
                                child: StatefulBuilder(builder: (context, setState) {
                                  return Container(
                                    width: size.width * 0.8,
                                    height: size.height * 0.8,
                                    padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
                                    constraints: BoxConstraints(maxWidth: 500, maxHeight: size.height * 0.8),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColors.scaffoldColor),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Material(
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            BuildTextField(controller: countrySearch, hint: 'Search', onChanged: (value) => setState(() {})),
                                            Expanded(
                                              child: ListView.separated(
                                                // shrinkWrap: true,
                                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                                                itemCount: getCountryList(countries, countrySearch.text).length,
                                                separatorBuilder: (context, index) => const SizedBox(height: 20),
                                                itemBuilder: (context, index) {
                                                  List countriesList = getCountryList(countries, countrySearch.text);
                                                  return InkWell(
                                                    onTap: () {
                                                      selectedCountry = countriesList[index];
                                                      //print(selectedCountry);
                                                      FocusManager.instance.primaryFocus?.unfocus();
                                                      countrySearch.clear();
                                                      Navigator.pop(context);
                                                      setState(() {});
                                                    },
                                                    child: Text(
                                                      countriesList[index]['full_name_english'],
                                                      style: AppStyles.getRegularTextStyle(fontSize: 16),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              );
                            },
                          ).then((value) => setState(() {})),
                          child: Container(
                            width: size.width,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(width: 1, color: AppColors.evenFadedText),
                            ),
                            child: Text(selectedCountry.isEmpty ? 'Select country' : selectedCountry['full_name_english'],
                                style: AppStyles.getLightTextStyle(fontSize: 14, color: AppColors.fadedText)),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    if (selectedCountry.isNotEmpty)
                      Query(
                        options: QueryOptions(document: gql(ApiServices.getRegion(selectedCountry['id']))),
                        builder: (result, {fetchMore, refetch}) {
                          // if (result.isLoading) {
                          //   return Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.primaryColor)));
                          // }
                          if (result.isLoading) return const SizedBox();
                          // log(jsonEncode(result.data));
                          regions = result.data!;
                          return InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    backgroundColor: Colors.transparent,
                                    child: StatefulBuilder(builder: (context, setState) {
                                      return Container(
                                        width: size.width * 0.8,
                                        height: size.height * 0.8,
                                        padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
                                        constraints: BoxConstraints(maxWidth: 500, maxHeight: size.height * 0.8),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColors.scaffoldColor),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: Material(
                                            color: Colors.white,
                                            child: Column(
                                              children: [
                                                BuildTextField(controller: countrySearch, hint: 'Search', onChanged: (value) => setState(() {})),
                                                Expanded(
                                                  child: ListView.separated(
                                                    // shrinkWrap: true,
                                                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                                                    itemCount: getCountryList(countries, countrySearch.text).length,
                                                    separatorBuilder: (context, index) => const SizedBox(height: 20),
                                                    itemBuilder: (context, index) {
                                                      List countriesList = getCountryList(countries, countrySearch.text);
                                                      return InkWell(
                                                        onTap: () {
                                                          FocusManager.instance.primaryFocus?.unfocus();
                                                          selectedRegion = countriesList[index];
                                                          //print(selectedRegion);
                                                          countrySearch.clear();
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text(
                                                          countriesList[index]['name'],
                                                          style: AppStyles.getRegularTextStyle(fontSize: 16),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  );
                                },
                              ).then((value) => setState(() {}));
                            },
                            child: Container(
                              width: size.width,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(width: 1, color: AppColors.evenFadedText),
                              ),
                              child: Text(selectedRegion.isEmpty ? 'Select region' : selectedRegion['name'],
                                  style: AppStyles.getLightTextStyle(fontSize: 14, color: AppColors.fadedText)),
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 10),
                    CheckboxListTile.adaptive(
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      hoverColor: Colors.transparent,
                      visualDensity: VisualDensity.comfortable,
                      activeColor: AppColors.primaryColor,
                      checkColor: Colors.white,
                      value: isDefaultShipping,
                      onChanged: (bool? value) {
                        isDefaultShipping = !isDefaultShipping;
                        setState(() {});
                      },
                      title: Text('This is default Shipping Address', style: AppStyles.getRegularTextStyle(fontSize: 14, color: AppColors.fadedText)),
                    ),
                    CheckboxListTile.adaptive(
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      hoverColor: Colors.transparent,
                      activeColor: AppColors.primaryColor,
                      visualDensity: VisualDensity.comfortable,
                      checkColor: Colors.white,
                      value: isDefaultBilling,
                      onChanged: (bool? value) {
                        isDefaultBilling = !isDefaultBilling;
                        setState(() {});
                      },
                      title: Text('This is default Billing Address', style: AppStyles.getRegularTextStyle(fontSize: 15, color: AppColors.fadedText)),
                    ),
                    const SizedBox(height: 10),
                    Mutation(
                      options: MutationOptions(
                        document: addressModel != null ? CustomerApis.updateCustomerAddress : gql(CustomerApis.createCustomerAddress),
                        onCompleted: (data) {
                          print(data);
                          Navigator.pop(context);
                          userData.getUserData(context);
                          showSnackBar(
                            context: context,
                            message: addressModel != null ? "Address updated Successfully" : "Address added sucessfully",
                            backgroundColor: AppColors.snackbarSuccessBackgroundColor,
                          );
                        },
                        onError: (error) {
                          print(error);
                          showSnackBar(
                            context: context,
                            message: error?.graphqlErrors.first.message ?? error!.linkException!.originalException.toString(),
                            backgroundColor: AppColors.snackbarErrorBackgroundColor,
                          );
                        },
                      ),
                      builder: (RunMutation runMutation, QueryResult? result) {
                        if (result!.isLoading) {
                          return Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.primaryColor,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                          );
                        }
                        return SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                            onPressed: () {
                              final formState = formKey.currentState;
                              List addressList = [];
                              log('message');
                              if (appartNo.text.isNotEmpty) {
                                addressList.add(appartNo.text);
                              }
                              if (street.text.isNotEmpty) {
                                addressList.add(street.text);
                              }
                              if (formState!.validate()) {
                                var addressMap = {
                                  'firstname': fName.text,
                                  'lastname': lName.text,
                                  'street': addressList,
                                  'city': city.text,
                                  'postcode': pin.text,
                                  'telephone': contact.text,
                                  'default_shipping': isDefaultShipping,
                                  'default_billing': isDefaultBilling,
                                };
                                print(addressMap);
                                if (addressModel != null) {
                                  var data = {
                                    "addressId": addressModel.id,
                                    "input": addressMap,
                                  };
                                  runMutation(data);
                                } else {
                                  runMutation(addressMap);
                                }
                              }
                            },
                            child: Text(
                              'SUBMIT',
                              style: AppStyles.getSemiBoldTextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  static getCountryList(Map<String, dynamic> countries, searchQuery) {
    List region = [];
    for (int i = 0; i < countries['countries'].length; i++) {
      if (countries['countries'][i]['full_name_english'].toLowerCase().contains(searchQuery.toLowerCase())) {
        region.add(countries['countries'][i]);
      }
    }
    return region;
  }

  static getRegionList(Map<String, dynamic> regions, searchQuery) {
    List region = [];
    if (regions['country']?['available_regions'] != null) {
      for (int i = 0; i < regions['country']['available_regions'].length; i++) {
        if (regions['country']['available_regions'][i]['name'].toLowerCase().contains(searchQuery.toLowerCase())) {
          region.add(regions['country']['available_regions'][i]);
        }
      }
    }

    return region;
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }
}
