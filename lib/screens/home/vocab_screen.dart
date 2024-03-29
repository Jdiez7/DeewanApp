import 'package:appwithfirebase/services/class_vocab.dart';
import 'package:appwithfirebase/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../models/myuser.dart';
import '../../services/database.dart';
import '../../shared/loading.dart';
import 'package:just_audio/just_audio.dart';

class VocabScreen extends StatefulWidget {
  final Vocab vocab;

  VocabScreen(this.vocab, {Key? key}) : super(key: key);

  @override
  _VocabScreenState createState() => _VocabScreenState();
}

class _VocabScreenState extends State<VocabScreen> {
  bool loading = false;
  bool _isLoading = false;
  final player = AudioPlayer();
  static const routeName = '/extractArguments';

  @override
  Widget build(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context);
    // Extract the arguments from the current ModalRoute
    // settings and cast them as ScreenArguments.
    return loading
        ? Loading()
        : StreamBuilder<List<SinglePersonalVocabList>>(
            stream: DeewanDataBaseService(uid: user.uid).personalVocabData,
            initialData: [],
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<SinglePersonalVocabList> _personalVocabList =
                    snapshot.data!;
                _personalVocabList.sort((a, b) {
                  return a.listName
                      .toLowerCase()
                      .compareTo(b.listName.toLowerCase());
                });
                _personalVocabList.sort((a, b) {
                  if (b.fixed) {
                    return 1;
                  }
                  return -1;
                });
                var _list = [
                  for (var i = 0; i < _personalVocabList.length; i += 1) i
                ];

                return Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    title: Text(widget.vocab.englishMain +
                        ' - ' +
                        widget.vocab.arabicMain),
                    actions: [
                      PopupMenuButton(
                          color: globalColor3,
                          elevation: 20,
                          enabled: true,
                          onSelected: (int value) async {
                            if (_personalVocabList[value]
                                .personalVocabsList
                                .contains(widget.vocab.id)) {
                              List _withoutTheFavorite = List.from(
                                  _personalVocabList[value].personalVocabsList);
                              _withoutTheFavorite.remove(widget.vocab.id);
                              await DeewanDataBaseService(uid: user.uid)
                                  .updatePersonalVocabList(_withoutTheFavorite,
                                      _personalVocabList[value].docId);
                            } else {
                              List _withoutTheFavorite = List.from(
                                  _personalVocabList[value].personalVocabsList);
                              _withoutTheFavorite.add(widget.vocab.id);
                              await DeewanDataBaseService(uid: user.uid)
                                  .updatePersonalVocabList(_withoutTheFavorite,
                                      _personalVocabList[value].docId);
                            }
                          },
                          itemBuilder: (context) {
                            return _list.map((int index) {
                              return PopupMenuItem(
                                value: index,
                                child: ListTile(
                                  leading: Icon(_personalVocabList[index]
                                          .personalVocabsList
                                          .contains(widget.vocab.id)
                                      ? Icons.check
                                      : Icons.add),
                                  title:
                                      Text(_personalVocabList[index].listName),
                                ),
                              );
                            }).toList();
                          }),
                      Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: widget.vocab.mp3ID == ""
                            ? null
                            : GestureDetector(
                                onTap: () async {
                                  if (player.playing == false) {
                                    setState(() => _isLoading = true);
                                    await player.setUrl(
                                        'http://docs.google.com/uc?export=open&id=' +
                                            widget.vocab.mp3ID);
                                    setState(() => _isLoading = false);
                                    player.play();
                                  } else {
                                    player.stop();
                                    setState(() {});
                                  }
                                },
                                child: _isLoading
                                    ? SpinKitChasingDots(
                                        color: globalColor3,
                                        size: 25,
                                      )
                                    : Icon(
                                        player.playing
                                            ? Icons.crop_square
                                            : Icons.audiotrack,
                                        color: player.playing
                                            ? Colors.red
                                            : globalColor3),
                              ),
                      )
                    ],
                  ),
                  body: Container(
                    constraints: BoxConstraints.expand(),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage("assets/app_bg5.jpg"),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.4), BlendMode.dstATop),
                    )),
                    child: ListView(
                      children: [
                        const Placeholder(5),
                        Definitions(widget.vocab),
                        /*   const Placeholder(0),*/
                        Plural(widget.vocab),
                        adjForms(widget.vocab),
                        Fusha(widget.vocab),
                        Prepositions(widget.vocab),
                        Synonyms(widget.vocab),
                        ExampleSentences2(widget.vocab),
                        Verb(widget.vocab),
                        NominalVerb(widget.vocab),
                        Noun(widget.vocab),
                        Adjective(widget.vocab),
                        Masder(widget.vocab),
                        NomVerbAct(widget.vocab),
                        NomVerbPas(widget.vocab),
                        const Placeholder(0),
                      ],
                    ),
                  ),
                );
              } else {
                return Loading();
              }
            });
  }

  @override
  void dispose() {
    player.stop();
    super.dispose();
  }
}

