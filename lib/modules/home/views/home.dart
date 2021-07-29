import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciador_produtos_confere/custom/colorClass.dart';
import 'package:gerenciador_produtos_confere/custom/customBottom1.dart';
import 'package:gerenciador_produtos_confere/models/Produto.dart';
import 'package:gerenciador_produtos_confere/modules/home/blocs/home_bloc.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _ListProdutos = [];
  var _filterLista = [];

  final _nome = new TextEditingController();
  final _preco = new MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',', leftSymbol: 'R\$');
  final _precoPromocao  = new MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',', leftSymbol: 'R\$');
  final _percentualDesconto = new TextEditingController();
  bool _disponivelVenda = false;

  bool _create = false;
  bool _update = false;
  bool _delete = false;
  int _idProduto = 0;

  HomeBloc homeBloc = new HomeBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: HexColor("#1D754F"),
          title: const Text('Gerenciador de Produtos - Confere'),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: CustomButtom1(
                    "Criar produto",
                    () {
                      _idProduto = 0;
                      _nome.text = "";
                      _preco.text = "";
                      _precoPromocao.text = "";
                      _percentualDesconto.text = "";
                      _disponivelVenda = false;
                      _create = true;
                      _update = false;
                      _delete = false;
                      create_update(context);
                    },
                    width: (MediaQuery.of(context).size.width / 1.2),
                    height: 60,
                  ),
                ),
              ),

              Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: CustomButtom1(
                    "Lista de produtos",
                    () async {
                      _create = false;
                      _update = false;
                      _delete = false;
                      _ListProdutos = await homeBloc.read();
                      listaProdutos(context, _ListProdutos);
                    },
                    width: (MediaQuery.of(context).size.width / 1.2),
                    height: 60,
                  ),
                ),
              ),

              Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: CustomButtom1(
                    "Atualizar produto",
                    () async {
                      _update = true;
                      _create = false;
                      _delete = false;
                      _ListProdutos = await homeBloc.read();
                      listaProdutos(context, _ListProdutos);
                    },
                    width: (MediaQuery.of(context).size.width / 1.2),
                    height: 60,
                  ),
                ),
              ),

              Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: CustomButtom1(
                    "Deletar produto",
                    () async {
                      _delete = true;
                      _create = false;
                      _update = false;
                      _ListProdutos = await homeBloc.read();
                      listaProdutos(context, _ListProdutos);
                    },
                    width: (MediaQuery.of(context).size.width / 1.2),
                    height: 60,
                  ),
                ),
              ),

              Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: CustomButtom1(
                    "Preenchimento automático",
                        () async {
                      homeBloc.preenchimentoAltBase();
                      _scaffoldKey.currentState!.showSnackBar(SnackBar(
                        content: Text(
                          'Registros preenchidos automáticamente na base!',
                        ),
                        duration: Duration(seconds: 5),
                      ));
                    },
                    width: (MediaQuery.of(context).size.width / 1.2),
                    height: 60,
                  ),
                ),
              ),
        ]),
      ),
    );
  }

  /*########################################################################
                         CREATE E UPDATE
   #########################################################################*/

  Widget create_update(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    // final controlerPreco = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ','); //after

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(5.0)
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/1.5,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.black45,
                                        size: 30.0,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              TextFormField(
                                enabled: (_create || _update) ? true : false,
                                controller: _nome,
                                decoration: const InputDecoration(
                                  icon: const Icon(Icons.drive_file_rename_outline),
                                  hintText: 'Digite o nome',
                                  labelText: 'Nome (Obrigatório)',
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'O nome é obrigatório.';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                enabled: (_create || _update) ? true : false,
                                controller: _preco,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  icon: const Icon(Icons.monetization_on),
                                  hintText: 'Digite o preço',
                                  labelText: 'Preço (Obrigatório)',
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'O preço é obrigatório.';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                enabled: (_create || _update) ? true : false,
                                controller: _precoPromocao,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  icon: const Icon(Icons.monetization_on),
                                  hintText: 'Digite o preço de promoção',
                                  labelText: 'Preço promocional (Opcional)',
                                ),
                              ),
                              TextFormField(
                                enabled: (_create || _update) ? true : false,
                                controller: _percentualDesconto,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  icon: const Icon(Icons.assessment),
                                  hintText: 'Digite o percentual de desconto',
                                  labelText: 'Percentual de desconto (Opcional)',
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(top: 10, left: 5),
                                child: Row(
                                  children: [
                                    Text(
                                      'Disponível para venda',
                                      style: TextStyle(fontSize: 17.0),
                                    ),
                                    Checkbox(
                                      checkColor: Colors.greenAccent,
                                      activeColor: Colors.blueAccent,
                                      value: _disponivelVenda,
                                      onChanged: (_create || _update) ? (bool? value) {
                                        setState(() {
                                          _disponivelVenda = value!;
                                        });
                                      } : null,
                                    ),
                                  ],
                                ),
                              ),

                              (_update) ?
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.black45,
                                      size: 30.0,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      confirmDelete(context);
                                    },
                                  ),
                              ) : Container(),

                              (_create || _update) ?
                              Center(
                                child: Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: CustomButtom1(
                                    "Salvar",
                                    () async {
                                      if (_formKey.currentState!.validate()) {
                                        var produto = Produto(
                                          id: _idProduto,
                                          imagem: "https://cdns.iconmonstr.com/wp-content/assets/preview/2019/240/iconmonstr-product-3.png",
                                          nome: _nome.text,
                                          preco: _preco.numberValue,
                                          precoPromocao: (!_precoPromocao.text.isEmpty) ? _precoPromocao.numberValue : 0,
                                          percentualDesconto: (!_percentualDesconto.text.isEmpty) ? double.parse(_percentualDesconto.text) : 0,
                                          disponivelVenda: (_disponivelVenda) ? 1 : 0
                                        );

                                        if(_create) {
                                          _create = false;
                                          homeBloc.create(produto);

                                          _scaffoldKey.currentState!.showSnackBar(SnackBar(
                                            content: Text(
                                              'Produto criado!',
                                            ),
                                            duration: Duration(seconds: 5),
                                          ));
                                        }else if(_update) {
                                          homeBloc.update(produto);
                                          _scaffoldKey.currentState!.showSnackBar(SnackBar(
                                            content: Text(
                                              'Produto atualizado!',
                                            ),
                                            duration: Duration(seconds: 5),
                                          ));
                                        }
                                        Navigator.of(context).pop();

                                        // Mostrando lista de produtos
                                        _ListProdutos = await homeBloc.read();
                                        listaProdutos(context, _ListProdutos);
                                      }
                                    },
                                    width: (MediaQuery.of(context).size.width / 1.9),
                                    height: 60,
                                  ),
                                ),
                              ) : Container(),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
          );
        }
    );
    return Container();
  }

  /*########################################################################
                         LISVIEW COM INPUT DE BUSCA PARA PRODUTOS
   #########################################################################*/

  Widget listaProdutos(BuildContext context, var lista) {
    _filterLista = lista;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(5.0)
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 10,
                    height: MediaQuery.of(context).size.height - 80,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.black45,
                                    size: 30.0,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ),
                          TextField(
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "Pesquisar",
                              contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                  borderSide: BorderSide(color: HexColor('#DCAC6D'))
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                  borderSide: BorderSide(color: HexColor('#DCAC6D'))
                              ),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                  borderSide: BorderSide(color: HexColor('#DCAC6D'))
                              ),
                            ),
                            onChanged: (String name) {
                              setState(() {
                                _filterLista = homeBloc.filter(name, lista);
                              });
                            },
                          ),
                          Expanded(
                            child: ListView.builder(
                                padding: EdgeInsets.only(top: 10, left: 20),
                                itemCount: _filterLista.length,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  return new DropdownMenuItem(
                                    child: new InkWell(
                                      child: Container(
                                      padding: const EdgeInsets.only(bottom: 5.0),
                                      height: 80.0,
                                      child: new Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: 50,
                                            child: Image.network(
                                              _filterLista[index].imagem
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(left: 10),
                                                    child: Text(
                                                      _filterLista[index].nome.toString(),
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(fontSize: 17.0),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(left: 10),
                                                    child: Text(
                                                      "Preço: "+_filterLista[index].preco.toString(),
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(fontSize: 17.0),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(left: 10),
                                                    child: (_filterLista[index].precoPromocao!=0) ? Text(
                                                      "Preço promocional: "+_filterLista[index].precoPromocao.toString(),
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(fontSize: 17.0),
                                                    ) : Container(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      _idProduto = _filterLista[index].id;
                                      if(_delete) {
                                        confirmDelete(context);
                                      }else {
                                        _nome.text = _filterLista[index].nome;
                                        _preco.text = _filterLista[index].preco.toString();
                                        _precoPromocao.text = _filterLista[index].precoPromocao.toString();
                                        _percentualDesconto.text = _filterLista[index].percentualDesconto.toString();
                                        _disponivelVenda = (_filterLista[index].disponivelVenda == 1) ? true : false;
                                        create_update(context);
                                      }
                                    },
                                  ));
                                }
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
          );
        }
    );
    return Container();
  }

  /*########################################################################
                         CONFIRMAR DELEÇÃO
   #########################################################################*/

  Widget confirmDelete(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(5.0)
                  ),
                  child: Container(
                    // width: MediaQuery.of(context).size.width - 10,
                    height: MediaQuery.of(context).size.height/3.5,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 20, bottom: 20),
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              'Você realmente deseja excluir esse item?',
                              style: TextStyle(fontSize: 17.0),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CustomButtom1(
                                    "Sim",
                                    () async {
                                      _delete = true;
                                      _create = false;
                                      _update = false;
                                      homeBloc.delete(_idProduto);
                                      _idProduto = 0;
                                      Navigator.of(context).pop();
                                      // Mostrando lista de produtos
                                      _ListProdutos = await homeBloc.read();
                                      listaProdutos(context, _ListProdutos);

                                      _scaffoldKey.currentState!.showSnackBar(SnackBar(
                                        content: Text(
                                          'Produto excluído!',
                                        ),
                                        duration: Duration(seconds: 5),
                                      ));
                                    },
                                    width: (MediaQuery.of(context).size.width / 3),
                                    height: 50,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: CustomButtom1(
                                      "Não",
                                      () {
                                        Navigator.of(context).pop();
                                      },
                                      width: (MediaQuery.of(context).size.width / 3),
                                      height: 50,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
          );
        }
    );
    return Container();
  }
}
