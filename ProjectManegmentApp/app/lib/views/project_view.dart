import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mt;
import '../res/colors.dart';
import '../widgets/project_view/board_details.dart';

class Project extends StatelessWidget {
  const Project({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      // color: CustomColors.background,
      child: Row(
        children: [
          const Expanded(
            flex: 4,
            child: BoardDetails(),
          ),
          if (MediaQuery.of(context).size.width > 700)
            Container(
              height: double.infinity,
              child: const mt.VerticalDivider(
                  // color: Colors.black,
                  // thickness: 0.1,
                  // width: 0.1,
                  ),
            ),
          if (MediaQuery.of(context).size.width > 700)
            Expanded(
              child: Container(),
            )
        ],
      ),
    );
  }
}
