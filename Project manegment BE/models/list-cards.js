const Sequelize = require("sequelize");

const sequelize = require("../util/database");

const ListCards = sequelize.define("listcards", {
    id: {
        type: Sequelize.INTEGER,
        autoIncrement: true,
        allowNull: false,
        primaryKey: true
    },
    label: Sequelize.STRING,
    dueDate: Sequelize.STRING,
    content: Sequelize.TEXT
});

module.exports = ListCards;
