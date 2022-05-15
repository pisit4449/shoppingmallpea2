// ignore_for_file: camel_case_types

import 'dart:convert';

class WalletModel {
  final String id;
  final String idBuyer;
  final String datePay;
  final String money;
  final String pathSlip;
  final String status;
  WalletModel({
    required this.id,
    required this.idBuyer,
    required this.datePay,
    required this.money,
    required this.pathSlip,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idBuyer': idBuyer,
      'datePay': datePay,
      'money': money,
      'pathSlip': pathSlip,
      'status': status,
    };
  }

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
      id: map['id'] ?? '',
      idBuyer: map['idBuyer'] ?? '',
      datePay: map['datePay'] ?? '',
      money: map['money'] ?? '',
      pathSlip: map['pathSlip'] ?? '',
      status: map['status'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory WalletModel.fromJson(String source) => WalletModel.fromMap(json.decode(source));
}
