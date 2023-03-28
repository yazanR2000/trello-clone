const BoardMembers = require("../models/board-members");

exports.addBoardMembers = (req, res, next) => {
  const boardId = req.body.boardId;
  const userId = req.body.userId;
  const role = req.body.role;
  BoardMembers.bulkCreate(req.body.users)
    .then((result) => {
      res.status(200).json({ msg: "Success" });
    })
    .catch((err) => {});
};

exports.deleteBoardMember = (req, res, next) => {
  BoardMembers.destroy({
    where: {
      userId: req.body.userId,
      boardId: req.body.boardId,
    },
  })
    .then((result) => {})
    .catch((err) => {});
};

exports.editBoardMember = (req, res, nex) => {
  const boardId = req.body.boardId;
  const userId = req.body.userId;
  const role = req.body.role;
  BoardMembers.update(
    {
      userBoardRole: role,
    },
    {
      where: {
        userId: userId,
        boardId: boardId,
      },
    }
  )
    .then((result) => {})
    .catch((err) => {});
};
