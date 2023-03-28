const Sequelize = require("sequelize");

const sequelize = require("../util/database");

const BoardLists = sequelize.define("boardslists", {
  id: {
    type: Sequelize.INTEGER,
    autoIncrement: true,
    allowNull: false,
    primaryKey: true,
  },
  name: { type: Sequelize.STRING},
});

module.exports = BoardLists;
