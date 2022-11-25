import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Helper/color.dart';
import '../../../Provider/WalletProvider.dart';
import '../../../Widget/parameterString.dart';
import '../../../Widget/translateVariable.dart';
import '../../../Widget/validation.dart';

class GetDialogs {
  static void withDrawMonetDiolog(
      BuildContext context,
      TextEditingController? amtC,
      bankDetailC,
      GlobalKey<FormState> _formkey) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(0.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    5.0,
                  ),
                ),
              ),
              content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        20.0,
                        20.0,
                        0,
                        2.0,
                      ),
                      child: Text(
                        getTranslated(context, SEND_REQUEST)!,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: fontColor,
                            ),
                      ),
                    ),
                    Divider(
                      color: lightBlack,
                    ),
                    Form(
                      key: _formkey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              validator: (val) =>
                                  StringValidation.validateField(val, context),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                hintText:
                                    getTranslated(context, WITHDRWAL_AMT)!,
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      color: lightBlack,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                              controller: amtC,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              20.0,
                              0,
                              20.0,
                              0,
                            ),
                            child: TextFormField(
                              validator: (val) =>
                                  StringValidation.validateField(val, context),
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                hintText: BANK_DETAIL,
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      color: lightBlack,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                              controller: bankDetailC,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    getTranslated(context, CANCEL)!,
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          color: lightBlack,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text(
                    getTranslated(context, SEND_LBL)!,
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          color: fontColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  onPressed: () {
                    final form = _formkey.currentState!;
                    if (form.validate()) {
                      form.save();

                      Navigator.pop(context);

                      context
                          .read<MyWalletProvider>()
                          .sendAmountWithdrawRequest(
                              userID: CUR_USERID!,
                              bankDetails: bankDetailC!.text.toString(),
                              withdrawalAmount: amtC!.text.toString());
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  static void filterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ButtonBarTheme(
          data: ButtonBarThemeData(
            alignment: MainAxisAlignment.center,
          ),
          child: AlertDialog(
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  5.0,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.all(
              0.0,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 19.0,
                    bottom: 16.0,
                  ),
                  child: Text(
                    getTranslated(context, FILTER_BY)!,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Divider(
                  color: lightBlack,
                ),
                TextButton(
                  child: Text(
                    getTranslated(context, SHOW_TRANS)!,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: lightBlack,
                        ),
                  ),
                  onPressed: () {
                    context
                        .read<MyWalletProvider>()
                        .walletTransactionList
                        .clear();
                    context.read<MyWalletProvider>().transactionListOffset = 0;
                    context.read<MyWalletProvider>().transactionListTotal = 0;
                    context.read<MyWalletProvider>().isLoading = true;
                    context.read<MyWalletProvider>().getUserWalletTransactions(
                        context: context, walletTransactionIsLoadingMore: true);
                    Navigator.pop(context, 'option 1');
                  },
                ),
                Divider(color: lightBlack),
                TextButton(
                  child: Text(
                    getTranslated(context, SHOW_REQ)!,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: lightBlack,
                        ),
                  ),
                  onPressed: () {
                    context
                        .read<MyWalletProvider>()
                        .walletTransactionList
                        .clear();
                    context.read<MyWalletProvider>().transactionListOffset = 0;
                    context.read<MyWalletProvider>().transactionListTotal = 0;
                    context.read<MyWalletProvider>().isLoading = true;
                    context
                        .read<MyWalletProvider>()
                        .fetchUserWalletAmountWithdrawalRequestTransactions(
                            context: context,
                            walletTransactionIsLoadingMore: true);
                    Navigator.pop(context, 'option 1');
                  },
                ),
                Divider(
                  color: white,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
