import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Helper/color.dart';
import '../../../Model/order_model.dart';
import '../../../Widget/desing.dart';
import '../../../Widget/parameterString.dart';
import '../../../Widget/translateVariable.dart';
import '../../../Widget/validation.dart';
import '../../OrderDetail/order_detail.dart';
import '../home.dart';

class OrderIteam extends StatelessWidget {
  int index;
  Function update;
  OrderIteam({
    Key? key,
    required this.index,
    required this.update,
  }) : super(key: key);

  _launchCaller(index) async {
    var url = "tel:${homeProvider!.orderList[index].mobile}";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    Order_Model model = homeProvider!.orderList[index];
    Color back;

    if ((model.itemList![0].status!) == DELIVERD)
      back = Colors.green;
    else if ((model.itemList![0].status!) == SHIPED)
      back = Colors.orange;
    else if ((model.itemList![0].status!) == CANCLED ||
        model.itemList![0].status! == RETURNED)
      back = Colors.red;
    else if ((model.itemList![0].status!) == PROCESSED)
      back = Colors.indigo;
    else if (model.itemList![0].status! == WAITING)
      back = Colors.black;
    else
      back = Colors.cyan;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(5.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(getTranslated(context, OrderNo)! + ".${model.id!}"),
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
                        () {
                          if (model.itemList![0].status! == "delivered") {
                            return getTranslated(context, "delivered")!;
                          } else if (model.itemList![0].status! ==
                              "cancelled") {
                            return getTranslated(context, "cancelled")!;
                          } else if (model.itemList![0].status! == "returned") {
                            return getTranslated(context, "returned")!;
                          } else if (model.itemList![0].status! ==
                              "processed") {
                            return getTranslated(context, "processed")!;
                          } else if (model.itemList![0].status! == "shipped") {
                            return getTranslated(context, "shipped")!;
                          } else if (model.itemList![0].status! == "received") {
                            return getTranslated(context, "received")!;
                          } else {
                            return StringValidation.capitalize(
                                model.itemList![0].status!);
                          }
                        }(),
                        style: const TextStyle(color: white),
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Row(
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          const Icon(Icons.person_outline, size: 14),
                          Expanded(
                            child: Text(
                              model.name!.isNotEmpty
                                  ? " ${StringValidation.capitalize(model.name!)}"
                                  : " ",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.call_outlined,
                            size: 14,
                            color: fontColor,
                          ),
                          Text(
                            " ${model.mobile!}",
                            style: const TextStyle(
                              color: fontColor,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        _launchCaller(index);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Row(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.money_outlined,
                          size: 14,
                        ),
                        Text(" " +
                            getTranslated(context, PAYABLE)! +
                            " : ${DesignConfiguration.getPriceFormat(
                              context,
                              double.parse(model.payable!),
                            )!}"),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.payment_outlined,
                          size: 14,
                        ),
                        Text(" ${model.payMethod!}"),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Row(
                  children: [
                    const Icon(Icons.date_range_outlined, size: 14),
                    Text(
                      " " +
                          getTranslated(context, OrderNo)! +
                          ": ${model.orderDate!}",
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        onTap: () async {
          await Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => OrderDetail(
                model: homeProvider!.orderList[index],
              ),
            ),
          );
          homeProvider!.getUserDetail(update, context);
          update();
        },
      ),
    );
  }
}
