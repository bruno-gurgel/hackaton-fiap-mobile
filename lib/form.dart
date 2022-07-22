import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hackaton_fiap_mobile/login.dart';
import 'package:http/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

class MyFormPage extends StatelessWidget {
  static const id = '/form';

  final _formKey = GlobalKey<FormBuilderState>();
  final bool _useCustomFileViewer = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
    body: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: Column(
      children: <Widget>[
        FormBuilder(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            children: <Widget>[
              FormBuilderTextField(
                name: 'nome',
                decoration: const InputDecoration(
                  labelText:
                  'Nome do Usuário',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.max(70),
                ]),
                keyboardType: TextInputType.number,
              ),
              FormBuilderTextField(
                name: 'produto',
                decoration: const InputDecoration(
                  labelText:
                  'Produto',
                ),
                // onChanged: _onChanged,
                // valueTransformer: (text) => num.tryParse(text),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.max(70),
                ]),
                keyboardType: TextInputType.number,
              ),
              FormBuilderDateTimePicker(
                name: 'data',
                inputType: InputType.date,
                decoration: const InputDecoration(
                  labelText: 'Data da compra',
                ),
              ),
              FormBuilderDropdown(
                name: 'cidade',
                decoration: const InputDecoration(
                  labelText: 'Estado',
                ),
                allowClear: true,
                hint: const Text('Selecione a Cidade'),
                validator: FormBuilderValidators.compose(
                    [FormBuilderValidators.required()]),
                items: ['Belo Horizonte', 'Brasília', 'Fortaleza' ,'Recife', 'Rio de Janeiro', 'Salvador',  'São Paulo']
                    .map((gender) => DropdownMenuItem(
                  value: gender,
                  child: Text('$gender'),
                ))
                    .toList(),
              ),
              FormBuilderTextField(
                name: 'problema',
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText:
                  'Descreva o seu problema em até 300 caracteres',
                ),
                // onChanged: _onChanged,
                // valueTransformer: (text) => num.tryParse(text),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.max(300),
                ]),
              ),
              FormBuilderFilePicker(
                name: 'anexo',
                decoration: const InputDecoration(labelText: 'Anexos'),
                maxFiles: null,
                allowMultiple: false,
                previewImages: true,
                onChanged: (val) => debugPrint(val.toString()),
                selector: Row(
                  children: const <Widget>[
                    Icon(Icons.file_upload),
                    Text('Upload'),
                  ],
                ),
                onFileLoading: (val) {
                  debugPrint(val.toString());
                },
                customFileViewerBuilder:
                _useCustomFileViewer ? customFileViewerBuilder : null,
              ),
              FormBuilderCheckbox(
                name: 'accept_terms',
                initialValue: false,
                title: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Concordo com os ',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: 'Termos e Condições',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                validator: FormBuilderValidators.equal(
                  true,
                  errorText: 'Você deve aceitar os termos e condições para avançar',
                ),
              ),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: MaterialButton(
                color: Theme.of(context).colorScheme.background,
                child: const Text(
                  "Enviar",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  try {
                    _formKey.currentState!.save();
                    if (_formKey.currentState!.validate()) {
                      var formData = _formKey.currentState!.value;
                      var url = Uri.parse('http://10.0.2.2:8090/reclamacao/add');

                      var data =  <String, dynamic>{};
                      data['nome'] = formData["nome"];
                      data['produto'] = formData["produto"];
                      data['data'] = formData["data"].toString().split(" ")[0];
                      data['cidade'] = formData["cidade"];
                      data['problema'] = formData["problema"];

                      var response = await post(url,headers: {"Content-Type": "application/json"}, body: jsonEncode(data));


                      if (response.statusCode < 300) {
                        var responseBody = jsonDecode(response.body);
                        var id = responseBody["id"];
                        var imageUrl = Uri.parse('http://10.0.2.2:8091/reclamacao/$id');
                        var length = await formData['anexo'][0].size;
                        var request = MultipartRequest("POST", imageUrl);
                        var multipartFile = await MultipartFile.fromPath("fileProduto", formData['anexo'][0].path);
                        request.files.add(multipartFile);
                        var response2 = await request.send();

                        if (response2.statusCode < 300) {
                        _formSuccessFeedback(context);
                        } else {
                          _formErrorFeedback(context);
                        }
                      } else {
                        _formErrorFeedback(context);
                      }

                    } else {
                      print("validation failed");
                      _formErrorFeedback(context);
                    }
                  } catch(_) {
                    print(_);
                    _formErrorFeedback(context, message: 'Favor preencher todos os campos!');
                  }
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: MaterialButton(
                color: Theme.of(context).colorScheme.background,
                child: const Text(
                  "Reset",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _formKey.currentState!.reset();
                },
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: MaterialButton(
                color: Theme.of(context).colorScheme.background,
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ));
                },
              ),
            ),
          ],
        )
      ],
    )));
  }

  Widget customFileViewerBuilder(
      List<PlatformFile>? files,
      FormFieldSetter<List<PlatformFile>> setter,
      ) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final file = files![index];
        return ListTile(
          title: Text(file.name),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              files.removeAt(index);
              setter.call([...files]);
            },
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(
        color: Colors.blueAccent,
      ),
      itemCount: files!.length,
    );
  }
}

// Alert with single button.
_formSuccessFeedback(context) {
  Alert(
    context: context,
    type: AlertType.success,
    title: "Informações salvas com sucesso!",
    // desc: "Flutter is more awesome with RFlutter Alert.",
    buttons: [
      DialogButton(
        onPressed: () => Navigator.of(context).pop(),
        width: 120,
        child: const Text(
          "OK",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      )
    ],
  ).show();
}

_formErrorFeedback(context, {message ="Houve um erro ao salvar suas informações..." }) {
  Alert(
    context: context,
    type: AlertType.error,
    title: message ,
    buttons: [
      DialogButton(
        onPressed: () => Navigator.of(context).pop(),
        width: 120,
        child: const Text(
          "OK",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      )
    ],
  ).show();
}

