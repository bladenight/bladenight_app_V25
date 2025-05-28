import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:go_transitions/go_transitions.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../helpers/export_import_data_helper.dart';
import '../../main.dart';
import '../../models/event.dart';
import '../../models/friend.dart';
import '../../models/user_gpx_point.dart';
import '../../pages/about_page/about_page.dart';
import '../../pages/admin/admin_page.dart';
import '../../pages/admin/widgets/admin_password_dialog.dart';
import '../../pages/events/events_page.dart';
import '../../pages/events/widgets/event_editor.dart';
import '../../pages/friends/widgets/nearby_widget.dart';
import '../../pages/home_info/home_page.dart';
import '../../pages/logger/talker_monitor.dart';
import '../../pages/map/map_page.dart';
import '../../pages/map/widgets/qr_create_page.dart';
import '../../pages/settings/settings_page.dart';
import '../../pages/widgets/intro_slider.dart';
import '../../pages/widgets/route/route_dialog.dart';
import '../../pages/widgets/picker/route_name_dialog.dart';
import '../../pages/widgets/startup_widgets/app_route_error_widget.dart';
import '../../pages/widgets/map/user_tracking_dialog.dart';
import '../admin/admin_pwd_provider.dart';
import '../../navigation/scaffold_with_nested_navigation.dart';
import '../../pages/bladeguard/bladeguard_page.dart';
import '../../pages/friends/friends_page.dart';
import '../../pages/friends/widgets/edit_friend_dialog.dart';
import '../../pages/messages/messages_page.dart';

part 'go_router.g.dart';

final GlobalKey<NavigatorState> _sectionHomeNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionHomeNav');
final GlobalKey<NavigatorState> _sectionMapNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionMapNav');
final GlobalKey<NavigatorState> _sectionEventsNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionEventsNav');
final GlobalKey<NavigatorState> _sectionSettingsNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionSettingsNav');
final _friendsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'friend');
final _messageLinkNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: '_messageLinkNavigatorKey');

enum AppRoute {
  aboutPage,

  /// open Admin Page if password set
  /// redirect to home
  adminPage,

  /// request Admin Page if password set
  /// redirect to home
  adminLogin,
  home,
  map,
  events,

  ///required extra Event
  eventEditorPage,
  friend,
  settings,
  logMonitor,
  showRouteDetails,
  showEventRouteDetails,
  onboarding,
  signIn,

  //friends
  editFriendDialog,
  addFriend,

  //messages
  message,
  messagesPage,
  messagesPageMenu,
  bladeguard,
  showRoute,
  linkFriendDevicePage,
  introScreen,

  /// Export userGPX Data
  ///
  /// queryParameters: {'userGPXPoints': userGPXPoints, 'date': date});
  userTrackDialog,

  /// Create QRCode with text
  ///
  /// ```/qrCreatePage?infoText=24566&headerText=567&qrCodeText=132435```
  ///
  /// ```dart
  /// queryParameters: {
  /// qrCodeText: pathParameters['qrCodeText']??'',
  /// headerText: pathParameters['headerText']??'',
  /// infoText: pathParameters['infoText']??''
  /// }```
  qrCreatePage
}