class Definitions extends StatelessWidget {
  final Vocab vocab;

  const Definitions(this.vocab, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        color: globalColor1,
        padding: EdgeInsets.all(4.0),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 7.0,
              color: globalTextColor,
            ),
            children: <TextSpan>[
              TextSpan(text: "\n"),
              TextSpan(
                  text: '\t Definition',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
              TextSpan(text: "\n"),
              TextSpan(text: "\n"),
              TextSpan(
                  text: "\t \t  1. " + vocab.englishMain,
                  style: TextStyle(fontSize: 17)),
              vocab.englishMaincom == ""
                  ? TextSpan(text: "")
                  : TextSpan(
                      text: "\t \t(" + vocab.englishMaincom + ")",
                      style: TextStyle(fontSize: 17, color: globalTextColor)),
              TextSpan(text: "\n"),
              TextSpan(text: "\n"),
              vocab.english2 == ""
                  ? TextSpan(
                      style: TextStyle(height: 0, fontSize: 0),
                    )
                  : TextSpan(
                      text: "\t \t  2. " + vocab.english2,
                      style: TextStyle(fontSize: 17)),
              vocab.english2com == ""
                  ? TextSpan(
                      style: TextStyle(height: 0, fontSize: 0),
                    )
                  : TextSpan(
                      text: "\t \t(" + vocab.english2com + ")",
                      style: TextStyle(fontSize: 17, color: globalTextColor)),
              vocab.english2 == ""
                  ? TextSpan(
                      style: TextStyle(height: 0, fontSize: 0),
                    )
                  : TextSpan(text: "\n"),
              vocab.english2 == ""
                  ? TextSpan(
                      style: TextStyle(height: 0, fontSize: 0),
                    )
                  : TextSpan(text: "\n"),
              vocab.english3 == ""
                  ? TextSpan(
                      style: TextStyle(height: 0, fontSize: 0),
                    )
                  : TextSpan(
                      text: "\t \t  3. " + vocab.english3,
                      style: TextStyle(fontSize: 17)),
              vocab.english3com == ""
                  ? TextSpan(
                      style: TextStyle(height: 0, fontSize: 0),
                    )
                  : TextSpan(
                      text: "\t \t(" + vocab.english3com + ")",
                      style: TextStyle(fontSize: 17, color: globalTextColor)),
              vocab.english3 == ""
                  ? TextSpan(
                      style: TextStyle(height: 0, fontSize: 0),
                    )
                  : TextSpan(text: "\n"),
              vocab.english3 == ""
                  ? TextSpan(
                      style: TextStyle(height: 0, fontSize: 0),
                    )
                  : TextSpan(text: "\n"),
              vocab.english4 == ""
                  ? TextSpan(
                      style: TextStyle(height: 0, fontSize: 0),
                    )
                  : TextSpan(
                      text: "\t \t  4. " + vocab.english4,
                      style: TextStyle(fontSize: 17)),
              vocab.english4com == ""
                  ? TextSpan(
                      style: TextStyle(height: 0, fontSize: 0),
                    )
                  : TextSpan(
                      text: "\t \t(" + vocab.english4com + ")",
                      style: TextStyle(fontSize: 17, color: globalTextColor)),
              TextSpan(text: "\n"),
            ],
          ),
        ),
      ),
    );
  }
}

