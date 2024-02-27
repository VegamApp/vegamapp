import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/services/api_services/customer_apis.dart';
import 'package:m2/services/models/user.dart';
import 'package:m2/utilities/utilities.dart';

class BuildAddressContainer extends StatefulWidget {
  const BuildAddressContainer({super.key, required this.addressModel, required this.size, this.fromCart = false, this.onRemove, this.onEdit});
  final Addresses addressModel;
  final Size size;
  final bool fromCart;
  final Future<void> Function()? onEdit;
  final void Function()? onRemove;
  @override
  State<BuildAddressContainer> createState() => _BuildAddressContainerState();
}

class _BuildAddressContainerState extends State<BuildAddressContainer> {
  late Addresses addressModel;
  @override
  void initState() {
    super.initState();
    addressModel = widget.addressModel;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400, minHeight: 250),
      // height: 320,
      decoration: BoxDecoration(
        color: const Color(0xffffffff),
        borderRadius: BorderRadius.circular(widget.size.width * .025 > 20 ? 20 : widget.size.width * 0.025),
        border: Border.all(width: 1.0, color: const Color(0xffa0dcd6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0a000000),
            offset: Offset(0, 10),
            blurRadius: 40,
          ),
        ],
      ),
      padding: EdgeInsets.all(widget.size.width * 0.05 > 30 ? 30 : widget.size.width * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${addressModel.firstname} ${addressModel.lastname}', style: AppStyles.getSemiBoldTextStyle(fontSize: 16, color: AppColors.fadedText)),
          if (addressModel.street != null) const SizedBox(height: 10),
          if (addressModel.street != null)
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: addressModel.street!.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) => Text(addressModel.street![index], style: AppStyles.getRegularTextStyle(fontSize: 16, color: AppColors.fadedText)),
            ),
          const SizedBox(height: 10),
          // Text(addressModel.addressType == AddressType.office ? "Office" : 'Home',
          //     style: AppStyles.getRegularTextStyle(fontSize: 16, color: AppColors.fadedText)),
          const SizedBox(height: 10),
          Text('Mob: ${addressModel.telephone}', style: AppStyles.getRegularTextStyle(fontSize: 16, color: AppColors.fadedText)),
          const SizedBox(height: 10),
          Text('PIN: ${addressModel.postcode}', style: AppStyles.getRegularTextStyle(fontSize: 16, color: AppColors.fadedText)),
          if (!widget.fromCart) ...[
            const SizedBox(height: 20),
            Divider(height: 1, color: AppColors.evenFadedText),
            const SizedBox(height: 10),
            SizedBox(
              width: widget.size.width * 0.9,
              child: Wrap(
                runAlignment: WrapAlignment.spaceBetween,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      fixedSize: const Size(80, 20),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: widget.onEdit,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(FontAwesomeIcons.penToSquare, color: AppColors.buttonColor, size: 20),
                        Text('Edit', style: AppStyles.getRegularTextStyle(fontSize: 16, color: AppColors.fadedText))
                      ],
                    ),
                  ),
                  Mutation(
                      options: MutationOptions(
                        document: CustomerApis.deleteCustomerAddress,
                        onCompleted: (data) {
                          print(data);
                          if (data?['deleteCustomerAddress'] == true) {
                            showSnackBar(context: context, message: "Address deleted!", backgroundColor: AppColors.snackbarSuccessBackgroundColor);
                          }
                          if (widget.onRemove != null) {
                            widget.onRemove!();
                          }
                        },
                        onError: (error) {
                          print(error);
                        },
                      ),
                      builder: (rm, mresult) {
                        return TextButton(
                          style: TextButton.styleFrom(
                            fixedSize: const Size(110, 20),
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () => showDeleteDialog(context, type: "address", onDelete: () {
                            context.pop();
                            return rm({"id": addressModel.id});
                          }),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(FontAwesomeIcons.xmark, color: Colors.red, size: 20),
                              Text('Remove', style: AppStyles.getRegularTextStyle(fontSize: 16, color: AppColors.fadedText))
                            ],
                          ),
                        );
                      })
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
