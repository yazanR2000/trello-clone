import 'dart:math';

import 'package:app/models/project_model.dart';
import 'package:app/res/components.dart';
import 'package:app/view_model/project_view_model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../res/colors.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

class CardW extends StatelessWidget {
  final Map<String, dynamic>? content;
  final int? listId;
  bool? isForMe;
  CardW({this.content, this.listId,this.isForMe = false});

  final f = DateFormat('yyyy-MM-dd hh:mm');

  @override
  Widget build(BuildContext context) {
    return Card(
      borderRadius: BorderRadius.circular(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: CustomColors.label),
                    child: content!['label'] == null
                        ? const SizedBox()
                        : Text(
                            content!['label'],
                            style: const TextStyle(
                              color: CustomColors.primary,
                            ),
                          ),
                  ),
                  if(isForMe!)
                    const SizedBox(width: 10,),
                  if(isForMe!)
                    const Icon(FluentIcons.d365_talent_insight),
                ],
              ),
              // Spacer(),
              DropDownButton(
                title: const Text('Edit card'),
                items: [
                  MenuFlyoutItem(
                    text: const Text('Edit members'),
                    onPressed: () {},
                  ),
                  MenuFlyoutItem(
                    text: const Text('Delete card'),
                    onPressed: () async {
                      await Provider.of<ProjectViewModel>(context,
                              listen: false)
                          .deleteCard(
                        content!['id'],
                        listId!,
                      );
                    },
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            content!['content'],
            style: TextStyle(height: 1.5),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ToggleButton(
                child: Text("${f.format(DateTime.parse(content!['dueDate']))}"),
                checked: true,
                onChanged: (value) {},
              ),
              CardMembers(
                cardId: content!['id'],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class CardMembers extends StatefulWidget {
  final int? cardId;
  const CardMembers({this.cardId});

  @override
  State<CardMembers> createState() => _CardMembersState();
}

class _CardMembersState extends State<CardMembers> {
  late Future _cardMembers;
  @override
  void initState() {
    _cardMembers = Provider.of<ProjectViewModel>(context, listen: false)
        .getCardMembers(widget.cardId!);
    print("object");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _cardMembers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ProgressRing();
        }
        final cardUsers = snapshot.data['data'] as List<dynamic>;
        //print(cardUsers);
        return Container(
          width: 100,
          height: 30,
          child: Stack(
            children: List.generate(cardUsers.length, (index) {
              return Positioned(
                right: index * 20,
                child: CircleAvatar(
                  backgroundColor:
                      Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                          .withOpacity(0.8),
                  radius: 15,
                  child: Text(cardUsers[index]['user']['name'][0]
                      .toString()
                      .toUpperCase()),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
