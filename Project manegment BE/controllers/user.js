const User = require("../models/user");
const bcrypt = require("bcryptjs");
const Board = require("../models/board");
const BoardMembers = require("../models/board-members");
const CardMembers = require("../models/card-members");

exports.login = (req, res, next) => {
  const email = req.body.email;
  const password = req.body.password;
  console.log(req.body);
  User.findOne({
    where: {
      email: email,
    },
    attributes: ["id", "name", "email", "role", "password"],
  })
    .then((user) => {
      console.log(user);
      bcrypt
        .compare(password, user.password)
        .then((doMatch) => {
          if (doMatch) {
            return res.status(200).json({
              msg: "Auth success",
              data: {
                id: user.id,
                name: user.name,
                email: user.email,
                role: user.role,
              },
            });
          }
        })
        .catch((err) => {
          console.log(err);
        });
    })
    .catch((err) => {
      console.log(err);
    });
};

exports.signup = (req, res, next) => {
  const email = req.body.email;
  const password = req.body.password;
  const name = req.body.name;
  const role = req.body.role;
  // const role = req.body.role;
  User.findOne({
    where: {
      email: email,
    },
    attributes: ["id", "name", "email", "role"],
  })
    .then((user) => {
      if (!user) {
        return bcrypt.hash(password, 12).then((hashPassword) => {
          User.create({
            email: email,
            password: hashPassword,
            name: name,
            role: role,
          })
            .then((newUser) => {
              return res.status(200).json({
                msg: "Signup successfully",
                data: {
                  id: newUser.id,
                  name: newUser.name,
                  email: newUser.email,
                  role: newUser.role,
                },
              });
            })
            .catch((err) => {});
        });
      } else {
        return res.status(404).json({ msg: "User already exist" });
      }
    })
    .catch((err) => {});
};

exports.createBoard = (req, res, next) => {
  Board.create({
    name: req.body.name,
    userId: req.body.userId,
  })
    .then((result) => {})
    .catch((err) => {});
};
exports.getMyBoards = (req, res, next) => {
  const userId = req.body.userId;
  const role = req.body.role;

  if (role !== "Admin") {
    BoardMembers.findAll({
      where: {
        userId: userId,
      },
    })
      .then((result) => {})
      .catch((err) => {});
  } else {
    BoardMembers.findAll()
      .then((result) => {})
      .catch((err) => {});
  }
};

exports.getAllUsers = (req, res, next) => {
  User.findAll()
    .then((result) => {
      res.status(200).json(result);
    })
    .catch((err) => {});
};

exports.getMyCards = (req, res, next) => {
  CardMembers.findAll({
    where: {
      userId: req.params.userId,
    },
  })
    .then((result) => {
      res.status(200).json(result);
    })
    .catch((err) => {});
};
