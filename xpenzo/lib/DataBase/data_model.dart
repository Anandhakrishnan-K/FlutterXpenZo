class Ledger {
  int? id;
  double? amount;
  String? notes;
  int? categoryIndex;
  int? categoryFlag;
  String? category;
  String? day;
  String? month;
  String? year;
  String? createdT;
  int? attachmentFlag;
  String? attachmentName;

  ledgerMap() {
    var mapping = <String, dynamic>{};
    mapping['id'] = id;
    mapping['amount'] = amount!;
    mapping['notes'] = notes;
    mapping['categoryIndex'] = categoryIndex!;
    mapping['categoryFlag'] = categoryFlag!;
    mapping['category'] = category;
    mapping['day'] = day!;
    mapping['month'] = month!;
    mapping['year'] = year!;
    mapping['createdT'] = createdT!;
    mapping['attachmentFlag'] = attachmentFlag;
    mapping['attachmentName'] = attachmentName;
    return mapping;
  }
}
