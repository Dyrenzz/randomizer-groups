import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/add_member_dialog.dart';
import 'package:flutter_application_1/components/delete_confirmation_dialog.dart';
import 'package:flutter_application_1/models/group.dart';
import 'package:flutter_application_1/utils/database_helper.dart';

class GroupPage extends StatefulWidget {
  final Group groupHome;
  final ValueChanged<Group>? onGroupUpdate;

  const GroupPage({super.key, required this.groupHome, this.onGroupUpdate});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  // Declare
  final List<String> members = [];
  final List<int> _selectedMemberList = [];
  late bool _filterList; // Declare filter list state
  late bool _isLoading;

  final _groupNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _membersController = TextEditingController();

  late Group groupHere;

  @override
  void initState() {
    super.initState();
    setState(() {
      _filterList = false;
      _isLoading = true;
    });
    // Insert the group model to local state
    groupHere = widget.groupHome;

    // log('START state // id: ${groupHere.id}');

    _groupNameController.text = groupHere.groupName;
    _descriptionController.text = groupHere.description ?? "";
    members.addAll(groupHere.membersName);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _membersController.dispose();
    _descriptionController.dispose();

    members.clear();
    // log('END state // id: ${groupHere.id}');
    _selectedMemberList.clear();

    super.dispose();
  }

  // setState section here ----------------
  void _insertIndexToList(int index) {
    setState(() {
      if (_selectedMemberList.contains(index)) {
        _selectedMemberList.remove(index);
      } else {
        _selectedMemberList.add(index);
        log("Id: ${members[index]} added");
      }
    });
  }

  void _clearSelectedMemberList() {
    setState(() {
      _selectedMemberList.clear();
    });
  }

  void _toggleFilterList() {
    setState(() {
      _filterList = !_filterList;
    });
  }
  // -------------------------------------

  // --------------- // ---------------
  // Database section
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> _updateGroupById(bool isEditingGroupNameDesc) async {
    log(isEditingGroupNameDesc? 'editing name,desc' : 'editing member');
    Group updatedGroup = isEditingGroupNameDesc
        // Editing group name and description
        ? Group.withId(
            id: groupHere.id!,
            groupName: _groupNameController.text.trim(),
            description: _descriptionController.text.trim(),
            membersName: members.toList(),
          )
        // Editing members
        : Group.withId(
            id: groupHere.id!,
            groupName: groupHere.groupName,
            description: groupHere.description,
            membersName: members,
          );

    // Update the group to the database
    await dbHelper.updateGroup(updatedGroup);

    // Update local state
    setState(() => groupHere = updatedGroup);

    // Update group_tabbed_page group model
    widget.onGroupUpdate?.call(updatedGroup);
    log("Group updated: ${groupHere.toMap()}");
  }

  Future<void> _addMember(List<String> listMember) async {
    setState(() {
      _isLoading = true;
      // Retrieve the listMember then add it one by one to members list
      members.addAll(listMember);
    });

    // update the memebers to database
    await _updateGroupById(false);
    log("member succesfully added, ${members.toString()}");
    if (!mounted) return;

    _showSnackBar("added", true, listMember.length);

    setState(() => _isLoading = false);
  }

  Future<void> _deleteSelectedMember() async {
    if (_selectedMemberList.isEmpty) return;
    // Set the deleting value to 'true'
    setState(() => _isLoading = true);
    // Logic here, retrive the index id then sort it DESCENDANT
    // it prevent the actual selected name with index id changed
    _selectedMemberList.sort((a, b) => b.compareTo(a));

    // Retrive each id then delete it
    for (int index in _selectedMemberList) {
      String name = members[index];
      log('Deleting group with name: $name');
      members.removeAt(index);
    }

    // Update to the database
    await _updateGroupById(false);

    _showSnackBar("deleted", false, _selectedMemberList.length);
    // Set the deleting value to 'false'
    setState(() => _isLoading = false);

    // Clear the selecectedMember list
    _clearSelectedMemberList();
  }
  // --------------- // ---------------

