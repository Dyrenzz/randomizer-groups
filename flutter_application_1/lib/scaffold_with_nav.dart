import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/add_group_page.dart';
import 'package:flutter_application_1/pages/group_list_page.dart';
import 'package:flutter_application_1/pages/info_page.dart';
import 'package:flutter_application_1/pages/navigaton_provider.dart';
import 'package:provider/provider.dart';

class ScaffoldWithNav extends StatefulWidget {
  const ScaffoldWithNav({super.key});

  @override
  State<ScaffoldWithNav> createState() => _ScaffoldWithNavState();
}

class _ScaffoldWithNavState extends State<ScaffoldWithNav> {
  // This is the page for adding a group
  // It is initialized once and reused to avoid unnecessary rebuilds
  final _addGroupPage = const AddGroupPage();

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<HomeNavigatonProvider>(context);
    final selectedIndex = navProvider.selectedIndex;

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: [
          // Index 0 is for List
          selectedIndex == 0 ? const GroupListPage() : const SizedBox.shrink(), // Page for List

          // Index 1 is for Add
          _addGroupPage, // Page for Add

          // Index 2 is for Info
          selectedIndex == 2 ? const InfoPage() : const SizedBox.shrink(), // Page for Info
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 100.0,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.onPrimary.withAlpha(22),
                blurRadius: 5.0,
              ),
            ],
          ),

          // This is the BottomNavigationBar
          child: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: navProvider.setIndex,
            items: const [
             BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_outlined),
              activeIcon: Icon(Icons.people_alt),
              label: 'List',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined),
              activeIcon: Icon(Icons.add_box),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info_outline),
              activeIcon: Icon(Icons.info),
              label: 'Info',
            ),
            ],
          ),
        ),
      ),
    );
  }
}
