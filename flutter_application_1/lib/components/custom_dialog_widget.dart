import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';

class CustomDialogWidget extends StatelessWidget {
   const CustomDialogWidget({
    super.key,
    required this.addGroupController,
    required this.voidAddGroup,
  });

  final TextEditingController addGroupController;
  final void Function(String name) voidAddGroup;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0)
      ),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.5),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // height
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Add Group",
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(width: 12.0),
                  // Logo
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8.0)
              
                    ),
                    child: Icon(Icons.people)
                  )
                ],
              ),
            ),
            const SizedBox(height: 32.0),
        
            // Input Group
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextFormField(
                maxLength: 60,
                minLines: 1,
                maxLines: 2,
                controller: addGroupController,
                style: TextStyle(fontSize: 16.0),
                decoration: InputDecoration(
                  labelText: 'Enter group name',
                  labelStyle: TextStyle(
                    fontSize: 14.0,
                    color: Theme.of(
                      context,
                    ).colorScheme.onPrimary.withAlpha(128),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary.withAlpha(18),
                    ),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            const SizedBox(height: 32.0),
        
            // Button Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                // This section: cancel button 
                  Expanded(
                    child: ElevatedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () {
                        addGroupController.clear();
                        Navigator.pop(context);
                      },
                      child: Text("Cancel", style: TextStyle(fontWeight: FontWeight.w600),),
                    ),
                  ),
        
                  const SizedBox(width: 24.0),
        
                // This section: submit button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)
                        )
                      ),
                      onPressed: () {
                        // Close keyboard
                        FocusScope.of(context).unfocus();

                        final input = addGroupController.text.trim();
                        if (input.isEmpty) {
                          showSnackBar("Group name cannot be empty.", context);
                          return;
                        }

                        // #LOG
                        log("Group added succesfully");
                        voidAddGroup(input);
                        addGroupController.clear();
                        Navigator.pop(context);
                      }, 
                      child: Text("Add", style: TextStyle(fontWeight: FontWeight.w600),)
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void showSnackBar(String message, BuildContext context) {
     rootScaffoldMessengerKey.currentState?.showSnackBar(
       SnackBar(
         content: Row(
           children: [
              Icon(Icons.warning_rounded, color: Theme.of(context).colorScheme.onErrorContainer,),
              const SizedBox(width: 8.0,),
              Text(message, style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
           ],
         ),
         behavior: SnackBarBehavior.floating,
         backgroundColor: Theme.of(context).colorScheme.error,
         
         margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
       ),
     );
  }
}