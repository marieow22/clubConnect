import 'package:club_connect2/classes/enums.dart';

class UserModel {

  final String? id;
  final String firstName;
  final String lastName;
  final String schoolEmail;
  final String userName;
  final String profilePicture;
  final String password;
  final AppRole role;
  final DateTime? clubDate;
  final DateTime? updatedClub;
  final String? specialty;

  UserModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.schoolEmail,
    required this.userName,
    this.profilePicture = '',
    required this.password,
    required this.role,
    this.clubDate,
    this.updatedClub,
    this.specialty,
  });
}