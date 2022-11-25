import 'dart:async';
import 'package:deliveryboy_multivendor/Helper/color.dart';
import 'package:deliveryboy_multivendor/Helper/constant.dart';
import 'package:deliveryboy_multivendor/Helper/push_notification_service.dart';
import 'package:deliveryboy_multivendor/Screens/CashCollection/cash_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Localization/Language_Constant.dart';
import '../../Provider/SettingsProvider.dart';
import '../../Provider/homeProvider.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/noNetwork.dart';
import '../../Widget/parameterString.dart';
import '../../Widget/simmerEffect.dart';
import '../../Widget/systemChromeSettings.dart';
import '../../Widget/translateVariable.dart';
import '../../Widget/validation.dart';
import '../NotificationList/notification_lIst.dart';
import '../Privacy policy/privacy_policy.dart';
import '../WalletHistory/wallet_history.dart';
import 'Widget/DetailHeader.dart';
import 'Widget/deleteAccountDialog.dart';
import 'Widget/getHeading.dart';
import 'Widget/orderIteam.dart';
import 'Widget/filterDialog.dart';
import 'Widget/getLanguageDialog.dart';
import 'Widget/getLogOutDialog.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateHome();
  }
}

SettingProvider? settingProvider;
HomeProvider? homeProvider;

class StateHome extends State<Home> with TickerProviderStateMixin {
  setStateNow() {
    setState(() {});
  }

//==============================================================================
//============================= For Animation ==================================

  getSaveDetail() async {
    String getlng = await settingProvider!.getPrefrence(LAGUAGE_CODE) ?? '';

    homeProvider!.selectLan =
        homeProvider!.langCode.indexOf(getlng == '' ? "en" : getlng);
  }

