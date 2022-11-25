import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../Helper/color.dart';
import '../../../Model/cash_collection_model.dart';
import '../../../Widget/desing.dart';
import '../../../Widget/translateVariable.dart';
import '../../../Widget/validation.dart';
import '../../OrderDetail/order_detail.dart';
import '../cash_collection.dart';

class OrderItem extends StatelessWidget {
  int index;
  OrderItem({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CashColl_Model model = cashCollectionProvider!.cashList[index];

    Color back;
    if (model.type == "Collected") {
      back = Colors.green;
    } else {
      back = pink;
    }
    return Column(
      children: [
        InkWell(
          child: Card(
            elevation: 0,
            margin: const EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          getTranslated(context, AMT_LBL)! +
                              " : " +
                              DesignConfiguration.getPriceFormat(
                                context,
                                double.parse(
                                  model.amount!,
                                ),
                              )!,
                          style: const TextStyle(
                            color: fontColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(model.date!),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (model.orderId! != "" && model.orderId! != "")
                          Text(
                            getTranslated(context, ORDER_ID_LBL)! +
                                " : " +
                                model.orderId!,
                          )
                        else
                          Text(
                            getTranslated(context, ID_LBL)! + " : " + model.id!,
                          ),
                        const Spacer(),
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                              color: back,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0))),
                          child: Text(
                            StringValidation.capitalize(model.type!),
                            style: const TextStyle(color: white),
                          ),
                        )
                      ],
                    ),
                    Text(
                      getTranslated(context, MSG_LBL)! + " : " + model.message!,
                    ),
                  ],
                ),
              ),
            ),
          ),
          onTap: () async {
            if (cashCollectionProvider!.cashList[index].orderId != "" &&
                cashCollectionProvider!.cashList[index].orderId != "") {
              await Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => OrderDetail(
                    model: cashCollectionProvider!.cashList[index].orderDetails,
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