class Synonyms extends StatelessWidget {
  final Vocab vocab;

  const Synonyms(this.vocab, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (vocab.syn1 == "") {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        height: vocab.syn2 == ""
            ? 70
            : vocab.syn3 == ""
                ? 100
                : 130,
        color: globalColor1,
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 7.0,
              color: globalTextColor,
            ),
            children: <TextSpan>[
              const TextSpan(text: "\n"),
              const TextSpan(
                  text: '\t Synonyms',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const TextSpan(text: "\n"),
              const TextSpan(text: "\n"),
              TextSpan(
                  text: "\t \t  1. " + vocab.syn1,
                  style: TextStyle(fontSize: 17)),
              TextSpan(text: "\n"),
              TextSpan(text: "\n"),
              vocab.syn2 == ""
                  ? TextSpan(text: "")
                  : TextSpan(
                      text: "\t \t  2. " + vocab.syn2,
                      style: TextStyle(fontSize: 17)),
              TextSpan(text: "\n"),
              TextSpan(text: "\n"),
              vocab.syn3 == ""
                  ? TextSpan(text: "")
                  : TextSpan(
                      text: "\t \t  3. " + vocab.syn3,
                      style: TextStyle(fontSize: 17)),
            ],
          ),
        ),
      ),
    );
  }
}

class Prepositions extends StatelessWidget {
  final Vocab vocab;

  const Prepositions(this.vocab, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (vocab.vERBprep1 == "") {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        height: vocab.vERBprep2 == ""
            ? 70
            : vocab.vERBprep3 == ""
                ? 100
                : 130,
        color: globalColor1,
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 7.0,
              color: globalTextColor,
            ),
            children: <TextSpan>[
              const TextSpan(text: "\n"),
              const TextSpan(
                  text: '\t Prepositions',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const TextSpan(text: "\n"),
              const TextSpan(text: "\n"),
              TextSpan(
                  text: "\t \t  1. " + vocab.vERBprep1,
                  style: TextStyle(fontSize: 17)),
              vocab.vERBprep1com == ""
                  ? TextSpan(text: "")
                  : TextSpan(
                      text: "(" + vocab.vERBprep1com + ")",
                      style: TextStyle(fontSize: 17, color: globalTextColor)),
              TextSpan(text: "\n"),
              TextSpan(text: "\n"),
              vocab.vERBprep2 == ""
                  ? TextSpan(text: "")
                  : TextSpan(
                      text: "\t \t  2. " + vocab.vERBprep2,
                      style: TextStyle(fontSize: 17)),
              vocab.vERBprep2com == ""
                  ? TextSpan(text: "")
                  : TextSpan(
                      text: "(" + vocab.vERBprep2com + ")",
                      style: TextStyle(fontSize: 17, color: globalTextColor)),
              TextSpan(text: "\n"),
              TextSpan(text: "\n"),
              vocab.vERBprep3 == ""
                  ? TextSpan(text: "")
                  : TextSpan(
                      text: "\t \t  3. " + vocab.vERBprep3,
                      style: TextStyle(fontSize: 17)),
              vocab.vERBprep3com == ""
                  ? TextSpan(text: "")
                  : TextSpan(
                      text: "(" + vocab.vERBprep3com + ")",
                      style: TextStyle(fontSize: 17, color: globalTextColor)),
            ],
          ),
        ),
      ),
    );
  }
}

class Placeholder extends StatelessWidget {
  final double pxl;

  const Placeholder(this.pxl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        height: pxl,
      ),
    );
  }
}

class Plural extends StatelessWidget {
  final Vocab vocab;

  const Plural(this.vocab, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (vocab.nOUNplural == "") {
      return Container();
    }
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          height: 60,
          color: globalColor1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "\t Plural (" + vocab.nounpluralType + ")",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                vocab.nOUNplural + "\t \t ",
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
        ));
  }
}

class Fusha extends StatelessWidget {
  final Vocab vocab;

  const Fusha(this.vocab, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (vocab.fusha == "") {
      return Container();
    }
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          height: 60,
          color: globalColor1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "\t Fusha",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                vocab.fusha + "\t \t ",
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
        ));
  }
}

