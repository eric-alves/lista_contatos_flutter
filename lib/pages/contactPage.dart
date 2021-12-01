import 'dart:io';

import 'package:agenda_contatos_flutter/helper/contact_helper.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  final Contact? contact;
  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact? _editedContact;

  bool _userEdited = false;
  final _nameFocus = FocusNode();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact!.toMap());
      _nameController.text = _editedContact!.name!;
      _emailController.text = _editedContact!.email!;
      if (_editedContact?.phone != null) {
        _phoneController.text = _editedContact!.phone!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editedContact?.name ?? "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedContact?.name != null &&
                _editedContact!.name!.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              GestureDetector(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: //_editedContact?.img != null
                          //? FileImage(File(_editedContact!.img!)) :
                          AssetImage("images/person.png"),
                    ),
                  ),
                ),
              ),
              TextField(
                focusNode: _nameFocus,
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Nome:",
                ),
                onChanged: (value) {
                  _userEdited = true;
                  setState(() {
                    _editedContact?.name = value;
                  });
                },
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email:",
                ),
                onChanged: (value) {
                  _userEdited = true;
                  _editedContact?.email = value;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: "Telefone:",
                ),
                onChanged: (value) {
                  _userEdited = true;
                  _editedContact?.phone = value;
                },
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancelar"),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text("Sim"),
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
