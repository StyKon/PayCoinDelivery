import 'package:flutter/material.dart';
import '../../../Helper/color.dart';
import '../../../Widget/translateVariable.dart';
import '../../../Widget/validation.dart';
import '../home.dart';

class FilterDialog {
  static void filterDialog(
    BuildContext context,
    Function update,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ButtonBarTheme(
          data: const ButtonBarThemeData(
            alignment: MainAxisAlignment.center,
          ),
          child: AlertDialog(
            elevation: 2.0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  5.0,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.all(0.0),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.only(top: 19.0, bottom: 16.0),
                    child: Text(
                      getTranslated(context, FILTER_BY)!,
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: fontColor),
                    ),
                  ),
                  Divider(color: lightBlack),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: getStatusList(context, update),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static List<Widget> getStatusList(
    BuildContext context,
    Function update,
  ) {
    return homeProvider!.statusList
        .asMap()
        .map(
          (index, element) => MapEntry(
            index,
            Column(
              children: [
                Container(
                  width: double.maxFinite,
                  child: TextButton(
                    child: Text(
                      StringValidation.capitalize(
                        homeProvider!.statusList[index],
                      ),
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: lightBlack),
                    ),
                    onPressed: () {
                      homeProvider!.activeStatus =
                          index == 0 ? "" : homeProvider!.statusList[index];
                      homeProvider!.isLoadingmore = true;
                      homeProvider!.offset = 0;
                      homeProvider!.isLoadingItems = true;
                      update();

                      homeProvider!.getOrder(update, context);

                      Navigator.pop(context, 'option $index');
                    },
                  ),
                ),
                const Divider(
                  color: lightBlack,
                  height: 1,
                ),
              ],
            ),
          ),
        )
        .values
        .toList();
  }
}
