import 'package:flutter/cupertino.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../indicators/data_loading_indicator.dart';

class PrivacyContent extends StatefulWidget {
  const PrivacyContent({super.key});

  @override
  State<PrivacyContent> createState() => _PrivacyContentState();
}

class _PrivacyContentState extends State<PrivacyContent> {
  @override
  void initState() {
    super.initState();
  }

  Future<String> _loadHtmlFromAssets(BuildContext context) async {
    return await DefaultAssetBundle.of(context)
        .loadString('assets/html/privacy.html');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadHtmlFromAssets(context),
        builder: (ctx, snapshot) {
          // Checking if future is resolved or not
          if (snapshot.connectionState == ConnectionState.done) {
            // If we got an error
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occurred',
                ),
              );

              // if we got our data
            } else if (snapshot.hasData) {
              // Extracting data from snapshot object
              final data = snapshot.data as String;
              return HtmlWidget(data);
            }
          }

          // Displaying LoadingSpinner to indicate waiting state
          return const Center(
            child: DataLoadingIndicator(),
          );
        });
  }
}
