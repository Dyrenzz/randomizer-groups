import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/components/randomize_setting.dart';
import 'package:flutter_application_1/models/group.dart';

class RandomizePage extends StatefulWidget {
  const RandomizePage({required this.groupModel, super.key});

  final Group groupModel;

  @override
  State<RandomizePage> createState() => _RandomizePageState();
}

class _RandomizePageState extends State<RandomizePage> {
  List<List<String>> grouppedList = [];
  List<String> randomMembersList = [];
  List<int> pickCounter = [];

  bool _isGroupRandomize = false;
  bool _isMemberRandomize = false;
  late Group groupData;

  // This is used to hide or show the RandomizeSetting
  bool _isHiden = false;

  // This start at the same time with groupPage
  @override
  void initState() {
    super.initState();
    groupData = widget.groupModel;

    log('START RANDOMIZE with id: ${groupData.id}');
  }

  void _onGroupRandomize(int count) {
    final List<String> allMember = widget.groupModel.membersName;
    if (allMember.isEmpty) return; // Prevent running with empty list
    // Ensure count does not exceed the number of members
    if (count > allMember.length) count = allMember.length;

    // Shuffle the list of all members
    final shuffled = List<String>.from(allMember)
      ..shuffle()
      ..shuffle();
    // Create empty lists for each group
    final groups = List<List<String>>.generate(count, (int i) => []);

    // Distribute members evenly across groups
    for (int i = 0; i < shuffled.length; i++) {
      final index = i % count;
      groups[index].add(shuffled[i]);
    }

    // Update the state with the new groups
    setState(() {
      randomMembersList = []; // Clear previous random members list
      grouppedList = groups;
      _isMemberRandomize = false; // Reset member randomization state
      _isGroupRandomize = true; // Set group randomization state
    });
    log("Randomized into $count groups: $grouppedList");
  }

