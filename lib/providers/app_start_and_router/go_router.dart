import 'package:flutter/foundation.dart';
import 'package:go_transitions/go_transitions.dart';

import '../../helpers/export_import_data_helper.dart';
import '../../main.dart';
import '../../models/event.dart';
import '../../models/friend.dart';
import '../../models/user_gpx_point.dart';
import '../../observers/go_router_observer.dart';
import '../../pages/admin/admin_page.dart';
import '../../pages/events/events_page.dart';
import '../../pages/events/widgets/event_editor.dart';
import '../../pages/friends/widgets/friends_action_sheet.dart';
import '../../pages/friends/widgets/nearby_widget.dart';
import '../../pages/home_info/home_page.dart';
import '../../pages/map/map_page.dart';
import '../../pages/map/widgets/qr_create_page.dart';
import '../../pages/settings/settings_page.dart';
import '../../pages/widgets/intro_slider.dart';
import '../../pages/widgets/route_dialog.dart';
import '../../pages/widgets/route_name_dialog.dart';
import '../../pages/widgets/startup_widgets/app_route_error_widget.dart';
import '../../pages/widgets/user_tracking_dialog.dart';
import '../settings/server_pwd_provider.dart';
import '../../navigation/scaffold_with_nested_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';

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
    GlobalKey<NavigatorState>(debugLabel: 'appLink');
final _bladeguardNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'bladeguard');
final _showRouteNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'showRoute');

enum AppRoute {
  aboutPage,

  /// required pathParameters password
  adminPage,
  home,
  map,
  events,