@riverpod
GoRouter goRouter(Ref ref) {
  return GoRouter(
    observers: [
      // Add your navigator observers
      // GoRouterNavigatorObserver(),
      TalkerRouteObserver(talker)
    ],
    initialLocation: '/',
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: kDebugMode,
    routes: [
      GoRoute(

          ///qrCreatePage?infoText=24566&headerText=567&qrCodeText=132435
          caseSensitive: false,
          path: '/${AppRoute.qrCreatePage.name}',
          name: AppRoute.qrCreatePage.name,
          pageBuilder: (context, state) {
            var pathParameters = state.uri.queryParameters;
            return NoTransitionPage(
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).width * 0.3,
                child: QRCreatePage(
                  qrCodeText: pathParameters['qrCodeText'] ?? '',
                  headerText: pathParameters['headerText'] ?? '',
                  infoText: pathParameters['infoText'] ?? '',
                ),
              ),
            );
          }),
      GoRoute(
          caseSensitive: false,
          path: '/privacy.html',
          name: 'privacy.html',
          pageBuilder: (context, state) {
            return NoTransitionPage(
              child: AboutPage(),
            );
          }),
      GoRoute(
          caseSensitive: false,
          path: '/privacy',
          name: 'privacy',
          pageBuilder: (context, state) {
            return NoTransitionPage(
              child: AboutPage(),
            );
          }),

      // Stateful navigation based on:
      // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
      StatefulShellRoute.indexedStack(
          pageBuilder: (context, state, navigationShell) => NoTransitionPage(
                child: ScaffoldWithNestedNavigation(
                    navigationShell: navigationShell),
              ),
          branches: <StatefulShellBranch>[
            // The route branch for the first tab of the bottom navigation bar.
            //every branch is a tab
            StatefulShellBranch(
              navigatorKey: _sectionHomeNavigatorKey,
              routes: <RouteBase>[
                GoRoute(
                  // The screen to display as the root in the first tab of the
                  // bottom navigation bar.
                  name: AppRoute.home.name,
                  path: '/',
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    var queryParameters = state.uri.queryParameters;
                    if (queryParameters.containsKey('data')) {
                      importData(context, queryParameters['data']!);
                    }
                    return NoTransitionPage(child: const HomePage());
                  },
                  routes: <RouteBase>[
                    // The details screen to display stacked on navigator of the
                    // first tab. This will cover screen A but not the application
                    // shell (bottom navigation bar).
                    GoRoute(
                      caseSensitive: false,
                      name: AppRoute.messagesPage.name,
                      path: '/messages',
                      parentNavigatorKey: _sectionHomeNavigatorKey,
                      pageBuilder: GoTransitions.bottomSheet,
                      builder: (BuildContext context, GoRouterState state) =>
                          const MessagesPage(),
                    ),
                    if (kIsWeb) //is in settings available on no kIsWebApps
                      GoRoute(
                        caseSensitive: false,
                        path: '/${AppRoute.aboutPage.name}',
                        name: AppRoute.aboutPage.name,
                        pageBuilder: (context, state) => const NoTransitionPage(
                          child: AboutPage(),
                        ),
                      ),
                  ],
                ),
              ],
              preload: true,
              // To enable preloading of the initial locations of branches, pass
              // 'true' for the parameter `preload` (false is default).
            ),
            // #enddocregion configuration-branches
            StatefulShellBranch(navigatorKey: _sectionMapNavigatorKey, routes: [
              GoRoute(
                caseSensitive: false,
                path: '/${AppRoute.map.name}',
                name: AppRoute.map.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: MapPage(),
                ),
              ),
            ]),
            StatefulShellBranch(
                navigatorKey: _sectionEventsNavigatorKey,
                routes: [
                  GoRoute(
                      caseSensitive: false,
                      path: '/${AppRoute.events.name}',
                      name: AppRoute.events.name,
                      pageBuilder: (context, state) {
                        return NoTransitionPage(
                          child: EventsPage(),
                        );
                      },
                      routes: [
                        GoRoute(
                          caseSensitive: false,
                          path: '/${AppRoute.showRoute.name}/:name',
                          pageBuilder: (context, state) => NoTransitionPage(
                            child: RouteNameDialog(
                                routeName: state.pathParameters['name']!),
                          ),
                        ),
                        GoRoute(
                          caseSensitive: false,
                          path: AppRoute.showRoute.name,
                          name: AppRoute.showEventRouteDetails.name,
                          redirect:
                              (BuildContext context, GoRouterState state) {
                            if (state.extra is Event) {
                              return null;
                            }
                            return '/${AppRoute.events.name}';
                          },
                          pageBuilder: (context, state) => NoTransitionPage(
                            child: RouteDialog(event: state.extra as Event),
                          ),
                        ),
                        GoRoute(
                            path: '/${AppRoute.eventEditorPage.name}',
                            name: AppRoute.eventEditorPage.name,
                            pageBuilder: (context, state) {
                              var event = state.extra as Event;
                              return NoTransitionPage(
                                child: EventEditor(event: event),
                              );
                            }),
                      ]),
                ]),
            if (!kIsWeb)
              StatefulShellBranch(
                navigatorKey: _friendsNavigatorKey,
                routes: [
                  //no locale
                  GoRoute(
                    caseSensitive: false,
                    path: '/${AppRoute.friend.name}',
                    name: AppRoute.friend.name,
                    pageBuilder: (context, state) {
                      return NoTransitionPage(child: FriendsPage());
                    },
                    routes: [
                      GoRoute(
                        //"/sample?id1=$param1&id2=$param2");
                        //bna://bladenight.app?addFriend&code=148318'
                        //
                        // oder 'https://bladenight.app?code=148318
                        //
                        //test:
                        // /usr/bin/xcrun simctl openurl booted "bna://bladenight.app/friend/addFriend?code=123456&name=tom"
                        //adb shell 'am start -W -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "bna://bladenight.app/friend/addFriend?code=123456&name=tom"'
                        //
                        // adb devices with -s "xxxxx"
                        //adb -s "R3CT50CK8FP" shell 'am start -W -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "bna://bladenight.app/friend/addFriend?code=123456&name=tom"'
                        caseSensitive: false,
                        path: '/${AppRoute.addFriend.name}',
                        name: AppRoute.addFriend.name,
                        parentNavigatorKey: _friendsNavigatorKey,
                        pageBuilder: GoTransitions.fullscreenDialog,
                        builder: (context, state) {
                          return addFriendRouterWidget(context, state);
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    // const LinkFriendDevicePage(deviceType: DeviceType.advertiser,
                    //                            friendsAction: FriendsAction.addNearby,
                    caseSensitive: false,
                    path: '/${AppRoute.linkFriendDevicePage.name}',
                    name: AppRoute.linkFriendDevicePage.name,
                    pageBuilder: (context, state) {
                      var parameters = state.uri.queryParameters;
                      var deviceType = parameters['deviceType'] as DeviceType;
                      var friendsAction =
                          parameters['friendsAction'] as FriendsAction;

                      return NoTransitionPage(
                        child: LinkFriendDevicePage(
                            deviceType: deviceType,
                            friendsAction: friendsAction),
                      );
                    },
                  ),
                  GoRoute(
                    caseSensitive: false,
                    path: '/${AppRoute.editFriendDialog.name}',
                    name: AppRoute.editFriendDialog.name,
                    redirect: (BuildContext context, GoRouterState state) {
                      var parameters = state.uri.queryParameters;
                      if (!parameters.containsKey('action')) {
                        return '/${AppRoute.friend.name}';
                      } else if (parameters.containsKey('action')) {
                        var action = FriendsAction.values.firstWhereOrNull(
                            (x) => parameters['action'] == x.name);
                        if (action == null) {
                          return '/${AppRoute.friend.name}';
                        }
                      }
                      return null;
                    },
                    builder: (context, state) {
                      var parameters = state.uri.queryParameters;
                      Friend? friend;
                      FriendsAction action;
                      if (parameters.containsKey('friend') &&
                          parameters['friend']!.isNotEmpty) {
                        friend = FriendMapper.fromJson(parameters['friend']!);
                      }
                      action = FriendsAction.values
                          .firstWhere((x) => parameters['action'] == x.name);

                      return EditFriendDialog(
                        friend: friend,
                        action: action,
                      );
                    },
                    pageBuilder: GoTransitions.fade.withBackGesture.call,
                  ),
                ],
              ),
            if (!kIsWeb)
              StatefulShellBranch(
                  navigatorKey: _sectionSettingsNavigatorKey,
                  routes: [
                    GoRoute(
                      caseSensitive: false,
                      path: '/${AppRoute.settings.name}',
                      name: AppRoute.settings.name,
                      pageBuilder: (context, state) => const NoTransitionPage(
                        child: SettingsPage(),
                      ),
                      routes: [
                        GoRoute(
                          caseSensitive: false,
                          path: '/${AppRoute.bladeguard.name}',
                          name: AppRoute.bladeguard.name,
                          builder: (context, state) => BladeGuardPage(),
                          pageBuilder: GoTransitions.slide.withBackGesture.call,
                        ),
                        GoRoute(
                          caseSensitive: false,
                          path: '/${AppRoute.aboutPage.name}',
                          name: AppRoute.aboutPage.name,
                          pageBuilder: (context, state) =>
                              const NoTransitionPage(
                            child: AboutPage(),
                          ),
                        ),
                        GoRoute(
                          path: '/${AppRoute.signIn.name}',
                          name: AppRoute.signIn.name,
                          pageBuilder: (context, state) =>
                              const NoTransitionPage(
                            child: BladeGuardPage(),
                          ),
                        ),
                        GoRoute(
                          path: '/${AppRoute.logMonitor.name}',
                          name: AppRoute.logMonitor.name,
                          pageBuilder: (context, state) => NoTransitionPage(
                            child: TalkerMonitor(
                                theme: TalkerScreenTheme(), talker: talker),
                          ),
                        ),
                        GoRoute(
                            path: '/${AppRoute.userTrackDialog.name}',
                            name: AppRoute.userTrackDialog.name,
                            pageBuilder: GoTransitions.slide.call,
                            builder: (context, state) {
                              var queryParameters = state.uri.queryParameters;
                              var date = queryParameters['date'] as String;
                              var userGpxPoints =
                                  queryParameters['userGPXPoints'];
                              if (userGpxPoints == null) {
                                return UserTrackDialog(
                                  userGPXPoints: UserGPXPoints([]),
                                  date: date,
                                );
                              }
                              var userGPXPoints =
                                  UserGPXPointsMapper.fromJson(userGpxPoints);
                              return UserTrackDialog(
                                userGPXPoints: userGPXPoints,
                                date: date,
                              );
                            }),
                        GoRoute(
                            path: '/intro',
                            name: AppRoute.introScreen.name,
                            pageBuilder: (context, state) =>
                                NoTransitionPage(child: IntroScreen())),
                        GoRoute(
                            path: '/${AppRoute.adminLogin.name}',
                            name: AppRoute.adminLogin.name,
                            redirect:
                                (BuildContext context, GoRouterState state) {
                              /* if (!ref.read(userIsAdminProvider)) {
                              return '/';
                            } else */
                              if (ref.read(adminPwdSetProvider)) {
                                return '/settings/${AppRoute.adminPage.name}';
                              } else {
                                return null;
                              }
                            },
                            builder: (context, state) {
                              return AdminPasswordDialog();
                            },
                            pageBuilder: GoTransitions.bottomSheet),
                        GoRoute(
                            path: '/${AppRoute.adminPage.name}',
                            name: AppRoute.adminPage.name,
                            redirect:
                                (BuildContext context, GoRouterState state) {
                              if (!ref.read(adminPwdSetProvider)) {
                                return '/${AppRoute.adminLogin.name}';
                              } else {
                                return null;
                              }
                            },
                            builder: (context, state) {
                              return AdminPage();
                            },
                            pageBuilder: GoTransitions.bottomSheet),
                      ],
                    ),
                  ]),
            StatefulShellBranch(
                navigatorKey: _messageLinkNavigatorKey,
                routes: [
                  GoRoute(
                    path: '/messagesPageMenu',
                    name: AppRoute.messagesPageMenu.name,
                    pageBuilder: (context, state) => const NoTransitionPage(
                      child: MessagesPage(),
                    ),
                  ),
                ]),
          ]),
    ],
    errorPageBuilder: (context, state) => NoTransitionPage(
      child: AppRouteErrorWidget(
          message: state.error!.message.toString(),
          onRetry: () => context.goNamed(AppRoute.home.name)),
    ),
  );
}

