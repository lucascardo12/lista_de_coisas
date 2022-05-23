import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:listadecoisa/modules/home/presenter/controllers/compartilha_controller.dart';
import 'package:listadecoisa/main.dart';
import 'package:listadecoisa/modules/home/domain/models/compartilha.dart';
import 'package:listadecoisa/modules/auth/presenter/ui/atoms/button_text_padrao.dart';
import 'package:listadecoisa/modules/auth/presenter/ui/organisms/loading_padrao.dart';
import 'package:listadecoisa/modules/listas/presenter/ui/pages/listas_page.dart';

class CompartilhaPage extends StatefulWidget {
  static const route = '/Compartilha';
  const CompartilhaPage({Key? key}) : super(key: key);
  @override
  State<CompartilhaPage> createState() => _CompartilhaPageState();
}

class _CompartilhaPageState extends State<CompartilhaPage> {
  final ct = di.get<CompartilhaController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => ct.init(context));
    super.initState();
  }

  @override
  void dispose() {
    ct.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ct.gb.getSecondary(),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ButtonTextPadrao(
            label: '  Cancelar  ',
            onPressed: () => Navigator.pop(context),
          ),
          ButtonTextPadrao(
            label: '  Confirmar  ',
            onPressed: () async {
              var comp = Compartilha(
                idLista: ct.gb.codigoList,
                idUser: ct.gb.codigoUser,
                isRead: ct.gb.codigRead == 'true' ? true : false,
              );

              if (ct.gb.lisComp.value
                  .where((element) => element.idLista == comp.idLista && element.idUser == comp.idUser)
                  .isEmpty) {
                ct.gb.lisComp.value.add(comp);
                await ct.banco.criaAlteraComp(user: ct.gb.usuario!, coisas: comp);
              } else {
                await Fluttertoast.showToast(
                    msg: "A lista já foi salva!!",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 5,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 18.0);
              }
              Navigator.pop(context);
            },
          )
        ],
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: ct.gb.getPrimary(),
        title: const Text(
          'Lista Compartilhada',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [ct.gb.getPrimary(), ct.gb.getSecondary()],
          ),
        ),
        child: ct.gb.isLoading
            ? LoadPadrao()
            : ListView(
                padding: const EdgeInsets.all(30),
                children: [
                  Text(
                    'Desejar anexar a seguinte lista?',
                    style: Theme.of(context).textTheme.headline5!.copyWith(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ButtonTextPadrao(
                    label: "${ct.lista.nome}",
                    onPressed: () => Navigator.pushNamed(
                      context,
                      ListasPage.route,
                      arguments: [ct.lista, true],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
