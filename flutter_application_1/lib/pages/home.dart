import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/custom_dialog_widget.dart';
import 'package:flutter_application_1/components/custom_header.dart';
import 'package:flutter_application_1/components/delete_confirmation_dialog.dart';
import 'package:flutter_application_1/components/group_tabbed_page.dart';
import 'package:flutter_application_1/models/group.dart';
import 'package:flutter_application_1/theme/theme_manager.dart';
import 'package:flutter_application_1/utils/database_helper.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _textInputController = TextEditingController();
  int groupCounter = 0; // Declare Items counter
  bool _filterList = false; // Declare filter list state

  // ------------------------
  // Declare database
  final DatabaseHelper dbHelper = DatabaseHelper();

  List<Group> groupList = []; // List of groups
  bool _isLoading = true;

  // Intilaize State
  @override
  void initState() {
    super.initState();
    updateGroupList();
  }

  @override
  void dispose() {
    _textInputController.dispose();

    groupList.clear();
    super.dispose();
  }

  Future<void> updateGroupList() async {
    // Retrieve all groups from database which return map object
    final List<Map<String, Object?>> maps = await dbHelper.getGroupMapList();
    // Map the map object one by one then Convert it
    // to <Group> object then return them to list
    final List<Group> tempList = maps
        .map((e) => Group.fromMapObject(e))
        .toList();

    // debug
    log('Updating group here');
    // Update the value
    setState(() {
      groupList = tempList;
      groupCounter = tempList.length;
      
      log("Group list updated: $groupCounter items");
      _isLoading = false;
    });
  }

  Future<void> _addGroupName(String groupName) async {
    if (groupName.trim().isEmpty) return; // Optional: Validasi kosong
    Group newGroup = Group(groupName: groupName);
    // Insert the group with the name of 'groupName'
    await dbHelper.insertGroup(newGroup);

    // Update
    await updateGroupList();
  }
  // ------------------------

  // Delete group section
  final List<int> _groupIdList = [];

  void _insertIdToList(int? groupId) {
    setState(() {
      if (_groupIdList.contains(groupId)) {
        _groupIdList.remove(groupId); // Toogle off
        log("Id: $groupId removed");
      } else {
        _groupIdList.add(groupId!); // Toogle on
        log("Id: $groupId added");
      }
    });
  }

  void _clearGroupIdList() {
    setState(() {
      _groupIdList.clear();
    });
  }

  Future<void> _deleteGroup() async {
    if (_groupIdList.isEmpty) return;
    // Set the deleting value to 'true'
    setState(() {
      _isLoading = true;
    });

    // Retrive each id then delete it
    for (int id in _groupIdList) {
      log('Deleting group with ID: $id');
      await dbHelper.deleteGroupById(id);
    }

    // Set the deleting value to 'false'
    setState(() {
      _isLoading = false;
    });

    // Clear the group list id
    _clearGroupIdList();
    // as always update
    await updateGroupList();
  }

  // Filter Toggle
  void _toggleFilterList() {
    setState(() {
      _filterList = !_filterList;
      log("Filter List Toggled: $_filterList");
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    log("Homepage was rebuilt");
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add Group'),
        backgroundColor: theme.colorScheme.primary,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => CustomDialogWidget(
              addGroupController: _textInputController,
              voidAddGroup: _addGroupName,
            ),
          );
        },
        icon: Icon(Icons.group_add),
      ),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight * 2.5),
        child: Consumer<ThemeManager>(
          builder: (context, themeManager, _) {
            final isDark = themeManager.isDark;
            return CustomHeaderWidget(
              themeManager: themeManager,
              isDark: isDark,
            );
          },
        ),
      ),
      // -------- BODY --------
      body: CustomScrollView(

        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 36.0),
              child: Column(
                children: [
                  const SizedBox(height: 20.0),

                  AnimatedCrossFade(
                    duration: Duration(milliseconds: 300),
                    crossFadeState: _filterList
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: groupListSettingSection(context),
                    secondChild: groupListSection(context),
                    firstCurve: Curves.easeOut,
                    secondCurve: Curves.easeIn,
                  ),

                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),

          // This section: group list
          if (_isLoading)
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                width: double.infinity,
                child: Center(
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ),
          if (!_isLoading)
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                // get each item
                final Group groupIndex = groupList[index];
                final int getMemberCount = groupIndex.membersName.length;
                final int? groupId = groupIndex.id;
                final bool isSelected = _groupIdList.contains(groupId);
                // log("${groupIndex.toString()}\n memberLenght: $getMemberCount");

                // This section: UI
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: ListTile(
                    // -----------
                    onTap: () {
                      _filterList
                          ? _insertIdToList(groupId)
                          : _navigateToGroupPage(groupIndex);
                    },
                    // -----------
                    shape: RoundedRectangleBorder(
                      side: (isSelected && _filterList)
                          ? BorderSide(color: theme.colorScheme.onSecondary)
                          : BorderSide.none,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    tileColor: theme.colorScheme.secondary,
                    splashColor: theme.colorScheme.primary.withAlpha(51),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 6.0,
                    ),
                    dense: true,

                    // Value widget
                    leading: Icon(Icons.radio_button_unchecked, weight: 12.0),
                    title: Text(
                      groupIndex.groupName,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      "Member${getMemberCount > 1 ? "s" : ""}: $getMemberCount",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: theme.colorScheme.onSecondary.withAlpha(190),
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                  ),
                );
              }, childCount: groupCounter
            ),
            ),
        ],
      ),
    );
  }

  void _navigateToGroupPage(Group group) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GroupTabbedPage(groupPageModel: group)),
    );

    // check the result to prevent the next method to be error
    if (result != null && result is Group) {
      final index = groupList.indexWhere((element) => element.id == result.id);

      // check the index, continue if the id have match
      if (index != -1 && groupList[index] != result) {
        setState(() {
          groupList[index] = result;
        });
      }
    }
  }

  Container groupListSettingSection(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      key: const ValueKey('list-filter'),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // This section: close button
          IconButton(
            iconSize: 22.0,
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: () {
              _toggleFilterList();
              _clearGroupIdList();
            },
            icon: Icon(Icons.close, color: theme.colorScheme.onSecondary),
          ),
          const SizedBox(width: 8.0),

          // This section: item counter text
          Text(
            "${_groupIdList.length} Selected",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSecondary,
            ),
          ),
          const SizedBox(width: 8.0),

          // This section: trash button
          Visibility(
            visible: _groupIdList.isNotEmpty,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: IconButton(
              iconSize: 22.0,
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                if (_groupIdList.isNotEmpty){
                  showDeleteConfirmation(
                    context,
                    _deleteGroup,
                    _groupIdList.length,
                    true,
                  );
                }
              },
              icon: Icon(Icons.delete, color: theme.colorScheme.onSecondary),
              tooltip: "Delete selected group",
            ),
          ),
        ],
      ),
    );
  }

  Row groupListSection(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      key: const ValueKey('list-normal'),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Group List",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        Container(
          width: 38.0,
          height: 38.0,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: IconButton(
            onPressed: () {
              _toggleFilterList();
              log("Filter Button Pressed: $_filterList");
            },
            icon: Icon(Icons.filter_list_outlined),
            iconSize: 22.0,
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
