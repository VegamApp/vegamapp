import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/services/api_services/api_services.dart';
import 'package:m2/services/app_responsive.dart';
import 'package:m2/services/state_management/cart/cart_data.dart';
import 'package:m2/services/state_management/token/token.dart';
import 'package:m2/utilities/utilities.dart';
import 'package:m2/utilities/widgets/widgets.dart';
import 'package:provider/provider.dart';

class CartAddressView extends StatefulWidget {
  const CartAddressView({super.key});
  static String route = 'address';

  @override
  State<CartAddressView> createState() => _CartAddressViewState();
}

class _CartAddressViewState extends State<CartAddressView> {
  ScrollController scrollController = ScrollController();

  bool isDefaultShipping = false;
  bool isDefaultBilling = false;
  bool regAsUser = false;
  // For new addresses
  TextEditingController name = TextEditingController();
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
  Map<String, dynamic> selectedRegion = {"name": "Kerala", "region_code": "KL", "id": 502, "__typename": "CustomerAddressRegion"};
  Map<String, dynamic> countries = {};
  Map<String, dynamic> regions = {};

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BuildScaffold(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Observer(
            builder: (_) {
              var cartData = Provider.of<CartData>(context);
              var token = Provider.of<AuthToken>(context);

              if (cartData.isLoading) {
                return const BuildLoadingWidget();
              }
              if (cartData.cartData.isEmpty) {
                return BuildErrorWidget(
                  errorMsg: 'An error occured, please try again.',
                  onRefresh: () => cartData.getCartData(context, token),
                );
              }
              return ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                children: [
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      width: AppResponsive.isDesktop(context) ? constraints.maxWidth - 430 : constraints.maxWidth,
                      decoration: AppResponsive.isDesktop(context)
                          ? BoxDecoration(
                              color: AppColors.shadowColor,
                              borderRadius: BorderRadius.circular(30),
                            )
                          : null,
                      child: const BuildCartSteps(currentCartIndex: 1),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AppResponsive(
                    mobile: Column(
                      children: [
                        // getBody(size, cartData, result, refetch),
                        getAddressForm1(const BoxConstraints.expand()),
                        const SizedBox(height: 20),
                        getAddressForm2(const BoxConstraints.expand(), size),
                        const SizedBox(height: 20),
                        CartSummaryWidget(
                          buttonText: "Go to Checkout",
                          onButtonTap: () {
                            // context.go("/${CartView.route}/${CartAddressView.route}");
                          },
                        ),
                      ],
                    ),
                    desktop: SizedBox(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 75,
                            // child: getBody(size, cartData, result, refetch),
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 20,
                              runSpacing: 20,
                              children: [
                                getAddressForm1(constraints),
                                getAddressForm2(constraints, size),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 350),
                            child: CartSummaryWidget(
                              buttonText: "Go to Checkout",
                              onButtonTap: () {
                                // context.go("/${CartView.route}/${CartAddressView.route}");
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  getAddressForm1(BoxConstraints constraints) {
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
          BuildTextField(controller: address, hint: 'Adrress'),
        ],
      ),
    );
  }

  getAddressForm2(BoxConstraints constraints, Size size) {
    TextEditingController countrySearch = TextEditingController();

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: constraints.maxWidth < 800 ? constraints.maxWidth * 0.4 : 450),
      child: Column(
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
                                                //print(selectedRegion);
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
                    child: Text(selectedRegion.isEmpty ? 'Select region' : selectedRegion['name'],
                        style: AppStyles.getLightTextStyle(fontSize: 13, color: AppColors.fadedText)),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

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
