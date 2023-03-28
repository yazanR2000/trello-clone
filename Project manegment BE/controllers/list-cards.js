const ListCards = require("../models/list-cards");
const CardMembers = require("../models/card-members");
const CardComments = require("../models/card-comments");
const User = require("../models/user");
const io = require("../socket");
const { Op } = require("sequelize");

exports.getListCards = (req, res, next) => {
  ListCards.findAll({
    where: {
      boardlistId: req.params.listId,
    },
  })
    .then((result) => {})
    .catch((err) => {});
};

exports.editCard = (req, res, next) => {
  let updatedObject = {
    label: req.body.label,
    content: req.body.content,
    dueDate: req.body.dueDate,
    boardListId: req.body.boardListId,
  };
  ListCards.update(updatedObject, {
    where: {
      boardListId: updatedObject.boardListId,
    },
  })
    .then((result) => {})
    .catch((err) => {});
};

exports.deleteCard = (req, res, next) => {
  console.log(req.params);
  ListCards.destroy({
    where: {
      id: req.params.cardId,
    },
  })
    .then((result) => {
      console.log(result);
      io.getIO().emit("deleteCard", {
        cardId: req.params.cardId,
        listId: req.params.listId,
        // listId:
      });
      res.status(200);
    })
    .catch((err) => {
      console.log(err);
    });
};

exports.addCardMembers = (req, res, next) => {
  CardMembers.create({
    userId: req.body.userId,
  })
    .then((result) => {})
    .catch((err) => {});
};

exports.deleteCardMember = (req, res, next) => {
  CardMembers.destroy({
    where: {
      userId: req.body.userId,
    },
  })
    .then((result) => {})
    .catch((err) => {});
};

exports.getCardComments = (req, res, next) => {
  CardComments.findAll({
    where: {
      listcardId: req.params.listcardId,
    },
  })
    .then((result) => {})
    .catch((err) => {});
};

exports.moveCard = (req, res, next) => {
  console.log(req.body);
  ListCards.update(
    { boardslistId: req.body.newBoardListId },
    {
      where: {
        boardslistId: req.body.oldBoardListId,
        id: req.body.cardId,
      },
    }
  )
    .then((result) => {
      console.log(result);
      io.getIO().emit("card", {
        action: "move",
        cardId: req.body.cardId,
        oldBoardListId: req.body.oldBoardListId,
        newBoardListId: req.body.newBoardListId,
      });
      res.status(200).json({
        msg: "Card moved successfully",
        data: result,
      });
    })
    .catch((err) => {
      console.log(err);
    });
};

exports.addNewCard = (req, res, next) => {
  console.log(req.body);

  var cardMembers = req.body.cardMembers;

  ListCards.create({
    label: req.body.label,
    dueDate: req.body.dueDate,
    content: req.body.content,
    boardslistId: req.body.boardslistId,
    boardId: req.body.boardId,
  })
    .then((listCardResult) => {
      // console.log(result.id);

      cardMembers = cardMembers.map((user) => {
        return {
          userId: user.id,
          listcardId: listCardResult.id,
        };
      });
      CardMembers.bulkCreate(cardMembers)
        .then((cardMembersResult) => {
          io.getIO().emit("newCard", listCardResult);
          res.status(200);
        })
        .catch((err) => {});
    })
    .catch((err) => {
      console.log(err);
    });
};

exports.moveAllCardsToList = (req, res, next) => {
  ListCards.update(
    { boardslistId: req.body.listId },
    {
      where: {
        boardId: req.body.boardId,
        id: {
          [Op.ne]: null,
        },
      },
    }
  )
    .then((result) => {
      console.log(result);
      res.status(200).json({ msg: "success" });
    })
    .catch((err) => {
      console.log(err);
    });
};

exports.getCardMembers = (req, res, next) => {
  CardMembers.findAll({
    include: User,
    where: {
      listcardId: req.params.cardId,
    },
  })
    .then((result) => {
      res.status(200).json({
        msg: "Success",
        data: result
      });
    })
    .catch((err) => {});
};
