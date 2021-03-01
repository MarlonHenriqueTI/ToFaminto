import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'resume_input_field.dart';

class InputFieldsContainer extends StatelessWidget {
  final TextEditingController commentController;
  final TextEditingController couponController;

  const InputFieldsContainer({
    @required this.commentController,
    @required this.couponController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ResumeInputField(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              text: "COMENTÁRIO",
              controller: commentController,
              isComment: true,
              inputFormatters: [
                LengthLimitingTextInputFormatter(100),
              ]),
          ResumeInputField(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            text: "CUPOM",
            controller: couponController,
          ),
        ],
      ),
    );
  }
}
