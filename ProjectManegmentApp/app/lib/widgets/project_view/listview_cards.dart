import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mt;
import 'package:provider/provider.dart';

import '../../res/colors.dart';
import '../../view_model/project_view_model.dart';
import 'card.dart';
import 'edit_list_drop_down.dart';

class ListViewCards extends StatefulWidget {
  final List<Map<String, dynamic>>? boardLists;
  const ListViewCards({this.boardLists});

  @override
  State<ListViewCards> createState() => _ListViewCardsState();
}

class _ListViewCardsState extends State<ListViewCards> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final projectProvider =
        Provider.of<ProjectViewModel>(context, listen: false);
    return ListView.separated(
      controller: _scrollController,
      separatorBuilder: (context, index) => const SizedBox(
        width: 20,
      ),
      padding: const EdgeInsets.all(20),
      scrollDirection: Axis.horizontal,
      itemCount: widget.boardLists!.length + 1,
      itemBuilder: (context, index) {
        if (index == widget.boardLists!.length) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.3,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              // color: CustomColors.listBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              // mainAxisSize: MainAxisSize.max,

              children: [
                TextBox(
                  controller: _controller,
                  placeholder: "List name",
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          if (_controller.text.isNotEmpty) {
                            await Provider.of<ProjectViewModel>(context,
                                    listen: false)
                                .addNewList(_controller.text);
                            _controller.clear();
                          }
                        },
                        child: const Text("Add list"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return DragTarget<Map<String, dynamic>>(
          onAccept: (data) async {
            await projectProvider.moveCardToNewList(
              widget.boardLists![index]['id'],
              data['listId'],
              data['content']['id'],
            );
          },
          onAcceptWithDetails: (details) {
            // print(details.data);
          },
          onWillAccept: (data) {
            return true;
          },
          onMove: (details) {
            print(width);
            print(details.offset.dx);
            double dx = details.offset.dx;
            double scrollDx = _scrollController.position.viewportDimension - dx;
            print(scrollDx);
            if (scrollDx < 400) {
              _scrollController.animateTo(
                dx,
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
              );
            }
            // }else{

            // }
            // if (dx < 50) {
            //   _scrollController.animateTo(
            //     dx,
            //     duration: const Duration(milliseconds: 300),
            //     curve: Curves.linear,
            //   );
            // }
          },
          builder: (context, candidateData, rejectedData) => Container(
            // color: mt.Colors.white,
            height: double.infinity,
            width: width * 0.3,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // color: CustomColors.listBackgroundColor,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.boardLists![index]['name']),
                    EditList(
                      index: index,
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(scrollbars: false),
                    child: ListView.separated(
                      // reverse: true,
                      //shrinkWrap: true,
                      itemBuilder: (context, i) => LongPressDraggable(
                        data: {
                          "content": widget.boardLists![index]['cards'][i],
                          "listIndex": index,
                          "itemIndex": i,
                          "listId": widget.boardLists![index]['id']
                        },
                        childWhenDragging: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Color.fromARGB(255, 222, 221, 219)),
                          ),
                        ),
                        feedback: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: CardW(
                            content: widget.boardLists![index]['cards'][i],
                          ),
                        ),
                        child: CardW(
                          content: widget.boardLists![index]['cards'][i],
                          listId: widget.boardLists![index]['id'],
                        ),
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 20),
                      itemCount: widget.boardLists![index]['cards'].length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
