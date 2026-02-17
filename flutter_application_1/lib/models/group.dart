
class Group {
  int? _id;
  String _groupName;
  String? _description;
  List<String>? _membersName;

  // Constructor 
  Group({
    required String groupName,
    String? description,
    List<String>? membersName,
  })  : _groupName = groupName,
        _description = description,
        _membersName = membersName ?? [];

  // Constructor with id (optional)
  Group.withId({
    required int id,
    required String groupName,
    String? description,
    List<String>? membersName,
  })  : _id = id,
        _groupName = groupName,
        _description = description,
        _membersName = membersName ?? [];

  
  // Getter 
  int? get id => _id;
  String get groupName => _groupName;
  String? get description => _description;
  List<String> get membersName => _membersName ?? [];


  // Setter
  set groupName(String value) {
    if (value.length <= 60) _groupName = value;
  } 
  set description(String? value) {
    value ??= "";
    if (value.length <= 100) _description = value;
  } 
  set membersName(List<String> value) => _membersName = value;



  /// Convert a Groups into a Map. The keys must correspond to the names of the
  /// columns in the database.
  // e.g Map >> {'id': _id, 'group_name' = _groupName, 'description': _description, 'members_name': 'a;b;c;d'}
  Map<String, Object?> toMap() {
    // Declare map for return
    var map = <String, Object?> {};
    
    // Prevent it to be error cuz the PRIMARY KEY parameter
    if (id != null) map['id'] = _id;
    map['group_name'] = _groupName;
    map['description'] = _description ?? '';

    // _membersName still on List<String> value  >> [a,b,c,d]
    // join them with ';' seperator   >> "a;b;c;d"
    map['members_name'] = (_membersName ?? []).join(';');
    return map;
  }

  @override
  String toString() {
    String members = (_membersName ?? []).join(';');
    return 'Group(id: $_id, name: $_groupName, desc: $_description, members: $members)';
  }

  // Extract a Group Object from a Map object
  Group.fromMapObject(Map<String, dynamic> map) 
  : _id = map['id'] as int?,
    _groupName = map['group_name'] as String,
    _description = map['description'] as String,
    _membersName = (map['members_name']?.toString().isEmpty ?? true)
                    ? []
                    : map['members_name']
                          .toString()
                          .split(';')
                          .where((e) => e.trim().isNotEmpty)
                          .toList();
    // _membersName = map['members_name']?.toString().split(';') ?? [];
} 