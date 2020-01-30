import 'package:flutter/material.dart';

class ColumnTextFieldCoulumnInRow extends StatefulWidget {
  @override
  _ColumnTextFieldCoulumnInRowState createState() => _ColumnTextFieldCoulumnInRowState();
}

class _ColumnTextFieldCoulumnInRowState extends State<ColumnTextFieldCoulumnInRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          firstItemColumn(),
          secondItemTextField(context),
          !_isExpandMembersButtonDisabled
              ? thirdItemColumn(context)
              : Container(
            height: 1.0,
            width: 92.0,
            decoration: BoxDecoration(color: Colors.blue, boxShadow: [BoxShadow(color: Colors.blue, offset: Offset(0.0, 1.0))]),
          )
        ],
      ),
    ),
    );
  }

  Flexible thirdItemColumn(BuildContext context) {
    return Flexible(
      flex: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                expandMembers();
                FocusScope.of(context).requestFocus(myFocusNode);
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Color(0xFFEFEFEF),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(expandMembersButton, style: TextStyle(fontSize: 14.0)),
              ),
            ),
            borderRadius: BorderRadius.circular(30.0),
          ),
          SizedBox(
            height: 7.0,
          ),
          Container(
            height: 0.35,
            width: 92.0,
            color: Colors.black,
          )
        ],
      ),
    );
  }

  Flexible secondItemTextField(BuildContext context) {
    return Flexible(
      flex: 7,
      child: Container(
        width: MediaQuery.of(context).size.width / 1.45,
        child: TextField(
            focusNode: myFocusNode,
            onChanged: (value) {
              inputMembersList = value;
            },
            onTap: !_isExpandMembersButtonDisabled
                ? () {
              setState(() {
                expandMembers();
              });
            }
                : null,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: TextStyle(fontSize: 20.0),
            controller: _controllerTextFieldNotify,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 1.0, bottom: 16.0),
              hintStyle: TextStyle(fontSize: 20.0, color: kReminderColor),
              hintText: '@notify team members',
            )),
      ),
    );
  }

  Flexible firstItemColumn() {
    return Flexible(
      flex: 1,
      child: Column(
//                            mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'To: ',
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(
            height: 15,
          ),
          !_isExpandMembersButtonDisabled
              ? Container(
            height: 0.35,
            width: 92.0,
            color: Colors.black,
          )
              : Container(
            height: 1.0,
            width: 92.0,
            decoration: BoxDecoration(color: Colors.blue, boxShadow: [BoxShadow(color: Colors.blue, offset: Offset(0.0, 1.0))]),
          ),
        ],
      ),
    );
  }
  }
}
