import '../../main.dart';
import '../../models/friend.dart';
import '../../observers/go_router_observer.dart';
import '../../pages/friends/widgets/friends_action_sheet.dart';
import '../../pages/widgets/main_app_widget.dart';
import '../../pages/widgets/route_name_dialog.dart';
import '../../pages/widgets/startup_widgets/app_start_error_widget.dart';
import 'app_start_notifier.dart';
import 'scaffold_with_nested_navigation.dart';
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
final _friendsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'friend');
final _messageLinkNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'appLink');
final _bladeguardNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'bladeguard');
final _showRouteNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'showRoute');

enum AppRoute {
  home,
  onboarding,
  signIn,
  friend,
  addFriend,
  addFriendWithCode,
  message,
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
        path: '/home',
        name: AppRoute.home.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: MainAppWidget(),
        ),
      ),
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
        branches: [
          StatefulShellBranch(
            navigatorKey: _friendsNavigatorKey,
            routes: [
              //no locale
              GoRoute(
                path: '/message',
                name: AppRoute.message.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: MessagesPage(),
                ),
              ),
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
                      path: 'addfriend/:name',
                      name: AppRoute.addFriend.name,
                      parentNavigatorKey: _rootNavigatorKey,
                      pageBuilder: (context, state) {
                        print('EditFriendDialogStatus ');
                        print(state.pathParameters);
                        return CupertinoPage(
                          fullscreenDialog: true,
                          child: EditFriendDialog(
                            friend: Friend(name: '', friendId: -1),
                            action: FriendsAction.addNew,
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
            navigatorKey: _bladeguardNavigatorKey,
            routes: [
              GoRoute(
                path: '/bladeguard',
                name: AppRoute.bladeguard.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: BladeGuardPage(),
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
