import 'package:flutter/material.dart';
import 'package:to_faminto_client/constants/api_urls.dart';
import 'package:to_faminto_client/constants/app_style.dart';
import 'package:to_faminto_client/constants/phrases_constants.dart';
import 'package:to_faminto_client/models/api_error.dart';
import 'package:to_faminto_client/services/api_service.dart';
import 'package:uuid/uuid.dart';

import 'address_text_form_field.dart';

class SearchContainer extends StatefulWidget {
  final Function autoFillAddress;
  final VoidCallback manualFill;

  const SearchContainer(
      {@required this.autoFillAddress, @required this.manualFill});
  @override
  _SearchContainerState createState() => _SearchContainerState();
}

class _SearchContainerState extends State<SearchContainer> {
  final _apiService = ApiService();
  final _uuid = Uuid();
  String _token;
  final _searchController = TextEditingController();
  List<Widget> predictionsText = [];
  bool _hasBeenDisposed = false;

  void onSearchUpdate() async {
    final result = await _apiService.addressAutoComplete(
        query: _searchController.text, token: _token);
    if (_hasBeenDisposed) return;
    if (result is ApiError) {
      setState(() {
        predictionsText = [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Text(
              result.text,
              style: AppStyle.greyRegularText14Style(),
            ),
          )
        ];
      });
    } else {
      buildPredictions(result ?? []);
    }
  }

  void buildPredictions(List<Map<String, dynamic>> predictions) {
    if (predictions.isNotEmpty) {
      List<Widget> predictionsList = [];
      final length = predictions.length;
      for (int i = 0; i < length; i++) {
        predictionsList.add(InkWell(
          key: Key(i.toString()),
          onTap: () => widget.autoFillAddress(predictions[i]['terms']),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Text(
              predictions[i]['description'],
              style: AppStyle.greyRegularText14Style(),
            ),
          ),
        ));
        if (!(i == length - 1)) predictionsList.add(Divider());
      }
      if (_hasBeenDisposed) return;
      setState(() {
        predictionsText = [...predictionsList];
      });
    }
  }

  @override
  void initState() {
    _token = _uuid.v4();
    _apiService.openConnection(ApiUrls.placesPredictions);
    _searchController.addListener(onSearchUpdate);
    super.initState();
  }

  @override
  void dispose() {
    _hasBeenDisposed = true;
    _apiService.closeConnection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (predictionsText.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppStyle.yellow),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: predictionsText,
                ),
              ),
            ),
          SizedBox(height: 10),
          AddressTextFormField(
            fieldName: PhrasesConstants.NEW_ADDRESS_SEARCH_BAR,
            controller: _searchController,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3,
                child: Align(
                  child: Image.asset(
                      "assets/images/powered_by_google_on_white.png"),
                ),
              ),
              InkWell(
                onTap: widget.manualFill,
                child: Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppStyle.yellow,
                    borderRadius: const BorderRadius.all(Radius.circular(36.0)),
                  ),
                  child: Text(
                    "Manual",
                    style: AppStyle.whiteSemiBoldText16Style(),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