class ExampleSentences2 extends StatelessWidget {
  final Vocab vocab;

  const ExampleSentences2(this.vocab, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (vocab.ex1ARA == "") {
      return Container();
    }
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
            color: globalColor1,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      " \n",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Example Sentences",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "",
                      style: TextStyle(fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
                const Divider(
                  thickness: 2,
                  // thickness of the line
                  indent: 20,
                  // empty space to the leading edge of divider.
                  endIndent: 20,
                  // empty space to the trailing edge of the divider.
                  color: Colors.black,
                  // The color to use when painting the line.
                  height: 10, // The divider's height extent.
                ),
                vocab.ex1ARA == ""
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              flex: 5,
                              child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    vocab.ex1ARA,
                                    maxLines: 3,
                                    style: TextStyle(fontSize: 20),
                                    overflow: TextOverflow.ellipsis,
                                  )))
                        ],
                      ),
                vocab.ex1ENG == ""
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              flex: 5,
                              child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    vocab.ex1ENG,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ))),
                          const Text(
                            "",
                            style: TextStyle(fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                vocab.ex2ARA == ""
                    ? Container()
                    : const Divider(
                        thickness: 1,
                        // thickness of the line
                        indent: 20,
                        // empty space to the leading edge of divider.
                        endIndent: 20,
                        // empty space to the trailing edge of the divider.
                        color: Colors.black,
                        // The color to use when painting the line.
                        height: 10, // The divider's height extent.
                      ),
                vocab.ex2ARA == ""
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              flex: 5,
                              child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    vocab.ex2ARA,
                                    style: TextStyle(fontSize: 20),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                  )))
                        ],
                      ),
                vocab.ex2ENG == ""
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              flex: 5,
                              child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    vocab.ex2ENG,
                                    style: TextStyle(fontSize: 20),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                  ))),
                          const Text(
                            "",
                            style: TextStyle(fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                vocab.ex3ARA == ""
                    ? Container()
                    : const Divider(
                        thickness: 1,
                        // thickness of the line
                        indent: 20,
                        // empty space to the leading edge of divider.
                        endIndent: 20,
                        // empty space to the trailing edge of the divider.
                        color: Colors.black,
                        // The color to use when painting the line.
                        height: 10, // The divider's height extent.
                      ),
                vocab.ex3ARA == ""
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(
                              flex: 5,
                              child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    vocab.ex3ARA,
                                    style: TextStyle(fontSize: 20),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                  )))
                        ],
                      ),
                vocab.ex3ENG == ""
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              flex: 5,
                              child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    vocab.ex3ENG,
                                    style: TextStyle(fontSize: 20),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                  ))),
                        ],
                      ),
                const Text(
                  " \n",
                  style: TextStyle(fontSize: 6, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )));
  }
}

class Verb extends StatelessWidget {
  final Vocab vocab;

  const Verb(this.vocab, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (vocab.verb == "") {
      return Container();
    }
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          // height: 60,
          color: globalColor1,
          child: Column(
            children: <Widget>[
              const Text(
                " \n",
                style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    vocab.vERBform == ""
                        ? "\t corresponding Verb"
                        : "\t corresponding Verb (" + vocab.vERBform + ")",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Text(
                " \n",
                style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                      child: Text(
                    "\t \t \t \t" + vocab.verbEng,
                    style: TextStyle(fontSize: 20),
                  )),
                  Flexible(
                      child: Text(
                    vocab.verb + "\t \t \t \t",
                    style: TextStyle(fontSize: 20),
                  ))
                ],
              ),
              const Text(
                " \n",
                style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ));
  }
}

class NominalVerb extends StatelessWidget {
  final Vocab vocab;

  const NominalVerb(this.vocab, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (vocab.nomVerbAra == "") {
      return Container();
    }
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          // height: 60,
          color: globalColor1,
          child: Column(
            children: <Widget>[
              const Text(
                " \n",
                style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 5,
                      child: Text(
                        vocab.nomVerbType == ""
                            ? "\t Nominal Verb"
                            : "\t Nominal Verb (" + vocab.nomVerbType + ")",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      )),
                ],
              ),
              const Text(
                " \n",
                style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      flex: 5,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Text(
                            vocab.nomVerbEng,
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ))),
                  Expanded(
                      flex: 5,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                          child: Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                vocab.nomVerbAra,
                                style: TextStyle(fontSize: 20),
                              ))))
                ],
              ),
              const Text(
                " \n",
                style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ));
  }
}

