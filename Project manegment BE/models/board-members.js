const Sequelize = require("sequelize");

const sequelize = require("../util/database");

const BoardMembers = sequelize.define("boardmembers", {
  id: {
    type: Sequelize.INTEGER,
    autoIncrement: true,
    allowNull: false,
    primaryKey: true,
  },
  userBoardRole: {
    type: Sequelize.STRING,
    allowNull:false,
    defaultValue: "Observer"
  },
});

module.exports = BoardMembers;
