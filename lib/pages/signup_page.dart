import 'package:flutter/material.dart';
import 'package:woocommerce_app/api_service.dart';
import 'package:woocommerce_app/models/customer.dart';
import 'package:woocommerce_app/utils/form_helper.dart';
import 'package:woocommerce_app/utils/validator_service.dart';
import 'package:woocommerce_app/utils/progress_hud.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late APIService apiService;
  late CustomerModel model;

  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool hidePassword = true;
  bool isApiCallProcess = false;
  String email = "";
  String firstName = "";
  String lastName = "";
  String password = "";

  @override
  void initState() {
    apiService = APIService();
    model = CustomerModel(
        email: email,
        firstName: firstName,
        lastName: lastName,
        password: password);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        automaticallyImplyLeading: true,
        title: const Text("Sign Up"),
      ),
      body: ProgressHUD(
        key: globalKey,
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
        color: Colors.white,
        child: Form(child: _formUI()),
      ),
    );
  }

  Widget _formUI() {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        color: Colors.white,
        child: Align(
          alignment: Alignment.topLeft,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            FormHelper.fieldLabel("First Name 1"),
            FormHelper.textInput(
              context,
              model.firstName,
              (value) => {
                model.firstName = value,
              },
              onValidate: (value) {
                if (value.toString().isEmpty) {
                  return "Please Enter first name";
                }
                return null;
              },
            ),
            FormHelper.fieldLabel("Last Name"),
            FormHelper.textInput(
              context,
              model.firstName,
              (value) => {
                model.lastName = value,
              },
              onValidate: (value) {
                if (value.toString().isEmpty) {
                  return "Please Enter Last name";
                }
                return null;
              },
            ),
            FormHelper.fieldLabel("Email ID"),
            FormHelper.textInput(
              context,
              model.firstName,
              (value) => {
                model.lastName = value,
              },
              onValidate: (value) {
                if (value.toString().isEmpty) {
                  return "Please Enter Email ID";
                }

                if (value.toString().isNotEmpty &&
                    !value.toString().isValidEmail()) {
                  return "Please Enter Valid Email ID";
                }

                return null;
              },
            ),
            FormHelper.fieldLabel("Password"),
            FormHelper.textInput(
              context,
              model.firstName,
              (value) => {
                model.lastName = value,
              },
              onValidate: (value) {
                if (value.toString().isEmpty) {
                  return "Please Enter Email ID";
                }

                if (value.toString().isNotEmpty &&
                    !value.toString().isValidEmail()) {
                  return "Please Enter Valid Email ID";
                }
                return null;
              },
              obscureText: hidePassword,
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {});
                  },
                  //color: Theme.of(context).accentColor.withOpacity(0.4),
                  color: Theme.of(context).canvasColor.withOpacity(0.4),
                  icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility)),
            ),
            const SizedBox(height: 20),
            Center(
              child: FormHelper.saveButton("Register", () {
                if (validateAndSave()) {
                  //print(model.toJson());
                  setState(() {
                    isApiCallProcess = true;
                  });
                  apiService.createCustomer(model).then((ret) {
                    setState(() {
                      isApiCallProcess = false;
                    });
                    if (ret) {
                      FormHelper.showMessage(context, "WooCommerce App",
                          "Registratin Successfull", "OK", () {
                        Navigator.of(context).pop();
                      });
                    } else {
                      FormHelper.showMessage(context, "WooCommerce App",
                          "Email is already registered", "OK", () {
                        Navigator.of(context).pop();
                      });
                    }
                  });
                }
              }),
            ),
          ]),
        ),
      ),
    ));
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    bool validForm = form!.validate();
    if (validForm) {
      //form.save();
      print("tab");
    } else {
      return true;
    }
    return false;
  }
}