  void _onMemberRandomize(int count) {
    final allMember = widget.groupModel.membersName;

    // Ensure count does not exceed the number of members
    if (count > allMember.length) count = allMember.length;

    // Initialize pickCount if empty
    if (pickCounter.isEmpty || pickCounter.length != allMember.length) {
      pickCounter = List.filled(allMember.length, 0);
    }

    final indexMembers = List<int>.generate(allMember.length, (int i) => i)
      ..shuffle()
      ..shuffle();
    // Sort by least picked count
    indexMembers.sort((a, b) => pickCounter[a].compareTo(pickCounter[b]));

    // Take the least picked indexes
    List<int> pickedIndexes = indexMembers.take(count).toList();

    // Add the picked indexes to the counter
    for (int index in pickedIndexes) {
      pickCounter[index]++;
    }

    // Take name base on indexes
    List<String> picked = pickedIndexes.map((e) => allMember[e]).toList();

    // Update the state
    setState(() {
      grouppedList = []; // Clear previous groups
      randomMembersList = picked;
      _isGroupRandomize = false; // Reset group randomization state
      _isMemberRandomize = true; // Set member randomization state
    });

    // Debugging log
    log("Randomized into $count members: $randomMembersList");
    log("members: $pickCounter");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    log("Building RandomizePage with group: ${groupData.groupName}");
    log("isGroupRandomize: $_isGroupRandomize, isMemberRandomize: $_isMemberRandomize");
    return GestureDetector(
      onTap: () =>
          FocusScope.of(context).unfocus(), // Dismiss keyboard on tap outside
      behavior: HitTestBehavior
          .opaque, // Ensure the gesture is recognized even if no child
      child: Scaffold(
        appBar: NewAppBar(groupData: groupData, theme: theme,),
        body: CustomScrollView(
          slivers: [
        // This section: Randomize settings
            SliverToBoxAdapter(
              child: _isHiden
                  ? const SizedBox.shrink()
                  : RandomizeSetting(
                      onRandomize: (count, isGroupRandomize) {
                        (isGroupRandomize)
                            ? _onGroupRandomize(count)
                            : _onMemberRandomize(count);
                      },
                      onCopy: () {
                        _onCopyToClipboard(theme);
                      },
                    ),
            ),
          // This section: hide/show button
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                margin: EdgeInsets.symmetric(
                  horizontal: !_isHiden? 88.0 : 120.0,
                  vertical: (_isHiden ? 8.0 : 24.0),
                ),
                decoration: BoxDecoration(
                  border: !_isHiden
                      ? BorderDirectional(
                          top: BorderSide(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        )
                      : BorderDirectional(
                          bottom: BorderSide(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.8,
                            ),
                          ),
                        ),
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  ),
                  onPressed: () => setState(() => _isHiden = !_isHiden),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (!_isHiden) Icon(Icons.keyboard_arrow_up_rounded, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                      Text(
                        _isHiden ? "Show" : "Hide",
                        style: TextStyle(color: !_isHiden? theme.colorScheme.onSurface.withValues(alpha: 0.5) : theme.colorScheme.onSurface),
                      ),
                      // if (_isHiden) Icon(Icons.keyboard_arrow_down_rounded, color: theme.colorScheme.onSurface),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 12.0)),
            if (grouppedList.isEmpty &&
                (_isGroupRandomize && _isMemberRandomize))
              SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    "No members to randomize",
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            if (_isGroupRandomize)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final group = grouppedList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        margin: EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          // color: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.2,
                            ),
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Group ${index + 1}",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),  
                            Text(
                              group.join(', '),
                              style: TextStyle(
                                fontSize: 14.0,
                                color: theme.colorScheme.onPrimary.withValues(
                                  alpha: 0.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: grouppedList.length,
                ),
              ),
            if (_isMemberRandomize)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final member = randomMembersList[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        margin: EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          // color: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.2,
                            ),
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          member,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: randomMembersList.length,
                ),
              ),
            SliverToBoxAdapter(
              child: const SizedBox(height: 48.0),
            )
          ],
        ),
      ),
    );
  }

  void _onCopyToClipboard(ThemeData theme) {
    if (!_isGroupRandomize && !_isMemberRandomize) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No members to copy.'),
        ),
      );
      return;
    }

    String resultText = '';
    if (_isGroupRandomize) { // [a, b, c]
      for (int i = 0; i < grouppedList.length; i++) {
        final members = grouppedList[i];
        String memberText = '';
        for (int number = 0; number < members.length; number++ ) {
          memberText += "\t${number + 1}. ${members[number]}\n";
        }
        resultText += "Group ${i + 1}:\n$memberText\n";
      }
    }

    if (_isMemberRandomize) {
      // [a, b, c]
      final members = randomMembersList.join(', '); // "a, b, c"
      resultText = "Picked: $members";
    }
    // Save it to clipboard
    Clipboard.setData(ClipboardData(text: resultText));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: theme.colorScheme.primary,
        elevation: 2,
        content: Text(
          (_isGroupRandomize)?
          'Group members have been copied to clipboard.'
          : (_isMemberRandomize)? 
          'Picked members have been copied to clipboard.'
          : 'No members to copy.',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
      ),
    );
  }
}

class NewAppBar extends StatefulWidget implements PreferredSizeWidget {
  const NewAppBar({super.key, required this.groupData, required this.theme});

  final Group groupData;
  final ThemeData theme;

  @override
  State<NewAppBar> createState() => _NewAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 1.8);
}

class _NewAppBarState extends State<NewAppBar> {
  @override
  Widget build(BuildContext context) {
    final String groupName = widget.groupData.groupName;
    final int memberCount = widget.groupData.membersName.length;
    final String memberText = memberCount > 1 ? 'members' : 'member';
    final theme = widget.theme;

    return AppBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(24.0),
      ),
      backgroundColor: theme.colorScheme.primary,
      toolbarHeight: (kToolbarHeight * 1.6), // as top padding
      titleSpacing: 0.0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            groupName,
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontSize: 24.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            "$memberCount $memberText",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),

      // This section: back button
      leadingWidth: (kToolbarHeight * 1.2),
      leading: IconButton(
        onPressed: () => Navigator.pop(context, widget.groupData),
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