class Noun extends StatelessWidget {
  final Vocab vocab;

  const Noun(this.vocab, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (vocab.noun == "") {
      return Container();
    }
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          // height: 60,
          color: globalColor1,
          child: Column(
            children: <Widget>[
              const Text(
                " \n",
                style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "corresponding Noun",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Text(
                " \n",
                style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Text(
                        vocab.nounEng,
                        style: TextStyle(fontSize: 20),
                      )),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                      child: Text(
                        vocab.noun,
                        style: TextStyle(fontSize: 20),
                      ))
                ],
              ),
              const Text(
                " \n",
                style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ));
  }
}

class Adjective extends StatelessWidget {
  final Vocab vocab;

  const Adjective(this.vocab, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (vocab.adjective == "") {
      return Container();
    }
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          // height: 60,
          color: globalColor1,
          child: Column(
            children: <Widget>[
              const Text(
                " \n",
                style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "\t corresponding Adjective",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Text(
                " \n",
                style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\t \t \t \t" + vocab.adjectiveEng,
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    vocab.adjective + "\t \t \t \t",
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
              const Text(
                " \n",
                style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ));
  }
}

class Masder extends StatelessWidget {
  final Vocab vocab;

  const Masder(this.vocab, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (vocab.masder == "") {
      return Container();
    }
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          // height: 60,
          color: globalColor1,
          child: Column(
            children: <Widget>[
              const Text(
                " \n",
                style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "\t Masdar",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Text(
                " \n",
                style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: Text(
                    "\t \t \t \t" + vocab.masderENG,
                    style: TextStyle(fontSize: 20),
                  )),
                  Flexible(
                      child: Text(
                    vocab.masder + "\t \t \t \t",
                    style: TextStyle(fontSize: 20),
                  ))
                ],
              ),
              const Text(
                " \n",
                style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ));
  }
}

class NomVerbAct extends StatelessWidget {
  final Vocab vocab;

  const NomVerbAct(this.vocab, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (vocab.nomVerbAct == "") {
      return Container();
    }
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          // height: 60,
          color: globalColor1,
          child: Column(
            children: <Widget>[
              const Text(
                " \n",
                style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "\t Nominal Verb (active)",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Text(
                " \n",
                style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: Text(
                    "\t \t \t \t" + vocab.nomVerbActEng,
                    style: TextStyle(fontSize: 20),
                  )),
                  Flexible(
                      child: Text(
                    vocab.nomVerbAct + "\t \t \t \t",
                    style: TextStyle(fontSize: 20),
                  ))
                ],
              ),
              const Text(
                " \n",
                style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ));
  }
}

class NomVerbPas extends StatelessWidget {
  final Vocab vocab;

  const NomVerbPas(this.vocab, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (vocab.nomVerbPas == "") {
      return Container();
    }
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          // height: 60,
          color: globalColor1,
          child: Column(
            children: <Widget>[
              const Text(
                " \n",
                style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "\t Nominal Verb (passive)",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Text(
                " \n",
                style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: Text(
                    "\t \t \t \t" + vocab.nomVerbPasEng,
                    style: TextStyle(fontSize: 20),
                  )),
                  Flexible(
                      child: Text(
                    vocab.nomVerbPas + "\t \t \t \t",
                    style: TextStyle(fontSize: 20),
                  ))
                ],
              ),
              const Text(
                " \n",
                style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ));
  }
}

/*
class ExampleSentences extends StatelessWidget {
  final Vocab vocab;

  const ExampleSentences(this.vocab, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (vocab.ex1ENG == "") {
      return Container();
    }
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
            color: Colors.blue[100],
            alignment: Alignment.topLeft,
            child: Column(children: <Widget>[
              const Text('\n \t ExampleS Sentences',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
              //Column(vocab.ex1ARA, textAlign: TextAlign.right,),
              RichText(
                  text: TextSpan(
                      style: const TextStyle(
                        fontSize: 7.0,
                        color: Colors.blue,
                      ),
                      children: <TextSpan>[
                        const TextSpan(text: "\n"),
                        const TextSpan(
                            text: '\t Example Sentences',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        TextSpan(
                            text: "\n \t \t" + vocab.ex1ENG,
                            style: const TextStyle(fontSize: 17)),
                        const TextSpan(text: "\n"),
                      ])),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 17.0, color: Colors.blue),
                  children: <TextSpan>[TextSpan(text: vocab.ex1ARA)],
                ),
                textAlign: TextAlign.right,
              ),
              Row(
                children: <Widget>[
                  const Text(
                    "",
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Text(
                    vocab.ex1ARA + "\t \t",
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ])));
  }
}*/
class adjForms extends StatelessWidget {
  final Vocab vocab;

  const adjForms(this.vocab, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (vocab.aDJECTIVEfemale == "" &&
        vocab.aDJECTIVEpl == "" &&
        vocab.aDJECTIVEmale == "") {
      return Container();
    }
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
            // height: 60,
            color: globalColor1,
            child: Column(children: [
              Container(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Conjugation",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Container(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[Column(
                    children: [
                      SizedBox(width: 200),
                      Text(
                  "male: " ,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )]),
                  Column(
                    children: [
                      SizedBox(width: 200),
                      Text(vocab.aDJECTIVEmale == "" ?
                    vocab.arabicMain : vocab.aDJECTIVEmale,
                    style: TextStyle(fontSize: 20),
                  )])]),
              Container(
                height: vocab.aDJECTIVEfemale == "" ? 0:10,
              ),
              vocab.aDJECTIVEfemale == "" ? Row():
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Column(
                      children: [
                        SizedBox(width: 200),
                        Text(
                          "female: " ,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        )]),
                    Column(
                        children: [
                          SizedBox(width: 200),
                          Text(vocab.aDJECTIVEfemale,
                            style: TextStyle(fontSize: 20),
                          )])]),
              Container(
                height: vocab.aDJECTIVEpl == "" ? 0:10,
              ),
              vocab.aDJECTIVEpl == "" ? Row():
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Column(
                      children: [
                        SizedBox(width: 200),
                        Text(
                          "plural: " ,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        )]),
                    Column(
                        children: [
                          SizedBox(width: 200),
                          Text(vocab.aDJECTIVEpl,
                            style: TextStyle(fontSize: 20),
                          )])]),
              Container(
                height: vocab.aDJECTIVEplMale == "" ? 0:10,
              ),
              vocab.aDJECTIVEplMale == "" ? Row():
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Column(
                      children: [
                        SizedBox(width: 200),
                        Text(
                          "plural (m): " ,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        )]),
                    Column(
                        children: [
                          SizedBox(width: 200),
                          Text(vocab.aDJECTIVEplMale,
                            style: TextStyle(fontSize: 20),
                          )])]),
              Container(
                height: vocab.aDJECTIVEplFemale == "" ? 0:10,
              ),
              vocab.aDJECTIVEplFemale == "" ? Row():
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Column(
                      children: [
                        SizedBox(width: 200),
                        Text(
                          "plural (f): " ,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        )]),
                    Column(
                        children: [
                          SizedBox(width: 200),
                          Text(vocab.aDJECTIVEplFemale,
                            style: TextStyle(fontSize: 20),
                          )])]),
              Container(
                height: 10,
              ),
              ])));

  }
}






