Widget addFriendRouterWidget(BuildContext context, GoRouterState state) {
  var friendsAction = FriendsAction.addNew;
  var name = '';
  var parameters = state.uri.queryParameters;
  var fullText = state.uri.toString();
  var unescaped = Uri.decodeFull(fullText);
  var encodedUri = Uri.tryParse(unescaped);
  if (encodedUri != null) {
    parameters = encodedUri.queryParameters;
  }

  if (parameters.isEmpty) {
    if (state.extra != null && state.extra is Map) {
      var extra = state.extra as Map<String, String>;
      if (extra.containsKey('code') && extra['code']!.length == 6) {
        var code = int.tryParse(extra['code']!);
        if (extra.containsKey('name') && extra['name']!.isNotEmpty) {
          name = extra['name']!;
        }
        if (code != null) {
          return EditFriendDialog(
            friend: Friend(name: name, friendId: -1, requestId: code),
            action: FriendsAction.addWithCode,
          );
        }
      }
    }
  }
  if (parameters.containsKey('code') && parameters['code']!.length == 6) {
    var code = int.tryParse(parameters['code']!);
    if (parameters.containsKey('name') && parameters['name']!.isNotEmpty) {
      name = parameters['name']!;
    }
    if (code != null) {
      return EditFriendDialog(
        friend: Friend(name: name, friendId: -1, requestId: code),
        action: FriendsAction.addWithCode,
      );
    } else {
      return EditFriendDialog(
          friend: Friend(
            name: name,
            friendId: -1,
          ),
          action: FriendsAction.addWithCode);
    }
  } else if (parameters.containsKey('code') &&
      parameters['code']!.length > 6 &&
      parameters['code']!.contains('&')) {
    var parts = parameters['code']!.split('&');
    if (parts.length != 2) {
      return EditFriendDialog(
        friend: Friend(name: name, friendId: -1),
        action: friendsAction,
      );
    } else {
      var code = int.tryParse(parameters['code']!);
      if (code != null) {
        if (parameters.containsKey('name') && parameters['name']!.isNotEmpty) {
          name = parameters['name']!;
        }
        return EditFriendDialog(
          friend: Friend(name: name, friendId: -1, requestId: code),
          action: FriendsAction.addWithCode,
        );
      } else {
        return EditFriendDialog(
            friend: Friend(
              name: name,
              friendId: -1,
            ),
            action: FriendsAction.addWithCode);
      }
    }
  }
  return EditFriendDialog(
    friend: Friend(name: name, friendId: -1),
    action: friendsAction,
  );
}
