import 'package:flutter/material.dart';

TextField reusableTextField(String text, IconData icon, bool isPassword,
    TextEditingController controller, Color borderColor) {
  return TextField(
    controller: controller,
    obscureText: isPassword,
    enableSuggestions: !isPassword,
    autocorrect: !isPassword,
    cursorColor: Colors.black,
    style: TextStyle(color: Colors.black.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: (Icon(
        icon,
        color: Colors.black,
      )),
      labelText: text,
      labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide:
            BorderSide(width: 10, style: BorderStyle.none, color: borderColor),
      ),
    ),
    keyboardType:
        isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
  );
}

Container signInSignUpButton(
    text, BuildContext context, bool isLogin, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
    ),
  );
}



/*ListTile dropDown(BuildContext context, String text, String selected, List list ){
return  ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(color: Colors.black)),
                        title: Row(children: [
                          Text(text),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: DropdownButton(
                                value: selectedGroup,
                                items: list
                                    .map((item) => DropdownMenuItem<String>(
                                          child: Text(item),
                                          value: item,
                                        ))
                                    .toList(),
                                onChanged: (item) => setState(
                                    () => selectedGroup = item as String?),
                              ))
                        ]),
                      ),
}  
*/