class TestVocabScreen extends StatefulWidget {
  final TestV testVocab;

  TestVocabScreen(this.testVocab, {Key? key}) : super(key: key);

  @override
  _TestVocabScreenState createState() => _TestVocabScreenState();
}

class _TestVocabScreenState extends State<TestVocabScreen> {
  bool loading = false;
  bool _isLoading = false;
  static const routeName = '/extractArguments';

  @override
  Widget build(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context);
    // Extract the arguments from the current ModalRoute
    // settings and cast them as ScreenArguments.
    return loading
        ? Loading()
        : StreamBuilder<List<SinglePersonalVocabList>>(
        stream: DeewanDataBaseService(uid: user.uid).personalVocabData,
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<SinglePersonalVocabList> _personalVocabList =
            snapshot.data!;
            _personalVocabList.sort((a, b) {
              return a.listName
                  .toLowerCase()
                  .compareTo(b.listName.toLowerCase());
            });
            _personalVocabList.sort((a, b) {
              if (b.fixed) {
                return 1;
              }
              return -1;
            });
            var _list = [
              for (var i = 0; i < _personalVocabList.length; i += 1) i
            ];

            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(widget.testVocab.englisch1 +
                    ' - ' +
                    widget.testVocab.arabic1)
              ),
              body: Container(
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/app_bg5.jpg"),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.blue.withOpacity(0.4), BlendMode.dstATop),
                    )),
                child: ListView(
                  children: [
                    const Placeholder(5),
                    TestDefinitions(widget.testVocab),
                    TestArabic(widget.testVocab),
                    /*   const Placeholder(0),*//*
                    Plural(widget.vocab),
                    adjForms(widget.vocab),
                    Fusha(widget.vocab),
                    Prepositions(widget.vocab),
                    Synonyms(widget.vocab),
                    ExampleSentences2(widget.vocab),
                    Verb(widget.vocab),
                    NominalVerb(widget.vocab),
                    Noun(widget.vocab),
                    Adjective(widget.vocab),
                    Masder(widget.vocab),
                    NomVerbAct(widget.vocab),
                    NomVerbPas(widget.vocab),
                    const Placeholder(0),*/
                  ],
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}

