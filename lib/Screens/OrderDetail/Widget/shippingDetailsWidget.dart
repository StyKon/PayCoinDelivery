import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Helper/color.dart';
import '../../../Model/order_model.dart';
import '../../../Widget/setSnackbar.dart';
import '../../../Widget/translateVariable.dart';
import '../../../Widget/validation.dart';

class ShippingDetails extends StatelessWidget {
  Order_Model model;
  ShippingDetails({
    Key? key,
    required this.model,
  }) : super(key: key);

  void _launchCaller(
    String phoneNumber,
    BuildContext context,
  ) async {
    var url = "tel:$phoneNumber";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      setSnackbar('Could not launch $url', context);
      throw 'Could not launch $url';
    }
  }

  _launchMap(lat, lng) async {
    var url = '';
    if (Platform.isAndroid) {
      url =
          "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving&dir_action=navigate";
    } else {
      url =
          "http://maps.apple.com/?saddr=&daddr=$lat,$lng&directionsmode=driving&dir_action=navigate";
    }
    await launchUrl(Uri.parse(url));
  }

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
              child: Row(
                children: [
                  Text(
                    getTranslated(context, SHIPPING_DETAIL)!,
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          color: fontColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  model.latitude != "" && model.longitude != ""
                      ? Container(
                          height: 30,
                          child: IconButton(
                            icon: const Icon(
                              Icons.location_on,
                              color: fontColor,
                            ),
                            onPressed: () {
                              _launchMap(
                                model.latitude,
                                model.longitude,
                              );
                            },
                          ),
                        )
                      : Container()
                ],
              ),
            ),
            const Divider(
              color: lightBlack,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Text(
                model.name!.isNotEmpty
                    ? " ${StringValidation.capitalize(model.orderRecipientName!)}"
                    : " ",
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 3,
              ),
              child: Text(
                StringValidation.capitalize(
                  model.address!,
                ),
                style: const TextStyle(
                  color: lightBlack2,
                ),
              ),
            ),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 5,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.call,
                      size: 15,
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
              ),
              onTap: () {
                _launchCaller(model.mobile!, context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
