const Sequelize = require("sequelize");

const sequelize = require("../util/database");

const Board = sequelize.define("boards", {
    id: {
        type: Sequelize.INTEGER,
        autoIncrement: true,
        allowNull: false,
        primaryKey: true
    },
    name: Sequelize.STRING,
});

module.exports = Board;