  ///required extra Event
  eventEditorPage,
  friend,
  settings,
  showRouteDetails,
  showEventRouteDetails,
  onboarding,
  signIn,
  addFriend,
  addFriendWithCode,
  message,
  messagesPage,
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
      GoRouterNavigatorObserver(),
    ],
    initialLocation: '/home',
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(

          ///qrCreatePage?infoText=24566&headerText=567&qrCodeText=132435
          path: '/qrCreatePage',
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
          path: '/eventEditorPage',
          name: AppRoute.eventEditorPage.name,
          pageBuilder: (context, state) {
            var event = state.extra as Event;
            return NoTransitionPage(
              child: EventEditor(event: event),
            );
          }),

      GoRoute(
        path: '/signIn',
        name: AppRoute.signIn.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: BladeGuardPage(),
        ),
      ),
      GoRoute(
        path: '/showRoute/:name',
        pageBuilder: (context, state) => NoTransitionPage(
          child: RouteNameDialog(routeName: state.pathParameters['name']!),
        ),
      ),

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
                  path: '/home',
                  builder: (BuildContext context, GoRouterState state) {
                    var queryParameters = state.uri.queryParameters;
                    if (queryParameters.containsKey('data')) {
                      importData(context, queryParameters.toString());
                    }

                    return const HomePage();
                  },
                  routes: <RouteBase>[
                    // The details screen to display stacked on navigator of the
                    // first tab. This will cover screen A but not the application
                    // shell (bottom navigation bar).
                    GoRoute(
                      name: AppRoute.messagesPage.name,
                      path: 'messages',
                      builder: (BuildContext context, GoRouterState state) =>
                          const MessagesPage(),
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
                path: '/map',
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
                      path: '/events',
                      name: AppRoute.events.name,
                      pageBuilder: (context, state) {
                        return NoTransitionPage(
                          child: EventsPage(),
                        );
                      },
                      routes: [
                        GoRoute(
                          path: 'showRoute/:name',
                          name: AppRoute.showRouteDetails.name,
                          pageBuilder: (context, state) => NoTransitionPage(
                            child: RouteNameDialog(
                                routeName: state.pathParameters['name']!),
                          ),
                        ),
                        GoRoute(
                          path: 'showRoute',
                          name: AppRoute.showEventRouteDetails.name,
                          pageBuilder: (context, state) => NoTransitionPage(
                            child: RouteDialog(event: state.extra as Event),
                          ),
                        ),
                      ]),
                ]),
            if (!kIsWeb)
              StatefulShellBranch(
                navigatorKey: _friendsNavigatorKey,
                routes: [
                  //no locale
                  GoRoute(
                    path: '/friend',
                    name: AppRoute.friend.name,
                    builder: (context, state) {
                      var parameters = state.uri.queryParameters;
                      return FriendsPage();
                    },
                    pageBuilder: GoTransitions.fade.withBackGesture.call,
                  ),
                  GoRoute(
                    // const LinkFriendDevicePage(deviceType: DeviceType.advertiser,
                    //                            friendsAction: FriendsAction.addNearby,
                    path: '/linkFriendDevicePage',
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
                    routes: [
                      GoRoute(
                          //"/sample?id1=$param1&id2=$param2");
                          path: 'addfriend/:query',
                          name: AppRoute.addFriend.name,
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder: (context, state) {
                            var friendsAction = FriendsAction.addNew;
                            var name = '';
                            var parameters = state.pathParameters;
                            if (parameters.containsKey('code') &&
                                parameters['code']!.length == 6) {
                              friendsAction = FriendsAction.addWithCode;
                            }
                            if (parameters.containsKey('name') &&
                                parameters['name']!.length > 1) {
                              name = parameters['name']!;
                            }
                            print('EditFriendDialogStatus ');
                            print(state.pathParameters);
                            return CupertinoPage(
                              fullscreenDialog: true,
                              child: EditFriendDialog(
                                friend: Friend(name: name, friendId: -1),
                                action: friendsAction,
                              ),
                            );
                          },
                          routes: [
                            GoRoute(
                              path: '/:code',
                              name: 'code',
                              parentNavigatorKey: rootNavigatorKey,
                              pageBuilder: (context, state) {
                                var friendsAction = FriendsAction.addNew;
                                var name = '';
                                var parameters = state.pathParameters;
                                if (parameters.containsKey('code') &&
                                    parameters['code']!.length == 6) {
                                  friendsAction = FriendsAction.addWithCode;
                                }
                                if (parameters.containsKey('name') &&
                                    parameters['name']!.length > 1) {
                                  name = parameters['name']!;
                                }
                                print('EditFriendDialogStatus code');
                                print(state.pathParameters);
                                return CupertinoPage(
                                  fullscreenDialog: true,
                                  child: EditFriendDialog(
                                    friend: Friend(name: name, friendId: -1),
                                    action: FriendsAction.addNew,
                                  ),
                                );
                              },
                            )
                          ]),
                      GoRoute(
                        path: 'addfriendwithcode',
                        name: AppRoute.addFriendWithCode.name,
                        parentNavigatorKey: rootNavigatorKey,
                        pageBuilder: (context, state) {
                          var friendsAction = FriendsAction.addNew;
                          var name = '';
                          var parameters = state.pathParameters;
                          if (parameters.containsKey('code') &&
                              parameters['code']!.length == 6) {
                            friendsAction = FriendsAction.addWithCode;
                          }
                          if (parameters.containsKey('name') &&
                              parameters['name']!.length > 1) {
                            name = parameters['name']!;
                          }
                          print('EditFriendDialogStatus ');
                          print(state.pathParameters);
                          return CupertinoPage(
                            fullscreenDialog: true,
                            child: EditFriendDialog(
                              friend: Friend(name: name, friendId: -1),
                              action: FriendsAction.addWithCode,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            StatefulShellBranch(
                navigatorKey: _sectionSettingsNavigatorKey,
                routes: [
                  GoRoute(
                    path: '/settings',
                    name: AppRoute.settings.name,
                    pageBuilder: (context, state) => const NoTransitionPage(
                      child: SettingsPage(),
                    ),
                    routes: [
                      GoRoute(
                        path: '/${AppRoute.bladeguard.name}',
                        name: AppRoute.bladeguard.name,
                        builder: (context, state) => BladeGuardPage(),
                        pageBuilder: GoTransitions.slide.withBackGesture.call,
                      ),
                      GoRoute(
                          path: '/${AppRoute.userTrackDialog.name}',
                          name: AppRoute.userTrackDialog.name,
                          pageBuilder: GoTransitions.dialog,
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
                          pageBuilder: (context, state) {
                            var pathParameters = state.pathParameters;
                            return NoTransitionPage(child: IntroScreen());
                          }),
                      GoRoute(
                          path: '/adminPage',
                          name: AppRoute.adminPage.name,
                          redirect:
                              (BuildContext context, GoRouterState state) {
                            if (!ref.read(serverPwdSetProvider)) {
                              return '/home';
                            } else {
                              return null;
                            }
                          },
                          pageBuilder: (context, state) {
                            var pathParameters = state.pathParameters;
                            return NoTransitionPage(
                              child: AdminPage(
                                  password: pathParameters['password']!),
                            );
                          }),
                    ],
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

/* redirect: (context, state) {
      try {
        final isLoading = userState!.subscription.maybeMap(
          loading: (_) => true,
          orElse: () => false,
        );
        if (isLoading) {
          return '/loading';
        }
        if (!userState.subscription.isActive && state.matchedLocation == '/') {
          debugPrint("Redirect to premium from (${state.matchedLocation})");
          return '/premium';
        }
      } catch (e) {
        debugPrint("Error in redirect: $e");
      }
      return null;
    },
  );
});*/
