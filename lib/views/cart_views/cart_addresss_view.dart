import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/services/api_services/api_services.dart';
import 'package:m2/services/api_services/cart_apis.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/services/models/user.dart';
import 'package:m2/services/state_management/cart/cart_data.dart';
import 'package:m2/services/state_management/token/token.dart';
import 'package:m2/services/state_management/user/user_data.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/widgets.dart';
import 'package:m2/views/account_view/address_view.dart';
import 'package:m2/views/cart_views/cart_payment.dart';
import 'package:m2/views/cart_views/cart_view.dart';
import 'package:provider/provider.dart';

class CartAddressView extends StatefulWidget {
  const CartAddressView({super.key});
  static String route = 'cartaddress';

  @override
  State<CartAddressView> createState() => _CartAddressViewState();
}

class _CartAddressViewState extends State<CartAddressView> {
  ScrollController scrollController = ScrollController();

  bool isDefaultShipping = false;
  bool isDefaultBilling = false;
  bool saveAddress = false;
  // For new addresses
  // For test
  // TextEditingController name = TextEditingController(text: "Jack");
  // TextEditingController email = TextEditingController();
  // TextEditingController state = TextEditingController();
  // TextEditingController lName = TextEditingController(text: "Reacher");
  // TextEditingController appartNo = TextEditingController(text: 'Appr');
  // TextEditingController street = TextEditingController(text: "Str");
  // TextEditingController address = TextEditingController(text: "Address");
  // TextEditingController city = TextEditingController(text: "City");
  // TextEditingController contact = TextEditingController(text: "1231231231");
  // TextEditingController pin = TextEditingController(text: "682025");

  //Default
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController appartNo = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController pin = TextEditingController();
  TextEditingController state = TextEditingController();
  // AddressType _addressType = AddressType.office;

  Map selectedCountry = {'id': "IN", 'full_name_english': 'India'};
  Map<String, dynamic> selectedRegion = {"__typename": "Region", "id": 586, "code": "KL", "name": "Kerala"};

  Map<String, dynamic> countries = {};
  Map<String, dynamic> regions = {};

  final _formKey = GlobalKey<FormState>();
  bool? newAddress;

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();

