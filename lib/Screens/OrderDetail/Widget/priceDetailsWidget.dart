import 'package:flutter/material.dart';
import '../../../Helper/color.dart';
import '../../../Model/order_model.dart';
import '../../../Widget/desing.dart';
import '../../../Widget/translateVariable.dart';
import '../../../Widget/validation.dart';

class PriceDetails extends StatelessWidget {
  Order_Model model;
  PriceDetails({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          0,
          15.0,
          0,
          15.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 15.0,
              ),
              child: Text(
                getTranslated(context, PRICE_DETAIL)!,
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color: fontColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const Divider(
              color: lightBlack,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getTranslated(context, PRICE_LBL)! + " :",
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: lightBlack2,
                        ),
                  ),
                  Text(
                    "${DesignConfiguration.getPriceFormat(context, double.parse(model.subTotal!))!}",
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: lightBlack2,
                        ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getTranslated(context, DELIVERY_CHARGE_LBL)! + " :",
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: lightBlack2,
                        ),
                  ),
                  Text(
                    "+ ${DesignConfiguration.getPriceFormat(
                      context,
                      double.parse(model.delCharge!),
                    )!}",
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: lightBlack2,
                        ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 15.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getTranslated(context, TAXPER)! + " (${model.taxPer!}) :",
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: lightBlack2,
                        ),
                  ),
                  Text(
                    "+ ${DesignConfiguration.getPriceFormat(context, double.parse(model.taxAmt!))!}",
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: lightBlack2,
                        ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 15.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getTranslated(context, PROMO_CODE_DIS_LBL)! + " :",
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: lightBlack2,
                        ),
                  ),
                  Text(
                    "- ${DesignConfiguration.getPriceFormat(context, double.parse(model.promoDis!))!}",
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: lightBlack2,
                        ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getTranslated(context, WALLET_BAL)! + " :",
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: lightBlack2,
                        ),
                  ),
                  Text(
                    "- ${DesignConfiguration.getPriceFormat(context, double.parse(model.walBal!))!}",
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: lightBlack2,
                        ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 15.0,
                top: 5.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getTranslated(context, TOTAL_PRICE)! + " :",
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: lightBlack2,
                        ),
                  ),
                  Text(
                    "${DesignConfiguration.getPriceFormat(context, double.parse(model.total!))!}",
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: lightBlack2,
                        ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getTranslated(context, PAYABLE)! + ": ",
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: lightBlack,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    "${DesignConfiguration.getPriceFormat(context, double.parse(model.payable!))!}",
                    style: Theme.of(context).textTheme.button!.copyWith(
                          color: lightBlack,
                          fontWeight: FontWeight.bold,
                        ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
