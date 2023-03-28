const Sequelize = require("sequelize");

const sequelize = require("../util/database");

const CardMembers = sequelize.define("cardmembers", {
    id: {
        type: Sequelize.INTEGER,
        autoIncrement: true,
        allowNull: false,
        primaryKey: true
    },
    
},
);

module.exports = CardMembers;
