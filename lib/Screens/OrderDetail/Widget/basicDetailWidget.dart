import 'package:flutter/material.dart';
import '../../../Helper/color.dart';
import '../../../Model/order_model.dart';
import '../../../Widget/translateVariable.dart';
import '../../../Widget/validation.dart';

class BasicDetail extends StatelessWidget {
  Order_Model model;
  BasicDetail({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  getTranslated(context, ORDER_ID_LBL)! + " - ${model.id!}",
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: lightBlack2,
                      ),
                ),
                Text(
                  model.orderDate!,
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: lightBlack2,
                      ),
                ),
              ],
            ),
            Text(
              getTranslated(context, PAYMENT_MTHD)! + " - ${model.payMethod!}",
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    color: lightBlack2,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
