class UserModel{
  late String id;
  late String email;
  late String firstName;
  late String lastName;
  late String mobile;

  UserModel.fromJson(Map<String, dynamic> jsondata){
    id = jsondata['_id'] ?? '';
    email = jsondata['email'] ?? '';
    firstName = jsondata['firstName'] ?? '';
    lastName = jsondata['lastName'] ?? '';
    mobile = jsondata['mobile'] ?? '';
  }

  Map<String, dynamic> toJson(){
    return{
      '_id': id,
      'email' : email,
      'firstname' : firstName,
      'lastName' : lastName,
      'mobile' : mobile,
    };
  }
}