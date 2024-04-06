//dirty solution for global dataholding

class Globals {
  static bool logToCrashlytics = true;
  static bool eventConfirmed = false;
  static bool serverConnected = true;
  static String? adminPass;
  static const String webViewHeader = '<!DOCTYPE html> '
      '<html lang="de">'
      '<head> <meta charset="UTF-8"> '
      '<meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">'
      '<meta http-equiv="X-UA-Compatible" content="ie=edge">'
      '<meta name="color-scheme" content="dark light">'
      '<style>fieldset {background-color: gainsboro;}'
      '@media (prefers-color-scheme: dark) {fieldset {background-color: darkslategray;}}</style>'
      //'<style>@media (prefers-color-scheme: dark) {.theme {color: #FFFFFF,background-color: #000000}} '
      //'</style><style>@media screen and (prefers-color-scheme: dark) {:root {--title-color: #ff8080; --subhead-color: #80ff80; --link-color: #93d5ff;}}</style>'
      '</head>'
      '<body>';
  static const String webViewFooter = '-</body></html>';}
