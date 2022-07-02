import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hackaton_fiap_mobile/login.dart';
import 'http_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';

class MyFormPage extends StatelessWidget {
  static const id = '/form';

  final _formKey = GlobalKey<FormBuilderState>();
  final bool _useCustomFileViewer = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                name: 'name',
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
                name: 'product',
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
                name: 'date',
                inputType: InputType.date,
                decoration: const InputDecoration(
                  labelText: 'Data da compra',
                ),
              ),
              FormBuilderDropdown(
                name: 'estado',
                decoration: const InputDecoration(
                  labelText: 'Estado',
                ),
                allowClear: true,
                hint: const Text('Selecione o Estado'),
                validator: FormBuilderValidators.compose(
                    [FormBuilderValidators.required()]),
                items: ['Rio de Janeiro', 'Brasília', 'São Paulo']
                    .map((gender) => DropdownMenuItem(
                  value: gender,
                  child: Text('$gender'),
                ))
                    .toList(),
              ),
              FormBuilderTextField(
                name: 'description',
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
                name: 'images',
                decoration: const InputDecoration(labelText: 'Anexos'),
                maxFiles: null,
                allowMultiple: true,
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
                onPressed: () {
                  try {
                    _formKey.currentState!.save();
                    if (_formKey.currentState!.validate()) {
                      print(_formKey.currentState!.value);
                      _formSuccessFeedback(context);
                    } else {
                      print("validation failed");
                      _formErrorFeedback(context);
                    }
                  } catch(_) {
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

