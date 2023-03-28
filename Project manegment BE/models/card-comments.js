const Sequelize = require("sequelize");

const sequelize = require("../util/database");

const CardComments = sequelize.define("cardcomments", {
    id: {
        type: Sequelize.INTEGER,
        autoIncrement: true,
        allowNull: false,
        primaryKey: true
    },
    comment: Sequelize.STRING,
});

module.exports = CardComments;