  void _showSnackBar(String verb, bool isAdding, int totalItem) {
    final String suffixSnackbar = totalItem > 1 ? 's' : '';
    final theme = Theme.of(context);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Expanded(
                child: Text(
                  "Successfully $verb $totalItem member$suffixSnackbar",
                  style: TextStyle(color: theme.colorScheme.onPrimary),
                ),
              ),
              const SizedBox(width: 8.0),
              Icon(isAdding ? Icons.group_add : Icons.delete_forever),
            ],
          ),
          padding: EdgeInsets.all(24.0),
          duration: Duration(seconds: 5),
          backgroundColor: theme.colorScheme.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    log("Building GroupPage with group: ${groupHere.groupName}");
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard on tap outside
      child: ColoredBox(
        color: theme.colorScheme.primary,
        child: Container(
          padding: EdgeInsets.zero,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Scaffold(
            appBar: NewAppBar(
              groupData: groupHere,
              descriptionController: _descriptionController,
              groupNameController: _groupNameController,
              onSaveEditVoid: _updateGroupById,
            ),
      
            body: CustomScrollView(
              // padding: EdgeInsets.all(24.0),
              slivers: [
                // Must wrap the ListView or etc with Expanded widget
                // This section: member top-bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 24.0),
                    child: (!_filterList)
                        ? newMemberTopBar(context)
                        : newMemberTopBarSetting(context),
                  ),
                ),
                  
                (_isLoading)
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: double.infinity,
                            child: CircularProgressIndicator(
                              color: theme.colorScheme.onPrimary.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          ),
                        ),
                      )
                    // This section: list member
                    : SliverList(
                        // padding: EdgeInsets.only(bottom: 4.0),
                        // shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        // itemCount: members.length,
                        // itemBuilder: (context, index) {
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final bool isSelected = _selectedMemberList.contains(index);
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: ListTile(
                                dense: true,
                                minTileHeight: 12.0,
                                contentPadding: EdgeInsets.zero,
                                onTap: () {
                                  if (_filterList) _insertIndexToList(index);
                                },
                                // Border section
                                shape: !isSelected
                                    ? BorderDirectional(
                                        bottom: BorderSide(
                                          color: theme.colorScheme.onSurface,
                                        ),
                                      )
                                    : Border.all(
                                        color: theme.colorScheme.onSurface,
                                      ),
                                trailing: isSelected? Container(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Icon(Icons.close_rounded, size: 18.0),
                                ) : const SizedBox.shrink(),
                                leading: Container(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "${index < 9? '0' : ''}${(index + 1).toString()}.", 
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                                title: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6.0,
                                  ),
                                  child: Text(
                                    members[index],
                                    style: TextStyle(fontSize: 11.0), textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: members.length,
                        ),
                      ),
                  
                //  This section: add member button
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 2.0),
                    child: (_filterList)
                        ? const SizedBox.shrink()
                        : newAddMemberTile(context),
                  ),
                ),
                SliverToBoxAdapter(child: const SizedBox(height: 64.0)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListTile newAddMemberTile(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      dense: true,
      minTileHeight: 0,
      contentPadding: EdgeInsets.zero,
      // ------
      onTap: () async {
        // wait for the tile to finish it splash animation
        await Future.delayed(Duration(milliseconds: 200));
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return ShowAddMemberDialog(
                memberController: _membersController,
                onSaveEditVoid: _addMember,
              );
            },
          );
        }
      },

      // Border section
      shape: BorderDirectional(
        bottom: BorderSide(color: theme.colorScheme.onSurface),
      ),

      leading: Container(
        padding: EdgeInsets.only(left: 8.0),
        child: Icon(Icons.person_4_outlined, size: 22.0),
      ),
      trailing: Container(
        padding: EdgeInsets.only(right: 8.0),
        child: Icon(Icons.add, size: 22.0),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          "Add member here",
          style: TextStyle(
            fontSize: 12.0,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  Container newMemberTopBarSetting(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
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
              _clearSelectedMemberList();
            },
            icon: Icon(Icons.close, color: theme.colorScheme.onSecondary),
          ),
          const SizedBox(width: 8.0),

          // This section: item counter text
          Text(
            "${_selectedMemberList.length} Selected",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSecondary,
            ),
          ),
          const SizedBox(width: 8.0),

          // This section: trash button
          Visibility(
            visible: _selectedMemberList.isNotEmpty,
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
                if (_selectedMemberList.isNotEmpty) {
                  showDeleteConfirmation(
                    context,
                    _deleteSelectedMember,
                    _selectedMemberList.length,
                    false,
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

  Container newMemberTopBar(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(bottom: 9.5, left: 12.0, right: 12.0),
      margin: EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "Member List${(members.length > 1 ? 's' : '')}",
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 8.0),
            width: 38.0,
            height: 38.0,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: IconButton(
              onPressed: () => _toggleFilterList(),
              color: theme.colorScheme.onPrimary,
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
      ),
    );
  }
}

class NewAppBar extends StatefulWidget implements PreferredSizeWidget {
  const NewAppBar({
    super.key,
    required this.groupData,
    required this.groupNameController,
    required this.descriptionController,
    required this.onSaveEditVoid,
  });

  final Group groupData;
  final void Function(bool) onSaveEditVoid;
  final TextEditingController groupNameController;
  final TextEditingController descriptionController;

  @override
  State<NewAppBar> createState() => _NewAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 1.8);
}

