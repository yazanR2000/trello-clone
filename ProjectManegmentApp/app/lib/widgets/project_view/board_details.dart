import 'dart:ui';

import 'package:app/res/colors.dart';
import 'package:app/view_model/auth_view_model.dart';
import 'package:app/view_model/project_view_model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mt;
import 'package:provider/provider.dart';

import 'card.dart';
import 'edit_list_drop_down.dart';
import 'listview_cards.dart';
import 'pageview_cards.dart';

class BoardDetails extends StatefulWidget {
  const BoardDetails({super.key});

  @override
  State<BoardDetails> createState() => _BoardDetailsState();
}

class _BoardDetailsState extends State<BoardDetails> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final projectViewModel =
          Provider.of<ProjectViewModel>(context, listen: false);
      if (projectViewModel.newFetch!) {
        await Provider.of<ProjectViewModel>(context, listen: false)
            .getBoardData();
      }
      await Provider.of<AuthViewModel>(context,listen: false).getMyCards();
    });
    super.initState();
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return ScaffoldPage(
      content: Consumer<ProjectViewModel>(
        builder: (context, project, _) {
          if (project.isLoading) {
            return const Center(
              child: mt.CircularProgressIndicator(),
            );
          }
          return ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              overscroll: true,
              dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
            ),
            child: PageViewCards(
                    boardLists: project.boardLists,
                  ),
            // child: width > 800
            //     ? ListViewCards(
            //         boardLists: project.boardLists,
            //       )
            //     : PageViewCards(
            //         boardLists: project.boardLists,
            //       ),
          );
        },
      ),
    );
  }
}








