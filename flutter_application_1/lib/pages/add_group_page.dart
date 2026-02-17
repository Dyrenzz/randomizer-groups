import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/navigaton_provider.dart';
import 'package:provider/provider.dart';

class AddGroupPage extends StatefulWidget {
  const AddGroupPage({super.key});

  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  final TextEditingController _groupController = TextEditingController();
  String groupName = '';
  
  void _sentGroupName() {
    setState(() {
      groupName = _groupController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<HomeNavigatonProvider>(context);
    return Column(
      children: [
        CustomHeader(),
        const SizedBox(height: 24.0),
        Container(
          color: Theme.of(context).colorScheme.primary.withAlpha(120),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Group Name",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                TextField(
                  controller: _groupController,
                  decoration: InputDecoration(
                    labelText: 'Enter group name',
                    labelStyle: TextStyle(
                      fontSize: 14.0,
                      color: Theme.of(context).colorScheme.onPrimary.withAlpha(128),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onPrimary.withAlpha(64),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                Text(groupName),
                const SizedBox(height: 24.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle group creation logic here
                      log("Group Created: ${_groupController.text}");
                      navProvider.setIndex(0);
                      _sentGroupName();
                      _groupController.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 36.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Text(
                      "Create Group",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                  ),
                ),
              ],
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
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24.0),
            bottomRight: Radius.circular(24.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onPrimary.withAlpha(32),
              blurRadius: 5.0,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(32, 48, 0, 32),
        child: Text("Add Group",
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
