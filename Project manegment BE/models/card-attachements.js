const Sequelize = require("sequelize");

const sequelize = require("../util/database");

const CardAttechements = sequelize.define("cardattechements", {
    id: {
        type: Sequelize.INTEGER,
        autoIncrement: true,
        allowNull: false,
        primaryKey: true
    },
    attachement: Sequelize.STRING,
    type: Sequelize.STRING,
});

module.exports = CardAttechements;