class _NewAppBarState extends State<NewAppBar> {
  @override
  Widget build(BuildContext context) {
    final String groupName = widget.groupData.groupName;
    final String? description = widget.groupData.description;
    final theme = Theme.of(context);

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
          GestureDetector(
            onTap: () {
              _showDescription(context);
            },
            child: Text(
              description!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),

      // This section: edit button
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 18.0, left: 12.0),
          child: IconButton(
            onPressed: () => _showEditDialog(context),
            icon: Icon(Icons.edit_rounded, color: theme.colorScheme.onPrimary),
          ),
        ),
      ],

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

  Future<dynamic> _showDescription(BuildContext context) {
    return showDialog(
              context: context,
              builder: (context) {
                final theme = Theme.of(context);
                final description = widget.groupData.description?? '';

                return Dialog(
                  insetPadding: const EdgeInsets.all(20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0)
                  ),
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(
                        color: theme.colorScheme.surface.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // height
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text("Group Description", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),),
                        ),

                        Divider(color: theme.colorScheme.tertiary, thickness: 2.0, indent: 12.0, endIndent: 12.0,),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 300.0,
                            height: 300.0,
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.tertiary.withValues(alpha: 0.2),
                              border: Border.all(color: theme.colorScheme.onTertiary.withValues(alpha: 0.3), width: 1.5),
                              borderRadius: BorderRadius.circular(20.0)),

                            child: Text(
                              (description.isEmpty)
                              ? "No description set yet for this group."
                              : description
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextButton(
                                onPressed: () {
                                  if(!mounted) return;
                                  Navigator.pop(context);
                                }, 
                                child: Text("Close", style: TextStyle(color: theme.colorScheme.onSurface))
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
  }

  void _showEditDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard if open
          child: Dialog(
            insetPadding: const EdgeInsets.all(4.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: theme.colorScheme.tertiary.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    const Text(
                      "Edit group",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.0,
                      ),
                    ),
                    const Text(
                      "You can edit your group name and description",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(height: 12.0),
          
                    // Inputs
                    // Group name input
                    TextFormField(
                      maxLength: 60,
                      minLines: 1,
                      maxLines: 2,
                      autocorrect: true,
                      controller: widget.groupNameController,
                      style: const TextStyle(fontSize: 16.0),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a group name';
                        }
                        if (value.trim().length < 3) {
                          return 'Group name must be at least 3 characters';
                        }
                        return null;
                      },
          
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(18.0),
                        // An empty helper text to prevent the field grow in height
                        helperText: "",
                        labelText: 'Group name',
                        labelStyle: TextStyle(
                          color: theme.colorScheme.onPrimary.withValues(
                            alpha: 0.5,
                          ),
                          fontSize: 16.0,
                        ),
                        alignLabelWithHint: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: theme.colorScheme.onPrimary.withValues(
                              alpha: 0.2,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: theme.colorScheme.onPrimary,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: theme.colorScheme.error),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: theme.colorScheme.error.withValues(alpha: 0.4),
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                    ),
          
                    const SizedBox(height: 16.0),
          
                    // Description (optional)
                    TextFormField(
                      maxLength: 250,
                      controller: widget.descriptionController,
                      style: TextStyle(fontSize: 16.0),
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(
                          color: theme.colorScheme.onPrimary.withValues(
                            alpha: 0.5,
                          ),
                          fontSize: 16.0,
                        ),
                        contentPadding: EdgeInsets.all(18.0),
                        // An empty helper text to prevent the field grow in height
                        helperText: "",
                        alignLabelWithHint: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: theme.colorScheme.onPrimary.withValues(
                              alpha: 0.2,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: theme.colorScheme.onPrimary,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                    ),
          
                    const SizedBox(height: 12),
                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Cancel
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => {
                              Navigator.pop(context),
                              FocusScope.of(context).unfocus(), // Dismiss keyboard if open
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(width: 32.0),
          
                        // Submit
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, or false otherwise.
                              if (formKey.currentState!.validate()) {
                                final groupChanged =
                                    widget.groupNameController.text.trim() !=
                                    widget.groupData.groupName;
                                final descriptionChanged =
                                    widget.descriptionController.text.trim() !=
                                    (widget.groupData.description ?? "");
          
                                Navigator.pop(context);
                                FocusScope.of(context).unfocus(); // Dismiss keyboard if open
                                if (!groupChanged && !descriptionChanged) return;
          
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Group updated successfully",
                                      style: TextStyle(
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                    padding: EdgeInsets.all(24.0),
                                    backgroundColor: theme.colorScheme.primary,
                                  ),
                                );
                                // run Edit
                                widget.onSaveEditVoid(true);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primaryContainer,
                              foregroundColor: theme.colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text(
                              "Save",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
