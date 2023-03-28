import 'package:app/res/colors.dart';
import 'package:app/view_model/project_view_model.dart';
import 'package:flutter/material.dart' as mt;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

class EditList extends StatelessWidget {
  final int? index;
  const EditList({this.index});

  @override
  Widget build(BuildContext context) {
    return DropDownButton(
      title: const Text('Edit'),
      items: [
        if (index == 0)
          MenuFlyoutItem(
            text: const Text('Add new card'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => ContentDialog(content: AddNewCard()),
              );
            },
            leading: const Icon(FluentIcons.add),
          ),
        MenuFlyoutItem(
          text: const Text('Change list name'),
          onPressed: () {},
          leading: const Icon(FluentIcons.edit),
        ),
        MenuFlyoutItem(
          text: const Text('Move all cards to this list'),
          onPressed: () async {
            final projectProvider =
                Provider.of<ProjectViewModel>(context, listen: false);
            await projectProvider.moveAllCardsToThisList(
                projectProvider.boardLists[index!]['id']);
          },
          leading: const Icon(FluentIcons.move),
        ),
      ],
    );
  }
}

class AddNewCard extends mt.StatefulWidget {
  AddNewCard({super.key});

  @override
  mt.State<AddNewCard> createState() => _AddNewCardState();
}

class _AddNewCardState extends mt.State<AddNewCard> {
  final formKey = GlobalKey<FormState>();

  String addZeroOrNot(int num){
    return num > 10 ? num.toString() : '0$num';
  }

  void _addCard() async {
    if (formKey.currentState!.validate()) {
      // print(selectedTime);
      // print(selectedDate);
      if (selectedTime != null && selectedDate != null) {
        // ignore: prefer_interpolation_to_compose_strings
        final String date ="${selectedDate!.year}" +
            '-' +
            addZeroOrNot(selectedDate!.month) +
            '-' +
             addZeroOrNot(selectedDate!.day) + " " +
             addZeroOrNot(selectedTime!.hour) +
            ':' +
             addZeroOrNot(selectedTime!.minute) +
            ":" +
            addZeroOrNot(selectedTime!.second);
        // print(date);
        _cardValues['dueDate'] = date;
      }
      formKey.currentState!.save();

      await Provider.of<ProjectViewModel>(context, listen: false).addListCard(
          _cardValues['content'], _cardValues['label'],_cardValues['dueDate'], cardUsers, context);
      Navigator.of(context).pop();
    }
  }

  final List<Map<String, dynamic>> cardUsers = [];

  final Map<String, dynamic> _cardValues = {
    "content": "",
    "label": "",
    "dueDate": ""
  };
  DateTime? selectedTime;
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final boardMembers =
        Provider.of<ProjectViewModel>(context, listen: false).boardMembers;
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormBox(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please add the content of the task";
              }
              return null;
            },
            //header: 'Enter your name:',
            placeholder: 'What is the task ?',
            //expands: false,
            minHeight: 100,
            expands: true,
            minLines: null,
            maxLines: null,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            onSaved: (newValue) {
              _cardValues['content'] = newValue;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormBox(
            placeholder: 'Label',
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            onSaved: (newValue) {
              _cardValues['label'] = newValue;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Divider(),
          const SizedBox(
            height: 10,
          ),
          const Text("Members"),
          const SizedBox(
            height: 5,
          ),
          ListView.builder(
            itemCount: cardUsers.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => ListTile(
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    cardUsers.removeAt(index);
                  });
                },
                icon: Icon(
                  FluentIcons.chrome_minimize,
                  color: Colors.red,
                ),
              ),
              title: Text(cardUsers[index]['name']),
            ),
          ),
          AutoSuggestBox<dynamic>(
            placeholder: "Add user to card",
            items: boardMembers!
                .map<AutoSuggestBoxItem<dynamic>>(
                  (cat) => AutoSuggestBoxItem<dynamic>(
                    value: cat,
                    label: cat['name'],
                    onFocusChange: (focused) {
                      if (focused) {
                        debugPrint('Focused #${cat['id']} - ${cat['name']}');
                      }
                    },
                  ),
                )
                .toList(),
            onSelected: (item) {
              setState(() {
                int index = cardUsers
                    .indexWhere((element) => element['id'] == item.value['id']);
                if (index == -1) {
                  cardUsers.add(item.value!);
                }
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          //const Text("Due date"),
          const SizedBox(
            height: 10,
          ),
          TimePicker(
            selected: selectedTime,
            onChanged: (time) => setState(() => selectedTime = time),
            header: 'Due time',
            minuteIncrement: 15,
          ),
          const SizedBox(
            height: 10,
          ),
          DatePicker(
            selected: selectedDate,
            header: "Due date",
            onChanged: (time) => setState(() => selectedDate = time),
            //showYear: false,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: mt.ElevatedButton(
                  style: mt.ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text("Done"),
                  onPressed: () {
                    _addCard();
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: mt.TextButton(
                  style: mt.TextButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    backgroundColor: CustomColors.cardBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class Cat {
  final int id;
  final String name;
  final bool hasTag;

  const Cat(this.id, this.name, this.hasTag);
}
