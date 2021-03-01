import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/providers/user_state.dart';
import 'package:to_faminto_client/screens/components/top_notch.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<ProfileInformationContainer> listOfContent = [];
  bool _isLoading = true;

  void buildContent() async {
    final userDetailsList =
        await Provider.of<UserState>(context, listen: false).userDetailsList();

    for (final info in userDetailsList) {
      listOfContent.add(ProfileInformationContainer(
          title: info.title, content: info.content));
    }

    if (userDetailsList != null) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    buildContent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.whiteBackground,
      body: SafeArea(
        child: _isLoading
            ? SizedBox()
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TopNotch("Perfil"),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: listOfContent,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class ProfileInformationContainer extends StatelessWidget {
  final String title;
  final String content;

  const ProfileInformationContainer(
      {@required this.title, @required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(9.0)),
        border: Border.all(color: AppStyle.lightGrey, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyle.greyRegularText14Style(),
          ),
          SizedBox(height: 12),
          Text(
            content,
            style: AppStyle.mediumGreyRegularTex16tStyle(),
          ),
        ],
      ),
    );
  }
}
