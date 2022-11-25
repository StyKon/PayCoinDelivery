import 'package:flutter/material.dart';
import '../../../Helper/color.dart';
import '../../../Widget/desing.dart';
import '../../../Widget/parameterString.dart';
import '../../../Widget/translateVariable.dart';
import '../../../Widget/validation.dart';
import '../home.dart';

class DetailHeader extends StatelessWidget {
  const DetailHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    color: fontColor,
                  ),
                  Text(
                    getTranslated(context, ORDER)!,
                  ),
                  Text(
                    homeProvider!.total.toString(),
                    style: const TextStyle(
                      color: fontColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: fontColor,
                  ),
                  Text(
                    getTranslated(context, BAL_LBL)!,
                  ),
                  Text(
                    DesignConfiguration.getPriceFormat(
                        context, double.parse(CUR_BALANCE))!,
                    style: const TextStyle(
                      color: fontColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  const Icon(
                    Icons.wallet_giftcard_outlined,
                    color: fontColor,
                  ),
                  Text(
                    getTranslated(context, BONUS_LBL)!,
                  ),
                  Text(
                    CUR_BONUS!,
                    style: const TextStyle(
                      color: fontColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
