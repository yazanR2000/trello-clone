import 'dart:convert';

import 'package:app/view_model/auth_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../res/constants.dart';
import 'package:http/http.dart' as http;

class ProjectModel {
  // Users
  static Future getAllUsers() async {
    final url = Uri.http(Constants.baseUrl, '/user/all');
    return await http.get(url);
  }

  // Board routes
  static Future getBoardData(String boardId) async {
    return await Future.wait([
      getBoardMembers(boardId),
      getBoardLists(boardId),
      getBoardCards(boardId),
    ]);
  }

  static Future getBoardMembers(String boardId) async {
    final url = Uri.http(Constants.baseUrl, '/board/board-members/$boardId');
    return await http.get(url);
  }

  static Future addBoardMembers(List<Map<String,dynamic>> users) async {
    final url = Uri.http(Constants.baseUrl, '/board-members/add');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "users": users
      })
    );
  }

  static Future getBoardLists(String boardId) async {
    final url = Uri.http(Constants.baseUrl, '/board/board-lists/$boardId');
    return await http.get(url);
  }

  static Future getBoardCards(String boardId) async {
    final url = Uri.http(Constants.baseUrl, '/board/board-cards/$boardId');
    return await http.get(url);
  }

  static Future getListCards() async {}

  // Board list routes
  static Future addBoardList(String name, int boardId) async {
    final url = Uri.http(Constants.baseUrl, '/board/create-new-list');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        {"name": name, "boardId": boardId},
      ),
    );
  }

  static Future deleteBoardList() async {}
  static Future editBoardList() async {}

  // List Card routes
  static Future deleteCardList(int cardId, int listId) async {
    final url =
        Uri.http(Constants.baseUrl, '/board-lists/delete-card/$listId/$cardId');
    return await http.delete(url);
  }

  static Future editCardList() async {}
  static Future getCardMembers(int cardId) async {
    final url =
        Uri.http(Constants.baseUrl, '/board-lists/card-members/$cardId');
    return await http.get(url);
  }
  static Future addListCard(
      String content,
      String label,
      String dueDate,
      int boardListId,
      int boardId,
      List<Map<String, dynamic>> cardMembers) async {
    print(DateTime.parse(dueDate).toLocal().toIso8601String());
    final url = Uri.http(Constants.baseUrl, '/board-lists/add-card');
    return await http.post(
      url,
      body: json.encode({
        "content": content,
        "label": label,
        "dueDate": DateTime.parse(dueDate).toIso8601String(),
        "boardslistId": boardListId,
        "boardId": boardId,
        "cardMembers": cardMembers
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }

  static Future addCardMember() async {}
  static Future getCardAttachments() async {}
  static Future getCardComments() async {}
  static Future moveCardToNewList(
      int newBoardListId, int oldBoardListId, int cardId) async {
    // print(newBoardListId);
    // print(oldBoardListId);
    final url = Uri.http(Constants.baseUrl, '/board-lists/move');
    return await http.post(
      url,
      body: json.encode({
        "newBoardListId": newBoardListId,
        "oldBoardListId": oldBoardListId,
        "cardId": cardId
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }

  static Future moveAllCardsToThisList(int listId, int boardId) async {
    final url = Uri.http(Constants.baseUrl, '/board-lists/move-all-cards');
    return await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        {"listId": listId, "boardId": boardId},
      ),
    );
  }

  static Future getUserCards(int userId, int boardId) async {
    final url = Uri.http(Constants.baseUrl, '/user/cards/$boardId/$userId');
    return await http.get(url);
  }

  // Activity routes
  static Future getRecentActivity() async {}
}