class TestDefinitions extends StatelessWidget {
  final TestV vocab;

  const TestDefinitions(this.vocab, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        color: Colors.blue[100],
        padding: EdgeInsets.all(4.0),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 7.0,
              color: Colors.black,
            ),
            children: <TextSpan>[
              TextSpan(text: "\n"),
              TextSpan(
                  text: '\t Definition',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
              TextSpan(text: "\n"),
              TextSpan(text: "\n"),
              TextSpan(
                  text: "\t \t  1. " + vocab.englisch1,
                  style: TextStyle(fontSize: 17)),
              TextSpan(text: "\n \n"),
              vocab.englisch2 == "-"
                  ? TextSpan(
                style: TextStyle(height: 0, fontSize: 0),
              )
                  : TextSpan(
                  text: "\t \t  2. " + vocab.englisch2,
                  style: TextStyle(fontSize: 17)),
              vocab.englisch2 == "-"
                  ? TextSpan(
                style: TextStyle(height: 0, fontSize: 0),
              ) : TextSpan(text:"\n \n"),
              vocab.englisch3 == "-"
                  ? TextSpan(
                style: TextStyle(height: 0, fontSize: 0),
              )
                  : TextSpan(
                  text: "\t \t  3. " + vocab.englisch3,
                  style: TextStyle(fontSize: 17)),
              vocab.englisch3 == "-"
                  ? TextSpan(
                style: TextStyle(height: 0, fontSize: 0),
              ) : TextSpan(text:"\n \n"),
              vocab.englisch4 == "-"
                  ? TextSpan(
                style: TextStyle(height: 0, fontSize: 0),
              )
                  : TextSpan(
                  text: "\t \t  4. " + vocab.englisch4,
                  style: TextStyle(fontSize: 17)),
              vocab.englisch4 == "-"
                  ? TextSpan(
                style: TextStyle(height: 0, fontSize: 0),
              ) : TextSpan(text:"\n \n"),
              vocab.englisch5 == "-"
                  ? TextSpan(
                style: TextStyle(height: 0, fontSize: 0),
              )
                  : TextSpan(
                  text: "\t \t  5. " + vocab.englisch5,
                  style: TextStyle(fontSize: 17)),
              vocab.englisch5 == "-"
                  ? TextSpan(
                style: TextStyle(height: 0, fontSize: 0),
              ) : TextSpan(text:"\n \n"),
              vocab.englisch6 == "-"
                  ? TextSpan(
                style: TextStyle(height: 0, fontSize: 0),
              )
                  : TextSpan(
                  text: "\t \t  6. " + vocab.englisch6,
                  style: TextStyle(fontSize: 17)),
              vocab.englisch6 == "-"
                  ? TextSpan(
                style: TextStyle(height: 0, fontSize: 0),
              ) : TextSpan(text:"\n \n"),
              vocab.englisch7 == "-"
                  ? TextSpan(
                style: TextStyle(height: 0, fontSize: 0),
              )
                  : TextSpan(
                  text: "\t \t  7. " + vocab.englisch7,
                  style: TextStyle(fontSize: 17)),
              vocab.englisch7 == "-"
                  ? TextSpan(
                style: TextStyle(height: 0, fontSize: 0),
              ) : TextSpan(text:"\n \n"),
              vocab.englisch8 == "-"
                  ? TextSpan(
                style: TextStyle(height: 0, fontSize: 0),
              )
                  : TextSpan(
                  text: "\t \t  8. " + vocab.englisch8,
                  style: TextStyle(fontSize: 17)),
              vocab.englisch6 == "-"
                  ? TextSpan(
                style: TextStyle(height: 0, fontSize: 0),
              ) : TextSpan(text:"\n \n"),
            ],
          ),
        ),
      ),
    );
  }
}

