const BoardMembers = require("../models/board-members");
const BoardLists = require("../models/board-lists");
const ListCards = require("../models/list-cards");
const User = require("../models/user");
const io = require("../socket");

exports.getBoardMembers = (req, res, next) => {
  // console.log(req.params.boardId);
  BoardMembers.findAll({
    include: User,
    where: {
      boardId: req.params.boardId,
    },
  })
    .then((result) => {
      // console.log(result);
      res.status(200).json({
        msg: "success",
        data: result,
      });
    })
    .catch((err) => {
      console.log(err);
    });
};

exports.getBoardLists = (req, res, next) => {
  // console.log(req.params.boardId);
  BoardLists.findAll({
    where: {
      boardId: req.params.boardId,
    },
  })
    .then((result) => {
      // console.log(result);
      res.status(200).json({
        msg: "success",
        data: result,
      });
    })
    .catch((err) => {
      console.log(err);
    });
};

exports.createNewList = (req, res, next) => {
  console.log(req.body);
  BoardLists.create({
    name: req.body.name,
    boardId: req.body.boardId,
  })
    .then((result) => {
      console.log(result);
      io.getIO().emit("addList", {
        "id": result['id'],
        "name": result['name']
      });
      res.status(200).json({
        msg:"success"
      });
    })
    .catch((err) => {
      console.log(err)
    });
};

exports.deleteList = (req, res, next) => {
  BoardLists.destroy({
    where: {
      id: req.body.listId,
    },
  })
    .then((result) => {})
    .catch((err) => {});
};

exports.getBoardCards = (req, res, next) => {
  ListCards.findAll({ where: { boardId: req.params.boardId } })
    .then((result) => {
      res.status(200).json({
        msg: "success",
        data: result
      });
    })
    .catch((err) => {});
};
