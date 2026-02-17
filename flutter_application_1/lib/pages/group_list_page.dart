import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/group.dart';
import 'package:flutter_application_1/theme/theme_manager.dart';
import 'package:flutter_application_1/utils/database_helper.dart';
import 'package:provider/provider.dart';

class GroupListPage extends StatefulWidget {
  const GroupListPage({super.key});

  @override
  State<GroupListPage> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  int groupCounter = 0; // Initialize Items counter
  bool _filterList = false; // Initialize filter list state
  
  // ------------------------
  // Declare database
  final DatabaseHelper dbHelper = DatabaseHelper();
  
  List<Group> groupList = [];
  bool isLoading = true;

  // Intilaize State
  @override
  void initState() {
    super.initState();
    updateGroupList();
  }

  void updateGroupList() async {
    // Retrieve all groups from database which return map object
    final List<Map<String, Object?>> maps = await dbHelper.getGroupMapList();
    // Map the map object one by one then Convert it
    // to <Group> object then return them to list
    final List<Group> tempList = maps.map((e) => Group.fromMapObject(e)).toList();
    
    // Count all the groups in database
    final int getCount = await dbHelper.getCount();
    
    // Update the value
    setState(() {
      groupList = tempList;
      groupCounter = getCount;
      isLoading = false;
    });
  }

  void addGroup(String groupName) async {
    // Example
    Group newGroup = Group(groupName: groupName);
    // Insert the group with the name of 'groupName'
    await dbHelper.insertGroup(newGroup);

  }
   // ------------------------

  void _toggleFilterList() async{
    await Future.delayed(const Duration(milliseconds: 150));
    setState(() {
      _filterList = !_filterList;
      log("Filter List Toggled: $_filterList");
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final isDark = themeManager.isDark;

    return Column(
      children: [
      CustomHeader(themeManager: themeManager, isDark: isDark),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 36.0,),
        child: Column(
        children: [
          const SizedBox(height: 20.0),
          _filterList ?
          groupListSettingSection(context) :
          groupListSection(context),
          const SizedBox(height: 20.0),
        ],
        ),
      ),
      ],
    );
  }

  Container groupListSettingSection(BuildContext context) {
    return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 28.0,
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: (){
                        _toggleFilterList();
                        log("Close Button Pressed: $_filterList");
                      }, 
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text("$groupCounter Items",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    IconButton(
                      iconSize: 28.0,
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: (){
                        log("Trash Button Pressed");
                      }, 
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),

                  ],
              ),);
  }

  Row groupListSection(BuildContext context) {
    return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Group List",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  Container(
                    width: 44.0,
                    height: 44.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: IconButton(
                      onPressed: () {
                        _toggleFilterList();
                        log("Filter Button Pressed: $_filterList");
                      },
                      icon: Icon(Icons.filter_list_outlined),
                      iconSize: 24.0,
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ],
              );
  }
}

class CustomHeader extends StatelessWidget {
  const CustomHeader({
    super.key,
    required this.themeManager,
    required this.isDark,
  });

  final ThemeManager themeManager;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 64, 42, 42),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32.0),
          bottomRight: Radius.circular(32.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onPrimary.withAlpha(32),
            blurRadius: 5.0,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Randomizer",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                "Hello there,",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () => themeManager.setMode(),
                child: CircleAvatar(
                  radius: 24.0,
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  child: Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode,
                    color: Theme.of(context).colorScheme.primary,
                    size: 26.0,
                  ),
                ),
              ),
              const SizedBox(height: 6.0),
              Text(
                "Theme",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
