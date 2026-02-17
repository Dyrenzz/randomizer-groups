
import 'package:flutter/material.dart';

class RandomizeSetting extends StatefulWidget {
  const RandomizeSetting({
    super.key,
    this.onRandomize,
    required this.onCopy,
  });

  final void Function(int, bool)? onRandomize;
  final void Function() onCopy;

  @override
  State<RandomizeSetting> createState() => _RandomizeSettingState();
}

class _RandomizeSettingState extends State<RandomizeSetting> {
  final List<String> randomizeOptions = [
    'Wanted Groups',
    'Pick Randomly',
  ];
  TextEditingController groupCountController = TextEditingController();
  TextEditingController memberCountController = TextEditingController();
  String? randomizeMethod;
  String? errorText;

  @override
  void initState() {
    super.initState();
    randomizeMethod = randomizeOptions.first; // Default to the first option
    memberCountController.text = '1'; // Default member count
  }

  @override
  void dispose() {
    groupCountController.dispose();
    memberCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        color: theme.colorScheme.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
          // Title for Randomize Settings
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
              title: Text(
                'Randomizer Settings', 
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 22.0,
                )
              ),
              subtitle: Text(
                'Configure how the randomization works.',
                style: TextStyle(
                  fontSize: 12,
                )
              ),
            ),
            
            const SizedBox(height: 6.0),
            // This section: Randomize Method
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 16,
                  ),
                  icon: Icon(Icons.keyboard_arrow_down_rounded, color: theme.colorScheme.onSurface),
                  iconSize: 28.0,
                  value: randomizeMethod, // This should be linked to a state management solution
                  isExpanded: true,
                  items: randomizeOptions.map(_buildDropdownItem).toList(),
                  onChanged: (value) => setState(() {
                    randomizeMethod = value;
                    errorText = null; // Reset error text when method changes
                  }),
                ),
              ),
            ),

            const SizedBox(height: 16.0),
          // This section: Number of Groups
            groupRandomize(theme),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              child: Text(
                errorText ?? '',
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontSize: 12.0,
                ),
              ),
            ),
            const SizedBox(height: 6.0),
            // This section: Randomize Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_checkInput()) {
                          int? countValue = int.tryParse(
                            randomizeMethod == 'Pick Randomly'
                              ? memberCountController.text
                              : randomizeMethod == 'Wanted Groups'
                                ? groupCountController.text
                                : '1'
                          );
                          bool isGroupRandomize = randomizeMethod == 'Wanted Groups';
                          widget.onRandomize?.call(countValue!, isGroupRandomize);
                          
                            setState(() {
                              errorText = null;
                              FocusScope.of(context).unfocus(); // Dismiss keyboard
                            });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        backgroundColor: theme.colorScheme.primaryFixed,
                      ),
                      child: const Text(
                        'Randomize',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  IconButton(
                    onPressed: () {
                      widget.onCopy.call();
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      iconSize: 18.0,
                      padding: const EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    icon: Icon(Icons.copy, color: theme.colorScheme.onSurface)
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _checkInput() {
    // If the method is 'Pick Randomly', we need to check the member count
    if (randomizeMethod == 'Pick Randomly') {
      if (memberCountController.text.isEmpty) {
        setState(() => errorText = 'Please enter a number of members.');
        return false;
      }
      int? countValue = int.tryParse(memberCountController.text);
      if (countValue == null || countValue <= 0) {
        setState(() => errorText = 'Please enter a valid number of members.');
        return false;
      }
      return true;
    } 
    
    // If the method is 'Wanted Groups', we need to check the group count
    if (randomizeMethod == 'Wanted Groups') {
      if (groupCountController.text.isEmpty) {
        setState(() => errorText = 'Please enter a number of groups.');
        return false;
      }
      int? countValue = int.tryParse(groupCountController.text);
      if (countValue == null || countValue <= 0) {
        setState(() => errorText = 'Please enter a valid number of groups.');
        return false;
      }
      return true;
    } else {
      setState(() => errorText = 'Please select a randomization method.');
      return false;
    }
  }

  Padding groupRandomize(ThemeData theme) {
    bool inputError = errorText != null && errorText!.isNotEmpty;
    bool isPickRandomly = randomizeMethod == 'Pick Randomly';
    bool isWantedGroups = randomizeMethod == 'Wanted Groups';
    String labelText = isPickRandomly? 'Number of Members' : isWantedGroups? 'Number of Groups' : 'null';

    return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    labelText,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  )
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: TextField(
                    controller: isPickRandomly? memberCountController : isWantedGroups? groupCountController : null,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                      filled: true,
                      fillColor: theme.colorScheme.secondary,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: (inputError? theme.colorScheme.error : theme.colorScheme.onSurface).withValues(alpha: 0.6)), 
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: (inputError? theme.colorScheme.error : theme.colorScheme.onSurface).withValues(alpha: 0.8)), 
                      ),
                      hintText: 'Enter here...',
                      hintStyle: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                        fontSize: 12,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          );
  }

  DropdownMenuItem<String> _buildDropdownItem(String item) {
    return DropdownMenuItem<String>(
      value: item,
      child: Text(item),
    );
  }
}