import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/models/coupon.dart';
import 'package:to_faminto_client/providers/cart_state.dart';
import 'package:to_faminto_client/providers/checkout_state.dart';
import 'package:to_faminto_client/providers/routes_state.dart';

class ResumeInputField extends StatefulWidget {
  final String text;
  final TextEditingController controller;
  final bool isComment;
  final Function onPressed;
  final TextStyle textStyle;
  final Color buttonColor;
  final Color buttonIconColor;
  final TextStyle labelTextStyle;
  final Color cursorColor;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  const ResumeInputField({
    @required this.text,
    this.controller,
    this.isComment = false,
    this.onPressed,
    this.textStyle,
    this.buttonColor,
    this.buttonIconColor,
    this.labelTextStyle,
    this.cursorColor,
    this.keyboardType,
    this.inputFormatters,
    this.margin,
    this.padding,
  });

  @override
  _ResumeInputFieldState createState() => _ResumeInputFieldState();
}

class _ResumeInputFieldState extends State<ResumeInputField> {
  String _commentCount = "";
  bool _hasToManyLetters = false;
  bool _waitingForCouponConfirmation = false;

  void onChanged() {
    _hasToManyLetters = false;
    if (widget.controller.text.length > 100) {
      _hasToManyLetters = true;
    }
    setState(() {
      _commentCount = "${widget.controller.text.length.toString()}/100";
    });
  }

  void applyCoupon(context) async {
    final coupon = widget.controller.text;
    if (coupon.length > 0 && coupon.length < 100) {
      setState(() {
        _waitingForCouponConfirmation = true;
      });

      final Coupon resultCoupon =
          await Provider.of<CheckoutState>(context, listen: false).applyCoupon(
        coupon: coupon,
        resId: Provider.of<RoutesState>(context, listen: false)
            .currentSelectedRestaurantMinData
            .id,
      );

      if (resultCoupon is Coupon) {
        Provider.of<CartState>(context, listen: false)
            .applyCoupon(resultCoupon);
        showSnackBar(context, "Aplicado com successo!", true);
      } else {
        showSnackBar(context, "Ops... Cupom não existe!", false);
      }
    }

    widget.controller.clear();

    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void showSnackBar(BuildContext context, String content, bool success) {
    setState(() {
      _waitingForCouponConfirmation = false;
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            content,
            style: success
                ? AppStyle.greenMediumText16Style()
                : AppStyle.redMediumText14Style(),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white,
          duration: Duration(seconds: 3),
        ),
      );
    });
  }

  @override
  void initState() {
    if (widget.isComment) {
      widget.controller.addListener(onChanged);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 10.0),
      margin:
          widget.margin ?? const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(9.0)),
        border: Border.all(color: AppStyle.lightGrey, width: 1.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              style: widget.textStyle ?? AppStyle.greyRegularText16Style(),
              cursorColor: widget.cursorColor ?? AppStyle.yellow,
              keyboardType: widget.keyboardType,
              maxLines: null,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10),
                border: InputBorder.none,
                labelText: "${widget.text} $_commentCount",
                labelStyle: widget.labelTextStyle ??
                    TextStyle(
                      color: _hasToManyLetters ? Colors.red : AppStyle.grey,
                    ),
                hintStyle: widget.labelTextStyle ??
                    TextStyle(
                      color: _hasToManyLetters ? Colors.red : AppStyle.grey,
                      height: 2,
                    ),
              ),
            ),
          ),
          if (!widget.isComment)
            _waitingForCouponConfirmation
                ? CircularProgressIndicator()
                : Container(
                    decoration: BoxDecoration(
                      color: widget.buttonColor != null
                          ? widget.buttonColor
                          : AppStyle.yellow,
                      borderRadius: BorderRadius.all(
                        Radius.circular(9.0),
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {
                        if (widget.onPressed != null) {
                          widget.onPressed();
                        } else {
                          applyCoupon(context);
                        }
                      },
                      icon: Icon(
                        Icons.done,
                        color: widget.buttonIconColor ?? Colors.white,
                      ),
                    ),
                  ),
        ],
      ),
    );
  }
}
