import 'package:flutter/material.dart';
import '../../../Helper/color.dart';
import '../../../Widget/desing.dart';
import '../../../Widget/translateVariable.dart';
import '../../../Widget/validation.dart';
import '../cash_collection.dart';

class GetCardValue extends StatelessWidget {
  const GetCardValue({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: fontColor,
                ),
                Text(
                  " " + getTranslated(context, TOTAL_AMT)!,
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: fontColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            cashCollectionProvider!.cashList.isNotEmpty
                ? Text(
                    DesignConfiguration.getPriceFormat(
                        context,
                        double.parse(cashCollectionProvider!
                            .cashList[0].cashReceived!))!,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: fontColor,
                          fontWeight: FontWeight.bold,
                        ),
                  )
                : Text(
                    DesignConfiguration.getPriceFormat(
                        context, double.parse(" 0"))!,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: fontColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
          ],
        ),
      ),
    );
  }
}
