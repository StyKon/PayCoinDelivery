import 'package:deliveryboy_multivendor/Screens/CashCollection/Widget/getDialogs.dart';
import 'package:flutter/material.dart';
import '../../../Helper/color.dart';
import '../../../Widget/desing.dart';

getAppBar(
  String title,
  BuildContext context,
  Function update,
) {
  return AppBar(
    leading: Builder(
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.all(10),
          decoration: DesignConfiguration.shadow(),
          child: Card(
            elevation: 0,
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () => Navigator.of(context).pop(),
              child: const Center(
                child: Icon(
                  Icons.keyboard_arrow_left,
                  color: primary,
                ),
              ),
            ),
          ),
        );
      },
    ),
    title: Text(
      title,
      style: const TextStyle(
        color: fontColor,
      ),
    ),
    backgroundColor: white,
    actions: [
      Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: DesignConfiguration.shadow(),
        child: Card(
          elevation: 0,
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: () {
              return GetDialogs.orderSortDialog(context, update);
            },
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(
                Icons.swap_vert,
                color: primary,
                size: 22,
              ),
            ),
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: DesignConfiguration.shadow(),
        child: Card(
          elevation: 0,
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: () {
              return GetDialogs.filterDialog(context, update);
            },
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(
                Icons.tune,
                color: primary,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