  @override
  void initState() {
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    settingProvider = Provider.of<SettingProvider>(context, listen: false);
    homeProvider!.offset = 0;
    homeProvider!.total = 0;
    homeProvider!.orderList.clear();
    homeProvider!.getSetting(context);
    homeProvider!.getOrder(setStateNow, context);
    homeProvider!.getUserDetail(setStateNow, context);
    final pushNotificationService = PushNotificationService(context: context);
    pushNotificationService.initialise();
    homeProvider!.buttonController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    homeProvider!.buttonSqueezeanimation = Tween(
      begin: deviceWidth! * 0.7,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: homeProvider!.buttonController!,
        curve: Interval(
          0.0,
          0.150,
        ),
      ),
    );
    homeProvider!.controller.addListener(_scrollListener);
    Future.delayed(
      Duration.zero,
      () {
        homeProvider!.languageList = [
          getTranslated(context, 'English'),
          getTranslated(context, 'Hindi'),
          getTranslated(context, 'Chinese'),
          getTranslated(context, 'Spanish'),
          getTranslated(context, 'Arabic'),
          getTranslated(context, 'Russian'),
          getTranslated(context, 'Japanese'),
          getTranslated(context, 'Deutch'),
        ];
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeProvider!.scaffoldKey,
      backgroundColor: lightWhite,
      appBar: AppBar(
        title: Text(
          appName,
          style: TextStyle(
            color: grad2Color,
          ),
        ),
        iconTheme: IconThemeData(color: grad2Color),
        backgroundColor: white,
        actions: [
          InkWell(
            onTap: () {
              FilterDialog.filterDialog(context, setStateNow);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.filter_alt_outlined,
                color: primary,
              ),
            ),
          )
        ],
      ),
      drawer: _getDrawer(),
      body: isNetworkAvail
          ? homeProvider!.isLoading || supportedLocale == null
              ? const ShimmerEffect()
              : RefreshIndicator(
                  key: homeProvider!.refreshIndicatorKey,
                  onRefresh: _refresh,
                  child: SingleChildScrollView(
                    controller: homeProvider!.controller,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const DetailHeader(),
                          homeProvider!.orderList.isEmpty
                              ? homeProvider!.isLoadingItems
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Center(
                                      child: Text(
                                        getTranslated(context, noItem)!,
                                      ),
                                    )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: (homeProvider!.offset! <
                                          homeProvider!.total!)
                                      ? homeProvider!.orderList.length + 1
                                      : homeProvider!.orderList.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return (index ==
                                                homeProvider!
                                                    .orderList.length &&
                                            homeProvider!.isLoadingmore)
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : OrderIteam(
                                            index: index,
                                            update: setStateNow,
                                          );
                                  },
                                )
                        ],
                      ),
                    ),
                  ),
                )
          : noInternet(
              context,
              setStateNoInternate,
              homeProvider!.buttonSqueezeanimation,
              homeProvider!.buttonController,
            ),
    );
  }

  _scrollListener() {
    if (homeProvider!.controller.offset >=
            homeProvider!.controller.position.maxScrollExtent &&
        !homeProvider!.controller.position.outOfRange) {
      if (this.mounted) {
        setState(
          () {
            homeProvider!.isLoadingmore = true;

            if (homeProvider!.offset! < homeProvider!.total!)
              homeProvider!.getOrder(setStateNow, context);
            ;
          },
        );
      }
    }
  }

  Drawer _getDrawer() {
    return Drawer(
      child: SafeArea(
        child: Container(
          color: white,
          child: ListView(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              GetHeading(update: setStateNow),
              Divider(),
              _getDrawerItem(
                0,
                getTranslated(context, HOME_LBL)!,
                Icons.home_outlined,
              ),
              _getDrawerItem(
                7,
                getTranslated(context, WALLET)!,
                Icons.account_balance_wallet_outlined,
              ),
              _getDrawerItem(
                2,
                getTranslated(context, CASH_COLL)!,
                Icons.money_outlined,
              ),
              _getDrawerItem(
                5,
                getTranslated(context, ChangeLanguage)!,
                Icons.translate,
              ),
              _getDivider(),
              _getDrawerItem(
                8,
                getTranslated(context, PRIVACY)!,
                Icons.lock_outline,
              ),
              _getDrawerItem(
                9,
                getTranslated(context, TERM)!,
                Icons.speaker_notes_outlined,
              ),
              CUR_USERID == "" || CUR_USERID == null
                  ? Container()
                  : _getDivider(),
              CUR_USERID == "" || CUR_USERID == null
                  ? Container()
                  : _getDrawerItem(13,
                      getTranslated(context, "Delete Account")!, Icons.delete),
              CUR_USERID == "" || CUR_USERID == null
                  ? Container()
                  : _getDrawerItem(
                      11,
                      getTranslated(context, LOGOUT)!,
                      Icons.input_outlined,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getDivider() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Divider(
        height: 1,
      ),
    );
  }

  Widget _getDrawerItem(int index, String title, IconData icn) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        gradient: homeProvider!.curDrwSel == index
            ? LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [secondary.withOpacity(0.2), primary.withOpacity(0.2)],
                stops: [0, 1],
              )
            : null,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          icn,
          color: homeProvider!.curDrwSel == index ? primary : lightBlack2,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: homeProvider!.curDrwSel == index ? primary : lightBlack2,
            fontSize: 15,
          ),
        ),
        onTap: () {
          Navigator.of(context).pop();
          if (title == getTranslated(context, HOME_LBL)) {
            setState(
              () {
                homeProvider!.curDrwSel = index;
              },
            );
            Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
          } else if (title == getTranslated(context, ChangeLanguage)!) {
            setState(
              () {
                homeProvider!.curDrwSel = index;
              },
            );
            LanguageDialog.languageDialog(
              context,
              setStateNow,
            );
          } else if (title == getTranslated(context, "Delete Account")!) {
            setState(
              () {
                homeProvider!.curDrwSel = index;
              },
            );
            homeProvider!.currentIndex = 0;
            DeleteAccountDialog.deleteAccountDailog(context, setStateNow);
          } else if (title == getTranslated(context, NOTIFICATION)) {
            setState(
              () {
                homeProvider!.curDrwSel = index;
              },
            );
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => NotificationList(),
              ),
            );
          } else if (title == getTranslated(context, LOGOUT)) {
            LogOutDialog.logOutDailog(context);
          } else if (title == getTranslated(context, PRIVACY)) {
            setState(
              () {
                homeProvider!.curDrwSel = index;
              },
            );
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => PrivacyPolicy(
                  title: getTranslated(context, PRIVACY)!,
                ),
              ),
            );
          } else if (title == getTranslated(context, TERM)) {
            setState(
              () {
                homeProvider!.curDrwSel = index;
              },
            );
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => PrivacyPolicy(
                  title: getTranslated(context, TERM)!,
                ),
              ),
            );
          } else if (title == getTranslated(context, WALLET)) {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => WalletHistory(),
              ),
            );
          } else if (title == getTranslated(context, CASH_COLL)) {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const CashCollection(),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    homeProvider!.passwordController.dispose();
    homeProvider!.buttonController!.dispose();
    super.dispose();
  }

  Future<Null> _refresh() {
    homeProvider!.offset = 0;
    homeProvider!.total = 0;
    homeProvider!.orderList.clear();

    setState(
      () {
        homeProvider!.isLoading = true;
        homeProvider!.isLoadingItems = false;
      },
    );
    homeProvider!.orderList.clear();
    homeProvider!.getSetting(context);

    return homeProvider!.getOrder(setStateNow, context);
    ;
  }

  Future<void> _playAnimation() async {
    try {
      await homeProvider!.buttonController!.forward();
    } on TickerCanceled {}
  }

  setStateNoInternate() async {
    _playAnimation();

    Future.delayed(Duration(seconds: 2)).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          homeProvider!.getSetting(context);
          homeProvider!.getOrder(setStateNow, context);
        } else {
          await homeProvider!.buttonController!.reverse();
          setState(
            () {},
          );
        }
      },
    );
  }
}
