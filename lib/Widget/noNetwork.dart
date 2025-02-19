import 'package:deliveryboy_multivendor/Widget/translateVariable.dart';
import 'package:flutter/material.dart';
import '../Helper/color.dart';
import 'ButtonDesing.dart';
import 'desing.dart';
import 'validation.dart';

Widget noInternet(
  BuildContext context,
  setStateNoInternate,
  Animation<dynamic>? buttonSqueezeanimation,
  AnimationController? buttonController,
) {
  return Center(
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          noIntImage(),
          noIntText(context),
          noIntDec(context),
          AppBtn(
            title: getTranslated(context, "TRY_AGAIN_INT_LBL")!,
            btnAnim: buttonSqueezeanimation,
            btnCntrl: buttonController,
            onBtnSelected: setStateNoInternate,
          )
        ],
      ),
    ),
  );
}

noIntImage() {
  return Image.asset(
    DesignConfiguration.setPngPath('no_internet'),
    fit: BoxFit.contain,
  );
}

noIntText(BuildContext context) {
  return Container(
    child: Text(
      getTranslated(context, NO_INTERNET)!,
      style: Theme.of(context).textTheme.headline5!.copyWith(
            color: primary,
            fontWeight: FontWeight.normal,
          ),
    ),
  );
}

noIntDec(BuildContext context) {
  return Container(
    padding: const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
    child: Text(
      getTranslated(context, NO_INTERNET_DISC)!,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline6!.copyWith(
            color: lightBlack2,
            fontWeight: FontWeight.normal,
          ),
    ),
  );
}