class TestArabic extends StatelessWidget {
  final TestV vocab;

  const TestArabic(this.vocab, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (vocab.arabic1 == "(أ / إ)") {
      return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            // height: 60,
            color: Colors.blue[100],
            child: Column(
              children: <Widget>[
                const Text(
                  " \n",
                  style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Arabic Forms",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Text(
                  " \n",
                  style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                        child: Text(
                          "\t \t \t \t" + vocab.arabic2,
                          style: TextStyle(fontSize: 20),
                        )),
                    Flexible(
                        child: Text(
                          vocab.forms1 + "\t \t \t \t",
                          style: TextStyle(fontSize: 20),
                        ))
                  ],
                ),
                const Text(
                  " \n",
                  style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
                ),
                vocab.arabic3 == "-" ? Row(): Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                        child: Text(
                          "\t \t \t \t" + vocab.arabic3,
                          style: TextStyle(fontSize: 20),
                        )),
                    Flexible(
                        child: Text(
                          vocab.forms2 + "\t \t \t \t",
                          style: TextStyle(fontSize: 20),
                        ))
                  ],
                ),
                const Text(
                  " \n",
                  style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
                ),
                vocab.arabic4 == "-" ? Row(): Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                        child: Text(
                          "\t \t \t \t" + vocab.arabic4,
                          style: TextStyle(fontSize: 20),
                        )),
                    Flexible(
                        child: Text(
                          vocab.forms3 + "\t \t \t \t",
                          style: TextStyle(fontSize: 20),
                        ))
                  ],
                ),
                const Text(
                  " \n",
                  style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
                ),

              ],
            ),
          ));
    }
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          // height: 60,
          color: Colors.blue[100],
          child: Column(
            children: <Widget>[
              const Text(
                " \n",
                style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Arabic Forms",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Text(
                " \n",
                style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                      child: Text(
                        "\t \t \t \t" + vocab.arabic1,
                        style: TextStyle(fontSize: 20),
                      )),
                  Flexible(
                      child: Text(
                        vocab.forms1 + "\t \t \t \t",
                        style: TextStyle(fontSize: 20),
                      ))
                ],
              ),
              const Text(
                " \n",
                style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
              ),
              vocab.arabic2 == "-" ? Row(): Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                      child: Text(
                        "\t \t \t \t" + vocab.arabic2,
                        style: TextStyle(fontSize: 20),
                      )),
                  Flexible(
                      child: Text(
                        vocab.forms2 + "\t \t \t \t",
                        style: TextStyle(fontSize: 20),
                      ))
                ],
              ),
              const Text(
                " \n",
                style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
              ),
              vocab.arabic3 == "-" ? Row(): Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                      child: Text(
                        "\t \t \t \t" + vocab.arabic3,
                        style: TextStyle(fontSize: 20),
                      )),
                  Flexible(
                      child: Text(
                        vocab.forms3 + "\t \t \t \t",
                        style: TextStyle(fontSize: 20),
                      ))
                ],
              ),
              const Text(
                " \n",
                style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),
              ),

            ],
          ),
        ));
  }
}