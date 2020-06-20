class LoginRequestData {
  String email = '';
  String password = '';
}

class RegisterData {
  String srNo;
  String name = '';
  String phone = '';
  String password = '';
  String cpassword = '';

  RegisterData({
    this.srNo,
    this.name,
    this.phone,
    this.password,
    this.cpassword,
  });

  RegisterData.fromJson(Map<String, dynamic> json) {

          srNo= json['user']['SrNo'];
          name= json['user']['fullname'];
          phone= json['user']['phone'];
          password= "";
          cpassword= "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SrNo']= this.srNo;
    data['name']= this.name;
    data['phone']= this.phone;
    data['password']= this.password;
    data['cpassword']= this.cpassword;
    return data;
  }
}