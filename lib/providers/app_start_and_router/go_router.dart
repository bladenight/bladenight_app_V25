import 'package:flutter/foundation.dart';

import '../../main.dart';
import '../../models/friend.dart';
import '../../observers/go_router_observer.dart';
import '../../pages/events/events_page.dart';
import '../../pages/friends/widgets/friends_action_sheet.dart';
import '../../pages/home_info/home_page.dart';
import '../../pages/map/map_page.dart';
import '../../pages/settings/settings_page.dart';
import '../../pages/widgets/main_app_widget.dart';
import '../../pages/widgets/route_name_dialog.dart';
import '../../pages/widgets/startup_widgets/app_start_error_widget.dart';
import 'app_start_notifier.dart';
import '../../navigation/scaffold_with_nested_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';

import '../../pages/bladeguard/bladeguard_page.dart';
import '../../pages/friends/friends_page.dart';
import '../../pages/friends/widgets/edit_friend_dialog.dart';
import '../../pages/home_screen.dart';
import '../../pages/messages/messages_page.dart';

part 'go_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
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
  home,
  map,
  events,
  friend,
  settings,
  showRouteDetails,
  onboarding,
  signIn,
  addFriend,
  addFriendWithCode,
  message,
  messages,
  bladeguard,
  showRoute
}

@riverpod
GoRouter goRouter(Ref ref) {
  return GoRouter(
    observers: [
      // Add your navigator observers
      GoRouterNavigatorObserver(),
    ],
    initialLocation: '/home',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
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
          child: ScaffoldWithNestedNavigation(navigationShell: navigationShell),
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
                builder: (BuildContext context, GoRouterState state) =>
                    const HomePage(),
                routes: <RouteBase>[
                  // The details screen to display stacked on navigator of the
                  // first tab. This will cover screen A but not the application
                  // shell (bottom navigation bar).
                  GoRoute(
                    name: AppRoute.messages.name,
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
                  pageBuilder: (context, state) {
                    print('friendroute ');
                    print(state.pathParameters);
                    return NoTransitionPage(
                      child: FriendsPage(),
                    );
                  },
                  routes: [
                    GoRoute(
                        path: 'addfriend/:query',
                        name: AppRoute.addFriend.name,
                        parentNavigatorKey: _rootNavigatorKey,
                        pageBuilder: (context, state) {
                          var friendsAction = FriendsAction.addNew;
                          var parameters = state.pathParameters;
                          if (parameters.containsKey('code') &&
                              parameters['code']!.length == 6) {
                            friendsAction = FriendsAction.addWithCode;
                          }
                          print('EditFriendDialogStatus ');
                          print(state.pathParameters);
                          return CupertinoPage(
                            fullscreenDialog: true,
                            child: EditFriendDialog(
                              friend: Friend(name: '', friendId: -1),
                              action: friendsAction,
                            ),
                          );
                        },
                        routes: [
                          GoRoute(
                            path: '/:code',
                            name: 'code',
                            parentNavigatorKey: _rootNavigatorKey,
                            pageBuilder: (context, state) {
                              print('EditFriendDialogStatus code');
                              print(state.pathParameters);
                              return CupertinoPage(
                                fullscreenDialog: true,
                                child: EditFriendDialog(
                                  friend: Friend(name: '', friendId: -1),
                                  action: FriendsAction.addNew,
                                ),
                              );
                            },
                          )
                        ]),
                    GoRoute(
                      path: 'addfriendwithcode',
                      name: AppRoute.addFriendWithCode.name,
                      parentNavigatorKey: _rootNavigatorKey,
                      pageBuilder: (context, state) {
                        print('EditFriendDialogStatus ');
                        print(state.pathParameters);
                        return CupertinoPage(
                          fullscreenDialog: true,
                          child: EditFriendDialog(
                            friend: Friend(name: '', friendId: -1),
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
              ),
            ],
          ),
        ],
      ),
    ],
    errorPageBuilder: (context, state) => NoTransitionPage(
      child: AppStartErrorWidget(
          message: state.error!.message.toString(),
          onRetry: () =>
              {ref.refresh(appStartNotifierProvider.notifier).retry()}),
    ),
  );
}
