const Sequelize = require("sequelize");

const sequelize = require("../util/database");

const RecentActivity = sequelize.define("recentactivity", {
    id: {
        type: Sequelize.INTEGER,
        autoIncrement: true,
        allowNull: false,
        primaryKey: true
    },
    content: Sequelize.STRING,
    user_id: Sequelize.INTEGER,
    card_id: Sequelize.INTEGER,
});

module.exports = RecentActivity;