    name.dispose();
    email.dispose();
    lName.dispose();
    appartNo.dispose();
    street.dispose();
    address.dispose();
    city.dispose();
    contact.dispose();
    pin.dispose();
    state.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BuildScaffold(
      child: LayoutBuilder(
        builder: (context, constraints) {
          var cartData = Provider.of<CartData>(context);
          var token = Provider.of<AuthToken>(context);
          var user = Provider.of<UserData>(context);

          if (cartData.cartData.isEmpty) {
            return BuildErrorWidget(
              errorMsg: 'An error occured, please try again.',
              onRefresh: () => cartData.getCartData(context, token),
            );
          }
          if (newAddress == null) {
            newAddress = user.data.addresses == null || user.data.addresses!.isEmpty;
            if (newAddress!) {
              newAddress = cartData.cartData['cart']['shipping_addresses'].isEmpty;
            }
          }
          print(((token.loginToken == null && cartData.cartData['cart']['shipping_addresses'].isEmpty) ||
              ((user.data.addresses == null || user.data.addresses!.isEmpty) && cartData.cartData['cart']['shipping_addresses'].isEmpty) ||
              newAddress!));
          return WillPopScope(
            onWillPop: () async {
              if (newAddress! && (user.data.addresses != null || user.data.addresses!.isNotEmpty)) {
                setState(() {
                  newAddress = false;
                });
                return false;
              }
              return true;
            },
            child: Form(
              key: _formKey,
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth > 1400 ? (constraints.maxWidth - 1400) / 2 : 20, vertical: 20),
                children: [
                  // const SizedBox(height: 20),
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  //     width: AppResponsive.isDesktop(context) ? constraints.maxWidth - 430 : constraints.maxWidth,
                  //     decoration: AppResponsive.isDesktop(context)
                  //         ? BoxDecoration(
                  //             color: AppColors.shadowColor,
                  //             borderRadius: BorderRadius.circular(30),
                  //           )
                  //         : null,
                  //     child: const BuildCartSteps(currentCartIndex: 1),
                  //   ),
                  // ),
                  // const SizedBox(height: 20),
                  AppResponsive(
                    mobile: Column(
                      children: [
                        ((token.loginToken == null && cartData.cartData['cart']['shipping_addresses'].isEmpty) ||
                                ((user.data.addresses == null || user.data.addresses!.isEmpty) && cartData.cartData['cart']['shipping_addresses'].isEmpty) ||
                                newAddress!)
                            ? Column(
                                children: [
                                  getAddressForm1(const BoxConstraints.expand(), token),
                                  const SizedBox(height: 20),
                                  getAddressForm2(const BoxConstraints.expand(), size, token, cartData),
                                ],
                              )
                            : getExistingAddress(user, size, token, cartData),
                        const SizedBox(height: 20),
                        // CartSummaryWidget(
                        //   buttonText: "Go to Checkout",
                        //   refetch: () => cartData.getCartData(context, token),
                        //   onButtonTap: () {
                        //     context.push("/${CartView.route}/${CartPayment.route}");
                        //   },
                        // ),
                      ],
                    ),
                    desktop: SizedBox(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 75,
                            // child: getBody(size, cartData, result, refetch),
                            child: ((token.loginToken == null && cartData.cartData['cart']['shipping_addresses'].isEmpty) ||
                                    ((user.data.addresses == null || user.data.addresses!.isEmpty) && cartData.cartData['cart']['shipping_addresses'].isEmpty) ||
                                    newAddress!)
                                ? Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 20,
                                    runSpacing: 20,
                                    children: [
                                      getAddressForm1(constraints, token),
                                      getAddressForm2(constraints, size, token, cartData),
                                    ],
                                  )
                                : getExistingAddress(user, size, token, cartData),
                          ),
                          const SizedBox(width: 20),
                          // ConstrainedBox(
                          //   constraints: const BoxConstraints(maxWidth: 350),
                          //   child: CartSummaryWidget(
                          //     refetch: () => cartData.getCartData(context, token),
                          //     buttonText: "Go to Checkout",
                          //     onButtonTap: () {
                          //       // log(jsonEncode(cartData.cartData));
                          //       if (cartData.cartData['shipping_addresses'] == null || cartData.cartData['shipping_addresses'].isEmpty) {
                          //         showSnackBar(context: context, message: "Please add an address", backgroundColor: Colors.red);
                          //         return;
                          //       }
                          //       context.push("/${CartView.route}/${CartPayment.route}");
                          //     },
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  getAddressForm1(BoxConstraints constraints, AuthToken authToken) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: constraints.maxWidth < 800 ? constraints.maxWidth * 0.4 : 450),
      child: Column(
        children: [
          BuildTextField(
            controller: name,
            hint: 'Name',
            validator: (value) => value != null && value != '' ? null : 'Enter a valid name',
          ),
          const SizedBox(height: 20),
          BuildTextField(
            controller: lName,
            hint: 'Last Name',
            validator: (value) => value != null && value != '' ? null : 'Enter a valid name',
          ),
          const SizedBox(height: 20),
          if (authToken.loginToken == null) ...[
            BuildTextField(
              controller: email,
              hint: 'Email',
              validator: validateEmail,
            ),
            const SizedBox(height: 20),
          ],
          BuildTextField(
            controller: appartNo,
            hint: 'Apartment Number',
            validator: (value) => value != null && value != '' ? null : 'Enter a valid appartment number',
          ),
          const SizedBox(height: 20),
          BuildTextField(
            controller: street,
            hint: 'Street',
            validator: (value) => value != null && value != '' ? null : 'Enter a valid street name',
          ),
          const SizedBox(height: 20),
          BuildTextField(
            controller: address,
            hint: 'Adrress',
            maxLines: authToken.loginToken != null ? 10 : 7,
            padding: const EdgeInsets.all(20),
          ),
        ],
      ),
    );
  }

  getAddressForm2(BoxConstraints constraints, Size size, AuthToken authToken, CartData cartData) {
    TextEditingController countrySearch = TextEditingController();
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: constraints.maxWidth < 800 ? constraints.maxWidth * 0.4 : 450),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BuildTextField(
            controller: city,
            hint: 'City',
            validator: (value) => value != null && value != '' ? null : 'Enter a valid city',
          ),
          const SizedBox(height: 20),
          BuildTextField(
            controller: contact,
            hint: 'Contact Number',
            validator: (value) => value != null && value != '' ? null : 'Enter a valid contact number',
          ),
          const SizedBox(height: 20),
          BuildTextField(
            controller: pin,
            hint: 'PIN Code',
            validator: (value) => value != null && value != '' ? null : 'Enter a valid PIN code',
          ),
          const SizedBox(height: 20),
          Query(
            options: QueryOptions(document: gql(ApiServices.getCountries)),
            builder: (result, {fetchMore, refetch}) {
              // if (result.isLoading) {
              //   return Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.primaryColor)));
              // }
              if (result.isLoading) {
                return Container(
                  width: size.width,
                  padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 1, color: AppColors.evenFadedText),
                  ),
                  child: Text(selectedCountry.isEmpty ? 'Select country' : selectedCountry['full_name_english'],
                      style: AppStyles.getLightTextStyle(fontSize: 13, color: AppColors.fadedText)),
                );
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
                                      itemCount: getCountryList(countrySearch.text).length,
                                      separatorBuilder: (context, index) => const SizedBox(height: 20),
                                      itemBuilder: (context, index) {
                                        List countries = getCountryList(countrySearch.text);
                                        return InkWell(
                                          onTap: () {
                                            selectedCountry = countries[index];
                                            //print(selectedCountry);
                                            FocusManager.instance.primaryFocus?.unfocus();
                                            countrySearch.clear();
                                            Navigator.pop(context);
                                            setState(() {});
                                          },
                                          child: Text(
                                            countries[index]['full_name_english'],
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
                  padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 1, color: AppColors.evenFadedText),
                  ),
                  child: Text(selectedCountry.isEmpty ? 'Select country' : selectedCountry['full_name_english'],
                      style: AppStyles.getLightTextStyle(fontSize: 13, color: AppColors.fadedText)),
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
                                          itemCount: getRegionList(countrySearch.text).length,
                                          separatorBuilder: (context, index) => const SizedBox(height: 20),
                                          itemBuilder: (context, index) {
                                            List countries = getRegionList(countrySearch.text);
                                            return InkWell(
                                              onTap: () {
                                                FocusManager.instance.primaryFocus?.unfocus();
                                                selectedRegion = countries[index];
                                                print(selectedRegion);
                                                countrySearch.clear();
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                countries[index]['name'],
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
                    padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 1, color: AppColors.evenFadedText),
                    ),
                    child: Text(selectedRegion.isEmpty ? 'Select region' : selectedRegion['name'], style: AppStyles.getLightTextStyle(fontSize: 13, color: AppColors.fadedText)),
                  ),
                );
              },
            ),
          const SizedBox(height: 20),
          if (authToken.loginToken != null)
            ListTile(
              contentPadding: EdgeInsets.zero,
              hoverColor: Colors.transparent,
              onTap: () {
                isDefaultShipping = !isDefaultShipping;
                setState(() {});
              },
              leading: Checkbox(
                activeColor: AppColors.primaryColor,
                checkColor: Colors.white,
                value: isDefaultShipping,
                onChanged: (bool? value) {
                  isDefaultShipping = !isDefaultShipping;
                  setState(() {});
                },
              ),
              title: Text('This is default Shipping Address', style: AppStyles.getRegularTextStyle(fontSize: 15, color: AppColors.fadedText)),
            ),
          if (authToken.loginToken != null)
            ListTile(
              contentPadding: EdgeInsets.zero,
              hoverColor: Colors.transparent,
              onTap: () {
                isDefaultBilling = !isDefaultBilling;
                setState(() {});
              },
              leading: Checkbox(
                activeColor: AppColors.primaryColor,
                checkColor: Colors.white,
                value: isDefaultBilling,
                onChanged: (bool? value) {
                  isDefaultBilling = !isDefaultBilling;
                  setState(() {});
                },
              ),
              title: Text('This is default Billing Address', style: AppStyles.getRegularTextStyle(fontSize: 15, color: AppColors.fadedText)),
            ),
          if (authToken.loginToken != null)
            ListTile(
              contentPadding: EdgeInsets.zero,
              hoverColor: Colors.transparent,
              onTap: () {
                saveAddress = !saveAddress;
                setState(() {});
              },
              leading: Checkbox(
                activeColor: AppColors.primaryColor,
                checkColor: Colors.white,
                value: saveAddress,
                onChanged: (bool? value) {
                  saveAddress = !saveAddress;
                  setState(() {});
                },
              ),
              title: Text('Save in address book', style: AppStyles.getRegularTextStyle(fontSize: 15, color: AppColors.fadedText)),
            ),
          if (authToken.loginToken != null) const SizedBox(height: 10),
          Mutation(
            options: MutationOptions(
                document: gql(CartApis.setEmailOnGuestCart),
                onCompleted: (result) {
                  newAddress = false;
                  setState(() {});
                  cartData.getCartData(context, authToken);
                  context.push("/${CartView.route}/${CartPayment.route}");
                },
                onError: (error) {
                  //print(error);
                }),
            builder: (RunMutation runMutationEmail, QueryResult? resultEmail) {
              return Mutation(
                options: MutationOptions(
                    document: gql(CartApis.setBillingAddressesOnCart),
                    onCompleted: (result) {
                      log('billing result :$result');
                      UserData userData = Provider.of<UserData>(context, listen: false);
                      userData.getUserData(context);
                      cartData.getCartData(context, authToken);
                      // navigate(context, const GuestPayment());
                      print('hi');
                      if (authToken.loginToken == null) {
                        runMutationEmail({'cart_id': cartData.cartId, 'email': email.text});
                      } else {
                        context.push("/${CartView.route}/${CartPayment.route}");
                      }
                    },
                    onError: (error) {
                      log('billing error $error');
                    }),
                builder: (RunMutation runMutation, QueryResult? result) {
                  return Mutation(
                      options: MutationOptions(
                          document: gql(CartApis.setShippingAddressesOnCart),
                          onCompleted: (result) {
                            log(result.toString());
                            newAddress = false;
                            setState(() {});
                            List streets = [];
                            if (appartNo.text.isNotEmpty) {
                              streets.add(appartNo.text);
                            }
                            if (street.text.isNotEmpty) {
                              streets.add(street.text);
                            }
                            runMutation({
                              "input": {
                                "cart_id": cartData.cartId,
                                "billing_address": {
                                  "address": {
                                    'city': city.text,
                                    'country_code': selectedCountry['id'],
                                    'firstname': name.text,
                                    'lastname': lName.text,
                                    'postcode': pin.text,
                                    'region': selectedRegion['code'],
                                    'region_id': selectedRegion['id'],
                                    "street": streets,
                                    'telephone': contact.text,
                                    // "landmark": address.text,
                                    // "address_label": "Home",
                                  },
                                }
                              }
                            });
                          },
                          onError: (error) {
                            log('shipping: $error');
                          }),
                      builder: (RunMutation runMutation2, QueryResult? result) {
                        return TextButton(
                          onPressed: () {
                            final FormState? form = _formKey.currentState;
                            List addressList = [];
                            if (appartNo.text != '') addressList.add(appartNo.text);
                            if (street.text != '') addressList.add(street.text);
                            if (address.text != '') addressList.add(address.text);
                            if (form!.validate()) {
                              if (selectedCountry.isNotEmpty && selectedRegion.isNotEmpty) {
                                List streets = [];
                                if (appartNo.text.isNotEmpty) {
                                  streets.add(appartNo.text);
                                }
                                if (street.text.isNotEmpty) {
                                  streets.add(street.text);
                                }

                                var addressMap = {
                                  'city': city.text,
                                  'country_code': selectedCountry['id'],
                                  'firstname': name.text,
                                  'lastname': lName.text,
                                  'postcode': pin.text,
                                  'region': selectedRegion['code'],
                                  'region_id': selectedRegion['id'],
                                  "street": streets,
                                  'telephone': contact.text,
                                  // "landmark": address.text,
                                  // "address_label": "Home",
                                  'save_in_address_book': saveAddress,
                                };
                                print(addressMap);
                                runMutation2({
                                  "input": {
                                    "cart_id": cartData.cartId,
                                    "shipping_addresses": [
                                      {
                                        "address": addressMap,
                                      }
                                    ]
                                  }
                                });
                              } else {
                                showSnackBar(context: context, message: "Please select country and state", backgroundColor: Colors.red);
                              }
                            } else {
                              final node = _formKey.currentContext!.findRenderObject();
                              final offset = node!.getTransformTo(null).getTranslation().y;
                              //print(offset);
                              // listScrollController.animateTo(-offset, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
                            }
                          },
                          style: TextButton.styleFrom(
                            // maximumSize: AppResponsive.isDesktop(context) ? Size(size.width, 50) : null,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            // fixedSize: Size(size.width * 0.9, size.width * 0.075),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            backgroundColor: Colors.black,
                            shadowColor: AppColors.shadowColor,
                          ),
                          child: result!.isLoading || resultEmail!.isLoading
                              ? const Center(child: CircularProgressIndicator(color: Colors.white))
                              : Text('SUBMIT', style: AppStyles.getSemiBoldTextStyle(fontSize: 20, color: Colors.white)),
                        );
                      });
                },
              );
            },
          ),
        ],
      ),
    );
  }

  getExistingAddress(UserData userData, Size size, AuthToken authToken, CartData cartData) {
    return Observer(builder: (_) {
      return Mutation(
        options: MutationOptions(
            document: gql(CartApis.setBillingAddressesOnCart),
            onCompleted: (result) {
              print('complete $result');
              // cartData.getCartData(context, authToken);

              if (result != null) {
                context.push("/${CartView.route}/${CartPayment.route}");
              }
            },
            onError: (error) {
              print('error billing $error');
            }),
        builder: (RunMutation runMutationBilling, QueryResult? billingResult) {
          return Mutation(
            options: MutationOptions(
                document: gql(CartApis.setShippingAddressesOnCart),
                onCompleted: (result) {
                  print(result);
                  //print(user.addresses![index].region!.regionId);

                  runMutationBilling({
                    'input': {
                      'cart_id': cartData.cartId,
                      'billing_address': {'same_as_shipping': true}
                    }
                  });
                  // refetch!();
                },
                onError: (error) {
                  print('error shipping $error');
                }),
            builder: (RunMutation runMutationShipping, QueryResult? shippingResult) {
              if (billingResult!.isLoading || shippingResult!.isLoading) {
                return Container(
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
                  child: Center(child: BuildLoadingWidget(color: AppColors.primaryColor)),
                );
              }
              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  InkWell(
                    onTap: () => setState(() => newAddress = true),
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
                  if (cartData.cartData['cart']?['shipping_addresses'] != null && cartData.cartData['cart']['shipping_addresses'].isNotEmpty)
                    InkWell(
                      onTap: () => context.pushNamed(CartPayment.route),
                      child: BuildAddressContainer(
                        addressModel: Addresses.fromJson(cartData.cartData['cart']['shipping_addresses'][0]),
                        size: size,
                        fromCart: true,
                      ),
                    ),
                  if (userData.addressesList.isNotEmpty)
                    ...userData.addressesList.map(
                      (e) => InkWell(
                        onTap: () {
                          runMutationShipping({
                            "input": {
                              "cart_id": cartData.cartId,
                              "shipping_addresses": [
                                {"customer_address_id": e.id, "customer_notes": ""}
                              ]
                            }
                          });
                        },
                        child: BuildAddressContainer(
                          addressModel: e,
                          size: size,
                          fromCart: true,
                          onEdit: () => AddressViewState.showAddAddressDialog(context, size, userData, addressModel: e).then((value) => userData.getUserData(context)),
                          onRemove: () => userData.getUserData(context),
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      );
    });
  }

  refreshUserAddress() {}

  getCountryList(String text) {
    List region = [];
    for (int i = 0; i < countries['countries'].length; i++) {
      try {
        if (countries['countries'][i]['full_name_english'].toLowerCase().contains(text.toLowerCase())) {
          region.add(countries['countries'][i]);
        }
      } catch (e) {
        print(e);
        print(countries['countries'][i]);
      }
    }
    return region;
  }

  getRegionList(String text) {
    List region = [];
    for (int i = 0; i < regions['country']['available_regions'].length; i++) {
      try {
        if (regions['country']['available_regions'][i]['name'].toLowerCase().contains(text.toLowerCase())) {
          region.add(regions['country']['available_regions'][i]);
        }
      } catch (e) {
        print(e);
        print(regions['country']['available_regions'][i]);
      }
    }

    return region;
  }
}
