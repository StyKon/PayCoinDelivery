import 'dart:async';
import 'package:deliveryboy_multivendor/Helper/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/cashCollectionProvider.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/noNetwork.dart';
import '../../Widget/parameterString.dart';
import '../../Widget/simmerEffect.dart';
import '../../Widget/translateVariable.dart';
import '../../Widget/validation.dart';
import 'Widget/getAppBar.dart';
import 'Widget/getCardValue.dart';
import 'Widget/orderIteamWidget.dart';

class CashCollection extends StatefulWidget {
  const CashCollection({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StateCash();
  }
}

CashCollectionProvider? cashCollectionProvider;

class StateCash extends State<CashCollection> with TickerProviderStateMixin {
  setStateNow() {
    setState(() {});
  }

  @override
  void initState() {
    cashCollectionProvider =
        Provider.of<CashCollectionProvider>(context, listen: false);
    cashCollectionProvider!.initalizeVaribleValues();
    cashCollectionProvider!.offset = 0;
    cashCollectionProvider!.total = 0;
    cashCollectionProvider!.cashList.clear();
    cashCollectionProvider!.getOrder(
      "admin",
      "DESC",
      setStateNow,
      context,
    );
    cashCollectionProvider!.buttonController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    cashCollectionProvider!.buttonSqueezeanimation = Tween(
      begin: deviceWidth! * 0.7,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: cashCollectionProvider!.buttonController!,
        curve: const Interval(
          0.0,
          0.150,
        ),
      ),
    );
    cashCollectionProvider!.controller.addListener(_scrollListener);
    cashCollectionProvider!.controllerText.addListener(
      () {
        if (cashCollectionProvider!.controllerText.text.isEmpty) {
          if (mounted) {
            setState(
              () {
                cashCollectionProvider!.searchText = "";
              },
            );
          }
        } else {
          if (mounted) {
            setState(
              () {
                cashCollectionProvider!.searchText =
                    cashCollectionProvider!.controllerText.text;
              },
            );
          }
        }

        if (cashCollectionProvider!.lastsearch !=
                cashCollectionProvider!.searchText &&
            ((cashCollectionProvider!.searchText.length > 2) ||
                (cashCollectionProvider!.searchText == ""))) {
          cashCollectionProvider!.lastsearch =
              cashCollectionProvider!.searchText;
          cashCollectionProvider!.isLoadingmore = true;
          cashCollectionProvider!.offset = 0;
          cashCollectionProvider!.getOrder(
            "delivery",
            "DESC",
            setStateNow,
            context,
          );
        }
      },
    );
    super.initState();
  }

  _scrollListener() {
    if (cashCollectionProvider!.controller.offset >=
            cashCollectionProvider!.controller.position.maxScrollExtent &&
        !cashCollectionProvider!.controller.position.outOfRange) {
      if (mounted) {
        setState(
          () {
            cashCollectionProvider!.isLoadingmore = true;

            if (cashCollectionProvider!.offset! <
                cashCollectionProvider!.total!)
              cashCollectionProvider!.getOrder(
                "delivery",
                "DESC",
                setStateNow,
                context,
              );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: cashCollectionProvider!.scaffoldKey,
      backgroundColor: lightWhite,
      appBar:
          getAppBar(getTranslated(context, CASH_COLL)!, context, setStateNow),
      body: isNetworkAvail
          ? cashCollectionProvider!.isLoading
              ? const ShimmerEffect()
              : SingleChildScrollView(
                  controller: cashCollectionProvider!.controller,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const GetCardValue(),
                        Container(
                          padding: const EdgeInsetsDirectional.only(
                            start: 5.0,
                            end: 5.0,
                            top: 10.0,
                          ),
                          child: TextField(
                            controller: cashCollectionProvider!.controllerText,
                            decoration: InputDecoration(
                              filled: true,
                              isDense: true,
                              fillColor: white,
                              prefixIconConstraints: const BoxConstraints(
                                minWidth: 40,
                                maxHeight: 20,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              prefixIcon: const Icon(Icons.search),
                              hintText: 'Search ...',
                              hintStyle: TextStyle(
                                  color: fontColor.withOpacity(0.3),
                                  fontWeight: FontWeight.normal),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        cashCollectionProvider!.cashList.isEmpty
                            ? cashCollectionProvider!.isGettingdata
                                ? Container()
                                : const Center(child: Text(noItem))
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: (cashCollectionProvider!.offset! <
                                        cashCollectionProvider!.total!)
                                    ? cashCollectionProvider!.cashList.length +
                                        1
                                    : cashCollectionProvider!.cashList.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return (index ==
                                              cashCollectionProvider!
                                                  .cashList.length &&
                                          cashCollectionProvider!.isLoadingmore)
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : OrderItem(index: index);
                                },
                              ),
                        cashCollectionProvider!.isGettingdata
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                )
          : noInternet(
              context,
              setStateNoInternate,
              cashCollectionProvider!.buttonSqueezeanimation,
              cashCollectionProvider!.buttonController,
            ),
    );
  }

  Future<void> _playAnimation() async {
    try {
      await cashCollectionProvider!.buttonController!.forward();
    } on TickerCanceled {}
  }

  setStateNoInternate() async {
    _playAnimation();
    Future.delayed(const Duration(seconds: 2)).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          cashCollectionProvider!.getOrder(
            "delivery",
            "DESC",
            setStateNow,
            context,
          );
        } else {
          await cashCollectionProvider!.buttonController!.reverse();
          setState(
            () {},
          );
        }
      },
    );
  }
}
