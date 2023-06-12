import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './config.dart';
import 'package:quizzle/configs/themes/custom_text_styles.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({Key? key}) : super(key: key);
  static const String routeName = '/dictionary';

  @override
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  bool descTextShowFlag = false;

  TextEditingController _controller = TextEditingController();
  late StreamController _streamController;
  late Stream _stream;
  late Timer search;
  _search() async {
    if (_controller.text == null || _controller.text.length == 0) {
      _streamController.add(null);
      return;
    } else {
      _streamController.add('waiting');
      final data = await http.get(Uri.parse(url + _controller.text.trim()),
          headers: {'Authorization': 'Token ' + token});
      print(data.body);
      if (data.body.contains('[{"message":"No definition :("}]')) {
        _streamController.add('NoData');
        return;
      } else {
        _streamController.add(json.decode(data.body));
        return;
      }
    }
  }

  bool isExpanded = false;
  @override
  void initState() {
    _streamController = StreamController();
    _stream = _streamController.stream;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xFF823FE6),
          centerTitle: true,
          title: const Text('Dictionary', style: kHeaderTS),
          bottom: PreferredSize(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 12, bottom: 8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24)),
                      child: TextFormField(
                        //autovalidate: true,
                        autocorrect: true,
                        textInputAction: TextInputAction.search,
                        onFieldSubmitted: (val) {
                          _search();
                        },
                        onChanged: (val) {
                          if (search.isActive) search.cancel();
                          search =
                              Timer(const Duration(milliseconds: 1000), () {
                            _search();
                          });
                        },
                        controller: _controller,
                        decoration: const InputDecoration(
                            hintText: 'Search for a word',
                            contentPadding: EdgeInsets.only(left: 24.0),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  IconButton(
                      iconSize: 30,
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _search();
                      })
                ],
              ),
              preferredSize: const Size.fromHeight(48.0)),
        ),
        body: StreamBuilder(
          stream: _stream,
          builder: (ctx, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: Text(
                  'Type a word to get its meaning 🤔',
                  style: TextStyle(fontSize: 18, color: Color(0xFF7424ed)),
                ),
              );
            }
            if (snapshot.data == 'waiting') {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data == 'NoData') {
              return const Center(
                child: Text(
                  'No Defination 😭',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              );
            }
            return ListView.builder(
                itemCount: (snapshot.data as Map)['definitions'].length,
                itemBuilder: (ctx, i) => ListBody(
                      children: [
                        Card(
                          color: Colors.white,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ExpansionTile(
                              onExpansionChanged: (bool expanding) =>
                                  setState(() => this.isExpanded = expanding),
                              // backgroundColor: Colors.grey,
                              leading: (snapshot.data as Map)['definitions'][i]
                                          ['image_url'] ==
                                      null
                                  ? const CircleAvatar(
                                      backgroundColor: Color(0xFF823FE6),
                                      child: Icon(Icons.chevron_right),
                                      maxRadius: 25,
                                    )
                                  : CircleAvatar(
                                      maxRadius: 25,
                                      backgroundImage: NetworkImage(
                                          (snapshot.data as Map)['definitions']
                                              [i]['image_url']),
                                    ),
                              title: Text(
                                _controller.text.trim() +
                                    "  (" +
                                    (snapshot.data as Map)['definitions'][i]
                                        ['type'] +
                                    ")",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: isExpanded
                                      ? FontWeight.w400
                                      : FontWeight.w300,
                                  color: isExpanded
                                      ? Color(0xFF823FE6)
                                      : Colors.black,
                                ),
                              ),
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Defination:',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      GestureDetector(
                                        onTap: () => {
                                          setState(() => descTextShowFlag =
                                              !descTextShowFlag)
                                        },
                                        child: (snapshot.data
                                                        as Map)['definitions']
                                                    [i]['definition']
                                                .isNotEmpty
                                            ? AnimatedCrossFade(
                                                duration: const Duration(
                                                    milliseconds: 400),
                                                crossFadeState: descTextShowFlag
                                                    ? CrossFadeState.showFirst
                                                    : CrossFadeState.showSecond,
                                                firstChild: Text(
                                                    (snapshot.data as Map)[
                                                                'definitions']
                                                            [i]['definition']
                                                        .trimLeft(),
                                                    // textAlign: TextAlign.justify,
                                                    style: TextStyle(
                                                        height: 1.5,
                                                        fontSize: 17,
                                                        color: Colors.grey[900],
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                secondChild: Text(
                                                    (snapshot.data as Map)[
                                                            'definitions'][i]
                                                        ['definition'],
                                                    maxLines: 7,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        height: 1.5,
                                                        fontSize: 16,
                                                        color:
                                                            Colors.grey[1000],
                                                        fontWeight:
                                                            FontWeight.w400)),
                                              )
                                            : Container(),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8.0),
                                        child: Divider(
                                            endIndent: 100,
                                            color: Colors.white),
                                      ),
                                      (snapshot.data as Map)['definitions'][i]
                                                      ['example']
                                                  .toString() !=
                                              'null'
                                          ? const Text(
                                              'Example:',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            )
                                          : const SizedBox(),
                                      (snapshot.data as Map)['definitions'][i]
                                                      ['example']
                                                  .toString() !=
                                              'null'
                                          ? Text(
                                              (snapshot.data
                                                          as Map)['definitions']
                                                      [i]['example']
                                                  .toString(),
                                              maxLines: 7,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  height: 1.5,
                                                  fontSize: 16,
                                                  color: Colors.grey[1000],
                                                  fontWeight: FontWeight.w400))
                                          : Container(),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ));
          },
        ));
  }
}
