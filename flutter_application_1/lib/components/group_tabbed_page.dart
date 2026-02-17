
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/group.dart';
import 'package:flutter_application_1/pages/group_page.dart';
import 'package:flutter_application_1/pages/randomize_page.dart';

class GroupTabbedPage extends StatefulWidget {
  const GroupTabbedPage({required this.groupPageModel, super.key});
  final Group groupPageModel;

  @override
  State<GroupTabbedPage> createState() => _GroupTabbedPageState();
}

class _GroupTabbedPageState extends State<GroupTabbedPage> {
  late Group groupHere;
  int _selectedIndex = 0;

  late GroupPage _groupPage;
  late RandomizePage _randomizePage;

  @override
  void initState() {
    super.initState();
    groupHere = widget.groupPageModel;

      _groupPage = GroupPage(
        groupHome: groupHere,
        onGroupUpdate: _updateGroup,
      );

      _randomizePage = RandomizePage(groupModel: groupHere);
  }

  Future<void> _onItemTapped(int index) async {
    if (index == _selectedIndex) return;
    FocusManager.instance.primaryFocus?.unfocus(); // Dismiss keyboard if open
    setState(() {
      _selectedIndex = index;
    });
  }

  void _updateGroup(Group updatedGroup) {
    setState(() {
      groupHere = updatedGroup;
      _randomizePage = RandomizePage(
        key: UniqueKey(), // Ensure the page rebuilds with new data
        groupModel: groupHere
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pop(context, groupHere);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            _groupPage,
            _randomizePage,
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: SizedBox(
            height: kBottomNavigationBarHeight * 1.7,
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
              ),
              child: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                items: List.from([
                  BottomNavigationBarItem(
                    icon: Icon(Icons.people_alt_outlined),
                    activeIcon: Icon(Icons.people_alt),
                    label: 'List',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.crop_square_outlined),
                    activeIcon: Icon(Icons.square_rounded),
                    label: 'Randomize',
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
