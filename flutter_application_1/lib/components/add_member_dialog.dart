import 'package:flutter/material.dart';

class ShowAddMemberDialog extends StatelessWidget {
  const ShowAddMemberDialog({
    super.key,
    required this.memberController,
    required this.onSaveEditVoid,
  });

  final TextEditingController memberController;
  final Future<void> Function(List<String>) onSaveEditVoid;
  
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Dialog(
      insetPadding: const EdgeInsets.all(4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      clipBehavior: Clip.antiAlias,
      child:  LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
              maxWidth: MediaQuery.of(context).size.width * 0.95,
              minWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.5),
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
                          "Add members",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20.0,
                          ),
                        ),
                        const Text(
                          "You can add members by entering one name per line",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(height: 12.0),
                    
                        // Inputs
                        // Members name input
                        TextFormField(
                          autocorrect: true,
                          controller: memberController,
                          minLines: 4,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          style: const TextStyle(fontSize: 16.0),
                          validator: (value) {
                            final lines = (value?? '')
                                            .trim()
                                            .split('\n')
                                            .map((e) => e.trim())
                                            .where((e) => e.isNotEmpty)
                                            .toList();

                            if (lines.isEmpty) {
                              return 'Please enter at least one valid member name.';
                            }
                            final invalidNames = lines.where((name) => !RegExp(r"^[a-zA-Z0-9\s]+$").hasMatch(name)).toList();
                            if (invalidNames.isNotEmpty) {
                              return 'Names can only contain letters, numbers, and spaces. Invalid: [${invalidNames.join(', ')}]';
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(18.0),
                            // An empty helper text to prevent the field grow in height
                            helperText: "",
                            hintText: "e.g. Alice\nGilang\nLouis",
                            hintStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.2), fontSize: 16.0),
                            labelText: 'Members name',
                            labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.5), fontSize: 16.0),
                            alignLabelWithHint: true,
                            errorMaxLines: 4,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.2)),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.error.withValues(alpha: 0.4)),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                        ),
                                  
                        const SizedBox(height: 16.0),
                
                        
                        // Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Cancel
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                  side: BorderSide.none,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.w600)),
                              ),
                            ),
                            const SizedBox(width: 32.0),
                    
                            // Submit
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Validate returns true if the form is valid, or false otherwise.
                                  if (formKey.currentState!.validate()) {
                                    Navigator.pop(context);
                                    // run Edit
                                    onSaveEditVoid(
                                      memberController.text
                                                      .trim()
                                                      .split('\n')
                                                      .map((name) => name.trim())
                                                      .where((name) => name.isNotEmpty)
                                                      .toList()
                                    );
                                    memberController.clear();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Text("Save", style: TextStyle(fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}