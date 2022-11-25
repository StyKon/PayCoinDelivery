import 'dart:async';
import 'dart:convert';
import 'package:deliveryboy_multivendor/Helper/color.dart';

import 'package:deliveryboy_multivendor/Provider/WalletProvider.dart';
import 'package:deliveryboy_multivendor/Screens/WalletHistory/Widget/GetAppBar.dart';
import 'package:deliveryboy_multivendor/Screens/WalletHistory/Widget/GetDialogs.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../Widget/ButtonDesing.dart';

import '../../Widget/desing.dart';

import '../../Widget/networkAvailablity.dart';
import '../../Widget/noNetwork.dart';
import '../../Widget/parameterString.dart';

import '../../Widget/simmerEffect.dart';
import '../../Widget/translateVariable.dart';
import '../../Widget/validation.dart';
import 'Widget/ListItem.dart';

class WalletHistory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateWallet();
  }
}

class StateWallet extends State<WalletHistory> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  ScrollController controller = ScrollController();
  TextEditingController? amtC, bankDetailC;

  @override
  void initState() {
    super.initState();
    context.read<MyWalletProvider>().getUserWalletTransactions(
        context: context, walletTransactionIsLoadingMore: true);

    controller.addListener(_scrollListener);
    buttonController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    buttonSqueezeanimation = Tween(
      begin: deviceWidth! * 0.7,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: buttonController!,
        curve: Interval(
          0.0,
          0.150,
        ),
      ),
    );
    amtC = TextEditingController();
    bankDetailC = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: lightWhite,
        key: _scaffoldKey,
        appBar: GetAppBar.getAppBar(
          getTranslated(context, WALLET)!,
          context,
        ),
        body: isNetworkAvail
            ? Consumer<MyWalletProvider>(
                builder: (context, value, child) {
                  if (value.getCurrentStatus == MyWalletStatus.isFailure) {
                    return Center(
                      child: Text(
                        value.errorMessage,
                      ),
                    );
                  } else if (value.getCurrentStatus ==
                      MyWalletStatus.isSuccsess) {
                    return RefreshIndicator(
                      key: _refreshIndicatorKey,
                      onRefresh: _refresh,
                      child: SingleChildScrollView(
                        controller: controller,
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 5.0,
                            ),
                            child: Card(
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(
                                  18.0,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.account_balance_wallet,
                                          color: fontColor,
                                        ),
                                        Text(
                                          " " + CURBAL_LBL,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2!
                                              .copyWith(
                                                color: fontColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      DesignConfiguration.getPriceFormat(
                                        context,
                                        double.parse(CUR_BALANCE),
                                      )!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                            color: fontColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    SimBtn(
                                      size: 0.8,
                                      title: getTranslated(
                                          context, WITHDRAW_MONEY)!,
                                      onBtnSelected: () {
                                        GetDialogs.withDrawMonetDiolog(context,
                                            amtC, bankDetailC, _formkey);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          value.walletTransactionList.isEmpty
                              ? Text(
                                  getTranslated(context, noItem)!,
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: (value.transactionListOffset <
                                          value.transactionListTotal)
                                      ? value.walletTransactionList.length + 1
                                      : value.walletTransactionList.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return (index ==
                                                value.walletTransactionList
                                                    .length &&
                                            value.walletTransactionHasMoreData)
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : ListItem(
                                            index: index,
                                            model: value
                                                .walletTransactionList[index],
                                          );
                                  })
                        ]),
                      ),
                    );
                  }
                  return const ShimmerEffect();
                },
              )
            : noInternet(
                context,
                setStateNoInternate,
                buttonSqueezeanimation,
                buttonController,
              ));
  }

  Future<void> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  setStateNoInternate() async {
    _playAnimation();
    Future.delayed(Duration(seconds: 2)).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          // getTransaction();
        } else {
          await buttonController!.reverse();
          setState(
            () {},
          );
        }
      },
    );
  }

  @override
  void dispose() {
    buttonController!.dispose();
    super.dispose();
  }

  Future<void> _refresh() {
    context.read<MyWalletProvider>().walletTransactionList.clear();
    context.read<MyWalletProvider>().transactionListOffset = 0;
    context.read<MyWalletProvider>().transactionListTotal = 0;
    context.read<MyWalletProvider>().isLoading = true;
    return context.read<MyWalletProvider>().getUserWalletTransactions(
        context: context, walletTransactionIsLoadingMore: true);
  }

  _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      if (this.mounted) {
        setState(
          () {
            if (context.read<MyWalletProvider>().transactionListOffset <
                context.read<MyWalletProvider>().transactionListTotal)
              context.read<MyWalletProvider>().getUserWalletTransactions(
                  context: context, walletTransactionIsLoadingMore: true);
          },
        );
      }
    }
  }
}
