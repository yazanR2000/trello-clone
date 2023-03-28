import 'dart:convert';

import 'package:app/models/project_model.dart';
import 'package:app/res/components.dart';
import 'package:app/view_model/home_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../res/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ProjectViewModel with ChangeNotifier {
  String? boardId = '1';
  bool? newFetch = true;
  bool? fetchMembers = true;

  List<dynamic>? boardMembers = [];
  List<Map<String, dynamic>> boardLists = [];
  List<dynamic>? boardCards;

  bool isLoading = true;

  void changeLoading() {
    isLoading = !isLoading;
    newFetch = false;
    // print(isLoading);
    notifyListeners();
  }

  set BoardId(String? value) {
    boardId = value;
    notifyListeners();
  }

  Future getBoardData() async {
    isLoading = true;
    boardLists.clear();
    notifyListeners();
    //return Future.delayed(Duration(seconds: 3)).then((value) => changeLoading());
    print("yazan");
    final response = await ProjectModel.getBoardData(boardId!);
    final members = json.decode(response[0].body);
    final lists = json.decode(response[1].body);
    final cards = json.decode(response[2].body);

    lists['data'].forEach((list) {
      boardLists.add({
        "id": list['id'],
        "name": list['name'],
        "cards": [],
        "cardMembers": []
      });
    });
    members['data'].forEach((user) {
      boardMembers!.add(user['user']);
    });
    // print(boardMembers);

    cards['data'].forEach((card) {
      int index = boardLists
          .indexWhere((element) => element['id'] == card['boardslistId']);
      boardLists[index]['cards'].add(card);
    });

    IO.Socket socket = IO.io('http://${Constants.baseUrl}', {
      'autoConnect': false,
      'transports': ['websocket'],
    });
    socket.connect();
    socket.onConnect((_) {
      print('connected');
      //socket.emit('msg', 'test');
    });
    socketOnCard(socket);
    socketOnNewCard(socket);
    socketOnDeleteCard(socket);
    socketOnAddList(socket);

    //print(boardLists);
    changeLoading();
  }

  Future addBoardMembers(
      List<Map<String, dynamic>> users, BuildContext context) async {
    try {
      await ProjectModel.addBoardMembers(users);
      Provider.of<HomeViewModel>(context, listen: false).setPageIndex = 0;
      Components.showErrorSnackBar(
        context,
        text: "Members added successfully!",
      );
    } catch (err) {
      Components.showErrorSnackBar(
        context,
        text: "$err",
      );
    }
  }

  Future moveAllCardsToThisList(int listId) async {
    try {
      final response = await ProjectModel.moveAllCardsToThisList(
          listId, int.parse(boardId!));
      print(response.body);
      final List<Map<String, dynamic>> allCards = [];
      boardLists.forEach((list) {
        for (int i = 0; i < list['cards'].length;) {
          allCards.add(list['cards'][i]);
          list['cards'].removeAt(i);
        }
      });
      int index = boardLists.indexWhere(
          (element) => element['id'].toString() == listId.toString());
      boardLists[index]['cards'] = allCards;
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  Future getBoardMembers() async {
    try {
      final response = await ProjectModel.getBoardMembers(boardId!).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          print("Timeout");
          throw 'no internet please connect to internet';
        },
      );
    } catch (err) {
      print(err);
    }
  }

  Future getBoardLists() async {
    try {
      final response = await ProjectModel.getBoardLists(boardId!).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          print("Timeout");
          throw 'no internet please connect to internet';
        },
      );
      boardLists = response['data'];
    } catch (err) {}
  }

  Future moveCardToNewList(
      int newBoardListId, int oldBoardListId, int cardId) async {
    // print(newBoardListId);
    // print(oldBoardListId);
    try {
      final response = await ProjectModel.moveCardToNewList(
          newBoardListId, oldBoardListId, cardId);
      //print(response.body);
    } catch (err) {
      print(err);
    }
  }

  Future addListCard(String content, String label, String dueDate,
      List<Map<String, dynamic>> cardMembers, BuildContext context) async {
    try {
      final response = await ProjectModel.addListCard(content, label, dueDate,
          boardLists[0]['id'], int.parse(boardId!), cardMembers);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Card added successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (err) {
      print(err);
    }
  }

  Future deleteCard(int cardId, int listId) async {
    try {
      final response = await ProjectModel.deleteCardList(cardId, listId);
    } catch (err) {}
  }

  Future addNewList(String name) async {
    try {
      final response =
          await ProjectModel.addBoardList(name, int.parse(boardId!));
    } catch (err) {}
  }

  Future getAllUsers() async {
    try {
      final response = await ProjectModel.getAllUsers();
      return json.decode(response.body);
    } catch (err) {}
  }

  Future getCardMembers(int cardId) async {
    if (fetchMembers!) {
      try {
        final response = await ProjectModel.getCardMembers(cardId);
        return json.decode(response.body);
      } catch (err) {
        print(err);
      }
    }
  }

  void socketOnCard(IO.Socket socket) {
    socket.on('card', (data) {
      //print(data);
      int oldListIndex = boardLists
          .indexWhere((element) => element['id'] == data['oldBoardListId']);
      // print("oldListIndex: $oldListIndex");
      int cardIndex = boardLists[oldListIndex]['cards']
          .indexWhere((card) => card['id'] == data['cardId']);
      // print("cardIndex: $cardIndex");
      Map<String, dynamic> card = boardLists[oldListIndex]['cards'][cardIndex];
      // print("card: $card");
      boardLists[oldListIndex]['cards'].removeAt(cardIndex);

      int newListIndex = boardLists
          .indexWhere((element) => element['id'] == data['newBoardListId']);
      // print("newListIndex: $newListIndex");

      boardLists[newListIndex]['cards'].add(card);

      // print(boardLists);
      notifyListeners();
    });
  }

  void socketOnNewCard(IO.Socket socket) {
    socket.on('newCard', (data) {
      //print(data);
      int boardListId = boardLists
          .indexWhere((element) => element['id'] == data['boardslistId']);
      boardLists[boardListId]['cards'].add(data);
      notifyListeners();
    });
  }

  void socketOnDeleteCard(IO.Socket socket) {
    socket.on('deleteCard', (data) {
      int listIndex = boardLists.indexWhere(
          (element) => element['id'].toString() == data['listId'].toString());
      boardLists[listIndex]['cards'].removeWhere(
          (card) => card['id'].toString() == data['cardId'].toString());
      notifyListeners();
    });
  }

  void socketOnAddList(IO.Socket socket) {
    socket.on("addList", (data) {
      //print(data);
      boardLists.add({"id": data['id'], "name": data['name'], "cards": []});
      notifyListeners();
    });
  }
}
