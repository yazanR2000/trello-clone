import 'package:app/view_model/auth_view_model.dart';
import 'package:app/view_model/project_view_model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../../res/components.dart';

class NewUser extends StatefulWidget {
  NewUser({super.key});

  @override
  State<NewUser> createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  late Future _allUsers;
  @override
  void initState() {
    _allUsers =
        Provider.of<ProjectViewModel>(context, listen: false).getAllUsers();
    super.initState();
  }

  // final List<Map<String,dynamic>> _checkedUsers = [];
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final projectProvider =
        Provider.of<ProjectViewModel>(context, listen: false);
    return FutureBuilder(
      future: _allUsers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: ProgressRing(),
          );
        }
        final List<dynamic> users = snapshot.data as List<dynamic>;
        return Users(
          users: users,
          boardId: projectProvider.boardId,
        );
      },
    );
  }
}

class Users extends StatefulWidget {
  final List<dynamic>? users;
  final String? boardId;
  const Users({this.users, this.boardId});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final List<Map<String, dynamic>> _checkedUsers = [];
  final List<String> _roles = ["Admin", "Member", "Observer"];

  @override
  void initState() {
    widget.users!.forEach((element) {
      _checkedUsers.add({"checked": false, "role": 0});
    });
    super.initState();
  }

  Future _addMembers(List<Map<String, dynamic>> users,BuildContext context) async {
    await Provider.of<ProjectViewModel>(context, listen: false)
        .addBoardMembers(users,context);
   
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const TextBox(
            placeholder: "Search",
            suffix: Icon(FluentIcons.search),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: AnimationLimiter(
              child: GridView.builder(
                //padding: const EdgeInsets.all(20),
                itemCount: widget.users!.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300.0,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                ),
                itemBuilder: (context, index) {
                  Map<String, dynamic> singleUser = widget.users![index];
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    columnCount: (index / widget.users!.length).floor(),
                    child: ScaleAnimation(
                      child: FadeInAnimation(
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Checkbox(
                                    checked: _checkedUsers[index]['checked'],
                                    onChanged: (v) {
                                      setState(() {
                                        _checkedUsers[index]['checked'] = v;
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(singleUser['name']),
                                ],
                              ),
                              if (_checkedUsers[index]['checked'])
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(_roles.length, (i) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RadioButton(
                                          content: Text(_roles[i]),
                                          checked: _checkedUsers[index]
                                                  ['role'] ==
                                              _roles[i],
                                          onChanged: (checked) {
                                            //print(_checkedUsers[index]['role']);
                                            setState(
                                              () => _checkedUsers[index]
                                                  ['role'] = _roles[i],
                                            );
                                          }),
                                    );
                                  }),
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton(
                    child: const Text("Done"),
                    onPressed: () async {
                      final List<Map<String, dynamic>> users = [];
                      for (int i = 0; i < _checkedUsers.length; i++) {
                        if (_checkedUsers[i]['checked']) {
                          widget.users![i].putIfAbsent(
                              "userBoardRole", () => _checkedUsers[i]['role']);
                          widget.users![i]
                              .putIfAbsent("boardId", () => widget.boardId!);
                          widget.users![i]
                              .putIfAbsent("userId", () => widget.users![i]['id']);
                          users.add(widget.users![i]);
                        }
                      }
                      await _addMembers(users,context);
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
