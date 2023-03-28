import 'package:app/view_model/auth_view_model.dart';
import 'package:app/views/project_view.dart';
import 'package:app/widgets/auth/new_user.dart';
import 'package:fluent_ui/fluent_ui.dart';

import 'package:provider/provider.dart';

import '../view_model/home_view_model.dart';
import 'auth_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);
  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AuthViewModel>(context, listen: false).user;
    print(currentUser);
    return Consumer<HomeViewModel>(
      builder: (BuildContext context, HomeViewModel homeProvider, _) {
        return NavigationView(
          appBar: const NavigationAppBar(
            automaticallyImplyLeading: false,
            //title:const  Text("Home"),
          ),
          pane: NavigationPane(
            selected: homeProvider.pageIndex,
            onChanged: (int value) {
              homeProvider.setPageIndex = value;
            },
            displayMode: PaneDisplayMode.top,
            items: [
              PaneItemExpander(
                items: [
                  PaneItem(
                    icon: const Icon(FluentIcons.mail),
                    title: const Text('Project 1'),
                    body: Project(),
                  ),
                  PaneItem(
                    icon: const Icon(FluentIcons.calendar),
                    title: const Text('Project 2'),
                    body: Project(),
                  ),
                ],
                icon: const Icon(FluentIcons.project_collection),
                title: const Text('Projects'),
                body: const Project(),
              ),
              PaneItem(
                icon: const Icon(FluentIcons.settings),
                title: const Text('Settings'),
                body: Container(),
              ),
              PaneItem(
                icon: const Icon(FluentIcons.help),
                title: const Text('Help'),
                body: Container(),
              ),
              if (currentUser!['role'] == "Admin")
                PaneItem(
                  icon: const Icon(FluentIcons.add_friend),
                  title: const Text('Add user'),
                  body: NewUser(),
                ),
              PaneItem(
                icon: const Icon(FluentIcons.sign_out),
                title: const Text('Logout'),
                body: Container(),
                onTap: () async {
                  // print("yazan");
                  // Navigator.of(context).pop();
                  homeProvider.setPageIndex = 0;
                  await homeProvider.logOut(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
