import 'package:flutter/material.dart';

void showDeleteConfirmation(BuildContext context, VoidCallback onDelete, int itemCount, bool isHomePage) {
  String itemSuffix = itemCount > 1? 's' : '';
  String item = isHomePage? 'group' : 'member' ;
  String thisItem = itemCount > 1? 'these' : 'this';
  showDialog(
    context: context,
    builder: (_) => Dialog(
      insetPadding: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Container(
        padding: EdgeInsets.all(isHomePage? 24.0 : 16.0),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: Theme.of(context).colorScheme.error.withValues(alpha: 0.7),
              width: 2,
            ),
          ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              child: const Icon(Icons.error_outline, color: Colors.red, size: 28),
            ),
            const SizedBox(height: 16),

            // Title
            Text("Delete $item$itemSuffix", 
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.w500
              )
            ),

            const SizedBox(height: 12),

            // Sub-title
            Text("Are you sure you want to delete $thisItem $item$itemSuffix?\nThis action cannot be undone.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),

            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [

                // Cancel button
                Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),

                const SizedBox(width: 16),

                // Delete button
                Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onDelete(); // run the delete method
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor: Theme.of(context).colorScheme.onError,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text("Delete", style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}