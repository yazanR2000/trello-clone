import 'package:app/res/components.dart';
import 'package:app/view_model/auth_view_model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../res/colors.dart';
import '../../view_model/project_view_model.dart';
import 'card.dart';
import 'edit_list_drop_down.dart';

class PageViewCards extends StatefulWidget {
  final List<Map<String, dynamic>>? boardLists;
  const PageViewCards({this.boardLists});

  @override
  State<PageViewCards> createState() => _PageViewCardsState();
}

class _PageViewCardsState extends State<PageViewCards> {
  PageController? _pageController;
  final TextEditingController _controller = TextEditingController();
  bool loading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final double width = MediaQuery.of(context).size.width;
      if (width <= 1080) {
        _pageController = PageController(viewportFraction: 0.8);
      } else {
        _pageController =
            PageController(initialPage: 0, viewportFraction: 0.32);
      }
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  bool checkCardMembers(BuildContext context,int cardId) {
    final myCards = Provider.of<AuthViewModel>(context,listen: false).myCards;
    int index = myCards.indexWhere((element) => element['listcardId'] == cardId);
    if(index != -1){
      return true;
    }
    //Components.showErrorSnackBar(context, text: text)
    return false;
  } 

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final projectProvider =
        Provider.of<ProjectViewModel>(context, listen: false);
    final currentUser = Provider.of<AuthViewModel>(context, listen: false).user;
    return loading
        ? Center(
            child: ProgressRing(),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 10),
            child: PageView.builder(
              padEnds: false,
              controller: _pageController,
              itemCount: widget.boardLists!.length + 1,
              itemBuilder: (context, index) {
                if (index == widget.boardLists!.length) {
                  return Container(
                    // width: MediaQuery.of(context).size.width * 0.3,
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
                        data['content']['id']);
                  },
                  onAcceptWithDetails: (details) {
                    // print(width);
                    // print("data dx: ${details.offset.dx}");
                  },
                  onWillAccept: (data) {
                    return true;
                  },
                  onMove: (details) {
                    double dx = details.offset.dx;
                    if (dx > width / 2) {
                      _pageController!.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.linear,
                      );
                    } else if (dx < 10) {
                      _pageController!.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.linear,
                      );
                    }
                  },
                  builder: (context, candidateData, rejectedData) => Container(
                    margin: const EdgeInsets.only(right: 20, bottom: 10),
                    height: double.infinity,
                    // width: width * 0.3,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // color: Colors.white,
                      color: CustomColors.listBackgroundColor,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.boardLists![index]['name'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            if (currentUser!['role'] == 'Admin')
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
                              itemBuilder: (context, i) => checkCardMembers(context,widget.boardLists![index]['cards']
                                      [i]['id']) ? LongPressDraggable(
                                data: {
                                  "content": widget.boardLists![index]['cards']
                                      [i],
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
                                      color: Color.fromARGB(255, 222, 221, 219),
                                    ),
                                  ),
                                ),
                                feedback: SizedBox(
                                  width: width <= 1080
                                      ? width * 0.77
                                      : width * 0.25,
                                  child: CardW(
                                    content: widget.boardLists![index]['cards']
                                        [i],
                                  ),
                                ),
                                child: CardW(
                                  content: widget.boardLists![index]['cards']
                                      [i],
                                  listId: widget.boardLists![index]['id'],
                                  isForMe: true,
                                ),
                              ) : GestureDetector(
                                onLongPress: (){
                                  Components.showErrorSnackBar(context, text: "You don't have access to move this card");
                                },
                                child: CardW(
                                    content: widget.boardLists![index]['cards']
                                        [i],
                                    listId: widget.boardLists![index]['id'],
                                  ),
                              ),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 20),
                              itemCount:
                                  widget.boardLists![index]['cards'].length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }
}
